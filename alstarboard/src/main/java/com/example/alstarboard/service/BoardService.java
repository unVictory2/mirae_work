package com.example.alstarboard.service;

import com.example.alstarboard.dto.BoardDTO;
import com.example.alstarboard.entity.Board;
import com.example.alstarboard.entity.Image;
import com.example.alstarboard.entity.User;
import com.example.alstarboard.repository.BoardRepository;
import com.example.alstarboard.repository.UserRepository;
import jakarta.servlet.ServletContext;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class BoardService {

    private final BoardRepository boardRepository;
    private final UserRepository userRepository;
    private final ServletContext servletContext;

    // application.yaml 파일에서 설정한 값을 가져온다
    @Value("${image.upload.dir}")
    private String uploadDir;

    @Value("${image.access.url}")
    private String accessUrl;

    @Transactional(readOnly = true)
    public Page<BoardDTO> getBoardsByPage(int page, int pageSize) {
        // 여러 개의 레코드 받아옴. 얘네가 전부 entity를 가져옴, 여러 개의 @annotations 달려 있는 무거운 entity.
        PageRequest pageRequest = PageRequest.of(page, pageSize, Sort.by( "createdAt").descending());

        // Entity -> DTO 변환, 왜? Entity가 기능이 많아서 무거우니까...
        // 모든 entity instance를 DTO 형태로(가볍게) 바꾸고 반환하는 작업.
        return boardRepository.findAll(pageRequest).map(BoardDTO::fromEntity);
    }

    public Board saveBoard(Board board) {
        return boardRepository.save(board);
    }

    public Optional<Board> findById(Long id) {
        return boardRepository.findById(id);
    }

    // user ID를 이용하여 user 테이블의 해당 사용자 정보를 가져욤
    public Board saveBoardWithImages(String title, String text, Long userId, List<MultipartFile> files) throws IOException {
        // userId로 검색 실패하면 user에는 null이 들어옴. 그에 대한 처리를 원래는 if (user==null) 어쩌고로 했음.코드 복잡, 논리 꼬임. 이제 .orElseThrow()로 처리. optional 이라고 부름.
        // userId를 이용하여 user 테이블의 해당 사용자 정보를 가져온다
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));


        Board board = Board.builder()
            .title(title)
            .text(text)
            .user(user)
            .build();

        // 링크를 resources/static/에 이미지를 두고 
        // 실제 경로 가져오기
        File staticImagesDir = new ClassPathResource("static/images").getFile();
        String realPath = staticImagesDir.getAbsolutePath();

        // 1:* 관계이기 때문에 각자 다른 위치에 images 저장해줘야
        // 이미지를 첨부파일 형식으로 받을 거임. 파일들의 형식 만들어줘서 저장.
        List<Image> images = new ArrayList<>();
        for (MultipartFile file : files) {
            String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
            String filePath = realPath + File.separator + fileName;
            String fileUrl = accessUrl + "/" + fileName;

            System.out.println(filePath);

            File dest = new File(filePath);
            if(!dest.getParentFile().exists()) {
                dest.getParentFile().mkdirs();
            }
            file.transferTo(dest);

            images.add(Image.builder()
                .url(fileUrl)
                .path(filePath)
                .board(board)
                .build());
        }
        // Board와 Image의 관계 설정, board에 이미지 리스트를 저장
        board.setImages(images);

        return boardRepository.save(board);
    }

    public void deleteBoard(Long boardId) {
        Board board = boardRepository.findById(boardId)
            .orElseThrow(() -> new RuntimeException("Board not found"));

        // 실제 파일 시스템에서 이미지 파일 삭제
        for (Image image : board.getImages()) {
            File file = new File(image.getPath());
            if (file.exists()) {
                file.delete();
            }
        }

        // 데이터베이스에서 게시글과 연관된 이미지 삭제
        boardRepository.delete(board);
    }

    public Board updateLike(Long boardId, int value) {
        Board board = boardRepository.findById(boardId)
            .orElseThrow(() -> new RuntimeException("Board not found"));
        board.setLike(board.getLike() + value);
        return boardRepository.save(board); // save() 메서드가 update 로 작동함
    }

    public Board updateUnlike(Long boardId, int value) {
        Board board = boardRepository.findById(boardId)
            .orElseThrow(() -> new RuntimeException("Board not found"));
        board.setUnlike(board.getUnlike() + value);
        return boardRepository.save(board); // save() 메서드가 update 로 작동함
    }
}
