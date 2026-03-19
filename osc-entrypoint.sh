#!/bin/bash
set -eo pipefail

PORT=${PORT:-8080}

# Set Centrifugo HTTP server port from OSC PORT
export CENTRIFUGO_HTTP_SERVER_PORT="${PORT}"

# Enable health endpoint by default
export CENTRIFUGO_HEALTH_ENABLED="${CENTRIFUGO_HEALTH_ENABLED:-true}"

# Map OSC_HOSTNAME to allowed origins if set
if [ -n "$OSC_HOSTNAME" ]; then
    export CENTRIFUGO_CLIENT_ALLOWED_ORIGINS="${CENTRIFUGO_CLIENT_ALLOWED_ORIGINS:-https://${OSC_HOSTNAME}}"
fi

# Auto-generate token HMAC secret if not set
if [ -z "$CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY" ]; then
    if [ -n "$TOKEN_HMAC_SECRET_KEY" ]; then
        export CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY="${TOKEN_HMAC_SECRET_KEY}"
    else
        echo "WARNING: CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY is not set. Generating a random secret (ephemeral - will change on restart)."
        export CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)"
    fi
fi

# Admin password support
if [ -z "$CENTRIFUGO_ADMIN_PASSWORD" ] && [ -n "$ADMIN_PASSWORD" ]; then
    export CENTRIFUGO_ADMIN_PASSWORD="${ADMIN_PASSWORD}"
fi

# API key support
if [ -z "$CENTRIFUGO_HTTP_API_KEY" ] && [ -n "$API_KEY" ]; then
    export CENTRIFUGO_HTTP_API_KEY="${API_KEY}"
fi

# Redis broker support (using CENTRIFUGO_ENGINE_REDIS_ADDRESS for scaling)
if [ -n "$REDIS_URL" ]; then
    export CENTRIFUGO_ENGINE="redis"
    export CENTRIFUGO_ENGINE_REDIS_ADDRESS="${REDIS_URL}"
fi

exec "$@"
