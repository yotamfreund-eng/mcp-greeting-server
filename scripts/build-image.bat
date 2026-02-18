@echo off
REM Build OCI image for MCP Greeting Server using Dockerfile
REM Includes full MCP registry metadata labels

echo ========================================
echo MCP Greeting Server - Image Builder
echo ========================================
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker daemon is not running!
    echo Please start Docker Desktop and try again.
    exit /b 1
)

echo Docker daemon is running...
echo.


REM Get the directory where this script is located
REM %~dp0 gives the drive and path with trailing backslash
set SCRIPT_DIR=%~dp0

REM Search for gradlew.bat by going up directories
set SEARCH_DIR=%SCRIPT_DIR%

:search_loop
if exist "%SEARCH_DIR%gradlew.bat" (
    set PROJECT_ROOT=%SEARCH_DIR:~0,-1%
    goto found_project_root
)

REM Go up one directory
pushd "%SEARCH_DIR%.."
set SEARCH_DIR=%CD%\
popd

REM Check if we've reached the root
if "%SEARCH_DIR:~-2%"==":\" (
    echo ERROR: Could not find gradlew.bat in any parent directory!
    exit /b 1
)

goto search_loop

:found_project_root

REM Build full path to gradlew.bat
set GRADLEW=%PROJECT_ROOT%\gradlew.bat

REM Change to project root for Docker build context
cd /d "%PROJECT_ROOT%"

echo Building Docker image with Dockerfile...
echo This includes full MCP registry metadata labels.
echo.
echo [INFO] Using PROJECT_ROOT: %PROJECT_ROOT%
echo [INFO] Calling: "%GRADLEW%" buildDockerImage
echo.

call "%GRADLEW%" buildDockerImage

if errorlevel 1 (
    echo.
    echo ERROR: Docker build failed!
    exit /b 1
)

echo.
echo ========================================
echo Build Successful!
echo ========================================
echo.
echo Image: mcp-greeting-server:1.0.0
echo Also tagged as: mcp-greeting-server:latest
echo.
echo This image includes full MCP registry OCI labels:
echo   - mcp.protocol.version
echo   - mcp.server.name
echo   - mcp.server.version
echo   - mcp.transport
echo.
echo To run the container with STDIO transport:
echo   docker run -i mcp-greeting-server:latest
echo.
echo To run with HTTP/SSE transport:
echo   docker run -p 8080:8080 -e SPRING_PROFILES_ACTIVE=default mcp-greeting-server:latest
echo.
echo To inspect the image:
echo   docker images mcp-greeting-server
echo   docker inspect mcp-greeting-server:latest
echo.
echo For more information, see docs\DOCKER.md
echo ========================================



