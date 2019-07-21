import 'package:flutter/material.dart';
import 'package:taxi/screens/manage_customer.screen.dart';

class TaxiButton extends StatelessWidget {
  final Icon icon;
  final String text;
  Function buttonHandler;
  Color color = Colors.amber;

  TaxiButton(
      {@required this.icon,
      @required this.text,
      @required this.buttonHandler,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Center(
        child: RaisedButton(
          color: this.color,
          child: Container(
            height: 20,
            width: 200,
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                this.icon,
                Divider(
                  endIndent: 10.0,
                ),
                Text(
                  this.text,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          onPressed: () => this.buttonHandler(),
        ),
      ),
      margin: EdgeInsets.all(20),
    );
  }
}
