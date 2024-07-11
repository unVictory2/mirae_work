package com.example.alstarboard.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
// 도메인으로 들어오는 사용자 차단하는 보안 기능이지만 개발 단계니까 다 풀어둠.
@Configuration
public class WebConfig implements WebMvcConfigurer {
  @Bean
  public WebMvcConfigurer corsConfigurer() {
    return new WebMvcConfigurer() {
      // 외부와의 접속은 내 컴퓨터에서만 접근하는 거랑 보안 수준이 아예 다르고, 이건 매우 복잡함.
      // 그래서 여기서는 다 최대한 간단하게 완화해둠
      @Override
      public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
            .allowedOrigins("*") // ipconfig 이용해서 내 ip address로.
            .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
            .allowedHeaders("*")
            .allowCredentials(false);
      }
    };
  }
}
