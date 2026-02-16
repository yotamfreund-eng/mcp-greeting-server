package com.example.mcpgreeting.mcp.tools;

import org.springaicommunity.mcp.annotation.McpTool;
import org.springaicommunity.mcp.annotation.McpToolParam;
import org.springframework.stereotype.Component;

/**
 * MCP Tool for generating personalized greetings.
 * This tool can be called by MCP clients to generate various types of greetings.
 */
@Component
public class GreetingTool {

    /**
     * Generate a personalized greeting message.
     *
     * @param name the name of the person to greet
     * @param style the greeting style (formal, casual, friendly, professional)
     * @param language the language for the greeting (english, spanish, french - default: english)
     * @return a personalized greeting message
     */
    @McpTool(
        name = "greet",
        description = "Generate a personalized greeting message with different styles"
    )
    public String greet(
            @McpToolParam(description = "The name of the person to greet", required = true)
            String name,

            @McpToolParam(description = "The greeting style: formal, casual, friendly, or professional", required = false)
            String style,

            @McpToolParam(description = "The language for the greeting: english, spanish, or french (default: english)", required = false)
            String language
    ) {
        // Default values
        if (style == null || style.isEmpty()) {
            style = "formal";
        }
        if (language == null || language.isEmpty()) {
            language = "english";
        }

        // Generate greeting based on style and language
        return generateGreeting(name, style, language);
    }

    /**
     * Generate a farewell message.
     *
     * @param name the name of the person to bid farewell to
     * @param style the farewell style (formal, casual, friendly, professional)
     * @return a farewell message
     */
    @McpTool(
        name = "farewell",
        description = "Generate a farewell message with different styles"
    )
    public String farewell(
            @McpToolParam(description = "The name of the person to bid farewell to", required = true)
            String name,

            @McpToolParam(description = "The farewell style: formal, casual, friendly, or professional", required = false)
            String style
    ) {
        if (style == null || style.isEmpty()) {
            style = "formal";
        }

        return generateFarewell(name, style);
    }

    /**
     * Get a casual greeting.
     *
     * @param name the name of the person to greet
     * @return a casual greeting message
     */
    @McpTool(
        name = "casual_greeting",
        description = "Generate a casual, informal greeting"
    )
    public String casualGreeting(
            @McpToolParam(description = "The name of the person to greet", required = true)
            String name
    ) {
        return greet(name, "casual", "english");
    }

    /**
     * Generate greeting message based on style and language.
     */
    private String generateGreeting(String name, String style, String language) {
        String greeting;

        // Language-specific greetings
        if ("spanish".equalsIgnoreCase(language)) {
            greeting = switch (style.toLowerCase()) {
                case "casual" -> "¡Hola " + name + "! ¿Qué tal?";
                case "friendly" -> "¡Hola " + name + "! ¡Qué gusto verte!";
                case "professional" -> "Buenos días, " + name + ". ¿En qué puedo ayudarle?";
                default -> "Hola, " + name + ". Bienvenido/a.";
            };
        } else if ("french".equalsIgnoreCase(language)) {
            greeting = switch (style.toLowerCase()) {
                case "casual" -> "Salut " + name + "! Ça va?";
                case "friendly" -> "Bonjour " + name + "! Ravi de te voir!";
                case "professional" -> "Bonjour, " + name + ". Comment puis-je vous aider?";
                default -> "Bonjour, " + name + ". Bienvenue.";
            };
        } else {
            // English greetings
            greeting = switch (style.toLowerCase()) {
                case "casual" -> "Hey " + name + "! What's up?";
                case "friendly" -> "Hi " + name + "! Nice to see you!";
                case "professional" -> "Good day, " + name + ". How may I assist you?";
                default -> "Hello, " + name + ". Welcome!";
            };
        }

        return greeting;
    }

    /**
     * Generate farewell message based on style.
     */
    private String generateFarewell(String name, String style) {
        return switch (style.toLowerCase()) {
            case "casual" -> "See you later, " + name + "!";
            case "friendly" -> "Bye " + name + "! Take care!";
            case "professional" -> "Farewell, " + name + ". Have a productive day.";
            default -> "Goodbye, " + name + ".";
        };
    }
}
