import 'package:http/http.dart' as http;
import 'dart:convert';

class Stock {
  late String code;
  late String name;
  late String market;
  late String marketId;
  late String isuCd;
  late int amount;
  late double chagesRatio;
  late String changeCode;
  late int changes;
  late String close;
  late String dept;
  late int high;
  late int low;
  late int marcap;
  late int open;
  late int stocks;
  late int volume;

  Stock({ // 강사님은 이거 칠 필요 없다고 하셨지만 기본 생성자 없으면 factory를 못 써서 기본 생성자는 필요함. 또 그냥 빈 생성자로 만들어두면 late 관련돼서 문제 생길 수도 있대서 그냥 만들기로 함.
    required this.code,
    required this.name,
    required this.market,
    required this.marketId,
    required this.isuCd,
    required this.amount,
    required this.chagesRatio,
    required this.changeCode,
    required this.changes,
    required this.close,
    required this.dept,
    required this.high,
    required this.low,
    required this.marcap,
    required this.open,
    required this.stocks,
    required this.volume,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      market: json['market'] ?? '',
      marketId: json['marketID'] ?? '',
      isuCd: json['isuCd'] ?? '',
      amount: json['amount'] ?? '',
      chagesRatio: json['chagesRatio'] ?? '',
      changeCode: json['changeCode'] ?? '',
      changes: json['changes'] ?? '',
      close: json['close'] ?? '',
      dept: json['dept'] ?? '',
      high: json['high'] ?? '',
      low: json['low'] ?? '',
      marcap: json['marcap'] ?? '',
      open: json['open'] ?? '',
      stocks: json['stocks'] ?? '',
      volume: json['volume'] ?? '',
    );
  }
}

class StockService {
  Future<List<Stock>> getStocks({int page=1, int ppv=20}) async {
    String url = 'http://223.194.157.229:8070/stocks?pages=$page&ppv=$ppv';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Stock> stocks = body.map((dynamic item) => Stock.fromJson(item)).toList();
      return stocks;
    } else {
      throw 'Failed to load stocks';
    }
  }
}