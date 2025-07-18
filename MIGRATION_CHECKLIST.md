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

## Comprehensive Container Testing Scenarios

### 16. Pre-Deployment Validation
```bash
# Verify Docker environment
docker --version
docker-compose --version
docker system df
docker system prune -f

# Check available resources
docker system info | grep -E "(CPUs|Total Memory)"
```
- [ ] Docker engine running and accessible
- [ ] Sufficient disk space available (>2GB free)
- [ ] Adequate memory available (>2GB free)
- [ ] No conflicting containers running on ports 9080/9443

### 17. Container Build Validation
```bash
# Build with verbose output
docker build -t websphere-cafe:java11 . --no-cache

# Inspect built image
docker image inspect websphere-cafe:java11
docker image ls websphere-cafe:java11

# Test image layers
docker history websphere-cafe:java11
```
- [ ] Build completes without warnings
- [ ] Image size reasonable (<500MB)
- [ ] All required files present in image
- [ ] Base image vulnerabilities acceptable
- [ ] Application JAR/WAR correctly copied

### 18. Container Runtime Validation
```bash
# Start container with resource limits
docker run -d --name websphere-cafe-test \
  --memory=1g --cpus=1 \
  -p 9080:9080 -p 9443:9443 \
  websphere-cafe:java11

# Monitor container startup
docker logs -f websphere-cafe-test

# Check container health
docker inspect websphere-cafe-test | grep -A 10 Health
```
- [ ] Container starts within 60 seconds
- [ ] No startup errors in logs
- [ ] Memory usage stays under limits
- [ ] CPU usage reasonable during startup
- [ ] Health checks pass within 30 seconds

### 19. Functional Testing Suite
```bash
# Web Interface Tests
curl -i http://localhost:9080/websphere-cafe
curl -i http://localhost:9080/websphere-cafe/index.xhtml

# REST API Comprehensive Tests
# Create test data
curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Content-Type: application/xml" \
  -d '<coffee><name>Espresso</name><price>2.50</price></coffee>'

curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Content-Type: application/xml" \
  -d '<coffee><name>Cappuccino</name><price>3.50</price></coffee>'

# Read operations
curl -X GET http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Accept: application/xml"

# Update operations (if supported)
curl -X PUT http://localhost:9080/websphere-cafe/rest/coffees/1 \
  -H "Content-Type: application/xml" \
  -d '<coffee><name>Double Espresso</name><price>3.00</price></coffee>'

# Delete operations
curl -X DELETE http://localhost:9080/websphere-cafe/rest/coffees/1

# Verify deletion
curl -X GET http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Accept: application/xml"
```
- [ ] Web interface loads without errors
- [ ] JSF pages render correctly
- [ ] Form submissions work
- [ ] POST requests create new records
- [ ] GET requests return proper XML
- [ ] PUT requests update existing records
- [ ] DELETE requests remove records
- [ ] Data validation works correctly
- [ ] Error responses proper format

### 20. Data Persistence Testing
```bash
# Add test data
curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Content-Type: application/xml" \
  -d '<coffee><name>Test Coffee</name><price>4.00</price></coffee>'

# Verify data exists
curl -X GET http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Accept: application/xml"

# Stop container
docker stop websphere-cafe-test

# Start container again
docker start websphere-cafe-test

# Wait for startup
sleep 30

# Verify data persists
curl -X GET http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Accept: application/xml"
```
- [ ] Data survives container restart
- [ ] Database connections restore properly
- [ ] No data corruption occurs
- [ ] Transaction logs intact
- [ ] Indexes remain functional

