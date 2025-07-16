# WebSphere Cafe Migration Execution Plan - Claude Code Agent

## AGENT EXECUTION OVERVIEW

This document provides a Claude Code agent-optimized execution plan for migrating WebSphere Cafe from Java 8 + WebSphere Application Server to Java 11 + OpenLiberty. Each step is designed for autonomous execution with clear validation checkpoints.

**Migration Path**: Java 8 + WebSphere AS → Java 11 + OpenLiberty + Container  
**Total Steps**: 32 discrete execution steps (enhanced from 25)  
**Validation Points**: 12 checkpoints with rollback procedures (enhanced from 8)  
**Agent Execution Mode**: Autonomous with TodoWrite tracking  
**Risk Assessment**: Comprehensive pre-migration analysis  
**Migration Strategy**: Phased approach with parallel environment support  

---

## AGENT EXECUTION STRATEGY

### Pre-Execution Setup
1. **Use TodoWrite** to track all 25 steps as discrete tasks
2. **Mark tasks as in_progress** before starting each step
3. **Complete tasks immediately** upon successful validation
4. **Use Read tool** extensively before making any modifications
5. **Validate after each step** before proceeding to next

### Error Handling
- **Rollback triggers**: Any validation failure stops execution
- **Backup requirement**: Create backup before starting
- **Recovery strategy**: Restore from backup and retry with adjustments

---

## RISK ASSESSMENT AND MITIGATION STRATEGIES

### High-Risk Areas Identified

#### 1. JAXB Compatibility Risk
**Risk**: JAXB removed from JDK 11 causing XML binding failures
**Impact**: Critical - REST API and entity marshalling broken
**Mitigation**: 
- Add explicit JAXB runtime dependencies
- Validate XML binding in dedicated test suite
- Implement fallback JSON support if needed

#### 2. Module System Conflicts
**Risk**: Java 11 module system conflicts with legacy libraries
**Impact**: High - Application fails to start
**Mitigation**:
- Add JVM module system bypass arguments
- Use `--add-opens` directives for reflection access
- Test with security manager disabled initially

#### 3. Performance Degradation
**Risk**: G1GC and container memory management issues
**Impact**: Medium - Application performance impacts
**Mitigation**:
- Baseline performance measurements before migration
- Implement comprehensive monitoring
- Tune G1GC parameters for container environment

#### 4. Database Connection Issues
**Risk**: JNDI datasource configuration incompatibility
**Impact**: High - Data access layer failure
**Mitigation**:
- Validate datasource configuration in Liberty
- Test connection pooling behavior
- Implement database health checks

#### 5. Security Configuration Changes
**Risk**: Jakarta EE security namespace changes break authentication
**Impact**: High - Application security compromised
**Mitigation**:
- Audit all security configurations
- Test authentication flows thoroughly
- Implement security scanning

### Risk Mitigation Timeline

1. **Pre-Migration** (Steps 0-5): Environment setup and risk validation
2. **Core Migration** (Steps 6-20): Systematic component migration
3. **Validation** (Steps 21-28): Comprehensive testing and validation
4. **Production Readiness** (Steps 29-32): Final preparations and rollback testing

---

## STEP 0: PRE-MIGRATION RISK ASSESSMENT

### Agent Actions:
1. Create comprehensive environment analysis
2. Validate current application health
3. Establish performance baselines
4. Identify potential migration blockers

### Agent Commands:
```bash
# Create migration analysis directory
mkdir -p migration-analysis

# Java environment analysis
java -version > migration-analysis/java-version-before.txt
java -XshowSettings:vm > migration-analysis/jvm-settings-before.txt

# Application health baseline
mvn clean package -DskipTests
java -jar target/websphere-cafe.war --version > migration-analysis/app-version-before.txt

# Performance baseline (if application running)
curl -o migration-analysis/performance-baseline.json \
  "http://localhost:9080/websphere-cafe/rest/coffees?benchmark=true"

# Dependency analysis
mvn dependency:tree > migration-analysis/dependency-tree-before.txt
mvn dependency:analyze > migration-analysis/dependency-analysis-before.txt

# Security scan
mvn org.owasp:dependency-check-maven:check
cp target/dependency-check-report.html migration-analysis/security-scan-before.html
```

### Agent Validation:
- [ ] Current Java 8 environment documented
- [ ] Application builds successfully
- [ ] Dependency tree analyzed for conflicts
- [ ] Security vulnerabilities catalogued
- [ ] Performance baselines established
- [ ] TodoWrite task marked as completed

---

## STEP 1: BACKUP AND PREPARATION

### Agent Actions:
1. Create backup of current codebase using Bash tool
2. Test current build using Maven
3. Document current Java version
4. Add to TodoWrite and mark as in_progress

### Agent Commands:
```bash
# Create timestamped backup
cp -r /mnt/d/websphere-cafe /mnt/d/websphere-cafe-backup-$(date +%Y%m%d_%H%M%S)

# Test current build
mvn clean package

# Document current Java version
java -version > java_version_before.txt
javac -version >> java_version_before.txt
```

### Agent Validation:
- [ ] Bash tool confirms backup created successfully
- [ ] Maven build exits with status 0
- [ ] Java version file created
- [ ] TodoWrite task marked as completed

---

## STEP 1A: DEPENDENCY COMPATIBILITY ANALYSIS

### Agent Actions:
1. Analyze all dependencies for Java 11 compatibility
2. Identify version conflicts and upgrade paths
3. Create dependency upgrade strategy
4. Validate license compatibility

### Agent Commands:
```bash
# Create dependency analysis report
mkdir -p migration-analysis/dependencies

# Check for Java 11 compatible versions
mvn versions:display-dependency-updates > migration-analysis/dependencies/available-updates.txt

# Analyze plugin compatibility
mvn versions:display-plugin-updates > migration-analysis/dependencies/plugin-updates.txt

# Check for vulnerable dependencies
mvn org.owasp:dependency-check-maven:check
cp target/dependency-check-report.html migration-analysis/dependencies/security-report.html

# License analysis
mvn license:aggregate-download-licenses
cp target/generated-resources/licenses.xml migration-analysis/dependencies/licenses.xml

# Java 11 compatibility check
mvn animal-sniffer:check -Dsignature=java18
```

### Agent Validation:
- [ ] All dependencies analyzed for Java 11 compatibility
- [ ] Upgrade path identified for incompatible dependencies
- [ ] Security vulnerabilities assessed
- [ ] License compatibility verified
- [ ] TodoWrite task marked as completed

### Critical Dependencies to Validate:
1. **JAXB Runtime**: Must add explicit dependencies for Java 11
2. **EclipseLink**: Verify version 2.7.9+ for Jakarta EE support
3. **JSF Implementation**: Ensure MyFaces 2.3+ or Mojarra 2.3+
4. **Bean Validation**: Hibernate Validator 6.0+ for Jakarta EE
5. **CDI Implementation**: Weld 3.0+ for Jakarta EE support

---

## STEP 1B: ENVIRONMENT COMPATIBILITY MATRIX

### Agent Actions:
1. Create compatibility matrix for target environment
2. Validate OpenLiberty version compatibility
3. Check container base image compatibility

### Agent File Creation:
```yaml
# migration-analysis/compatibility-matrix.yml
java_versions:
  current: "1.8.0_XXX"
  target: "11.0.XX"
  validation: "required"

jakarta_ee:
  current: "javax.* (Java EE 7)"
  target: "jakarta.* (Jakarta EE 8)"
  namespace_changes: "critical"

application_server:
  current: "WebSphere Application Server 9.0.5"
  target: "OpenLiberty 23.0.0.6"
  feature_compatibility: "validated"

dependencies:
  jaxb:
    current: "bundled_with_jdk8"
    target: "explicit_dependency_required"
    versions: "jakarta.xml.bind:2.3.3"
  
  persistence:
    current: "javax.persistence:2.1"
    target: "jakarta.persistence:2.2"
    provider: "EclipseLink 2.7.9+"
  
  cdi:
    current: "javax.enterprise:1.2"
    target: "jakarta.enterprise:2.0"
    provider: "Weld 3.0+"

container:
  base_image: "icr.io/appcafe/open-liberty:full-java11-openj9-ubi"
  java_distribution: "OpenJ9"
  optimization: "container_aware"
```

### Agent Validation:
- [ ] Compatibility matrix created
- [ ] All version conflicts identified
- [ ] Migration path validated
- [ ] TodoWrite task marked as completed

---

## STEP 2: UPDATE ROOT POM FOR JAVA 11

### Agent Actions:
1. Use Read tool to examine current `/pom.xml`
2. Use Edit tool to update compiler properties to Java 11
3. Add JAXB dependencies for Java 11 compatibility
4. Update plugin versions

### Agent File Analysis:
- **Target**: `/pom.xml`
- **Strategy**: Use Edit tool for targeted replacements
- **Validation**: Compile test after changes

### Agent Edits:
```xml
<!-- Update properties section -->
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
    <maven.compiler.release>11</maven.compiler.release>
    <maven.compiler.plugin.version>3.11.0</maven.compiler.plugin.version>
    <maven.surefire.plugin.version>3.0.0</maven.surefire.plugin.version>
    <maven.failsafe.plugin.version>3.0.0</maven.failsafe.plugin.version>
</properties>

<!-- Replace dependencies section -->
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
    
    <dependency>
        <groupId>jakarta.annotation</groupId>
        <artifactId>jakarta.annotation-api</artifactId>
        <version>1.3.5</version>
    </dependency>
</dependencies>
```

### Agent Validation:
- [ ] Bash tool: `mvn clean compile -Dmaven.compiler.release=11` succeeds
- [ ] Dependencies resolve without errors
- [ ] TodoWrite task marked as completed

