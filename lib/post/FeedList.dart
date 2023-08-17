import 'package:flutter/material.dart';

import 'package:maven_market/post/PostBody.dart';
// State
import 'package:provider/provider.dart';
import 'package:maven_market/state/PostState.dart';
// firestore
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedList extends StatelessWidget {
  final String? symbol;
  const FeedList({this.symbol});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: context.read<PostState>().getFeed(symbol: symbol),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return SliverList(
            delegate: SliverChildListDelegate(
              snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Column(
                  children: <Widget>[
                    PostBody(
                      data,
                      context.read<PostState>().getAvatar(data['userId']),
                    ),
                    const Divider()
                  ],
                );
              }).toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return const SliverToBoxAdapter(
            child: Text('Something went wrong'),
          );
        }

        return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
