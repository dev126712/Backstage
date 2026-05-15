# Architecture

## Data Model

```sql
CREATE TABLE order (
  id          SERIAL PRIMARY KEY,
  product_id  VARCHAR(50)  NOT NULL,
  product_name VARCHAR(100),
  status      VARCHAR(20)  DEFAULT 'PLACED'
);
```

`product_name` is deliberately denormalized — it's copied from the Product Service at order time so that order history remains correct even if a product is later renamed or deleted.

## Order Creation Flow

```
Client
  │
  ▼
POST /api/orders/
  │
  ├─► GET product-service:3000/{product_id}   (timeout: 2s)
  │       │
  │       ├─ 404 → return 404 "Product not found in inventory"
  │       └─ 503 → return 503 "Product service unavailable"
  │
  ├─► INSERT into PostgreSQL orders table
  │
  └─► POST notification-service:5001/notify   (timeout: 2s)
          │
          └─ FAIL (tolerated) → log warning, order already saved
```

## Fault Tolerance

The Notification Service call is **fire-and-forget** — if it times out or fails, the order is still committed and a warning is logged. This prevents a non-critical service from blocking the order flow.

## Database Startup Retry

On startup, the service retries the PostgreSQL connection every 2 seconds until it succeeds. This handles the race condition where the database container starts after the app container in Docker Compose:

```python
while not connected:
    try:
        db.create_all()
        connected = True
    except OperationalError:
        time.sleep(2)
```

## Service Communication

All inter-service calls use Docker internal DNS:

| Call | URL |
|------|-----|
| Verify product | `http://product-service:3000/{id}` |
| Send notification | `http://notification-service:5001/notify` |
