import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/errorAlertdialog.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/constants.dart';
import 'package:scuba/model/DeepBrain.dart';
import 'package:scuba/model/DivingTableBrain.dart';
import 'package:scuba/model/GroupBrain.dart';
import 'package:scuba/model/TimeBrain.dart';
import 'package:scuba/model/dataClasses.dart';

/*
* Classe : TimeCrudMainScreen
*
* Permet la gestion du temps dans
* la base de données
*
* */
class TimeCrudMainScreen extends StatefulWidget {
  const TimeCrudMainScreen({Key? key}) : super(key: key);

  @override
  State<TimeCrudMainScreen> createState() => _TimeCrudMainScreenState();
}

class _TimeCrudMainScreenState extends State<TimeCrudMainScreen> {

  //Init liste vide qui condiendra nos données
  List<Time> times = [];
  List<DivingTable> tables = [];
  List<Deep> deeps = [];
  List<Group> groupes = [];

  DivingTable currentDivingTable = DivingTable(name: "");
  Deep  currentDeep = Deep(deep: 0, divingTableId: 0);
  Group currentGroup = Group(azoteGroup: "");

  Time newTime = Time(time: 0, p15: 0, p12: 0, p9: 0,p6: 0, p3: 0, azoteGroup: "A", deepId: 0);

  Future<void> reorderGroups(String group) async {

    List<Group> grps = groupes;

    Group selectedGroup = await GroupBrain().listGroupByGroup(group);
    grps.removeWhere((element) => element.azoteGroup == group);
    grps.insert(0, selectedGroup);

    groupes = grps;

  }

  //Vérification si une donnée existe déjà
  bool checkValues(Time time){

    bool exist = false;

    for(Time t in times){

      if(t.time == time.time && t.p3 == time.p3 && t.p6 == time.p6 && t.p9 == time.p9 && t.p12 == time.p12 && t.p15 == time.p15 && t.azoteGroup == time.azoteGroup){
        return true;
      } else {
        exist = false;
      }

    }

    return exist;

  }

  Future<void> getTime() async {
    List<Time> t = await TimeBrain().listTimeByDeep(currentDeep.id);

    //Actualisation des données
    setState(() {
      times = t;
    });
  }

  Future<void> getTables() async {
    List<DivingTable> t = await DivingTableBrain().listDivingTable();

    setState(() {
      tables = t;
    });
  }

  Future<void> getDeep(int id) async {
    List<Deep> d = await DeepBrain().listDeepByTable(id);

    //Actualisation des données
    setState(() {
      deeps = d;
    });
  }

  Future<void> getGroupes() async {
    List<Group> g = await GroupBrain().listGroup();
    //Actualisation des données
    setState(() {
      groupes = g;
    });
  }

  //Ajout d'une donnée
  Future<void> addTime(Time temps) async {

    newTime.deepId = currentDeep.id;

    //print("Temps : " + temps.toMap().toString());
    //Vérif si champ non vide et valide
    if (temps.p3 >= 0 && temps.p3 < 120 && temps.p6 >= 0 && temps.p6 < 120 && temps.p9 >= 0 && temps.p9 < 120 && temps.p12 >= 0 && temps.p12 < 120 && temps.p15 >= 0 && temps.p15 < 120) {
      if(temps.time > 0 && temps.time < 360 ) {

        //Vérif si donnée existe
        bool exist = checkValues(temps);
        if(exist == false) {
          //Insertion d'une nouvelle donnée
          await TimeBrain().insertTime(temps);
          newTime.azoteGroup = "A";
          newTime.time = 0;
          newTime.p3 = 0;
          newTime.p6 = 0;
          newTime.p9 = 0;
          newTime.p12 = 0;
          newTime.p15 = 0;
          //Récupération des données
          getTime();
        } else {
          ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
        }
        //Ecran principal
        Navigator.pop(context);
      }

    }
  }

