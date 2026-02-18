# Publishing to MCP Registry

This guide explains how to publish the MCP Greeting Server to the official Model Context Protocol Registry.

## Overview

The [MCP Registry](https://modelcontextprotocol.io/registry) is a centralized directory where users can discover and install MCP servers. Publishing your server makes it easily accessible to Claude Desktop users and other MCP clients.

## Prerequisites

Before publishing, ensure you have:

1. ✅ Built the Docker/OCI image with MCP registry labels
2. ✅ GitHub account (for authentication)
3. ✅ Container registry account (Docker Hub, GitHub Container Registry, etc.)
4. ✅ Tested your server with an MCP client

## Step-by-Step Publishing Guide

### Step 1: Build and Tag Your Image

Build the image with all required MCP registry labels:

```cmd
gradlew.bat buildDockerImage
```

This creates:
- `mcp-greeting-server:1.0.0`
- `mcp-greeting-server:latest`

### Step 2: Choose a Container Registry

You need to push your image to a public container registry. Popular options:

#### Option A: Docker Hub (Recommended)

1. **Create Docker Hub account**: https://hub.docker.com/signup
2. **Login**:
   ```cmd
   docker login
   ```
3. **Tag your image**:
   ```cmd
   docker tag mcp-greeting-server:1.0.0 YOUR_USERNAME/mcp-greeting-server:1.0.0
   docker tag mcp-greeting-server:1.0.0 YOUR_USERNAME/mcp-greeting-server:latest
   ```
4. **Push to Docker Hub**:
   ```cmd
   docker push YOUR_USERNAME/mcp-greeting-server:1.0.0
   docker push YOUR_USERNAME/mcp-greeting-server:latest
   ```

#### Option B: GitHub Container Registry (ghcr.io)

1. **Create GitHub Personal Access Token**:
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Select scopes: `write:packages`, `read:packages`, `delete:packages`

2. **Login to GHCR**:
   ```cmd
   echo YOUR_PAT | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
   ```

3. **Tag your image**:
   ```cmd
   docker tag mcp-greeting-server:1.0.0 ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:1.0.0
   docker tag mcp-greeting-server:1.0.0 ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:latest
   ```

4. **Push to GHCR**:
   ```cmd
   docker push ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:1.0.0
   docker push ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:latest
   ```

5. **Make package public**:
   - Go to: https://github.com/YOUR_USERNAME?tab=packages
   - Click on `mcp-greeting-server`
   - Click "Package settings"
   - Scroll to "Danger Zone" → "Change visibility" → "Public"

### Step 3: Verify Your Image

Before submitting to the registry, verify your image works correctly:

**If you used Docker Hub (Option A):**
```cmd
# Pull your published image
docker pull YOUR_USERNAME/mcp-greeting-server:latest

# Test STDIO mode (--rm auto-removes container after testing)
docker run -i --rm YOUR_USERNAME/mcp-greeting-server:latest
```

**If you used GitHub Container Registry (Option B):**
```cmd
# Pull your published image
docker pull ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:latest

# Test STDIO mode (--rm auto-removes container after testing)
docker run -i --rm ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:latest
```

Type an initialize request:
```json
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
```

You should see a JSON-RPC response with server capabilities. Press `Ctrl+C` to exit - the `--rm` flag will automatically remove the container.

### Step 4: Verify OCI Labels

Ensure all required MCP labels are present:

**For Docker Hub (Option A):**
```cmd
docker inspect YOUR_USERNAME/mcp-greeting-server:latest --format='{{json .Config.Labels}}' | jq
```

**For GitHub Container Registry (Option B):**
```cmd
docker inspect ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:latest --format='{{json .Config.Labels}}' | jq
```

**Required MCP labels** (must be present):
- ✅ `mcp.protocol.version` = `2024-11-05`
- ✅ `mcp.server.name` = `greeting`
- ✅ `mcp.server.version` = `1.0.0`
- ✅ `mcp.transport` = `stdio`
- ✅ `io.modelcontextprotocol.server.name` = `io.github.yotamfreund-eng/greeting` (must match registry config name)

**Required OCI standard labels** (must be present):
- ✅ `org.opencontainers.image.title` = `MCP Greeting Server`
- ✅ `org.opencontainers.image.description` = Description text
- ✅ `org.opencontainers.image.version` = `1.0.0`
- ✅ `org.opencontainers.image.licenses` = `MIT`

**Recommended OCI labels** (should be present):
- ✅ `org.opencontainers.image.source` = Repository URL
- ✅ `org.opencontainers.image.url` = Homepage URL
- ✅ `org.opencontainers.image.documentation` = Documentation URL
- ✅ `org.opencontainers.image.authors` = Author name
- ✅ `org.opencontainers.image.vendor` = Organization/vendor name

### Step 5: Test Your Published Image

Before submitting to the registry, thoroughly test your published image:

**Test STDIO Communication:**

**For Docker Hub:**
```cmd
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | docker run -i --rm YOUR_USERNAME/mcp-greeting-server:latest
```

**For GitHub Container Registry:**
```cmd
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | docker run -i --rm ghcr.io/yotamfreund-eng/mcp-greeting-server:latest
```

**Expected response:**
```json
{"jsonrpc":"2.0","id":1,"result":{"protocolVersion":"2024-11-05","capabilities":{"tools":{},"prompts":{},"resources":{}},"serverInfo":{"name":"greeting","version":"1.0.0"}}}
```

**Test with MCP Inspector (Recommended):**
```cmd
# For Docker Hub
npx @modelcontextprotocol/inspector docker run -i --rm YOUR_USERNAME/mcp-greeting-server:latest

# For GHCR
npx @modelcontextprotocol/inspector docker run -i --rm ghcr.io/yotamfreund-eng/mcp-greeting-server:latest
```

This opens a web UI where you can:
- Initialize the connection
- Call tools interactively
- Test prompts
- View logs and messages

See [TESTING.md](TESTING.md) for detailed testing instructions.

### Step 6: Submit to MCP Registry

The MCP Registry uses the `mcp-publisher` CLI tool for submissions. This tool validates your server and submits it to the registry.

#### 6.1: Install mcp-publisher

**On Windows (PowerShell):**
```powershell
$arch = if ([System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture -eq "Arm64") { "arm64" } else { "amd64" }
Invoke-WebRequest -Uri "https://github.com/modelcontextprotocol/registry/releases/latest/download/mcp-publisher_windows_$arch.tar.gz" -OutFile "mcp-publisher.tar.gz"
tar xf mcp-publisher.tar.gz mcp-publisher.exe
rm mcp-publisher.tar.gz

# Move to a directory in your PATH (e.g., C:\Windows\System32 or create a tools directory)
# Or add the current directory to your PATH
```

**On Linux/macOS:**
```bash
curl -L "https://github.com/modelcontextprotocol/registry/releases/latest/download/mcp-publisher_$(uname -s | tr '[:upper:]' '[:lower:]')_$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/').tar.gz" | tar xz mcp-publisher
sudo mv mcp-publisher /usr/local/bin/
```

Verify installation:
```cmd
mcp-publisher --version
```

#### 6.2: Create Registry Configuration File

Create a file named `mcp-registry.json` in your project root with your server's metadata:

> **Note**: The default filename is `server.json`, but you can use any name (like `mcp-registry.json`). The `mcp-publisher` commands accept a filename argument. If you prefer the default name, create `server.json` instead and you can omit the filename from commands (e.g., `mcp-publisher publish` instead of `mcp-publisher publish mcp-registry.json`).

**For Docker Hub:**
```json
{
  "$schema": "https://static.modelcontextprotocol.io/schemas/2025-12-11/server.schema.json",
  "name": "io.github.YOUR_USERNAME/greeting",
  "title": "MCP Greeting Server",
  "description": "MCP server providing personalized greetings with AI-powered tools using Spring Boot",
  "version": "1.0.0",
  "packages": [
    {
      "registryType": "oci",
      "identifier": "docker.io/YOUR_USERNAME/mcp-greeting-server:latest",
      "transport": {
        "type": "stdio"
      }
    }
  ]
}
```

**For GitHub Container Registry:**
```json
{
  "$schema": "https://static.modelcontextprotocol.io/schemas/2025-12-11/server.schema.json",
  "name": "io.github.yotamfreund-eng/greeting",
  "title": "MCP Greeting Server",
  "description": "MCP server providing personalized greetings with AI-powered tools using Spring Boot and Spring AI",
  "version": "1.0.0",
  "packages": [
    {
      "registryType": "oci",
      "identifier": "ghcr.io/yotamfreund-eng/mcp-greeting-server:latest",
      "transport": {
        "type": "stdio"
      }
    }
  ]
}
```

**Configuration Fields Explained:**
- `$schema`: Schema URL for validation (required: `https://static.modelcontextprotocol.io/schemas/2025-12-11/server.schema.json`)
- `name`: Unique identifier in format `io.github.owner/server-name` (required)
- `title`: Human-readable name shown in the registry
- `description`: Short description (required, max 100 characters)
- `version`: Current version (must match your Docker image version)
- `packages`: Array of package definitions (required, at least one package)
  - `registryType`: Package type, must be `"oci"` for Docker/OCI images
  - `identifier`: Full image reference including registry, name, and tag
  - `transport.type`: Communication transport, must be `"stdio"` for MCP servers

#### 6.3: Authenticate with GitHub

The `mcp-publisher` tool requires GitHub authentication:

```cmd
# Interactive GitHub authentication using device code flow
mcp-publisher login github
```

Follow the prompts to:
1. A device code and URL will be displayed in the terminal
2. Open the provided URL in your browser (e.g., https://github.com/login/device)
3. Enter the device code shown in your terminal
4. Sign in to GitHub
5. Authorize the MCP Registry application
6. Return to the terminal - authentication will complete automatically

#### 6.4: Validate Your Configuration

Before publishing, validate your configuration and Docker image:

```cmd
mcp-publisher validate mcp-registry.json
```

This will check:
- ✅ JSON configuration is valid
- ✅ Docker image is publicly accessible
- ✅ Required OCI labels are present
- ✅ STDIO transport is working
- ✅ All required fields are provided

Fix any validation errors before proceeding.

#### 6.5: Publish to Registry

Once validation passes, publish your server:

```cmd
mcp-publisher publish mcp-registry.json
```

The tool will:
1. Verify your authentication
2. Validate your configuration
3. Test your Docker image
4. Submit to the MCP Registry
5. Provide a submission ID for tracking

**Expected output:**
```
Publishing to https://registry.modelcontextprotocol.io...
✓ Successfully published
✓ Server io.github.yotamfreund-eng/greeting version 1.0.0
```

Your server is now live on the MCP Registry!

#### 6.6: Verify Your Published Server

After publishing, verify your server is live using the MCP Registry REST API.

**Important Notes:**
- The MCP Registry does **not** have a web UI at `modelcontextprotocol.io/registry/...` (returns 404)
- You must use the REST API endpoints
- URL path parameters must be URL-encoded (e.g., `/` becomes `%2F`)
- API endpoints require version prefix: `/v0.1/` or `/v0/`

**Query all versions of your server:**

```cmd
# Get all versions of your server
curl "https://registry.modelcontextprotocol.io/v0.1/servers/io.github.yotamfreund-eng%2Fgreeting/versions"
```

**Windows PowerShell:**
```powershell
Invoke-RestMethod -Uri "https://registry.modelcontextprotocol.io/v0.1/servers/io.github.yotamfreund-eng%2Fgreeting/versions" | ConvertTo-Json -Depth 10
```

**Expected response:**
```json
{
  "servers": [
    {
      "server": {
        "$schema": "https://static.modelcontextprotocol.io/schemas/2025-12-11/server.schema.json",
        "name": "io.github.yotamfreund-eng/greeting",
        "description": "MCP server providing personalized greetings with AI-powered tools using Spring Boot and Spring AI",
        "title": "MCP Greeting Server",
        "version": "1.0.0",
        "packages": [
          {
            "registryType": "oci",
            "identifier": "ghcr.io/yotamfreund-eng/mcp-greeting-server:latest",
            "transport": {
              "type": "stdio"
            }
          }
        ]
      },
      "_meta": {
        "io.modelcontextprotocol.registry/official": {
          "status": "active",
          "publishedAt": "2026-02-18T15:31:41.651064Z",
          "updatedAt": "2026-02-18T15:31:41.651064Z",
          "isLatest": true
        }
      }
    }
  ],
  "metadata": {
    "count": 1
  }
}
```

**Key fields in the response:**
- `_meta.status`: Should be `"active"` when successfully published
- `_meta.isLatest`: Indicates this is the latest version
- `_meta.publishedAt`: Timestamp of initial publication
- `server`: Your complete server configuration

**Query a specific version:**

```cmd
# Get a specific version (e.g., 1.0.0)
curl "https://registry.modelcontextprotocol.io/v0.1/servers/io.github.yotamfreund-eng%2Fgreeting/versions/1.0.0"
```

**API Documentation:**

For complete REST API documentation, see:
- https://modelcontextprotocol.io/registry/registry-aggregators#consuming-the-mcp-registry-rest-api
- API docs: https://registry.modelcontextprotocol.io/docs


### Step 7: Verify Publication

Once published, your server is **immediately available** on the MCP Registry.

**Verify using the REST API:**

The MCP Registry provides a REST API for verification. **Important**: 
- Server names must be URL-encoded in the URL path (e.g., `/` becomes `%2F`)
- API endpoints require version prefix: `/v0.1/` or `/v0/`

**Query all versions:**
```cmd
# Get all versions of your server (note: / is encoded as %2F)
curl "https://registry.modelcontextprotocol.io/v0.1/servers/io.github.yotamfreund-eng%2Fgreeting/versions"
```

**Windows PowerShell:**
```powershell
Invoke-RestMethod -Uri "https://registry.modelcontextprotocol.io/v0.1/servers/io.github.yotamfreund-eng%2Fgreeting/versions" | ConvertTo-Json -Depth 10
```

**Query a specific version:**
```cmd
# Get version 1.0.0
curl "https://registry.modelcontextprotocol.io/v0.1/servers/io.github.yotamfreund-eng%2Fgreeting/versions/1.0.0"
```

**What to look for in the response:**
- ✅ `_meta.status` = `"active"` (server is live)
- ✅ `_meta.isLatest` = `true` (this is the latest version)
- ✅ `server.name` = `"io.github.yotamfreund-eng/greeting"` (your server)
- ✅ `server.version` = `"1.0.0"` (your version)
- ✅ `_meta.publishedAt` = timestamp (when it was published)

**For more information about the REST API:**
- [MCP Registry REST API Documentation](https://modelcontextprotocol.io/registry/registry-aggregators#consuming-the-mcp-registry-rest-api)
- [API Interactive Docs](https://registry.modelcontextprotocol.io/docs)

## Post-Publication

### Update Your README

Once approved, add the registry badge to your `README.md`:

```markdown
[![MCP Registry](https://img.shields.io/badge/MCP-Registry-blue)](https://modelcontextprotocol.io/registry/greeting)
```

### Publishing Updates

To publish a new version:

1. **Update version** in `gradle.properties`:
   ```properties
   version=1.1.0
   ```

2. **Update Dockerfile** (if label version is hardcoded):
   ```dockerfile
   LABEL mcp.server.version="1.1.0"
   LABEL org.opencontainers.image.version="1.1.0"
   ```

3. **Rebuild and push**:
   ```cmd
   gradlew.bat buildDockerImage
   docker tag mcp-greeting-server:1.1.0 YOUR_USERNAME/mcp-greeting-server:1.1.0
   docker tag mcp-greeting-server:1.1.0 YOUR_USERNAME/mcp-greeting-server:latest
   docker push YOUR_USERNAME/mcp-greeting-server:1.1.0
   docker push YOUR_USERNAME/mcp-greeting-server:latest
   ```

4. **Update registry listing**:
   - Go to MCP Registry dashboard
   - Edit your server entry
   - Update version number
   - Submit for review

## Claude Desktop Integration

Once published, users can install your server in Claude Desktop:

### Manual Configuration

Users add to `claude_desktop_config.json`:

**Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`

**For Docker Hub:**
```json
{
  "mcpServers": {
    "greeting": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "YOUR_USERNAME/mcp-greeting-server:latest"]
    }
  }
}
```

**For GitHub Container Registry:**
```json
{
  "mcpServers": {
    "greeting": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:latest"]
    }
  }
}
```

### Registry-based Installation (Future)

The MCP Registry may offer one-click installation in future versions.

## Verification Checklist

Before submitting to the registry, verify:

- [ ] Image is publicly accessible on Docker Hub or GHCR
- [ ] Can pull image without authentication: 
  - Docker Hub: `docker pull YOUR_USERNAME/mcp-greeting-server:latest`
  - GHCR: `docker pull ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:latest`
- [ ] Image has all required OCI labels (use `docker inspect`)
- [ ] STDIO transport works: `echo '{"jsonrpc":"2.0",...}' | docker run -i --rm ...`
- [ ] README.md has clear usage instructions
- [ ] Repository has MIT license file
- [ ] Documentation includes example MCP client configuration
- [ ] Image size is reasonable (< 500 MB preferred)
- [ ] No hardcoded secrets or API keys in image

## Troubleshooting

### Submission Rejected: "Image not accessible"

**Solution**: Ensure image is public:
- Docker Hub: Repository settings → Make Public
- GHCR: Package settings → Change visibility → Public

### Submission Rejected: "Missing required labels"

**Solution**: Rebuild with Dockerfile that includes all labels:
```cmd
gradlew.bat buildDockerImage
```

Verify labels:
```cmd
docker inspect YOUR_USERNAME/mcp-greeting-server:latest --format='{{.Config.Labels}}'
```

### Submission Rejected: "STDIO not working"

**Solution**: Verify the Dockerfile has:
```dockerfile
ENV SPRING_PROFILES_ACTIVE=stdio
CMD ["java", "-jar", "/app/mcp-greeting-server.jar", "--spring.profiles.active=stdio"]
```

Test manually:
```cmd
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | docker run -i --rm YOUR_USERNAME/mcp-greeting-server:latest
```

### Can't authenticate with GitHub

**Solution**: 
- Clear browser cache and cookies
- Try incognito/private browsing mode
- Ensure GitHub account is verified (email confirmed)

### Image too large (> 1 GB)

**Solution**:
- Use Alpine-based images (already done in this project)
- Remove unnecessary dependencies
- Use multi-stage builds (already done)
- Clean build artifacts

## Best Practices

1. **Semantic Versioning**: Use `major.minor.patch` (e.g., `1.0.0`, `1.1.0`, `2.0.0`)
2. **Tag both specific and latest**: Push both `1.0.0` and `latest` tags
3. **Documentation**: Provide clear README with examples
4. **Testing**: Test with Claude Desktop before publishing
5. **Security**: Never include API keys or secrets in the image
6. **Updates**: Regularly update dependencies and security patches
7. **Changelog**: Maintain a CHANGELOG.md for version history

## Example: Complete Publishing Flow

Here's the complete flow from build to publish:

**Using Docker Hub (Option A):**

```cmd
# 1. Build the image with MCP labels
gradlew.bat buildDockerImage

# 2. Login to Docker Hub
docker login

# 3. Tag for Docker Hub (replace YOUR_USERNAME)
docker tag mcp-greeting-server:1.0.0 YOUR_USERNAME/mcp-greeting-server:1.0.0
docker tag mcp-greeting-server:1.0.0 YOUR_USERNAME/mcp-greeting-server:latest

# 4. Push to Docker Hub
docker push YOUR_USERNAME/mcp-greeting-server:1.0.0
docker push YOUR_USERNAME/mcp-greeting-server:latest

# 5. Test the published image
docker pull YOUR_USERNAME/mcp-greeting-server:latest
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | docker run -i --rm YOUR_USERNAME/mcp-greeting-server:latest

# 6. Verify labels
docker inspect YOUR_USERNAME/mcp-greeting-server:latest --format='{{json .Config.Labels}}' | jq

# 7. Create mcp-registry.json configuration file (see Step 6.2)

# 8. Install mcp-publisher (if not already installed)
# Windows: See Step 6.1 for PowerShell commands
# Linux/macOS: See Step 6.1 for curl commands

# 9. Authenticate with GitHub
mcp-publisher login github

# 10. Validate configuration
mcp-publisher validate mcp-registry.json

# 11. Publish to registry
mcp-publisher publish mcp-registry.json

# 12. Verify via REST API
# curl "https://registry.modelcontextprotocol.io/v0.1/servers/io.github.YOUR_USERNAME%2Fgreeting/versions"
```

**Using GitHub Container Registry (Option B):**

```cmd
# 1. Build the image with MCP labels
gradlew.bat buildDockerImage

# 2. Login to GHCR (replace YOUR_PAT with your Personal Access Token)
echo YOUR_PAT | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin

# 3. Tag for GHCR (replace YOUR_GITHUB_USERNAME)
docker tag mcp-greeting-server:1.0.0 ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:1.0.0
docker tag mcp-greeting-server:1.0.0 ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:latest

# 4. Push to GHCR
docker push ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:1.0.0
docker push ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:latest

# 5. Make package public (go to GitHub → Packages → mcp-greeting-server → Settings → Change visibility → Public)

# 6. Test the published image
docker pull ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:latest
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | docker run -i --rm ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:latest

# 7. Verify labels
docker inspect ghcr.io/YOUR_GITHUB_USERNAME/mcp-greeting-server:latest --format='{{json .Config.Labels}}' | jq

# 8. Create mcp-registry.json with ghcr.io image URL (see Step 6.2)

# 9. Install mcp-publisher (if not already installed)
# Windows: See Step 6.1 for PowerShell commands
# Linux/macOS: See Step 6.1 for curl commands

# 10. Authenticate with GitHub
mcp-publisher login github

# 11. Validate configuration
mcp-publisher validate mcp-registry.json

# 12. Publish to registry
mcp-publisher publish mcp-registry.json

# 13. Verify via REST API
# curl "https://registry.modelcontextprotocol.io/v0.1/servers/io.github.yotamfreund-eng%2Fgreeting/versions"
```


## Additional Resources

- **MCP Registry**: https://modelcontextprotocol.io/registry
- **MCP Registry Quickstart**: https://modelcontextprotocol.io/registry/quickstart
- **MCP Registry REST API**: https://modelcontextprotocol.io/registry/registry-aggregators#consuming-the-mcp-registry-rest-api
- **Docker/OCI Package Types**: https://modelcontextprotocol.io/registry/package-types#docker/oci-images
- **MCP Protocol Spec**: https://spec.modelcontextprotocol.io/
- **Docker Hub**: https://hub.docker.com/
- **GitHub Container Registry**: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry

## Support

If you encounter issues during publishing:
- Check the [MCP Discord](https://discord.gg/modelcontextprotocol) community
- Open an issue on the MCP Registry GitHub repository
- Review the official documentation

---

**Need Help?**
- See [DOCKER.md](DOCKER.md) for Docker/OCI image details
- See [README.md](../README.md) for general server documentation
- See [TESTING.md](TESTING.md) for testing instructions

