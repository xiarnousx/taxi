import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi/models/customer.p.dart';
import 'package:taxi/db/db.dart';
import 'package:taxi/models/order.p.dart';
import 'package:taxi/screens/home.screen.dart';
import 'package:taxi/screens/manage_customer.screen.dart';
import 'package:taxi/screens/order.screen.dart';

void main() {
  //_initDB();
  //debugPaintBaselinesEnabled = true;
  //debugPaintSizeEnabled = true;
  _initDB();
  runApp(_Taxi());
}

_initDB() async {
  Db.open();
}

class _Taxi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => CustomerProvider(),
        ),
        ChangeNotifierProvider(
          builder: (_) => OrderProvider(),
        )
      ],
      child: MaterialApp(
        title: 'TAXI Ridders',
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.amber,
          primarySwatch: Colors.amber,
          primaryColor: Colors.black,
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        initialRoute: HomeScreen.path,
        routes: {
          HomeScreen.path: (context) => HomeScreen(),
          ManageCustommerScreen.path: (context) => ManageCustommerScreen(),
          OrderScreen.path: (context) => OrderScreen(),
        },
      ),
    );
  }
}
