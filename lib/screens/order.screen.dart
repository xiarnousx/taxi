import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taxi/helpers.dart/taxi_border_bottom.dart';
import 'package:taxi/models/customer.p.dart';
import 'package:taxi/models/order.p.dart';
import 'package:taxi/widgets/taxi_app_bar.dart';
import 'package:taxi/widgets/taxi_drawer.dart';
import 'package:taxi/widgets/taxi_full_paymant_dialog..dart';
import 'dart:async';

import 'package:taxi/widgets/taxi_paymant_dialog.dart';

class OrderScreen extends StatelessWidget {
  int _customerId;
  Customer _customer = Customer.empty();

  static const String path = '/customer-orders';

  @override
  Widget build(BuildContext context) {
    OrderProvider provider = OrderProvider.getInstance(context: context);
    Future.delayed(Duration.zero, () async {
      _customerId = ModalRoute.of(context).settings.arguments;
      _customer =
          await CustomerProvider.getInstance(context: context, listen: false)
              .getById(id: _customerId);

      provider.initOrders(_customer.id.toString());
    });

    return Scaffold(
      appBar: TaxiAppBar(
        headerText: '${_customer.name}',
        actions: <Widget>[
          if (provider.orders.length > 0)
            IconButton(
              icon: Icon(
                Icons.payment,
                size: 35,
              ),
              color: Colors.greenAccent,
              tooltip: 'Pay Them All',
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) {
                    return TaxiFullPaymentDialog(
                      provider: provider,
                      customer: _customer,
                    );
                  }),
            ),
          IconButton(
            icon: Icon(
              Icons.add_box,
              size: 35,
            ),
            color: Colors.amber,
            tooltip: 'Add Payment',
            onPressed: () => showDialog(
              context: context,
              builder: (__) => TaxiPaymentDialog(
                customer: _customer,
                provider: provider,
              ),
            ),
          ),
        ],
      ),
      // drawer: TaxiDrawer(),
      body: _buildListView(provider),
    );
  }

  Widget _buildListView(OrderProvider provider) {
    try {
      return ListView.builder(
        itemCount: provider.orders.length,
        itemBuilder: (_, int index) {
          Order order = provider.orders[index];
          return Dismissible(
            movementDuration: const Duration(microseconds: 800),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                provider.pay(order);
                provider.orders.removeAt(index);
              }
              return true;
            },
            key: Key("order_${order.id}"),
            background: Container(
              color: Colors.amber,
              child: Container(
                child: Icon(
                  Icons.payment,
                  size: 60,
                  color: Colors.black45,
                ),
                alignment: Alignment.centerRight,
              ),
            ),
            child: Container(
              decoration: TaxiBorderBottom.get(color: Colors.amber[100]),
              margin: EdgeInsets.zero,
              child: Container(
                color: Colors.black54,
                child: ListTile(
                  subtitle: _getSubTitle(order),
                  leading: Text(
                    'x1000',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11.0,
                    ),
                  ),
                  title: _getOrderType(order.type),
                  trailing: Chip(
                    backgroundColor: Colors.amber,
                    label: Text(
                      "LBP ${order.total}",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } catch (exception, stackTrace) {
      print(exception.toString());
    }
  }

  Widget _getOrderType(int type) {
    if (TYPE.remaining.index == type) {
      return Text('REMAINING');
    }

    if (TYPE.delivery.index == type) {
      return Text('DELIVERY');
    }

    return Text('DROP');
  }

  Widget _getSubTitle(Order order) {
    if (order.type != TYPE.remaining.index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'Placed On: ${DateFormat.yMMMMEEEEd().format(DateTime.parse(order.placedOn))}'),
          Text(
              TYPE.drop.index == order.type
                  ? 'Drop off @ ${order.drop_note}'
                  : 'Delivery from ${order.delivery_note}',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              )),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'Placed On: ${DateFormat.yMMMMEEEEd().format(DateTime.parse(order.placedOn))}'),
        Text('Amount Paid LBP ${order.lumpsum_payment}',
            style: TextStyle(
              color: Colors.amber[50],
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }
}
