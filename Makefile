.ONESHELL:
SHELL := /bin/bash
all: help

publish: bump-version ## publish on pypi
	uv build && uv publish && rm -r redisw.egg-info dist

bump-version:
	@version=$$(grep -Po '(?<=^version = ")[^"]*' pyproject.toml); \
	major=$$(echo $$version | cut -d. -f1); \
	minor=$$(echo $$version | cut -d. -f2); \
	patch=$$(echo $$version | cut -d. -f3); \
	new_patch=$$((patch + 1)); \
	new_version="$$major.$$minor.$$new_patch"; \
	sed -i "s/^version = \"$$version\"/version = \"$$new_version\"/" pyproject.toml; \
	echo "Version updated from $$version to $$new_version"

################################################################################
# HELP
help: ## print this help
	@grep '##' $(MAKEFILE_LIST) \
		| grep -Ev 'grep|###' \
		| sed -e 's/^\([^:]*\):[^#]*##\([^#]*\)$$/\1:\2/' \
		| awk -F ":" '{ printf "%-34s%s\n", "\033[1;32m" $$1 ":\033[0m", $$2 }' \
		| grep -v 'sed'
