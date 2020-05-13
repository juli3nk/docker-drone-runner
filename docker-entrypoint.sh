#!/usr/bin/env bash

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_SECRETNAME" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local secretNameVar="${var}_SECRETNAME"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!secretNameVar:-}" ]; then
		echo "Both $var and $secretNameVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!secretNameVar:-}" ]; then
		val="$(< "/run/secrets/${!secretNameVar}")"
	fi
	export "$var"="$val"
	unset "$secretNameVar"
}

file_env "DRONE_DOCKER_CONFIG"
file_env "DRONE_ENV_PLUGIN_TOKEN"
file_env "DRONE_REGISTRY_PLUGIN_TOKEN"
file_env "DRONE_RPC_SECRET"
file_env "DRONE_SECRET_PLUGIN_TOKEN"
file_env "DRONE_UI_PASSWORD"

exec /bin/drone-runner-docker "$@"
