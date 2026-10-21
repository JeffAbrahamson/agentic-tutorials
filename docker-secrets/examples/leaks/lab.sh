#!/bin/sh
# Where secrets leak in a Docker build and run, and what the fixes change.
# Uses only lab marker values. Creates images lab-leaky and lab-fixed, a
# container lab-env, and the file deploy_key here; removes them at the end.
set -u
cd "$(dirname "$0")"

NPM=LAB-NPM-7f3a       # build-time token
DBPW=LAB-DBPW-5e1c     # baked ENV default (written in Dockerfile.leaky)
KEY=LAB-KEY-9b20       # content of a "private key" file
RUNPW=LAB-RUNPW-c4d8   # runtime password passed with -e

step() { printf '\n=== %s\n' "$*"; }
printf '%s\n' "$KEY" > deploy_key

step "1. Build checks on the leaky Dockerfile"
docker build --check -f Dockerfile.leaky . 2>&1 | grep -E 'SecretsUsedInArgOrEnv|Check complete' || true

step "2. Build both images"
NPM_TOKEN=$NPM docker build -q -t lab-leaky -f Dockerfile.leaky \
    --build-arg NPM_TOKEN . >/dev/null && echo "lab-leaky built"
NPM_TOKEN=$NPM docker build -q -t lab-fixed -f Dockerfile.fixed \
    --secret id=npm_token,env=NPM_TOKEN --secret id=deploy_key,src=deploy_key \
    . >/dev/null && echo "lab-fixed built"

for img in lab-leaky lab-fixed; do
    step "3. $img: history, config and layers"
    echo "history lines mentioning a marker:"
    docker history --no-trunc --format '{{.CreatedBy}}' "$img" \
        | grep -E "$NPM|$DBPW|$KEY" || echo "  (none)"
    echo "Config.Env: $(docker image inspect -f '{{json .Config.Env}}' "$img")"
    docker save "$img" | python3 scan_image.py "$NPM" "$DBPW" "$KEY"
done

step "4. A runtime secret passed with -e"
docker run -d --rm --name lab-env -e "DB_PASSWORD=$RUNPW" alpine:3.24 sleep 60 >/dev/null
echo "docker inspect: $(docker inspect -f '{{json .Config.Env}}' lab-env | grep -o "DB_PASSWORD=[^\"]*")"
echo "PID 1 environ: $(docker exec lab-env sh -c 'tr "\0" "\n" < /proc/1/environ' | grep DB_PASSWORD)"
echo "child process environ: $(docker exec lab-env sh -c 'sleep 2 & sleep 0.2; tr "\0" "\n" < /proc/$!/environ' | grep DB_PASSWORD)"

step "Clean up"
docker rm -f lab-env >/dev/null 2>&1
docker image rm lab-leaky lab-fixed >/dev/null
rm -f deploy_key
echo done
