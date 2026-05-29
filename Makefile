# Showcase Landscaping — build & deploy
#
# Toolchain: Node 8 (pinned in .nvmrc) + grunt-cli@1.3.2 installed globally.
# Run `nvm use` once in your shell before any target so the Node 8 grunt/npm are on PATH.

SHELL := /bin/bash
GRUNT := grunt

.PHONY: help install build serve deploy

help:
	@echo "make install   install dependencies (run 'nvm use' first)"
	@echo "make build     compile Jade -> HTML (grunt jade)"
	@echo "make serve     serve http://localhost:8001 and watch for jade changes"
	@echo "make deploy    publish committed master to the gh-pages production site"

install:
	npm install

build:
	$(GRUNT) jade

serve:
	$(GRUNT)

# Publish to production. GitHub Pages serves the gh-pages branch at showcaselandscapingsc.com.
# Model: master is the source of truth; gh-pages is a fast-forwarded mirror of master.
deploy:
	@[ "$$(git rev-parse --abbrev-ref HEAD)" = "master" ] || { echo "deploy: must be on master"; exit 1; }
	@git diff --quiet && git diff --cached --quiet || { echo "deploy: commit or stash your changes first"; exit 1; }
	$(GRUNT) jade
	@git diff --quiet || { echo "deploy: generated HTML was out of date ('make build' changed files); commit it and re-run"; exit 1; }
	git push origin master
	git push origin master:gh-pages
	@echo "Deployed -> http://showcaselandscapingsc.com/ (GitHub Pages rebuilds within ~1 min)"
