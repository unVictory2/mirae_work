import 'package:flutter/material.dart';
import 'package:news_application/articles.dart';
import 'article_card.dart';
// 기본적인 드로잉 처리만 이 파일에서 처리
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
  late Future<List<Article>> futureArticles;

  @override
  void initState() { // 프로그램 실행되자마자 해야하는 일. 
    // 데이터 로딩 처리. 
    super.initState(); // 이미 super에 구현돼있어서 뭘 안 해도 알아서 호출됨.
    futureArticles = NewsService().fetchArticles(); // 데이터 로딩
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 단계 구조 레이아웃. 뼈대.
      appBar: AppBar(
        title : Text('News', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.surface),), //글자 설정 및 색 변경. TextStyle에서 color 뿐만 아니라 font, font style, font weight, font size 등도 바꿀 수 있다.
        backgroundColor: Theme.of(context).colorScheme.primary, //context 기반으로 아까 위에서 만든 Theme 가져옴. context를 계속 이용해서 디자인 통일성을 유지할 수 있다.
      ),
      body: FutureBuilder<List<Article>> (
        future : futureArticles, //위에서 정의한 처리해야 되는 함수
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); //대기 중이면 아이콘 띄워라
          } else if (snapshot.hasError) {
            return Center(child: Text('Error : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) { //데이터가 없으면. !은 null check 관련
            return const Center(child: Text('No Data'));
          } else {
            //리스트뷰에 들어가는 기본적인 구성품은 listtile. 
            return ListView.builder( // 리스트 타일을 계속 만들어줌. 
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) { // 익명 함수
                final article = snapshot.data![index]; //article은 아까 만든 데이터만 들어있는 클래스. 
                return ArticleCard(article: article, key : ValueKey(article.title)); // valuekey : article title을 seed로 key 만들어줌
              },
            );
          }
        }), // snapshot = 데이터
        bottomNavigationBar: BottomNavigationBar(items: [ // bottomNaviBar에 들어갈 항목들. 전부 위젯임.
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"), // 미리 정의돼있는 구글 스타일 아이콘. Icons.home은 상수임.
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],

        ),
    );
  }
}
  