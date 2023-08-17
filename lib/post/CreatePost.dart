import 'package:flutter/material.dart';
// State
import 'package:provider/provider.dart';
import 'package:maven_market/state/DataHouse.dart';
import 'package:maven_market/state/PostState.dart';

class CreatePost extends StatefulWidget {
  final String? symbol;
  CreatePost({this.symbol});
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late final List<dynamic> _allSymbols;
  late final TextEditingController _textController;
  String? _hashTicker;
  List<dynamic> _hashTickers = [];

  List<dynamic> _mentions = [];
  Map<String, dynamic> _postMap = {};
  @override
  void initState() {
    super.initState();
    _allSymbols = context.read<DataHouse>().allSymbol;
    _textController = HighlightTextEditingController((String text, TextStyle style) {
      List<InlineSpan> children = [];
      text.splitMapJoin(
        RegExp(_mentions.map((e) => e).join('|')),
        onMatch: (Match match) {
          children.add(TextSpan(
            text: match[0],
            style: const TextStyle(
              color: Colors.blue,
              height: 1.5,
              letterSpacing: 1.0,
            ),
          ));
          return '';
        },
        onNonMatch: (String text) {
          children.add(TextSpan(
            text: text,
            style: style,
          ));
          return '';
        },
      );
      return TextSpan(children: children);
    });
    if (widget.symbol != null) {
      _mentions.add('#${widget.symbol}');
      _textController.text = '#${widget.symbol} ';
    }
    _textController.addListener(() {
      final String tickerString = _textController.text.split("\n").last.split(' ').last;
      if (tickerString.startsWith('#')) {
        setState(() {
          _hashTicker = tickerString.substring(1).toUpperCase();
          _hashTickers = _allSymbols.where((i) => i.startsWith(_hashTicker)).toList();
        });
      } else if (_hashTicker != null) {
        setState(() {
          _hashTicker = null;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
            child: ElevatedButton(
              child: const Text('Post'),
              onPressed: () {
                context.read<PostState>().addPost(_postMap
                  ..addAll({
                    'mentions': _mentions,
                    'text': _textController.text
                  }));
                context.read<PostState>().addDataToBhavcopy("Hind", 100.0, 1.5, 10000, 70.0, "https://example.com/symbol1_logo.png");
                context.read<PostState>().addDataToBhavcopy("Wind", 200.0, -2.0, 5000, 60.0, "https://example.com/symbol2_logo.png");
                context.read<PostState>().addDataToBhavcopy("Dind", 200.0, -2.0, 5000, 60.0, "https://example.com/symbol2_logo.png");
                context.read<PostState>().addDataToBhavcopy("Sind", 200.0, -2.0, 5000, 60.0, "https://example.com/symbol2_logo.png");
                context.read<PostState>().addDataToBhavcopy("Kind", 200.0, -2.0, 5000, 60.0, "https://example.com/symbol2_logo.png");

                Map<dynamic, dynamic> metaData = {
                  "broad_indices": ["Index1", "Index2",],
                  "sect_indices": ["SectorIndex1", "SectorIndex2",],
                  "indices_consti": {
                    "Index1": ["SymbolA", "SymbolB",],
                    "Index2": ["SymbolC", "SymbolD",],
                  },
                  "sectors": ["Sector1", "Sector2",],
                  "sectors_consti": {
                    "SymbolA": 0,
                    "SymbolB": 1,
                  },
                  "industries": ["Industry1", "Industry2",],
                  "industries_consti": {
                    "SymbolC": 0,
                    "SymbolD": 1,
                  },
                  "logo_url": {
                    "SymbolA": "https://example.com/symbol_a_logo.png",
                    "SymbolB": "https://example.com/symbol_b_logo.png",
                    "SymbolC": "https://example.com/symbol_c_logo.png",
                    "SymbolD": "https://example.com/symbol_d_logo.png",
                  },
                };

                // context.read<PostState>().addDataToMeta(metaData);

                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (_postMap['trend'] != null)
            Container(
              margin: const EdgeInsets.only(left: 60),
              alignment: Alignment.bottomLeft,
              child: _postMap['trend'] ? const Text('Bullish', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)) : const Text('Bearish', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 12, top: 4),
                  child: CircleAvatar(radius: 20, child: Icon(Icons.person_rounded)),
                ),
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                      height: 1.5,
                      letterSpacing: 1.0,
                    ),
                    decoration: const InputDecoration(
                      hintText: "What's Happening...!",
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                    controller: _textController,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    autocorrect: false,
                    autofocus: true,
                  ),
                ),
              ],
            ),
          ),
          if (_hashTicker != null)
            Expanded(
              flex: 3,
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) => ListTile(
                  subtitle: const Text('NSE'),
                  title: Text(_hashTickers[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    final String selTicker = _hashTickers[index];
                    _mentions.add('#$selTicker');
                    String text = _textController.text;
                    text = '${text.substring(0, text.length - _hashTicker!.length)}${selTicker} ';

                    _textController.value = TextEditingValue(
                      text: text,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: text.length),
                      ),
                    );
                  },
                ),
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemCount: _hashTickers.length,
              ),
            ),
          if (_hashTicker == null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                      onPressed: () => setState(() {
                            _postMap['trend'] = true;
                          }),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
                      child: const Text('Bullish')),
                ),
                ElevatedButton(
                    onPressed: () => setState(() {
                          _postMap['trend'] = false;
                        }),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                    child: const Text('Bearish')),
              ],
            ),
        ],
      ),
    );
  }
}

class HighlightTextEditingController extends TextEditingController {
  HighlightTextEditingController(this.buildSpan);
  Function buildSpan;

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    return buildSpan(text, style);

    //return super.buildTextSpan(context: context, style: TextStyle(), withComposing: withComposing);
  }
}
