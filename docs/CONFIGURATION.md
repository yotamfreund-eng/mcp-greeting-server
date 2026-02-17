# MCP Server Configuration Summary

## Overview
The MCP Greeting Server is now configured to run with **Streamable HTTP** support by default, unless the `stdio` profile is explicitly activated.

## Configuration Changes

### 1. Application Properties (`application.yml`)

Added the following MCP server properties:

```yaml
spring:
  ai:
    mcp:
      server:
        enabled: true
        protocol: STREAMABLE  # Default protocol
        type: SYNC            # Blocking WebMVC (can be ASYNC for reactive WebFlux)
        version: ${projectVersion}  # Resolved from gradle.properties
        capabilities:
          tool: true
        tool-callback-converter: true
        tool-change-notification: true
```

### 2. Actuator Configuration

Enabled health, info, and metrics endpoints:

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
  endpoint:
    health:
      show-details: always
```

### 3. Gradle Configuration

#### gradle.properties
Added project version property:
```properties
projectVersion=1.0.0
```

#### build.gradle
Added task to replace `${projectVersion}` placeholder in application.yml during build:
```groovy
tasks.named('processResources') {
    filesMatching('application*.yml') {
        filter { line ->
            line.replace('${projectVersion}', project.findProperty('projectVersion') ?: '1.0.0')
        }
    }
}
```

## Running the Server

### Default: Streamable HTTP Mode

```cmd
# Using Gradle
gradlew.bat bootRun

# Using JAR
java -jar build\libs\mcp-greeting-server-1.0.0.jar

# Using start script
scripts\start.bat
```

**Endpoint**: `http://localhost:8080/mcp`  
**Accept Header**: `text/event-stream`  
**Session Header**: `mcp-session-id` (required)

### STDIO Mode

To run with STDIO protocol instead:

```cmd
# Using Gradle
gradlew.bat bootRun --args='--spring.profiles.active=stdio'

# Using JAR
java -jar build\libs\mcp-greeting-server-1.0.0.jar --spring.profiles.active=stdio

# Using STDIO script
scripts\run-stdio.bat
```

## Testing Endpoints

### Health Check
```bash
curl http://localhost:8080/actuator/health
```

### Metrics
```bash
curl http://localhost:8080/actuator/metrics
```

### MCP Streamable Endpoint
```bash
curl http://localhost:8080/mcp -H "Accept: text/event-stream"
```

Expected response: `Session ID required in mcp-session-id header`

### Test Script
Run the provided test script:
```cmd
scripts\test-streamable.bat
```

## Profile Behavior

### Default Profile (no profile specified)
- Protocol: **STREAMABLE** (HTTP/SSE)
- Web Application Type: **SERVLET** (Tomcat)
- Server Port: **8080**
- Logging: **Console output enabled**

### STDIO Profile (`--spring.profiles.active=stdio`)
- Protocol: **STDIO** (Standard Input/Output)
- Web Application Type: **NONE** (No web server)
- Server Port: **N/A**
- Logging: **Console disabled** (only file logging)

## Key Features

1. **Streamable HTTP by Default**: No need to specify profile for web-based MCP communication
2. **Version Injection**: Application version from gradle.properties is injected into Spring configuration
3. **Actuator Endpoints**: Health, metrics, and info endpoints exposed for monitoring
4. **Profile-Based Override**: STDIO mode still available when explicitly requested
5. **Tool Auto-Discovery**: Automatic detection and registration of @McpTool annotated methods

## Auto-Configuration

The Spring Boot auto-configuration will automatically enable:

- `McpServerStreamableHttpWebMvcAutoConfiguration` - Streamable HTTP transport (default)
- `McpServerAutoConfiguration` - Core MCP server (SYNC type)
- `ToolCallbackConverterAutoConfiguration` - Tool callback conversion
- `McpServerAnnotationScannerAutoConfiguration` - @McpTool scanning

## Next Steps

To use the MCP server with a client:

1. Start the server: `gradlew.bat bootRun`
2. Connect to `http://localhost:8080/mcp` with SSE support
3. Include `mcp-session-id` header with a unique session ID
4. Send MCP JSON-RPC messages via the SSE connection

For STDIO mode (e.g., for Claude Desktop):
1. Build the JAR: `gradlew.bat build -x test`
2. Configure Claude Desktop to run: `java -jar build\libs\mcp-greeting-server-1.0.0.jar --spring.profiles.active=stdio`

