import 'package:flutter/material.dart';
import 'my_appbar.dart';

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
                  Container(
                    child: Row(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}