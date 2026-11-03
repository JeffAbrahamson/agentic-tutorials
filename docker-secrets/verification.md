# Verification record

Date: 21 October 2026.

**Docker.** The labs ran on Docker Engine 29.9.1 with Compose v5.6.0 and Buildx v0.38.0. The daemon was a disposable `docker:29.9.1-dind` container using the containerd image store. Its host ran Engine 27.2.0 on Linux amd64. The target is the 29.9 series. 29.9.2 was released on 20 October but was not yet published as a `dind` image.

**Images:**
- `postgres:18-alpine` (PostgreSQL 18.6, `sha256:77f58511…`)
- `alpine:3.24` (`sha256:294b683c…`)
- `openbao/openbao:2.7.1` (`sha256:6d2b9385…`)

**Lab 3 tools.** SOPS 3.13.3 and age 1.3.2 ran directly on the host. Release binaries were checked against published SHA-256 digests. Git 2.43.0 and Python 3.12.3 were also on the host.

Sources are linked beside claims in the tutorial.

## Lab 1: leaks (`examples/leaks/lab.sh`)

| Step | Observation |
| --- | --- |
| `docker build --check` on the leaky Dockerfile | Two `SecretsUsedInArgOrEnv` warnings |
| History of `lab-leaky` | `ARG NPM_TOKEN=…`, `ENV DB_PASSWORD=…`, and the token on both later `RUN` lines, including the `rm` line |
| `Config.Env` of `lab-leaky` | Contains `DB_PASSWORD` |
| Layer scan of `docker save` output | Token and password in the configuration blob; the key file in the `COPY` layer |
| `lab-fixed`, all three checks | No marker found |
| `docker run -e` | Value in `docker inspect`, `/proc/1/environ` and a child process's environ |

## Lab 2: Compose secrets (`examples/compose/lab.sh`)

| Step | Observation |
| --- | --- |
| `docker compose config` | Printed the interpolated `LEGACY_API_KEY` value; for secrets only the file path and variable name |
| Warnings | Compose warned that `uid`, `gid` and `mode` are "not supported outside Swarm mode and will be ignored", for the environment-sourced secret |
| Host file 0600, owner root | `db` started; non-root `app` (UID 70) got `Permission denied`; login failed |
| Host file 0444 in a 0700 directory | Both worked |
| Mounts | `db_password` was a read-only bind mount. `api_key` was `-r-------- 70 70`, so `uid`, `gid` and `mode` were honoured despite the warning |
| `docker commit` of `app` | Image contained `api_key` with its value; `db_password` was an empty mount point |
| Atomic replace of host file | Container saw the old value; also after `up -d`; new value after `restart app` |
| Login after file change | Failed, also after recreating both containers. PostgreSQL kept the password set at initialisation |
| `ALTER ROLE` to new value | Login succeeded |

An earlier draft of this lab had `app` as root and `mode: 0440` without `uid`/`gid`. It showed two things:
- With `app` as root, the root-only file did not fail for `db`, because the PostgreSQL entrypoint reads `*_FILE` as root before `gosu`.
- Without `uid`/`gid`, the environment-sourced secret was `0:0 0440` and unreadable by UID 70.

The entrypoint exports `POSTGRES_PASSWORD` during initialisation and unsets `POSTGRES_*` before starting the server. This was read from the image's `/usr/local/bin/docker-entrypoint.sh`, around line 381.

## Lab 3: SOPS and age (`examples/sops/lab.sh`)

| Step | Observation |
| --- | --- |
| Encrypt dotenv | Keys in clear, all values `ENC[AES256_GCM,…]` |
| Decrypt | `web1` could; `ci` could not |
| Remove `alice`, `updatekeys`, commit | `alice` could not decrypt HEAD; could decrypt HEAD~1 from history |
| `rotate`, commit | Same: HEAD closed to `alice`, HEAD~2 readable with unchanged value |
| Rename a key in ciphertext | `cipher: message authentication failed` |
| `exec-env` | Child saw `DB_PASSWORD` |
| `decrypt --extract` to a file | Mode `-rw-------`; reported by `git status` as untracked |
| Decrypt with a non-recipient key (separate check) | "Failed to get the data key required to decrypt the SOPS file." |

The source of SOPS 3.13.3 (`sops.go`, `Tree.Encrypt`) passes each value's key path as GCM additional data. This was read in the source, not taken from the documentation.

## Lab 4: OpenBao (`examples/openbao/lab.sh`)

| Step | Observation |
| --- | --- |
| Server | `Sealed false`, `Version 2.7.1`, `Storage Type inmem` (dev mode) |
| `rotate-root` | Original admin password rejected over TCP afterwards |
| Two reads of `database/creds/app` | Two distinct `v-token-app-…` roles, `VALID UNTIL` 40 s ahead |
| AppRole token | Could read creds; `permission denied` on `database/config/labdb` |
| Agent and app | `db.env` rendered `-r-------- 70 70` on tmpfs volume; app connected as `v-approle-app-…` |
| `lease revoke -prefix` | Dynamic roles left: 0; app login failed with `FATAL: password authentication failed for user "v-approle-app-…"` |
| After revocation | Agent rendered a new credential after about 30 s in every run; app connected as a new user |
| Audit response entry | `path`, `display_name` (`approle`), `remote_address` in clear; `username` and `password` as `hmac-sha256:…`. Per-role attribution fields were not extracted |

