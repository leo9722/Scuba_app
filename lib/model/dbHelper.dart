import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


//Classe permettant la récupération de la base de données
//pour effectuer des opérations
class DbHelper {

  // ignore: prefer_typing_uninitialized_variables
  var _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();

    return _database;
  }

  initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'scuba_database.db'),
    );

    return database;
  }

  Future close() async {
    var dbClient = await database;
    return dbClient.close();
  }
}