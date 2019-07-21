import 'package:flutter/material.dart';
import 'package:taxi/helpers.dart/taxi_border_bottom.dart';
import 'package:taxi/screens/home.screen.dart';
import 'package:taxi/screens/manage_customer.screen.dart';
import 'package:taxi/widgets/taxi_drawer_header.dart';

class TaxiDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 70.0,
                width: double.infinity,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: TaxiBorderBottom.get(),
                child: TaxiDrawerHeader(),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Customers'),
            onTap: () {
              Navigator.of(context).pushNamed(HomeScreen.path);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.group_add),
            title: Text('Add Customers'),
            onTap: () {
              Navigator.of(context).pushNamed(ManageCustommerScreen.path);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