---

## STEP 3: UPDATE BUILD PLUGINS

### Agent Actions:
1. Use Read tool to examine current plugin configuration
2. Use Edit tool to update Maven compiler plugin
3. Add Surefire/Failsafe plugins with Java 11 support

### Agent Edits:
```xml
<build>
    <pluginManagement>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>${maven.compiler.plugin.version}</version>
                <configuration>
                    <source>11</source>
                    <target>11</target>
                    <release>11</release>
                    <compilerArgs>
                        <arg>-parameters</arg>
                        <arg>-Xlint:deprecation</arg>
                        <arg>-Xlint:unchecked</arg>
                    </compilerArgs>
                </configuration>
            </plugin>
            
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>${maven.surefire.plugin.version}</version>
                <configuration>
                    <argLine>
                        --add-opens java.base/java.lang=ALL-UNNAMED
                        --add-opens java.base/java.util=ALL-UNNAMED
                        --add-opens java.base/java.time=ALL-UNNAMED
                    </argLine>
                </configuration>
            </plugin>
            
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-failsafe-plugin</artifactId>
                <version>${maven.failsafe.plugin.version}</version>
                <configuration>
                    <argLine>
                        --add-opens java.base/java.lang=ALL-UNNAMED
                        --add-opens java.base/java.util=ALL-UNNAMED
                    </argLine>
                </configuration>
            </plugin>
        </plugins>
    </pluginManagement>
</build>
```

### Agent Validation:
- [ ] Bash tool: `mvn clean compile` succeeds with Java 11
- [ ] TodoWrite task marked as completed

---

## STEP 4: UPDATE JAVA IMPORTS - COFFEE ENTITY

### Agent Actions:
1. Use Read tool to examine `websphere-cafe-web/src/main/java/cafe/model/entity/Coffee.java`
2. Use Edit tool to replace javax.xml.bind imports with jakarta.xml.bind
3. Update any other javax imports to jakarta

### Agent File Analysis:
- **Target**: `websphere-cafe-web/src/main/java/cafe/model/entity/Coffee.java`
- **Strategy**: Examine imports section, then replace javax.* with jakarta.*

### Agent Edits:
```java
// Replace:
import javax.xml.bind.annotation.XmlRootElement;
import javax.persistence.*;

// With:
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.persistence.*;
```

### Agent Validation:
- [ ] Bash tool: `mvn compile` succeeds
- [ ] No compilation errors for Coffee class
- [ ] TodoWrite task marked as completed

---

## STEP 5: UPDATE JAVA IMPORTS - CAFE REPOSITORY

### Agent Actions:
1. Use Read tool to examine `websphere-cafe-web/src/main/java/cafe/model/CafeRepository.java`
2. Use Edit tool to replace javax.persistence imports with jakarta.persistence

### Agent Edits:
```java
// Replace:
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

// With:
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
```

### Agent Validation:
- [ ] Bash tool: `mvn compile` succeeds
- [ ] TodoWrite task marked as completed

---

## STEP 6: UPDATE JAVA IMPORTS - CAFE RESOURCE

### Agent Actions:
1. Use Read tool to examine `websphere-cafe-web/src/main/java/cafe/web/rest/CafeResource.java`
2. Use Edit tool to replace all javax.* imports with jakarta.* imports

### Agent Edits:
```java
// Replace all javax imports:
import javax.ejb.Stateless;
import javax.inject.Inject;
import javax.persistence.PersistenceException;
import javax.ws.rs.*;
import javax.ws.rs.core.*;

// With jakarta imports:
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.persistence.PersistenceException;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
```

### Agent Validation:
- [ ] Bash tool: `mvn compile` succeeds
- [ ] TodoWrite task marked as completed

---

## STEP 7: UPDATE JAVA IMPORTS - CAFE VIEW

### Agent Actions:
1. Use Read tool to examine `websphere-cafe-web/src/main/java/cafe/web/view/Cafe.java`
2. Use Edit tool to replace all javax.* imports with jakarta.* imports

### Agent Edits:
```java
// Replace all javax imports:
import javax.annotation.PostConstruct;
import javax.enterprise.context.RequestScoped;
import javax.faces.context.FacesContext;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotNull;
import javax.ws.rs.client.*;
import javax.ws.rs.core.*;

// With jakarta imports:
import jakarta.annotation.PostConstruct;
import jakarta.enterprise.context.RequestScoped;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Named;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.constraints.NotNull;
import jakarta.ws.rs.client.*;
import jakarta.ws.rs.core.*;
```

### Agent Validation:
- [ ] Bash tool: `mvn compile` succeeds
- [ ] TodoWrite task marked as completed

---

## STEP 8: UPDATE WEB.XML CONFIGURATION

### Agent Actions:
1. Use Read tool to examine `websphere-cafe-web/src/main/webapp/WEB-INF/web.xml`
2. Use Edit tool to update namespace to Jakarta EE
3. Update servlet class references

