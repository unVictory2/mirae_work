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

  Stock({
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

  factory Stock.fromJson(Map<String, dynamic> x) {
    return Stock(
      code: x['Code'] ?? '',
      name: x['Name'] ?? '',
      market: x['Market'] ?? '',
      marketId: x['MarketId'] ?? '',
      isuCd: x['ISU_CD'] ?? '',
      amount: x['Amount'] ?? 0,
      chagesRatio: x['ChagesRatio'] ?? 0.0,
      changeCode: x['ChangeCode'] ?? '',
      changes: x['Changes'] ?? 0,
      close: x['Close'] ?? '',
      dept: x['Dept'] ?? '',
      high: x['High'] ?? 0,
      low: x['Low'] ?? 0,
      marcap: x['Marcap'] ?? 0,
      open: x['Open'] ?? 0,
      stocks: x['Stocks'] ?? 0,
      volume: x['Volume'] ?? 0,
    );
  }
}

class StockService {
  Future<List<Stock>> getStocks({int page = 1, int ppv = 20}) async {
    // 강사님은 stocks라고 쳤는데 난 stock이 맞음, stocks로 치면 못 불러옴
    String url = 'http://223.194.157.229:8070/stock?pages=$page&ppv=$ppv';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> data = body['data'];
      List<Stock> stocks = data.map((dynamic item) => Stock.fromJson(item)).toList();
      return stocks;
    } else {
      throw Exception('Failed to load stocks');
    }
  }
}
