import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi/db/customer_db.dart';

class Customer {
  static const String table = 'customers';

  int id;
  String name;
  double amountDue = 0.0;

  Customer({this.name});
  Customer.empty() : this.name = '';
  Customer.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        amountDue = map['amountDue'] ?? 0.0;

  void setId(val) => id = val;
  void setName(val) => name = val;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
}

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  CustomerDB db = CustomerDB();

  List<Customer> get customers => _customers;

  void initCustomers() async {
    _customers = await db.getList(sort: 'asc');
    notifyListeners();
  }

  void search(String search) async {
    _customers = await db.search(search);
    notifyListeners();
  }

  void add(Customer customer) async {
    Customer inserted = await db.insert(customer);
    notifyListeners();
  }

  void update(Customer customer) async {
    Customer updated = await db.update(customer);
    notifyListeners();
  }

  Future<Customer> getById({int id}) async {
    if (id == null) {
      return Customer.empty();
    }
    return await db.getById(id);
  }

  static CustomerProvider getInstance(
          {BuildContext context, bool listen = true}) =>
      Provider.of<CustomerProvider>(context, listen: listen);
}
