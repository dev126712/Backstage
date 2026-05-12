# Architecture

## Data Storage

All products are stored in a single **Redis hash** under the key `products`:

```
products → {
  "1234567890": '{"id":"1234567890","name":"Widget","price":9.99}',
  "0987654321": '{"id":"0987654321","name":"Gadget","price":19.99}'
}
```

Each product is serialized as JSON and stored as a string value inside the hash.

## Cache-Aside Pattern

Individual product lookups (`GET /:id`) use the Cache-Aside pattern to reduce Redis hash lookups:

```
Client
  │
  ▼
GET /api/products/:id
  │
  ├─► Check Redis key: cache:{id}
  │       │
  │       ├─ HIT  → return { source: "cache", data: ... }
  │       │
  │       └─ MISS → hGet products:{id}
  │                     │
  │                     ├─ NOT FOUND → 404
  │                     │
  │                     └─ FOUND → setEx cache:{id} 60s
  │                                    → return { source: "main_store", data: ... }
```

Cache entries expire automatically after **60 seconds**.

## Cache Invalidation

On `PUT /:id` and `DELETE /:id`, the service explicitly deletes the `cache:{id}` key to prevent stale reads:

```js
await client.del(`cache:${id}`);
```

## Service Communication

The Product Service is called internally by the Order Service over Docker DNS:

```
order-service → http://product-service:3000/{id}
```

It is exposed externally through the nginx gateway at `/api/products/`.