  //Suppression d'une donnée
  Future<void> deleteTime(int id) async {

    //Ouverture dialogue de confirmation
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous supprimer ce temps ?'),
        actions: <Widget>[
          TextButton(
            //Si non, on fait rien, on retire le dialogue
            onPressed: () => Navigator.pop(context, 'Non'),
            child: const Text('Non'),
          ),
          TextButton(
            //Si oui, on supprime, et on actualise les données
            onPressed: () {
              TimeBrain().deleteTime(id);
              Navigator.pop(context, 'Oui');
              getTime();
            },
            child: const Text('Oui'),
          ),
        ],
      ),
    );
  }

  //Modification d'une donnée
  Future<void> editTime(Time t) async {

    //Si donnée existe
    bool exist = checkValues(t);
      if(exist == false) {
        //Modification d'une donnée
        await TimeBrain().updateTime(t);
        //Actualisation des données
        getTime();

      } else {
        ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
      }
      //Retour à l'écran principal
    Navigator.pop(context);

  }

  List<Widget> getTableItems() {

    List<Widget> pickerItems = [];

    for (DivingTable table in tables) {
      pickerItems.add(
        Align(
          child: Text(
            table.name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          alignment: Alignment.center,
        ),
      );
    }

    return pickerItems;
  }

  List<Widget> getDeepItems() {

    List<Widget> pickerItems = [];

    for (Deep deep in deeps) {
      pickerItems.add(
        Align(
          child: Text(
            "${deep.deep.toString()} m",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          alignment: Alignment.center,
        ),
      );
    }

    return pickerItems;
  }

  List<Widget> getGroupItems() {

    List<Widget> pickerItems = [];

    for (Group group in groupes) {
      pickerItems.add(
        Align(
          child: Text(
            group.azoteGroup,
            style: const TextStyle(
              color: kDarkBlueTextColor,
            ),
          ),
          alignment: Alignment.center,
        ),
      );
    }

    return pickerItems;
  }

  //Récupération de la liste des items
  List<Padding> getListViewItems() {

    //Liste de Widgets (ici, des paddings)
    List<Padding> items = [];

    //Pour chaque données, on va créer un widget et l'ajouter à la liste
    for (Time t in times) {
      items.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          //GestureDetector qui prend en charge tout le widget
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
                      //TextButton qui va afficher les détails
                      child: TextButton(
                        //Au moment où l'on appuie sur le texte, on appelle une fonction
                        onPressed: (){
                          //Fonction qui va faire apparaître un ModalBottomSheet
                          //<--------------------------------------------------------------------------->
                          showModalBottomSheet<void>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              //Corps de la bottomSheet
                              return Container(
                                height: 450,
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
                                          "Détails du temps",
                                          style: TextStyle(
                                            color: kDarkBlueTextColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Flexible(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Flexible(
                                                flex: 5,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Flexible(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(bottom: 10.0),
                                                        child: Text(
                                                          "Temps",
                                                          style: TextStyle(
                                                            color: kDarkBlueTextColor,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      enabled: false,
                                                      initialValue: t.time.toString(),
                                                      maxLines: 1,
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
                                                        setState(() {
                                                          newTime.time = int.parse(value);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(
                                                flex: 1,
                                              ),
                                              Flexible(
                                                flex: 5,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Flexible(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(bottom: 10.0),
                                                        child: Text(
                                                          "Groupe",
                                                          style: TextStyle(
                                                            color: kDarkBlueTextColor,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      enabled: false,
                                                      initialValue: t.azoteGroup.toString(),
                                                      maxLines: 1,
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
                                                        setState(() {
                                                          newTime.time = int.parse(value);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Flexible(
                                                flex: 5,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Flexible(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(bottom: 10.0),
                                                        child: Text(
                                                          "3 m",
                                                          style: TextStyle(
                                                            color: kDarkBlueTextColor,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      enabled: false,
                                                      initialValue: t.p3.toString(),
                                                      maxLines: 1,
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
                                                        setState(() {
                                                          newTime.time = int.parse(value);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(
                                                flex: 1,
                                              ),
                                              Flexible(
                                                flex: 5,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Flexible(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(bottom: 10.0),
                                                        child: Text(
                                                          "6 m",
                                                          style: TextStyle(
                                                            color: kDarkBlueTextColor,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      enabled: false,
                                                      initialValue: t.p6.toString(),
                                                      maxLines: 1,
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
                                                        setState(() {
                                                          newTime.time = int.parse(value);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(
                                                flex: 1,
                                              ),
                                              Flexible(
                                                flex: 5,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Flexible(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(bottom: 10.0),
                                                        child: Text(
                                                          "9 m",
                                                          style: TextStyle(
                                                            color: kDarkBlueTextColor,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      enabled: false,
                                                      initialValue: t.p9.toString(),
                                                      maxLines: 1,
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
                                                        setState(() {
                                                          newTime.time = int.parse(value);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(
                                                flex: 1,
                                              ),
                                              Flexible(
                                                flex: 5,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Flexible(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(bottom: 10.0),
                                                        child: Text(
                                                          "12 m",
                                                          style: TextStyle(
                                                            color: kDarkBlueTextColor,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      enabled: false,
                                                      initialValue: t.p12.toString(),
                                                      maxLines: 1,
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
                                                        setState(() {
                                                          newTime.time = int.parse(value);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(
                                                flex: 1,
                                              ),
                                              Flexible(
                                                flex: 5,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Flexible(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(bottom: 10.0),
                                                        child: Text(
                                                          "15 m",
                                                          style: TextStyle(
                                                            color: kDarkBlueTextColor,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      enabled: false,
                                                      initialValue: t.p15.toString(),
                                                      maxLines: 1,
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
                                                        setState(() {
                                                          newTime.time = int.parse(value);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
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
                                        flex: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        //Nom du niveau
                        child: Text(
                          "${t.time.toString()} minutes",
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      //Ligne contenant les boutons edit et delete
                      child: Row(children: [
                        Flexible(
                          flex: 3,
                          //Partie Edit : fait apparaître un modalbottomsheet
                          child: GestureDetector(
                            onTap: (){
                              //<--------------------------------------------------------------------------->
                              reorderGroups(t.azoteGroup);
                              showModalBottomSheet<void>(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  //Corps de la bottomsheet
                                  return Container(
                                    height: 550,
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
                                              "Modifier un temps",
                                              style: TextStyle(
                                                color: kDarkBlueTextColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Flexible(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 5,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        const Flexible(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(bottom: 10.0),
                                                            child: Text(
                                                              "Temps",
                                                              style: TextStyle(
                                                                color: kDarkBlueTextColor,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          keyboardType: const TextInputType.numberWithOptions(
                                                              decimal: false, signed: true),
                                                          initialValue: t.time.toString(),
                                                          enabled: true,
                                                          maxLines: 1,
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
                                                            setState(() {
                                                              newTime.time = int.parse(value);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(
                                                    flex: 1,
                                                  ),
                                                  Flexible(
                                                    flex: 5,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        const Flexible(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(bottom: 10.0),
                                                            child: Text(
                                                              "Groupe",
                                                              style: TextStyle(
                                                                color: kDarkBlueTextColor,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(
                                                                top: 15.0, bottom: 5.0, left: 50.0, right: 50.0),
                                                            child: CupertinoPicker(
                                                              itemExtent: 35.0,
                                                              looping: true,
                                                              onSelectedItemChanged: (selectedIndex) {
                                                                setState(() {
                                                                  currentGroup = groupes[selectedIndex];
                                                                  t.azoteGroup = currentGroup.azoteGroup;
                                                                });
                                                              },
                                                              children: getGroupItems(),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 5,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        const Flexible(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(bottom: 10.0),
                                                            child: Text(
                                                              "3 m",
                                                              style: TextStyle(
                                                                color: kDarkBlueTextColor,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          keyboardType: const TextInputType.numberWithOptions(
                                                              decimal: false, signed: true),
                                                          initialValue: t.p3.toString(),
                                                          enabled: true,
                                                          maxLines: 1,
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
                                                            setState(() {
                                                              newTime.p3 = int.parse(value);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(
                                                    flex: 1,
                                                  ),
                                                  Flexible(
                                                    flex: 5,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        const Flexible(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(bottom: 10.0),
                                                            child: Text(
                                                              "6 m",
                                                              style: TextStyle(
                                                                color: kDarkBlueTextColor,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          keyboardType: const TextInputType.numberWithOptions(
                                                              decimal: false, signed: true),
                                                          initialValue: t.p6.toString(),
                                                          enabled: true,
                                                          maxLines: 1,
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
                                                            setState(() {
                                                              newTime.p6 = int.parse(value);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(
                                                    flex: 1,
                                                  ),
                                                  Flexible(
                                                    flex: 5,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        const Flexible(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(bottom: 10.0),
                                                            child: Text(
                                                              "9 m",
                                                              style: TextStyle(
                                                                color: kDarkBlueTextColor,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          keyboardType: const TextInputType.numberWithOptions(
                                                              decimal: false, signed: true),
                                                          initialValue: t.p9.toString(),
                                                          enabled: true,
                                                          maxLines: 1,
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
                                                            setState(() {
                                                              newTime.p9 = int.parse(value);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(
                                                    flex: 1,
                                                  ),
                                                  Flexible(
                                                    flex: 5,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        const Flexible(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(bottom: 10.0),
                                                            child: Text(
                                                              "12 m",
                                                              style: TextStyle(
                                                                color: kDarkBlueTextColor,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          keyboardType: const TextInputType.numberWithOptions(
                                                              decimal: false, signed: true),
                                                          initialValue: t.p12.toString(),
                                                          enabled: true,
                                                          maxLines: 1,
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
                                                            setState(() {
                                                              newTime.p12 = int.parse(value);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(
                                                    flex: 1,
                                                  ),
                                                  Flexible(
                                                    flex: 5,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        const Flexible(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(bottom: 10.0),
                                                            child: Text(
                                                              "15 m",
                                                              style: TextStyle(
                                                                color: kDarkBlueTextColor,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          keyboardType: const TextInputType.numberWithOptions(
                                                              decimal: false, signed: true),
                                                          initialValue: t.p15.toString(),
                                                          enabled: true,
                                                          maxLines: 1,
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
                                                            setState(() {
                                                              newTime.p15 = int.parse(value);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Spacer(
                                            flex: 1,
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
                                                editTime(t);
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
                                            flex: 2,
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
                          //Partie delete : appelle la fonction delete et supprime une donnée
                          child: GestureDetector(
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 35,
                            ),
                            onTap: (){
                              deleteTime(t.id);
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

  //Au chargement de la page, on initialise et on récupère les données
  @override
  void initState() {
    super.initState();
    getTables();
    getDeep(currentDivingTable.id);
    getGroupes();
    getTime();

  }

  @override
  Widget build(BuildContext context) {
    //Background et corps de la page
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
          //Header
          const Flexible(
            child: HeaderC(
              text: "Gestion du Temps",
            ),
            flex: 3,
          ),
          const Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 2,
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 5.0, left: 50.0, right: 50.0),
                    child: CupertinoPicker(
                      itemExtent: 35.0,
                      looping: true,
                      onSelectedItemChanged: (selectedIndex) {
                        setState(() {
                          currentDivingTable = tables[selectedIndex];
                          getDeep(currentDivingTable.id);
                        });
                      },
                      children: getTableItems(),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 5.0, left: 50.0, right: 50.0),
                    child: CupertinoPicker(
                      itemExtent: 35.0,
                      looping: true,
                      onSelectedItemChanged: (selectedIndex) {
                        setState(() {
                          currentDeep = deeps[selectedIndex];
                          getTime();
                        });
                      },
                      children: getDeepItems(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //ListeView qui va avoir comme enfant (données) les données retournées par la fonction getListViewItems
          Flexible(
            flex: 10,
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
          //Bouton d'ajout de données
          Flexible(
            flex: 1,
            child: FloatingActionButton(
              onPressed: () {
                //<--------------------------------------------------------------------------->
                showModalBottomSheet<void>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    //Corps de la bottomsheet
                    return Container(
                      height: 550,
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
                                "Ajouter un temps",
                                style: TextStyle(
                                  color: kDarkBlueTextColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: 10.0),
                                              child: Text(
                                                "Temps",
                                                style: TextStyle(
                                                  color: kDarkBlueTextColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: const TextInputType.numberWithOptions(
                                                decimal: false, signed: true),
                                            enabled: true,
                                            maxLines: 1,
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
                                              setState(() {
                                                newTime.time = int.parse(value);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: 10.0),
                                              child: Text(
                                                "Groupe",
                                                style: TextStyle(
                                                  color: kDarkBlueTextColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0, bottom: 5.0, left: 50.0, right: 50.0),
                                              child: CupertinoPicker(
                                                itemExtent: 35.0,
                                                looping: true,
                                                onSelectedItemChanged: (selectedIndex) {
                                                  setState(() {
                                                    currentGroup = groupes[selectedIndex];
                                                    newTime.azoteGroup = currentGroup.azoteGroup;
                                                  });
                                                },
                                                children: getGroupItems(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: 10.0),
                                              child: Text(
                                                "3 m",
                                                style: TextStyle(
                                                  color: kDarkBlueTextColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: const TextInputType.numberWithOptions(
                                                decimal: false, signed: true),
                                            enabled: true,
                                            maxLines: 1,
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
                                              setState(() {
                                                newTime.p3 = int.parse(value);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: 10.0),
                                              child: Text(
                                                "6 m",
                                                style: TextStyle(
                                                  color: kDarkBlueTextColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: const TextInputType.numberWithOptions(
                                                decimal: false, signed: true),
                                            enabled: true,
                                            maxLines: 1,
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
                                              setState(() {
                                                newTime.p6 = int.parse(value);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: 10.0),
                                              child: Text(
                                                "9 m",
                                                style: TextStyle(
                                                  color: kDarkBlueTextColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: const TextInputType.numberWithOptions(
                                                decimal: false, signed: true),
                                            enabled: true,
                                            maxLines: 1,
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
                                              setState(() {
                                                newTime.p9 = int.parse(value);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: 10.0),
                                              child: Text(
                                                "12 m",
                                                style: TextStyle(
                                                  color: kDarkBlueTextColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: const TextInputType.numberWithOptions(
                                                decimal: false, signed: true),
                                            enabled: true,
                                            maxLines: 1,
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
                                              setState(() {
                                                newTime.p12 = int.parse(value);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: 10.0),
                                              child: Text(
                                                "15 m",
                                                style: TextStyle(
                                                  color: kDarkBlueTextColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: const TextInputType.numberWithOptions(
                                                decimal: false, signed: true),
                                            enabled: true,
                                            maxLines: 1,
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
                                              setState(() {
                                                newTime.p15 = int.parse(value);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(
                              flex: 1,
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
                                  addTime(newTime);
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
                              flex: 2,
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
