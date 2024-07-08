package com.example.alstarboard.service;

import com.example.alstarboard.domain.Board;
import com.example.alstarboard.repository.BoardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class BoardService {

    private final BoardMapper boardMapper;

    public List<Board> getBoardList() {
        // 데이터베이스와 연동해서 필요한 데이터 (이 경우에는 게시판 목록)를 가져와서
        // 데이터를 실어 나르는 object = dto = data transfer object에 담아서 리턴한다
        // dto는 domain 안에 구현돼있다.
        return boardMapper.getBoardList();
    }
}
