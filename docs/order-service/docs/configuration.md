# Configuration

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DATABASE_URL` | `postgresql://user:pass@db:5432/orders_db` | PostgreSQL connection string |
| `PRODUCT_SERVICE_URL` | `http://product-service:3000` | Base URL for the Product Service |
| `NOTIFICATION_SERVICE_URL` | `http://notification-service:5001` | Base URL for the Notification Service |

## Docker / Docker Compose

```yaml
services:
  order-service:
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/orders_db
      - PRODUCT_SERVICE_URL=http://product-service:3000
      - NOTIFICATION_SERVICE_URL=http://notification-service:5001
    depends_on:
      - db
      - product-service

  db:
    image: postgres:15
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: orders_db
```

## Ports

| Service | Internal Port | Exposed via Gateway |
|---------|--------------|---------------------|
| order-service | 5000 | `/api/orders/` |
