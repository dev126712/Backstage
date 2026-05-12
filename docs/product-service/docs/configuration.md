# Configuration

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `REDIS_HOST` | `localhost` | Hostname of the Redis instance |

## Docker / Docker Compose

The service connects to Redis using the Docker DNS hostname:

```yaml
services:
  product-service:
    environment:
      - REDIS_HOST=redis
    depends_on:
      - redis

  redis:
    image: redis:alpine
```

## Ports

| Service | Internal Port | Exposed via Gateway |
|---------|--------------|---------------------|
| product-service | 3000 | `/api/products/` |
