package com.example.alstarboard.entity;

import lombok.*;

import java.sql.Timestamp;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Setter
@Getter
public class Reply {
    private Long id;
    private String text;
    private Long board; // Board 테이블의 외래 키
    private Long like;
    private Long unlike;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}
