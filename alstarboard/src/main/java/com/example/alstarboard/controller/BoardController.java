package com.example.alstarboard.controller;

import com.example.alstarboard.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
// /board로 끝나는 모든 request는 얘한테 들어옴.
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {
    private final BoardService boardService;

    @GetMapping('/list')
    void getBoardList() {
        // request url이 특정 방식으로 끝나면 해당 controller가 request 받아서 service에게 일 시킨다.
    }
}
