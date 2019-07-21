import 'package:taxi/db/base.dart';
import 'package:taxi/models/customer.p.dart';
import 'package:taxi/models/order.p.dart';

class CustomerDB extends Base<Customer> {
  Future<Customer> insert(Customer customer) async {
    var dbClient = await db;

    customer.id = await dbClient.insert(Customer.table, customer.toMap());
    return customer;
  }

  Future<Customer> update(Customer customer) async {
    var dbClient = await db;
    final int res = await dbClient.update(Customer.table, customer.toMap(),
        where: 'id = ?', whereArgs: [customer.id]);
    return customer;
  }

  Future<Customer> getById(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(Customer.table, columns: null, where: 'id = ?', whereArgs: [id]);
    if (maps.length <= 0) {
      return null;
    }
    return Customer.fromMap(maps.first);
  }

  Future<List<Customer>> getList(
      {String sort = 'asc', String filter, dynamic filterVal}) async {
    var dbClient = await db;

    List<Map> list = await dbClient.rawQuery(
        'SELECT *, (SELECT SUM(total) FROM orders where status != ${STATUS.closed.index} and orders.customerId = customers.id) as amountDue FROM customers order by name $sort');
    List<Customer> customers = [];

    list.forEach((item) {
      customers.add(Customer.fromMap(item));
    });

    return customers;
  }

  Future<List<Customer>> search(String search) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * , (SELECT SUM(total) FROM orders where status != ${STATUS.closed.index} and orders.customerId = customers.id) as amountDue FROM customers where name like "%$search%"');
    List<Customer> customers = [];

    list.forEach((item) => customers.add(Customer.fromMap(item)));

    return customers;
  }

  @override
  void delete(int id) {
    // TODO: implement delete
  }
}
