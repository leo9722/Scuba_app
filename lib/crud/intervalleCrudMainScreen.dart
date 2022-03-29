import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/errorAlertdialog.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/constants.dart';
import 'package:scuba/model/GroupBrain.dart';
import 'package:scuba/model/IntervalleBrain.dart';
import 'package:scuba/model/dataClasses.dart';

/*
* Classe : IntervalleCrudMainScreen
*
* Permet la gestion des intervalles dans
* la base de données
*
* */

class IntervalleCrudMainScreen extends StatefulWidget {
  const IntervalleCrudMainScreen({Key? key}) : super(key: key);

  @override
  State<IntervalleCrudMainScreen> createState() => _IntervalleCrudMainScreen();
}

class _IntervalleCrudMainScreen extends State<IntervalleCrudMainScreen> {
  //Init liste vide qui condiendra nos données
  List<Intervalle> intervalles = [];

  List<Group> groups = [];

  //Champ vide
  int newIntervalleValue = 0;
  double newCoefficientValue = 0;

  Group currentGroup = Group(azoteGroup: "");

  //Vérification si les valeurs existent déjà
  bool checkValues(double coeff, int intervalle){

    bool exist = false;

    for(Intervalle i in intervalles){
      if(i.coefficient == coeff && i.interval == intervalle){
        return true;
      } else {
        exist = false;
      }
    }

    return exist;

  }

  Future<void> getGroup() async {
    List<Group> g = await GroupBrain().listGroup();

    setState(() {
      groups = g;
    });
  }

  //Récup des données
  Future<void> getIntervalle(int id) async {
    List<Intervalle> i = await IntervalleBrain().listIntervalleByGroup(id);

    //Actualisation des données
    setState(() {
      intervalles = i;
    });
  }

  //Ajout d'une donnée
  Future<void> addInt(int int, double coef) async {
    //Vérif si champ non vide et valide
    if (int > 0 && int < 600 && coef > 0 && coef < 2) {
      //vérif si donnée existe
      bool exist = checkValues(coef, int);
      if(exist == false) {
        //Création d'une nouvelle donnée
        Intervalle intervalle = Intervalle(
            interval: int, coefficient: coef, groupId: currentGroup.id);
        newIntervalleValue = 0;
        //Insertion d'une nouvelle donnée
        await IntervalleBrain().insertIntervalle(intervalle);
        //Récupération des données
        getIntervalle(currentGroup.id);
      } else {
        ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
      }
      //Ecran principal
      Navigator.pop(context);
    }
  }

