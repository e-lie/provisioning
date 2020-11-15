#!/bin/bash

export DNS_ZONE=hosteaching.ovh
export ADMIN_EMAIL=eliegavoty@free.fr
export OAUTH_AUTHZ_DOMAIN="hosteaching.ovh"
export KEYCLOAK_PASSWORD="secretpassword"
export KEYCLOAK_GROUP=""

kubeprod install generic \
  --dns-zone "${DNS_ZONE}" \
  --email "${ADMIN_EMAIL}" \
  --authz-domain "${OAUTH_AUTHZ_DOMAIN}" \
  --keycloak-password "${KEYCLOAK_PASSWORD}" \
  --keycloak-group "${KEYCLOAK_GROUP}"