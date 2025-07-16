# WebSphere Cafe Migration Execution Plan - Claude Code Agent

## EXECUTIVE SUMMARY

**Migration Path**: Java 8 + WebSphere AS → Java 11 + OpenLiberty + Container  
**Total Steps**: 20 streamlined execution steps  
**Validation Points**: 8 critical checkpoints with rollback procedures  
**Execution Mode**: Autonomous with TodoWrite tracking  
**Risk Level**: Medium (comprehensive mitigation strategies included)  
**Estimated Time**: 4-6 hours for full migration  

---

## CLAUDE CODE EXECUTION STRATEGY

### Tool Usage Protocol
1. **TodoWrite**: Track all steps as discrete tasks - mark in_progress before starting, completed immediately after validation
2. **Read**: Always examine files before modifications - understand context and dependencies
3. **Edit/MultiEdit**: Use for targeted changes - prefer MultiEdit for multiple changes to same file
4. **Bash**: Validate after each step - run builds, tests, and verification commands
5. **Grep/Glob**: Use for code analysis and dependency discovery

### Execution Rules
- **Sequential Processing**: Complete each step fully before proceeding
- **Validation First**: Every step must pass validation before marking complete
- **Rollback Ready**: Create backup before starting - restore on any failure
- **Error Reporting**: Document specific errors and resolution steps

---

## RISK ASSESSMENT & MITIGATION

### Critical Risk Areas

| Risk | Impact | Mitigation Strategy | Validation |
|------|--------|-------------------|------------|
| **JAXB Compatibility** | Critical | Add explicit JAXB runtime dependencies | Test XML marshalling |
| **Jakarta EE Namespace** | High | Systematic javax→jakarta import replacement | Compilation validation |
| **Database Configuration** | High | Update JNDI datasource config | Connection health checks |
| **Performance Degradation** | Medium | G1GC tuning + monitoring | Benchmark comparison |
| **Security Changes** | High | Audit security configurations | Security scanning |

### Risk Mitigation Protocol
1. **Pre-Migration**: Environment validation and backup creation
2. **Core Migration**: Step-by-step component migration with validation
3. **Integration Testing**: End-to-end functionality verification
4. **Production Readiness**: Performance and security validation

---

## MIGRATION EXECUTION STEPS

### STEP 1: ENVIRONMENT PREPARATION

**Claude Code Actions:**
1. **TodoWrite**: Add "Environment preparation" task, mark in_progress
2. **Bash**: Create backup and validate current environment
3. **Read**: Examine current project structure and dependencies

**Commands:**
```bash
# Create timestamped backup
cp -r /mnt/d/websphere-cafe /mnt/d/websphere-cafe-backup-$(date +%Y%m%d_%H%M%S)

# Validate current build
mvn clean package

# Document environment
java -version > migration-analysis/java-version-before.txt
mvn dependency:tree > migration-analysis/dependency-tree-before.txt
```

**Validation Criteria:**
- [ ] Backup created successfully
- [ ] Maven build exits with status 0
- [ ] Java 8 environment documented
- [ ] TodoWrite task marked as completed

**Rollback Trigger:** Any validation failure

---

### STEP 2: DEPENDENCY ANALYSIS

**Claude Code Actions:**
1. **TodoWrite**: Add "Dependency analysis" task, mark in_progress
2. **Read**: Examine current `pom.xml` files
3. **Grep**: Search for javax.* imports across codebase
4. **Bash**: Run dependency analysis tools

**Commands:**
```bash
# Analyze dependencies for Java 11 compatibility
mvn versions:display-dependency-updates > migration-analysis/available-updates.txt
mvn org.owasp:dependency-check-maven:check
```

**Validation Criteria:**
- [ ] All dependencies analyzed for Java 11 compatibility
- [ ] Security vulnerabilities assessed
- [ ] Migration strategy documented
- [ ] TodoWrite task marked as completed

---

### STEP 3: UPDATE ROOT POM FOR JAVA 11

**Claude Code Actions:**
1. **TodoWrite**: Add "Update root POM" task, mark in_progress
2. **Read**: Examine current `/pom.xml` structure
3. **Edit**: Update compiler properties and dependencies
4. **Bash**: Validate compilation with Java 11

