.PHONY: deps test-syntax tests phpstan lint frontend-lint frontend-build install-cjd-web ci

deps:
	$(MAKE) -C src deps

test-syntax:
	$(MAKE) -C src test-syntax

tests:
	$(MAKE) -C src tests

phpstan:
	$(MAKE) -C src phpstan

frontend-lint:
	cd frontend && npm run lint

frontend-build:
	cd frontend && npm run build

lint: test-syntax phpstan frontend-lint

ci: deps test-syntax tests phpstan frontend-lint frontend-build install-cjd-web

install-cjd-web:
	@test -d src/modules/web || $(MAKE) -C src modules
	cp -f build/cjd-web/_head.html src/modules/web/_head.html
	cp -f build/cjd-web/content.css src/modules/web/content.css
	cp -f build/cjd-web/cjd.css src/modules/web/cjd.css
	@echo "Thème CJD Brindille installé dans src/modules/web/"

