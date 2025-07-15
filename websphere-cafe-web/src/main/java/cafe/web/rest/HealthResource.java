package cafe.web.rest;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

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