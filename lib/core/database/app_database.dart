import 'package:controle_tarefas/core/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Future<Database> db() async {
    Database database = await openDatabase('app_demarco_db', version: 1,
        onCreate: (Database db, int version) async {
      await createTables(db);
    });
    return database;
  }

  static createTables(Database db) {
    createTodoTable(db);
  }

  static Future<void> createTodoTable(Database database) async {
    await Future.wait([
      database.execute("""CREATE TABLE user(
        uid TEXT PRIMARY KEY,
        email TEXT
        )
      """),
    ]);
  }

  Future<UserModel> getUser() async {
    final db = await AppDatabase.db();
    final user = await db.query('user');
    return UserModel.fromMap(user.first);
  }

  Future<bool> insertUser(UserModel user) async {
    final db = await AppDatabase.db();
    int qtd = await db.insert('user', user.toMap());
    return qtd >= 1 ? true : false;
  }

  Future<void> deleteUser() async {
    final db = await AppDatabase.db();
    await db.delete('user');
  }
}
