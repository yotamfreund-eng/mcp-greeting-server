package com.example.mcpgreeting;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main application class for MCP Greeting Server.
 * This server implements the Model Context Protocol to provide greeting functionality.
 */
@SpringBootApplication
public class McpGreetingApplication {

    static void main(String[] args) {
        SpringApplication.run(McpGreetingApplication.class, args);
    }
}
