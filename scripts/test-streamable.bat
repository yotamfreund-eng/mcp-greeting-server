@echo off
REM Test script for MCP Greeting Server Streamable HTTP endpoint

echo Testing MCP Greeting Server Streamable HTTP endpoint...
echo.

REM Test health endpoint
echo [1/3] Testing health endpoint...
curl -s http://localhost:8080/actuator/health
echo.
echo.

REM Test MCP endpoint availability
echo [2/3] Testing MCP endpoint (should require session ID)...
curl -v http://localhost:8080/mcp -H "Accept: text/event-stream" 2>&1 | findstr "Session"
echo.
echo.

REM Test actuator metrics
echo [3/3] Testing metrics endpoint...
curl -s http://localhost:8080/actuator/metrics
echo.
echo.

echo Test complete!
pause

