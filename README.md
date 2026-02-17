# MCP Greeting Server

A Model Context Protocol (MCP) server that provides greeting functionality, built with Java 25, Gradle, and Spring AI.


## Overview

This server implements the Model Context Protocol to provide greeting-related tools and resources. It can be integrated with MCP-compatible clients to add greeting capabilities to AI assistants.

## Quick Start

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
