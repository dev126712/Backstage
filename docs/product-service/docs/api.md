# API Reference

Base URL (via gateway): `http://localhost:8080/api/products`

---

## GET /
Returns all products from the Redis `products` hash.

**Response `200`**
```json
[
  { "id": "1234567890", "name": "Widget", "price": 9.99 },
  { "id": "0987654321", "name": "Gadget", "price": 19.99 }
]
```

---

## GET /:id
Returns a single product. Checks the fast cache first, falls back to the main hash.

**Response `200`**
```json
{
  "source": "cache",
  "data": { "id": "1234567890", "name": "Widget", "price": 9.99 }
}
```

| `source` value | Meaning |
|---------------|---------|
| `cache` | Served from `cache:{id}` Redis key (TTL: 60s) |
| `main_store` | Served from `products` hash, result then cached |

**Response `404`** — product not found

---

## POST /
Creates a new product. The `id` is auto-generated from `Date.now()`.

**Request Body**
```json
{ "name": "Widget", "price": 9.99 }
```

**Response `201`**
```json
{ "id": "1234567890", "name": "Widget", "price": 9.99 }
```

---

## PUT /:id
Updates an existing product and invalidates its cache entry.

**Request Body**
```json
{ "name": "Updated Widget", "price": 12.99 }
```

**Response `200`**
```json
{ "id": "1234567890", "name": "Updated Widget", "price": 12.99 }
```

---

## DELETE /:id
Removes a product from the main store and clears its cache.

**Response `200`**
```json
{ "message": "Product deleted successfully", "id": "1234567890" }
```

**Response `404`** — product not found

---

## GET /health
Health check endpoint.

**Response `200`** — `OK`
