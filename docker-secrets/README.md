# Docker and secrets

The tutorial is [docker-secrets.pdf](docker-secrets.pdf), a 2–3 hour read with exercises and worked answers. Part 1 is a short tour of Docker beyond build and run: the image and container model, BuildKit, Compose, hardening and inspection. Part 2 is about secret management. It covers why a private repository is the wrong model for secrets, leak paths and secret mechanisms in Docker, encrypted files in git (SOPS, age, ansible-vault, git-crypt), secret services (OpenBao, Vault, cloud and SaaS managers), delivery and identity, Kubernetes as an optional branch, and choosing and migrating.

The source is [tutorial.md](tutorial.md). [brief.md](brief.md) and [outline.md](outline.md) record its scope and teaching assumptions. The tutorial targets Docker Engine 29.9 with Compose v5.6, SOPS 3.13.3 with age 1.3.2, and OpenBao 2.7.1.

## Build the PDF

You need GNU Make, Pandoc, XeLaTeX, and the Latin Modern Roman and Latin Modern Mono fonts. The TeX installation needs the packages used by Pandoc's default LaTeX template, plus `fvextra`, `microtype`, `ragged2e`, `etoolbox` and `needspace`. On Debian/Ubuntu, the usual packages are `make`, `pandoc`, `texlive-xetex`, `texlive-latex-extra`, `texlive-fonts-recommended` and `fonts-lmodern`.

From the repository root:

```sh
make -C docker-secrets
```

This produces `docker-secrets/docker-secrets.pdf`. It uses the same 160 × 230 mm layout and fonts as the other tutorials. Temporary files go in the ignored `.build/` directory.

## Labs

The labs live in `examples/`; [verification.md](verification.md) records what they showed. Three of them create and destroy Docker images, containers, volumes and the Compose projects `secrets-lab` and `openbao-lab`. Run those three against a disposable daemon rather than the one you work with. A Docker-in-Docker container is enough:

```sh
docker run -d --privileged --name dind -e DOCKER_TLS_CERTDIR= docker:29.9.1-dind
docker exec dind apk add -q python3      # lab 1 scans layers with Python
docker cp examples dind:/lab
docker exec dind sh /lab/leaks/lab.sh    # lab 1, chapters 1-2
docker exec dind sh /lab/compose/lab.sh  # lab 2, chapter 5
docker exec dind sh /lab/openbao/lab.sh  # lab 4, chapter 7 (about 2 minutes)
docker rm -f dind
```

Lab 3 (chapter 6) needs no Docker. It needs `curl`, `git`, `sha256sum` and `tar` on Linux amd64 or arm64:

```sh
examples/sops/lab.sh
```

It downloads SOPS and age into `examples/sops/.bin` and checks their SHA-256 digests. It works in `examples/sops/work`, which it recreates on each run.

Every secret in the labs is a lab-only marker value. The OpenBao server runs in dev mode, which is in memory, unsealed and uses a fixed root token, so never copy that configuration.
