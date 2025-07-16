# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Build Commands
- `mvn clean package` - Clean and build the entire application (generates EAR file)
- `mvn clean compile` - Clean and compile the source code
- `mvn clean install` - Clean, compile, test, and install to local repository

### Generated Artifacts
- Main artifact: `websphere-cafe-application/target/websphere-cafe.ear`
- Web module: `websphere-cafe-web/target/websphere-cafe.war`

## Architecture Overview

This is a Java EE 7 multi-module Maven project structured as follows:

### Module Structure
- **Root Module** (`websphere-cafe-modules`): Parent POM managing the build
- **Web Module** (`websphere-cafe-web`): WAR packaging containing the web application
- **Application Module** (`websphere-cafe-application`): EAR packaging that bundles the web module

### Technology Stack
- Java EE 7 (JAX-RS, EJB, CDI, JPA, JSF, Bean Validation)
- Java 8 (source/target compatibility)
- Maven 3.5.0+ for build management
- Traditional WebSphere Application Server for deployment

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
- Traditional WebSphere Application Server
- Database with JNDI datasource: `jdbc/WebSphereCafeDB`
- Application accessible at: `http://host:9080/websphere-cafe` or `https://host:9443/websphere-cafe`

### Development Notes
- Uses CDI for dependency injection
- JPA named queries for database operations
- Bean Validation for input validation
- Internationalization support (English/Spanish)