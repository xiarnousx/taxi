import 'package:flutter/material.dart';
import 'package:taxi/helpers.dart/taxi_border_bottom.dart';

class TaxiAppBar extends AppBar {
  final String headerText;
  Key key;

  TaxiAppBar({Key key, this.headerText, List<Widget> actions})
      : super(
          key: key,
          title: Text(headerText),
          bottom: PreferredSize(
            child: Container(
              decoration: TaxiBorderBottom.get(),
            ),
            preferredSize: Size.fromHeight(1),
          ),
          actions: actions ?? [],
        );
}
