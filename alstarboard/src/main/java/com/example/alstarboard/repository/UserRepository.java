package com.example.alstarboard.repository;

import com.example.alstarboard.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
  public List<User> findAll();
  public User findByUserEmail(String email);
}
