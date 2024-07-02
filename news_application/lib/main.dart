import 'package:flutter/material.dart';
import 'package:news_application/articles.dart';
import 'article_card.dart';
import 'settings.dart';
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
  late Future<List<Article>> futureArticles; // 임시 리스트
  final List<Article> _articles = []; // 최종적으로 받는 리스트
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  String _country = 'kr'; // catrgory나 country 바뀔 때 이걸 바꿔주면 됨
  String _category = '';
  bool _isLoadingMore = false;


  final List<Map<String, String>> categories = [ // 인덱싱을 위해 각 항목은 <Map>으로
    {'title': 'Headlines'},
    {'title': 'Business'},
    {'title': 'Technology'},
    {'title': 'Entertainment'},
    {'title': 'Sports'},
    {'title': 'Science'},
  ];

  @override
  void initState() { // 프로그램 실행되자마자 해야하는 일. 
    // 데이터 로딩 처리. 
    super.initState(); // 이미 super에 구현돼있어서 뭘 안 해도 알아서 호출됨.
    futureArticles = NewsService().fetchArticles(); // 데이터 로딩
    // NewsService news = new NewsService();
    // news.fetchArticles(); 가 생략돼서 News.Service().fetchArticles();가 된거
    futureArticles.then((articles) { //처음엔 그냥 지나가고, 나중에 futureArticles가 비동기 처리 끝나고 반환돼서 오면 그 때 then 안 쪽의 함수 실행. 인자인 articles는 리스트임. _articles는 맨 위에서 만든 빈 리스트였음.
    // then 안의 함수는 initState랑은 관련 없는 함수임, setState는 상태 갱신하는 함수.
      setState(() => _articles.addAll(articles)); 
    });

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onCountryTap({String country = 'kr'}) {
    // 밑 함수랑 비슷하게 국가 바꾸는 함수 작성
    setState(() {  // 카테고리 바꾸면 기존에 쌓여있던 기사들 초기화
      _articles.clear(); // 쌓인 것들 초기화
      _currentPage = 1;
      futureArticles = NewsService().fetchArticles(country: country, category: _category); //기사 다시 받기. country는 바꾸고, category는 현재 카테고리로
      futureArticles.then((articles) {
        setState(() => _articles.addAll(articles)); // 비어있는 _articles에 바뀐 카테고리의 기사 넣어줌
        _country = country; // 이거 왜 있어야 되는지
      });
    });
  }

  void _onCategoryTap({String category = ''}) { // articles.dart의 기사 가져오는 함수 fetChArticles에 카테고리 설정해줘서 해당 카테고리 기사 가져오게 한다.
  //인자 중괄호 치는 건 named parameter로 만드는 것. null값 안 되니까 기본값으로 '' 넣어줌.
    setState(() {  // 카테고리 바꾸면 기존에 쌓여있던 기사들 초기화
      _articles.clear(); // 쌓인 것들 초기화
      _currentPage = 1;
      futureArticles = NewsService().fetchArticles(category: category); //기사 다시 받기
      futureArticles.then((articles) {
        setState(() => _articles.addAll(articles)); // 비어있는 _articles에 바뀐 카테고리의 기사 넣어줌
        _category = category;
      });
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
            //map 함수는 리스트 2개를 가지고 새 리스트 반환하는 함수.
            // 새로운 리스트를 넣는다. 위에 있는 categories 사용해서 넣을 거임.
            ...categories.map((category) => ListTile( //기존의 categories는 맵 아이템이 쭉 있을 뿐.
              title: Text(category['title']!), // 각 항목의 value
              onTap: () {
                _onCategoryTap(category: category['title']!);
                Navigator.pop(context);
              }
            )),
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
              controller: _scrollController, 
              itemCount: _articles.length + (_isLoadingMore ? 1 : 0), //참이면 1 더함
              itemBuilder: (context, index) { // 익명 함수
                if (index == _articles.length) { // 위에 _isLoadingMore면 1 더해준 이유가 이거 때문임, 로딩 화면 띄우려고
                  return const Center(child: CircularProgressIndicator());
                }
                final article = _articles[index]; // 이걸로 그림 
                return ArticleCard(article: article, key : ValueKey(article.title)); // valuekey : article title을 seed로 key 만들어줌
              },
            );
          }
        }), // snapshot = 데이터
        bottomNavigationBar: BottomNavigationBar(items: [ // items 항목에 bottomNaviBar에 들어갈 항목들 넣어줌. 전부 위젯임.
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/kr.png',width: 24, height: 24), label: "Country"), // 미리 정의돼있는 구글 스타일 아이콘. Icons.home은 상수임.
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        onTap: ((value)=>_onNavItemTap(value, context)),

        ),
    );
  }

  void _scrollListener() { // 페이지 끝나는 데서 사용자가 스크롤을 더 내린 상황
    if (_scrollController.position.extentAfter < 200 && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      _loadMoreArticles(); // 스크롤 내렸으니까 기사 더 보여줘야 한다
    }
  }
  
  //이런 인터넷 한 번 갔다오는 애들은 비동기로 해줘야 한다
  // 스크롤을 더 내리면 스크롤 리스너가 동작해서 loadMoreArticles 호출
  // loadMoreArticles는 기사를 더 불러와서 밑에다가 붙인다
  Future<void> _loadMoreArticles() async { 
    _currentPage++; // 다음 페이지 로딩
    List<Article> articles = await NewsService().fetchArticles(page: _currentPage); // 카테고리는 안 주고 있음, 기존 카테고리 사용
    setState(() {
      _articles.addAll(articles);
      _isLoadingMore = false;
    });
  }

  void _showModalBottomSheet(BuildContext context) {
    List<Map<String, String>> items = [
      {'title' : 'Korea', 'images': 'assets/images/kr.png', 'code': 'kr'},
      {'title' : 'United States', 'images': 'assets/images/united_states.png', 'code': 'us'},
      {'title' : 'Japan', 'images': 'assets/images/japan.webp', 'code': 'jp'}
    ];
    // items.map((item) => print(item['title']));

    showModalBottomSheet(context: context, 
    builder: (BuildContext context) {
      return Container(
        height: 200,
        color: Colors.white,
        child : GridView.count(
          crossAxisCount: 3, // 가로 줄의 아이템 몇 개를 대체할 거냐
          crossAxisSpacing: 4.0, // 가로 아이템 사이의 간격
          mainAxisSpacing: 4.0, // 상하 방향의 간격
          children: items.map((item) => // items 리스트를 순회하며 각 항목의 정보를 이용해 항목당 하나의 container를 생성한 후, 나라 3개를 그리고 그걸 리스트로 만들어서 children으로 추가한다. 
            Container(
              color: Colors.white,
              child: GestureDetector( // gridview를 탭했을때 어떤 액션을 하기 위해 child로 바로 getsture detector를 줌
                onTap:() { // 항목 눌렀을 때 처리할 일들
                  Navigator.pop(context);
                  _onCountryTap(country : item['code']!);
                  //country 항목 바뀌게 해보기. 아마 api는 이미 country 받을 수 있게 설계됐을 거임.
                },
                child: Center(child:
                  Column( // 각 아이템에 한국 국기, 그 밑 Korea라고 써있게 하기 위해서 column 만듦. 국기+korea가 하나의 column임
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(item['images']!, width : 50, height : 50, fit: BoxFit.cover),
                      Text(item['title']!)
                    ],
                  ),
                ),
              ),
            ),
          ).toList(),
        )
      );
    });
  }

  //nav bar에서 action을 하는 게 아니라, 
  // value : nav bar 아이템 3개 중 눌린 아이템의 인덱스 값
  //지금은 value와 상관 없이 country 선택이 뜸 > 문제
  _onNavItemTap(int value, BuildContext context) {
    print('Selected Index : $value');
    switch (value) {
      case 0 : 
      _showModalBottomSheet(context);
        break;
      case 1 :
        break;
      case 2 :
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
    }
    //show modal = 빈 캔버스 그려줌 
  }
}
  



  