package com.example.mcpgreeting.service;

import com.example.mcpgreeting.model.GreetingRequest;
import com.example.mcpgreeting.model.GreetingResponse;
import org.springframework.stereotype.Service;

/**
 * Service for generating greetings.
 */
@Service
public class GreetingService {

    /**
     * Generate a greeting based on the request.
     *
     * @param request the greeting request
     * @return the greeting response
     */
    public GreetingResponse generateGreeting(GreetingRequest request) {
        String name = request.getName() != null ? request.getName() : "there";
        String style = request.getStyle() != null ? request.getStyle() : "formal";

        String message = switch (style.toLowerCase()) {
            case "casual" -> "Hey " + name + "! What's up?";
            case "friendly" -> "Hi " + name + "! Nice to see you!";
            case "professional" -> "Good day, " + name + ". How may I assist you?";
            default -> "Hello, " + name + ". Welcome!";
        };

        return new GreetingResponse(message, style);
    }

    /**
     * Generate a farewell message.
     *
     * @param name the name to use in the farewell
     * @param style the style of farewell
     * @return the farewell response
     */
    public GreetingResponse generateFarewell(String name, String style) {
        name = name != null ? name : "there";
        style = style != null ? style : "formal";

        String message = switch (style.toLowerCase()) {
            case "casual" -> "See you later, " + name + "!";
            case "friendly" -> "Bye " + name + "! Take care!";
            case "professional" -> "Farewell, " + name + ". Have a productive day.";
            default -> "Goodbye, " + name + ".";
        };

        return new GreetingResponse(message, style);
    }
}
