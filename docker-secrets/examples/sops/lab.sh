#!/bin/sh
# Encrypted files in git with SOPS and age: who can decrypt what, what
# removing a recipient changes, and what it cannot change.
# Works in ./work (recreated each run) and caches pinned tools in ./.bin.
# Needs: curl, git, sha256sum, tar; Linux amd64 or arm64.
set -eu
cd "$(dirname "$0")"
here=$(pwd)

SOPS_VERSION=v3.13.3
AGE_VERSION=v1.3.2
case "$(uname -m)" in
    x86_64)  arch=amd64
             sops_sha=e5bec3346a873ae91d871550f3e698c1aad962aff462a080e40f25fde17fef6b
             age_sha=cbe24006683f8eb669266162894b9a522a1af52f2665fbc63a4bb032ed26ac10 ;;
    aarch64) arch=arm64
             sops_sha=53b0abacd38ef1b12a66d6c100956691b9cefce018d91f81e73ddf7438b94d77
             age_sha=6b8dc4333c53a5a57c9e5834e3a48f92605d7154014cd07269ff3327db5d37f4 ;;
    *) echo "unsupported architecture" >&2; exit 1 ;;
esac

step() { printf '\n=== %s\n' "$*"; }

if [ ! -x .bin/sops ] || [ ! -x .bin/age-keygen ]; then
    mkdir -p .bin/dl
    curl -fsSLo .bin/dl/sops "https://github.com/getsops/sops/releases/download/$SOPS_VERSION/sops-$SOPS_VERSION.linux.$arch"
    curl -fsSLo .bin/dl/age.tgz "https://github.com/FiloSottile/age/releases/download/$AGE_VERSION/age-$AGE_VERSION-linux-$arch.tar.gz"
    printf '%s  %s\n%s  %s\n' "$sops_sha" .bin/dl/sops "$age_sha" .bin/dl/age.tgz | sha256sum -c -
    tar -xzf .bin/dl/age.tgz -C .bin/dl
    install -m 755 .bin/dl/sops .bin/dl/age/age .bin/dl/age/age-keygen .bin/
    rm -rf .bin/dl
fi
export PATH="$here/.bin:$PATH"
sops --version 2>&1 | head -1
age --version

rm -rf work && mkdir work && cd work
git init -q -b main . && git config user.email lab@example.invalid && git config user.name lab

step "1. Three identities: a person, a CI runner, a production host"
for who in alice ci web1; do
    age-keygen -o "$who.key" 2>/dev/null
    eval "$who=\$(age-keygen -y $who.key)"
done
printf '*.key\n' > .gitignore
echo "alice=$alice"

cat > .sops.yaml <<EOF
creation_rules:
  - path_regex: prod/.*
    age: $alice,$web1
  - path_regex: dev/.*
    age: $alice,$ci
EOF

step "2. Encrypt a production env file; keys stay readable, values do not"
mkdir prod dev
printf 'DB_USER=app\nDB_PASSWORD=LAB-PROD-PW-1\n' > prod/app.env
sops encrypt -i prod/app.env
grep -E '^DB_|^sops_mac' prod/app.env | cut -c1-60
git add -A && git commit -qm "prod secrets, alice and web1" && echo committed

step "3. Who can decrypt"
for who in web1 ci; do
    if SOPS_AGE_KEY_FILE=$who.key sops decrypt prod/app.env >/dev/null 2>&1
    then echo "$who: can decrypt prod"; else echo "$who: cannot decrypt prod"; fi
done

step "4. Alice leaves: remove her as a recipient and commit"
sed -i "s/age: $alice,$web1/age: $web1/" .sops.yaml
SOPS_AGE_KEY_FILE=web1.key sops updatekeys -y prod/app.env 2>&1 | tail -1
git commit -qam "remove alice from prod" && echo committed
try_alice() {
    if out=$(SOPS_AGE_KEY_FILE=alice.key sops decrypt "$1" 2>/dev/null)
    then echo "alice reads $2: $(echo "$out" | grep DB_PASSWORD)"
    else echo "alice: cannot decrypt $2"; fi
}
try_alice prod/app.env "HEAD"
git show HEAD~1:prod/app.env > /tmp/old.env.$$
mv /tmp/old.env.$$ old.env
try_alice old.env "HEAD~1 (from history)"

step "5. Rotate the data key too; history is unchanged"
SOPS_AGE_KEY_FILE=web1.key sops rotate -i prod/app.env
git commit -qam "rotate data key" && echo committed
try_alice prod/app.env "HEAD after rotate"
try_alice old.env "HEAD~2 (from history)"

step "6. Tampering is detected"
sed 's/^DB_USER=/DB_ADMIN=/' prod/app.env > tampered.env
SOPS_AGE_KEY_FILE=web1.key sops decrypt --input-type dotenv tampered.env 2>&1 | tail -1

step "7. Deliver to a consumer without a plaintext file in the repo"
SOPS_AGE_KEY_FILE=web1.key sops exec-env prod/app.env \
    'echo "child sees DB_PASSWORD of length ${#DB_PASSWORD}"'
(umask 077; SOPS_AGE_KEY_FILE=web1.key sops decrypt --extract '["DB_PASSWORD"]' \
    prod/app.env > db_password)
ls -l db_password | cut -c1-10
echo "git status of plaintext: $(git status --porcelain db_password)"
echo done
