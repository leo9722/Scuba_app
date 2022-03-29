import 'dart:async';
import 'package:scuba/model/dataClasses.dart';
import 'package:scuba/model/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

/*
* Classe : ProfileBrain
* Permet la gestion des profiles
* */
class ProfileBrain {

  //Récupération du dernier ID
  Future<Object?> getLastId() async {

    final db = await DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM profile ORDER BY ID DESC LIMIT 1');

    if(map.isNotEmpty){
      return map[0]['id'];
    } else {
      return -1;
    }

  }

  //Ajout d'une donnée
  Future<void> insertProfile(Profile profile) async {

    var id = await getLastId() as int;
    //print("Last profile id : " + id.toString());
    if (id != -1) {
      //print("Increment id");
      profile.id = id + 1;
    }

    final db = await DbHelper().database;

    await db.insert(
      'profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //print("Profile added : " + profile.name);
  }

  //Liste des profiles
  Future<List<Profile>> listProfile() async {

    final db = await  DbHelper().database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * from profile ORDER BY selected DESC');

    return List.generate(maps.length, (i) {
      return Profile(
        id: maps[i]['id'],
        speed: maps[i]['speed'],
        consommation: maps[i]['consommation'],
        nbBottle: maps[i]['nbBottle'],
        name: maps[i]['name'],
        vRep: maps[i]['vRep'],
        vRap: maps[i]['vRap'],
        volume: maps[i]['volume'],
        pressure: maps[i]['pressure'],
        detendor: maps[i]['detendor'],
        selected: maps[i]['selected'],
        levelId: maps[i]['levelId'],
      );
    });
  }

  //Liste de profil par id
  Future<Profile> listProfileById(int id) async {

    final db = await  DbHelper().database;
    final map = await db.rawQuery('SELECT * FROM profile WHERE id=?', [id]);

    return Profile.fromMap(map[0]);

  }

  //Récupération profil sélectionné
  Future<Profile> getSelectedProfile() async {

    final db = await DbHelper().database;

    final map = await db.rawQuery('SELECT * FROM profile WHERE selected = 1');

    return Profile.fromMap(map[0]);

  }

  //Récupération profile au hasard
  Future<Profile> getRandomProfile() async {
    final db = await  DbHelper().database;

    final map = await db.rawQuery('SELECT * FROM profile LIMIT 1');

    return Profile.fromMap(map[0]);
  }

  //Mise à jour profil
  Future<void> updateProfile(Profile profile) async {

    final db = await  DbHelper().database;

    await db.update(
      'profile',
      profile.toMap(),
      where: 'id = ?',

      whereArgs: [profile.id],
    );

    print("Updated : " + profile.name + " | " + profile.selected.toString());

  }

  //Suppression profil
  Future<void> deleteProfile(int id) async {
    final db = await  DbHelper().database;

    await db.delete(
      'profile',
      where: 'id = ?',

      whereArgs: [id],
    );
  }

}
