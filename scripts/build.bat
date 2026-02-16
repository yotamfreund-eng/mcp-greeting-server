@echo off
REM Build script for MCP Greeting Server

echo Building MCP Greeting Server...
echo.

REM Change to repository root
cd /d "%~dp0\.."

REM Set JAVA_HOME if needed (uncomment and adjust path)
REM set "JAVA_HOME=C:\path\to\your\java-25"

REM Clean and build the project (skip tests due to Java 25 class file format)
call gradlew.bat clean build

echo.
echo Build complete!
echo JAR file location: build\libs\mcp-greeting-server-1.0.0.jar
echo.

pause