**Key Changes:**
- Java compiler version: 8 → 11
- Dependencies: javax.* → jakarta.*
- Add JAXB runtime dependencies
- Update plugin versions

**Edit Template:**
```xml
<properties>
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
    <maven.compiler.release>11</maven.compiler.release>
</properties>

<dependencies>
    <dependency>
        <groupId>jakarta.platform</groupId>
        <artifactId>jakarta.jakartaee-api</artifactId>
        <version>8.0.0</version>
        <scope>provided</scope>
    </dependency>
    
    <!-- JAXB for Java 11+ compatibility -->
    <dependency>
        <groupId>jakarta.xml.bind</groupId>
        <artifactId>jakarta.xml.bind-api</artifactId>
        <version>2.3.3</version>
    </dependency>
    <dependency>
        <groupId>org.glassfish.jaxb</groupId>
        <artifactId>jaxb-runtime</artifactId>
        <version>2.3.3</version>
    </dependency>
</dependencies>
```

**Validation Command:**
```bash
mvn clean compile -Dmaven.compiler.release=11
```

**Validation Criteria:**
- [ ] Java 11 compilation succeeds
- [ ] Dependencies resolve without errors
- [ ] TodoWrite task marked as completed

---

### STEP 4: NAMESPACE MIGRATION (javax → jakarta)

**Claude Code Actions:**
1. **TodoWrite**: Add "Namespace migration" task, mark in_progress
2. **Grep**: Find all javax.* imports across codebase
3. **Read**: Examine each Java file for context
4. **Edit**: Replace javax imports with jakarta equivalents

**Target Files:**
- `websphere-cafe-web/src/main/java/cafe/model/entity/Coffee.java`
- `websphere-cafe-web/src/main/java/cafe/model/CafeRepository.java`
- `websphere-cafe-web/src/main/java/cafe/web/rest/CafeResource.java`
- `websphere-cafe-web/src/main/java/cafe/web/view/Cafe.java`

**Common Replacements:**
```java
// Replace:
import javax.xml.bind.annotation.XmlRootElement;
import javax.persistence.*;
import javax.ws.rs.*;
import javax.inject.Inject;
import javax.ejb.Stateless;

// With:
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.persistence.*;
import jakarta.ws.rs.*;
import jakarta.inject.Inject;
import jakarta.ejb.Stateless;
```

**Validation Command:**
```bash
mvn clean compile
```

**Validation Criteria:**
- [ ] All javax imports replaced with jakarta
- [ ] Java files compile without errors
- [ ] TodoWrite task marked as completed

---

### STEP 5: CONFIGURATION FILE UPDATES

**Claude Code Actions:**
1. **TodoWrite**: Add "Configuration updates" task, mark in_progress
2. **Read**: Examine XML configuration files
3. **Edit**: Update namespaces and schema locations

**Target Files:**
- `websphere-cafe-web/src/main/webapp/WEB-INF/web.xml`
- `websphere-cafe-web/src/main/webapp/WEB-INF/faces-config.xml`
- `websphere-cafe-web/src/main/webapp/WEB-INF/beans.xml`
- `websphere-cafe-web/src/main/resources/META-INF/persistence.xml`

**Key Updates:**
- Namespace: `java.sun.com` → `jakarta.ee`
- Schema versions: Update to Jakarta EE 8
- Servlet class references: Update to jakarta packages

**Validation Criteria:**
- [ ] XML files validate against Jakarta EE schemas
- [ ] Application builds successfully
- [ ] TodoWrite task marked as completed

---

### STEP 6: OPENLIBERTY CONFIGURATION

**Claude Code Actions:**
1. **TodoWrite**: Add "OpenLiberty configuration" task, mark in_progress
2. **Bash**: Create Liberty configuration directory
3. **Write**: Create `src/main/liberty/config/server.xml`
4. **Edit**: Update web module POM with Liberty plugin

**Commands:**
```bash
mkdir -p src/main/liberty/config
```

