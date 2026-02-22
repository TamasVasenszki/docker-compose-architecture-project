# Docker Compose Architecture Demo

This project demonstrates a layered containerized infrastructure built with Docker Compose.

The goal of this project is not backend complexity, but infrastructure design, orchestration, and security-focused architecture.

---

## Architecture Overview

The system consists of:

- **Nginx** as a reverse proxy and single entry point
- **Two backend instances** (Node.js) with load balancing
- **PostgreSQL database** with persistent storage
- **Backup container** for database dumps
- **Analyzer container** for report generation
- **Separated Docker networks** (public and internal)

### High-Level Flow

```
Browser
   ↓
Nginx (public_net)
   ↓
api1 / api2
   ↓
PostgreSQL (internal_net)
   ↓
Backup → Analyzer
```

---

## Key DevOps Concepts Demonstrated

- Reverse proxy configuration
- Load balancing between backend containers
- Docker multi-service orchestration
- Persistent Docker volumes
- One-off automation containers
- Network isolation (internal-only network)
- Principle of least privilege

---

## Security Design

- No credentials are stored in the repository
- Environment variables are loaded from a local `.env` file
- Internal services (database, backup, analyzer) run on an isolated network
- Automation containers have no outbound internet access
- Base images are pinned to LTS versions

---

## Setup & Run

### Clone the repository

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

### Create your environment file

```bash
cp .env.example .env
```

Edit `.env` if needed.

### Start the infrastructure

```bash
docker compose up -d --build
```

Open in browser:

```
http://localhost:8080
```

---

## Health Check

The backend exposes:

```
/api/health
```

This endpoint:

- Identifies which backend instance handled the request
- Performs a live database connectivity check (`SELECT 1`)

---

## Backup Job (One-Off Container)

Run a database backup:

```bash
docker compose run --rm backup sh
```

Inside the container:

```bash
pg_dump -h $DB_HOST -U $DB_USER $DB_NAME > /backups/backup.sql
```

The backup is stored in a persistent Docker volume.

---

## Analyzer Job

Run the analyzer:

```bash
docker compose run --rm analyzer
```

This container:

- Reads the latest backup from a shared volume
- Generates a report (file size, line count, timestamp)
- Writes output to a persistent volume
- Exits automatically

---

## Network Isolation

Internal services run on a Docker network with:

```yaml
internal: true
```

This prevents outbound internet access for:

- PostgreSQL
- Backup container
- Analyzer container

Only required communication paths are allowed.

---

## Technologies Used

- Docker & Docker Compose
- Node.js (Active LTS)
- Nginx
- PostgreSQL
- Alpine Linux

---

## Future Improvements

- Scheduled automated backups
- CI pipeline for image builds
- Image vulnerability monitoring
- Healthcheck definitions in Compose
- Infrastructure as Code extension (Terraform)

---

## License

MIT