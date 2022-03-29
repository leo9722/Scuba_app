import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:scuba/model/AzoteBrain.dart';
import 'package:scuba/model/DeepBrain.dart';
import 'package:scuba/model/DivingTableBrain.dart';
import 'package:scuba/model/IntervalleBrain.dart';
import 'package:scuba/model/LevelBrain.dart';
import 'package:scuba/model/ProfileBrain.dart';
import 'package:scuba/model/SecondDeepBrain.dart';
import 'package:scuba/model/TimeBrain.dart';
import 'package:scuba/model/data.dart';
import 'package:scuba/model/dbHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'GroupBrain.dart';

/*
* Définition de toutes les classes de données
* ainsi que de la classe de gestion d'initialisation
* de la base de données
* */

//Classe table de plongée
class DivingTable {
  int id = 0;
  String name = "0";

  DivingTable({required this.name, this.id = 0});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  DivingTable.fromMap(Map<Object, dynamic> map) {
    name = map['name'];
    id = map['id'];
  }
}

//Classe azote
class Azote {
  int id = 0;
  double azote = 0;

  Azote({required this.azote, this.id = 0});

  Map<String, dynamic> toMap() {
    return {
      'azote': azote,
      'id': id,
    };
  }

  Azote.fromMap(Map<Object, dynamic> map) {
    azote = map['azote'];
    id = map['id'];
  }
}

//Classe seconde profondeur
class SecondDeep {
  int id = 0;
  int deep = 0;
  int time = 0;
  int azoteId = 0;

  SecondDeep(
      {required this.deep,
      required this.time,
      required this.azoteId,
      this.id = 0});

  Map<String, dynamic> toMap() {
    return {
      'deep': deep,
      'time': time,
      'azoteId': azoteId,
      'id': id,
    };
  }

  SecondDeep.fromMap(Map<Object, dynamic> map) {
    deep = map['deep'];
    time = map['time'];
    azoteId = map['azoteId'];
    id = map['id'];
  }
}

//Classe intervalle
class Intervalle {
  int id = 0;
  int interval = 0;
  double coefficient = 0;
  int groupId = 0;

  Intervalle({
    required this.interval,
    required this.coefficient,
    required this.groupId,
    this.id = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'interval': interval,
      'coefficient': coefficient,
      'groupId': groupId,
    };
  }

  Intervalle.fromMap(Map<Object, dynamic> map) {
    id = map['id'];
    interval = map['interval'];
    coefficient = map['coefficient'];
    groupId = map['groupId'];
  }
}

//Classe groupe
class Group {
  int id = 0;
  String azoteGroup = "0";

  Group({required this.azoteGroup, this.id = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'azoteGroup': azoteGroup,
    };
  }

  Group.fromMap(Map<Object, dynamic> map) {
    id = map['id'];
    azoteGroup = map['azoteGroup'];
  }
}

//Classe temps
class Time {
  int id = 0;
  int time = 0;

  int p15 = 0;
  int p12 = 0;
  int p9 = 0;
  int p6 = 0;
  int p3 = 0;

  String azoteGroup = "A";

  int deepId = 0;

  Time({
    this.id = 0,
    required this.time,
    required this.p15,
    required this.p12,
    required this.p9,
    required this.p6,
    required this.p3,
    required this.azoteGroup,
    required this.deepId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'p15': p15,
      'p12': p12,
      'p9': p9,
      'p6': p6,
      'p3': p3,
      'azoteGroup': azoteGroup,
      'deepId': deepId,
    };
  }

  Time.fromMap(Map<Object, dynamic> map) {
    id = map['id'];
    time = map['time'];
    p15 = map['p15'];
    p12 = map['p12'];
    p9 = map['p9'];
    p6 = map['p6'];
    p3 = map['p3'];
    azoteGroup = map['azoteGroup'];
    deepId = map['deepId'];
  }
}

//Classe profondeur
class Deep {

  int id = 0;
  int deep = 0;
  int divingTableId = 0;

  Deep({
    required this.deep,
    required this.divingTableId,
    this.id = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deep': deep,
      'divingTableId': divingTableId,
    };
  }

  Deep.fromMap(Map<Object, dynamic> map) {
    id = map['id'];
    deep = map['deep'];
    divingTableId = map['divingTableId'];
  }
}

//Classe plongée
class Diving {

  String divingDate = "";
  double divingTime = 0;
  double upTime = 0;
  double downTime = 0;

  int deepId = 0;
  int id = 0;
  int profileId = 0;

  Diving({

    this.id = 0,
    required this.divingDate,
    required this.divingTime,
    required this.downTime,
    required this.upTime,
    required this.profileId,
    required this.deepId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'divingDate': divingDate,
      'divingTime': divingTime,
      'downTime': downTime,
      'upTime': upTime,
      'profileId': profileId,
      'deepId': deepId
    };
  }