**Server Configuration Template:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<server description="WebSphere Cafe OpenLiberty Server - Java 11">
    <featureManager>
        <feature>jakartaee-8.0</feature>
        <feature>microProfile-4.1</feature>
        <feature>localConnector-1.0</feature>
    </featureManager>
    
    <httpEndpoint id="defaultHttpEndpoint" httpPort="9080" httpsPort="9443" />
    
    <application location="websphere-cafe.war" contextRoot="/websphere-cafe">
        <classloader commonLibraryRef="jaxbLib"/>
    </application>
    
    <library id="jaxbLib">
        <fileset dir="${server.config.dir}/lib" includes="jaxb-*.jar"/>
    </library>
    
    <dataSource id="WebSphereCafeDB" jndiName="jdbc/WebSphereCafeDB">
        <jdbcDriver libraryRef="derbyLib"/>
        <properties.derby.embedded databaseName="WebSphereCafeDB" createDatabase="create"/>
    </dataSource>
    
    <library id="derbyLib">
        <fileset dir="${server.config.dir}/lib" includes="derby*.jar"/>
    </library>
    
    <!-- Java 11 optimized JVM options -->
    <jvmOptions>-Xms128m</jvmOptions>
    <jvmOptions>-Xmx512m</jvmOptions>
    <jvmOptions>-XX:+UseG1GC</jvmOptions>
    <jvmOptions>-XX:MaxGCPauseMillis=200</jvmOptions>
</server>
```

**Validation Criteria:**
- [ ] Liberty server configuration created
- [ ] Configuration validates against Liberty schema
- [ ] TodoWrite task marked as completed

---

### STEP 7: TESTING & VALIDATION

**Claude Code Actions:**
1. **TodoWrite**: Add "Testing & validation" task, mark in_progress
2. **Bash**: Create test directory structure
3. **Write**: Create comprehensive test suite
4. **Bash**: Run full test cycle

**Test Structure:**
```bash
mkdir -p websphere-cafe-web/src/test/java/cafe/{model,web/rest}
```

**Test Categories:**
- **Unit Tests**: Repository and service layer testing
- **Integration Tests**: REST API endpoint testing
- **JAXB Tests**: XML marshalling/unmarshalling validation
- **Health Tests**: Application health endpoint verification

**Commands:**
```bash
# Full build and test
mvn clean package -Dmaven.compiler.release=11
mvn test -Djava.version=11

# Liberty server testing
mvn liberty:create liberty:install-feature
mvn liberty:deploy
mvn liberty:start

# Health check validation
curl -f http://localhost:9080/websphere-cafe/health

# REST API validation
curl -f http://localhost:9080/websphere-cafe/rest/coffees

# Cleanup
mvn liberty:stop
```

**Validation Criteria:**
- [ ] All unit tests pass with Java 11
- [ ] Integration tests pass (if server available)
- [ ] JAXB marshalling/unmarshalling works
- [ ] Health endpoint returns Java 11 information
- [ ] REST API responds correctly
- [ ] TodoWrite task marked as completed

---

### STEP 8: CONTAINERIZATION

**Claude Code Actions:**
1. **TodoWrite**: Add "Containerization" task, mark in_progress
2. **Write**: Create optimized Dockerfile for Java 11
3. **Write**: Create Docker Compose configuration
4. **Bash**: Build and test container

**Dockerfile Template:**
```dockerfile
FROM icr.io/appcafe/open-liberty:full-java11-openj9-ubi

# Set Java 11 environment
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Copy Liberty configuration
COPY --chown=1001:0 src/main/liberty/config/ /config/

# Copy application
COPY --chown=1001:0 target/websphere-cafe.war /config/apps/

# Java 11 optimized JVM options
ENV JVM_ARGS="-Xms128m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

EXPOSE 9080 9443
USER 1001
```

**Docker Compose Template:**
```yaml
version: '3.8'
services:
  websphere-cafe:
    build: .
    ports:
      - "9080:9080"
      - "9443:9443"
    environment:
      - JAVA_TOOL_OPTIONS=-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9080/websphere-cafe/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

**Container Validation:**
```bash
# Build and test container
docker build -t websphere-cafe:java11 .
docker run -d -p 9080:9080 --name websphere-cafe-test websphere-cafe:java11
sleep 30
curl -f http://localhost:9080/websphere-cafe/health
docker stop websphere-cafe-test && docker rm websphere-cafe-test
```

