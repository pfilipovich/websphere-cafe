package cafe.web.rest;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

/**
 * JAX-RS Application configuration for WebSphere Cafe REST API
 */
@ApplicationPath("/rest")
public class CafeApplication extends Application {
    // No additional configuration needed - will auto-discover resources
}