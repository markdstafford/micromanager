# API Contracts

This document defines all API endpoints, their request/response schemas, validation rules, and error codes. It serves as the source of truth for the API interface.

**Last updated**: [Date]
**API Version**: v1
**Base URL**: `/api/v1`
**API Style**: [REST / GraphQL / gRPC]

## Authentication

**Method**: [JWT Bearer Token / Session Cookie / OAuth 2.0]

**Headers**:
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Authentication errors**:
- `401 Unauthorized` - Missing or invalid token
- `403 Forbidden` - Valid token but insufficient permissions

## Endpoints

### Workspaces

#### List workspaces

**Endpoint**: `GET /workspaces`

**Description**: Get all workspaces the user has access to

**Authentication**: Required

**Query parameters**:
- `limit` (integer, optional, default: 50) - Number of workspaces to return
- `offset` (integer, optional, default: 0) - Pagination offset

**Response**: `200 OK`

```json
{
  "workspaces": [
    {
      "id": "uuid",
      "name": "string",
      "owner_id": "uuid",
      "created_at": "ISO8601 timestamp"
    }
  ],
  "total": "integer",
  "limit": "integer",
  "offset": "integer"
}
```

**Errors**:
- `400 Bad Request` - Invalid query parameters
- `401 Unauthorized` - Not authenticated

#### Create workspace

**Endpoint**: `POST /workspaces`

**Description**: Create a new workspace

**Authentication**: Required

**Request body**:
```json
{
  "name": "string (required, 1-255 chars)"
}
```

**Validation**:
- `name` - Required, 1-255 characters, must be unique for user

**Response**: `201 Created`

```json
{
  "id": "uuid",
  "name": "string",
  "owner_id": "uuid",
  "created_at": "ISO8601 timestamp"
}
```

**Errors**:
- `400 Bad Request` - Invalid request body
  ```json
  {
    "error": "validation_error",
    "message": "Invalid workspace name",
    "details": {
      "name": ["Name must be between 1 and 255 characters"]
    }
  }
  ```
- `401 Unauthorized` - Not authenticated
- `409 Conflict` - Workspace name already exists for user

#### Get workspace

**Endpoint**: `GET /workspaces/:id`

**Description**: Get a specific workspace by ID

**Authentication**: Required

**Path parameters**:
- `id` (uuid, required) - Workspace ID

**Response**: `200 OK`

```json
{
  "id": "uuid",
  "name": "string",
  "owner_id": "uuid",
  "member_count": "integer",
  "page_count": "integer",
  "created_at": "ISO8601 timestamp",
  "updated_at": "ISO8601 timestamp"
}
```

**Errors**:
- `401 Unauthorized` - Not authenticated
- `403 Forbidden` - User doesn't have access to this workspace
- `404 Not Found` - Workspace doesn't exist

### Pages

[Similar structure for page endpoints]

## Common response patterns

### Pagination

All list endpoints support pagination:

**Query parameters**:
- `limit` - Max items to return (default: 50, max: 100)
- `offset` - Number of items to skip (default: 0)

**Response includes**:
```json
{
  "items": [...],
  "total": "integer",
  "limit": "integer",
  "offset": "integer",
  "has_more": "boolean"
}
```

### Sorting

List endpoints support sorting:

**Query parameters**:
- `sort` - Field to sort by (e.g., `created_at`, `name`)
- `order` - Sort order: `asc` or `desc` (default: `desc`)

### Filtering

List endpoints may support filtering:

**Query parameters**:
- `type` - Filter by type (comma-separated for multiple)
- `created_after` - Filter by creation date (ISO8601)

## Error response format

All errors follow this format:

```json
{
  "error": "error_code",
  "message": "Human-readable error message",
  "details": {
    "field_name": ["Error description"]
  }
}
```

### Common error codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `validation_error` | 400 | Request validation failed |
| `unauthorized` | 401 | Authentication required |
| `forbidden` | 403 | Insufficient permissions |
| `not_found` | 404 | Resource not found |
| `conflict` | 409 | Resource already exists |
| `rate_limited` | 429 | Too many requests |
| `internal_error` | 500 | Server error |

## Validation rules

### Common field validations

- **name fields**: 1-255 characters, no leading/trailing whitespace
- **email fields**: Valid email format, max 255 characters
- **uuid fields**: Valid UUID v4 format
- **type fields**: Must match allowed enum values
- **content fields**: Max size 10MB

### Rate limiting

- Anonymous requests: 10 requests/minute
- Authenticated requests: 100 requests/minute
- Burst limit: 20 requests

**Rate limit headers**:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640000000
```

## Versioning

API version is specified in the URL path: `/api/v1/...`

**Breaking changes** require a new version number. Non-breaking changes:
- Adding new optional fields
- Adding new endpoints
- Adding new enum values (if gracefully handled)

**Breaking changes**:
- Removing or renaming fields
- Changing field types
- Removing endpoints
- Changing validation rules to be more strict

## WebSocket API (if applicable)

**Connection**: `wss://api.example.com/ws`

**Authentication**: Via query parameter `?token=<jwt>`

### Message format

All messages use JSON:

```json
{
  "type": "message_type",
  "payload": { ... }
}
```

### Message types

[Document WebSocket message types if applicable]

## Notes

[Additional notes about API design decisions, future changes, or deprecation plans]

---

## How to use this document

1. **When creating tech specs**: Reference this document for existing endpoints
2. **When adding endpoints**: Update this document with new endpoint definitions
3. **When modifying endpoints**: Update the relevant section and note breaking changes
4. **When consuming API**: Use this as the canonical reference for request/response format

This document should be updated whenever:
- New endpoints are added
- Request or response schemas change
- Validation rules are modified
- Error codes are added or changed
- Authentication or authorization requirements change
