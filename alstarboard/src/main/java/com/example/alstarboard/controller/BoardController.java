package com.example.alstarboard.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
// /board로 끝나는 모든 request는 얘한테 들어옴.
@RequestMapping("/board")

public class BoardController {
    void getBoardList() {

    }
}
