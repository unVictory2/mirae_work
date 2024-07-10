package com.example.alstarboard;

import com.example.alstarboard.entity.Image;
import com.example.alstarboard.entity.User;
import com.example.alstarboard.entity.Board;
import com.example.alstarboard.repository.BoardRepository;
import com.example.alstarboard.repository.ImageRepository;
import com.example.alstarboard.repository.UserRepository;

import com.example.alstarboard.service.BoardService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;


@SpringBootTest
class AlstarboardApplicationTests {
	@Autowired
	private UserRepository userRepository;

	@Autowired
	private BoardRepository boardRepository;

	@Autowired
	private ImageRepository imageRepository;

	@Autowired
	private BoardService boardService;



	@Test
	void contextLoads() {
	}

	@Test
	void testCountBoards() {
		long count = boardRepository.count();
		System.out.println("count: " + count);
		assert count > 0;
	}

	@Test
	void testSelectByEmail() {
		// select All
		List<User> users = userRepository.findAll();
		users.forEach(System.out::println);
		assert !users.isEmpty();

		// select by email
		User user = userRepository.findByUserEmail("test@gmail.com");
		assertNotNull(user);
		System.out.println(user);
	}

	@Test
	@Transactional
	void testInsertBoard() {
		// User 엔티티가 데이터베이스에 존재하는지 확인하고 가져옵니다.
		User user = userRepository.findByUserEmail("test@gmail.com");
		assertNotNull(user, "User should not be null");

		// 새로운 Board 엔티티를 생성합니다.
		Board board = Board.builder()
				.title("새로운 테스트 게시글 제목")
				.text("새로운 테스트 게시글 내용")
				.user(user)
				.build();

		// 새로운 Image 엔티티들을 생성하고 Board 엔티티에 추가합니다.
		Image image1 = Image.builder().path("c:/image1.jpg").url("http://example.com/image1.jpg").board(board).build();
		Image image2 = Image.builder().path("c:/image2.jpg").url("http://example.com/image2.jpg").board(board).build();
		board.setImages(Arrays.asList(image1, image2));

		// Board 엔티티를 데이터베이스에 저장합니다.
		Board savedBoard = boardService.saveBoard(board);
		assertNotNull(savedBoard, "Saved board should not be null");
		assertNotNull(savedBoard.getId(), "Saved board ID should not be null");

		// 저장된 Board 엔티티를 출력합니다.
		System.out.println(savedBoard);

		// 저장된 Board 엔티티를 다시 로드하여 검증합니다.
		Board foundBoard = boardService.findById(savedBoard.getId()).orElse(null);
		assertNotNull(foundBoard, "Found board should not be null");
		assertEquals("새로운 테스트 게시글 제목", foundBoard.getTitle());
		assertEquals("새로운 테스트 게시글 내용", foundBoard.getText());
		assertEquals(user.getId(), foundBoard.getUser().getId());
		assertEquals(2, foundBoard.getImages().size(), "Board should have 2 images");
	}

	@Test
	void testSelectBoardByUserId() {
		List<Board> boards = boardRepository.findByUserId(1L);
		assert !boards.isEmpty();
		boards.forEach(System.out::println);
		boards.clear();
		assert boards.isEmpty();

		boards = boardRepository.findByUserUserEmail("test@gmail.com");
		assert !boards.isEmpty();
		boards.forEach(System.out::println);
	}
	
	@Test
	void testInsertImage() {
		Image image = Image.builder()
						.board(Board.builder().id(1L).build())
						.path("static/images/test.webp")
						.url("/images/test.webp")
						.build();
		assert image != null;
		System.out.println(image);

		Image newImage = imageRepository.save(image);
		assertNotNull(newImage);
	}

	@Test
	@Transactional
	void testInsertBoardWithImages() throws IOException {
		// User 엔티티가 데이터베이스에 존재하는지 확인하고 가져옵니다.
		User user = userRepository.findByUserEmail("test@gmail.com");
		assertNotNull(user, "User should not be null");

		// MockMultipartFile을 사용하여 파일 업로드를 시뮬레이션합니다.
		// MockMultipartFile: Spring의 org.springframework.mock.web 패키지에 포함된 클래스입니다. 이 클래스를 사용하여 파일 업로드를 모의할 수 있습니다.
		// MockMultipartFile 생성자: 파일 이름, 원본 파일 이름, 콘텐츠 타입, 바이트 배열을 인자로 받아 MockMultipartFile 객체를 생성합니다.
		MockMultipartFile file1 = new MockMultipartFile("file", "image1.jpg", "image/jpeg", "Test Image 1".getBytes());
		MockMultipartFile file2 = new MockMultipartFile("file", "image2.jpg", "image/jpeg", "Test Image 2".getBytes());

		Board board = boardService.saveBoardWithImages("새로운 테스트 게시글 제목", "새로운 테스트 게시글 내용", user.getId(), Arrays.asList(file1, file2));
		assertNotNull(board, "Saved board should not be null");
		assertNotNull(board.getId(), "Saved board ID should not be null");

		// 저장된 Board 엔티티를 다시 로드하여 검증합니다.
		Board foundBoard = boardService.findById(board.getId()).orElse(null);
		assertNotNull(foundBoard, "Found board should not be null");
		assertEquals("새로운 테스트 게시글 제목", foundBoard.getTitle());
		assertEquals("새로운 테스트 게시글 내용", foundBoard.getText());
		assertEquals(user.getId(), foundBoard.getUser().getId());
		assertEquals(2, foundBoard.getImages().size(), "Board should have 2 images");
	}

}
