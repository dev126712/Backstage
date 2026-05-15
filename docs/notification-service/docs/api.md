# API Reference

Base URL (via gateway): `http://localhost:8080/api/orders`

---

## GET /
Returns a confirmation that the service is online.

**Response `200`** — `Order Service Online`

---

## POST /
Places a new order. Validates the product, saves to PostgreSQL, and triggers a notification.

**Request Body**
```json
{ "product_id": "1234567890" }
```

**Response `201`**
```json
{ "message": "Order placed successfully", "order_id": 1 }
```

**Response `404`** — product not found in Product Service
```json
{ "error": "Product not found in inventory" }
```

**Response `503`** — Product Service is unreachable
```json
{ "error": "Product service unavailable: ..." }
```

---

## GET /
Returns all orders from PostgreSQL.

**Response `200`**
```json
[
  {
    "id": 1,
    "product_id": "1234567890",
    "product_name": "Widget",
    "status": "PLACED"
  }
]
```

---

## GET /stats
Returns aggregated stats across services.

**Response `200`**
```json
{
  "postgres_orders": 42,
  "redis_products": 10
}
```

| Field | Source |
|-------|--------|
| `postgres_orders` | Count of rows in the `order` table |
| `redis_products` | Count of products from Product Service (`GET /`) |

---

## GET /health
Verifies the service and its database connection are healthy.

**Response `200`** — `OK` (PostgreSQL reachable)  
**Response `503`** — `Database not ready` (connection failed)