### 21. Error Handling and Recovery Testing
```bash
# Test invalid data
curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Content-Type: application/xml" \
  -d '<coffee><name></name><price>-1</price></coffee>'

# Test malformed XML
curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Content-Type: application/xml" \
  -d '<invalid-xml>'

# Test missing content-type
curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
  -d '<coffee><name>Test</name><price>1.00</price></coffee>'

# Test non-existent endpoints
curl -i http://localhost:9080/websphere-cafe/rest/nonexistent

# Test database connection issues (simulate)
docker exec websphere-cafe-test pkill -f derby
sleep 5
curl -X GET http://localhost:9080/websphere-cafe/rest/coffees
```
- [ ] Invalid data returns proper error codes
- [ ] Malformed requests handled gracefully
- [ ] Missing headers handled correctly
- [ ] 404 errors for non-existent resources
- [ ] Database connection failures handled
- [ ] Application recovers from temporary failures
- [ ] Error logs contain useful information

### 22. Performance and Load Testing
```bash
# Concurrent request testing
for i in {1..20}; do
  curl -X GET http://localhost:9080/websphere-cafe/rest/coffees \
    -H "Accept: application/xml" -w "%{time_total}\n" -o /dev/null -s &
done
wait

# Memory usage monitoring
docker stats websphere-cafe-test --no-stream

# Load testing with data creation
for i in {1..50}; do
  curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
    -H "Content-Type: application/xml" \
    -d "<coffee><name>Coffee-$i</name><price>$((i % 10 + 1)).00</price></coffee>" &
done
wait

# Verify all data created
curl -X GET http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Accept: application/xml" | grep -c "<coffee>"
```
- [ ] Handles 20 concurrent read requests
- [ ] Response times under 2 seconds
- [ ] Memory usage stays under 1GB
- [ ] No connection timeouts
- [ ] Handles 50 concurrent write requests
- [ ] Data integrity maintained under load
- [ ] No database deadlocks occur

### 23. Security Testing
```bash
# Test HTTPS endpoint
curl -k -i https://localhost:9443/websphere-cafe

# Test SQL injection attempts
curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Content-Type: application/xml" \
  -d '<coffee><name>Test"; DROP TABLE coffee; --</name><price>1.00</price></coffee>'

# Test XSS attempts
curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Content-Type: application/xml" \
  -d '<coffee><name>&lt;script&gt;alert("xss")&lt;/script&gt;</name><price>1.00</price></coffee>'

# Test oversized requests
curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Content-Type: application/xml" \
  -d "<coffee><name>$(head -c 10000 /dev/zero | tr '\0' 'A')</name><price>1.00</price></coffee>"

# Check security headers
curl -I http://localhost:9080/websphere-cafe
```
- [ ] HTTPS endpoint accessible
- [ ] SQL injection attempts blocked
- [ ] XSS attempts properly escaped
- [ ] Oversized requests rejected
- [ ] Security headers present
- [ ] No sensitive data in error messages
- [ ] Input validation working correctly

### 24. Monitoring and Logging Validation
```bash
# Check health endpoints
curl -i http://localhost:9080/websphere-cafe/health
curl -i http://localhost:9080/health
curl -i http://localhost:9080/metrics

# Check log output
docker logs websphere-cafe-test | grep -i error
docker logs websphere-cafe-test | grep -i warn
docker logs websphere-cafe-test | grep -i "started in"

# Check log rotation
docker exec websphere-cafe-test ls -la /opt/ol/wlp/usr/servers/defaultServer/logs/

# Monitor resource usage
docker stats websphere-cafe-test --no-stream
```
- [ ] Health endpoint returns UP status
- [ ] Metrics endpoint accessible
- [ ] Application logs contain startup info
- [ ] No unexpected errors in logs
- [ ] Warning messages are acceptable
- [ ] Log files have reasonable size
- [ ] Resource usage within expected ranges

### 25. Multi-Container Environment Testing
```bash
# Test with docker-compose
docker-compose up -d

# Wait for all services to start
sleep 30

# Test application in multi-container setup
curl -i http://localhost:9080/websphere-cafe
curl -X GET http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Accept: application/xml"

# Test service discovery and networking
docker-compose exec websphere-cafe ping -c 3 database || echo "Database service not found"

# Check all services status
docker-compose ps
```
- [ ] All services start successfully
- [ ] Application accessible through compose
- [ ] Inter-service communication works
- [ ] Database connectivity established
- [ ] Network isolation proper
- [ ] Service dependencies resolved

