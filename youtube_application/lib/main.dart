import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : 'Youtube App',
      home : const MyHomePage(),
      theme : ThemeData(
        appBarTheme: const AppBarTheme( // AppBar
          backgroundColor: Colors.black,
        ), 
        elevatedButtonTheme: ElevatedButtonThemeData( // 버튼
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 77, 76, 76)),
            textStyle: WidgetStateProperty.all<TextStyle>(
              TextStyle(color: Colors.white),
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // 아이콘 
        textTheme: const TextTheme( // 텍스트
          bodyMedium: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // AppBar 구성 요소들. (최상단 바)
        title : Row(
          children: [
            Expanded( // 홈 버튼, 제목. 왼쪽 정렬
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.home, color: Theme.of(context).iconTheme.color),
                  const SizedBox(width : 25),
                  Text(
                    'Flutter', 
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),              
            ),
            Expanded( // 홈 버튼, 제목. 오른쪽 정렬
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.tv, color: Theme.of(context).iconTheme.color),
                  const SizedBox(width : 25),
                  Icon(Icons.notifications, color: Theme.of(context).iconTheme.color),
                  const SizedBox(width : 25),
                  Icon(Icons.search, color: Theme.of(context).iconTheme.color),
                  const SizedBox(width : 8),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print('ElevatedButton1 clicked');
                    },
                    child: Text('Post', style: TextStyle(color: Colors.white),),
                  ),
                  const SizedBox(width : 15),
                  ElevatedButton(
                    onPressed: () {
                      print('ElevatedButton2 clicked');
                    },
                    child: Text('새로운 맞춤 동영상', style: TextStyle(color: Colors.white),),
                  )
                ],
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 129, 129, 129),
            width: double.infinity,
            height: 410,
          ),
          Container(
            color: Color.fromARGB(255, 216, 216, 216),
            width: double.infinity,
            height: 440,
          ),
        ]
      ),
    );
  }

}