import 'package:flutter/material.dart';
// State
import 'package:provider/provider.dart';
import 'package:maven_market/state/DataHouse.dart';
// common_widget
import 'package:maven_market/common_widgets/IntervalSelector.dart';

class Deals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        IntervalSelector(
            'Bulk',
            const [
              'Bulk',
              'Block',
              'Insides'
            ],
            () {}),
      ],
    );
  }
}
