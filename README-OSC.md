# Centrifugo - OSC Deployment

This fork contains OSC (Open Source Cloud) containerization artifacts for [centrifugal/centrifugo](https://github.com/centrifugal/centrifugo).

## Overview

Centrifugo is a real-time messaging server written in Go. It provides WebSocket, SSE, and HTTP streaming transports for building real-time applications.

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `TOKEN_HMAC_SECRET_KEY` | Yes | HMAC secret for JWT token signing (auto-generated if not set) |
| `API_KEY` | No | API key for server-side API calls |
| `ADMIN_PASSWORD` | No | Admin UI password |
| `REDIS_URL` | No | Redis URL for broker/presence/history (e.g., `redis://host:6379`) |
| `CENTRIFUGO_*` | No | Any Centrifugo env var (prefix `CENTRIFUGO_` maps to config key) |

## OSC Platform

- Port: `$PORT` (default 8080)
- Public URL: `$OSC_HOSTNAME` mapped to `CENTRIFUGO_CLIENT_ALLOWED_ORIGINS`
- Persistent storage: not required (ephemeral by default, Redis for persistence)
- Service type: service (long-running WebSocket/HTTP server)

## Added Files

- `Dockerfile.osc` - OSC-optimized Docker image built from source
- `osc-entrypoint.sh` - Entrypoint handling OSC platform conventions
- `README-OSC.md` - This file
- `CHANGELOG-OSC.md` - OSC artifact changelog
