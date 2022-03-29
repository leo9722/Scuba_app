import 'dart:async';
import 'package:scuba/model/dataClasses.dart';
import 'package:sqflite/sqflite.dart';

import 'dbHelper.dart';

/*
* Classe : DeepBrain
* Permet la gestion des profondeurs
*
* */
class DeepBrain {

  //Récupération du dernier ID inséré
  Future<Object?> getLastId() async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM deep ORDER BY ID DESC LIMIT 1');

    if(map.isNotEmpty){
      return map[0]['id'];
    } else {
      return -1;
    }

  }

  //Insertion d'une donnée
  Future<void> insertDeep(Deep deep) async {

    var id = await getLastId() as int;
    //print("Last id : " + id.toString());
    if (id != -1) {
      //print("Increment id");
      deep.id = id + 1;
    }


    final db = await DbHelper().database;

    await db.insert(
      'deep',
      deep.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //print("Deep added : " + deep.deep.toString());

  }

  //Liste les profondeurs
  Future<List<Deep>> listDeep() async {

    final db = await  DbHelper().database;

    final List<Map<String, dynamic>> maps = await db.query('deep');

    return List.generate(maps.length, (i) {
      return Deep(
        divingTableId: maps[i]['divingTableId'],
        deep: maps[i]['deep'],
        id: maps[i]['id'],
      );
    });

  }

  //Liste des profondeurs en fonction d'une table
  Future<List<Deep>> listDeepByTable(int id) async {

    final db = await  DbHelper().database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM deep WHERE divingTableId=?', [id]);

    return List.generate(maps.length, (i) {
      return Deep(
        divingTableId: maps[i]['divingTableId'],
        deep: maps[i]['deep'],
        id: maps[i]['id'],
      );
    });

  }

  //Liste des profondeurs en fonction d'un id
  Future<Deep> listDeepById(int id) async {

    final db = await  DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM deep WHERE id=?', [id]);

    return Deep.fromMap(map[0]);

  }

  //Mise à jour d'une donnée
  Future<void> updateDeep(Deep deep) async {

    final db = await  DbHelper().database;

    await db.update(
      'deep',
      deep.toMap(),
      where: 'id = ?',

      whereArgs: [deep.id],
    );
  }

  //Suppression d'une profondeur
  Future<void> deleteDeep(int id) async {

    final db = await  DbHelper().database;
    await db.delete(
      'deep',
      where: 'id = ?',

      whereArgs: [id],
    );
  }

}
