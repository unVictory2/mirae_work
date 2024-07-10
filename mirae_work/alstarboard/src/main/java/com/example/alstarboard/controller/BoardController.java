package com.example.alstarboard.controller;

import com.example.alstarboard.dto.BoardDTO;
import com.example.alstarboard.entity.Board;
import com.example.alstarboard.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

// url 처리 전부 여기서 한다
// 가장 기본적인 board 테이블에 대해서 crud (create read update delete) 구현.
// controller : 분기만 해줌. 실제 일은 service에서 전부.

@RestController
@RequestMapping("/api/board")
@RequiredArgsConstructor
public class BoardController {
    // 반드시 private final로 만들어야 외부에서 injection 해줌,
    // @RequiredArgsConstructor도 써줘야 함.
    private final BoardService boardService;

    @GetMapping
    public String getBoards() {
        return "board";
    }

    // 127.0.0.1:8080/api/board/page?page=0&pageSize=10
    // http://223.194.157.229:8080/api/board/page?page=0&pageSize=10
    @GetMapping("/page")
    // board entity 형태가 아니라 board DTO 형태로 반환하게 돼있다.
    public Page<BoardDTO> getBoardsByPage(
            @RequestParam int page,
            @RequestParam(defaultValue = "20") int pageSize) {
        return boardService.getBoardsByPage(page, pageSize);
    }

    // 게시글 생성
    @PostMapping("/create")
    public Board createBoardWithImages(
        @RequestParam("title") String title,
        @RequestParam("text") String text,
        @RequestParam("userId") Long userId,
        @RequestParam("files") List<MultipartFile> files) throws IOException {
        System.out.println("title = " + title);
        System.out.println("text = " + text);
        System.out.println("userId = " + userId);
        files.forEach(file -> System.out.println("file = " + file.getOriginalFilename()));
        return boardService.saveBoardWithImages(title, text, userId, files);
    }

    // 삭제 기능, api에서 구현은 해놔야 되는 거니까 만들어 놓으셨다고 함.
    @DeleteMapping("/{boardId}")
    public ResponseEntity<String> deleteBoard(@PathVariable Long boardId) {
        boardService.deleteBoard(boardId);
        return ResponseEntity.ok("Board deleted successfully");
    }

    // 밑에 2개는 update임
    @PostMapping("/{boardId}/like")
    public ResponseEntity<Board> updateLike(@PathVariable Long boardId, @RequestParam int value) {
        Board updatedBoard = boardService.updateLike(boardId, value);
        return ResponseEntity.ok(updatedBoard);
    }

    @PostMapping("/{boardId}/unlike")
    public ResponseEntity<Board> updateUnlike(@PathVariable Long boardId, @RequestParam int value) {
        Board updatedBoard = boardService.updateUnlike(boardId, value);
        return ResponseEntity.ok(updatedBoard);
    }
}
