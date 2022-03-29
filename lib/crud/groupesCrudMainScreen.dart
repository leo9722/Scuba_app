import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/errorAlertdialog.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/constants.dart';
import 'package:scuba/model/GroupBrain.dart';
import 'package:scuba/model/dataClasses.dart';

/*
* Classe : GroupesCrudMainScreen
*
* Permet la gestion des groupes dans
* la base de données
*
* */
class GroupesCrudMainScreen extends StatefulWidget {
  const GroupesCrudMainScreen({Key? key}) : super(key: key);

  @override
  State<GroupesCrudMainScreen> createState() => _GroupesCrudMainScreenState();
}

class _GroupesCrudMainScreenState extends State<GroupesCrudMainScreen> {

  //Init liste vide qui condiendra nos données
  List<Group> groupes = [];

  //Champ vide
  String newGroupName = "";

  //Vérification si la valeur existe déjà
  bool checkValue(String value){

    bool exist = false;

    for(Group g in groupes){
      if(g.azoteGroup == value){
        return true;
      } else {
        exist = false;
      }
    }

    return exist;

  }
  //Récup des données
  Future<void> getGroupes() async {
    List<Group> g = await GroupBrain().listGroup();
    //print("LENGTH : " + g.length.toString());
    //Actualisation des données
    setState(() {
      groupes = g;
    });
  }

  //Ajout d'une donnée
  Future<void> addGroupe(String name) async {
    //Vérif si champ non vide et valide
    if (name.isNotEmpty && name.length < 2) {
      //Vérif si donnée existe
      bool exist = checkValue(name);
      if(exist == false) {
        //Création d'une nouvelle donnée
        Group newGroup = Group(azoteGroup: name);
        newGroupName = "";
        await GroupBrain().insertGroup(newGroup);

        getGroupes();
      } else {
        ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
      }
      //Ecran principal
      Navigator.pop(context);

    }
  }

  //Suppression d'une donnée
  Future<void> deleteGroupe(int id) async {

    //Ouverture dialogue de confirmation
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous supprimer ce groupe ?'),
        actions: <Widget>[
          TextButton(
            //Si non, on fait rien, on retire le dialogue
            onPressed: () => Navigator.pop(context, 'Non'),
            child: const Text('Non'),
          ),
          TextButton(
            //Si oui, on supprime, et on actualise les données
            onPressed: () {
              GroupBrain().deleteGroup(id);
              Navigator.pop(context, 'Oui');
              getGroupes();
            },
            child: const Text('Oui'),
          ),
        ],
      ),
    );
  }

  //Modification d'une donnée
  Future<void> editGroupes (Group g) async {
    bool exist = checkValue(g.azoteGroup);
    if(exist == false) {
      //Modification d'une donnée
      await GroupBrain().updateGroup(g);
      //Actualisation des données
      getGroupes();
    } else {
      ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
    }
    //Retour à l'écran principal
    Navigator.pop(context);

  }

  //Récupération de la liste des items
  List<Padding> getListViewItems() {

    //Liste de Widgets (ici, des paddings)
    List<Padding> items = [];

    //Pour chaque données, on va créer un widget et l'ajouter à la liste
    for (Group g in groupes) {
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
                                          "Détails du groupe",
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
                                                  "Nouvelle valeur du groupe",
                                                  style: TextStyle(
                                                    color: kDarkBlueTextColor,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              TextFormField(
                                                enabled: false,
                                                initialValue:g.azoteGroup,
                                                maxLines: 1,
                                                maxLength: 1,
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
                                                  newGroupName = value;
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
                        //Nom du niveau
                        child: Text(
                          "Groupe de plongée successive ${g.azoteGroup}",
                          style: const TextStyle(
                            fontSize: 15,
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
                                              "Modifier la valeur d'un groupe",
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
                                                      "Nouvelle valeur",
                                                      style: TextStyle(
                                                        color: kDarkBlueTextColor,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
                                                    initialValue:g.azoteGroup,
                                                    maxLines: 1,
                                                    maxLength: 1,
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
                                                      g.azoteGroup = value;
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
                                                editGroupes(g);
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
                              deleteGroupe(g.id);
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
    getGroupes();
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
              text: "Gestion des groupes",
            ),
            flex: 3,
          ),
          const Spacer(
            flex: 1,
          ),
          //ListeView qui va avoir comme enfant (données) les données retournées par la fonction getListViewItems
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
                                'Ajouter un nouveau groupe',
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
                                        "Nouvelle valeur du groupe",
                                        style: TextStyle(
                                          color: kDarkBlueTextColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
                                      maxLines: 1,
                                      maxLength: 1,
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
                                        newGroupName = value;
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
                                  addGroupe(newGroupName);
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
