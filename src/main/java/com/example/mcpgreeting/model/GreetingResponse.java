package com.example.mcpgreeting.model;

import lombok.Getter;
import lombok.Setter;

/**
 * Represents a greeting response.
 */
@Setter
@Getter
public class GreetingResponse {

    private String message;
    private String style;
    private long timestamp;

    public GreetingResponse() {
        this.timestamp = System.currentTimeMillis();
    }

    public GreetingResponse(String message, String style) {
        this.message = message;
        this.style = style;
        this.timestamp = System.currentTimeMillis();
    }

}
