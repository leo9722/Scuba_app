import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/errorAlertdialog.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/constants.dart';
import 'package:scuba/model/DivingTableBrain.dart';
import 'package:scuba/model/dataClasses.dart';

/*
* Classe : DivingTableCrudMainScreen
*
* Permet la gestion des tables dans
* la base de données
*
* */
class DivingTableCrudMainScreen extends StatefulWidget {
  const DivingTableCrudMainScreen({Key? key}) : super(key: key);

  @override
  State<DivingTableCrudMainScreen> createState() => _DivingTableCrudMainScreenState();
}

class _DivingTableCrudMainScreenState extends State<DivingTableCrudMainScreen> {
  List <DivingTable> tables = [];
  String newTableName = "";

  Future<void> getTables() async {
    List<DivingTable> tbls = await DivingTableBrain().listDivingTable();

    setState(() {
      tables = tbls;
    });

  }

  //Vérification si la valeur existe déjà
  Future<bool> checkValue(String value) async {

    List<DivingTable> tables = await DivingTableBrain().listDivingTable();

    bool exist = false;
    for(DivingTable dt in tables){
      //print(dt.toMap());
      if(dt.name == value){
        return true;
      } else {
        exist = false;
      }
    }

    return exist;

  }

  Future<void> addTable(String name) async {
    if (name.isNotEmpty && name.length < 31) {
      //Vérif si donnée existe
      bool exist = await checkValue(name);
      if(exist == false) {
        DivingTable table = DivingTable(name: name);
        newTableName = "";
        await DivingTableBrain().insertDivingTable(table);
        getTables();
      } else {
        ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
      }
      Navigator.pop(context);

    }
  }

  Future<void> deleteTable(int id) async {

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous supprimer cette table ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Non'),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () {
              DivingTableBrain().deleteDivingTable(id);
              Navigator.pop(context, 'Oui');
              getTables();
            },
            child: const Text('Oui'),
          ),
        ],
      ),
    );

  }

  Future<void> editTable(DivingTable t) async {

    bool exist = await checkValue(t.name);
    if(exist == false) {
      await DivingTableBrain().updateDivingTable(t);
      getTables();
    } else {
      ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
    }

    Navigator.pop(context);

  }

  List<Padding> getListViewItems() {
    List<Padding> items = [];

    for (DivingTable t in tables) {
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
                                          "Détails de la table",
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
                                                  "Nom de la table",
                                                  style: TextStyle(
                                                    color: kDarkBlueTextColor,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              TextFormField(
                                                enabled: false,
                                                initialValue: t.name,
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
                                                  newTableName = value.toString();
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
                          t.name,
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
                                              'Modifier une table',
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
                                                      "Nom de la table",
                                                      style: TextStyle(
                                                        color: kDarkBlueTextColor,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    initialValue: t.name,
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
                                                     t.name = value.toString();
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
                                                editTable(t);
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
                              deleteTable(t.id);
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
    getTables();
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
              text: "Gestion des tables",
            ),
            flex: 3,
          ),
          const Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 9,
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
                                'Ajouter une table',
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
                                        "Nom de la table",
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
                                        newTableName = value.toString();
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
                                  addTable(newTableName);
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
