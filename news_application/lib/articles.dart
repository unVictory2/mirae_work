import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart'; // 잘못침
import 'dart:convert'; // json 쓸거라서

class NewsService { // 데이터를 get 해온다.
//future는 비동기로 동작한다는 뜻. 반환값을 future 안에 넣어주는데, 이건 리스트고 그 항목들은 밑에서 정의한 article이다. 데이터가 전부 도착하면 이 리스트를 반환해줌. 인자에는 필요한 parameter 유연하게 받으면 됨 
  Future<List<Article>> fetchArticles({int page = 1, String country = 'kr', String category = '', String apiKey = '0cb509b771ce43de85e74e7d738ddb98'}) async { // future는 무조건async 달아줘야 한다.
    String url = 'https://newsapi.org/v2/top-headlines?';
    url += 'country=$country'; // https://newsapi.org/v2/top-headlines?country=kr

  if (category.isNotEmpty && category != 'Headlines') { //카테고리 headlines면 url에 아무것도 추가 안 함
    url += '&category=$category';
  }

  if (page > 1) { //1일 경우에는 안 줘도 됨
    url += '&page=$page';
  }

  url += '&apiKey=$apiKey'; 

  //await은 호출하고 넘어감. 오면 future가 처리할 거다.
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) { //200 = 성공적으로 받아옴
    Map<String, dynamic> json = jsonDecode(response.body); //json status code, total result, articles 3개 있음
    List<dynamic> body = json['articles']; // 나머지 둘 무시하고 articles만 처리

    // Article 인스턴스 계속 만들어서 toList 한 후, 앞의 articles에 넣는다. 
    // body는 맵 덩어리. 그 맵이 하나씩 item에 들어가서 Article.fromjson(생성자)으로 새로운 아티클 인스턴스로 만들어져서 앞의 articles에 들어간다.
    // 기존 처리 + isUrlValid함수 호출해서 결과값 참인 경우에만 articles 리스트에 추가한다. 
    List<Article> articles = [];
    for (var item in body) {
      if (await _isUrlValid(item['urlToImage'])) {
        articles.add(Article.fromJson(item));
      }
    }

    return articles; // 기존 : 1페이지에서 2페이지 넘어가면 2페이지를 보여줌. 1페이지 + 2페이지를 보여줘야 하는데, 1은 지우고 2만 보여줌.
  } else {
    return []; 
    }
  }

  Future<bool> _isUrlValid(String? urlToImage) async { //check whether the url is valid by visiting it. visiting may take some time so you need to do this asynchronously.
    try {
      if(urlToImage == null || urlToImage.isEmpty) {
        return false;
      }
      
      final response = await http.head(Uri.parse(urlToImage)); // await 함수는 호출하고 지나가는 게 아니라 결과가 올 때까지 기다림. 그래서 사실 future 쓰는 큰 의미 없다.
      return response.statusCode == 200;
    } catch (e) {
      return false;
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
  //isValidUrl 여기서 쓰는 게 맞지만, 생성자에선 future를 쓸 수 없기에 못 쓴다.
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
    );
  } 
}