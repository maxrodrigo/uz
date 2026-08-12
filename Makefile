# uz Makefile

TAP := https://github.com/maxrodrigo/homebrew-tap.git
VERSION ?= $(shell git describe --tags --abbrev=0 2>/dev/null)

.DEFAULT_GOAL := help

release: ## Tag, push, and update the Homebrew formula
	@git diff --exit-code --quiet || (echo "error: working tree is dirty" >&2 && exit 1)
	@printf "Version (vX.Y.Z): " && read -r ver && \
	git tag -a "$$ver" -m "$$ver" && \
	git push origin "$$ver" && \
	$(MAKE) brew VERSION="$$ver"

brew: ## Point the Homebrew formula at $(VERSION) (default: latest tag)
	@test -n "$(VERSION)" || (echo "error: no tag found, pass VERSION=vX.Y.Z" >&2 && exit 1)
	@tmp=$$(mktemp -d) && \
	curl -sL -o $$tmp/uz.tar.gz https://github.com/maxrodrigo/uz/archive/refs/tags/$(VERSION).tar.gz && \
	sha256=$$(shasum -a 256 $$tmp/uz.tar.gz | cut -d' ' -f1) && \
	git clone -q $(TAP) $$tmp/tap && \
	perl -pi -e 's#(archive/refs/tags/)v[0-9.]+(\.tar\.gz)#$${1}$(VERSION)$${2}#' $$tmp/tap/uz.rb && \
	perl -pi -e "s#sha256 \".*\"#sha256 \"$$sha256\"#" $$tmp/tap/uz.rb && \
	git -C $$tmp/tap commit -qam "Bump uz to $(VERSION)" && \
	git -C $$tmp/tap push -q origin main && \
	rm -rf $$tmp && \
	echo "Formula updated to $(VERSION)."

help: ## Show commands
	@awk 'BEGIN {FS = ":.*##"} /^[a-z][a-z-]+:.*##/ {printf "  %-8s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: release brew help
