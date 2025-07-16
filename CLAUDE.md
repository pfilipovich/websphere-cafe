# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Build Commands
- `JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 mvn clean package` - Clean and build the entire application (generates WAR file)
- `JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 mvn clean compile` - Clean and compile the source code
- `JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 mvn clean install` - Clean, compile, test, and install to local repository

### OpenLiberty Development Commands
- `mvn liberty:create` - Create OpenLiberty server
- `mvn liberty:install-feature` - Install Jakarta EE features
- `mvn liberty:start` - Start OpenLiberty server
- `mvn liberty:stop` - Stop OpenLiberty server
- `mvn liberty:deploy` - Deploy application to OpenLiberty
- `mvn liberty:dev` - Run in development mode with hot reload

### Container Commands
- `docker build -t websphere-cafe:java11 .` - Build Docker image
- `docker-compose up` - Start containerized application
- `docker-compose down` - Stop containerized application

### Generated Artifacts
- Main artifact: `websphere-cafe-web/target/websphere-cafe.war`
- Container image: `websphere-cafe:java11`

## Architecture Overview

This is a Jakarta EE 8 multi-module Maven project structured as follows:

### Module Structure
- **Root Module** (`websphere-cafe-modules`): Parent POM managing the build
- **Web Module** (`websphere-cafe-web`): WAR packaging containing the web application
- **Application Module** (`websphere-cafe-application`): EAR packaging that bundles the web module

### Technology Stack
- Jakarta EE 8 (JAX-RS, EJB, CDI, JPA, JSF, Bean Validation)
- Java 11 (source/target compatibility)
- Maven 3.5.0+ for build management
- OpenLiberty 23.0.0.6 for deployment
- Docker containerization support

### Key Components

#### Data Layer
- **CafeRepository** (`cafe.model.CafeRepository`): JPA repository for Coffee entity operations
- **Coffee Entity** (`cafe.model.entity.Coffee`): JPA entity representing coffee items
- **Persistence Context**: Uses JNDI name `jdbc/WebSphereCafeDB`

#### REST API Layer
- **CafeResource** (`cafe.web.rest.CafeResource`): JAX-RS resource at `/coffees` endpoint
- Supports full CRUD operations (GET, POST, DELETE)
- Produces/consumes XML media type

#### Web Layer
- **Cafe View** (`cafe.web.view.Cafe`): JSF backing bean
- **JSF Pages**: Located in `webapp/` directory with XHTML templates
- **Context Root**: `/websphere-cafe`

### Deployment Requirements
- OpenLiberty Server with Jakarta EE 8 and MicroProfile 4.1 features
- Database with JNDI datasource: `jdbc/WebSphereCafeDB` (Derby embedded)
- Application accessible at: `http://host:9080/websphere-cafe` or `https://host:9443/websphere-cafe`
- Docker runtime for containerized deployment

### Health Check Endpoints
- Application health: `http://host:9080/websphere-cafe/health`
- OpenLiberty metrics: `http://host:9080/metrics`

### Development Notes
- Uses CDI for dependency injection
- JPA named queries for database operations
- Bean Validation for input validation
- Internationalization support (English/Spanish)
- Jakarta EE namespace migration from javax
- G1GC optimized for Java 11 performance
- Container-ready with health checks

### Migration Notes
- **Java Version**: Migrated from Java 8 to Java 11
- **Namespace**: All javax.* imports replaced with jakarta.*
- **Runtime**: Traditional WebSphere → OpenLiberty
- **Configuration**: XML configs updated to Jakarta EE 8 schemas
- **JAXB**: Explicit JAXB runtime dependencies added for Java 11+ compatibility
- **Testing**: Liberty Maven plugin for development and testing