@echo off
REM Quick start script for MCP Greeting Server
REM This script runs the Spring Boot application

echo Starting MCP Greeting Server...
echo.

REM Change to repository root
cd /d "%~dp0\.."

REM Set JAVA_HOME if needed (uncomment and adjust path)
REM set "JAVA_HOME=C:\Users\YFreund\.jdks\openjdk-25.0.1"

REM Run the application
call gradlew.bat bootRun

pause
