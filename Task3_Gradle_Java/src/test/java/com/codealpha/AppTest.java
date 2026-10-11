package com.codealpha;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class AppTest {

    @Test
    void testGetMessage() {
        assertEquals(
            "CodeAlpha Gradle CI/CD is working!",
            App.getMessage()
        );
    }
}
