import 'dart:async';
import 'package:scuba/model/dataClasses.dart';
import 'package:sqflite/sqflite.dart';
import 'dbHelper.dart';

/*
* Classe : TimeBrain
* Permet la gestion du temps
* */

class TimeBrain {

  //Récupération du dernier ID
  Future<Object?> getLastId() async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM time ORDER BY ID DESC LIMIT 1');

    if(map.isNotEmpty){
      return map[0]['id'];
    } else {
      return -1;
    }

  }

  //Insertion d'une donnée
  Future<void> insertTime(Time time) async {

    var id = await getLastId() as int;
    //print("Last id : " + id.toString());
    if (id != -1) {
      //print("Increment id");
      time.id = id + 1;
    }

    final db = await  DbHelper().database;
    await db.insert(
      'time',
      time.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //print("Time added : " + time.time.toString());

  }

  //Liste des temps
  Future<List<Time>> listTime() async {

    final db = await  DbHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('time');

    return List.generate(maps.length, (i) {
      return Time(
        id: maps[i]['id'],
        p3: maps[i]['p3'],
        p6: maps[i]['p6'],
        p9: maps[i]['p9'],
        p12: maps[i]['p12'],
        p15: maps[i]['p15'],
        time: maps[i]['time'],
        deepId: maps[i]['deepId'],
        azoteGroup: maps[i]['azoteGroup'],
      );
    });
  }

  //Liste des temps par ID
  Future<Time> listTimeById(int id) async {

    final db = await  DbHelper().database;

    final map = await db.rawQuery('SELECT * FROM time WHERE id=?', [id]);

    return Time.fromMap(map[0]);

  }

  //Liste des temps par profondeur
  Future<List<Time>> listTimeByDeep(int id) async {
    final db = await DbHelper().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM time WHERE deepId=?', [id]);

    return List.generate(maps.length, (i) {
      return Time(
          id: maps[i]['id'],
          p3: maps[i]['p3'],
          p6: maps[i]['p6'],
          p9: maps[i]['p9'],
          p12: maps[i]['p12'],
          p15: maps[i]['p15'],
          time: maps[i]['time'],
          deepId: maps[i]['deepId'],
          azoteGroup: maps[i]['azoteGroup'],
      );
    });
  }

  //Mise à jour
  Future<void> updateTime(Time time) async {

    final db = await  DbHelper().database;

    await db.update(
      'time',
      time.toMap(),
      where: 'id = ?',

      whereArgs: [time.id],
    );
  }

  //Suppression
  Future<void> deleteTime(int id) async {

    final db = await  DbHelper().database;
    await db.delete(
      'time',
      where: 'id = ?',

      whereArgs: [id],
    );
  }

}
