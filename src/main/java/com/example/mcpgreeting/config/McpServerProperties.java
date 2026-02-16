package com.example.mcpgreeting.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration properties for MCP server.
 */
@Setter
@Getter
@Configuration
@ConfigurationProperties(prefix = "mcp.server")
public class McpServerProperties {

    private String name;
    private String version;
    private String description;

}
