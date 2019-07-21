import 'package:sqflite/sqlite_api.dart';
import 'package:taxi/db/db.dart';

abstract class Base<T> {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;

    _db = await getDb();
    return _db;
  }

  Future<Database> getDb() async {
    return await Db.open();
  }

  void closeDb() async => await _db.close();

  Future<T> insert(T model);

  Future<T> update(T model);

  void delete(int id);

  Future<T> getById(int id);

  Future<List<T>> getList(
      {String sort = 'asc', String filter, dynamic filterVal});
}
