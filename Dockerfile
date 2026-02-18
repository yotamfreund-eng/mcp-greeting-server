FROM eclipse-temurin:25-jre-alpine

# Add OCI labels for MCP registry compliance
LABEL org.opencontainers.image.title="MCP Greeting Server"
LABEL org.opencontainers.image.description="Model Context Protocol server providing greeting functionality"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="com.example"
LABEL org.opencontainers.image.licenses="MIT"
LABEL mcp.protocol.version="2024-11-05"
LABEL mcp.server.name="greeting"
LABEL mcp.server.version="1.0.0"
LABEL mcp.transport="stdio"

WORKDIR /app

# Copy the pre-built jar from build/libs directory
COPY build/libs/mcp-greeting-server-1.0.0.jar app.jar

# Expose the port (for HTTP/SSE mode, not used in STDIO mode)
EXPOSE 8080

# Set default profile to stdio (can be overridden with SPRING_PROFILES_ACTIVE env var)
ENV SPRING_PROFILES_ACTIVE=stdio

# Set the entrypoint - uses SPRING_PROFILES_ACTIVE env var
ENTRYPOINT ["java", "-jar", "app.jar"]
