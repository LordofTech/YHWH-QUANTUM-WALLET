# Quantum Wallet Backend v1.0

YHWH DEV TEAM AI REPO — backend service for the ARTHUR YHWH QUANTUM WALLET PROJECT.

## Quickstart

```bash
npm install
# Setup PostgreSQL + PostGIS (https://postgis.net/install/)
# Create DB: quantum_wallet
# Run SQL:
psql -d quantum_wallet -f src/database/init.sql

# Copy .env.example to .env and fill values
npm run dev
```

### Test
```bash
curl -X POST http://localhost:3000/api/tx/online   -H "Authorization: Bearer YOUR_FIREBASE_ID_TOKEN"   -H "Content-Type: application/json"   -d '{
    "walletId": "a1b2c3d4-...",
    "amount": 2500,
    "type": "airtime",
    "lat": 9.0765,
    "lng": 7.3986
  }'
```


## Production & Ops

- **Security**: Helmet, rate limiting, CORS.
- **Observability**: Request IDs + morgan logs.
- **Docs**: Swagger UI at `/docs`.
- **Idempotency**: `Idempotency-Key` header for POSTs (in-memory; swap to Redis for prod).
- **Docker**: `Dockerfile` and `docker-compose.yml` (includes PostGIS).

### Run with Docker
```bash
docker compose up --build
# API -> http://localhost:3000
# Docs -> http://localhost:3000/docs
```


## RBAC
- Table: `users(uid, role)`
- Middleware:
  - `loadRole` resolves role from DB, bootstraps `ADMIN_UID` as admin
  - `authorize('admin' | 'agent' | 'user')` to protect routes
- Admin endpoint:
  - `POST /api/admin/users/role` (body: `{ uid, role }`), requires admin

## Idempotency (Redis-backed)
- Send `Idempotency-Key: <uuid>` header on POSTs
- Uses Redis when `REDIS_URL` is set; falls back to in-memory

## Prisma (preferred) or Knex (optional)
- Prisma:
  ```bash
  npm run prisma:generate
  npm run prisma:migrate   # interactive in dev
  # or
  npm run db:push          # non-destructive push in dev
  ```
- Knex (optional alternative):
  ```bash
  npm run knex:migrate
  ```

## CI/CD
- GitHub Actions: build, prisma generate, Docker build
- Optional publish job to push an image (configure `DOCKER_*` secrets)



## One‑click style deploys
- **Render**: connect repo, set env vars (`DATABASE_URL`, `REDIS_URL`, `FIREBASE_PROJECT_ID`), Render will read `render.yaml`.
- **Fly.io**: install `flyctl`, run `fly launch` (or use provided `fly.toml`), set secrets.
- **Railway**: import repo, Railway uses `railway.json`.
- **AWS ECS**: build & push Docker image (see CI), then create a Fargate service with `aws/ecs-task-def.json`.

## Redis Session Cache
- Caches verified Firebase token (`token:<token>`) and role lookups (`role:<uid>`) for 5 minutes.
- Disable by omitting `REDIS_URL` (falls back to no cache, still works).

## Prisma refactor
- Controllers now use Prisma Client (`src/database/prisma.ts`).
- PostGIS proximity uses `prisma.$queryRaw` to keep geospatial power while using Prisma for core CRUD.


## Observability (OpenTelemetry)
- Configure `OTEL_SERVICE_NAME` and (optional) `OTEL_EXPORTER_OTLP_ENDPOINT` (e.g., `http://collector:4318`).
- Auto-instruments HTTP, Express, and Postgres. Metrics & traces export via OTLP/HTTP if endpoint is set.

## Seed Data
```bash
npm run prisma:generate
npm run db:push        # or prisma migrate
npm run seed
```
Creates:
- Admin user (`ADMIN_UID`) as admin (upsert)
- Demo user + wallet
- Sample transactions


## Environments & GitHub Secrets
This repo includes a **Kubernetes deploy workflow** that targets GitHub **environments** (`staging`, `production`).
Set these secrets in each environment:
- `REGISTRY` (e.g., `ghcr.io`), `REGISTRY_USERNAME`, `REGISTRY_PASSWORD`
- `IMAGE` (e.g., `ghcr.io/<org>/quantum-wallet-backend`)
- `KUBE_CONFIG` (base64-encoded kubeconfig)
- `DATABASE_URL`, `FIREBASE_PROJECT_ID`, `REDIS_URL`, `ADMIN_UID`

Deploy manually:
1. Go to **Actions → Deploy to Kubernetes (Staging/Prod) → Run workflow**.
2. Choose `staging` or `production`.
3. The workflow builds & pushes the Docker image, applies **OTEL Collector**, **Secrets**, **API Deployment**, and **Ingress**.

### Docker Compose with OTEL Collector
```bash
docker compose -f docker-compose.yml -f docker-compose.otel.yml up --build
# API  -> http://localhost:3000
# OTLP -> http://localhost:4318
```


## Helm Charts
- `helm/quantum-wallet-api` — API deployment with configurable secrets and ingress.
- `helm/otel-collector` — minimal collector with OTLP/HTTP.
```bash
helm upgrade --install otel ./helm/otel-collector -n quantum-wallet --create-namespace
helm upgrade --install api  ./helm/quantum-wallet-api -n quantum-wallet
```

## External Secrets (optional)
Install ESO via Helm, then apply:
```bash
kubectl apply -f k8s/external-secrets-operator.yaml
kubectl apply -f k8s/api-external-secret.yaml
```

## Terraform (AWS EKS)
Template under `terraform/aws-eks` to spin up VPC + EKS with managed nodes.
```bash
cd terraform/aws-eks
terraform init && terraform apply -auto-approve
```


## Multi‑Cloud
- Umbrella Helm chart: `helm/umbrella`
- Providers:
  - Terraform: `terraform/aws-eks`, `terraform/gcp-gke`, `terraform/azure-aks`
- One command wrapper: `make deploy-cloud PROVIDER=aws|gcp|azure ENV=staging`

### GitHub OIDC
Use OIDC to eliminate static cloud keys. Configure provider-side identities (AWS IAM role with trust policy, GCP Workload Identity Pool/Provider, Azure Federated Identity Credentials) and set environment-level secrets for registry and kubeconfig access (if needed). The sample workflow `deploy-cloud.yml` shows the pattern.
