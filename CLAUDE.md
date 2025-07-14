# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

WebSphere Cafe is a Java EE 7 CRUD web application modernized for cloud-native deployment running on Java 11. Originally designed for WebSphere Application Server, it has been migrated to OpenLiberty and configured for Kubernetes deployment with PostgreSQL database.

## Common Development Commands

### Build and Package
```bash
mvn clean package          # Build WAR and create Liberty server package
mvn clean install         # Build and install to local Maven repository
./scripts/build.sh         # Build application and Docker image
```

**Note**: The main build commands should be run from the project root directory. For Liberty-specific commands, navigate to the `websphere-cafe-web/` directory.

### Development
```bash
mvn liberty:dev            # Start Liberty in development mode (from websphere-cafe-web/)
./scripts/local-dev.sh     # Start PostgreSQL and Liberty dev mode
mvn compile               # Compile source code
mvn dependency:tree      # View dependency hierarchy
```

### Container and Kubernetes
```bash
docker build -t websphere-cafe:latest .  # Build Docker image
./scripts/deploy.sh       # Deploy to Kubernetes
./scripts/undeploy.sh     # Remove from Kubernetes
kubectl port-forward svc/websphere-cafe-service 8080:80 -n websphere-cafe  # Access locally
```

## Architecture Overview

### Structure
- **websphere-cafe-web/**: Main WAR module containing business logic and web interface
- **k8s/**: Kubernetes deployment manifests
- **scripts/**: Build and deployment automation scripts
- **Parent POM**: Manages shared dependencies and build configuration

### Technology Stack
- **Backend**: Java EE 7 (JAX-RS, EJB, JPA, CDI, Bean Validation) on Java 11
- **Frontend**: JSF 2.2 with XHTML/Facelets and Bootstrap
- **Runtime**: OpenLiberty (migrated from WebSphere Traditional)
- **Database**: PostgreSQL (cloud-native replacement)
- **Build**: Maven 3.5.0+ with Liberty Maven Plugin
- **Container**: Docker with OpenLiberty Java 11 base image
- **Orchestration**: Kubernetes with health checks and auto-scaling

### Key Components

#### Data Layer (`cafe.model`)
- **Coffee Entity**: JPA entity representing coffee menu items (id, name, price)
- **CafeRepository**: EJB managing database operations via EntityManager
- **Database**: PostgreSQL with automatic schema generation
- **JNDI Data Source**: `jdbc/WebSphereCafeDB` (configured in Liberty server.xml)

#### REST API (`cafe.web.rest`)
- **CafeResource**: JAX-RS endpoints at `/rest/coffees`
- **HealthResource**: Health check endpoints for Kubernetes liveness/readiness probes
- **Content Type**: XML (APPLICATION_XML)
- **Operations**: GET (list/single), POST (create), DELETE
- **Health Endpoints**: `/rest/health` for Kubernetes probes

#### Web Interface (`cafe.web.view`)
- **Cafe Managed Bean**: JSF backing bean with session scope
- **Main Page**: `/index.xhtml` with coffee management interface
- **Custom Components**: `inputPrice.xhtml` for reusable price input

### Configuration Architecture
- **server.xml**: OpenLiberty feature configuration and database setup
- **persistence.xml**: JPA configuration with PostgreSQL-specific settings
- **faces-config.xml**: JSF setup with English/Spanish internationalization
- **beans.xml**: CDI configuration with full bean discovery mode
- **Dockerfile**: Multi-stage build with OpenLiberty base image
- **Kubernetes Manifests**: ConfigMaps, Secrets, Deployments, and Services

### Application Flow
1. JSF front-end for user interaction
2. Managed beans handle UI logic
3. EJB repository manages business operations
4. JPA entities map to database
5. REST API provides programmatic access

## Development Guidelines

### Liberty Development Mode
Use `mvn liberty:dev` for hot-reload development. Liberty automatically detects changes and redeploys.

### Database Configuration
- PostgreSQL connection configured via environment variables
- Schema auto-generation handles database initialization
- Environment variables: `DB_SERVER`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`

### Container Development
- Local development: Use `./scripts/local-dev.sh` for PostgreSQL + Liberty
- Container testing: Build with `./scripts/build.sh`
- Kubernetes deployment: Use `./scripts/deploy.sh`

### Health Checks
- Liveness probe: `/health/live` (application running)
- Readiness probe: `/health/ready` (database connectivity)
- Custom health endpoint: `/rest/health`

### Kubernetes Configuration
- Namespace: `websphere-cafe`
- ConfigMaps: Database connection parameters
- Secrets: Database credentials (base64 encoded)
- Ingress: `websphere-cafe.local` hostname

### Cloud-Native Features
- MicroProfile Health for Kubernetes integration
- Environment-based configuration for cloud deployment
- Horizontal Pod Autoscaling ready with resource limits