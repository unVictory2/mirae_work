package com.example.alstarboard.entity;

import lombok.*;
import java.sql.Timestamp;
import java.util.List;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;

// 중요한 건 @Entity, @Table annotation임. 얘네 둘 때문에 MySQL에 연동돼서 이 데이터가 테이블로 바뀜.
@Entity
@ToString
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "boards") // mySQL에 매칭되는 테이블명을 줘야 함, "boards".
public class Board {
    @Id // @Id를 달아주면 primary key가 된다.
    @GeneratedValue(strategy = GenerationType.IDENTITY) // auto_increment, key 생성 전략
    private Long id;

    // not null, 길이는 100 >> varchar(100)
    @Column(nullable = false, length = 100)
    private String title;   // not null, 길이 100, varchar(100)

    @Column(nullable = false, length = 300)
    private String text;


    // 쿼리문의 like 키워드가 이미 존재함. 그러니가 backtick ``를 줘야 한다. md에서 ``로 코드 그대로 치는 거랑 같은 느낌
    // 모든 예약어를 외울 순 없다. 그니까 만약을 대비해서 backtick으로 감싸주는 게 안전하다.
    @Builder.Default
    @Column(name = "`like`")    // like는 예약어이므로 ``로 감싸줌, name으로 컬럼명을 `like`로 지정
    private Long like = 0L;     // default 0

    @Builder.Default
    @Column(name = "`unlike`")
    private Long unlike = 0L;

    @ManyToOne
    @JoinColumn(name = "`user`")    // board테이블의 컬럼명 user, 외래키
    // entity 안에 toString 지원하는 클래스가 들어오면 중복 처리해서 무한 루프 되지 않게 써줌
    @ToString.Exclude
    private User user; // User 테이블의 외래 키

    @Column(nullable = false)
    @CreationTimestamp
    private Timestamp createdAt;

    @Column(nullable = false)
    @CreationTimestamp
    private Timestamp updatedAt;

    // image 정보는 board에 있는 column은 아니지만, join 해서 가지고 와야 하는 정보임.
    // 게시글 하나 가지고 올 때 이 게시글에 연동돼있는 이미지 정보를 가지고 와야 하니까.
    // mappedBy = "board" : 이미지 테이블의 board coulmn과 연동. ophanRemoval : 종속성 설정, 삭제시 같이 삭제되게
    @OneToMany(mappedBy = "board", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @ToString.Exclude
    private List<Image> images;
}
