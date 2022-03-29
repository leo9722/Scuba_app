import 'dart:async';
import 'package:scuba/model/dataClasses.dart';
import 'package:scuba/model/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

/*
* Classe : AzoteBrain
* Permet la gestion de l'azote
*
* */

class AzoteBrain {

  //Récupération du dernier ID inséré
  Future<Object?> getLastId() async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM azote ORDER BY ID DESC LIMIT 1');

    if(map.isNotEmpty){
      return map[0]['id'];
    } else {
      return -1;
    }

  }

  //Insertion d'une donnée
  Future<void> insertAzote(Azote azote) async {

    var id = await getLastId() as int;
    //print("Last id : " + id.toString());
    if (id != -1) {
      //print("Increment id");
      azote.id = id + 1;
    }

    final db = await DbHelper().database;

    await db.insert(
      'azote',
      azote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //print("Azote added : " + azote.azote.toString());
  }

  //Mise à jour d'une donnée
  Future<void> updateAzote(Azote azote) async {

    final db = await  DbHelper().database;

    await db.update(
      'azote',
      azote.toMap(),
      where: 'id = ?',

      whereArgs: [azote.id],
    );
  }

  //Liste tous les azotes
  Future<List<Azote>> listAzote() async {

    final db = await  DbHelper().database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * from azote');

    return List.generate(maps.length, (i) {
      return Azote(
          id: maps[i]['id'],
          azote: maps[i]['azote']
      );
    });
  }

  //Liste un azote en fonction d'un ID
  Future<Azote> listAzoteById(int id) async {

    final db = await  DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM azote WHERE id=?', [id]);

    return Azote.fromMap(map[0]);

  }

  //Suppression d'un azote
  Future<void> deleteAzote(int id) async {
    final db = await  DbHelper().database;

    await db.delete(
      'azote',
      where: 'id = ?',

      whereArgs: [id],
    );
  }


}
