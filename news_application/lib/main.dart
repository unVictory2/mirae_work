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
    // NewsService news = new NewsService();
    // news.fetchArticles(); 가 생략돼서 News.Service().fetchArticles();가 된거
  }

  void _onCategoryTap({String category = ''}) { // articles.dart의 기사 가져오는 함수 fetChArticles에 카테고리 설정해줘서 해당 카테고리 기사 가져오게 한다.
  //인자 중괄호 치는 건 named parameter로 만드는 것. null값 안 되니까 기본값으로 '' 넣어줌.
    setState(() {
      futureArticles = NewsService().fetchArticles(category: category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 단계 구조 레이아웃. 뼈대.
      appBar: AppBar(
        title : Text('News', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.surface),), //글자 설정 및 색 변경. TextStyle에서 color 뿐만 아니라 font, font style, font weight, font size 등도 바꿀 수 있다.
        backgroundColor: Theme.of(context).colorScheme.primary, //context 기반으로 아까 위에서 만든 Theme 가져옴. context를 계속 이용해서 디자인 통일성을 유지할 수 있다.
      ),
      drawer: Drawer( // parameter drawer에 instance Drawer() 생성해서 넣어줌. 좌상단 줄 3개 누르면 카테고리 떠서 카테고리별 뉴스 볼 수 있는 기능.
        child: ListView( // listview를 주고 children으로 항목 나열
          padding: EdgeInsets.zero,
          children : [
            const DrawerHeader( // drawer한개 listtile 7개
              decoration: BoxDecoration( // BoxDecoration이라는 위젯을 이용해서 색이나 이미지를 채워 넣을 수 있다.
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('assets/images/news.jpg'),
                  fit: BoxFit.cover
                )
              ),
              child : Column( // column은 children 속성을 가진다. 즉 안에 속성여러 개 쌓을 수 있다.
                children: [
                  Padding(padding: EdgeInsets.only(top:80)), // 위에 공간 둠
                  Text('News Categories', style: TextStyle(color: Colors.white, fontSize: 24),),
                ],
              ),
            ),
            ListTile(
              title : const Text('Headlines'),
              onTap: () { // 첫 화면이 headlines라 빈 카테고리로 넣으면 됨.
              _onCategoryTap(category: '');
                Navigator.pop(context);
              }
            ),
            ListTile(
              title : const Text('Business'),
              onTap: () { // 기능은 여기 구현. initState에서 futureArticles에 들어간 내용이 바뀌었다고 알려야 한다.
                _onCategoryTap(category: 'Business');
                Navigator.pop(context);
              }
            ),
            ListTile(
              title : const Text('Technology'),
              onTap: () {
                _onCategoryTap(category: 'Technology');
                Navigator.pop(context);
              }
            ),
            ListTile(
              title : const Text('Entertainment'),
              onTap: () {
                _onCategoryTap(category: 'Entertainment');
                Navigator.pop(context);
              }
            ),
            ListTile(
              title : const Text('Sports'),
              onTap: () {
                _onCategoryTap(category: 'Sports');
                Navigator.pop(context);
              }
            ),
            ListTile(
              title : const Text('Science'),
              onTap: () {
                _onCategoryTap(category: 'Science');
                Navigator.pop(context);
              }
            ),
            ListTile(
              title : const Text('Health'),
              onTap: () {
                _onCategoryTap(category: 'Health');
                Navigator.pop(context);
              }
            ),
          ],
        )
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
  