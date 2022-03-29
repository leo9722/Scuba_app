import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/errorAlertdialog.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/constants.dart';
import 'package:scuba/model/AzoteBrain.dart';
import 'package:scuba/model/SecondDeepBrain.dart';
import 'package:scuba/model/dataClasses.dart';

/*
* Classe : MajorationCrudMainScreen
*
* Permet la gestion des majorations dans
* la base de données
*
* */

class MajorationCrudMainScreen extends StatefulWidget {
  const MajorationCrudMainScreen({Key? key}) : super(key: key);

  @override
  State<MajorationCrudMainScreen> createState() => _MajorationCrudMainScreen();
}

class _MajorationCrudMainScreen extends State<MajorationCrudMainScreen> {

  //Init liste vide qui condiendra nos données
  List<SecondDeep> majorations = [];

  List <Azote> azote = [];


  //Champ vide
  int newDeepValue = 0;
  int newTimeValue = 0;

  Azote currentAzote = Azote(azote: 0);

  //Vérification si les valeurs existent déjà
  bool checkValues(int time, int deep){

    bool exist = false;

    for(SecondDeep s in majorations){
      if(s.time == time && s.deep == deep){
        return true;
      } else {
        exist = false;
      }
    }

    return exist;

  }

  Future<void> getAzote() async {
    List<Azote> a= await AzoteBrain().listAzote();

    setState(() {
      azote = a;
    });
  }

  //Récup des données
  Future<void> getSecondDeep(int id) async {

    List<SecondDeep> m = await SecondDeepBrain().listSecondDeepByAzote(id);

    //Actualisation des données
    setState(() {
       majorations = m;
    });
  }

  //Ajout d'une donnée
  Future<void> addMaj(int prof, int temps) async {
    //Vérif si champ non vide et valide
    if (prof > 0 && prof < 80 && temps > 0 && temps < 300) {
      bool exist = checkValues(temps, prof);
      if(exist == false) {
        //Création d'une nouvelle donnée
        SecondDeep majoration = SecondDeep(
            deep: prof, time: temps, azoteId: currentAzote.id);
        newDeepValue = 0;
        //Insertion d'une nouvelle donnée
        await SecondDeepBrain().insertSecondDeep(majoration);
        //Récupération des données
        getSecondDeep(currentAzote.id);
        //Ecran principal
      } else {
        ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
      }
      Navigator.pop(context);

    }
  }

  //Suppression d'une donnée
  Future<void> deleteMaj(int id) async {

    //Ouverture dialogue de confirmation
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous supprimer cette valeur ?'),
        actions: <Widget>[
          TextButton(
            //Si non, on fait rien, on retire le dialogue
            onPressed: () => Navigator.pop(context, 'Non'),
            child: const Text('Non'),
          ),
          TextButton(
            //Si oui, on supprime, et on actualise les données
            onPressed: () {

              SecondDeepBrain().deleteSecondDeep(id);
              Navigator.pop(context, 'Oui');
              getSecondDeep(currentAzote.id);
            },
            child: const Text('Oui'),
          ),
        ],
      ),
    );
  }

  //Modification d'une donnée
  Future<void> editMaj(SecondDeep m) async {

    bool exist = checkValues(m.time, m.deep);
    if(exist == false) {
      //Modification d'une donnée
      await SecondDeepBrain().updateSecondDeep(m);
      //Actualisation des données
      getSecondDeep(currentAzote.id);
    } else {
      ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
    }
    //Retour à l'écran principal
    Navigator.pop(context);

  }

  List<Widget> getItems() {

    List<Widget> pickerItems = [];

    for (Azote a in azote ) {
      pickerItems.add(
        Align(
          child: Text(
            a.azote.toString(),
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
    for (SecondDeep m in majorations) {
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
                                          "Détails de la majoration",
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
                                                  padding: const EdgeInsets.only(
                                                      left: 20.0, right: 20.0),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        flex: 5,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets.only(
                                                                  bottom: 10.0, top: 15.0),
                                                              child: Text(
                                                                "Profondeur",
                                                                style: TextStyle(
                                                                  color: kDarkBlueTextColor,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ),
                                                            TextFormField(
                                                              enabled: false,
                                                              initialValue: "${m.deep.toString()} mètres",
                                                              keyboardType: const TextInputType.numberWithOptions(
                                                                  decimal: true, signed: true),
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
                                                                m.deep = int.parse(value);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Flexible(
                                                        flex: 5,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets.only(
                                                                  bottom: 10.0, top: 15.0),
                                                              child: Text(
                                                                "Temps additionnel",
                                                                style: TextStyle(
                                                                  color: kDarkBlueTextColor,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ),
                                                            TextFormField(
                                                              enabled: false,
                                                              initialValue: "${m.time.toString()} minutes",
                                                              keyboardType: const TextInputType.numberWithOptions(
                                                                  decimal: true, signed: true),
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
                                                                m.time = int.parse(value);
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
                        //Nom du niveau
                        child: Text(
                          "Profondeur :${m.deep.toString()} - Temps : ${m.time.toString()}",
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
                                              'Modifier la majoration',
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
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.only(
                                                              bottom: 10.0, top: 15.0),
                                                          child: Text(
                                                            "Profondeur (mètres)",
                                                            style: TextStyle(
                                                              color: kDarkBlueTextColor,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          keyboardType: const TextInputType.numberWithOptions(
                                                              decimal: false, signed: true),
                                                          initialValue: m.deep.toString(),
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
                                                            m.deep = int.parse(value);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Flexible(
                                                    flex: 5,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.only(
                                                              bottom: 10.0, top: 15.0),
                                                          child: Text(
                                                            "Temps (minutes)",
                                                            style: TextStyle(
                                                              color: kDarkBlueTextColor,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          keyboardType: const TextInputType.numberWithOptions(
                                                              decimal: false, signed: true),
                                                          initialValue: m.time.toString(),
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
                                                            m.time = int.parse(value);
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
                                                editMaj(m);
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
                            onTap: (){
                              deleteMaj(m.id);
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
    getAzote();
    getSecondDeep(currentAzote.id);
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
              text: "Gestion des majorations",
            ),
            flex: 3,
          ),
          const Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 15.0, bottom: 5.0, left: 50.0, right: 50.0),
              child: Text("Azote résiduel", style: TextStyle(
                color: kDarkBlueTextColor,
                fontSize: 19,
              ),),
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
                   currentAzote = azote[selectedIndex];
                   //print(currentAzote.toMap());

                   getSecondDeep(currentAzote.id);
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
                                'Ajouter une majoration',
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10.0, top: 15.0),
                                            child: Text(
                                              "Profondeur (mètres)",
                                              style: TextStyle(
                                                color: kDarkBlueTextColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: const TextInputType.numberWithOptions(
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
                                              newDeepValue = int.parse(value);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10.0, top: 15.0),
                                            child: Text(
                                              "Temps (minutes)",
                                              style: TextStyle(
                                                color: kDarkBlueTextColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: const TextInputType.numberWithOptions(
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
                                              newTimeValue = int.parse(value);
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
                                  addMaj(newDeepValue, newTimeValue);
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
