import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : "news app",
      theme : ThemeData (
        primarySwatch: Colors.blue
        ),
      home: const NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget{
  const NewsPage({super.key});

  @override
  State<StatefulWidget> createState() => _NewsPageState();  
}
  
//전체 영역을 const로 하는 게 제일 빠르다. 하지만 중간에 바뀌는 부분 있어서 그렇게 만드는 건사실상 불가능. 그래도 안 바뀔 건 const로 넘기는 게 나음. 그래서 코드에 가끔 파란 밑줄 그이는 것 const로 바꾸라고
class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('News', style: TextStyle(color: Theme.of(context).colorScheme.surface),), //글자 설정 및 색 변경
        backgroundColor: Theme.of(context).colorScheme.primary, //context 기반으로 아까 위에서 만든 Theme 가져옴. context를 계속 이용해서 디자인 통일성을 유지할 수 있다.
      ),
      body: Center( //레이아웃 클래스
        child: Text('News Page'), //레이블
        )
    );
  }
}
  