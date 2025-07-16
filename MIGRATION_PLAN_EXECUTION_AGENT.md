# WebSphere Cafe Migration Execution Plan - Claude Code Agent

## AGENT EXECUTION OVERVIEW

This document provides a Claude Code agent-optimized execution plan for migrating WebSphere Cafe from Java 8 + WebSphere Application Server to Java 11 + OpenLiberty. Each step is designed for autonomous execution with clear validation checkpoints.

**Migration Path**: Java 8 + WebSphere AS → Java 11 + OpenLiberty + Container  
**Total Steps**: 25 discrete execution steps  
**Validation Points**: 8 checkpoints with rollback procedures  
**Agent Execution Mode**: Autonomous with TodoWrite tracking  

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