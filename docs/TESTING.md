# Testing the MCP Greeting Server

This guide explains how to build, run, and test the MCP Greeting Server executable using the MCP Inspector.

## Table of Contents

- [Building the Executable](#building-the-executable)
- [Running the Server](#running-the-server)
- [Testing with MCP Inspector](#testing-with-mcp-inspector)
- [Testing MCP Tools](#testing-mcp-tools)
- [Troubleshooting](#troubleshooting)

## Building the Executable

### Prerequisites

Before building, ensure you have:
- Java 25 (OpenJDK) installed
- `JAVA_HOME` environment variable set to your Java 25 installation
- Gradle 9.2.1 (included via wrapper)

### Build Steps

1. **Build the project**:
   ```cmd
   gradlew.bat build
   ```

   Or use the convenience script:
   ```cmd
   scripts\build.bat
   ```

2. **Verify the JAR was created**:
   ```cmd
   dir build\libs
   ```

   You should see:
   - `mcp-greeting-server-1.0.0.jar` (executable JAR with all dependencies)
   - `mcp-greeting-server-1.0.0-plain.jar` (without dependencies)

## Running the Server

### Option 1: Run with Gradle

```cmd
gradlew.bat bootRun
```

The server will start on `http://localhost:8080`

### Option 2: Run the JAR directly

```cmd
java -jar build\libs\mcp-greeting-server-1.0.0.jar
```

### Option 3: Use the start script

```cmd
scripts\start.bat
```

### Verify the Server is Running

Open a new terminal and test the health endpoint:

```cmd
curl http://localhost:8080/api/v1/health
```

Expected response:
```json
{"status":"UP"}
```

## Testing with MCP Inspector

The [MCP Inspector](https://github.com/modelcontextprotocol/inspector) is a developer tool for testing and debugging MCP servers.

### Installing MCP Inspector

```bash
npm install -g @modelcontextprotocol/inspector
```

Or using npx (no installation needed):
```bash
npx @modelcontextprotocol/inspector
```

### Running MCP Inspector with the Server

There are two ways to connect MCP Inspector to your server:

#### Method 1: STDIO Transport (Direct JAR execution)

1. **Build the JAR**:
   ```cmd
   gradlew.bat build
   ```

2. **Start MCP Inspector with STDIO**:
   ```bash
   npx @modelcontextprotocol/inspector java -jar build/libs/mcp-greeting-server-1.0.0.jar
   ```

   On Windows (PowerShell):
   ```powershell
   npx "@modelcontextprotocol/inspector" java -jar build/libs/mcp-greeting-server-1.0.0.jar
   ```

   On Windows (CMD):
   ```cmd
   npx @modelcontextprotocol/inspector java -jar build\libs\mcp-greeting-server-1.0.0.jar
   ```

3. **Open your browser**:
   
   MCP Inspector will output a URL like:
   ```
   Inspector running at http://localhost:5173
   ```
   
   Open this URL in your browser.

#### Method 2: SSE Transport (HTTP Server)

1. **Start the MCP server**:
   ```cmd
   gradlew.bat bootRun
   ```

2. **In another terminal, start MCP Inspector**:
   ```bash
   npx @modelcontextprotocol/inspector --transport sse --url http://localhost:8080/mcp/sse
   ```

3. **Open the Inspector URL** in your browser.

### Using MCP Inspector

Once MCP Inspector is running in your browser:

1. **Connect to the Server**:
   - The Inspector should automatically connect
   - You'll see server information displayed

2. **View Server Info**:
   - Server name: `greeting`
   - Server version: `1.0.0`
   - Description: "MCP server providing greeting functionality"

3. **Explore Available Tools**:
   - Click on the **Tools** tab
   - You should see three tools:
     - `greet`
     - `farewell`
     - `casual_greeting`

## Testing MCP Tools

### Testing the `greet` Tool

1. **In MCP Inspector**, select the `greet` tool

2. **Fill in the parameters**:
   ```json
   {
     "name": "Alice",
     "style": "friendly",
     "language": "english"
   }
   ```

3. **Click "Call Tool"**

4. **Expected Response**:
   ```
   "Hi Alice! Nice to see you!"
   ```

### Test Cases for `greet` Tool

#### Test 1: Formal English Greeting
```json
{
  "name": "Bob",
  "style": "formal"
}
```
Expected: `"Hello, Bob. Welcome!"`

#### Test 2: Casual English Greeting
```json
{
  "name": "Charlie",
  "style": "casual",
  "language": "english"
}
```
Expected: `"Hey Charlie! What's up?"`

#### Test 3: Spanish Professional Greeting
```json
{
  "name": "Carlos",
  "style": "professional",
  "language": "spanish"
}
```
Expected: `"Buenos días, Carlos. ¿En qué puedo ayudarle?"`

#### Test 4: French Friendly Greeting
```json
{
  "name": "Marie",
  "style": "friendly",
  "language": "french"
}
```
Expected: `"Bonjour Marie! Ravi de te voir!"`

### Testing the `farewell` Tool

1. **Select the `farewell` tool**

2. **Test with parameters**:
   ```json
   {
     "name": "David",
     "style": "casual"
   }
   ```

3. **Expected Response**:
   ```
   "See you later, David!"
   ```

### Test Cases for `farewell` Tool

#### Test 1: Formal Farewell
```json
{
  "name": "Emma"
}
```
Expected: `"Goodbye, Emma."`

#### Test 2: Professional Farewell
```json
{
  "name": "Frank",
  "style": "professional"
}
```
Expected: `"Farewell, Frank. Have a productive day."`

#### Test 3: Friendly Farewell
```json
{
  "name": "Grace",
  "style": "friendly"
}
```
Expected: `"Bye Grace! Take care!"`

### Testing the `casual_greeting` Tool

1. **Select the `casual_greeting` tool**

2. **Test with parameter**:
   ```json
   {
     "name": "Henry"
   }
   ```

3. **Expected Response**:
   ```
   "Hey Henry! What's up?"
   ```

## Testing via REST API (Alternative)

If MCP Inspector is not available, you can test the basic functionality via REST endpoints:

### Test Health
```cmd
curl http://localhost:8080/api/v1/health
```

### Test Server Info
```cmd
curl http://localhost:8080/api/v1/info
```

### Test Greeting (REST endpoint, not MCP)
```cmd
curl -X POST http://localhost:8080/api/v1/greet ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"Alice\",\"style\":\"friendly\"}"
```

## Troubleshooting

### Inspector Can't Connect

**Problem**: MCP Inspector fails to connect to the server

**Solutions**:
1. Ensure the server is running:
   ```cmd
   curl http://localhost:8080/api/v1/health
   ```

2. Check that no firewall is blocking port 8080

3. Verify Java 25 is being used:
   ```cmd
   java -version
   ```

### Tools Not Appearing in Inspector

**Problem**: MCP tools don't show up in the Inspector

**Solutions**:
1. Rebuild the project:
   ```cmd
   gradlew.bat clean build
   ```

2. Restart the server

3. Check the logs for any errors:
   ```cmd
   gradlew.bat bootRun --debug
   ```

### STDIO Transport Issues

**Problem**: Inspector fails when using STDIO transport

**Solutions**:
1. Ensure the JAR file exists:
   ```cmd
   dir build\libs\mcp-greeting-server-1.0.0.jar
   ```

2. Try using the full path to the JAR:
   ```bash
   npx @modelcontextprotocol/inspector java -jar C:\full\path\to\mcp-greeting-server-1.0.0.jar
   ```

3. Check Java is in PATH:
   ```cmd
   java -version
   ```

### Port Already in Use

**Problem**: Port 8080 is already in use

**Solutions**:
1. Stop any other process using port 8080

2. Or configure a different port in `application.yml`:
   ```yaml
   server:
     port: 8081
   ```

3. Restart the server

## Advanced Testing

### Testing with Custom MCP Client

You can also test by integrating with MCP-compatible clients like Claude Desktop:

1. **Add to Claude Desktop config** (`claude_desktop_config.json`):
   ```json
   {
     "mcpServers": {
       "greeting": {
         "command": "java",
         "args": [
           "-jar",
           "C:\\full\\path\\to\\mcp-greeting-server-1.0.0.jar"
         ]
       }
     }
   }
   ```

2. **Restart Claude Desktop**

3. **Test by asking Claude**: "Can you greet John in a friendly way?"

### Logging and Debugging

Enable debug logging to see MCP protocol messages:

1. **Update `application.yml`**:
   ```yaml
   logging:
     level:
       com.example.mcpgreeting: DEBUG
       org.springframework.ai.mcp: DEBUG
   ```

2. **Restart the server**

3. **Monitor logs** for MCP tool invocations

## Next Steps

- Explore adding more MCP tools
- Implement MCP resources
- Add MCP prompts
- Integrate with AI assistants

## References

- [MCP Inspector GitHub](https://github.com/modelcontextprotocol/inspector)
- [MCP Specification](https://spec.modelcontextprotocol.io/)
- [Spring AI MCP Documentation](https://docs.spring.io/spring-ai/reference/)
