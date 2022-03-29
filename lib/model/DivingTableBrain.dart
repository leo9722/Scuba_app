import 'dart:async';
import 'package:scuba/model/dataClasses.dart';
import 'package:sqflite/sqflite.dart';

import 'dbHelper.dart';

/*
* Classe : DivingTableBrain
* Permet la gestion des tables
*
* */

class DivingTableBrain {

  //Récupération du dernier ID
  Future<Object?> getLastId() async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM diving_table ORDER BY ID DESC LIMIT 1');

    if(map.isNotEmpty){
      return map[0]['id'];
    } else {
      return -1;
    }

  }

  //Ajout d'une donnée
  Future<void> insertDivingTable(DivingTable divingTable) async {

    var id = await getLastId() as int;
    //print("Last id : " + id.toString());
    if (id != -1) {
      //print("Increment id");
      divingTable.id = id + 1;
    }

    //print("Diving table added : " + divingTable.toMap().toString());

    final db = await DbHelper().database;

    await db.insert(
      'diving_table',
      divingTable.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  //Liste des tables
  Future<List<DivingTable>> listDivingTable() async {

    final db = await DbHelper().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM diving_table ORDER BY ID');

    return List.generate(maps.length, (i) {
      return DivingTable(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  //Liste d'une table en fonction d'un id
  Future<DivingTable> listDivingTableById(int id) async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM diving_table WHERE id=?', [id]);

    return DivingTable.fromMap(map[0]);

  }

  //Liste d'une table en fonction d'un nom
  Future<DivingTable> listDivingTableByName(String name) async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM diving_table WHERE name=?', [name]);

    return DivingTable.fromMap(map[0]);

  }

  //Mise à jour d'une table
  Future<void> updateDivingTable(DivingTable divingTable) async {

    final db = await DbHelper().database;
    await db.update(
      'diving_table',
      divingTable.toMap(),
      where: 'id = ?',

      whereArgs: [divingTable.id],
    );
  }

  //Suppression d'une table
  Future<void> deleteDivingTable(int id) async {

    final db = await DbHelper().database;
    await db.delete(
      'diving_table',
      where: 'id = ?',

      whereArgs: [id],
    );
  }

}
