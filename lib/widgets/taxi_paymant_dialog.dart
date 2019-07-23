import 'package:flutter/material.dart';
import 'package:taxi/models/customer.p.dart';
import 'package:taxi/models/order.p.dart';
import 'package:taxi/widgets/taxi_button.dart';

class TaxiPaymentDialog extends StatefulWidget {
  Customer customer;
  OrderProvider provider;

  TaxiPaymentDialog({this.customer, this.provider});

  @override
  _TaxiPaymentDialogState createState() => _TaxiPaymentDialogState();
}

class _TaxiPaymentDialogState extends State<TaxiPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  int _type;
  String _message = '';
  Order order = Order.empty();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add Payment for ${widget.customer.name}',
          style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.amber,
      children: <Widget>[
        Container(
          color: Colors.black87,
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
          TextFormField(
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
              order.total = double.parse(val);
            },
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              labelText: 'Payment Amount LBP x 1000',
            ),
          ),
          RadioListTile(
            title: const Text('Drop'),
            value: TYPE.drop.index,
            onChanged: (val) {
              setState(() {
                _type = TYPE.drop.index;
              });

              order.type = val;
            },
            groupValue: _type,
            activeColor: Colors.amber,
          ),
          RadioListTile(
            title: const Text('Delivery'),
            value: TYPE.delivery.index,
            onChanged: (val) {
              setState(() {
                _type = TYPE.delivery.index;
              });
              order.type = val;
            },
            groupValue: _type,
            activeColor: Colors.amber,
          ),
          if (!_message.isEmpty)
            Text(
              _message,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          if (_type == TYPE.delivery.index)
            TextFormField(
              validator: (val) {
                if (val.isEmpty) {
                  return 'Delivery From is required.';
                }
                return null;
              },
              onSaved: (val) {
                order.delivery_note = val;
              },
              decoration: InputDecoration(
                labelText: 'Delivery From',
              ),
            ),
          if (_type == TYPE.drop.index)
            TextFormField(
              validator: (val) {
                if (val.isEmpty) {
                  return 'Drop location is required.';
                }
                return null;
              },
              onSaved: (val) {
                order.drop_note = val;
              },
              decoration: InputDecoration(
                labelText: 'Drop Location',
              ),
            ),
          Divider(),
          Container(
            alignment: Alignment.bottomRight,
            child: TaxiButton(
              icon: Icon(Icons.add_box),
              text: 'Save Payment',
              buttonHandler: () {
                final bool isValid = _formKey.currentState.validate();

                if (!isValid || _type == null) {
                  setState(() {
                    _message = 'Please Select Payment Type';
                  });

                  return null;
                }

                if (isValid) {
                  setState(() {
                    _message = '';
                  });
                  _formKey.currentState.save();
                  order.status = STATUS.open.index;
                  order.customerId = widget.customer.id;
                  order.placedOn = DateTime.now().toString();
                  widget.provider.add(order);
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