### 26. Internationalization Testing
```bash
# Test with different Accept-Language headers
curl -H "Accept-Language: en-US" http://localhost:9080/websphere-cafe
curl -H "Accept-Language: es-ES" http://localhost:9080/websphere-cafe
curl -H "Accept-Language: es" http://localhost:9080/websphere-cafe

# Test with different locale data
curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Content-Type: application/xml" -H "Accept-Language: es" \
  -d '<coffee><name>Café Español</name><price>2.50</price></coffee>'
```
- [ ] English localization works
- [ ] Spanish localization works
- [ ] Locale-specific data handled correctly
- [ ] Currency formatting appropriate
- [ ] Character encoding proper (UTF-8)

### 27. Configuration Management Testing
```bash
# Test with environment variables
docker run -d --name websphere-cafe-config-test \
  -e JAVA_OPTS="-Xmx512m" \
  -e SERVER_HOST="0.0.0.0" \
  -p 9081:9080 \
  websphere-cafe:java11

# Wait for startup
sleep 30

# Test custom configuration
curl -i http://localhost:9081/websphere-cafe

# Check configuration applied
docker exec websphere-cafe-config-test ps aux | grep java
```
- [ ] Environment variables respected
- [ ] JVM options applied correctly
- [ ] Server configuration customizable
- [ ] Application starts with custom config
- [ ] No configuration conflicts

### 28. Backup and Recovery Testing
```bash
# Create test data
curl -X POST http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Content-Type: application/xml" \
  -d '<coffee><name>Backup Test</name><price>5.00</price></coffee>'

# Create container backup
docker commit websphere-cafe-test websphere-cafe-backup:test

# Stop and remove original container
docker stop websphere-cafe-test
docker rm websphere-cafe-test

# Restore from backup
docker run -d --name websphere-cafe-restored \
  -p 9080:9080 -p 9443:9443 \
  websphere-cafe-backup:test

# Wait for startup
sleep 30

# Verify data restored
curl -X GET http://localhost:9080/websphere-cafe/rest/coffees \
  -H "Accept: application/xml" | grep "Backup Test"
```
- [ ] Container can be backed up
- [ ] Backup image contains all data
- [ ] Restored container starts successfully
- [ ] Application data fully restored
- [ ] No data loss during backup/restore

### 29. Resource Constraint Testing
```bash
# Test with limited memory
docker run -d --name websphere-cafe-memory-test \
  --memory=256m --oom-kill-disable=false \
  -p 9082:9080 \
  websphere-cafe:java11

# Monitor memory usage
docker stats websphere-cafe-memory-test --no-stream

# Test with limited CPU
docker run -d --name websphere-cafe-cpu-test \
  --cpus=0.5 \
  -p 9083:9080 \
  websphere-cafe:java11

# Test under resource constraints
curl -i http://localhost:9082/websphere-cafe
curl -i http://localhost:9083/websphere-cafe
```
- [ ] Application starts with 256MB memory
- [ ] No out-of-memory errors
- [ ] Application responsive with limited CPU
- [ ] Resource limits respected
- [ ] Performance degradation acceptable

### 30. Graceful Shutdown Testing
```bash
# Send shutdown signal
docker kill -s SIGTERM websphere-cafe-test

# Monitor shutdown process
docker logs -f websphere-cafe-test

# Verify clean shutdown
docker ps -a | grep websphere-cafe-test
```
- [ ] Application shuts down gracefully
- [ ] No forced termination required
- [ ] Database connections closed properly
- [ ] Active requests completed
- [ ] Shutdown logs indicate clean exit

## Server Management Tests

### 31. Server Stop/Start
```bash
mvn liberty:stop
mvn liberty:start
```
- [ ] Server stops cleanly
- [ ] Server restarts successfully
- [ ] Application remains functional

