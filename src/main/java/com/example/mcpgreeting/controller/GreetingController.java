package com.example.mcpgreeting.controller;

import com.example.mcpgreeting.config.McpServerProperties;
import com.example.mcpgreeting.model.GreetingRequest;
import com.example.mcpgreeting.model.GreetingResponse;
import com.example.mcpgreeting.service.GreetingService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * REST controller for greeting operations.
 */
@RestController
@RequestMapping("/api/v1")
public class GreetingController {

    private final GreetingService greetingService;
    private final McpServerProperties mcpServerProperties;

    public GreetingController(GreetingService greetingService, McpServerProperties mcpServerProperties) {
        this.greetingService = greetingService;
        this.mcpServerProperties = mcpServerProperties;
    }

    /**
     * Get server information.
     */
    @GetMapping("/info")
    public ResponseEntity<Map<String, String>> getServerInfo() {
        Map<String, String> info = new HashMap<>();
        info.put("name", mcpServerProperties.getName());
        info.put("version", mcpServerProperties.getVersion());
        info.put("description", mcpServerProperties.getDescription());
        return ResponseEntity.ok(info);
    }

    /**
     * Generate a greeting.
     */
    @PostMapping("/greet")
    public ResponseEntity<GreetingResponse> greet(@RequestBody GreetingRequest request) {
        GreetingResponse response = greetingService.generateGreeting(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Generate a farewell message.
     */
    @PostMapping("/farewell")
    public ResponseEntity<GreetingResponse> farewell(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String style) {
        GreetingResponse response = greetingService.generateFarewell(name, style);
        return ResponseEntity.ok(response);
    }

    /**
     * Health check endpoint.
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> health = new HashMap<>();
        health.put("status", "UP");
        return ResponseEntity.ok(health);
    }
}
