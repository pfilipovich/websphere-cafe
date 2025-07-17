# Migration Checklist - WebSphere to OpenLiberty

This checklist validates the completeness of the migration from WebSphere to OpenLiberty, Java 8 to Java 11, and javax to jakarta namespace.

## Prerequisites
- [ ] Java 11 installed and configured
- [ ] Maven 3.5.0+ installed
- [ ] Docker installed (for container testing)

## Build & Compilation Tests

### 1. Clean Build Test
```bash
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 mvn clean package
```
- [ ] Build completes successfully
- [ ] No compilation errors
- [ ] WAR file generated at `websphere-cafe-web/target/websphere-cafe.war`
- [ ] EAR file generated at `websphere-cafe-application/target/websphere-cafe-application.ear`

### 2. Compile Test
```bash
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 mvn clean compile
```
- [ ] Compilation successful for all modules
- [ ] No jakarta namespace errors
- [ ] No Java 11 compatibility issues

### 3. Install Test
```bash
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 mvn clean install
```
- [ ] All tests pass
- [ ] Artifacts installed to local repository

## OpenLiberty Server Tests

### 4. Liberty Server Creation
```bash
mvn liberty:create
```
- [ ] OpenLiberty server created successfully
- [ ] Server configuration generated

### 5. Feature Installation
```bash
mvn liberty:install-feature
```
- [ ] Jakarta EE 8 features installed
- [ ] MicroProfile 4.1 features installed
- [ ] No feature conflicts

### 6. Server Start Test
```bash
mvn liberty:start
```
- [ ] Server starts without errors
- [ ] Jakarta EE features loaded
- [ ] Database connection established

### 7. Application Deployment
```bash
mvn liberty:deploy
```
- [ ] Application deploys successfully
- [ ] No deployment errors in server logs
- [ ] Context root `/websphere-cafe` accessible

## Application Functionality Tests

### 8. Web Application Access
```bash
curl -i http://localhost:9080/websphere-cafe
```
- [ ] Returns HTTP 200 status
- [ ] JSF pages render correctly
- [ ] No jakarta namespace errors in logs

### 9. REST API Tests
```bash
# Get all coffees
curl -X GET http://localhost:9080/websphere-cafe/rest/coffees -H "Accept: application/xml"

# Add a coffee
curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Content-Type: application/xml" \
  -d '<coffee><name>Test Coffee</name><price>4.50</price></coffee>'

# Verify coffee was added
curl -X GET http://localhost:9080/websphere-cafe/rest/coffees -H "Accept: application/xml"
```
- [ ] GET request returns coffee list
- [ ] POST request creates new coffee
- [ ] Data persists in database
- [ ] XML serialization works correctly

### 10. Health Check Tests
```bash
# Application health
curl -i http://localhost:9080/websphere-cafe/health

# OpenLiberty metrics
curl -i http://localhost:9080/metrics
```
- [ ] Health endpoint returns healthy status
- [ ] Metrics endpoint accessible
- [ ] No errors in health checks

## Database Tests

### 11. Database Operations
```bash
# Through web interface or REST API
```
- [ ] Create coffee records
- [ ] Read coffee records
- [ ] Delete coffee records
- [ ] JPA queries execute correctly
- [ ] JNDI datasource `jdbc/WebSphereCafeDB` works

## Development Mode Tests

### 12. Development Mode
```bash
mvn liberty:dev
```
- [ ] Development mode starts
- [ ] Hot reload works
- [ ] Code changes reflected immediately
- [ ] No compilation errors on changes

## Container Tests

### 13. Docker Build
```bash
docker build -t websphere-cafe:java11 .
```
- [ ] Docker image builds successfully
- [ ] Java 11 base image used
- [ ] Application packaged correctly

### 14. Docker Compose
```bash
docker-compose up
```
- [ ] Containers start successfully
- [ ] Application accessible at expected port
- [ ] Database connections work
- [ ] Health checks pass

### 15. Container Application Test
```bash
curl -i http://localhost:9080/websphere-cafe
curl -X GET http://localhost:9080/websphere-cafe/rest/coffees -H "Accept: application/xml"
```
- [ ] Web application accessible
- [ ] REST API functional
- [ ] Database operations work

## Server Management Tests

### 16. Server Stop/Start
```bash
mvn liberty:stop
mvn liberty:start
```
- [ ] Server stops cleanly
- [ ] Server restarts successfully
- [ ] Application remains functional

### 17. Server Logs Check
```bash
# Check server logs for errors
tail -f target/liberty/wlp/usr/servers/*/logs/messages.log
```
- [ ] No ERROR messages
- [ ] No WARN messages about deprecated features
- [ ] Jakarta EE initialization messages present

## Migration Validation Tests

### 18. Namespace Migration Check
```bash
# Search for any remaining javax imports
grep -r "javax\." src/ --include="*.java" | grep -v "// Migration comment"
```
- [ ] No javax imports found (except in comments)
- [ ] All imports use jakarta namespace

### 19. Java 11 Compatibility Check
```bash
# Verify Java version
java -version
javac -version
```
- [ ] Java 11 being used
- [ ] No Java 8 specific code remaining
- [ ] JAXB dependencies present

### 20. Configuration Migration Check
- [ ] `web.xml` uses Jakarta EE 8 schema
- [ ] `beans.xml` uses Jakarta EE schema
- [ ] `persistence.xml` uses Jakarta EE schema
- [ ] No WebSphere-specific configurations

## Performance Tests

### 21. Load Test (Optional)
```bash
# Simple load test
for i in {1..10}; do curl -s http://localhost:9080/websphere-cafe/rest/coffees & done
wait
```
- [ ] Application handles concurrent requests
- [ ] No memory leaks
- [ ] Response times acceptable

## Cleanup

### 22. Cleanup
```bash
mvn liberty:stop
docker-compose down
```
- [ ] Server stops cleanly
- [ ] Containers removed
- [ ] No hanging processes

## Migration Success Criteria

✅ **Migration Complete When:**
- [ ] All build commands execute successfully
- [ ] OpenLiberty server starts and deploys application
- [ ] Web interface accessible and functional
- [ ] REST API fully operational
- [ ] Database operations work correctly
- [ ] Health checks pass
- [ ] Docker deployment successful
- [ ] No javax namespace references remain
- [ ] Java 11 compatibility confirmed
- [ ] All configuration files updated

## Common Issues & Solutions

### Build Issues
- **Java version mismatch**: Ensure JAVA_HOME points to Java 11
- **Maven version**: Use Maven 3.5.0 or higher
- **Memory issues**: Add `-Xmx2g` to MAVEN_OPTS

### Runtime Issues
- **Feature conflicts**: Check `server.xml` for correct Jakarta EE features
- **Database connection**: Verify JNDI datasource configuration
- **Port conflicts**: Ensure ports 9080/9443 are available

### Migration Issues
- **Namespace errors**: Search for remaining javax imports
- **JAXB missing**: Ensure JAXB runtime dependencies included
- **Annotation processing**: Verify CDI and JPA annotations work