# Quick Reference: Building Docker/OCI Images

## Build Commands

### Using Dockerfile (Recommended)
```cmd
# Build with full MCP labels
gradlew.bat buildDockerImage

# Using convenience script
scripts\build-image.bat

# Using Docker directly
docker build -t mcp-greeting-server:1.0.0 .
```

## Run Commands

### STDIO Mode (MCP Standard)
```cmd
# Interactive mode with auto-remove (RECOMMENDED - no cleanup needed)
docker run -i --rm mcp-greeting-server:latest

# Interactive mode without auto-remove (keeps container for debugging)
docker run -i mcp-greeting-server:latest
# Stop with Ctrl+C, then run: docker rm <container-id>

# Interactive mode with friendly name
docker run -i --name mcp-greeting mcp-greeting-server:latest
# Stop with: docker stop mcp-greeting
# Remove with: docker rm mcp-greeting

# Background/detached mode with auto-remove
docker run -d --rm --name mcp-greeting -i mcp-greeting-server:latest
# Stop with: docker stop mcp-greeting (auto-removes)

# Background/detached mode (keeps container)
docker run -d --name mcp-greeting -i mcp-greeting-server:latest
# Stop with: docker stop mcp-greeting
# Remove with: docker rm mcp-greeting
```

**Key**: 
- `--rm` = Auto-removes container when stopped (no manual cleanup needed)
- Without `--rm` = Container persists, need `docker stop` + `docker rm` to cleanup

### HTTP/SSE Mode
```cmd
# Run with web endpoints
docker run -p 8080:8080 -e SPRING_PROFILES_ACTIVE=default mcp-greeting-server:latest

# Access endpoints
# http://localhost:8080/mcp (Streamable HTTP)
# http://localhost:8080/mcp/sse (SSE)
# http://localhost:8080/actuator/health
```

## Inspect Commands

```cmd
# List images
docker images mcp-greeting-server

# Inspect image details and labels
docker inspect mcp-greeting-server:latest

# View image layers
docker history mcp-greeting-server:latest

# View logs
docker logs mcp-greeting
```

## Publishing Commands

```cmd
# Tag for registry
docker tag mcp-greeting-server:1.0.0 registry.example.com/mcp-greeting-server:1.0.0

# Push to registry
docker push registry.example.com/mcp-greeting-server:1.0.0
```

## Testing Commands

```cmd
# Test STDIO with manual JSON-RPC
docker run -i mcp-greeting-server:latest
# Then type: {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}

# Test with echo (Windows)
echo {"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}} | docker run -i mcp-greeting-server:latest

# Test HTTP health endpoint
docker run -d -p 8080:8080 -e SPRING_PROFILES_ACTIVE=default --name mcp-test mcp-greeting-server:latest
curl http://localhost:8080/actuator/health
docker stop mcp-test && docker rm mcp-test
```

## Testing with MCP Inspector

```cmd
# Test Docker image with MCP Inspector (Recommended)
npx @modelcontextprotocol/inspector docker run -i --rm mcp-greeting-server:latest

# With environment variables
npx @modelcontextprotocol/inspector docker run -i --rm -e OPENAI_API_KEY=sk-... mcp-greeting-server:latest

# With volume mount for logs (CMD - PORTABLE, works from any directory)
npx @modelcontextprotocol/inspector docker run -i --rm -v "%CD:\=/%/logs:/app/logs" mcp-greeting-server:latest

# With volume mount for logs (PowerShell - PORTABLE, works from any directory)
npx @modelcontextprotocol/inspector docker run -i --rm -v "${PWD}/logs:/app/logs" mcp-greeting-server:latest

# IMPORTANT: Windows CMD path conversion
# ✅ BEST for CMD: -v "%CD:\=/%/logs:/app/logs" (string substitution converts \ to /)
# ✅ BEST for PowerShell: -v "${PWD}/logs:/app/logs" (automatic conversion)
# ❌ WRONG: -v "%CD%/logs:/app/logs" (causes "mkdir C:GitHubyotamfreund-eng..." error)
```

**Explanation of `%CD:\=/%`:**
- `%CD%` expands to current directory: `C:\GitHub\project`
- `%CD:\=/%` replaces all backslashes with forward slashes: `C:/GitHub/project`
- This is CMD's string substitution syntax
- Works from any directory - fully portable!

**Note**: The Inspector runs at `http://localhost:5173` - open this URL in your browser after running the command.

## Cleanup Commands

```cmd
# Stop container
docker stop mcp-greeting

# Remove container
docker rm mcp-greeting

# Remove image
docker rmi mcp-greeting-server:latest

# Remove all versions
docker rmi mcp-greeting-server:1.0.0 mcp-greeting-server:latest
```

## Build Method

The server uses a Dockerfile-based build approach with:
- ✅ Full MCP registry OCI labels
- ✅ Java 25 (Eclipse Temurin)
- ✅ Alpine-based for smaller image (~300 MB)
- ✅ Multi-stage build optimization
- ✅ Fast, reproducible builds

## Environment Variables

```cmd
# Set OpenAI API key
docker run -i -e OPENAI_API_KEY=sk-... mcp-greeting-server:latest

# Change server port (HTTP mode)
docker run -p 9090:9090 -e SERVER_PORT=9090 -e SPRING_PROFILES_ACTIVE=default mcp-greeting-server:latest

# Mount logs directory (CMD - portable, works from any directory)
docker run -i -v "%CD:\=/%/logs:/app/logs" mcp-greeting-server:latest

# Mount logs directory (PowerShell - portable, works from any directory)
docker run -i -v "${PWD}/logs:/app/logs" mcp-greeting-server:latest
```

## Troubleshooting

```cmd
# Check if Docker is running
docker info

# View container logs
docker logs mcp-greeting

# Enter running container
docker exec -it mcp-greeting sh

# Check Java version inside container
docker run mcp-greeting-server:latest java -version

# Test without removing container (keep for debugging)
docker run --name mcp-test -i mcp-greeting-server:latest
docker logs mcp-test
docker rm mcp-test
```

## MCP Client Configuration

### Claude Desktop
Add to `claude_desktop_config.json`:
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

### Generic MCP Client
```
Command: docker
Args: ["run", "-i", "--rm", "mcp-greeting-server:latest"]
```

## Documentation

- Full guide: [docs/DOCKER.md](../docs/DOCKER.md)
- Configuration: [docs/CONFIGURATION.md](../docs/CONFIGURATION.md)
- Testing: [docs/TESTING.md](../docs/TESTING.md)
- Main README: [README.md](../README.md)

