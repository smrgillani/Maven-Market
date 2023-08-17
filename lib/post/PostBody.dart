import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostBody extends StatelessWidget {
  final Map<dynamic, dynamic> post;
  final Widget avatar;
  const PostBody(this.post, this.avatar);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 7,
      leading: avatar,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text(post['userId'], style: const TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text(timeago.format(post['timestamp'].toDate(), locale: 'en_short'), style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          post['trend'] != null
              ? Container(
                  alignment: Alignment.bottomRight,
                  child: post['trend'] ? const Text('Bullish', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)) : const Text('Bearish', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                )
              : const SizedBox(height: 7),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: _buildTextSpan(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildButton(Icons.thumb_up_outlined, count: 42),
              _buildButton(Icons.loop_outlined, count: 78),
              _buildButton(Icons.chat_bubble_outline_outlined, count: 99),
              _buildButton(Icons.share_outlined),
            ],
          ),
        ],
      ),
    );
  }

  List<InlineSpan> _buildTextSpan() {
    List<InlineSpan> children = [];
    post['text'].splitMapJoin(
      RegExp(post['mentions'].map((e) => e).join('|')),
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
        children.add(TextSpan(text: text));
        return '';
      },
    );
    return children;
  }

  Widget _buildButton(IconData icon, {int? count}) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        primary: Colors.grey,
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(vertical: 7),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(icon, size: 20),
      label: Text(count != null ? count.toString() : '', style: const TextStyle(fontSize: 12)),
      onPressed: () {},
    );
  }
}
