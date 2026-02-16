package com.example.mcpgreeting.model;

import lombok.Getter;
import lombok.Setter;

/**
 * Represents a greeting request.
 */
@Setter
@Getter
public class GreetingRequest {

    private String name;
    private String style;
    private String language;

    public GreetingRequest() {
    }

    public GreetingRequest(String name, String style, String language) {
        this.name = name;
        this.style = style;
        this.language = language;
    }

}
