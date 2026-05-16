.PHONY: deps test-syntax tests phpstan lint frontend-lint frontend-build ci

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

ci: deps test-syntax tests phpstan frontend-lint frontend-build
