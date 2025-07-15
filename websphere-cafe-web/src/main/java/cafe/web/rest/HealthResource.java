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

// MicroProfile Health imports removed for Java EE 8 compatibility

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

    // MicroProfile Health endpoints removed for Java EE 8 compatibility
    // Basic health check available at /rest/health
}