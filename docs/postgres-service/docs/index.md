# Order Service

## Overview

The **Order Service** is a Python/Flask microservice responsible for managing customer orders. It persists orders in **PostgreSQL** and coordinates with two other services at order time: the **Product Service** (to validate inventory) and the **Notification Service** (to confirm the order to the customer).

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Runtime | Python |
| Framework | Flask + SQLAlchemy |
| Database | PostgreSQL |
| Port | 5000 |

## Responsibilities

- Accept new orders and validate the requested product exists
- Persist orders to PostgreSQL with product name denormalized for resilience
- Trigger a notification after each successful order
- Expose order stats combining data from PostgreSQL and Redis (via Product Service)

## Quick Start

```bash
# Health check
curl http://localhost:8080/api/orders/health

# Place an order
curl -X POST http://localhost:8080/api/orders/ \
  -H "Content-Type: application/json" \
  -d '{"product_id": "1234567890"}'
```

## Related Services

- **Product Service** — called to verify product existence before placing an order
- **Notification Service** — called after a successful order (non-blocking, failure is tolerated)
- **nginx gateway** — proxies all `/api/orders/` traffic to this service on port 5000
