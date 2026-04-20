# Talos Admin API (v1)

The Admin V1 API provides endpoints for managing the Talos Protocol platform, including identity, secrets, RBAC, and platform configuration.

## Base URL
`/admin/v1`

## Authentication
All endpoints require valid authentication (e.g., Bearer token).

---

## Identity & Status

### GET `/me`
Returns the current authorized user profile.

**Response:**
```json
{
  "id": "admin-001",
  "email": "admin@talos.security",
  "name": "System Administrator",
  "roles": ["admin", "operator"]
}
```

### GET `/gateway/status`
Returns high-level health and status of the gateway service.

---

## Secrets Management

### GET `/secrets`
Lists all secrets (environment-based and custom KMS secrets). Values are never returned.

**Response:**
```json
{
  "secrets": [
    {
      "id": "env:TALOS_API_KEY",
      "name": "TALOS_API_KEY",
      "provider": "env",
      "created_at": "2024-03-20T10:00:00Z"
    },
    {
      "id": "db:my-custom-key",
      "name": "my-custom-key",
      "provider": "kms",
      "kek_id": "kek-v1",
      "created_at": "2024-03-21T15:30:00Z"
    }
  ],
  "total": 2
}
```

### POST `/secrets`
Creates or updates a custom secret. The value is encrypted with the current KEK.

**Request Body:**
```json
{
  "name": "MY_SECRET_KEY",
  "value": "super-secret-value"
}
```

**Response:**
```json
{
  "status": "created",
  "name": "MY_SECRET_KEY"
}
```

### POST `/secrets/rotate-all`
Triggers a background rotation of all secrets to a new KEK.

**Response:**
```json
{
  "op_id": "rot-550e8400-e29b-41d4-a716-446655440000",
  "status": "RUNNING",
  "message": "Rotation started in background"
}
```

### GET `/secrets/rotation-status/{op_id}`
Returns the progress and stats of an active or completed rotation.

**Response:**
```json
{
  "id": "rot-550e8400-e29b-41d4-a716-446655440000",
  "status": "COMPLETED",
  "target_kek_id": "kek-v2",
  "stats": {
    "scanned": 12,
    "rotated": 12,
    "failed": 0
  },
  "started_at": "2024-03-21T16:00:00Z",
  "completed_at": "2024-03-21T16:00:05Z"
}
```

---

## RBAC Management

### GET `/rbac/roles`
Lists all available RBAC roles.

**Response:**
```json
{
  "roles": [
    {
      "role_id": "admin",
      "name": "Super Administrator",
      "permissions": ["*"],
      "built_in": true
    },
    {
      "role_id": "auditor",
      "name": "Audit Viewer",
      "permissions": ["audit:read"],
      "built_in": false
    }
  ]
}
```

### POST `/rbac/roles`
Upserts a role definition.

---

## Platform Configuration

### GET `/config:export`
Exports a snapshot of the current platform configuration.

### POST `/config:apply`
Applies a configuration snapshot atomically.
