# Production Deployment Guide

This guide covers deploying Talos Protocol services to production Kubernetes environments.

## Prerequisites

- Kubernetes 1.24+ cluster
- kubectl configured
- Helm 3.8+ (optional, for Helm-based deployment)
- Docker (for building images)
- Ingress controller (nginx recommended)

## Quick Start

### Option 1: Helm Chart (Recommended)

```bash
# Build images (or use GHCR)
export VERSION=$(git rev-parse --short HEAD)
docker build --build-arg GIT_SHA=$(git rev-parse HEAD) \
  --build-arg VERSION=$VERSION \
  --build-arg BUILD_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  -t ghcr.io/talosprotocol/talos-gateway:$VERSION \
  -f services/gateway/Dockerfile .

# Push to registry
docker push ghcr.io/talosprotocol/talos-gateway:$VERSION

# Install via Helm
helm install talos deploy/helm/talos \
  --namespace talos-system --create-namespace \
  --set image.tag=$VERSION
```

### Option 2: Kustomize

```bash
# Build images locally
make docker-build  # Or use the CI-built images

# Apply with Kustomize
cd deploy/k8s/overlays/prod
kustomize edit set image \
  talos-gateway=ghcr.io/talosprotocol/talos-gateway:$VERSION

kubectl apply -k .
```

## Configuration

### 1. Secrets

Create secrets before deployment:

```bash
kubectl create secret generic talos-secrets \
  --from-literal=database-url=postgresql://user:pass@host:5432/talos \
  --namespace talos-system
```

For production, use:

- **Sealed Secrets**: Encrypt secrets in Git
- **External Secrets Operator**: Sync from Vault/AWS Secrets Manager
- **SOPS**: Encrypt values with KMS

### 2. Ingress

Update hostname in values.yaml or kustomize patches:

```yaml
# Helm: values.yaml
ingress:
  host: talos.yourdomain.com
  tls:
    enabled: true
    secretName: talos-tls
```

### 3. Database

Production PostgreSQL is required (`DEV_MODE=false`).

**Option A: Managed Service** (Recommended)

```bash
# Use AWS RDS, GCP Cloud SQL, or Azure Database
DATABASE_URL=postgresql://user:pass@rds.amazonaws.com:5432/talos
```

**Option B: In-cluster StatefulSet**

```bash
kubectl apply -f deploy/k8s/base/postgres/statefulset.yaml
```

### 4. Monitoring (Optional)

Install Prometheus Operator:

```bash
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --values deploy/k8s/monitoring/prometheus-values.yaml
```

Enable ServiceMonitors:

```yaml
# Helm: values.yaml
monitoring:
  enabled: true
  serviceMonitor:
    enabled: true
  prometheusRule:
    enabled: true
```

## Architecture

### Two-Ingress Pattern

```
                    ┌─────────────────┐
                    │  Ingress-Nginx  │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │                 │
              ┌─────▼─────┐    ┌─────▼──────┐
              │ Dashboard │    │  API Path  │
              │ Ingress   │    │  Ingress   │
              │   "/"     │    │ "/api/*"   │
              └─────┬─────┘    │ "/audit/*" │
                    │          │ "/mcp/*"   │
                    │          └─────┬──────┘
                    │                │
           ┌────────▼───┐    ┌───────┴──────┐
           │ Dashboard  │    │   Gateway    │
           │  Service   │    │   Audit      │
           │ (Port 3000)│    │   MCP        │
           └────────────┘    └──────────────┘
```

### Security Features

- **Non-root containers**: UID 1001
- **Read-only rootfs**: Writable mounts for /tmp
- **NetworkPolicies**: Default deny + explicit allowances
- **Pod security**: Capabilities dropped, seccomp enabled
- **TLS**: Ingress with cert-manager

## Health Check Endpoints

All services expose standardized health endpoints:

- `/healthz` - Liveness probe (no dependencies)
- `/readyz` - Readiness probe (checks dependencies)
- `/version` - Build metadata (git SHA, version, build time)
- `/metrics` - Prometheus metrics

## Migration Strategy

Migrations run as a **versioned Kubernetes Job**:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: gateway-migrations-v1 # Increment version
```

**Workflow:**

1. Job runs `alembic upgrade head`
2. Gateway `/readyz` checks schema version
3. Returns 503 until migrations complete
4. No initContainer race conditions

## Scaling

### Horizontal Pod Autoscaling

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: talos-gateway
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: talos-gateway
  minReplicas: 3
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

### Vertical Pod Autoscaling

Adjust resource requests/limits in `values.yaml`:

```yaml
gateway:
  resources:
    requests:
      cpu: 200m
      memory: 256Mi
    limits:
      cpu: 1000m
      memory: 1Gi
```

## Backup & Disaster Recovery

### Database Backups

```bash
# Automated backups via CronJob
kubectl apply -f deploy/k8s/base/postgres/backup-cronjob.yaml
```

### Audit Log Archival

Audit events stored in PostgreSQL with Merkle tree anchoring.

**Retention Policy:**

- Hot storage: 90 days
- Cold storage (S3): 7 years
- Compliance: SOC2, HIPAA, GDPR

## Troubleshooting

### Pods not starting

```bash
# Check pod status
kubectl get pods -n talos-system

# View logs
kubectl logs -n talos-system -l app=talos-gateway --tail=50

# Check events
kubectl describe pod -n talos-system <pod-name>
```

### Ingress not routing

```bash
# Verify ingress created
kubectl get ingress -n talos-system

# Check ingress-nginx logs
kubectl logs -n ingress-nginx -l app.kubernetes.io/component=controller

# Test with port-forward
kubectl port-forward -n talos-system svc/talos-gateway 8080:8080
curl http://localhost:8080/healthz
```

### Database connection issues

```bash
# Check secret exists
kubectl get secret talos-secrets -n talos-system

# Verify DATABASE_URL
kubectl get secret talos-secrets -n talos-system -o jsonpath='{.data.database-url}' | base64 -d

# Test connectivity from pod
kubectl run -it --rm debug --image=postgres:15 --restart=Never -- \
  psql $DATABASE_URL
```

## Production Checklist

- [ ] Secrets externally managed (not in Git)
- [ ] TLS certificates configured
- [ ] Database backups enabled
- [ ] Monitoring alerts configured
- [ ] Resource limits set appropriately
- [ ] NetworkPolicies applied
- [ ] Pod security policies enforced
- [ ] Ingress rate limiting configured
- [ ] Log aggregation setup (ELK, Datadog, etc.)
- [ ] Disaster recovery plan documented

## References

- [Kubernetes Manifests](../deploy/k8s/)
- [Helm Chart](../deploy/helm/talos/)
- [Monitoring Setup](../deploy/k8s/monitoring/)
- [CI/CD Pipeline](../.github/workflows/production-ready.yml)
