# Product Service

## Overview

The **Product Service** is a Node.js/Express microservice responsible for managing the product inventory. It uses **Redis** as its primary data store and implements a **Cache-Aside** pattern for fast individual product lookups.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Runtime | Node.js |
| Framework | Express |
| Database | Redis |
| Port | 3000 |

## Responsibilities

- Store and retrieve all products from a Redis hash (`products`)
- Serve individual product lookups with a 60-second in-memory cache
- Expose CRUD endpoints consumed by the Order Service and the nginx gateway

## Quick Start

```bash
# Run with Docker
docker run -e REDIS_HOST=localhost -p 3000:3000 product-service

# Health check
curl http://localhost:8080/api/products/health
```

## Related Services

- **Order Service** — calls this service to verify products before placing orders
- **nginx gateway** — proxies all `/api/products/` traffic to this service on port 3000
