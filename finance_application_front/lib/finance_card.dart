import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'stocks.dart';

class FinanceCard extends StatelessWidget{
  late Stock stock;

  //finance card 만들 때 stock을 받아서 instance 생성하고 시작함. 즉 stock 정보 이미 가지고 있음
  FinanceCard({super.key, required this.stock});


  @override
  Widget build(BuildContext context) { // 여기서 카드를 만들어서 반환
    final formatter = NumberFormat('#,##0'); // 숫자 표현할 방식 설정. intl 사용.

    return GestureDetector(
      // 함수면 일단 () {} 쓰고 생각. 에러나면 원형 보면 됨.
      onTap: () { print('touched!!');},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stock.name), // stock 정보 클래스 생성 시 이미 받았기 때문에 사용 가능하다.
                    Text(stock.code),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // format 함수 안에 stock.close가 dynamic으로 들어가 있기 때문에, format 함수가 정수만 받는 경우 동작 안 할 수도 있음. 그래서 문자열을 정수로 바꿔주는 int.parse.
                    Text(formatter.format(int.parse(stock.close))),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(stock.chagesRatio.toString()),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(stock.volume.toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}