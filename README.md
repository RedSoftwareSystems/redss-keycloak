# Keycloack installation for develpment environment

This project has two objctives.

Create a Keycloak instance that developers can use on their local machines under https protocol.\
The image uses nginx to fulfill this requirement and serves keycloack at `https://auth.redss.local`.\
Of course you have to modify your `/etc/hosts` file inserting the line like `127.0.1.1  auth.redss.local` (Or any of the loopback addresses. Ex.: 127.0.0.0/8)

The other objective is to create a self signed certificates that can be used on multiple local servers with a common CA, this way your applications will not complain for using a self signed certificate.

## Prerequisites

- docker
- docker-compose
- cfss (to easily generate self signed certificates [https://github.com/cloudflare/cfssl](https://github.com/cloudflare/cfssl))
- make to build Keycloack

## Installation

Use the file `env.sample` to create `.env` file. The variable BIND_ADDRESS is set to 127.0.1.1 so, if you leave the default address, you
just have to modify the `/etc/hosts` file inserting the line `127.0.1.1  auth.redss.local`.

Run the command `make all` to create TLS certificates and build and run docker compose.

You will have certificates in folder `tls/certs`.

You can also modify file `tls/config/cfssl/server-csr.json` to add other supported hosts to the certificate. Remeber that the ca.pem is the certificate of the CA and can be used to validate tls connections without any problem

To regenerate the server certificate just run the command `make server-cert`

## Using the certification authority in your browser.

Insall file `ca.pem` as trusted store in your browser and it will not complain for a self signed certificate.

## Using the certification authority in java applications.

```
keytool -importcert -no-prompt -keystore [JDK]/lib/security/cacerts -storepass changeit -file tls/certs/ca.pem
```

## Using the certification authority in nodejs applications.

Just set the environment variable `NODE_EXTRA_CA_CERTS` to the absolute path of tls/certs/ca.pem