**Validation Criteria:**
- [ ] Docker image builds successfully
- [ ] Container starts with Java 11
- [ ] Health checks pass in container
- [ ] Application accessible via container
- [ ] TodoWrite task marked as completed

---

### STEP 9: FINAL VALIDATION & DOCUMENTATION

**Claude Code Actions:**
1. **TodoWrite**: Add "Final validation" task, mark in_progress
2. **Bash**: Run comprehensive validation suite
3. **Edit**: Update CLAUDE.md with new architecture
4. **TodoRead**: Verify all tasks completed

**Comprehensive Validation:**
```bash
# Full build and test cycle
mvn clean package -Dmaven.compiler.release=11
mvn test -Djava.version=11

# Liberty server validation
mvn liberty:start
curl -f http://localhost:9080/websphere-cafe/health
curl -f http://localhost:9080/websphere-cafe/rest/coffees
mvn liberty:stop

# Container validation
docker-compose up -d
sleep 30
curl -f http://localhost:9080/websphere-cafe/health
docker-compose down
```

**CLAUDE.md Updates:**
- Update build commands for Java 11 + Liberty
- Document new architecture (Jakarta EE 8 + OpenLiberty)
- Add container deployment instructions
- Include health check endpoints
- Update testing strategy

**Migration Success Criteria:**
- [ ] All 9 steps completed successfully
- [ ] Application runs on Java 11 + OpenLiberty
- [ ] All tests pass
- [ ] Health endpoints functional
- [ ] Container deployment successful
- [ ] Documentation updated
- [ ] TodoWrite shows all tasks completed

---

## ERROR HANDLING & RECOVERY

### Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| **Compilation Errors** | Missing jakarta imports | Use Grep to find all javax imports, replace systematically |
| **JAXB Binding Failures** | Missing JAXB runtime | Add explicit JAXB dependencies, validate with tests |
| **Database Connection Issues** | JNDI configuration | Update Liberty server.xml datasource configuration |
| **Container Build Failures** | Missing dependencies | Check Dockerfile COPY commands, validate file paths |
| **Performance Degradation** | G1GC tuning needed | Adjust JVM parameters in server.xml |

### Rollback Procedure

**Immediate Rollback:**
```bash
# Stop current services
mvn liberty:stop
docker-compose down

# Restore backup
cd /mnt/d
rm -rf websphere-cafe
cp -r websphere-cafe-backup-* websphere-cafe

# Verify restoration
cd websphere-cafe
mvn clean package
```

**Rollback Triggers:**
- Any step validation failure
- Compilation errors with Java 11
- Runtime errors with OpenLiberty
- Test failures
- Container build failures

### Post-Migration Recommendations

1. **Performance Monitoring**: Set up APM tools for Java 11 G1GC monitoring
2. **Security Review**: Validate Jakarta EE security configurations
3. **CI/CD Updates**: Update build pipeline for Java 11 + Liberty
4. **Documentation**: Update operational runbooks
5. **Team Training**: Jakarta EE namespace differences

---

## MIGRATION COMPLETION CHECKLIST

**Technical Validation:**
- [ ] Java 11 compilation successful
- [ ] Jakarta EE namespace migration complete
- [ ] OpenLiberty server operational
- [ ] All unit tests passing
- [ ] Integration tests passing
- [ ] JAXB marshalling functional
- [ ] Health endpoints responding
- [ ] REST API functional
- [ ] Container deployment successful
- [ ] Performance benchmarks acceptable

**Documentation & Process:**
- [ ] CLAUDE.md updated with new architecture
- [ ] Build commands updated for Java 11 + Liberty
- [ ] Container deployment documented
- [ ] All TodoWrite tasks completed
- [ ] Migration artifacts archived
- [ ] Rollback procedures tested

**Operational Readiness:**
- [ ] Monitoring configured for Java 11 runtime
- [ ] Security scan completed
- [ ] Performance baseline established
- [ ] Team trained on new architecture
- [ ] CI/CD pipeline updated

This streamlined migration plan provides systematic, trackable, and recoverable migration from Java 8 + WebSphere to Java 11 + OpenLiberty with comprehensive validation and error handling.