### 32. Server Logs Check
```bash
# Check server logs for errors
tail -f target/liberty/wlp/usr/servers/*/logs/messages.log
```
- [ ] No ERROR messages
- [ ] No WARN messages about deprecated features
- [ ] Jakarta EE initialization messages present

## Migration Validation Tests

### 33. Namespace Migration Check
```bash
# Search for any remaining javax imports
grep -r "javax\." src/ --include="*.java" | grep -v "// Migration comment"
```
- [ ] No javax imports found (except in comments)
- [ ] All imports use jakarta namespace

### 34. Java 11 Compatibility Check
```bash
# Verify Java version
java -version
javac -version
```
- [ ] Java 11 being used
- [ ] No Java 8 specific code remaining
- [ ] JAXB dependencies present

### 35. Configuration Migration Check
- [ ] `web.xml` uses Jakarta EE 8 schema
- [ ] `beans.xml` uses Jakarta EE schema
- [ ] `persistence.xml` uses Jakarta EE schema
- [ ] No WebSphere-specific configurations

## Performance Tests

### 36. Load Test (Optional)
```bash
# Simple load test
for i in {1..10}; do curl -s http://localhost:9080/websphere-cafe/rest/coffees & done
wait
```
- [ ] Application handles concurrent requests
- [ ] No memory leaks
- [ ] Response times acceptable

## Cleanup

### 37. Cleanup
```bash
mvn liberty:stop
docker-compose down
```
- [ ] Server stops cleanly
- [ ] Containers removed
- [ ] No hanging processes

## Container Testing Summary

### Comprehensive Container Testing Checklist
✅ **Container Deployment Ready When:**
- [ ] Pre-deployment validation passes (sections 16-17)
- [ ] Container builds and runs successfully (section 18)
- [ ] All functional tests pass (section 19)
- [ ] Data persistence works correctly (section 20)
- [ ] Error handling and recovery tested (section 21)
- [ ] Performance under load acceptable (section 22)
- [ ] Security validation completed (section 23)
- [ ] Monitoring and logging functional (section 24)
- [ ] Multi-container environment tested (section 25)
- [ ] Internationalization validated (section 26)
- [ ] Configuration management tested (section 27)
- [ ] Backup and recovery verified (section 28)
- [ ] Resource constraints handled (section 29)
- [ ] Graceful shutdown confirmed (section 30)

### Container Testing Execution Order
1. **Pre-deployment** (sections 16-17): Validate environment readiness
2. **Build & Runtime** (section 18): Verify container operation
3. **Functional** (section 19): Test application features
4. **Data** (section 20): Validate persistence
5. **Resilience** (sections 21, 28-30): Test error handling and recovery
6. **Performance** (section 22): Validate under load
7. **Security** (section 23): Test security measures
8. **Operations** (sections 24-27): Validate monitoring and configuration
9. **Multi-environment** (section 25): Test in composed environment

## Migration Success Criteria

✅ **Migration Complete When:**
- [ ] All build commands execute successfully
- [ ] OpenLiberty server starts and deploys application
- [ ] Web interface accessible and functional
- [ ] REST API fully operational
- [ ] Database operations work correctly
- [ ] Health checks pass
- [ ] Docker deployment successful
- [ ] Comprehensive container testing passes
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

### Container Issues
- **Docker build failures**: Check Dockerfile syntax and base image availability
- **Container startup timeout**: Increase memory allocation or optimize startup
- **Port conflicts**: Ensure ports 9080/9443 are not in use by other services
- **Database connection issues**: Verify JNDI configuration and database service startup
- **Performance degradation**: Check resource limits and JVM heap settings
- **Security failures**: Validate SSL certificates and security configurations
- **Network connectivity**: Ensure container networking and service discovery works
- **Data persistence issues**: Check volume mounts and database initialization
- **Log access problems**: Verify log directory permissions and rotation settings
- **Resource exhaustion**: Monitor memory, CPU, and disk usage under load