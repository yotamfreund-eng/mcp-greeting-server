# MCP Greeting Server

[![MCP Registry](https://img.shields.io/badge/MCP-Registry-blue?logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDJMMiA3TDEyIDEyTDIyIDdMMTIgMloiIHN0cm9rZT0id2hpdGUiIHN0cm9rZS13aWR0aD0iMiIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIi8+CjxwYXRoIGQ9Ik0yIDEyTDEyIDE3TDIyIDEyIiBzdHJva2U9IndoaXRlIiBzdHJva2Utd2lkdGg9IjIiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8cGF0aCBkPSJNMiAxN0wxMiAyMkwyMiAxNyIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLXdpZHRoPSIyIiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiLz4KPC9zdmc+)](https://modelcontextprotocol.io/registry/io.github.yotamfreund-eng/greeting)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Java 25](https://img.shields.io/badge/Java-25-orange.svg)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.4.3-green.svg)](https://spring.io/projects/spring-boot)

A Model Context Protocol (MCP) server that provides greeting functionality, built with Java 25, Gradle, and Spring AI.


## Overview

This server implements the Model Context Protocol to provide greeting-related tools and resources. It can be integrated with MCP-compatible clients to add greeting capabilities to AI assistants.

## Installation

### From MCP Registry

This server is published on the [MCP Registry](https://modelcontextprotocol.io/registry/io.github.yotamfreund-eng/greeting) and can be installed directly:

**Using Docker:**
```json
{
  "mcpServers": {
    "greeting": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "ghcr.io/yotamfreund-eng/mcp-greeting-server:latest"]
    }
  }
}
```

Add this to your Claude Desktop configuration file:
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Linux**: `~/.config/Claude/claude_desktop_config.json`

### From Source

```cmd
# Build (Windows)
gradlew.bat build

# Run
gradlew.bat bootRun

# Or use convenience scripts
scripts\build.bat
scripts\start.bat
```

## Features

- **Tools**: Expose greeting functions that can be called by AI assistants
- **Resources**: Provide greeting templates and patterns
- **Prompts**: Pre-configured greeting prompts for various scenarios
- Built with Spring AI for enhanced AI capabilities
- Containerized deployment support

## Technology Stack

- **Java**: OpenJDK 25
- **Build Tool**: Gradle 9.2.1
- **Framework**: Spring Boot 3.5.7
- **Spring AI**: 1.1.2 with MCP server support
- **Protocol**: Model Context Protocol (MCP)

## Prerequisites

- Java 25 (OpenJDK)
- Gradle 9.2.1 or higher

## Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/mcp-greeting-server.git
cd mcp-greeting-server
```

## Building

Build the project using Gradle:

```bash
./gradlew build
```

For Windows:

```cmd
gradlew.bat build
```

**Note**: If you have multiple Java versions installed, run `scripts\set-java-25.bat` first on Windows to ensure Java 25 takes priority.

## Building Docker/OCI Images

The server can be packaged as a Docker/OCI container image for deployment to the MCP registry or container platforms.

### Quick Start

```cmd
# Build Docker image with full MCP registry labels
scripts\build-image.bat
```

Or using Gradle directly:

```cmd
gradlew.bat buildDockerImage
```

This uses the Dockerfile and includes all MCP registry metadata labels:
- `mcp.protocol.version`
- `mcp.server.name`
- `mcp.server.version`
- `mcp.transport`

### Running the Container

Run with STDIO transport (MCP registry standard):

```cmd
docker run -i --rm mcp-greeting-server:latest
```

The `--rm` flag automatically removes the container when it stops (recommended for most use cases).

Run with HTTP/SSE transport:

```cmd
docker run -p 8080:8080 -e SPRING_PROFILES_ACTIVE=default mcp-greeting-server:latest
```

For detailed Docker documentation, see [docs/DOCKER.md](docs/DOCKER.md).

### Publishing to MCP Registry

Once you've built and tested your Docker image, you can publish it to the MCP Registry for easy discovery and installation by users:

```cmd
# 1. Tag for your container registry (e.g., Docker Hub)
docker tag mcp-greeting-server:1.0.0 YOUR_USERNAME/mcp-greeting-server:1.0.0

# 2. Push to registry
docker push YOUR_USERNAME/mcp-greeting-server:1.0.0

# 3. Submit to MCP Registry at https://modelcontextprotocol.io/registry
```

For complete publishing instructions, see [docs/PUBLISHING.md](docs/PUBLISHING.md).

## Running

Run the server:

```bash
./gradlew bootRun
```

Or run the built JAR:

```bash
java -jar build/libs/mcp-greeting-server-1.0.0.jar
```

## Development

### Running in Development Mode

```bash
./gradlew bootRun --args='--spring.profiles.active=dev'
```

### Running Tests

```bash
./gradlew test
```

For Windows:

```cmd
gradlew.bat test
```

### Code Coverage

```bash
./gradlew jacocoTestReport
```

## Configuration

The server can be configured through `application.yml` or environment variables.

### Example Configuration

```yaml
server:
  port: 8080

spring:
  application:
    name: mcp-greeting-server
  ai:
    enabled: true

mcp:
  server:
    name: greeting
    version: 1.0.0
```

## Usage

### MCP Client Configuration

Add this server to your MCP client configuration:

```json
{
  "mcpServers": {
    "greeting": {
      "command": "java",
      "args": ["-jar", "path/to/mcp-greeting-server/build/libs/mcp-greeting-server-1.0.0.jar"]
    }
  }
}
```

### Available Tools

The server provides the following tools:

- `greet`: Generate a personalized greeting
- `farewell`: Generate a farewell message
- `casual_greeting`: Generate an informal greeting

### Available Resources

- `greeting://templates`: Access to greeting templates
- `greeting://styles`: Different greeting styles and formats

## Project Structure

```
mcp-greeting-server/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── example/
│   │   │           └── mcpgreeting/
│   │   │               ├── McpGreetingApplication.java
│   │   │               ├── config/          # Configuration classes
│   │   │               ├── controller/      # REST controllers
│   │   │               ├── service/         # Business logic
│   │   │               ├── model/           # Domain models
│   │   │               └── mcp/             # MCP protocol implementation
│   │   └── resources/
│   │       ├── application.yml
│   │       └── templates/
│   └── test/
│       └── java/
├── scripts/                  # Build and utility scripts
│   ├── build.bat            # Windows build script
│   └── start.bat            # Windows start script
├── docs/                     # Project documentation
│   └── TESTING.md           # Testing guide
├── .github/                  # GitHub configuration
│   └── copilot-instructions.md
├── build/                    # Build output
├── gradle/
│   └── wrapper/
├── build.gradle              # Gradle build configuration
├── settings.gradle           # Gradle settings
├── gradlew                   # Gradle wrapper (Unix)
├── gradlew.bat              # Gradle wrapper (Windows)
└── README.md                # This file
```

## Docker Support

### Building Docker Image

```bash
docker build -t mcp-greeting-server:latest .
```

### Running with Docker

```bash
docker run -p 8080:8080 mcp-greeting-server:latest
```

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Code Style

This project follows standard Java coding conventions. Please ensure your code:
- Follows Java naming conventions
- Includes appropriate Javadoc comments
- Passes all tests and checkstyle rules

## Troubleshooting

### Java Version Issues

**Problem**: Build fails with "Unsupported class file major version 69" or Java version errors

**Solution**: Ensure you're using Java 25. If needed, set JAVA_HOME to your Java 25 installation:
```cmd
set "JAVA_HOME=C:\path\to\your\java-25"
gradlew.bat build
```

Or use the provided build script which handles the environment:
```cmd
scripts\build.bat
```

### Gradle Daemon Issues

**Problem**: Build fails with cached daemon issues

**Solution**: Stop all Gradle daemons and rebuild:
```cmd
gradlew.bat --stop
gradlew.bat clean build
```

## License

MIT

## Support

For issues and questions, please open an issue in the GitHub repository.

## Resources

- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)
- [MCP Specification](https://spec.modelcontextprotocol.io/)
- [MCP Inspector](https://github.com/modelcontextprotocol/inspector) - Testing and debugging tool
- [Spring AI Documentation](https://docs.spring.io/spring-ai/reference/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)

### Project Documentation

- [Testing Guide](docs/TESTING.md) - How to test with MCP Inspector

## Changelog

### Version 1.0.0 (2026-02-16)
- Initial release
- Basic greeting functionality
- Support for multiple greeting styles
- Spring AI 1.1.2 integration with MCP server support
- Spring Boot 3.5.7
- Java 25 (OpenJDK) support
- Full MCP protocol implementation
- STDIO, SSE, and HTTP transport support
- `@McpTool` annotations for tool definitions
