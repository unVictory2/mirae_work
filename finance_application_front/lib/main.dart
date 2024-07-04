import 'package:flutter/material.dart';
import 'finance_card.dart';
import 'stocks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home : const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});
  
  @override
  State<StatefulWidget> createState() => _MyHomePageState();  
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Stock>> futureStocks; // 비동기 프로세싱을 하는 클래스 futurestocks. 반환은 <Lst<Stock>>. 참고로 데이터를 받아오는 형식이 <List<Stock>>임.
  @override
  void initState() {
    super.initState();
    futureStocks = StockService().getStocks(); // 완전히 비동기로 진행. 훑고 넘어간다. 데이터가 다 오면 그 때서야 이벤트가 발생된다. 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주식 정보 조회'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // 여백 주는 sizedbox. 이 외에도 padding도 있다.
          //SizedBox(height: 8,),
          const Padding(padding: EdgeInsets.all(8.0),),
          const Row( // 2개의 텍스트가 row의 children으로 들어와있는데, 수평 방향의 spacebetween이라 가로 공간을 전부 다 쓰면서 벌어져있다.
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //row의 cross는 수직방향이다.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded( // flex 항목 적용하기 위해 
                flex: 2, // row에서 배치시 비율이 됨
                child: Column( // 2줄짜리를 표현할거라 column으로 감쌂
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('종목명'),
                    Text('종목코드'),
                  ],
                ),
              ),
              Expanded( // flex 항목 적용하기 위해 
                flex: 1,
                child: Column( // 2줄짜리를 표현할거라 column으로 감쌂
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('현재가'),
                  ],
                ),
              ),
              Expanded( // flex 항목 적용하기 위해 
                flex: 1,
                child: Column( // 2줄짜리를 표현할거라 column으로 감쌂
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('전일비'),
                  ],
                ),
              ),
              Expanded( // flex 항목 적용하기 위해 
                flex: 2,
                child: Column( // 2줄짜리를 표현할거라 column으로 감쌂
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('거래량'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8,),
          Expanded(
            // listview에 listtile만들어서 넣는다. listtile에는 우리가 불러온 데이터 
            // 근데 데이터는 웹에서 오기 때문에 비동기다. 언제 올지 모름. 그래서 이 부분을 그냥 비어있게 냅두면 앱이 팅긴거처럼 보일 수 있음.
            child: FutureBuilder<List<Stock>>(
              future: futureStocks, // 데이터를 넣어줘야 한다. 위 initState에서 futureStocks로 데이터 받았었음.
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Stock stock = snapshot.data![index];
                      return FinanceCard(stock: stock);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // 에러 상태도 아니고, 데이터도 아직 못 받은 경우
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      )
    );
  }
}