@echo off
REM Script to test MCP server with SSE transport (RECOMMENDED METHOD)
REM This is much more reliable than STDIO transport

echo ===============================================
echo   MCP Greeting Server - SSE Transport Test
echo ===============================================
echo.
echo This script will:
echo 1. Start the server with bootRun (you'll see logs)
echo 2. Wait for you to test with MCP Inspector
echo 3. Press Ctrl+C to stop when done
echo.
echo After the server starts:
echo   Open a NEW terminal and run:
echo   npx @modelcontextprotocol/inspector --transport sse --url http://localhost:8080/mcp/sse
echo.
echo ===============================================
echo.

pause

echo Starting server...
gradlew.bat bootRun
