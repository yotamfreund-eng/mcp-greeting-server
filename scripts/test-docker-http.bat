@echo off
REM Test Docker container with HTTP/SSE mode

echo Cleaning up old test containers...
docker rm -f mcp-http-test 2>nul

echo.
echo Starting container with HTTP/SSE mode...
docker run -d -p 8080:8080 -e SPRING_PROFILES_ACTIVE=default --name mcp-http-test mcp-greeting-server:latest

if errorlevel 1 (
    echo ERROR: Failed to start container
    exit /b 1
)

echo.
echo Waiting 10 seconds for application to start...
timeout /t 10 /nobreak

echo.
echo Testing health endpoint...
curl http://localhost:8080/actuator/health

echo.
echo.
echo To view logs: docker logs mcp-http-test
echo To stop: docker stop mcp-http-test
echo To remove: docker rm -f mcp-http-test

