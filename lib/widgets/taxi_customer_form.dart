import 'package:flutter/material.dart';
import 'package:taxi/models/customer.p.dart';
import 'package:taxi/screens/home.screen.dart';
import 'package:taxi/widgets/taxi_button.dart';

class TaxiCustomerForm extends StatefulWidget {
  Customer customer;
  CustomerProvider provider;
  TaxiCustomerForm({this.provider, this.customer});
  @override
  _TaxiCustomerFormState createState() => _TaxiCustomerFormState();
}

class _TaxiCustomerFormState extends State<TaxiCustomerForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Customer Name',
              icon: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Icon(Icons.group_add),
              ),
            ),
            initialValue:
                widget.customer.id == null ? '' : widget.customer.name,
            validator: (val) {
              if (val.isEmpty) {
                return 'Please Enter Customer Name.';
              }
              return null;
            },
            onSaved: (val) {
              widget.customer.setName(val);
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            width: double.infinity,
            child: TaxiButton(
              text: widget.customer.id == null
                  ? 'Save Customer'
                  : 'Update Customer',
              icon: Icon(Icons.person),
              buttonHandler: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  if (widget.customer.id == null) {
                    widget.provider.add(widget.customer);
                  } else {
                    widget.provider.update(widget.customer);
                  }

                  Navigator.of(context).pushNamed(HomeScreen.path);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
