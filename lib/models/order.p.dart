import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi/db/order_db.dart';

enum STATUS { open, closed, remaining }
enum TYPE { drop, delivery, remaining }

class Order {
  static const String table = 'orders';

  int id;
  int customerId;
  double total;
  double lumpsum_payment = 0.0;
  int type;
  int status;
  String placedOn;

  Order({
    this.customerId,
    this.total,
    this.type,
    this.placedOn,
    this.status,
    this.lumpsum_payment,
  });

  Order.empty()
      : id = null,
        customerId = null,
        total = 0.0,
        lumpsum_payment = 0.0,
        type = TYPE.drop.index,
        status = STATUS.open.index,
        placedOn = DateTime.now().toString();

  Order.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        customerId = map['customerId'],
        total = map['total'],
        lumpsum_payment = map['lumpsum_payment'],
        type = map['type'],
        status = map['status'],
        placedOn = map['placedOn'];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "customerId": customerId,
      "total": total,
      "lumpsum_payment": lumpsum_payment,
      "type": type,
      "status": status,
      "placedOn": placedOn,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }
}

class OrderProvider with ChangeNotifier {
  OrderDB db = OrderDB();
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  void initOrders(String customerId) async {
    _orders = await db.getList(
        sort: 'asc', filter: 'customerId', filterVal: customerId);
    notifyListeners();
  }

  void add(Order order) async {
    Order inserted = await db.insert(order);
    //notifyListeners();
  }

  void pay(Order order) {
    db.delete(order.id);
    //notifyListeners();
  }

  void payTotal(
      {@required int customerId, @required double totalAmount}) async {
    db.closePaymentAndCreateRemaining(
        customerId: customerId, paidAmount: totalAmount);
    notifyListeners();
  }

  static OrderProvider getInstance(
          {BuildContext context, bool listen = true}) =>
      Provider.of<OrderProvider>(context, listen: listen);
}
