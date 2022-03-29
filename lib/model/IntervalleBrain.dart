import 'dart:async';
import 'package:scuba/model/dataClasses.dart';
import 'package:scuba/model/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

/*
* Classe IntervalleBrain
* Gestion des intervalles
* */
class IntervalleBrain {

  //Récupération du dernier ID
  Future<Object?> getLastId() async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM interval ORDER BY ID DESC LIMIT 1');

    if(map.isNotEmpty){
      return map[0]['id'];
    } else {
      return -1;
    }

  }

  //Ajout d'une donnée
  Future<void> insertIntervalle(Intervalle intervalle) async {

    var id = await getLastId() as int;
    //print("Last id : " + id.toString());
    if (id != -1) {
      //print("Increment id");
      intervalle.id = id + 1;
    }

    final db = await DbHelper().database;

    await db.insert(
      'interval',
      intervalle.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //print("Intervalle added : " + intervalle.interval.toString());
  }

  //Liste des intervalles
  Future<List<Intervalle>> listIntervalle() async {

    final db = await  DbHelper().database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * from interval');

    return List.generate(maps.length, (i) {
      return Intervalle(
          id: maps[i]['id'],
          groupId: maps[i]['groupId'],
          coefficient: maps[i]['coefficient'],
          interval: maps[i]['interval']
      );
    });
  }

  //Liste des intervalles pour un groupe
  Future<List<Intervalle>> listIntervalleByGroup(int id) async {

    final db = await  DbHelper().database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * from interval WHERE groupId=?', [id]);

    return List.generate(maps.length, (i) {
      return Intervalle(
          id: maps[i]['id'],
          groupId: maps[i]['groupId'],
          coefficient: maps[i]['coefficient'],
          interval: maps[i]['interval']
      );
    });
  }

  //Récupération d'un intervalle en fonction d'un ID
  Future<Intervalle> listIntervalleById(int id) async {

    final db = await  DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM interval WHERE id=?', [id]);

    return Intervalle.fromMap(map[0]);

  }

  //Récupération d'un intervalle en fonction d'un groupe et d'un temps
  Future<Intervalle> listIntervalleByGroupAndTime(int groupId, int time) async {

    final db = await  DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM interval WHERE groupId=? AND interval=?', [groupId, time]);

    return Intervalle.fromMap(map[0]);

  }

  //Suppression d'un intervalle
  Future<void> deleteIntervalle(int id) async {
    final db = await  DbHelper().database;

    await db.delete(
      'interval',
      where: 'id = ?',

      whereArgs: [id],
    );
  }

  //Mise à jour d'un intervalle
  Future<void> updateIntervalle(Intervalle intervalle) async {

    final db = await DbHelper().database;
    await db.update(
      'interval',
      intervalle.toMap(),
      where: 'id = ?',

      whereArgs: [intervalle.id],
    );
  }

}
