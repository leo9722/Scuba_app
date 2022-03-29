import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/errorAlertdialog.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/constants.dart';
import 'package:scuba/model/LevelBrain.dart';
import 'package:scuba/model/dataClasses.dart';

/*
* Classe : LevelCrudMainScreen
*
* Permet la gestion des niveaux dans
* la base de données
*
* */

class LevelCrudMainScreen extends StatefulWidget {
  const LevelCrudMainScreen({Key? key}) : super(key: key);

  @override
  State<LevelCrudMainScreen> createState() => _LevelCrudMainScreenState();
}

class _LevelCrudMainScreenState extends State<LevelCrudMainScreen> {
  List<Level> levels = [];
  String newLevelName = "";

  //Vérification si la valeur existe déjà
  bool checkValue(String value){

    bool exist = false;

    for(Level l in levels){
      if(l.level == value){
        return true;
      } else {
        exist = false;
      }
    }

    return exist;

  }

  Future<void> getLevels() async {
    List<Level> l = await LevelBrain().listLevel();

    setState(() {
      levels = l;
    });
  }

  Future<void> addLevel(String name) async {
    if (name.isNotEmpty && name.length < 31) {
      //Vérification si donnée existe ou non
      bool exist = checkValue(name);
      if(exist == false) {
        Level level = Level(level: name);
        //print("Add : " + level.toMap().toString());
        newLevelName = "";
        await LevelBrain().insertLevel(level);
        getLevels();
      } else {
        ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
      }
      Navigator.pop(context);
    }
  }

  Future<void> deleteLevel(int id) async {

    //print("Delete : " + id.toString());
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous supprimer ce niveau ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Non'),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () {
              LevelBrain().deleteLevel(id);
              Navigator.pop(context, 'Oui');
              getLevels();
            },
            child: const Text('Oui'),
          ),
        ],
      ),
    );

  }

  Future<void> editLevel(Level l) async {

    bool exist = checkValue(l.level);
    if(exist == false) {
      await LevelBrain().updateLevel(l);
      getLevels();
    } else {
      ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
    }
    Navigator.pop(context);

  }

  List<Padding> getListViewItems() {
    List<Padding> items = [];

    for (Level l in levels) {
      items.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 10,
                      child: TextButton(
                        onPressed: (){
                          showModalBottomSheet<void>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 375,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Flexible(
                                        flex: 1,
                                        child: Text(
                                          "Détails du niveau",
                                          style: TextStyle(
                                            color: kDarkBlueTextColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 10.0, top: 15.0),
                                                child: Text(
                                                  "Nom du niveau",
                                                  style: TextStyle(
                                                    color: kDarkBlueTextColor,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              TextFormField(
                                                enabled: false,
                                                initialValue: l.level,
                                                maxLines: 1,
                                                maxLength: 30,
                                                decoration: const InputDecoration(
                                                  fillColor: Color(0x33333333),
                                                  filled: true,
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.indigo,
                                                    ),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: kDarkBlueTextColor,
                                                    ),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  hintText: "...",
                                                ),
                                                onChanged: (value) {
                                                  newLevelName = value.toString();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                              ),
                                            ),
                                            backgroundColor:
                                            MaterialStateProperty.resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                                return kLightPurpleButtonColor;
                                              },
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 10,
                                              right: 10,
                                              left: 10,
                                              top: 10,
                                            ),
                                            child: Text(
                                              'Retour',
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          l.level,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Row(children: [
                        Flexible(
                          flex: 3,
                          child: GestureDetector(
                            onTap: (){
                              showModalBottomSheet<void>(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 375,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(50.0),
                                        topRight: Radius.circular(50.0),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Flexible(
                                            flex: 1,
                                            child: Text(
                                              'Modifier un niveau',
                                              style: TextStyle(
                                                color: kDarkBlueTextColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 10.0, top: 15.0),
                                                    child: Text(
                                                      "Nom du niveau",
                                                      style: TextStyle(
                                                        color: kDarkBlueTextColor,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    initialValue: l.level,
                                                    maxLines: 1,
                                                    maxLength: 30,
                                                    decoration: const InputDecoration(
                                                      fillColor: Color(0x33333333),
                                                      filled: true,
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.indigo,
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: kDarkBlueTextColor,
                                                        ),
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      hintText: "...",
                                                    ),
                                                    onChanged: (value) {
                                                      l.level = value.toString();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18.0),
                                                  ),
                                                ),
                                                backgroundColor:
                                                MaterialStateProperty.resolveWith<Color>(
                                                      (Set<MaterialState> states) {
                                                    return kLightPurpleButtonColor;
                                                  },
                                                ),
                                              ),
                                              onPressed: () {
                                                editLevel(l);
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 10,
                                                  right: 10,
                                                  left: 10,
                                                  top: 10,
                                                ),
                                                child: Text(
                                                  'Sauvegarder',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Spacer(
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.orange,
                              size: 35,
                            ),
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Flexible(
                          flex: 3,
                          child: GestureDetector(
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 35,
                            ),
                            onTap: (){
                              deleteLevel(l.id);
                            },
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return items;
  }

  @override
  void initState() {
    super.initState();
    getLevels();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      resizeToAvoidBottomInset: false,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF32a5ff),
          Color(0xFF334ac9),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Flexible(
            child: HeaderC(
              text: "Gestion des niveaux",
            ),
            flex: 3,
          ),
          const Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 12,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ListView(
                  children: getListViewItems(),
                ),
              ),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 1,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 375,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text(
                                'Ajouter un niveau',
                                style: TextStyle(
                                  color: kDarkBlueTextColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 10.0, top: 15.0),
                                      child: Text(
                                        "Nom du niveau",
                                        style: TextStyle(
                                          color: kDarkBlueTextColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      maxLines: 1,
                                      maxLength: 30,
                                      decoration: const InputDecoration(
                                        fillColor: Color(0x33333333),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: kDarkBlueTextColor,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        hintText: "...",
                                      ),
                                      onChanged: (value) {
                                        newLevelName = value.toString();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      return kLightPurpleButtonColor;
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  addLevel(newLevelName);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 10,
                                    right: 10,
                                    left: 10,
                                    top: 10,
                                  ),
                                  child: Text(
                                    'Ajouter',
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.add,
                color: kDarkBlueTextColor,
                size: 35,
              ),
            ),
          ),
          const Spacer(
            flex: 2,
          )
        ],
      ),
    );
  }
}
