import 'package:flutter/material.dart';
import 'package:taxi/models/customer.p.dart';
import 'package:taxi/models/order.p.dart';
import 'package:taxi/screens/order.screen.dart';
import 'package:taxi/widgets/taxi_button.dart';

class TaxiFullPaymentDialog extends StatefulWidget {
  Customer customer;
  OrderProvider provider;

  TaxiFullPaymentDialog({this.customer, this.provider});

  @override
  _TaxiFullPaymentDialogState createState() => _TaxiFullPaymentDialogState();
}

class _TaxiFullPaymentDialogState extends State<TaxiFullPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  double total;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.green,
      title: Text(
        'Full Payment For ${widget.customer.name}',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      children: <Widget>[
        Container(
          color: Colors.lightGreen[50],
          width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: _buildForm(),
        )
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Theme(
            data: ThemeData(
              primaryColor: Colors.green,
            ),
            child: TextFormField(
              validator: (val) {
                if (val.isEmpty) {
                  return 'Enter Payment Amount';
                }

                if (double.tryParse(val) == null) {
                  return 'Enter Payment in Digits Only';
                }
                return null;
              },
              onSaved: (val) {
                setState(() {
                  total = double.parse(val);
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Payment Amount LBP x1000',
              ),
            ),
          ),
          Divider(),
          Container(
            alignment: Alignment.bottomRight,
            child: TaxiButton(
              color: Colors.green,
              icon: Icon(Icons.add_box),
              text: 'Save Payment',
              buttonHandler: () {
                final bool isValid = _formKey.currentState.validate();

                if (isValid) {
                  _formKey.currentState.save();
                  widget.provider.payTotal(
                      customerId: widget.customer.id, totalAmount: total);
                  widget.provider.initOrders(widget.customer.id.toString());
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
