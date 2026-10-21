#!/bin/sh
# Compose secrets without Swarm: what they expose, how they are mounted, and
# what a "rotation" by file replacement really changes.
# DESTROYS AND RECREATES the Compose project secrets-lab and its volumes.
set -u
cd "$(dirname "$0")"

step() { printf '\n=== %s\n' "$*"; }
dc() { docker compose "$@"; }
login() {   # try to log in from app with the password it can read
    dc exec -T app sh -c 'PGPASSWORD="$(cat /run/secrets/db_password)" \
        psql -h db -U postgres -tAc "select 1" >/dev/null 2>&1' \
        && echo "app login: ok" || echo "app login: FAILED"
}

dc down -v --remove-orphans >/dev/null 2>&1
rm -rf secrets && mkdir -m 700 secrets
(umask 077; printf 'LAB-DBPW-v1' > secrets/db_password)
printf 'LEGACY_API_KEY=LAB-LEGACY-11aa\n' > .env
export API_KEY=LAB-API-22bb

step "1. What 'docker compose config' prints"
dc config | grep -E 'LAB-|db_password|API_KEY' | sed 's/^/  /'

step "2. Start with the secret file at mode 0600 (owner: $(id -u))"
dc up -d --wait >/dev/null 2>&1 && echo "up --wait succeeded"
dc exec -T app cat /run/secrets/db_password
login

step "3. Make the file world-readable inside a 0700 directory, then retry"
chmod 0444 secrets/db_password
dc down -v >/dev/null 2>&1
dc up -d --wait >/dev/null 2>&1 && echo "up --wait succeeded"
login

step "4. How each secret reached the app container"
docker inspect -f '{{range .Mounts}}{{.Type}} {{.Source}} -> {{.Destination}} rw={{.RW}}{{"\n"}}{{end}}' \
    "$(dc ps -q app)" | grep /run/secrets
dc exec -T app ls -ln /run/secrets
echo "app reads api_key: $(dc exec -T app cat /run/secrets/api_key)"
docker commit "$(dc ps -q app)" lab-committed >/dev/null
echo "committed image, api_key: $(docker run --rm -u 0 lab-committed cat /run/secrets/api_key)"
echo "committed image, db_password bytes: $(docker run --rm lab-committed sh -c 'wc -c < /run/secrets/db_password')"
docker image rm lab-committed >/dev/null
echo "LEGACY_API_KEY in inspect: $(docker inspect -f '{{json .Config.Env}}' "$(dc ps -q app)" | grep -o 'LAB-LEGACY-[a-z0-9]*')"

step "5. 'Rotate' by atomically replacing the host file"
(umask 022; printf 'LAB-DBPW-v2' > secrets/db_password.new)
mv secrets/db_password.new secrets/db_password
echo "app sees: $(dc exec -T app cat /run/secrets/db_password)"
dc up -d --wait >/dev/null 2>&1
echo "after 'up -d': $(dc exec -T app cat /run/secrets/db_password)"
dc restart app >/dev/null 2>&1
echo "after 'restart app': $(dc exec -T app cat /run/secrets/db_password)"
login
dc up -d --wait --force-recreate >/dev/null 2>&1
echo "after recreating both: db container reads $(dc exec -T db cat /run/secrets/db_password)"
login

step "6. Rotate the credential itself, then deliver it"
dc exec -T db psql -U postgres -tAc "ALTER ROLE postgres PASSWORD 'LAB-DBPW-v2'"
login

step "Clean up"
dc down -v >/dev/null 2>&1
rm -rf secrets .env
echo done
