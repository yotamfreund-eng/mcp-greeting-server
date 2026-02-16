# GitHub Copilot Instructions for MCP Greeting Server

## Project Structure Conventions

### File Organization

1. **Scripts Directory**: `scripts/`
   - All batch files (`.bat`) must be placed in `scripts/` directory
   - Examples: `build.bat`, `start.bat`, deployment scripts, etc.

2. **Documentation Directory**: `docs/`
   - All markdown documentation files (`.md`) except README.md must be placed in `docs/` directory
   - Examples: `SETUP.md`, `CONTRIBUTING.md`, `ARCHITECTURE.md`, etc.
   - Exception: `README.md` stays in the repository root

3. **Root Directory**
   - Keep only essential files: `README.md`, build configuration files, Docker files, license files
   - Build files: `build.gradle`, `settings.gradle`, `gradle.properties`
   - Docker files: `Dockerfile`, `.dockerignore`
   - Git files: `.gitignore`
   - License: `LICENSE`

4. **IDE Configuration**: `.idea/`
   - **Commit these files** (shared project configuration):
     - `.idea/.gitignore` - IntelliJ's own gitignore
     - `.idea/vcs.xml` - VCS configuration
     - `.idea/misc.xml` - Project settings (JDK, compiler)
     - `.idea/gradle.xml` - Gradle build configuration (delegates build to Gradle)
     - `.idea/compiler.xml` - Compiler settings (bytecode target level)
   - **Do NOT commit** (user-specific):
     - `workspace.xml`, `tasks.xml`, `usage.statistics.xml`
     - `*.iml`, `modules.xml`
     - Copilot settings, databases, dictionaries
     - See `.gitignore` for complete list

### Technology Stack

- **Java Version**: OpenJDK 25 (Eclipse Temurin)
  - Toolchain configured for Java 25
- **Build Tool**: Gradle 9.2.1
- **Framework**: Spring Boot 3.4.3 with Spring AI 1.0.0-M5
- **Protocol**: Model Context Protocol (MCP)

### Build Configuration

- **Group**: `com.example`
- **Artifact**: `mcp-greeting-server`
- **Version**: `1.0.0`
- **Package**: `com.example.mcpgreeting`

### Java 25 Considerations

- Lombok is not compatible with Java 25 - do not add it as a dependency
- Spring Framework tests may fail with class file version 69 - this is a known limitation
- Use `-x test` flag when building until Spring Framework updates ASM library
- Application compiles and runs successfully despite test limitations

### Code Style

1. **Java Naming Conventions**
   - Classes: PascalCase
   - Methods/Variables: camelCase
   - Constants: UPPER_SNAKE_CASE
   - Packages: lowercase

2. **Package Structure**
   - `config/` - Configuration classes
   - `controller/` - REST controllers
   - `service/` - Business logic services
   - `model/` - Domain models and DTOs
   - `mcp/` - MCP protocol implementation

3. **Documentation**
   - Add Javadoc comments to public classes and methods
   - Use descriptive variable and method names
   - Include README updates when adding new features

### Build Commands

```cmd
# Build (skip tests due to Java 25)
gradlew.bat build -x test

# Run application
gradlew.bat bootRun

# Clean build
gradlew.bat clean build -x test
```

### Environment Setup

- Always set JAVA_HOME when running Gradle commands:
  ```cmd
  set "JAVA_HOME=C:\Users\YFreund\\.jdks\\openjdk-25.0.1"
  ```

### Git Workflow

- All scripts should be executable and tested
- Update documentation when adding new features
- Keep README.md in sync with actual project state
- No references to Foglight or Quest in any documentation

### Spring Boot Configuration

- Configuration in `src/main/resources/application.yml`
- Test configuration in `src/test/resources/application-test.yml`
- Use externalized configuration via environment variables when needed
- Main application class: `com.example.mcpgreeting.McpGreetingApplication`

### Docker

- Base image: `eclipse-temurin:25-jdk-alpine` (builder)
- Runtime image: `eclipse-temurin:25-jre-alpine`
- Multi-stage builds preferred for smaller image size

## When Creating New Features

1. Place any new scripts in `scripts/` directory
2. Place any new documentation in `docs/` directory
3. Follow the existing package structure
4. Update README.md if the feature is user-facing
5. Ensure Java 25 compatibility
6. Test with Gradle 9.2.1
7. Update application.yml if new configuration is needed

## Reference Documentation

- Main README: `/README.md`
- Setup Guide: `/docs/SETUP.md`
- Build Script: `/scripts/build.bat`
- Start Script: `/scripts/start.bat`
