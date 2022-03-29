import 'dart:async';
import 'package:scuba/model/dataClasses.dart';
import 'package:sqflite/sqflite.dart';

import 'dbHelper.dart';

/*
* Classe : DivingBrain
* Permet la gestion des plongées
*
* */

class DivingBrain {

  //Récupération du dernier ID inséré
  Future<Object?> getLastId() async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM diving ORDER BY ID DESC LIMIT 1');

    if(map.isNotEmpty){
      return map[0]['id'];
    } else {
      return -1;
    }

  }

  //Insertion d'une donnée
  Future<void> insertDiving(Diving diving) async {

    var id = await getLastId() as int;
    //print("Last id : " + id.toString());
    if (id != -1) {
      //print("Increment id");
      diving.id = id + 1;
    }


    final db = await  DbHelper().database;
    await db.insert(
      'diving',
      diving.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //print("Diving added : " + diving.divingTime.toString());

  }

  //Liste des plongées
  Future<List<Diving>> listDiving() async {

    final db = await  DbHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('diving');

    return List.generate(maps.length, (i) {
      return Diving(
        id: maps[i]['id'],
        divingTime: maps[i]['divingTime'],
        deepId: maps[i]['deepId'],
        divingDate: maps[i]['divingDate'],
        downTime: maps[i]['downTime'],
        profileId: maps[i]['profileId'],
        upTime: maps[i]['upTime'],
      );
    });
  }

  //Liste des plongées par profil
  Future<List<Diving>> listDivingByProfile(int id) async {

    final db = await  DbHelper().database;
    final List<Map<String, dynamic>> maps =  await db.rawQuery('SELECT * FROM diving WHERE profileId=?', [id]);

    return List.generate(maps.length, (i) {
      return Diving(
        id: maps[i]['id'],
        divingTime: maps[i]['divingTime'],
        deepId: maps[i]['deepId'],
        divingDate: maps[i]['divingDate'],
        downTime: maps[i]['downTime'],
        profileId: maps[i]['profileId'],
        upTime: maps[i]['upTime'],
      );
    });
  }

  //Liste une plongée en fonction d'un id
  Future<Diving> listDivingById(int id) async {

    final db = await  DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM diving WHERE id=?', [id]);

    return Diving.fromMap(map[0]);

  }

  //Mise à jour d'une donnée
  Future<void> updateDiving(Diving diving) async {

    final db = await  DbHelper().database;

    await db.update(
      'diving',
      diving.toMap(),
      where: 'id = ?',

      whereArgs: [diving.id],
    );
  }

  //Suppression d'une donnée
  Future<void> deleteDiving(int id) async {

    final db = await  DbHelper().database;
    await db.delete(
      'diving',
      where: 'id = ?',

      whereArgs: [id],
    );
  }

}
