#테이블 만들기

- 사용자 테이블
    - id(big_int, unusigned), 자동증가
    - user_email., 문자열
    - password, 문자열
    - nick_name, 문자열
    - created_at, 타임스탬프
    - updated_at, 타임스탬프

- 보드(게시판) 테이블
    - id(big_int, unsigned), 자동증가
    - 타이ㅣ틀
    - 텍스트
    - 좋아요
    - 싫어요
    - 사용자(외부키) - 사용자 테이블과 id로 연결
    - 이미지(외부키) - 사용자 테이블과 id로 연결
    - created_at, 타임스탬프
    - updated_at, 타임스탬프

- 이미지 테이블
    - id(big_int, unsigned), 자동증가
    - path, 문자열
    - url, 문자열
    - created_at, 타임스탬프
    - updated_at, 타임스탬프

- 댓글 테이블