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

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      market: json['market'] ?? '',
      marketID: json['marketID'] ?? '',
      isuCd: json['isuCd'] ?? '',
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