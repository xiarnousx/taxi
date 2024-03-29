import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';

class Db {
  static Future<Database> open() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    return openDatabase(
      join(appDocPath, 'taxi_database_v7.db'),
      onCreate: (db, version) {
        String customersTable = """
        CREATE TABLE IF NOT EXISTS customers(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT
        );
        """;

        String ordersTable = """
        CREATE TABLE IF NOT EXISTS orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerId INTEGER,
            total DOUBLE,
            lumpsum_payment DOUBLE default 0,
            type INTEGER,
            status INTEGER,
            placedOn DateTime
          );
        """;

        String addDropOffNote = """
        ALTER TABLE orders ADD drop_note TEXT default null;
        """;

        String addDeliveryNote = """
        Alter TABLE orders ADD delivery_note TEXT default null;
        """;

        db.execute(customersTable);
        db.execute(ordersTable);
        db.execute(addDropOffNote);
        db.execute(addDeliveryNote);
      },
      version: 1,
    );
  }
}
