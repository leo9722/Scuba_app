import 'dart:async';
import 'package:scuba/model/dataClasses.dart';
import 'package:sqflite/sqflite.dart';
import 'dbHelper.dart';

/*
* Classe : GroupBrain
* Permet la gestion des groupes
*
* */
class GroupBrain {

  //Récupération du dernier ID
  Future<Object?> getLastId() async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM azote_group ORDER BY ID DESC LIMIT 1');

    if(map.isNotEmpty){
      return map[0]['id'];
    } else {
      return -1;
    }

  }

  //Ajout d'une donnée
  Future<void> insertGroup(Group group) async {

    var id = await getLastId() as int;
    //print("Last id : " + id.toString());
    if (id != -1) {
      //print("Increment id");
      group.id = id + 1;
    }

    final db = await  DbHelper().database;
    await db.insert(
      'azote_group',
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //print("Group added : " + group.azoteGroup.toString());

  }

  Future<List<Group>> listGroup() async {

    final db = await  DbHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('azote_group');
    return List.generate(maps.length, (i) {
      return Group(
        id: maps[i]['id'],
        azoteGroup: maps[i]['azoteGroup'],
      );
    });
  }

  //Liste de groupe par ID
  Future<Group> listGroupById(int id) async {

    final db = await  DbHelper().database;

    final map = await db.rawQuery('SELECT * FROM azote_group WHERE id=?', [id]);

    return Group.fromMap(map[0]);

  }

  //Liste de groupe par groupe
  Future<Group> listGroupByGroup(String group) async {

    final db = await  DbHelper().database;

    final map = await db.rawQuery('SELECT * FROM azote_group WHERE azoteGroup=?', [group]);

    return Group.fromMap(map[0]);

  }

  //Mise à jour d'un groupe
  Future<void> updateGroup(Group group) async {

    final db = await  DbHelper().database;

    await db.update(
      'azote_group',
      group.toMap(),
      where: 'id = ?',

      whereArgs: [group.id],
    );
  }

  //Suppression d'un groupe
  Future<void> deleteGroup(int id) async {

    final db = await  DbHelper().database;
    await db.delete(
      'azote_group',
      where: 'id = ?',

      whereArgs: [id],
    );
  }


}