**Problems hit while building the lab:**
- `bao audit enable file …` failed with "cannot enable audit device via API; use declarative, config-based audit device management instead". The OpenBao changelog for 2.3.2 explains the change. The lab now declares the device in `server.hcl`.
- With the AppRole directory at mode 0700, owned by root, the non-root agent logged "no known role ID" and never rendered the file.
- A loopback login check passed with the old admin password because the image trusts loopback. The check now connects through the service name.

**Open-session check.** This was run separately on the same stack. A `psql` session was opened with a dynamic credential. The lease was then revoked, which dropped the role. The open session still answered `select 2` afterwards.

## Exercise 3

Run on the same daemon with the exercise's files.

| Item | Value |
| --- | --- |
| `DATABASE_URL` | `postgres://api:s3cret@db/api` |
| `LOG_LEVEL` | `info` |
| `DB_PASSWORD` | `other` |
| `docker compose config` | Printed both `DATABASE_URL` with `s3cret` and `DB_PASSWORD: other` |

## Reading primer, 3 November 2026

Chapter 1's Docker and Compose examples ran on Engine 29.9.2 with Compose 5.6.1 in a disposable `docker:29.9.2-dind` container. The `age` and SOPS commands ran on the host with the lab's checksum-verified binaries, and the OpenBao commands in an `openbao/openbao:2.7.1` dev-mode container. Observations:

- `hello` printed the output shown, and a command given to `docker run` replaced its `CMD`. With `ENTRYPOINT ["echo", "fixed"]` and `CMD ["default"]`, the three forms printed `fixed default`, `fixed changed` and `replaced`.
- The stored configuration showed `CMD sleep 30` as `["/bin/sh","-c","sleep 30"]` and the exec form unchanged. An `ENV` value was in `Config.Env` and an `ARG` was not. An `ARG` before `FROM` was empty inside the stage.
- `RUN false; echo` succeeded and `RUN false && echo` failed the build. The here-document forms of `RUN` and `COPY` ran, as did `--target`.
- `docker stop` on a process ignoring SIGTERM took about 10 seconds and gave `Exited (137)`, as did `docker kill` at once. A missing command made `docker run` exit with 127. An image with `EXPOSE 80` showed `80/tcp` with no arrow.
- The Compose file ran as shown under a directory called `comp`, giving `comp-web-1`, `comp_default` and `comp_cache`; the chapter's `shop` names follow that pattern. The anchor merged, `probe` reached `http://web/`, and `probe` stayed out of a plain `up`.
- `${VAR}`, `:-`, `-`, `:+`, `:?` and `$$` behaved as tabled, including for an empty variable. A bare `- KEY` passed the shell's value through. `configs:` mounted its file at the target, and `tmpfs:` gave a tmpfs. `down` kept the named volume and `down -v` removed it. With both file names present, Compose warned and used `compose.yaml`; `compose.override.yaml` was merged.
- The SOPS excerpt is real output, shortened. Dotenv metadata lines and `--extract` were as shown. `ansible-vault encrypt_string` produced the `!vault` and `$ANSIBLE_VAULT;1.1;AES256` form.
- `bao kv get` printed the output shown, with `secret/data/app/db` as its path. A token under a policy on `secret/data/app/*` could read the value, and one under `secret/app/*` got `permission denied`. A token began `s.`. Decryption with the default key path was checked with SOPS 3.13.3.

**Not run in this form:** the `golang:1.25` stage fragment, which has no source to build (a two-stage build ran on Alpine, without `COPY --from`); the `--platform` flag; the `build:` and `networks:` settings, which `docker compose config` accepted but no build used; the `docker run -d … -p … -v` example, whose port and mount forms ran through Compose; a `Up … (healthy)` status, which appears only with a health check; the agent `template` excerpt, which is shortened from lab 4's working file; the Kubernetes Secret, whose form comes from the documentation. The `Up 2 hours` status is illustrative. The `hvs.` prefix and the git-crypt `.gitattributes` line come from HashiCorp's and git-crypt's documentation.

Exercise and answer links were followed in the PDF from each link annotation to the text at its destination: 12 links each way, all landing on the right heading.

On 3 November 2026, chapter and section numbers, the title, subtitle and date moved into the Markdown so that it reads on GitHub. Comparing the rebuilt PDF's text with the previous build showed only heading punctuation and consequent line breaks. All links were traced again and land on the right headings.

## Not verified

**Not run:**
- Swarm secrets
- Rootless mode
- Attestations and provenance contents
- Multi-platform builds and Bake
- Kubernetes and every tool in chapter 10, including exercise 10's update behaviour, which comes from the Kubernetes documentation
- HashiCorp Vault
- Cloud and SaaS managers
- OpenBao outside dev mode: storage, HA, unseal, response wrapping, and agent `exec`
- Ansible `community.sops`
- Flux
- gitleaks and TruffleHog
- The Dockerfile fragments in exercises 1 and 2, and the Compose fragments in chapter 4 and exercise 5. Exercise 5's outcome follows from lab 2 steps 2 and 4.

**Not confirmed:**
- SOPS support for age post-quantum recipients.
- AWS prices: read from the page's worked examples.
- Vault Secrets Operator licence: not checked, and not stated in the tutorial.
