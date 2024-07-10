package com.example.alstarboard.dto;

import com.example.alstarboard.entity.Board;
import com.example.alstarboard.entity.Image;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.stream.Collectors;


// annotation 많으면 데이터 저장에는 좋지만 실어 나르기에는 너무 무거워진다. 그렇기 때문에 기능은 없이 순수 데이터만 가지고 있는 형태로 바꾸면, 데이터 실어 나르기에 적합한 클래스가 된다.
// @Data는 getter setter만 있다. 생성자도 없음.
@Data
public class BoardDTO {
  private Long id;
  private String title;
  private String text;
  private Long like;
  private Long unlike;
  private Long userId;
  private String userEmail;
  private String userNickName;
  private List<String> imageUrls;

  // getters and setters
  // 하나의 인스턴스 생성해서 반환해준다
  public static BoardDTO fromEntity(Board board) {
    BoardDTO dto = new BoardDTO();

    dto.setId(board.getId());
    dto.setTitle(board.getTitle());
    dto.setText(board.getText());
    dto.setLike(board.getLike());
    dto.setUnlike(board.getUnlike());
    dto.setUserId(board.getUser().getId());
    dto.setUserEmail(board.getUser().getUserEmail());
    dto.setUserNickName(board.getUser().getNickName());
    dto.setImageUrls(board.getImages().stream().map(Image::getUrl).collect(Collectors.toList()));

    return dto;
  }
}
