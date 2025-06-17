.PHONY: ca-cert server-cert all-certs clean-certs docker-compose-build docker-compose-up docker-compose-down all

ca-cert: ## Build the certification authority.
	@cfssl gencert -initca ./tls/config/cfssl/ca-csr.json | cfssljson -bare ./tls/certs/ca

server-cert: ## Build the certification authority.
	@cfssl gencert -ca=./tls/certs/ca.pem -ca-key=./tls/certs/ca-key.pem \
		--config=./tls/config/cfssl/ca-config.json \
		-profile=smartsense \
		./tls/config/cfssl/server-csr.json | cfssljson -bare ./tls/certs/server

all-certs: ca-cert server-cert

clean-certs:
	@rm ./tls/certs/*.pem ./tls/certs/*.csr

docker-compose-build:
	@docker compose -f docker-compose-dev.yml --env-file .env --project-directory . -p redss-oauth2 build

docker-compose-up:
	@docker compose -f docker-compose-dev.yml --env-file .env --project-directory . -p redss-oauth2 up -d

docker-compose-down:
	@docker compose -f docker-compose-dev.yml --env-file .env --project-directory . -p redss-oauth2 down --remove-orphans

all: all-certs docker-compose-up
