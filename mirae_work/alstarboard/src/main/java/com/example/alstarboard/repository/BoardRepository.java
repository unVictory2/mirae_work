package com.example.alstarboard.repository;

import com.example.alstarboard.entity.Board;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

 // board는 테이블 값 그대로 코딩해둔 거임
 // <Board,Long> : <board repository가 핸들링 할 table entity, 키가 되는 데이터 타입>
@Repository
public interface BoardRepository extends JpaRepository<Board, Long> {
  // jpa가 findAll, findByUserId 등 메서드 이름 보고 알아서 쿼리를 만들어줌.
  public List<Board> findAll();
  public List<Board> findByUserId(Long userId);
  // 자세히 보면 UserUserEmail임. User 테이블과 join해서 useremail 가져오라는 소리다.
  public List<Board> findByUserUserEmail(String userEmail);
  public Board save(Board board); // 테이블의 모든 정보 가지고 가서 INSERT, ID 값을 주면 해당 ID로 가서 save
}
