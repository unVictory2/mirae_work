import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart'; // 잘못침
import 'dart:convert'; // json 쓸거라서

class NewsService { // 데이터를 get 해온다.
//future는 비동기로 동작한다는 뜻. 반환값을 future 안에 넣어주는데, 이건 리스트고 그 항목들은 밑에서 정의한 article이다. 데이터가 전부 도착하면 이 리스트를 반환해줌. 인자에는 필요한 parameter 유연하게 받으면 됨 
  Future<List<Article>> fetchArticles({String country = 'kr', String category = '', String apiKey = '0cb509b771ce43de85e74e7d738ddb98'}) async { // future는 무조건async 달아줘야 한다.
    String url = 'https://newsapi.org/v2/top-headlines?';
    url += 'country=$country'; // https://newsapi.org/v2/top-headlines?country=kr

  if (category.isNotEmpty) {
    url += '&category=$category';
  }

  url += '&apiKey=$apiKey'; 

  //await은 호출하고 넘어감. 오면 future가 처리할 거다.
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) { //200 = 성공적으로 받아옴
    Map<String, dynamic> json = jsonDecode(response.body); //json status code, total result, articles 3개 있음
    List<dynamic> body = json['articles']; // 나머지 둘 무시하고 articles만 처리

    // Article 인스턴스 계속 만들어서 toList 한 후, 앞의 articles에 넣는다. 
    // body는 맵 덩어리. 그 맵이 하나씩 item에 들어가서 Article.fromjson(생성자)으로 새로운 아티클 인스턴스로 만들어져서 앞의 articles에 들어간다.
    List<Article> articles = body.map((dynamic item) => Article.fromJson(item)).toList();

    return articles;
  } else {
    throw Exception("failed to load articles");  
    }
  }
}

class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String url;

  //null값 때문에 required 붙여줌
  Article({required this.title, required this.description, required this.urlToImage, required this.url});

  //factory는 싱글톤 생성자일때 다는 키워드. 인스턴스가 우리 앱에서 한 개만 존재해야 할 때 쓰는 게 싱글톤 생성자이다. 다음에 부를 때 새 인스턴스 만드는 게 아니라 기존 인스턴스 바꿔서 준다. 오류가 있어도 일단 클래스를 만들어서 리턴해준다. 생성을 보장해줌.
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
    );
  } 
}