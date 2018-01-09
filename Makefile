DBUSER=hashmir_user
DBPASSWD=shei7AnganeihaeF
DBNAME=hashmir_test
HOST=localhost

THIS_FILE := $(lastword $(MAKEFILE_LIST))

.DEFAULT_GOAL := help

create-db-user: ## Creates a DB user with the root MySQL user
	mysql -u root --host $(HOST) -e "CREATE USER '$(DBUSER)'@'$(HOST)' IDENTIFIED BY '$(DBPASSWD)';" > /dev/null 2>&1
	mysql -u root --host $(HOST) -e "GRANT ALL PRIVILEGES ON `$(DBNAME)`.* TO '$(DBUSER)'@'$(HOST)';" > /dev/null 2>&1

build-db: ## Builds the DB
	@echo "Dropping and rebuilding database $(DBNAME)"
	@mysql -u $(DBUSER) --password='$(DBPASSWD)' --host $(HOST) -e "DROP DATABASE IF EXISTS $(DBNAME);" > /dev/null 2>&1
	@mysql -u $(DBUSER) --password='$(DBPASSWD)' --host $(HOST) -e "CREATE DATABASE $(DBNAME);" > /dev/null 2>&1
	@mysql -u $(DBUSER) --password='$(DBPASSWD)' --host $(HOST) $(DBNAME) < resources/schema.sql > /dev/null 2>&1

dbconnect: ## Connect to the DB with mysql console
	mysql --user=$(DBUSER) --password='$(DBPASSWD)' --host=$(HOST) $(DBNAME)

build: ## Builds the project with stack
	@stack build && stack install

run: build-db ## Runs the app
	@time ~/.local/bin/hashmir-exe

test: build ## Run the specs
	@time stack test

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
