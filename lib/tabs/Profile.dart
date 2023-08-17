import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Hive Local Database
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
// State
import 'package:provider/provider.dart';
import 'package:maven_market/state/PostState.dart';

import '../state/AuthState.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Box<dynamic> _box = Hive.box('app_state');

  @override
  Widget build(BuildContext context) {
    final List<String> _tabs = <String>[
      'Posts',
      'Replay',
      'Likes',
    ];
    return DefaultTabController(
      length: _tabs.length,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: Text(''),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(bottom: 60),
                  centerTitle: true,
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      context.read<PostState>().getAvatar(_box.get('userId', defaultValue: ''), 35),
                      const SizedBox(height: 15),
                      Text('Maven Market', style: Theme.of(context).textTheme.headline6),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          for (String i in [
                            '0',
                            '0',
                            '0'
                          ])
                            Text(i, style: Theme.of(context).textTheme.button),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          for (String i in [
                            'Post',
                            'Followers',
                            'Following',
                          ])
                            Text(i, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text('Price Action Trader | Position Trader | Coder'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {

                            },
                            child: const Text('Edit Profile'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () async {
                              final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                              await firebaseAuth.signOut();
                              final authState = Provider.of<AuthState>(context, listen: false);
                              Navigator.pushNamed(context,'/',arguments: authState);
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/UserId',
                    ),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: TabBar(
                      tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                    ),
                  ),
                ),
                pinned: true,
                expandedHeight: 350.0,
              ),
            ),
          ];
        },
        body: TabBarView(
          children: _tabs.map((String name) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>(name),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return _post();
                          },
                          childCount: 30,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  _post() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 14, right: 10),
            child: CircleAvatar(radius: 25, child: FlutterLogo()),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Text('Flutter', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    const Text('@flutterDev .7 min', style: TextStyle(color: Colors.grey)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.expand_more_outlined),
                      onPressed: () {},
                    )
                  ],
                ),
                const Text('Nse looks like,\nhaving a biggeat rally forword and be\nall year nifty is high loke rocket always bullish\nready to get your reward....'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        primary: Colors.grey,
                      ),
                      icon: const Icon(Icons.thumb_up_outlined),
                      label: const Text('7842'),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        primary: Colors.grey,
                      ),
                      icon: const Icon(Icons.loop_outlined),
                      label: const Text('478'),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        primary: Colors.grey,
                      ),
                      icon: const Icon(Icons.chat_bubble_outline_outlined),
                      label: const Text('742'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
