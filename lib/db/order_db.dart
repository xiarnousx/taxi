import 'package:flutter/material.dart';
import 'package:taxi/db/base.dart';
import 'package:taxi/models/order.p.dart';
import 'dart:async';

class OrderDB extends Base<Order> {
  @override
  Future<Order> getById(int id) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(
      Order.table,
      columns: null,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.length <= 0) {
      return Order.empty();
    }

    return Order.fromMap(maps.first);
  }

  @override
  Future<List<Order>> getList(
      {String sort = 'asc', String filter, filterVal}) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
      "SELECT * FROM orders where $filter = $filterVal and status in ( ${STATUS.remaining.index}, ${STATUS.open.index} ) order by placedOn $sort",
    );

    List<Order> orders = [];

    list.forEach((item) => orders.add(Order.fromMap(item)));

    return orders;
  }

  @override
  Future<Order> insert(Order model) async {
    var dbClient = await db;

    model.id = await dbClient.insert(Order.table, model.toMap());
    return model;
  }

  @override
  Future<Order> update(Order model) async {
    var dbClient = await db;
    final int res = await dbClient.update(Order.table, model.toMap(),
        where: 'id = ?', whereArgs: [model.id]);
    return model;
  }

  @override
  void delete(int id) {
    Future.delayed(Duration.zero, () async {
      var dbClient = await db;
      final int res = await dbClient
          .rawUpdate("update orders set status = 1 where id = $id");
    });
  }

  void closePaymentAndCreateRemaining(
      {@required int customerId, @required double paidAmount}) {
    Future.delayed(Duration.zero, () async {
      var dbClinet = await db;
      final List<Map> res = await dbClinet.rawQuery(
          'SELECT SUM(total) as Total from orders where customerId = $customerId and status != ${STATUS.closed.index}');
      if (res.length <= 0) {
        return null;
      }

      double total = res.first['Total'];

      await dbClinet.rawQuery(
          'UPDATE orders set status= ${STATUS.closed.index} where customerId = $customerId and status != ${STATUS.closed.index}');
      if (total > paidAmount) {
        Order order = Order(
          customerId: customerId,
          total: (total - paidAmount),
          lumpsum_payment: paidAmount,
          status: STATUS.remaining.index,
          type: TYPE.remaining.index,
          placedOn: DateTime.now().toString(),
        );
        await dbClinet.insert(Order.table, order.toMap());
      }
    });
  }
}
