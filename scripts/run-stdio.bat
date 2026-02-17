@echo off
REM Script to run the MCP Greeting Server with STDIO transport
REM This script disables console logging to prevent JSON parsing conflicts
REM
REM IMPORTANT: No echo statements allowed! They pollute stdout and break MCP protocol.
REM Application logs go to: logs/mcp-greeting-server.log

:run
REM Activate the stdio Spring profile to disable console logging
REM NOTE: We do NOT forward script arguments (%*) because MCP Inspector
REM passes the full command as arguments, which would duplicate the Java command
java -Dspring.profiles.active=stdio -jar build\libs\mcp-greeting-server-1.0.0.jar
