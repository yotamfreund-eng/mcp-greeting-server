# Docker/OCI Image Guide for MCP Greeting Server

This guide explains how to build and run the MCP Greeting Server as a Docker/OCI container image, suitable for publishing to the MCP registry.

## Overview

The MCP Greeting Server can be packaged as an OCI-compliant Docker image using a traditional Dockerfile approach. The image is configured to support STDIO transport by default, which is the standard for MCP registry deployment, and includes all required MCP registry metadata labels.

## Building the Image

### Using the Build Script (Recommended)

The easiest way to build the OCI image is using the provided build script:

```cmd
scripts\build-image.bat
```

Or directly with Gradle:

```cmd
gradlew.bat buildDockerImage
```

This creates an OCI-compliant image with:
- Java 25 runtime (Eclipse Temurin)
- Full MCP registry metadata labels
- STDIO transport as default
- Alpine-based for smaller image size

### Using Docker Directly

You can also build using the standard Docker command:

```cmd
docker build -t mcp-greeting-server:1.0.0 .
```

The Dockerfile uses a multi-stage build to create an optimized final image.

## Image Metadata

The built image includes MCP registry-compliant OCI labels:

**MCP-Specific Labels:**

| Label | Value | Description |
|-------|-------|-------------|
| `mcp.protocol.version` | 2024-11-05 | MCP protocol version |
| `mcp.server.name` | greeting | MCP server name |
| `mcp.server.version` | 1.0.0 | Server version |
| `mcp.transport` | stdio | Transport type |
| `io.modelcontextprotocol.server.name` | io.github.yotamfreund-eng/greeting | Registry identifier (must match mcp-registry.json name) |

**OCI Standard Labels:**

| Label | Value | Description |
|-------|-------|-------------|
| `org.opencontainers.image.title` | MCP Greeting Server | Image title |
| `org.opencontainers.image.description` | Model Context Protocol server... | Image description |
| `org.opencontainers.image.version` | 1.0.0 | Version |
| `org.opencontainers.image.vendor` | com.example | Vendor/organization |
| `org.opencontainers.image.licenses` | MIT | License |
| `org.opencontainers.image.source` | Repository URL | Source code repository |
| `org.opencontainers.image.url` | Repository URL | Homepage URL |
| `org.opencontainers.image.documentation` | README URL | Documentation URL |
| `org.opencontainers.image.authors` | Yotam Freund | Author name |

Inspect labels:
```cmd
docker inspect mcp-greeting-server:latest --format='{{json .Config.Labels}}' | jq
```

## Running the Container

### STDIO Mode (MCP Registry Standard)

Run with STDIO transport for MCP client communication (this is the default):

**Option 1: Auto-remove container (Recommended for testing)**
```cmd
docker run -i --rm mcp-greeting-server:latest
```
- The `--rm` flag automatically removes the container when it stops
- No need to run `docker stop` or `docker rm` afterwards
- **Best for**: Quick testing, MCP client configurations, one-time runs

**Option 2: Keep container for debugging**
```cmd
docker run -i mcp-greeting-server:latest
```
- Container persists after stopping
- Use `Ctrl+C` to stop the container
- Later run `docker ps -a` to see stopped containers
- Use `docker logs <container-id>` to view logs after stopping
- **Need to cleanup**: `docker rm <container-id>` when done
- **Best for**: Debugging, inspecting logs after crashes

**Option 3: Named container (for long-running or repeated use)**
```cmd
docker run -i --name mcp-greeting mcp-greeting-server:latest
```
- Gives container a friendly name for easy reference
- Stop with: `docker stop mcp-greeting`
- Remove with: `docker rm mcp-greeting`
- **Best for**: Development, repeated manual testing

The container will:
- Start with STDIO profile (default: `SPRING_PROFILES_ACTIVE=stdio` set in Dockerfile)
- Listen on stdin for MCP JSON-RPC messages
- Write responses to stdout
- Log to file (`/app/logs/mcp-greeting-server.log` inside container)

### Interactive STDIO Testing

Test the server manually:

```cmd
docker run -i mcp-greeting-server:latest
```

Then type MCP JSON-RPC requests, for example:

```json
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test-client","version":"1.0.0"}}}
```

### HTTP/SSE Mode

For web-based clients, override the default STDIO profile:

```cmd
docker run -p 8080:8080 -e SPRING_PROFILES_ACTIVE=default mcp-greeting-server:latest
```

**Important**: The `-e SPRING_PROFILES_ACTIVE=default` environment variable overrides the default `stdio` profile set in the Dockerfile.

