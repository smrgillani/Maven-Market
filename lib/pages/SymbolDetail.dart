import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
// http
import 'package:http/http.dart' as http;
// common_widget
import 'package:maven_market/common_widgets/IntervalSelector.dart';
// State
import 'package:provider/provider.dart';
import 'package:maven_market/state/DataHouse.dart';
// Post
import 'package:maven_market/post/FeedList.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SymbolDetail extends StatefulWidget {
  final String symbol;
  const SymbolDetail(this.symbol);
  @override
  _SymbolDetailState createState() => _SymbolDetailState();
}

class ChartData {
  final DateTime date;
  final double value;

  ChartData(this.date, this.value);

  static Future<List<ChartData>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://query1.finance.yahoo.com/v8/finance/chart/ACC.NS?region=IN&lang=en-IN&includePrePost=false&interval=1d&range=1mo&corsDomain=in.finance.yahoo.com&.tsrc=finance'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> timeSeries = jsonData['chart']['result'][0]['timestamp'];
      List<dynamic> values = jsonData['chart']['result'][0]['indicators']['quote'][0]['close'];

      List<ChartData> chartData = [];
      for (int i = 0; i < timeSeries.length; i++) {
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeSeries[i] * 1000);
        if(values[i] != null)
          chartData.add(ChartData(dateTime, values[i]));
      }
      return chartData;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class CandleData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  CandleData(this.date, this.open, this.high, this.low, this.close);

  static Future<List<CandleData>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://query1.finance.yahoo.com/v8/finance/chart/ACC.NS?region=IN&lang=en-IN&includePrePost=false&interval=1d&range=1mo&corsDomain=in.finance.yahoo.com&.tsrc=finance'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> timeSeries = jsonData['chart']['result'][0]['timestamp'];
      List<dynamic> opens = jsonData['chart']['result'][0]['indicators']['quote'][0]['open'];
      List<dynamic> highs = jsonData['chart']['result'][0]['indicators']['quote'][0]['high'];
      List<dynamic> lows = jsonData['chart']['result'][0]['indicators']['quote'][0]['low'];
      List<dynamic> closes = jsonData['chart']['result'][0]['indicators']['quote'][0]['close'];

      List<CandleData> candleData = [];
      for (int i = 0; i < timeSeries.length; i++) {
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeSeries[i] * 1000);
        double open = opens[i] != null ? opens[i].toDouble() : 0;
        double high = highs[i] != null ? highs[i].toDouble() : 0;
        double low = lows[i] != null ? lows[i].toDouble() : 0;
        double close = closes[i] != null ? closes[i].toDouble(): 0;
        candleData.add(CandleData(dateTime, open, high, low, close));
      }
      return candleData;
    } else {
      throw Exception('Failed to load data');
    }
  }

}

class _SymbolDetailState extends State<SymbolDetail> {
  late final DataHouse _dataHouse;
  late Map<dynamic, dynamic> _quate;
  List<ChartData>? chartData;

  List<Candle> candles = [];
  bool themeIsDark = false;

  List<CandleData>? candleData;

  @override
  void initState() {
    super.initState();
    _dataHouse = context.read<DataHouse>();
    _quate = _dataHouse.quate(widget.symbol);

    // fetchCandles().then((value) {
    //   setState(() {
    //     candles = value;
    //   });
    // });

    CandleData.fetchData().then((data) {
      setState(() {
        candleData = data;
      });
    });

    // ChartData.fetchData().then((data) {
    //   setState(() {
    //     chartData = data;
    //   });
    // });
    // print(_quate);
    // var url = "https://query1.finance.yahoo.com/v8/finance/chart/ACC.NS?region=IN&lang=en-IN&includePrePost=false&interval=1d&range=1mo&corsDomain=in.finance.yahoo.com&.tsrc=finance"; //').json()['chart']['result'][0]['indicators']['quote'][0]";
  }

  Future<List<Candle>> fetchCandles() async {
    final uri = Uri.parse(
        "https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1h");
    final res = await http.get(uri);
    return (jsonDecode(res.body) as List<dynamic>)
        .map((e) => Candle.fromJson(e))
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.star_border_outlined),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text('Telecom'),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(_quate['q'][0].toString(),
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('   ${_quate['q'][2]} %',
                        style: TextStyle(
                          color: _quate['q'][2] > 0 ? Colors.green : Colors.red,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                    const Text('1D'),
                  ],
                ),
                IntervalSelector(
                    '1D',
                    const [
                      '1D',
                      '1W',
                      '1M',
                      '1Y',
                      'Max',
                    ],
                    () {}),
                // Container(
                //   height: 300,
                //   alignment: Alignment.center,
                //   // child: Text('Chart', style: Theme.of(context).textTheme.headline3),
                //   child: chartData != null
                //       ? SfCartesianChart(
                //     primaryXAxis: DateTimeAxis(),
                //     series: <ChartSeries>[
                //       LineSeries<ChartData, DateTime>(
                //         dataSource: chartData!,
                //         xValueMapper: (ChartData data, _) => data.date,
                //         yValueMapper: (ChartData data, _) => data.value,
                //       ),
                //     ],
                //   )
                //       : const CircularProgressIndicator(),
                // ),
                Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: candleData != null
                      ? SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    series: <ChartSeries>[
                      CandleSeries<CandleData, DateTime>(
                        dataSource: candleData!,
                        xValueMapper: (CandleData data, _) => data.date,
                        lowValueMapper: (CandleData data, _) => data.low,
                        highValueMapper: (CandleData data, _) => data.high,
                        openValueMapper: (CandleData data, _) => data.open,
                        closeValueMapper: (CandleData data, _) => data.close,
                      ),
                    ],
                  )
                      : CircularProgressIndicator(),
                ),
                // Container(
                //   height: 300,
                //   alignment: Alignment.center,
                //   child: candles != null ? Candlesticks(
                //     candles: candles,
                //   ) : const CircularProgressIndicator(),
                // ),
              ],
            ),
          ),
          SliverAppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IntervalSelector(
                    'All Post',
                    const [
                      'All Post',
                      'Following Post'
                    ],
                    () {}),
                IconButton(
                  icon: const Icon(Icons.post_add_outlined),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/CreatePost',
                    arguments: widget.symbol,
                  ),
                ),
              ],
            ),
            pinned: true,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
          ),
          FeedList(symbol: widget.symbol),
        ],
      ),
    );
  }
}
