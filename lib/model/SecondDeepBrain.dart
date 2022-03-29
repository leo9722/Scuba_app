import 'dart:async';
import 'package:scuba/model/dataClasses.dart';
import 'package:scuba/model/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

/*
* Classe : SecondDeepBrain
* Permet la gestion des profondeurs de plongée successive
*
* */
class SecondDeepBrain {

  //Récupération du dernier ID
  Future<Object?> getLastId() async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM deep_second ORDER BY ID DESC LIMIT 1');

    if(map.isNotEmpty){
      return map[0]['id'];
    } else {
      return -1;
    }

  }

  //Ajout d'une donnée
  Future<void> insertSecondDeep(SecondDeep secondDeep) async {

    var id = await getLastId() as int;
    //print("Last id : " + id.toString());
    if (id != -1) {
      //print("Increment id");
      secondDeep.id = id + 1;
    }

    final db = await DbHelper().database;

    await db.insert(
      'deep_second',
      secondDeep.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //print("SecondDeep added : " + secondDeep.deep.toString());
  }

  //Liste des profondeurs
  Future<List<SecondDeep>> listSecondDeep() async {

    final db = await  DbHelper().database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * from deep_second');

    return List.generate(maps.length, (i) {
      return SecondDeep(
        id: maps[i]['id'],
        deep: maps[i]['deep'],
        time: maps[i]['time'],
        azoteId: maps[i]['azoteId']
      );
    });
  }

  //Liste profondeur par ID
  Future<SecondDeep> listSecondDeepById(int id) async {

    final db = await  DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM deep_second WHERE id=?', [id]);

    return SecondDeep.fromMap(map[0]);

  }

  //Liste profondeur par azote et profondeur
  Future<SecondDeep> listSecondDeepByAzoteAndDeep(int id, int deep) async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM deep_second WHERE deep=? AND azoteId=?', [deep,id]);
    print("Second Deep : " + map.toString());
    return SecondDeep.fromMap(map[0]);

  }

  //Liste profondeurs par azote
  Future<List<SecondDeep>> listSecondDeepByAzote(int id) async {

    final db = await DbHelper().database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * from deep_second WHERE azoteId=?', [id]);

    return List.generate(maps.length, (i) {
      return SecondDeep(
          id: maps[i]['id'],
          deep: maps[i]['deep'],
          time: maps[i]['time'],
          azoteId: maps[i]['azoteId']
      );
    });
  }

  //Suppression donnée
  Future<void> deleteSecondDeep(int id) async {
    final db = await DbHelper().database;

    await db.delete(
      'deep_second',
      where: 'id = ?',

      whereArgs: [id],
    );
  }

  //Mise à jour
  Future<void> updateSecondDeep(SecondDeep secondDeep) async {

    final db = await DbHelper().database;
    await db.update(
      'deep_second',
      secondDeep.toMap(),
      where: 'id = ?',

      whereArgs: [secondDeep.id],
    );
  }

}
