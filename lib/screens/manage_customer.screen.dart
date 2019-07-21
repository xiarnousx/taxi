import 'package:flutter/material.dart';
import 'package:taxi/models/customer.p.dart';
import 'package:taxi/screens/home.screen.dart';
import 'package:taxi/widgets/taxi_app_bar.dart';
import 'package:taxi/widgets/taxi_button.dart';
import 'package:taxi/widgets/taxi_customer_form.dart';

class ManageCustommerScreen extends StatelessWidget {
  static const String path = '/manage-customer';

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context).settings.arguments as int;

    CustomerProvider provider =
        CustomerProvider.getInstance(context: context, listen: false);

    return FutureBuilder(
      future: CustomerProvider.getInstance(context: context, listen: false)
          .getById(id: id),
      builder: (_, AsyncSnapshot<Customer> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        var customer = snapshot.data;

        return Scaffold(
          appBar: TaxiAppBar(
            headerText: customer.id == null
                ? 'Add New Customer'
                : 'Change Customer Name',
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: TaxiCustomerForm(
              customer: customer,
              provider: provider,
            ),
          ),
        );
      },
    );
  }
}
