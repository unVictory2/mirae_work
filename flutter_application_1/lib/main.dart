import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() { // MyApp에서 정의된 앱을 실행하라고 Flutter에 지시할 뿐
  runApp(MyApp()); 
}

// MyApp의 코드는 전체 앱을 설정
// 앱 전체 상태를 생성하고(나중에 자세히 설명) 앱의 이름을 지정하고 시각적 테마를 정의하고 '홈' 위젯(앱의 시작점)을 설정
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// MyAppState는 앱이 작동하는 데 필요한 데이터를 정의, 지금은 현재 임의의 단어 쌍이 있는 단일 변수만 포함되어 있습니다. 
//상태 클래스는 ChangeNotifier를 확장. 상태가 만들어지고 ChangeNotifierProvider를 사용하여 전체 앱에 제공된다. 
//예를 들어 현재 단어 쌍이 변경되면 앱의 일부 위젯이 알아야 합니다.
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random(); // 임의의 새 WordPair를 current에 재할당
    notifyListeners(); // MyAppState를 보고 있는 사람에게 알림을 보내는 notifyListeners()(ChangeNotifier)의 메서드)를 호출
  }

  var favorites = <WordPair>[]; // 속성 favorites. 빈 List ([])으로 초기화. 목록에 <WordPair>[] 단어 쌍만 포함될 수 있다고 지정. WordPair가 아닌 것 추가 불가 = null check 안 해도 됨

  void toggleFavorite() { // 좋아요 함수. favorites 리스트에 넣고 빼기
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget { 
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> { // State를 확장하므로 자체 값을 관리(변경)할 수 있습니다. MyHomePage의 build 그대로 얻어옴.
  var selectedIndex = 0; // 새 스테이트풀(Stateful) 위젯은 하나의 변수 selectedIndex만 추적하면 됩니다. 
  @override
  Widget build(BuildContext context) {
    Widget page; // Widget 유형의 새 변수 page를 선언
    switch (selectedIndex) { // selectedIndex의 현재 값에 따라 switch 문이 화면을 page에 할당
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        // page = Placeholder(); // 배치하는 곳마다 교차 사각형을 그려 UI의 해당 부분이 미완성임을 표시하는 편리한 위젯인 Placeholder를 사용
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder( // 이 위젯을 사용하면 사용할 수 있는 공간의 양에 따라 위젯 트리를 변경할 수 있습니다.
      builder: (context, constraints) { // LayoutBuilder의 builder 콜백은 제약 조건이 변경될 때마다 호출됩니다. 예를 들어 창 크기가 바뀐다던지.
        return Scaffold(
          body: Row( // 하위 요소 두 개가 있는 Row. SafeArea, Expanded.
            children: [
              SafeArea( // NavigationRail(탐색 레일)를 래핑하여 하위 요소가 하드웨어 노치나 상태 표시줄로 가려지지 않도록
                child: NavigationRail( //  탐색 레일
                  extended: constraints.maxWidth >= 600, // 라벨이 아이콘 옆에 표시될지. MyHomePage의 너비가 600픽셀 이상일 때만 라벨을 표시.
                  destinations: [
                    NavigationRailDestination( // 탐색 레일에 두 가지 대상이 있음 : Home, Favorites.
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex, // NavigationRail 위젯의 selectedIndex 속성에 현재 상태 클래스 _MyHomePageState의 selectedIndex 변수를 할당
                  // this.selectedIndex = selectedIndex; 왼쪽은 NavigationRail의 속성, 오른쪽은 _MyHomePageState의 인스턴스 변수
                  // "위젯의 속성"은 위젯을 구성하는 데 사용되는 매개변수 또는 인자를 의미
                  // NavigationRail 위젯의 selectedIndex, destinations, onDestinationSelected, extended 등이 속성이라는 것은 Flutter 프레임워크에서 미리 정의된 것
                  // 콜론 :은 Dart의 객체 초기화에서 속성 값을 지정할 때 사용
                  // Flutter에서는 위젯을 초기화할 때 이러한 구문을 자주 사용 selectedIndex: selectedIndex
                  // 왼쪽의 selectedIndex는 NavigationRail 위젯의 생성자에서 정의된 속성입니다.
                  // 오른쪽의 selectedIndex는 현재 클래스(여기서는 _MyHomePageState)의 인스턴스 변수입니다.
                  // 문맥과 클래스 정의를 통해 왼쪽과 오른쪽이 각각 무엇을 의미하는지 알 수 있습니다. > 왼 오에 뭐가 오는지는 일종의 약속이라고 봐도 된다고 함.
                  onDestinationSelected: (value) { // 탐색 레일은 또한 사용자가 onDestinationSelected로 대상 중 하나를 선택할 때 발생하는 작업을 정의
                    setState(() { // onDestinationSelected 콜백이 호출되면 새 값을 콘솔로 인쇄하는 대신 setState() 호출 내 selectedIndex에 할당합니다.
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded( // 일부 하위 요소는 필요한 만큼만 공간을 차지하고(여기서는 NavigationRail) 다른 위젯은 남은 공간을 최대한 차지해야 하는(여기서는 Expanded) 레이아웃을 표현할 수 있습니다
                child: Container( // 색상이 지정된 Container가 있고 컨테이너 안에는 GeneratorPage가 있습니다.
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget { // MyHomePage의 전체 콘텐츠가 새 위젯 GeneratorPage로 추출
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) { // 위젯의 상황이 변경될 때마다 자동으로 호출되는 build() 메서드
    var appState = context.watch<MyAppState>(); //MyHomePage는 watch 메서드를 사용하여 앱의 현재 상태에 관한 변경사항을 추적
    var pair = appState.current;

    IconData icon; // 좋아요 눌렀는지에 따라 적당한 아이콘 설정
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold( //모든 build 메서드는 위젯 또는 중첩된 위젯 트리(좀 더 일반적임)를 반환해야 합니다. 최상위 위젯은 Scaffold입니다.
      body: Center( // 다른 위젯들은 알아서 돼있지만, 가운데에 있지 않았던 Column 자체를 가운데 정렬
        child: Column( // 레이아웃 위젯 중 하나. 얘를 wrap with center 해서 윗줄이 생겨남.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text('A random AWESOME idea:'), // 그냥 텍스트
            // Text(appState.current.asLowerCase), //appState를 사용하고 해당 클래스의 유일한 멤버인 current(즉, WordPair)에 액세스
            BigCard(pair: pair), //이걸로 변경. 원래는 전체 appState에 액세스하지만 실제로는 현재 단어 쌍이 무엇인지만 알면 됩니다.
            SizedBox(height: 10), // 여백 
            Row( // Next 버튼 옆에 새 버튼 추가하려고 wrap with row
              mainAxisSize: MainAxisSize.min, // 사용 가능한 모든 가로 공간을 차지하지 말라고 Row에 지시. 없으면 버튼이 한 쪽으로 몰림.
              children: [
                ElevatedButton.icon(
                  onPressed: () { //람다. 매개 변수로 아무것도 주지 않으면서 toggleFavorite 함수를 부르라
                    appState.toggleFavorite(); // 좋아요 함수 호출
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                SizedBox(width: 10), // 여백

                ElevatedButton( //Next 라고 쓰인 버튼
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

class BigCard extends StatelessWidget { // Text(pair.asLowerCase) 위에서 ctrl + . >> Extract Widget >> BigCard 했더니 BigCard(pair: pair로 바뀌고 이 클래스 자동 추가)
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Theme.of(context)로 앱의 현재 테마를 요청
    final style = theme.textTheme.displayMedium!.copyWith( // theme.textTheme,을 사용하여 앱의 글꼴 테마에 액세스합니다. 
    // displayMedium 속성은 디스플레이 텍스트를 위한 큰 스타일. nullable이라 원래는 못 부르지만 ! 연산자 붙이면 개발자가 null 아님을 보장
    // displayMedium에서 copyWith()를 호출하면 정의된 변경사항이 포함된 텍스트 스타일의 사본이 반환
      color: theme.colorScheme.onPrimary, // 앱 테마에 액세스해서 새로운 색상 가져옴
    );

    return Card( // Padding 위젯과 Text 위젯이 Card 위젯으로 래핑
      color: theme.colorScheme.primary, // colorScheme 속성과 동일하도록 카드의 색상을 정의합니다. 색 구성표에는 여러 색상이 포함되어 있으며 primary가 앱을 정의하는 가장 두드러진 색상
      child: Padding(
        padding: const EdgeInsets.all(20.0), //padding은 text의 속성이 아니라 위젯임
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); // 앱의 현재 상태를 가져옵니다.

    if (appState.favorites.isEmpty) { // 즐겨찾기 목록이 비어 있으면 No favorites yet이라는 메시지를 중앙에 표시
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView( // 목록이 비어 있지 않으면 스크롤 가능한 목록을 표시
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ' // 목록은 요약으로 시작됩니다(예: You have 5 favorites*.*).
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites) // 그런 다음 코드가 모든 즐겨찾기를 반복하고 각 즐겨찾기의 ListTile 위젯을 구성합니다.
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}