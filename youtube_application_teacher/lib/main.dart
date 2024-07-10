import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/button_horiz_rail.dart';
import 'package:flutter_application_2/content_card.dart';
import 'board.dart';
import 'my_appbar.dart';
import 'button_horiz_rail.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : 'Flutter',
      theme : ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black
      ),
      debugShowCheckedModeBanner: false, //디버그 띠 삭제
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  late String title;

  MyHomePage({super.key, this.title = 'flutter'});
  
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
  
}

class _MyHomePageState extends State<MyHomePage> {
late Future<List<Board>> futureBoards;

  String baseUrl = "http://223.194.157.229:8080/"; // localhost 절대 안 됨, 나갔다 들어오는 주소 써야함
  
  @override
  void initState() {
    futureBoards = fetchBoards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar.withValue(
        title: 'Flutter',
        leading: const Icon(Icons.home),
        actions: const [
          Icon(Icons.tv),
          Icon(Icons.notifications),
          Icon(Icons.search),
        ],
      ),
      body: LayoutBuilder( // 위젯 반환 함수가 인자로 들어간다. 
        builder: (context, constraint) {
          return ConstrainedBox (
            constraints: const BoxConstraints(
              minWidth: 300,
            ),
            child : SingleChildScrollView( 
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4,),
                  const ButtonHorizRail(items: [ // 이 부분 좌우스크롤 돼야하는데 안됨, 수정
                      '쇼핑', '동영상', '게임', '채널', '커뮤니티', '채팅', ],), 
                  Container(height: 4,),
                  FutureBuilder(
                    future: futureBoards, 
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error : ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No data');
                      } else {
                        return Column(
                          children: snapshot.data!.map((e) =>
                          ContentCard(board: e, baseUrl: baseUrl,)).toList(),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Future<List<Board>> fetchBoards() async {
    int page = 0; // 페이지 수는 계산해서 해야 함
    int size = 10; // 이걸 하드코딩 하지 말고 설정값으로 해서 바꿀 수 있게 만들어야 함
    String url = '$baseUrl/api/board/page?page=$page&size=$size';
    final response = await http.get(Uri.parse(url),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 200) {
      // 1. 문자셋을 utf8로 디코딩. 
      // 2. 들어온 문자열 데이터를 <List<Map<String,dynamic>>> 형식으로 바꿈.
      return (json.decode(utf8.decode(response.bodyBytes))['content'] as List)
      // 3. 그 아이템들을하나씩 꺼내서 Board 클래스 인스턴스를 만듦, fromJson 생성자 부름
        .map((e)=>Board.fromJson(e))
        // 4. 그럼 map object가 되는데 이를 리스트로 만들어서 리스트 형식으로 반환한다.
        .toList();
    } else {
      throw Exception('Failed to load boards');
    }
  }
}