  //Suppression d'une donnée
  Future<void> deleteInt(int id) async {
    //Ouverture dialogue de confirmation
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous supprimer cette intervalle ?'),
        actions: <Widget>[
          TextButton(
            //Si non, on fait rien, on retire le dialogue
            onPressed: () => Navigator.pop(context, 'Non'),
            child: const Text('Non'),
          ),
          TextButton(
            //Si oui, on supprime, et on actualise les données
            onPressed: () {
              IntervalleBrain().deleteIntervalle(id);
              Navigator.pop(context, 'Oui');
              getIntervalle(currentGroup.id);
            },
            child: const Text('Oui'),
          ),
        ],
      ),
    );
  }

  //Modification d'une donnée
  Future<void> editInt(Intervalle i) async {
    bool exist = checkValues(i.coefficient, i.interval);
    if(exist == false) {
      //Modification d'une donnée
      await IntervalleBrain().updateIntervalle(i);
      //Actualisation des données
      getIntervalle(currentGroup.id);
    } else {
      ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
    }
    //Retour à l'écran principal
    Navigator.pop(context);

  }

  List<Widget> getItems() {
    List<Widget> pickerItems = [];

    for (Group g in groups) {
      pickerItems.add(
        Align(
          child: Text(
            g.azoteGroup.toString(),
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

  //Récupération de la liste des items
  List<Padding> getListViewItems() {
    //Liste de Widgets (ici, des paddings)
    List<Padding> items = [];

    //Pour chaque données, on va créer un widget et l'ajouter à la liste
    for (Intervalle i in intervalles) {
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
                        onPressed: () {
                          //Fonction qui va faire apparaître un ModalBottomSheet
                          //<--------------------------------------------------------------------------->
                          showModalBottomSheet<void>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              //Corps de la bottomSheet
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
                                          "Détails de l'intervalle",
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
                                          child: Row(
                                            children: [
                                              Flexible(
                                                flex: 3,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 20.0),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        flex: 5,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10.0,
                                                                      top:
                                                                          15.0),
                                                              child: Text(
                                                                "Intervalle",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kDarkBlueTextColor,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ),
                                                            TextFormField(
                                                              keyboardType:
                                                                  const TextInputType
                                                                          .numberWithOptions(
                                                                      decimal:
                                                                          true,
                                                                      signed:
                                                                          true),
                                                              maxLines: 1,
                                                              enabled: false,
                                                              initialValue:
                                                                  "${i.interval.toString()} minutes",
                                                              decoration:
                                                                  const InputDecoration(
                                                                fillColor: Color(
                                                                    0x33333333),
                                                                filled: true,
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .indigo,
                                                                  ),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color:
                                                                        kDarkBlueTextColor,
                                                                  ),
                                                                ),
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                                hintText: "...",
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                i.interval =
                                                                    int.parse(
                                                                        value);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Flexible(
                                                        flex: 5,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10.0,
                                                                      top:
                                                                          15.0),
                                                              child: Text(
                                                                "Azote résiduel",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kDarkBlueTextColor,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ),
                                                            TextFormField(
                                                              keyboardType:
                                                                  const TextInputType
                                                                          .numberWithOptions(
                                                                      decimal:
                                                                          true,
                                                                      signed:
                                                                          true),
                                                              maxLines: 1,
                                                              enabled: false,
                                                              initialValue: i
                                                                  .coefficient
                                                                  .toString(),
                                                              decoration:
                                                                  const InputDecoration(
                                                                fillColor: Color(
                                                                    0x33333333),
                                                                filled: true,
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .indigo,
                                                                  ),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color:
                                                                        kDarkBlueTextColor,
                                                                  ),
                                                                ),
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                                hintText: "...",
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                i.coefficient =
                                                                    double.parse(
                                                                        value);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color>(
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
                        //Nom du niveau
                        child: Text(
                          "Intervalle :${i.interval.toString()} - Coefficient : ${i.coefficient.toString()}",
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
                            onTap: () {
                              //<--------------------------------------------------------------------------->
                              showModalBottomSheet<void>(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  //Corps de la bottomsheet
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Flexible(
                                            flex: 1,
                                            child: Text(
                                              "Modifier l'intervalle",
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
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    flex: 5,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 10.0,
                                                                  top: 15.0),
                                                          child: Text(
                                                            "Intervalle (minutes)",
                                                            style: TextStyle(
                                                              color:
                                                                  kDarkBlueTextColor,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          keyboardType:
                                                              const TextInputType
                                                                      .numberWithOptions(
                                                                  decimal:
                                                                      false,
                                                                  signed: true),
                                                          initialValue: i
                                                              .interval
                                                              .toString(),
                                                          maxLines: 1,
                                                          decoration:
                                                              const InputDecoration(
                                                            fillColor: Color(
                                                                0x33333333),
                                                            filled: true,
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .indigo,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    kDarkBlueTextColor,
                                                              ),
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            hintText: "...",
                                                          ),
                                                          onChanged: (value) {
                                                            i.interval =
                                                                int.parse(
                                                                    value);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Flexible(
                                                    flex: 5,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 10.0,
                                                                  top: 15.0),
                                                          child: Text(
                                                            "Coefficient d'azote",
                                                            style: TextStyle(
                                                              color:
                                                                  kDarkBlueTextColor,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          keyboardType:
                                                              const TextInputType
                                                                      .numberWithOptions(
                                                                  decimal: true,
                                                                  signed: true),
                                                          initialValue: i
                                                              .coefficient
                                                              .toString(),
                                                          maxLines: 1,
                                                          decoration:
                                                              const InputDecoration(
                                                            fillColor: Color(
                                                                0x33333333),
                                                            filled: true,
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .indigo,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    kDarkBlueTextColor,
                                                              ),
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            hintText: "...",
                                                          ),
                                                          onChanged: (value) {
                                                            i.coefficient =
                                                                double.parse(
                                                                    value);
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
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                                    return kLightPurpleButtonColor;
                                                  },
                                                ),
                                              ),
                                              onPressed: () {
                                                editInt(i);
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
                          //Partie delete : appelle la fonction delete et supprime une donnée
                          child: GestureDetector(
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 35,
                            ),
                            onTap: () {
                              deleteInt(i.id);
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
    getGroup();
    getIntervalle(currentGroup.id);
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
              text: "Gestion des intervalles",
            ),
            flex: 3,
          ),
          const Flexible(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                "Groupe de plongée successive",
                style: TextStyle(
                  color: kDarkBlueTextColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 5.0, left: 50.0, right: 50.0),
              child: CupertinoPicker(
                itemExtent: 35.0,
                looping: true,
                onSelectedItemChanged: (selectedIndex) {
                  setState(() {
                    currentGroup = groups[selectedIndex];
                    //print(currentGroup.toMap());

                    getIntervalle(currentGroup.id);
                  });
                },
                children: getItems(),
              ),
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
                                'Ajouter un intervalle',
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
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10.0, top: 15.0),
                                            child: Text(
                                              "Intervalle (minutes)",
                                              style: TextStyle(
                                                color: kDarkBlueTextColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: const TextInputType
                                                    .numberWithOptions(
                                                decimal: false, signed: true),
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
                                              newIntervalleValue =
                                                  int.parse(value);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10.0, top: 15.0),
                                            child: Text(
                                              "Coefficient d'azote",
                                              style: TextStyle(
                                                color: kDarkBlueTextColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: const TextInputType
                                                    .numberWithOptions(
                                                decimal: true, signed: true),
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
                                              newCoefficientValue =
                                                  double.parse(value);
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
                                  addInt(
                                      newIntervalleValue, newCoefficientValue);
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
