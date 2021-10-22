package com.springboot.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * http://localhost:8388/test/1
 */
@RestController
@RequestMapping(value = "/test")
public class TestController {

    @GetMapping(value = "/1")
    public String get() {
        return "hello, world";
    }

}
