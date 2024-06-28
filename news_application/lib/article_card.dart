import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'articles.dart';
//각각의 리스트 타일을 하나의 네모 형태로 만드려고 한다.

class ArticleCard extends StatelessWidget {
  late final Article article;
  
ArticleCard({super.key, required this.article}); // article 형식으로 외부에서 데이터 받음. 만들어서 멤버 변수에 집어넣고 쓴다.

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => developer.log("URL : ${article.url}"), // Tap 시 로그 출력
      child:  Card (
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //위에다 딱 붙이겠다
          children: [
            (article.urlToImage.isNotEmpty) ? // 이미지가 있는 경우 
              Image.network(article.urlToImage, // 이미지 안 깨지고 들어가게 크기 설정
                width: double.infinity,
                height: 200,
                fit : BoxFit.cover,) :
              Image.asset('assets/images/watermelon.png',
              width: double.infinity,
                height: 200,
                fit : BoxFit.cover,), // 이미지가 없는 경우, 내가 정한 이미지로 채워줌
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(article.title,
                style : const TextStyle(fontSize: 20, fontWeight : FontWeight.bold)
                )),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(article.description,
                style : const TextStyle(fontSize: 15, fontWeight : FontWeight.bold)
                )),  
            Text(article.title),
            Text(article.description),
          ],),
      ),
    );
  }
    
}