  Diving.fromMap(Map<Object, dynamic> map) {
    id = map['id'];
    divingDate = map['divingDate'];
    divingTime = map['divingTime'];
    downTime = map['downTime'];
    upTime = map['upTime'];
    profileId = map['profileId'];
    deepId = map['deepId'];
  }
}

//Classe profile
class Profile {
  int id = 0;
  int speed = 0;
  int consommation = 0;
  int nbBottle = 0;
  String name = "0";
  int vRap = 0;
  int vRep = 0;
  int volume = 0;
  int pressure = 0;
  int detendor = 0;
  int selected = 0;
  int levelId = 0;

  Profile({

    this.id = 0,
    required this.speed,
    required this.consommation,
    required this.nbBottle,
    required this.name,
    required this.vRap,
    required this.vRep,
    required this.volume,
    required this.pressure,
    required this.detendor,
    required this.selected,
    required this.levelId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'speed': speed,
      'consommation': consommation,
      'nbBottle': nbBottle,
      'name': name,
      'vRap': vRap,
      'vRep': vRep,
      'volume': volume,
      'pressure': pressure,
      'detendor': detendor,
      'selected': selected,
      'levelId': levelId,
    };
  }

  Profile.fromMap(Map<Object, dynamic> map) {
    id = map['id'];
    speed = map['speed'];
    consommation = map['consommation'];
    nbBottle = map['nbBottle'];
    name = map['name'];
    vRap = map['vRap'];
    vRep = map['vRep'];
    volume = map['volume'];
    pressure = map['pressure'];
    detendor = map['detendor'];
    selected = map['selected'];
    levelId = map['levelId'];
  }
}

//Class information de plongée
class DivingInfo {

  int currentDeep;
  double volumeLeft;
  double pressureLeft;
  double volumeConso;
  double pressureConso;
  double time;
  double totalTime;
  bool breath;

  DivingInfo({
    required this.currentDeep,
    required this.volumeLeft,
    required this.volumeConso,
    required this.pressureLeft,
    required this.pressureConso,
    required this.time,
    required this.totalTime,
    required this.breath,
  });


  Map<String, dynamic> toMap() {
    return {
      'deep': currentDeep,
      'volumeLeft': volumeLeft,
      'volumeConso': volumeConso,
      'pressureLeft': pressureLeft,
      'pressureConso': pressureConso,
      'time': time,
      'totalTime': totalTime,
      'breath': breath
    };
  }

}

//Classe résultat de calculs
class DivingResults {

  List<DivingInfo> infoPaliers = [];
  List<DivingInfo> infoDiving = [];

  double initPressure = 0;
  double initVolume = 0;

  double finalPressure = 0;
  double finalVolume = 0;

  double totalTime = 0;

  DivingResults({
    required this.infoDiving,
    required this.infoPaliers,
    required this.initPressure,
    required this.totalTime,
    required this.finalPressure,
    required this.finalVolume,
    required this.initVolume,
  });

}

//Classe liant profondeur et temps
class DeepTime {

  Deep deep;
  List<Time> times;

  DeepTime({
    required this.deep,
    required this.times,
  });
}

//Classe niveau
class Level {

  String level = '1';
  int id = 0;

  Level({
    this.id = 0,
    required this.level,
});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level':level
    };
  }

  Level.fromMap(Map<Object, dynamic> map) {
    id = map['id'];
    level = map['level'];
  }

}

//Classe objet de plongée pour vérification
//lors de la simulation
class CheckObject {

  String desc = "";
  String short = "";
  bool checked = false;

  double userValue = 0;
  double realValue = 0;

  CheckObject({
    required this.desc,
    required this.checked,
    required this.short,
    required this.userValue,
    required this.realValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'desc': desc,
      'checked': checked,
      'short': short,
      'userValue': userValue,
      'realValue': realValue,
    };
  }

}

//Gestion de la base de données
class DbBrain {

  //Initialisation de la base de données
  Future<void> init() async {

    //print("INITIALISATION");

    WidgetsFlutterBinding.ensureInitialized();

    Future<bool> databaseExists(String path) => databaseFactory.databaseExists(path);

    bool exists = await databaseExists('scuba_database.db');

    if(exists){
      removeDb();
    }

    openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'scuba_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        // return db.execute(
        //   'CREATE TABLE profile(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, detendor INTEGER NOT NULL, speed INTEGER NOT NULL, consommation INTEGER NOT NULL, vRep INTEGER NOT NULL, vRap INTEGER NOT NULL, pressure INTEGER NOT NULL, volume INTEGER NOT NULL, nbBottle INTEGER NOT NULL, selected INTEGER NOT NULL);',
        // );
        //print("Database created");

      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 2,
    );

