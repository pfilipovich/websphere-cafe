package cafe.web.rest;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.Liveness;
import org.eclipse.microprofile.health.Readiness;

import cafe.model.CafeRepository;

@ApplicationScoped
public class HealthResource {

    @PersistenceContext
    private EntityManager entityManager;

    @Inject
    private CafeRepository cafeRepository;

    @GET
    @Path("/health")
    @Produces(MediaType.APPLICATION_JSON)
    public Response health() {
        return Response.ok("{\"status\":\"UP\"}").build();
    }

    @Liveness
    public HealthCheckResponse livenessCheck() {
        return HealthCheckResponse.up("WebSphere Cafe Application");
    }

    @Readiness
    public HealthCheckResponse readinessCheck() {
        try {
            cafeRepository.getAllCoffees();
            return HealthCheckResponse.up("Database connection");
        } catch (Exception e) {
            return HealthCheckResponse.down("Database connection failed: " + e.getMessage());
        }
    }
}