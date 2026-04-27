# Docker Compose Architecture Project

A layered, containerized infrastructure demo built with Docker Compose, Nginx, Node.js, PostgreSQL, and isolated Docker networks.

## About The Project

This project demonstrates a small but realistic containerized application architecture. The focus is not on backend complexity, but on infrastructure design, service orchestration, network isolation, and operational thinking.

The system contains multiple services that communicate through separate Docker networks. Nginx acts as the public entry point and load balancer, while PostgreSQL, backup, and analyzer services remain isolated on an internal network.

## Architecture Overview

```text
Browser
  ↓
Nginx reverse proxy (public network)
  ↓
api1 / api2 Node.js backend containers
  ↓
PostgreSQL database (internal network)
  ↓
Backup container
  ↓
Analyzer container
```

### Main Components

- **Nginx** as a reverse proxy and single public entry point
- **Two Node.js backend containers** to demonstrate load balancing
- **PostgreSQL** with persistent storage
- **Backup container** for database dump operations
- **Analyzer container** for processing backup files and generating reports
- **Separated Docker networks** for public and internal communication

## Built With

- Docker
- Docker Compose
- Node.js
- Express
- Nginx
- PostgreSQL
- Alpine Linux

## Key Concepts Demonstrated

- Multi-container application orchestration
- Reverse proxy configuration
- Load balancing between backend containers
- Persistent Docker volumes
- One-off operational containers
- Internal-only Docker networks
- Environment-based configuration
- Basic infrastructure security principles

## Getting Started

### Prerequisites

Make sure the following tools are installed:

- Docker
- Docker Compose
- Git

### Installation

Clone the repository:

```bash
git clone https://github.com/TamasVasenszki/docker-compose-architecture-project.git
cd docker-compose-architecture-project
```

Create your local environment file:

```bash
cp .env.example .env
```

Review the values in `.env` and update them if needed.

### Running The Project

Start the full application stack:

```bash
docker compose up -d --build
```

Open the application in your browser:

```text
http://localhost:8080
```

The project uses port `8080` to avoid conflicts with services that commonly use port `5000` on macOS.

## Verification

### Check Running Containers

```bash
docker compose ps
```

### Health Check

The backend exposes a health endpoint:

```text
/api/health
```

Example request:

```bash
curl http://localhost:8080/api/health
```

The response identifies which backend instance handled the request and verifies database connectivity.

### Load Balancing Check

Run the health check multiple times. Responses should alternate between the two backend instances:

```text
api1
api2
```

This confirms that Nginx is distributing traffic between the backend containers.

## Backup Job

Run a one-off backup container:

```bash
docker compose run --rm backup sh
```

Inside the container, create a database dump:

```bash
pg_dump -h $DB_HOST -U $DB_USER $DB_NAME > /backups/backup.sql
```

The backup file is stored in a persistent Docker volume.

## Analyzer Job

Run the analyzer container:

```bash
docker compose run --rm analyzer
```

The analyzer reads the backup volume, generates a small report, writes the output to a persistent volume, and exits automatically.

## Security Considerations

- Credentials are not stored directly in the repository.
- Environment variables are loaded from a local `.env` file.
- PostgreSQL, backup, and analyzer services run on an internal-only Docker network.
- Internal services are not exposed directly to the host machine.
- Public access is routed through Nginx.
- Docker images use explicit version tags instead of `latest` where possible.

## Testing And Quality Notes

This project currently focuses on infrastructure behavior and manual verification through health checks, container inspection, and backup/analyzer jobs.

Recommended next quality improvements:

- Add automated API tests for the health endpoint.
- Add smoke tests for Docker Compose startup.
- Add CI checks for Docker image builds.
- Add linting for shell scripts and configuration files.

## Roadmap

- Add automated tests
- Add Docker healthcheck definitions
- Add scheduled backups
- Add CI pipeline for image builds
- Add image vulnerability scanning
- Extend the project with Terraform-based infrastructure provisioning

## License

Distributed under the MIT License.

## Author

Tamás Vasenszki

- GitHub: [TamasVasenszki](https://github.com/TamasVasenszki)
- LinkedIn: [Tamás Vasenszki](https://www.linkedin.com/in/tamasvasenszki)
