package com.example.alstarboard.repository;

import com.example.alstarboard.entity.Image;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.beans.JavaBean;
import java.util.List;

@Repository
public interface ImageRepository extends JpaRepository<Image, Long>{
  public List<Image> findByBoardId(Long boardId);
  public Image save(Image image);
}
