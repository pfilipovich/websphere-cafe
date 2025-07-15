# Use OpenLiberty base image with Java 11 and Web Profile
FROM icr.io/appcafe/open-liberty:23.0.0.12-full-java11-openj9-ubi

# Set user to root for installation
USER root

# Install PostgreSQL driver
RUN mkdir -p /opt/ol/wlp/usr/shared/config/lib
COPY websphere-cafe-web/target/liberty/wlp/usr/shared/config/lib/*.jar /opt/ol/wlp/usr/shared/config/lib/

# Copy server configuration
COPY websphere-cafe-web/src/main/liberty/config/server.xml /config/

# Copy application WAR
COPY websphere-cafe-web/target/websphere-cafe.war /config/apps/

# Set correct ownership
RUN chown -R 1001:0 /config && \
    chmod -R g+rw /config

# Switch back to default user
USER 1001

# Configure Liberty features
RUN configure.sh

# Expose ports
EXPOSE 9080 9443

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:9080/websphere-cafe/rest/health || exit 1

# Start the server
CMD ["/opt/ol/wlp/bin/server", "run", "defaultServer"]