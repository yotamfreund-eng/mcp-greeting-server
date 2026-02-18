FROM eclipse-temurin:25-jre-alpine

# Add OCI standard labels (https://github.com/opencontainers/image-spec/blob/main/annotations.md)
LABEL org.opencontainers.image.title="MCP Greeting Server"
LABEL org.opencontainers.image.description="Model Context Protocol server providing greeting functionality"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="com.example"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/yotamfreund-eng/mcp-greeting-server"
LABEL org.opencontainers.image.url="https://github.com/yotamfreund-eng/mcp-greeting-server"
LABEL org.opencontainers.image.documentation="https://github.com/yotamfreund-eng/mcp-greeting-server/blob/main/README.md"
LABEL org.opencontainers.image.authors="Yotam Freund"

# Add MCP-specific labels for registry compliance
LABEL mcp.protocol.version="2024-11-05"
LABEL mcp.server.name="greeting"
LABEL mcp.server.version="1.0.0"
LABEL mcp.transport="stdio"

# Add MCP Registry required label (must match registry configuration name)
LABEL io.modelcontextprotocol.server.name="io.github.yotamfreund-eng/greeting"

WORKDIR /app

# Copy the pre-built jar from build/libs directory
COPY build/libs/mcp-greeting-server-1.0.0.jar app.jar

# Expose the port (for HTTP/SSE mode, not used in STDIO mode)
EXPOSE 8080

# Set default profile to stdio (can be overridden with SPRING_PROFILES_ACTIVE env var)
ENV SPRING_PROFILES_ACTIVE=stdio

# Set the entrypoint - uses SPRING_PROFILES_ACTIVE env var
ENTRYPOINT ["java", "-jar", "app.jar"]
