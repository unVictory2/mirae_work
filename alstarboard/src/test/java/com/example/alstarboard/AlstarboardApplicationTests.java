package com.example.alstarboard;

import com.example.alstarboard.domain.User;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class AlstarboardApplicationTests {

	@Test
	void contextLoads() {
	}

	@Test
	void testUser() {
		//new User 하고 parameter 안 주고 이런 식으로 만드는 걸 build pattern이라고 함.
		// user 안에 내부 클래스 (static class) 들어가서, user 세팅하고 내뱉어줌.
		// 테스트 모듈 쓰면 빠르게 테스트 가능. sprint app은 크기 때문에 전체 실행하고 테스트하면 시간 오래 걸림.
		User user = User.builder()
				.userEmail("test@gmail.com")
				.password("1234")
				.nickName("test")
				.build();

		assert user != null;
	}
}
