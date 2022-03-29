import 'dart:async';
import 'package:scuba/model/dataClasses.dart';
import 'package:sqflite/sqflite.dart';
import 'dbHelper.dart';

/*
* Classe : LevelBrain
* Permet la gestion des niveaux
* */
class LevelBrain {

  //Récupération du dernier ID
  Future<Object?> getLastId() async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM level ORDER BY ID DESC LIMIT 1');

    if(map.isNotEmpty){
      return map[0]['id'];
    } else {
      return -1;
    }

  }

  //Insertion
  Future<void> insertLevel(Level level) async {

    var id = await getLastId() as int;
    //print("Last id lvl : " + id.toString());
    if (id != -1) {
      //print("Increment id");
      level.id = id + 1;
    }

    final db = await DbHelper().database;

    await db.insert(
      'level',
      level.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //print("Level added : " + level.level.toString());

  }

  //Liste les niveaux
  Future<List<Level>> listLevel() async {

    final db = await  DbHelper().database;

    final List<Map<String, dynamic>> maps = await db.query('level');

    return List.generate(maps.length, (i) {
      return Level(
        id: maps[i]['id'],
        level: maps[i]['level'],
      );
    });

  }

  //Liste de niveaux en fonction d'un ID
  Future<Level> listLevelById(int id) async {

    final db = await  DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM level WHERE id=?', [id]);

    return Level.fromMap(map[0]);

  }

  //Mise çà jour d'un niveau
  Future<void> updateLevel(Level level) async {

    final db = await  DbHelper().database;

    await db.update(
      'level',
      level.toMap(),
      where: 'id = ?',

      whereArgs: [level.id],
    );
  }

  //Suppression d'un niveau
  Future<void> deleteLevel(int id) async {

    final db = await  DbHelper().database;
    await db.delete(
      'level',
      where: 'id = ?',

      whereArgs: [id],
    );
  }

}
