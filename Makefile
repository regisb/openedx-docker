.DEFAULT_GOAL := help

compile-requirements: ## Compile requirements files
	pip-compile -o requirements/base.txt requirements/base.in
	pip-compile -o requirements/dev.txt requirements/dev.in

bundle: ## Bundle the tutor package in a single "dist/tutor" executable
	pyinstaller --onefile --name=tutor --add-data=./tutor/templates:./tutor/templates ./bin/main

travis: bundle ## Run tests on travis-ci
	mkdir /tmp/tutor
	./dist/tutor config noninteractive --root=/tmp/tutor
	./dist/tutor images env --root=/tmp/tutor
	./dist/tutor images build all --root=/tmp/tutor
	./dist/tutor local databases --root=/tmp/tutor

ESCAPE = 
help: ## Print this help
	@grep -E '^([a-zA-Z_-]+:.*?## .*|######* .+)$$' Makefile \
		| sed 's/######* \(.*\)/\n               $(ESCAPE)[1;31m\1$(ESCAPE)[0m/g' \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[33m%-30s\033[0m %s\n", $$1, $$2}'