Access endpoints:
- SSE: `http://localhost:8080/mcp/sse`
- Streamable HTTP: `http://localhost:8080/mcp`
- Health: `http://localhost:8080/actuator/health`

### Background Mode (Detached)

Run as detached container (runs in background):

```cmd
docker run -d --name mcp-greeting -i mcp-greeting-server:latest
```

The `-d` flag runs the container in the background (detached mode).

**Manage the background container:**

```cmd
# View logs
docker logs mcp-greeting

# Follow logs in real-time
docker logs -f mcp-greeting

# Stop the container
docker stop mcp-greeting

# Remove the container
docker rm mcp-greeting

# Stop and remove in one command
docker stop mcp-greeting && docker rm mcp-greeting
```

**Note**: You can also use `--rm` with detached mode:
```cmd
docker run -d --rm --name mcp-greeting -i mcp-greeting-server:latest
```
This auto-removes the container when it stops.

## MCP Client Configuration

### Using with Claude Desktop

Add to Claude Desktop configuration (`claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "greeting": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp-greeting-server:latest"]
    }
  }
}
```

### Using with Other MCP Clients

Configure your MCP client to execute:

```
docker run -i --rm mcp-greeting-server:latest
```

The client will communicate via stdin/stdout pipes.

## Environment Variables

Configure the server with environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `SPRING_PROFILES_ACTIVE` | Active Spring profile | `stdio` |
| `OPENAI_API_KEY` | OpenAI API key (if needed) | - |
| `SERVER_PORT` | HTTP port (HTTP/SSE mode) | 8080 |

Example:

```cmd
docker run -i -e OPENAI_API_KEY=sk-... mcp-greeting-server:latest
```

## Volume Mounts

Mount logs directory to persist logs:

```cmd
docker run -i -v "%CD%\logs:/app/logs" mcp-greeting-server:latest
```

## Troubleshooting

### Container exits immediately

Ensure you use `-i` (interactive) flag for STDIO mode:
```cmd
docker run -i mcp-greeting-server:latest
```

### No response to MCP requests

1. Check logs inside container:
   ```cmd
   docker exec <container-id> cat /app/logs/mcp-greeting-server.log
   ```

2. Verify STDIO profile is active:
   ```cmd
   docker exec <container-id> env | grep SPRING_PROFILES_ACTIVE
   ```

3. Test with raw JSON-RPC:
   ```cmd
   echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | docker run -i mcp-greeting-server:latest
   ```

### Build fails with "Docker daemon not running"

Start Docker Desktop and verify:
```cmd
docker info
```

### Java version issues

The image uses Java 25 (Eclipse Temurin). The Dockerfile specifies both the builder and runtime images with Java 25.

## Publishing to MCP Registry

To publish the image to the MCP registry:

1. **Tag appropriately** for your registry:
   ```cmd
   docker tag mcp-greeting-server:1.0.0 registry.example.com/mcp-greeting-server:1.0.0
   ```

2. **Push to registry**:
   ```cmd
   docker push registry.example.com/mcp-greeting-server:1.0.0
   ```

3. **Register with MCP directory** at https://modelcontextprotocol.io/registry

## Image Size and Optimization

The Docker image is built using a multi-stage build process:
- Builder stage uses Eclipse Temurin 25 JDK on Alpine
- Runtime stage uses Eclipse Temurin 25 JRE on Alpine
- Only the necessary JAR file is copied to the final image

Typical image size: ~300-350 MB

To see layer breakdown:
```cmd
docker history mcp-greeting-server:latest
```

## Security Considerations

1. **No secrets in image**: Use environment variables for API keys
2. **Minimal base image**: Alpine Linux for reduced attack surface
3. **Scan for vulnerabilities**:
   ```cmd
   docker scan mcp-greeting-server:latest
   ```
4. **Use specific tags**: Avoid `:latest` in production

## Additional Resources

- [Spring Boot Docker Documentation](https://spring.io/guides/topicals/spring-boot-docker/)
- [Docker Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [MCP Registry Documentation](https://modelcontextprotocol.io/registry)
- [MCP Protocol Specification](https://spec.modelcontextprotocol.io/)

## Next Steps

- See [PUBLISHING.md](PUBLISHING.md) for publishing to the MCP Registry
- See [TESTING.md](TESTING.md) for testing the server
- See [CONFIGURATION.md](CONFIGURATION.md) for configuration options
- See [README.md](../README.md) for general server documentation

