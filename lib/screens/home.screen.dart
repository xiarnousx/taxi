import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:taxi/helpers.dart/taxi_border_bottom.dart';
import 'package:taxi/models/customer.p.dart';
import 'package:taxi/screens/manage_customer.screen.dart';
import 'package:taxi/screens/order.screen.dart';
import 'package:taxi/widgets/taxi_app_bar.dart';
import 'package:taxi/widgets/taxi_button.dart';
import 'package:taxi/widgets/taxi_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const String path = '/';

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearchable = false;
  bool _isSearchFieldValid = false;
  bool _didChange = true;
  String _searchText = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_didChange) {
      CustomerProvider provider =
          CustomerProvider.getInstance(context: context, listen: false);
      _isSearchable ? provider.search(_searchText) : provider.initCustomers();
      _didChange = false;
    }
  }

  @override
  void initState() {
    super.initState();
    CustomerProvider provider =
        CustomerProvider.getInstance(context: context, listen: false);
    provider.initCustomers();
  }

  @override
  Widget build(BuildContext context) {
    CustomerProvider provider = CustomerProvider.getInstance(context: context);

    return Scaffold(
      appBar: TaxiAppBar(
        headerText: 'Taxi Riders',
        actions: <Widget>[
          if (_isSearchable)
            IconButton(
                icon: Icon(Icons.clear),
                color: Colors.amber,
                tooltip: 'Clear Search',
                onPressed: () {
                  setState(() {
                    _isSearchable = false;
                    _searchText = '';
                  });
                  provider.initCustomers();
                }),
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.amber,
            tooltip: 'Search for Customers',
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      drawer: TaxiDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    CustomerProvider provider = CustomerProvider.getInstance(context: context);
    var customers = provider.customers;

    if (customers.length <= 0) {
      return _getNoDataWidget();
    }

    return _buildListView();
  }

  Widget _getNoDataWidget() {
    return TaxiButton(
      icon: Icon(Icons.group_add),
      text: 'Add New Customer',
      buttonHandler: () {
        return Navigator.of(context).pushNamed(ManageCustommerScreen.path);
      },
    );
  }

  Widget _buildListView() {
    CustomerProvider provider = CustomerProvider.getInstance(context: context);
    var customers = provider.customers;

    Widget listView = ListView.separated(
      itemCount: customers.length,
      separatorBuilder: (_, int index) => Container(
        decoration: TaxiBorderBottom.get(color: Colors.amber[100]),
      ),
      itemBuilder: (_, int index) {
        final Customer customer = customers[index];

        return Container(
          color: Colors.black54,
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(customer.name),
            subtitle: _buildAmountDue(customer.amountDue),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(OrderScreen.path, arguments: customer.id);
            },
            onLongPress: () {
              Navigator.of(context).pushNamed(ManageCustommerScreen.path,
                  arguments: customer.id);
            },
          ),
        );
      },
    );

    return RefreshIndicator(
      displacement: 60,
      backgroundColor: Colors.black38,
      onRefresh: () {
        return Future.delayed(Duration.zero, () {
          provider.initCustomers();
          setState(() {
            _isSearchable = false;
          });
        });
      },
      child: listView,
    );
  }

  Future _showSearchDialog() {
    CustomerProvider provider = CustomerProvider.getInstance(context: context);
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        backgroundColor: Colors.amber,
        title: Text(
          'Search for customers:',
          style: TextStyle(color: Colors.black),
        ),
        children: <Widget>[
          Container(
            color: Colors.black87,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Customer Name',
                      errorText:
                          !_isSearchFieldValid ? 'Value Can\'t Be Empty' : null,
                      icon: Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                Divider(),
                Container(
                  alignment: Alignment.bottomRight,
                  child: TaxiButton(
                    icon: Icon(Icons.search),
                    text: 'Search For Customer',
                    buttonHandler: () {
                      final searchText = _searchController.text;

                      if (searchText.isEmpty) {
                        _isSearchable = false;
                        _isSearchFieldValid = false;
                      } else {
                        _isSearchable = true;
                        _isSearchFieldValid = true;
                      }

                      if (_isSearchFieldValid) {
                        setState(() {
                          _searchText = searchText;
                        });
                        provider.search(searchText);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountDue(double amountDue) {
    final formater = NumberFormat("#,##0.00", "en_US");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Amount Due: LBP ${formater.format(amountDue * 1000)}',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Amount Due: \$${formater.format((amountDue * 1000) / 1500)}',
          style: TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
