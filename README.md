# StartTech Application

Full-stack application with React frontend and Golang backend.

## Repository Structure
- `Client/` - React frontend application (Vite + TypeScript)
- `Server/MuchToDo/` - Golang backend API
- `.github/workflows/` - CI/CD pipelines
- `scripts/` - Deployment and utility scripts

## Prerequisites
- Node.js 20+
- Go 1.24+
- Docker
- AWS CLI configured

## Frontend (React)

### Local Development
```bash
cd Client
npm install
npm run dev
```

### Build
```bash
cd Client
npm run build
```

## Backend (Golang)

### Local Development
```bash
cd Server/MuchToDo
go mod download
go run cmd/api/main.go
```

### Build Docker Image
```bash
./scripts/docker-build.sh
```

## CI/CD Pipelines

### Frontend Pipeline
Triggers on push to `feature/full-stack` when files in `Client/` change:
1. Install Node.js dependencies
2. Run security audit
3. Build production bundle
4. Sync to S3
5. Invalidate CloudFront cache

### Backend Pipeline
Triggers on push to `feature/full-stack` when files in `Server/` change:
1. Run Go tests
2. Run vulnerability scan
3. Build Docker image
4. Scan image for vulnerabilities
5. Push to ECR
6. Deploy to EC2 via rolling update

## Deployment Scripts

### Deploy Frontend
```bash
./scripts/deploy-frontend.sh <s3-bucket-name> <cloudfront-id>
```

### Deploy Backend
```bash
./scripts/deploy-backend.sh starttech-asg us-east-1
```

### Health Check
```bash
./scripts/health-check.sh <alb-dns-name>
```

### Rollback
```bash
./scripts/rollback.sh starttech-asg us-east-1
```

## Environment Variables

### Backend
| Variable | Description |
|----------|-------------|
| `PORT` | Server port (default: 8080) |
| `MONGO_URI` | MongoDB Atlas connection string |
| `DB_NAME` | Database name |
| `JWT_SECRET_KEY` | JWT signing key |
| `JWT_EXPIRATION_HOURS` | JWT expiry in hours |
| `LOG_LEVEL` | Log level (DEBUG/INFO/WARN/ERROR) |
| `LOG_FORMAT` | Log format (json/text) |

### Frontend
| Variable | Description |
|----------|-------------|
| `VITE_API_URL` | Backend API URL |

## GitHub Secrets Required
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `MONGO_URI`
- `JWT_SECRET`
- `S3_BUCKET_NAME`
- `CLOUDFRONT_DISTRIBUTION_ID`
- `CLOUDFRONT_DOMAIN`
- `ALB_DNS_NAME`
- `VITE_API_URL`