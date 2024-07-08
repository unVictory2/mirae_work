-- database 생성
create database alstarboard;

-- 위에서 생성한 database를 사용
use alstarboard;

-- user table 생성
create table `users`(
`id` bigint unsigned not null auto_increment,
`user_email` varchar(300) not null unique, -- 이메일, unique 넣으면 인덱스 하나 생성해줌
`password` varchar(20),
`nick_name` varchar(50) not null,
-- 어떤 테이블이던지 이 두 레코드는 관리에 도움이 되기 때문에 넣는 게 좋음.
`created_at` timestamp default current_timestamp,
`updated_at` timestamp default current_timestamp,
constraint primary key(`id`)
);

create table images(
`id` bigint unsigned not null auto_increment,
`path` varchar(300) not null, -- 실제 이미지가 위치할 경로 path
`url` varchar(300) not null,  -- 클라이언트에 서비스될 image url. 클라이언트가 이 정보를 이용해서 이미지를 요청할 거임
`created_at` timestamp default current_timestamp,
`updated_at` timestamp default current_timestamp,
constraint primary key(`id`)
);

create table boards(
`id` bigint unsigned not null auto_increment,
`title` varchar(100) not null,
`text` varchar(300) not null, -- not null = 필수 필드, 입력해야 등록된다.
`like` bigint unsigned default 0,
`unlike` bigint unsigned default 0,
`image` bigint unsigned not null, -- 밑의 foreign key는 이걸 의미하는 거임
`user` bigint unsigned not null,
`created_at` timestamp default current_timestamp,
`updated_at` timestamp default current_timestamp,
constraint primary key(`id`),
constraint foreign key(`image`) references `images`(`id`), -- 앞의 image는 이 테이블의 image, 뒤는 images 테이블의 id.
constraint foreign key(`user`) references `users`(`id`)
)