    //print("Database created");
  }

  //Création et remplissage de la base de données
  Future<void> createDb() async {

    //print("createDb()");

    Database db = await DbHelper().database;

    await db.execute('CREATE TABLE level ( id INTEGER PRIMARY KEY AUTOINCREMENT, level TEXT NOT NULL );'
    );
    await db.execute('CREATE TABLE profile ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, speed INTEGER NOT NULL, vRap INTEGER NOT NULL, vRep INTEGER NOT NULL, volume INTEGER NOT NULL, pressure INTEGER NOT NULL, nbBottle INTEGER NOT NULL, selected INTEGER NOT NULL, detendor INTEGER NOT NULL, consommation INTEGER NOT NULL, levelId INTEGER NOT NULL, FOREIGN KEY (levelId) REFERENCES level (id) ); '
    );
    await db.execute('CREATE TABLE diving_table ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL ); '
    );
    await db.execute('CREATE TABLE azote_group ( id INTEGER PRIMARY KEY AUTOINCREMENT, azoteGroup TEXT NOT NULL );'
    );
    await db.execute('CREATE TABLE deep ( id INTEGER PRIMARY KEY AUTOINCREMENT, deep INTEGER NOT NULL, divingTableId INTEGER NOT NULL, FOREIGN KEY (divingTableId) REFERENCES diving_table (id) ); '
    );
    await db.execute('CREATE TABLE time ( id INTEGER PRIMARY KEY AUTOINCREMENT, time INTEGER NOT NULL, p15 INTEGER NOT NULL, p12 INTEGER NOT NULL, p9 INTEGER NOT NULL, p6 INTEGER NOT NULL, p3 INTEGER NOT NULL, azoteGroup TEXT NOT NULL, deepId INTEGER NOT NULL, FOREIGN KEY (azoteGroup) REFERENCES azote_group (azote), FOREIGN KEY (deepId) REFERENCES deep (id) ); '
    );
    await db.execute('CREATE TABLE diving ( id INTEGER PRIMARY KEY AUTOINCREMENT, divingTime REAL NOT NULL, divingDate TEXT NOT NULL, downTime REAL NOT NULL, upTime REAL NOT NULL, profileId INTEGER NOT NULL, deepId INTEGER NOT NULL, FOREIGN KEY (profileId) REFERENCES profile (id), FOREIGN KEY (deepId) REFERENCES deep (id) ); '
    );
    await db.execute('CREATE TABLE interval ( id INTEGER PRIMARY KEY AUTOINCREMENT, interval INTEGER NOT NULL, coefficient REAL NOT NULL, groupId INTEGER NOT NULL, FOREIGN KEY (groupId) REFERENCES azote_group (id) ); '
    );
    await db.execute('CREATE TABLE azote ( id INTEGER PRIMARY KEY AUTOINCREMENT, azote REAL NOT NULL ); '
    );
    await db.execute('CREATE TABLE deep_second ( id INTEGER PRIMARY KEY AUTOINCREMENT, deep INTEGER NOT NULL, time INTEGER NOT NULL, azoteId INTEGER NOT NULL, FOREIGN KEY (azoteId) REFERENCES azote (id) );'
    );

  }

  //Insertion des données par défaut
  Future<void> insertDefault() async {

    List<Level> levels = kLevels;
    for(Level level in levels){
      await LevelBrain().insertLevel(level);
    }

    Profile profile =
        Profile(speed: 10, consommation: 20, nbBottle: 1, name: "Default", vRap: 10, vRep: 6, volume: 15, pressure: 200, detendor: 5, selected: 1, levelId: 5);

    ProfileBrain b = ProfileBrain();
    await b.insertProfile(profile);

    List<DivingTable> tables = kDivingTables;
    for(DivingTable table in tables){
      await DivingTableBrain().insertDivingTable(table);
    }

    List<Group> groups = kGroups;
    for(Group group in groups){
      await GroupBrain().insertGroup(group);
    }

    List<Azote> azotes = kAzotes;
    for(Azote azote in azotes){
      await AzoteBrain().insertAzote(azote);
    }

    List<Deep> deeps = kDeeps;
    for(Deep deep in deeps){
      await DeepBrain().insertDeep(deep);
    }

    List<Time> times = kTimes;
    for(Time time in times){
      await TimeBrain().insertTime(time);
    }

    List<Intervalle> intervalles = kIntervals;
    for(Intervalle intervalle in intervalles){
      await IntervalleBrain().insertIntervalle(intervalle);
    }

    List<SecondDeep> secondDeeps = kSecondDeeps;
    for(SecondDeep secondDeep in secondDeeps){
      await SecondDeepBrain().insertSecondDeep(secondDeep);
    }

  }

  //Suppression de la base de données
  void removeDb() async {

    print("Database deleted");

    final database = openDatabase(
      join(await getDatabasesPath(), 'scuba_database.db'),
      // ignore: void_checks
      onOpen: (db) {
        return db.delete('scuba_databse.db');
      },
    );

  }

}

