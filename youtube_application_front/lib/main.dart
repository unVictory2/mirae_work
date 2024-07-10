import 'package:flutter/material.dart';
import 'package:youtube_application_front/button_horiz_rail.dart';
import 'package:youtube_application_front/video_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'board_input_page.dart';
import 'firebase_options.dart';
import 'my_appbar.dart';
import 'board.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter'),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  late String title;
  MyHomePage({super.key, required this.title});
  
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{  
  late Future<List<BoardDTO>> futureBoards;

  @override
  void initState() {
    super.initState();
    futureBoards = fetchBoards();
  }

  Future<List<BoardDTO>> fetchBoards() async {
    final response = await http.get(
        Uri.parse('http://192.168.123.106:8080/api/board/page?page=0&pageSize=20'),
        //Uri.parse('http://192.0.0.2:8080/api/board/page?page=0&pageSize=20'),
        headers: {'content-type': 'application/json; charset=UTF-8'});
    if (response.statusCode == 200) {
      return (json.decode(utf8.decode(response.bodyBytes))['content'] as List)
          .map((data) => BoardDTO.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load boards');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.withValues(
        title: widget.title,
        leading: const Icon(Icons.home, color: Colors.white),
        actions: const [
          Icon(Icons.account_circle_sharp),
          Icon(Icons.notifications),
          Icon(Icons.search),
        ],
      ),      
      body: LayoutBuilder(
        builder: (context, constraints) {
          List<String> items = ['Post', '새로운 맞춤 동영상', '레이아웃', '애니메이션', '쇼핑', '게임', '채널', '커뮤니티'];
          return ConstrainedBox(
            constraints: const BoxConstraints(              
              minWidth: 300,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 4, color: Colors.black,),
                  Container(
                    color: Colors.black,
                    child: ButtonHorizRail(items: items,),
                    
                  ),
                  Container(height: 4, color: Colors.black,),
                  FutureBuilder(
                    future: futureBoards, 
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No data available'));
                      } else {
                        return Column(
                          children: snapshot.data!.map((board) {
                            return VideoCard(
                              key: ValueKey(board.id),
                              board: board,
                            );
                          }).expand((element) => [
                                element,
                                const SizedBox(height: 8),
                              ]).toList(),
                        );
                      }
                    },
                  ),
                ].expand((element) => [ element, const SizedBox(height: 8), ]).toList(),
              ),
            ),
          );
        },              
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BoardInputPage(userId: '1')),
              )
            ),
          ],
        ),
      )
    );
  }
}

class MyText extends StatelessWidget {
  final String text;
  final int condition;

  MyText({super.key, this.text='MyText', this.condition=0});
  
  @override
  Widget build(BuildContext context) {

    Color color;
    switch (condition) {
      case 0:
        color = Colors.black;
        break;
      case 1:
        color = Colors.red;
        break;
      case 2:
        color = Colors.blue;
        break;
      default:
        color = Colors.black;
    }

    TextStyle? style = TextStyle(color: color, fontSize: 16);

    return Text('MyText', style:style,);
  }
}