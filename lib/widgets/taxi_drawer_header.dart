import 'package:flutter/material.dart';

class TaxiDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Text(
        'Management',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
