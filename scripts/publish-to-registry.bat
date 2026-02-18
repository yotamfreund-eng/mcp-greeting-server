@echo off
REM MCP Registry Publishing Script for Windows
REM This script guides you through publishing the MCP Greeting Server to the MCP Registry

echo ============================================
echo MCP Registry Publishing Script
echo ============================================
echo.

REM Check if mcp-publisher is installed
where mcp-publisher >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] mcp-publisher is not installed or not in PATH
    echo.
    echo Please install mcp-publisher first:
    echo.
    echo PowerShell command:
    echo $arch = if ([System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture -eq "Arm64") { "arm64" } else { "amd64" }
    echo Invoke-WebRequest -Uri "https://github.com/modelcontextprotocol/registry/releases/latest/download/mcp-publisher_windows_$arch.tar.gz" -OutFile "mcp-publisher.tar.gz"
    echo tar xf mcp-publisher.tar.gz mcp-publisher.exe
    echo rm mcp-publisher.tar.gz
    echo.
    echo Then move mcp-publisher.exe to a directory in your PATH
    echo.
    pause
    exit /b 1
)

echo [OK] mcp-publisher is installed
echo.

REM Check if mcp-registry.json exists
if not exist "mcp-registry.json" (
    echo [ERROR] mcp-registry.json not found in current directory
    echo.
    echo Please ensure you are in the project root directory
    pause
    exit /b 1
)

echo [OK] mcp-registry.json found
echo.

REM Step 1: Authenticate
echo ============================================
echo Step 1: Authenticate with GitHub
echo ============================================
echo.
echo This will use GitHub device code flow for authentication...
echo A device code and URL will be displayed.
echo You'll need to open the URL in your browser and enter the code.
echo.
pause

mcp-publisher login github
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Authentication failed
    pause
    exit /b 1
)

echo.
echo [OK] Authentication successful
echo.

REM Step 2: Validate
echo ============================================
echo Step 2: Validate Configuration
echo ============================================
echo.
echo Validating mcp-registry.json and Docker image...
echo.

mcp-publisher validate mcp-registry.json
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Validation failed
    echo.
    echo Please fix the errors above and try again
    pause
    exit /b 1
)

echo.
echo [OK] Validation successful
echo.

REM Step 3: Publish
echo ============================================
echo Step 3: Publish to MCP Registry
echo ============================================
echo.
echo Ready to publish your server to the MCP Registry
echo.
set /p CONFIRM="Proceed with publishing? (y/n): "
if /i not "%CONFIRM%"=="y" (
    echo.
    echo Publishing cancelled
    pause
    exit /b 0
)

echo.
echo Publishing...
echo.

mcp-publisher publish mcp-registry.json
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Publishing failed
    pause
    exit /b 1
)

echo.
echo [SUCCESS] Published successfully!
echo.

REM Step 4: Verify publication
echo ============================================
echo Step 4: Verify Publication
echo ============================================
echo.
echo Your server is now live on the MCP Registry!
echo.
echo Visit your server's registry page:
echo https://modelcontextprotocol.io/registry/io.github.yotamfreund-eng/greeting
echo.

echo.
echo ============================================
echo Publishing Complete!
echo ============================================
echo.
echo Your server is immediately available on the MCP Registry.
echo Users can now discover and install your server!
echo.
pause

