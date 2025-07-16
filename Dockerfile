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