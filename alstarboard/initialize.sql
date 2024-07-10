create database alstarboard;

use alstarboard;

DROP TABLE IF EXISTS users, images, boards, reply;

create table users (
id bigint unsigned not null auto_increment,
`user_email` varchar(200) not null unique,
`password` varchar(20),
`nick_name` varchar(200) not null,
`created_at` timestamp default current_timestamp,
`updated_at` timestamp default current_timestamp,
constraint primary key(id)
);


create table boards(
id bigint unsigned not null auto_increment,
`title` varchar(100) not null,
`text` varchar(500) not null,
`like` bigint unsigned default 0,
`unlike` bigint unsigned default 0,
`user` bigint unsigned not null,
`created_at` timestamp default current_timestamp,
`updated_at` timestamp default current_timestamp,
constraint primary key(id),
constraint foreign key(`user`) references users(id)
);

create table images(
id bigint unsigned not null auto_increment,
`path` varchar(500) not null,
`url` varchar(500) not null,
`board` bigint unsigned not null,
`created_at` timestamp default current_timestamp,
`updated_at` timestamp default current_timestamp,
constraint primary key(id),
constraint foreign key(`board`) references `boards`(id)
);


create table reply(
id bigint unsigned not null auto_increment,
`text` varchar(100) not null,
`board` bigint unsigned not null,
`like` bigint unsigned default 0,
`unlike` bigint unsigned default 0,
`created_at` timestamp default current_timestamp,
`updated_at` timestamp default current_timestamp,
constraint primary key(id),
constraint foreign key(`board`) references `boards`(id)
);


insert into `users`(`user_email`, `nick_name`)
values('test@gmail.com', 'test_별명');

insert into `boards`(`title`, `text`, `user`)
values('제목입니다', '이 부분은 내용입니다\n테스트할 내용입니다', 1);

insert into images(`path`,`url`, `board`)
values('static/images/test.webp', '/images/test.webp', 1);

select * from users;
select * from boards;
select * from images;