### Agent Edits:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="4.0"
    xmlns="https://jakarta.ee/xml/ns/jakartaee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee 
                        https://jakarta.ee/xml/ns/jakartaee/web-app_4_0.xsd">
    
    <context-param>
        <param-name>jakarta.faces.PROJECT_STAGE</param-name>
        <param-value>Production</param-value>
    </context-param>
    
    <servlet>
        <servlet-name>Faces Servlet</servlet-name>
        <servlet-class>jakarta.faces.webapp.FacesServlet</servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>
    
    <servlet-mapping>
        <servlet-name>Faces Servlet</servlet-name>
        <url-pattern>*.xhtml</url-pattern>
    </servlet-mapping>

    <servlet>
        <servlet-name>jakarta.ws.rs.core.Application</servlet-name>
    </servlet>
    <servlet-mapping>
        <servlet-name>jakarta.ws.rs.core.Application</servlet-name>
        <url-pattern>/rest/*</url-pattern>
    </servlet-mapping>

    <session-config>
        <session-timeout>60</session-timeout>
    </session-config>
    
    <welcome-file-list>
        <welcome-file>index.xhtml</welcome-file>
    </welcome-file-list>
</web-app>
```

### Agent Validation:
- [ ] XML validates against Jakarta EE schema
- [ ] TodoWrite task marked as completed

---

## STEP 9: UPDATE FACES-CONFIG.XML

### Agent Actions:
1. Use Read tool to examine `websphere-cafe-web/src/main/webapp/WEB-INF/faces-config.xml`
2. Use Edit tool to update namespace and schema location

### Agent Edits:
```xml
<?xml version='1.0' encoding='UTF-8'?>
<faces-config version="3.0"
    xmlns="https://jakarta.ee/xml/ns/jakartaee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee 
                        https://jakarta.ee/xml/ns/jakartaee/web-facesconfig_3_0.xsd">
    <application>
        <resource-bundle>
            <base-name>cafe.web.messages</base-name>
            <var>messages</var>
        </resource-bundle>
        <locale-config>
            <default-locale>en</default-locale>
            <supported-locale>es</supported-locale>
        </locale-config>
    </application>
</faces-config>
```

### Agent Validation:
- [ ] XML validates against Jakarta EE schema
- [ ] TodoWrite task marked as completed

---

## STEP 10: UPDATE BEANS.XML

### Agent Actions:
1. Use Read tool to examine `websphere-cafe-web/src/main/webapp/WEB-INF/beans.xml`
2. Use Edit tool to update namespace and version

### Agent Edits:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="https://jakarta.ee/xml/ns/jakartaee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee 
                        https://jakarta.ee/xml/ns/jakartaee/beans_3_0.xsd"
    version="3.0" bean-discovery-mode="all">
</beans>
```

### Agent Validation:
- [ ] XML validates against Jakarta EE schema
- [ ] TodoWrite task marked as completed

---

## STEP 11: UPDATE PERSISTENCE.XML

### Agent Actions:
1. Use Read tool to examine `websphere-cafe-web/src/main/resources/META-INF/persistence.xml`
2. Use Edit tool to update namespace and properties

### Agent Edits:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence version="3.0"
    xmlns="https://jakarta.ee/xml/ns/persistence"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="https://jakarta.ee/xml/ns/persistence 
                        https://jakarta.ee/xml/ns/persistence/persistence_3_0.xsd">
    
    <persistence-unit name="coffees">
        <jta-data-source>jdbc/WebSphereCafeDB</jta-data-source>
        <properties>
            <property name="jakarta.persistence.schema-generation.database.action" value="create"/>
            <property name="eclipselink.logging.level.sql" value="FINE"/>
            <property name="eclipselink.logging.parameters" value="true"/>
        </properties>
    </persistence-unit>
</persistence>
```

### Agent Validation:
- [ ] XML validates against Jakarta EE schema
- [ ] TodoWrite task marked as completed

---

## STEP 12: VALIDATION CHECKPOINT - JAVA 11 MIGRATION

### Agent Actions:
1. Use Bash tool to clean and compile with Java 11
2. Run tests with Java 11 runtime
3. Validate JAXB functionality

### Agent Commands:
```bash
# Clean and compile with Java 11
mvn clean compile -Dmaven.compiler.release=11

# Run tests
mvn test -Djava.version=11
```

### Agent Validation:
- [ ] All Java files compile with Java 11
- [ ] Tests pass with Java 11 runtime
- [ ] JAXB marshalling/unmarshalling works
- [ ] Jakarta EE annotations recognized
- [ ] TodoWrite task marked as completed

**ROLLBACK TRIGGER**: If any validation fails, agent must restore from backup and report errors

---

## STEP 13: REMOVE WEBSPHERE-SPECIFIC FILES

### Agent Actions:
1. Use Bash tool to remove IBM-specific configuration files
2. Remove WebSphere EAR module directory

### Agent Commands:
```bash
# Remove WebSphere-specific files
rm -f websphere-cafe-web/src/main/webapp/WEB-INF/ibm-web-ext.xml

# Remove EAR module (using WAR-only deployment)
rm -rf websphere-cafe-application/
```

### Agent Validation:
- [ ] WebSphere-specific files removed
- [ ] Build succeeds without EAR module
- [ ] TodoWrite task marked as completed

---

## STEP 14: CREATE OPENLIBERTY SERVER CONFIGURATION

### Agent Actions:
1. Use Bash tool to create Liberty server configuration directory
2. Use Write tool to create `src/main/liberty/config/server.xml`

### Agent Commands:
```bash
# Create directory structure
mkdir -p src/main/liberty/config
```

### Agent File Creation:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<server description="WebSphere Cafe OpenLiberty Server - Java 11">
    <featureManager>
        <feature>jakartaee-8.0</feature>
        <feature>microProfile-4.1</feature>
        <feature>localConnector-1.0</feature>
    </featureManager>
    
    <httpEndpoint id="defaultHttpEndpoint"
                  httpPort="9080"
                  httpsPort="9443" />
    
    <application location="websphere-cafe.war" contextRoot="/websphere-cafe">
        <classloader commonLibraryRef="jaxbLib"/>
    </application>
    
    <!-- JAXB Library for Java 11+ -->
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
    
    <!-- Java 11 specific JVM options -->
    <jvmOptions>-Xms128m</jvmOptions>
    <jvmOptions>-Xmx512m</jvmOptions>
    <jvmOptions>-XX:+UseG1GC</jvmOptions>
    <jvmOptions>-XX:MaxGCPauseMillis=200</jvmOptions>
    
    <logging traceSpecification="*=info:cafe.*=fine"
             maxFileSize="20"
             maxFiles="10"
             traceFormat="BASIC" />
</server>
```

### Agent Validation:
- [ ] Liberty server configuration created
- [ ] Configuration validates against Liberty schema
- [ ] TodoWrite task marked as completed

---

## STEP 15: UPDATE WEB MODULE POM FOR LIBERTY

### Agent Actions:
1. Use Read tool to examine `websphere-cafe-web/pom.xml`
2. Use Edit tool to add Liberty Maven plugin
3. Update dependencies for Jakarta EE

### Agent Edits:
```xml
<properties>
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
    <maven.compiler.release>11</maven.compiler.release>
    <failOnMissingWebXml>false</failOnMissingWebXml>
</properties>

<dependencies>
    <dependency>
        <groupId>jakarta.platform</groupId>
        <artifactId>jakarta.jakartaee-api</artifactId>
        <version>8.0.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>org.eclipse.microprofile</groupId>
        <artifactId>microprofile</artifactId>
        <version>4.1</version>
        <type>pom</type>
        <scope>provided</scope>
    </dependency>
    
    <!-- Java 11 JAXB Dependencies -->
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

<build>
    <plugins>
        <plugin>
            <groupId>io.openliberty.tools</groupId>
            <artifactId>liberty-maven-plugin</artifactId>
            <version>3.8.2</version>
            <configuration>
                <serverName>websphere-cafe-server</serverName>
                <runtimeArtifact>
                    <groupId>io.openliberty</groupId>
                    <artifactId>openliberty-runtime</artifactId>
                    <version>23.0.0.6</version>
                    <type>zip</type>
                </runtimeArtifact>
                <jvmOptions>
                    <param>-Xms128m</param>
                    <param>-Xmx512m</param>
                    <param>-XX:+UseG1GC</param>
                </jvmOptions>
                <copyDependencies>
                    <dependencyGroup>
                        <location>lib</location>
                        <dependency>
                            <groupId>org.glassfish.jaxb</groupId>
                            <artifactId>jaxb-runtime</artifactId>
                        </dependency>
                        <dependency>
                            <groupId>jakarta.xml.bind</groupId>
                            <artifactId>jakarta.xml.bind-api</artifactId>
                        </dependency>
                    </dependencyGroup>
                </copyDependencies>
            </configuration>
        </plugin>
    </plugins>
</build>
```

### Agent Validation:
- [ ] Liberty plugin configured correctly
- [ ] Dependencies resolve successfully
- [ ] TodoWrite task marked as completed

---

## STEP 16: BUILD AND TEST WITH LIBERTY

### Agent Actions:
1. Use Bash tool to build application
2. Create Liberty server and install features
3. Deploy application to Liberty

### Agent Commands:
```bash
# Build application
mvn clean package -Dmaven.compiler.release=11

# Create Liberty server
mvn liberty:create liberty:install-feature

# Deploy application
mvn liberty:deploy
```

### Agent Validation:
- [ ] Application builds successfully
- [ ] Liberty server starts without errors
- [ ] Application deploys to Liberty
- [ ] TodoWrite task marked as completed

---

## STEP 17: CREATE HEALTH CHECK ENDPOINT

### Agent Actions:
1. Use Bash tool to create monitoring package directory
2. Use Write tool to create `CafeHealthCheck.java`

### Agent Commands:
```bash
mkdir -p websphere-cafe-web/src/main/java/cafe/monitoring
```

### Agent File Creation:
```java
package cafe.monitoring;

import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.Readiness;

@ApplicationScoped
@Readiness
public class CafeHealthCheck implements HealthCheck {
    
    @Override
    public HealthCheckResponse call() {
        String javaVersion = System.getProperty("java.version");
        
        return HealthCheckResponse.named("cafe-health-check")
                .withData("version", "1.0.0")
                .withData("java.version", javaVersion)
                .withData("java.vendor", System.getProperty("java.vendor"))
                .up()
                .build();
    }
}
```

### Agent Validation:
- [ ] Health check endpoint accessible
- [ ] Returns Java 11 version information
- [ ] TodoWrite task marked as completed

---

## STEP 17A: CREATE PERFORMANCE MONITORING ENDPOINT

### Agent Actions:
1. Create MicroProfile metrics endpoint for performance monitoring
2. Add JVM and application-specific metrics
3. Implement performance benchmarking utilities

### Agent Commands:
```bash
mkdir -p websphere-cafe-web/src/main/java/cafe/monitoring
```

### Agent File Creation:
```java
package cafe.monitoring;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.eclipse.microprofile.metrics.annotation.Counted;
import org.eclipse.microprofile.metrics.annotation.Timed;
import org.eclipse.microprofile.metrics.annotation.Gauge;
import org.eclipse.microprofile.metrics.MetricRegistry;
import org.eclipse.microprofile.metrics.MetricType;
import org.eclipse.microprofile.metrics.annotation.Metric;

import cafe.model.CafeRepository;

@ApplicationScoped
public class CafeMetricsService {
    
    @Inject
    private CafeRepository cafeRepository;
    
    @Inject
    @Metric(name = "cafe.coffee.requests")
    private org.eclipse.microprofile.metrics.Counter coffeeRequestCounter;
    
    @Gauge(name = "cafe.memory.used", unit = "bytes")
    public long getUsedMemory() {
        Runtime runtime = Runtime.getRuntime();
        return runtime.totalMemory() - runtime.freeMemory();
    }
    
    @Gauge(name = "cafe.memory.free", unit = "bytes")
    public long getFreeMemory() {
        return Runtime.getRuntime().freeMemory();
    }
    
    @Gauge(name = "cafe.memory.max", unit = "bytes")
    public long getMaxMemory() {
        return Runtime.getRuntime().maxMemory();
    }
    
    @Gauge(name = "cafe.coffee.total.count")
    public long getTotalCoffeeCount() {
        return cafeRepository.getAllCoffees().size();
    }
    
    @Gauge(name = "cafe.jvm.uptime", unit = "milliseconds")
    public long getJvmUptime() {
        return java.lang.management.ManagementFactory.getRuntimeMXBean().getUptime();
    }
    
    @Counted(name = "cafe.database.connections")
    @Timed(name = "cafe.database.connection.time", unit = org.eclipse.microprofile.metrics.MetricUnits.MILLISECONDS)
    public void recordDatabaseOperation() {
        // This method will be called by repository operations
    }
    
    public void recordCoffeeRequest() {
        coffeeRequestCounter.inc();
    }
}
```

### Agent Validation:
- [ ] Performance metrics endpoint created
- [ ] JVM metrics configured
- [ ] Application metrics implemented
- [ ] TodoWrite task marked as completed

---

## STEP 17B: CREATE PERFORMANCE BENCHMARKING UTILITIES

### Agent Actions:
1. Create performance benchmarking utilities
2. Add load testing endpoints
3. Implement performance comparison tools

### Agent File Creation:
```java
package cafe.monitoring;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

import cafe.model.CafeRepository;
import cafe.model.entity.Coffee;

@ApplicationScoped
@Path("/benchmark")
public class CafeBenchmarkResource {
    
    @Inject
    private CafeRepository cafeRepository;
    
    @Inject
    private CafeMetricsService metricsService;
    
    @GET
    @Path("/performance")
    @Produces(MediaType.APPLICATION_JSON)
    public Response runPerformanceBenchmark(@QueryParam("iterations") int iterations) {
        if (iterations <= 0) iterations = 100;
        
        Map<String, Object> results = new HashMap<>();
        long startTime = System.currentTimeMillis();
        
        // Memory before test
        long memoryBefore = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        
        // Database operations benchmark
        long dbStartTime = System.nanoTime();
        for (int i = 0; i < iterations; i++) {
            List<Coffee> coffees = cafeRepository.getAllCoffees();
            metricsService.recordDatabaseOperation();
        }
        long dbEndTime = System.nanoTime();
        
        // Memory after test
        long memoryAfter = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        
        long endTime = System.currentTimeMillis();
        
        results.put("test_duration_ms", endTime - startTime);
        results.put("db_operations_duration_ns", dbEndTime - dbStartTime);
        results.put("avg_db_operation_ns", (dbEndTime - dbStartTime) / iterations);
        results.put("memory_used_before_bytes", memoryBefore);
        results.put("memory_used_after_bytes", memoryAfter);
        results.put("memory_delta_bytes", memoryAfter - memoryBefore);
        results.put("iterations", iterations);
        results.put("java_version", System.getProperty("java.version"));
        results.put("java_vendor", System.getProperty("java.vendor"));
        results.put("available_processors", Runtime.getRuntime().availableProcessors());
        
        return Response.ok(results).build();
    }
    
    @GET
    @Path("/load")
    @Produces(MediaType.APPLICATION_JSON)
    public Response runLoadTest(@QueryParam("threads") int threads, @QueryParam("duration") int durationSeconds) {
        if (threads <= 0) threads = 10;
        if (durationSeconds <= 0) durationSeconds = 30;
        
        ExecutorService executor = Executors.newFixedThreadPool(threads);
        List<Future<Integer>> futures = new ArrayList<>();
        
        long startTime = System.currentTimeMillis();
        long endTime = startTime + (durationSeconds * 1000);
        
        // Submit load test tasks
        for (int i = 0; i < threads; i++) {
            Future<Integer> future = executor.submit(() -> {
                int operationCount = 0;
                while (System.currentTimeMillis() < endTime) {
                    try {
                        cafeRepository.getAllCoffees();
                        operationCount++;
                        Thread.sleep(10); // Small delay to simulate real usage
                    } catch (Exception e) {
                        // Log error but continue
                    }
                }
                return operationCount;
            });
            futures.add(future);
        }
        
        // Collect results
        int totalOperations = 0;
        for (Future<Integer> future : futures) {
            try {
                totalOperations += future.get();
            } catch (Exception e) {
                // Handle error
            }
        }
        
        executor.shutdown();
        
        Map<String, Object> results = new HashMap<>();
        results.put("total_operations", totalOperations);
        results.put("operations_per_second", totalOperations / durationSeconds);
        results.put("threads", threads);
        results.put("duration_seconds", durationSeconds);
        results.put("java_version", System.getProperty("java.version"));
        
        return Response.ok(results).build();
    }
}
```

### Agent Validation:
- [ ] Benchmarking utilities created
- [ ] Load testing endpoints functional
- [ ] Performance comparison tools available
- [ ] TodoWrite task marked as completed

---

## STEP 18: CREATE DOCKERFILE

### Agent Actions:
1. Use Write tool to create `Dockerfile` in project root

### Agent File Creation:
```dockerfile
FROM icr.io/appcafe/open-liberty:full-java11-openj9-ubi

# Set Java 11 environment
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Copy Liberty configuration
COPY --chown=1001:0 src/main/liberty/config/ /config/

# Copy application
COPY --chown=1001:0 target/websphere-cafe.war /config/apps/

# Copy shared resources
COPY --chown=1001:0 target/liberty/wlp/usr/shared/resources/ /config/resources/

# Java 11 specific JVM options
ENV JVM_ARGS="-Xms128m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

EXPOSE 9080
EXPOSE 9443

USER 1001
```

### Agent Validation:
- [ ] Dockerfile created successfully
- [ ] TodoWrite task marked as completed

---

## STEP 19: CREATE DOCKER COMPOSE

### Agent Actions:
1. Use Write tool to create `docker-compose.yml` in project root

### Agent File Creation:
```yaml
version: '3.8'
services:
  websphere-cafe:
    build: .
    ports:
      - "9080:9080"
      - "9443:9443"
    environment:
      - WLP_LOGGING_CONSOLE_LOGLEVEL=INFO
      - JAVA_TOOL_OPTIONS=-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0
      - JVM_ARGS=-Xms128m -Xmx512m -XX:+UseG1GC
    volumes:
      - ./logs:/logs
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9080/websphere-cafe/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
  
  database:
    image: postgres:13
    environment:
      POSTGRES_DB: WebSphereCafeDB
      POSTGRES_USER: cafe
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### Agent Validation:
- [ ] Docker Compose file created
- [ ] TodoWrite task marked as completed

---

## STEP 20: CREATE UNIT TESTS

### Agent Actions:
1. Use Bash tool to create test directory structure
2. Use Write tool to create `CafeRepositoryTest.java`

### Agent Commands:
```bash
mkdir -p websphere-cafe-web/src/test/java/cafe/model
```

### Agent File Creation:
```java
package cafe.model;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.Arrays;
import java.util.List;

import cafe.model.entity.Coffee;

@ExtendWith(MockitoExtension.class)
class CafeRepositoryTest {
    
    @Mock
    private EntityManager entityManager;
    
    @Mock
    private TypedQuery<Coffee> query;
    
    @InjectMocks
    private CafeRepository cafeRepository;
    
    @Test
    void testGetAllCoffees() {
        // Setup
        List<Coffee> expectedCoffees = Arrays.asList(
            new Coffee("Espresso", 2.50),
            new Coffee("Latte", 3.00)
        );
        
        when(entityManager.createNamedQuery("findAllCoffees", Coffee.class))
            .thenReturn(query);
        when(query.getResultList()).thenReturn(expectedCoffees);
        
        // Execute
        List<Coffee> result = cafeRepository.getAllCoffees();
        
        // Verify
        assertEquals(expectedCoffees, result);
        verify(entityManager).createNamedQuery("findAllCoffees", Coffee.class);
    }
    
    @Test
    void testPersistCoffee() {
        // Setup
        Coffee coffee = new Coffee("Cappuccino", 2.75);
        
        // Execute
        Coffee result = cafeRepository.persistCoffee(coffee);
        
        // Verify
        assertEquals(coffee, result);
        verify(entityManager).persist(coffee);
    }
    
    @Test
    void testRemoveCoffeeById() {
        // Setup
        Long coffeeId = 1L;
        Coffee coffee = new Coffee("Espresso", 2.50);
        coffee.setId(coffeeId);
        
        when(entityManager.find(Coffee.class, coffeeId)).thenReturn(coffee);
        
        // Execute
        cafeRepository.removeCoffeeById(coffeeId);
        
        // Verify
        verify(entityManager).find(Coffee.class, coffeeId);
        verify(entityManager).remove(coffee);
    }
    
    @Test
    void testFindCoffeeById() {
        // Setup
        Long coffeeId = 1L;
        Coffee expectedCoffee = new Coffee("Espresso", 2.50);
        expectedCoffee.setId(coffeeId);
        
        when(entityManager.find(Coffee.class, coffeeId)).thenReturn(expectedCoffee);
        
        // Execute
        Coffee result = cafeRepository.findCoffeeById(coffeeId);
        
        // Verify
        assertEquals(expectedCoffee, result);
        verify(entityManager).find(Coffee.class, coffeeId);
    }
}
```

### Agent Validation:
- [ ] Unit tests compile with Java 11
- [ ] Test directory structure created
- [ ] TodoWrite task marked as completed

---

## STEP 21: CREATE INTEGRATION TESTS

### Agent Actions:
1. Use Write tool to create `CafeResourceIT.java`

### Agent File Creation:
```java
package cafe.web.rest;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;
import static org.junit.jupiter.api.Assertions.*;

import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.core.GenericType;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

import cafe.model.entity.Coffee;

@TestMethodOrder(OrderAnnotation.class)
public class CafeResourceIT {
    
    private static final String BASE_URL = "http://localhost:9080/websphere-cafe/rest/coffees";
    private final Client client = ClientBuilder.newClient();
    
    @Test
    @Order(1)
    void testGetAllCoffees() {
        List<Coffee> coffees = client.target(BASE_URL)
                .request(MediaType.APPLICATION_XML)
                .get(new GenericType<List<Coffee>>() {});
        
        assertNotNull(coffees);
    }
    
    @Test
    @Order(2)
    void testCreateCoffee() {
        Coffee coffee = new Coffee("Integration Test Coffee", 4.50);
        
        Response response = client.target(BASE_URL)
                .request(MediaType.APPLICATION_XML)
                .post(Entity.xml(coffee));
        
        assertEquals(Response.Status.CREATED.getStatusCode(), response.getStatus());
        assertNotNull(response.getLocation());
    }
    
    @Test
    @Order(3)
    void testCreateAndRetrieveCoffee() {
        Coffee coffee = new Coffee("Test Retrieve Coffee", 3.25);
        
        Response createResponse = client.target(BASE_URL)
                .request(MediaType.APPLICATION_XML)
                .post(Entity.xml(coffee));
        
        assertEquals(Response.Status.CREATED.getStatusCode(), createResponse.getStatus());
        
        // Extract ID from location header
        String location = createResponse.getLocation().toString();
        String id = location.substring(location.lastIndexOf('/') + 1);
        
        // Retrieve the coffee
        Coffee retrievedCoffee = client.target(BASE_URL + "/" + id)
                .request(MediaType.APPLICATION_XML)
                .get(Coffee.class);
        
        assertNotNull(retrievedCoffee);
        assertEquals("Test Retrieve Coffee", retrievedCoffee.getName());
        assertEquals(3.25, retrievedCoffee.getPrice());
    }
}
```

### Agent Validation:
- [ ] Integration tests compile
- [ ] TodoWrite task marked as completed

---

## STEP 22: CREATE JAXB COMPATIBILITY TESTS

### Agent Actions:
1. Use Write tool to create `CoffeeJaxbTest.java`

### Agent File Creation:
```java
package cafe.model.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.Marshaller;
import jakarta.xml.bind.Unmarshaller;
import java.io.StringReader;
import java.io.StringWriter;

class CoffeeJaxbTest {
    
    @Test
    void testXmlMarshalling() throws JAXBException {
        Coffee coffee = new Coffee("Espresso", 2.50);
        coffee.setId(1L);
        
        JAXBContext context = JAXBContext.newInstance(Coffee.class);
        Marshaller marshaller = context.createMarshaller();
        marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
        
        StringWriter writer = new StringWriter();
        marshaller.marshal(coffee, writer);
        
        String xml = writer.toString();
        assertTrue(xml.contains("<coffee>"));
        assertTrue(xml.contains("<name>Espresso</name>"));
        assertTrue(xml.contains("<price>2.5</price>"));
    }
    
    @Test
    void testXmlUnmarshalling() throws JAXBException {
        String xml = """
            <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
            <coffee>
                <id>1</id>
                <name>Latte</name>
                <price>3.0</price>
            </coffee>
            """;
        
        JAXBContext context = JAXBContext.newInstance(Coffee.class);
        Unmarshaller unmarshaller = context.createUnmarshaller();
        
        Coffee coffee = (Coffee) unmarshaller.unmarshal(new StringReader(xml));
        
        assertEquals(1L, coffee.getId());
        assertEquals("Latte", coffee.getName());
        assertEquals(3.0, coffee.getPrice());
    }
    
    @Test
    void testRoundTripMarshalling() throws JAXBException {
        Coffee originalCoffee = new Coffee("Cappuccino", 2.75);
        originalCoffee.setId(42L);
        
        JAXBContext context = JAXBContext.newInstance(Coffee.class);
        
        // Marshall to XML
        Marshaller marshaller = context.createMarshaller();
        StringWriter writer = new StringWriter();
        marshaller.marshal(originalCoffee, writer);
        String xml = writer.toString();
        
        // Unmarshall back to object
        Unmarshaller unmarshaller = context.createUnmarshaller();
        Coffee roundTripCoffee = (Coffee) unmarshaller.unmarshal(new StringReader(xml));
        
        assertEquals(originalCoffee.getId(), roundTripCoffee.getId());
        assertEquals(originalCoffee.getName(), roundTripCoffee.getName());
        assertEquals(originalCoffee.getPrice(), roundTripCoffee.getPrice());
    }
}
```

### Agent Validation:
- [ ] JAXB tests compile with Java 11
- [ ] TodoWrite task marked as completed

---

## STEP 22A: SECURITY CONFIGURATION VALIDATION

### Agent Actions:
1. Create comprehensive security configuration validation
2. Implement security scanning utilities
3. Add security health checks

### Agent Commands:
```bash
mkdir -p websphere-cafe-web/src/main/java/cafe/security
```

### Agent File Creation:
```java
package cafe.security;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.security.Security;

@ApplicationScoped
@Path("/security")
public class SecurityValidationResource {
    
    @GET
    @Path("/scan")
    @Produces(MediaType.APPLICATION_JSON)
    public Response performSecurityScan() {
        Map<String, Object> results = new HashMap<>();
        List<String> issues = new ArrayList<>();
        List<String> recommendations = new ArrayList<>();
        
        // Check Java version for security
        String javaVersion = System.getProperty("java.version");
        if (javaVersion.startsWith("1.8")) {
            issues.add("Java 8 detected - upgrade to Java 11 for security improvements");
        } else {
            results.put("java_version_status", "acceptable");
        }
        
        // Check security providers
        String[] providers = Security.getProviders()[0].getName().split("\\.");
        results.put("security_providers", providers);
        
        // Check system properties for security
        String[] securityProps = {
            "java.security.policy",
            "java.security.manager",
            "javax.net.ssl.trustStore",
            "javax.net.ssl.keyStore"
        };
        
        Map<String, String> securitySettings = new HashMap<>();
        for (String prop : securityProps) {
            String value = System.getProperty(prop);
            securitySettings.put(prop, value != null ? value : "not_set");
        }
        results.put("security_settings", securitySettings);
        
        // Check for development mode indicators
        String stage = System.getProperty("jakarta.faces.PROJECT_STAGE");
        if ("Development".equals(stage)) {
            issues.add("Application running in development mode - ensure production mode for deployment");
        }
        
        // Security recommendations
        recommendations.add("Enable HTTPS in production");
        recommendations.add("Configure proper session timeout");
        recommendations.add("Implement CSRF protection");
        recommendations.add("Enable security headers");
        recommendations.add("Configure proper CORS settings");
        
        results.put("security_issues", issues);
        results.put("recommendations", recommendations);
        results.put("scan_timestamp", System.currentTimeMillis());
        
        return Response.ok(results).build();
    }
    
    @GET
    @Path("/headers")
    @Produces(MediaType.APPLICATION_JSON)
    public Response checkSecurityHeaders() {
        Map<String, Object> results = new HashMap<>();
        List<String> recommendedHeaders = new ArrayList<>();
        
        // Security headers that should be configured
        recommendedHeaders.add("X-Content-Type-Options: nosniff");
        recommendedHeaders.add("X-Frame-Options: DENY");
        recommendedHeaders.add("X-XSS-Protection: 1; mode=block");
        recommendedHeaders.add("Strict-Transport-Security: max-age=31536000; includeSubDomains");
        recommendedHeaders.add("Content-Security-Policy: default-src 'self'");
        recommendedHeaders.add("Referrer-Policy: strict-origin-when-cross-origin");
        
        results.put("recommended_headers", recommendedHeaders);
        results.put("configuration_location", "server.xml or web.xml");
        
        return Response.ok(results).build();
    }
}
```

### Agent Validation:
- [ ] Security validation endpoint created
- [ ] Security scanning utilities implemented
- [ ] Security configuration checked
- [ ] TodoWrite task marked as completed

---

## STEP 22B: CREATE SECURITY HEALTH CHECK

### Agent Actions:
1. Create security-focused health check
2. Add security configuration validation

### Agent File Creation:
```java
package cafe.security;

import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.Liveness;

@ApplicationScoped
@Liveness
public class SecurityHealthCheck implements HealthCheck {
    
    @Override
    public HealthCheckResponse call() {
        boolean isSecure = true;
        HealthCheckResponse.HealthCheckResponseBuilder builder = HealthCheckResponse.named("security-health-check");
        
        // Check Java version
        String javaVersion = System.getProperty("java.version");
        builder.withData("java.version", javaVersion);
        
        if (javaVersion.startsWith("1.8")) {
            isSecure = false;
            builder.withData("java.version.status", "upgrade_required");
        } else {
            builder.withData("java.version.status", "acceptable");
        }
        
        // Check for development mode
        String stage = System.getProperty("jakarta.faces.PROJECT_STAGE");
        builder.withData("project.stage", stage != null ? stage : "not_set");
        
        if ("Development".equals(stage)) {
            builder.withData("project.stage.warning", "development_mode_detected");
        }
        
        // Check security manager
        SecurityManager sm = System.getSecurityManager();
        builder.withData("security.manager.enabled", sm != null);
        
        // Check SSL configuration
        String trustStore = System.getProperty("javax.net.ssl.trustStore");
        String keyStore = System.getProperty("javax.net.ssl.keyStore");
        builder.withData("ssl.truststore.configured", trustStore != null);
        builder.withData("ssl.keystore.configured", keyStore != null);
        
        return isSecure ? builder.up().build() : builder.down().build();
    }
}
```

### Agent Validation:
- [ ] Security health check implemented
- [ ] Security configuration monitored
- [ ] TodoWrite task marked as completed

---

## STEP 22C: UPDATE LIBERTY SERVER.XML WITH SECURITY FEATURES

### Agent Actions:
1. Update Liberty server.xml with security features
2. Add security-related configuration

### Agent Edits:
```xml
<!-- Add to server.xml after existing features -->
<featureManager>
    <feature>jakartaee-8.0</feature>
    <feature>microProfile-4.1</feature>
    <feature>localConnector-1.0</feature>
    <feature>transportSecurity-1.0</feature>
    <feature>appSecurity-3.0</feature>
    <feature>sessionDatabase-1.0</feature>
</featureManager>

<!-- Security configuration -->
<webAppSecurity httpOnlyCookies="true" 
                secureSessionCookies="true"
                ssoRequiresSSL="true"
                useAuthenticationDataForUnprotectedResource="true"/>

<!-- Session configuration -->
<httpSession invalidationTimeout="30m" 
             cookieSecure="true" 
             cookieHttpOnly="true"
             cookieSameSite="strict"/>

<!-- SSL configuration -->
<ssl id="defaultSSLConfig" 
     keyStoreRef="defaultKeyStore" 
     clientAuthenticationSupported="false"/>

<keyStore id="defaultKeyStore" 
          password="password" 
          location="security/key.p12" 
          type="PKCS12"/>

<!-- Security headers -->
<webContainer>
    <security-headers>
        <header name="X-Content-Type-Options" value="nosniff"/>
        <header name="X-Frame-Options" value="DENY"/>
        <header name="X-XSS-Protection" value="1; mode=block"/>
        <header name="Strict-Transport-Security" value="max-age=31536000; includeSubDomains"/>
        <header name="Content-Security-Policy" value="default-src 'self'"/>
        <header name="Referrer-Policy" value="strict-origin-when-cross-origin"/>
    </security-headers>
</webContainer>
```

### Agent Validation:
- [ ] Security features added to server.xml
- [ ] Security headers configured
- [ ] SSL configuration added
- [ ] Session security configured
- [ ] TodoWrite task marked as completed

---

## STEP 23: UPDATE CLAUDE.MD

### Agent Actions:
1. Use Read tool to examine current `CLAUDE.md`
2. Use Edit tool to update build commands for Java 11 + Liberty

### Agent Edits:
```markdown
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Build Commands
- `mvn clean package -Dmaven.compiler.release=11` - Clean and build with Java 11
- `mvn clean compile -Djava.version=11` - Compile with Java 11
- `mvn liberty:create liberty:install-feature` - Create Liberty server and install features
- `mvn liberty:deploy` - Deploy application to Liberty server
- `mvn liberty:dev` - Run Liberty in development mode with hot reload

### Testing Commands
- `mvn test -Djava.version=11` - Run unit tests with Java 11
- `mvn verify -Pit -Djava.version=11` - Run integration tests
- `mvn liberty:start` - Start Liberty server for integration testing
- `mvn liberty:stop` - Stop Liberty server

### Container Commands
- `docker build -t websphere-cafe:latest .` - Build Docker image
- `docker-compose up` - Start application with Docker Compose
- `docker-compose down` - Stop Docker Compose services

### Generated Artifacts
- Main artifact: `websphere-cafe-web/target/websphere-cafe.war`
- Liberty server: `target/liberty/wlp/usr/servers/websphere-cafe-server`

## Architecture Overview

This is a Jakarta EE 8 single-module Maven project running on OpenLiberty with Java 11:

### Technology Stack
- **Java 11** (upgraded from Java 8)
- **Jakarta EE 8** (upgraded from Java EE 7)
- **OpenLiberty** (migrated from WebSphere Application Server)
- **Maven 3.5.0+** for build management
- **Docker** for containerization

### Key Components

#### Data Layer
- **CafeRepository** (`cafe.model.CafeRepository`): JPA repository for Coffee entity operations
- **Coffee Entity** (`cafe.model.entity.Coffee`): JPA entity with JAXB XML binding
- **Persistence Context**: Uses JNDI name `jdbc/WebSphereCafeDB`

#### REST API Layer
- **CafeResource** (`cafe.web.rest.CafeResource`): JAX-RS resource at `/rest/coffees`
- Supports full CRUD operations (GET, POST, DELETE)
- Produces/consumes XML media type

#### Web Layer
- **Cafe View** (`cafe.web.view.Cafe`): JSF backing bean
- **JSF Pages**: Located in `webapp/` directory with XHTML templates
- **Context Root**: `/websphere-cafe`

#### Monitoring Layer
- **CafeHealthCheck** (`cafe.monitoring.CafeHealthCheck`): MicroProfile health check
- **Health Endpoint**: `/health` - Shows application and Java version status
- **Metrics**: Available at `/metrics` endpoint

### OpenLiberty Configuration
- **Server Config**: `src/main/liberty/config/server.xml`
- **Features**: `jakartaee-8.0`, `microProfile-4.1`
- **Libraries**: JAXB runtime for Java 11 compatibility
- **JVM Options**: G1GC with optimized heap settings

### Development Environment
- **Liberty Dev Mode**: `mvn liberty:dev` for hot reload development
- **Health Check**: `http://localhost:9080/websphere-cafe/health`
- **Application**: `http://localhost:9080/websphere-cafe`
- **REST API**: `http://localhost:9080/websphere-cafe/rest/coffees`

### Containerization
- **Base Image**: `icr.io/appcafe/open-liberty:full-java11-openj9-ubi`
- **Java 11 Support**: Optimized JVM arguments for container deployment
- **Health Checks**: Container health monitoring enabled
- **Development**: Docker Compose configuration available

### Testing Strategy
- **Unit Tests**: JUnit 5 with Mockito for component testing
- **Integration Tests**: JAX-RS client testing against Liberty server
- **JAXB Tests**: XML marshalling/unmarshalling validation
- **Health Tests**: MicroProfile health endpoint validation

### Migration Notes
- **Namespace Changes**: All `javax.*` imports updated to `jakarta.*`
- **JAXB Support**: Runtime dependencies added for Java 11 compatibility
- **Configuration Updates**: XML files updated to Jakarta EE namespaces
- **Container Optimizations**: Java 11 G1GC and container-aware JVM settings
```

### Agent Validation:
- [ ] CLAUDE.md updated with Java 11 + Liberty information
- [ ] TodoWrite task marked as completed

---

## STEP 24: FINAL VALIDATION CHECKPOINT

### Agent Actions:
1. Use Bash tool to run complete build and test cycle
2. Start Liberty server and verify application
3. Test health endpoints and REST API

### Agent Commands:
```bash
# Full build and test
mvn clean package -Dmaven.compiler.release=11
mvn test -Djava.version=11

# Start Liberty server
mvn liberty:start

# Test health endpoint
curl -f http://localhost:9080/websphere-cafe/health

# Test REST API
curl -f http://localhost:9080/websphere-cafe/rest/coffees

# Stop Liberty server
mvn liberty:stop
```

### Agent Validation:
- [ ] Complete build succeeds with Java 11
- [ ] All unit tests pass
- [ ] Integration tests pass (if server available)
- [ ] JAXB tests pass
- [ ] Health endpoint returns Java 11 information
- [ ] REST API responds correctly
- [ ] Application accessible in browser
- [ ] TodoWrite task marked as completed

---

## STEP 24A: ENVIRONMENT-SPECIFIC CONFIGURATION

### Agent Actions:
1. Create environment-specific configuration files
2. Add configuration management utilities
3. Implement environment detection

### Agent Commands:
```bash
# Create environment configuration directory
mkdir -p src/main/liberty/config/environments/{dev,test,staging,prod}
mkdir -p src/main/resources/environments/{dev,test,staging,prod}
```

### Agent File Creation - Development Environment:
```xml
<!-- src/main/liberty/config/environments/dev/server.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<server description="WebSphere Cafe - Development Environment">
    <featureManager>
        <feature>jakartaee-8.0</feature>
        <feature>microProfile-4.1</feature>
        <feature>localConnector-1.0</feature>
        <feature>logstashCollector-1.0</feature>
    </featureManager>
    
    <!-- Development-specific settings -->
    <httpEndpoint id="defaultHttpEndpoint" httpPort="9080" httpsPort="9443" />
    
    <application location="websphere-cafe.war" contextRoot="/websphere-cafe">
        <classloader commonLibraryRef="jaxbLib"/>
    </application>
    
    <library id="jaxbLib">
        <fileset dir="${server.config.dir}/lib" includes="jaxb-*.jar"/>
    </library>
    
    <!-- Development database - Derby embedded -->
    <dataSource id="WebSphereCafeDB" jndiName="jdbc/WebSphereCafeDB">
        <jdbcDriver libraryRef="derbyLib"/>
        <properties.derby.embedded databaseName="WebSphereCafeDB_DEV" createDatabase="create"/>
    </dataSource>
    
    <library id="derbyLib">
        <fileset dir="${server.config.dir}/lib" includes="derby*.jar"/>
    </library>
    
    <!-- Development JVM options -->
    <jvmOptions>-Xms64m</jvmOptions>
    <jvmOptions>-Xmx256m</jvmOptions>
    <jvmOptions>-XX:+UseG1GC</jvmOptions>
    <jvmOptions>-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:7777</jvmOptions>
    
    <!-- Development logging -->
    <logging traceSpecification="*=info:cafe.*=all" 
             maxFileSize="50" 
             maxFiles="5" 
             traceFormat="ENHANCED" 
             consoleLogLevel="INFO"/>
    
    <!-- Development-specific variables -->
    <variable name="CAFE_ENV" value="development"/>
    <variable name="CAFE_DEBUG" value="true"/>
    <variable name="CAFE_LOG_LEVEL" value="debug"/>
</server>
```

### Agent File Creation - Production Environment:
```xml
<!-- src/main/liberty/config/environments/prod/server.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<server description="WebSphere Cafe - Production Environment">
    <featureManager>
        <feature>jakartaee-8.0</feature>
        <feature>microProfile-4.1</feature>
        <feature>transportSecurity-1.0</feature>
        <feature>appSecurity-3.0</feature>
        <feature>sessionDatabase-1.0</feature>
        <feature>logstashCollector-1.0</feature>
    </featureManager>
    
    <!-- Production-specific settings -->
    <httpEndpoint id="defaultHttpEndpoint" 
                  httpPort="9080" 
                  httpsPort="9443"
                  host="*" />
    
    <application location="websphere-cafe.war" contextRoot="/websphere-cafe">
        <classloader commonLibraryRef="jaxbLib"/>
    </application>
    
    <library id="jaxbLib">
        <fileset dir="${server.config.dir}/lib" includes="jaxb-*.jar"/>
    </library>
    
    <!-- Production database - PostgreSQL -->
    <dataSource id="WebSphereCafeDB" 
                jndiName="jdbc/WebSphereCafeDB"
                connectionManagerRef="conMgr1">
        <jdbcDriver libraryRef="postgresql-library"/>
        <properties.postgresql 
            serverName="${env.DB_HOST}" 
            portNumber="${env.DB_PORT}" 
            databaseName="${env.DB_NAME}" 
            user="${env.DB_USER}" 
            password="${env.DB_PASSWORD}"/>
    </dataSource>
    
    <connectionManager id="conMgr1" 
                       maxPoolSize="20" 
                       minPoolSize="5" 
                       reapTime="3m" 
                       maxIdleTime="30m" 
                       connectionTimeout="30s"/>
    
    <library id="postgresql-library">
        <fileset dir="${server.config.dir}/lib" includes="postgresql*.jar"/>
    </library>
    
    <!-- Production JVM options -->
    <jvmOptions>-Xms512m</jvmOptions>
    <jvmOptions>-Xmx2048m</jvmOptions>
    <jvmOptions>-XX:+UseG1GC</jvmOptions>
    <jvmOptions>-XX:MaxGCPauseMillis=100</jvmOptions>
    <jvmOptions>-XX:G1HeapRegionSize=16m</jvmOptions>
    <jvmOptions>-XX:+UseContainerSupport</jvmOptions>
    <jvmOptions>-XX:MaxRAMPercentage=75.0</jvmOptions>
    
    <!-- Production logging -->
    <logging traceSpecification="*=info:cafe.*=info" 
             maxFileSize="100" 
             maxFiles="10" 
             traceFormat="BASIC" 
             consoleLogLevel="WARNING"/>
    
    <!-- Security configuration -->
    <webAppSecurity httpOnlyCookies="true" 
                    secureSessionCookies="true"
                    ssoRequiresSSL="true"/>
    
    <httpSession invalidationTimeout="30m" 
                 cookieSecure="true" 
                 cookieHttpOnly="true"
                 cookieSameSite="strict"/>
    
    <ssl id="defaultSSLConfig" keyStoreRef="defaultKeyStore"/>
    <keyStore id="defaultKeyStore" 
              password="${env.SSL_KEYSTORE_PASSWORD}" 
              location="${env.SSL_KEYSTORE_PATH}" 
              type="PKCS12"/>
    
    <!-- Production-specific variables -->
    <variable name="CAFE_ENV" value="production"/>
    <variable name="CAFE_DEBUG" value="false"/>
    <variable name="CAFE_LOG_LEVEL" value="info"/>
</server>
```

### Agent File Creation - Environment Configuration Utility:
```java
package cafe.config;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.annotation.PostConstruct;
import java.util.Properties;
import java.io.InputStream;
import java.util.logging.Logger;

@ApplicationScoped
public class EnvironmentConfigurationService {
    
    private static final Logger logger = Logger.getLogger(EnvironmentConfigurationService.class.getName());
    
    private Properties envProperties;
    private String currentEnvironment;
    
    @PostConstruct
    public void init() {
        currentEnvironment = determineEnvironment();
        loadEnvironmentProperties();
        logger.info("Initialized configuration for environment: " + currentEnvironment);
    }
    
    private String determineEnvironment() {
        // Check system property first
        String env = System.getProperty("CAFE_ENV");
        if (env != null) {
            return env;
        }
        
        // Check environment variable
        env = System.getenv("CAFE_ENV");
        if (env != null) {
            return env;
        }
        
        // Check Liberty server name
        String serverName = System.getProperty("wlp.server.name");
        if (serverName != null) {
            if (serverName.contains("prod")) return "production";
            if (serverName.contains("stage")) return "staging";
            if (serverName.contains("test")) return "test";
        }
        
        // Default to development
        return "development";
    }
    
    private void loadEnvironmentProperties() {
        envProperties = new Properties();
        String propertiesFile = "/environments/" + currentEnvironment + "/application.properties";
        
        try (InputStream is = getClass().getResourceAsStream(propertiesFile)) {
            if (is != null) {
                envProperties.load(is);
                logger.info("Loaded environment properties from: " + propertiesFile);
            } else {
                logger.warning("Environment properties file not found: " + propertiesFile);
            }
        } catch (Exception e) {
            logger.severe("Error loading environment properties: " + e.getMessage());
        }
    }
    
    public String getCurrentEnvironment() {
        return currentEnvironment;
    }
    
    public String getProperty(String key) {
        return envProperties.getProperty(key);
    }
    
    public String getProperty(String key, String defaultValue) {
        return envProperties.getProperty(key, defaultValue);
    }
    
    public boolean isProduction() {
        return "production".equals(currentEnvironment);
    }
    
    public boolean isDevelopment() {
        return "development".equals(currentEnvironment);
    }
    
    public boolean isTest() {
        return "test".equals(currentEnvironment);
    }
}
```

### Agent Validation:
- [ ] Environment-specific configurations created
- [ ] Configuration management utility implemented
- [ ] Environment detection working
- [ ] TodoWrite task marked as completed

---

## STEP 24B: ENVIRONMENT-SPECIFIC DOCKER CONFIGURATIONS

### Agent Actions:
1. Create environment-specific Docker configurations
2. Add Docker Compose configurations for different environments

### Agent File Creation - Development Docker Compose:
```yaml
# docker-compose.dev.yml
version: '3.8'
services:
  websphere-cafe-dev:
    build: 
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "9080:9080"
      - "9443:9443"
      - "7777:7777"  # Debug port
    environment:
      - CAFE_ENV=development
      - CAFE_DEBUG=true
      - CAFE_LOG_LEVEL=debug
      - WLP_LOGGING_CONSOLE_LOGLEVEL=INFO
      - JAVA_TOOL_OPTIONS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:7777
    volumes:
      - ./logs:/logs
      - ./src/main/liberty/config/environments/dev:/config
    depends_on:
      - derby-dev
    networks:
      - cafe-dev-network

  derby-dev:
    image: timveil/derby-db:latest
    ports:
      - "1527:1527"
    environment:
      - DERBY_DATABASE=WebSphereCafeDB_DEV
    volumes:
      - derby_dev_data:/var/lib/derby/data
    networks:
      - cafe-dev-network

volumes:
  derby_dev_data:

networks:
  cafe-dev-network:
```

### Agent File Creation - Production Docker Compose:
```yaml
# docker-compose.prod.yml
version: '3.8'
services:
  websphere-cafe-prod:
    build: 
      context: .
      dockerfile: Dockerfile.prod
    ports:
      - "9080:9080"
      - "9443:9443"
    environment:
      - CAFE_ENV=production
      - CAFE_DEBUG=false
      - CAFE_LOG_LEVEL=info
      - DB_HOST=postgres-prod
      - DB_PORT=5432
      - DB_NAME=WebSphereCafeDB
      - DB_USER=cafe_user
      - DB_PASSWORD_FILE=/run/secrets/db_password
      - SSL_KEYSTORE_PATH=/run/secrets/ssl_keystore
      - SSL_KEYSTORE_PASSWORD_FILE=/run/secrets/ssl_keystore_password
      - JAVA_TOOL_OPTIONS=-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0
    volumes:
      - ./logs:/logs
      - ./src/main/liberty/config/environments/prod:/config
    depends_on:
      - postgres-prod
    secrets:
      - db_password
      - ssl_keystore
      - ssl_keystore_password
    networks:
      - cafe-prod-network
    healthcheck:
      test: ["CMD", "curl", "-f", "https://localhost:9443/websphere-cafe/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
        reservations:
          memory: 512M
          cpus: '0.5'

  postgres-prod:
    image: postgres:13
    environment:
      - POSTGRES_DB=WebSphereCafeDB
      - POSTGRES_USER=cafe_user
      - POSTGRES_PASSWORD_FILE=/run/secrets/db_password
    volumes:
      - postgres_prod_data:/var/lib/postgresql/data
    secrets:
      - db_password
    networks:
      - cafe-prod-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U cafe_user -d WebSphereCafeDB"]
      interval: 30s
      timeout: 10s
      retries: 5

secrets:
  db_password:
    file: ./secrets/db_password.txt
  ssl_keystore:
    file: ./secrets/keystore.p12
  ssl_keystore_password:
    file: ./secrets/keystore_password.txt

volumes:
  postgres_prod_data:

networks:
  cafe-prod-network:
```

### Agent Validation:
- [ ] Environment-specific Docker configurations created
- [ ] Production security configurations implemented
- [ ] Development debugging configurations added
- [ ] TodoWrite task marked as completed

---

## STEP 25: CONTAINERIZATION VALIDATION

### Agent Actions:
1. Use Bash tool to build Docker image
2. Start container and verify application
3. Test health checks in container environment

### Agent Commands:
```bash
# Build Docker image
docker build -t websphere-cafe:java11 .

# Start container
docker run -d -p 9080:9080 --name websphere-cafe-test websphere-cafe:java11

# Wait for startup
sleep 30

# Test health endpoint
curl -f http://localhost:9080/websphere-cafe/health

# Test REST API
curl -f http://localhost:9080/websphere-cafe/rest/coffees

# Stop and remove container
docker stop websphere-cafe-test
docker rm websphere-cafe-test
```

### Agent Validation:
- [ ] Docker image builds successfully
- [ ] Container starts with Java 11
- [ ] Health checks pass in container
- [ ] Application accessible via container
- [ ] REST API functions correctly
- [ ] TodoWrite task marked as completed

---

## AGENT EXECUTION COMPLETION

### Final Agent Report:
1. **TodoRead** to show all completed tasks
2. **Summary** of migration success
3. **Validation** of all 25 steps completed
4. **Recommendations** for production deployment

### Migration Success Criteria:
- [ ] All 25 steps completed successfully
- [ ] Application runs on Java 11 + OpenLiberty
- [ ] All tests pass
- [ ] Health endpoints functional
- [ ] Container deployment successful
- [ ] Documentation updated

### Post-Migration Recommendations:
1. **Performance Testing**: Load test with Java 11 G1GC
2. **Security Review**: Validate Jakarta EE security configurations
3. **Monitoring Setup**: Configure application monitoring
4. **Backup Strategy**: Implement automated backups
5. **CI/CD Pipeline**: Update build pipeline for Java 11

---

## AGENT ROLLBACK PROCEDURES

### Rollback Triggers:
- Any step validation failure
- Compilation errors with Java 11
- Runtime errors with OpenLiberty
- Test failures
- Container build failures

### Rollback Actions:
1. **Stop execution** immediately
2. **Restore from backup** created in Step 1
3. **Report specific error** that triggered rollback
4. **Recommend manual intervention** for complex issues
5. **Update TodoWrite** to reflect rollback status

### Error Recovery:
- **Analysis Phase**: Examine error logs and stack traces
- **Resolution Phase**: Fix specific issues and retry
- **Validation Phase**: Ensure fix resolves the problem
- **Continuation Phase**: Resume from failed step

---

## AGENT SUCCESS METRICS

### Completion Metrics:
- **Steps Completed**: 25/25
- **Build Success**: Java 11 compilation successful
- **Test Success**: All tests passing
- **Runtime Success**: OpenLiberty server operational
- **Container Success**: Docker deployment functional

### Quality Metrics:
- **Code Coverage**: Unit tests cover repository layer
- **Integration Coverage**: REST API endpoints validated
- **Performance**: Application startup time acceptable
- **Security**: Jakarta EE security configurations applied
- **Documentation**: CLAUDE.md updated with new architecture

This agent-optimized execution plan ensures systematic, trackable, and recoverable migration from Java 8 + WebSphere to Java 11 + OpenLiberty with full containerization support.

---

## GRADUAL MIGRATION STRATEGY (ALTERNATIVE APPROACH)

### Phase 1: Parallel Environment Setup (1-2 weeks)
**Goal**: Establish Java 11 + OpenLiberty environment alongside existing WebSphere

#### Phase 1 Steps:
1. **Environment Setup**
   - Create separate development environment with Java 11 + OpenLiberty
   - Configure CI/CD pipeline for parallel builds
   - Set up monitoring and logging for both environments

2. **Basic Application Migration**
   - Migrate simple, stateless components first
   - Update namespace imports (javax → jakarta)
   - Basic functionality testing

3. **Validation**
   - Compare performance metrics between environments
   - Validate core functionality parity
   - Test data access layer compatibility

### Phase 2: Feature-by-Feature Migration (2-4 weeks)
**Goal**: Migrate application features incrementally with rollback capability

#### Phase 2 Steps:
1. **REST API Migration**
   - Migrate CafeResource to Jakarta EE namespace
   - Test XML marshalling/unmarshalling
   - Validate REST endpoints functionality

2. **Web Layer Migration**
   - Migrate JSF components
   - Update faces-config.xml and web.xml
   - Test user interface functionality

3. **Data Layer Migration**
   - Migrate JPA entities and repositories
   - Update persistence.xml configuration
   - Test database connectivity and operations

4. **Monitoring and Health Checks**
   - Add health check endpoints
   - Implement performance monitoring
   - Configure logging and metrics

### Phase 3: Production Cutover (1 week)
**Goal**: Complete migration with minimal downtime

#### Phase 3 Steps:
1. **Pre-Cutover Validation**
   - Full regression testing
   - Performance benchmarking
   - Security validation
   - Load testing

2. **Cutover Execution**
   - Blue-green deployment strategy
   - Database migration if needed
   - DNS/Load balancer updates
   - Monitoring during cutover

3. **Post-Cutover Validation**
   - Application functionality verification
   - Performance monitoring
   - Error rate analysis
   - User acceptance testing

### Rollback Strategy for Gradual Migration:
- **Immediate Rollback**: DNS/Load balancer switch back to WebSphere
- **Database Rollback**: Database snapshot restoration if schema changes
- **Application Rollback**: Previous version deployment capability
- **Monitoring**: Automated alerts for performance degradation or errors

---

## ENHANCED BACKUP AND RECOVERY PROCEDURES

### Comprehensive Backup Strategy

#### Pre-Migration Backup Checklist:
1. **Full System Backup**
   ```bash
   # Create timestamped backup directory
   BACKUP_DIR="/backup/websphere-cafe-migration-$(date +%Y%m%d_%H%M%S)"
   mkdir -p "$BACKUP_DIR"
   
   # Backup entire codebase
   tar -czf "$BACKUP_DIR/websphere-cafe-codebase.tar.gz" /mnt/d/websphere-cafe
   
   # Backup Java environment
   java -version > "$BACKUP_DIR/java-version.txt"
   echo $JAVA_HOME > "$BACKUP_DIR/java-home.txt"
   
   # Backup Maven settings
   cp ~/.m2/settings.xml "$BACKUP_DIR/maven-settings.xml"
   
   # Backup system environment variables
   printenv | grep -E "JAVA|MAVEN|PATH" > "$BACKUP_DIR/environment-variables.txt"
   ```

2. **Database Backup**
   ```bash
   # Derby database backup
   cp -r $DERBY_HOME/databases "$BACKUP_DIR/derby-databases"
   
   # PostgreSQL backup (if using PostgreSQL)
   pg_dump -U cafe_user WebSphereCafeDB > "$BACKUP_DIR/postgres-backup.sql"
   ```

3. **Configuration Backup**
   ```bash
   # WebSphere configuration backup
   cp -r $WAS_HOME/profiles/default/config "$BACKUP_DIR/websphere-config"
   
   # Application server logs
   cp -r $WAS_HOME/profiles/default/logs "$BACKUP_DIR/websphere-logs"
   ```

4. **Application State Backup**
   ```bash
   # Current build artifacts
   cp -r target "$BACKUP_DIR/build-artifacts"
   
   # Generated documentation
   cp -r docs "$BACKUP_DIR/documentation"
   
   # Test results
   cp -r target/surefire-reports "$BACKUP_DIR/test-results"
   ```

#### Recovery Procedures:

1. **Complete System Recovery**
   ```bash
   # Stop current application
   mvn liberty:stop
   
   # Restore codebase
   cd /mnt/d
   rm -rf websphere-cafe
   tar -xzf "$BACKUP_DIR/websphere-cafe-codebase.tar.gz"
   
   # Restore Java environment
   export JAVA_HOME=$(cat "$BACKUP_DIR/java-home.txt")
   export PATH=$JAVA_HOME/bin:$PATH
   
   # Restore Maven settings
   cp "$BACKUP_DIR/maven-settings.xml" ~/.m2/settings.xml
   
   # Verify restoration
   java -version
   mvn -version
   ```

2. **Database Recovery**
   ```bash
   # Derby database recovery
   rm -rf $DERBY_HOME/databases
   cp -r "$BACKUP_DIR/derby-databases" $DERBY_HOME/databases
   
   # PostgreSQL recovery
   dropdb -U cafe_user WebSphereCafeDB
   createdb -U cafe_user WebSphereCafeDB
   psql -U cafe_user WebSphereCafeDB < "$BACKUP_DIR/postgres-backup.sql"
   ```

3. **Application Recovery**
   ```bash
   # Clean build
   mvn clean
   
   # Restore build artifacts
   cp -r "$BACKUP_DIR/build-artifacts" target
   
   # Restart application
   mvn liberty:start
   
   # Verify application
   curl -f http://localhost:9080/websphere-cafe/health
   ```

### Automated Recovery Script:
```bash
#!/bin/bash
# automated-recovery.sh

set -e

BACKUP_DIR="$1"
if [ -z "$BACKUP_DIR" ]; then
    echo "Usage: $0 <backup-directory>"
    exit 1
fi

echo "Starting automated recovery from: $BACKUP_DIR"

# Stop running services
echo "Stopping Liberty server..."
mvn liberty:stop || true

# Restore codebase
echo "Restoring codebase..."
cd /mnt/d
rm -rf websphere-cafe
tar -xzf "$BACKUP_DIR/websphere-cafe-codebase.tar.gz"

# Restore environment
echo "Restoring environment..."
export JAVA_HOME=$(cat "$BACKUP_DIR/java-home.txt")
export PATH=$JAVA_HOME/bin:$PATH

# Restore Maven settings
cp "$BACKUP_DIR/maven-settings.xml" ~/.m2/settings.xml

# Restore database
echo "Restoring database..."
rm -rf $DERBY_HOME/databases
cp -r "$BACKUP_DIR/derby-databases" $DERBY_HOME/databases

# Verify restoration
echo "Verifying restoration..."
cd websphere-cafe
mvn clean compile

# Start application
echo "Starting application..."
mvn liberty:start

# Wait for startup
sleep 30

# Verify application
echo "Verifying application..."
if curl -f http://localhost:9080/websphere-cafe/health; then
    echo "✓ Recovery successful - Application is running"
else
    echo "✗ Recovery failed - Application not responding"
    exit 1
fi

echo "Recovery completed successfully"
```

### Recovery Validation Checklist:
- [ ] Java version matches pre-migration version
- [ ] Maven settings restored correctly
- [ ] Database contains expected data
- [ ] Application builds successfully
- [ ] All tests pass
- [ ] Application starts without errors
- [ ] Health endpoints respond correctly
- [ ] REST API functions properly
- [ ] Web interface accessible
- [ ] Performance metrics within acceptable range

### Emergency Contact Information:
```yaml
# emergency-contacts.yml
migration_team:
  lead: "John Doe <john.doe@company.com>"
  java_expert: "Jane Smith <jane.smith@company.com>"
  database_admin: "Bob Johnson <bob.johnson@company.com>"
  
escalation:
  level_1: "Team Lead"
  level_2: "Technical Manager"
  level_3: "CTO"
  
support_resources:
  confluence: "https://company.atlassian.net/wiki/spaces/MIGRATION"
  slack: "#websphere-migration"
  jira: "https://company.atlassian.net/projects/WM"
```

This comprehensive migration plan provides both systematic execution and robust recovery capabilities, ensuring minimal risk and maximum success probability for the Java 11 + OpenLiberty migration.