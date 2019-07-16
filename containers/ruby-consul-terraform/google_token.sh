#!/bin/bash

# USAGE script PATH_TO_SA_FILE SCOPE [TTL]
# SCOPE can be a space-delimited list of scopes, must be quoted
# TTL is in seconds, default 3600

# REQUIRES
# curl jq python python-dev libffi-dev openssl-dev
# (pip) pyjwt cryptography

# the audience the jwt is intendded for is always the google token API
# because the point of the JWT is to give it to the token API in exchange for
# an oauth token
google_auth_url="https://www.googleapis.com/oauth2/v4/token"

# google_sa_jwt SA_JSON_PATH SCOPE [TTL]
# SCOPE can be a space-delimited list of scopes, must be quoted
# TTL is in seconds, default 3600
google_sa_jwt() {
  local sa_json_path="${1}"
  
  # if array, should be space-delimited, e.g. 'https://www.googleapis.com/auth/analytics.edit https://www.googleapis.com/auth/analytics.manage.users'
  local scope="${2}"

  # seconds
  local ttl="${3:-3600}"

  local audience="${google_auth_url}"

  # The RS256 (RSA with SHA-265) algorithm is used to sign a JWT using
  # an RSA private key; that's what the private key in the SA JSON is for
  local algorithm="RS256"
  local priv_key="$(cat ${sa_json_path} | jq -r .private_key)"

  local issuer="$(cat ${sa_json_path} | jq -r .client_email)"
  local issued_at="$(date +%s)"
  local expiration="$(($(date +%s) + ${ttl}))"

  # Make the JWT
  pyjwt --alg=${algorithm} --key="${priv_key}" encode iss="${issuer}" scope="${scope}" aud="${audience}" iat="${issued_at}" exp="${expiration}"
}

# google_oauth_token JWT
google_oauth_token_json() {
  local jwt=${1}
  curl -X POST ${google_auth_url} -H 'Content-Type: application/json' --data '{"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer", "assertion": "'${1}'"}'
}

# google_token_info OAUTH_TOKEN
google_token_info() {
  local oauth_token=${1}
  curl 'https://content.googleapis.com/oauth2/v2/tokeninfo?access_token='${oauth_token}
}

SA_JWT=$(google_sa_jwt "${1}" "${2}" "${3}")
OAUTH_TOKEN=$(google_oauth_token_json "$SA_JWT" | jq -r .access_token)
google_token_info $OAUTH_TOKEN
