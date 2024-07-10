package com.example.alstarboard.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.bytecode.enhance.spi.EnhancementInfo;

import java.sql.Timestamp;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@Builder
@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 300)
    private String userEmail;

    @Column(length = 20)
    private String password;

    @Column(nullable = false, length = 50)
    private String nickName;

    @Column(nullable = false)
    @CreationTimestamp
    private Timestamp createdAt;

    @Column(nullable = false)
    @CreationTimestamp
    private Timestamp updatedAt;
}

/*
'id', 'bigint unsigned', 'NO', 'PRI', NULL, 'auto_increment'
'user_email', 'varchar(300)', 'NO', 'UNI', NULL, ''
'password', 'varchar(20)', 'YES', '', NULL, ''
'nick_name', 'varchar(50)', 'NO', '', NULL, ''
'created_at', 'timestamp', 'YES', '', 'CURRENT_TIMESTAMP', 'DEFAULT_GENERATED'
'updated_at', 'timestamp', 'YES', '', 'CURRENT_TIMESTAMP', 'DEFAULT_GENERATED'
* */