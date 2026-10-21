#!/bin/sh
# A central secret service: dynamic database credentials, policy, an agent
# that renders them, revocation, expiry and audit.
# DESTROYS AND RECREATES the Compose project openbao-lab. Takes about two
# minutes, mostly waiting for a credential to expire.
set -u
cd "$(dirname "$0")"

step() { printf '\n=== %s\n' "$*"; }
dc() { docker compose "$@"; }
bao() { dc exec -T -e BAO_TOKEN="${TOKEN:-lab-root-token}" bao bao "$@"; }
psql_admin() { dc exec -T db psql -U postgres -tAc "$1"; }
app_login() {
    dc exec -T app sh -c 'set -a; . /run/app/db.env; psql -h db -d postgres -tAc "select current_user"' 2>&1 \
        | tail -1 | sed 's/^/app connects as: /'
}

dc --profile app down -v --remove-orphans >/dev/null 2>&1
rm -rf work && mkdir -m 700 work && mkdir -m 755 work/approle
(umask 077; printf 'LAB-ADMIN-PW' > work/db_admin)   # 0600 is enough: the db entrypoint reads it as root

step "1. Start PostgreSQL and a dev-mode OpenBao"
dc up -d --wait db >/dev/null 2>&1 && dc up -d bao >/dev/null 2>&1
for i in $(seq 1 60); do bao status >/dev/null 2>&1 && break; sleep 1; done
bao status | grep -E '^(Sealed|Version|Storage Type)'

step "2. Configure the database secrets engine"
bao secrets enable database >/dev/null
bao write database/config/labdb plugin_name=postgresql-database-plugin \
    connection_url='postgresql://{{username}}:{{password}}@db:5432/postgres?sslmode=disable' \
    allowed_roles=app username=postgres password=LAB-ADMIN-PW >/dev/null
bao write database/roles/app db_name=labdb default_ttl=40s max_ttl=80s \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT pg_read_all_data TO \"{{name}}\";" >/dev/null
bao write -f database/rotate-root/labdb >/dev/null && echo "root credential rotated"
dc exec -T -e PGPASSWORD=LAB-ADMIN-PW db psql -h db -U postgres -tAc 'select 1' >/dev/null 2>&1 \
    && echo "old admin password: still works" || echo "old admin password: rejected"

step "3. Each read creates a new database user"
for i in 1 2; do bao read -format=json database/creds/app \
    | grep -E '"(username|lease_duration)"' | tr -d ' ,' | tr '\n' ' '; echo; done
psql_admin "select rolname, rolvaliduntil from pg_roles where rolname like 'v-%'"

step "4. Policy and AppRole for the application"
printf 'path "database/creds/app" {\n  capabilities = ["read"]\n}\n' | bao policy write app - >/dev/null
bao auth enable approle >/dev/null
bao write auth/approle/role/app token_policies=app token_ttl=10m >/dev/null
bao read -field=role_id auth/approle/role/app/role-id > work/approle/role_id
bao write -f -field=secret_id auth/approle/role/app/secret-id > work/approle/secret_id
chmod 0444 work/approle/role_id work/approle/secret_id   # lab only, see tutorial
TOKEN=$(bao write -field=token auth/approle/login \
    role_id="$(cat work/approle/role_id)" secret_id="$(cat work/approle/secret_id)")
echo "app token can read creds: $(TOKEN=$TOKEN bao read -field=username database/creds/app)"
echo "app token reading config: $(TOKEN=$TOKEN bao read database/config/labdb 2>&1 | grep -o 'permission denied' | head -1)"
unset TOKEN

step "5. Start the agent and the application"
bao audit list | tail -n +3
dc --profile app up -d agent app >/dev/null 2>&1
for i in $(seq 1 60); do dc exec -T app test -s /run/app/db.env 2>/dev/null && break; sleep 1; done
dc exec -T app ls -ln /run/app
app_login

step "6. Revoke every credential issued for the role"
bao lease revoke -prefix database/creds/app 2>&1 | tail -1
psql_admin "select count(*) from pg_roles where rolname like 'v-%'" | sed 's/^/dynamic roles left: /'
app_login

step "7. Wait for the agent to replace the credential (max_ttl 80s)"
first=$(dc exec -T app sh -c '. /run/app/db.env; echo $PGUSER')
for i in $(seq 1 30); do
    sleep 5
    now=$(dc exec -T app sh -c '. /run/app/db.env; echo $PGUSER')
    [ "$now" != "$first" ] && { echo "re-rendered after about $((i * 5))s"; break; }
done
app_login

step "8. What the audit log recorded for one issued credential"
dc exec -T bao cat /tmp/audit.log \
    | grep -F '"type":"response"' | grep -F '"path":"database/creds/app"' | tail -1 \
    | grep -oE '"(path|remote_address|display_name)":"[^"]*"|"(username|password)":"[^"]{0,30}' | sort -u

step "Clean up"
dc --profile app down -v >/dev/null 2>&1
rm -rf work
echo done
