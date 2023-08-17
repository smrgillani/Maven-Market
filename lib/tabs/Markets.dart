import 'package:flutter/material.dart';
// markets tabs
import 'package:maven_market/markets_tabs/Overview.dart';
import 'package:maven_market/markets_tabs/Sectors.dart';
import 'package:maven_market/markets_tabs/Deals.dart';

class Markets extends StatefulWidget {
  @override
  _MarketsState createState() => _MarketsState();
}

class _MarketsState extends State<Markets> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, vsync: this, length: 6);
    _tabController.addListener(() {
      print(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () => Navigator.pushNamed(
              context,
              '/SearchSymbol',
            ),
          ),
        ],
        bottom: TabBar(
          tabs: const <Tab>[
            Tab(text: 'Overview'),
            Tab(text: 'Industries'),
            Tab(text: 'Sectors'),
            Tab(text: 'Deals'),
            Tab(text: 'IPO Center'),
            Tab(text: 'Earnings'),
          ],
          isScrollable: true,
          controller: _tabController,
          labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 30),
        ),
        title: const Text('Markets'),
        shape: Border(bottom: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.5))),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Overview(),
          Sectors('Industries'),
          Sectors('Sectors'),
          Deals(),
          const Text('ak'),
          const Text('ak'),
        ],
      ),
    );
  }
}
