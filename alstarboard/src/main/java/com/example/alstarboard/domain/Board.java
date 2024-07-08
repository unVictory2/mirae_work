package com.example.alstarboard.domain;

import lombok.*;

@Getter // getID()등 메서드 자동 생성
@Setter // setID()등
@ToString // object 클래스의 toString() 메서드 자동으로 override해줌
@Builder
@AllArgsConstructor // 모든 필드값 매개변수로 받아서 생성하는 생성자
@NoArgsConstructor // 빈 값만 넣어서 만들어주는, parameter 없는 생성자. 빈 기본 생성자.
// 이렇게만 치면 lombok이 전부 만들어줌. getter 등 함수 전부 짜준 거임.

public class Board {
    private Long id;
    private String title;
    private String text;
    private Long like;
    private Long unlike;
    private Long image;
    private Long user;
    private String createdAt;
    private String updatedAt;
}
