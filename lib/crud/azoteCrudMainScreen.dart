import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/errorAlertdialog.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/constants.dart';
import 'package:scuba/model/AzoteBrain.dart';
import 'package:scuba/model/dataClasses.dart';

/*
* Classe : AzoteCrudMainScreen
*
* Permet la gestion du l'azote dans
* la base de données
*
* */
class AzoteCrudMainScreen extends StatefulWidget {
  const AzoteCrudMainScreen({Key? key}) : super(key: key);

  @override
  State<AzoteCrudMainScreen> createState() => _AzoteCrudMainScreenState();
}

class _AzoteCrudMainScreenState extends State<AzoteCrudMainScreen> {

  //Init liste vide qui condiendra nos données
  List<Azote> azotes = [];

  //Champ vide
  double newAzoteVal = 0;

  //Récup des données
  Future<void> getAzote() async {
    List<Azote> a = await AzoteBrain().listAzote();

    //Actualisation des données
    setState(() {
      azotes = a;
    });
  }

  //Vérification si la valeur existe déjà
  bool checkValue(double value){

    bool exist = false;

    for(Azote a in azotes){
      if(a.azote == value){
        return true;
      } else {
        exist = false;
      }
    }

    return exist;

  }

  //Ajout d'une donnée
  Future<void> addAzote(double value) async {
    //Vérif si champ non vide et valide
    if (value > 0 && value < 4) {
      //Vérification si la valeur existe déjà
      bool exist = checkValue(newAzoteVal);
      if(exist == false) {
        //Création d'une nouvelle donnée
        Azote newAzote = Azote(azote: newAzoteVal);
        newAzoteVal = 0;
        await AzoteBrain().insertAzote(newAzote);

        getAzote();
      } else {
        ErrorAlertDialog().alertDialog(context, "Cette donnée existe déjà");
      }
      //retour ecran principal
      Navigator.pop(context);

    }
  }

  //Suppression d'une donnée
  Future<void> deleteAzote(int id) async {

    //Ouverture dialogue de confirmation
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous supprimer cet azote ?'),
        actions: <Widget>[
          TextButton(
            //Si non, on fait rien, on retire le dialogue
            onPressed: () => Navigator.pop(context, 'Non'),
            child: const Text('Non'),
          ),
          TextButton(
            //Si oui, on supprime, et on actualise les données
            onPressed: () {
            AzoteBrain().deleteAzote(id);
              Navigator.pop(context, 'Oui');
              getAzote();
            },
            child: const Text('Oui'),
          ),
        ],
      ),
    );
  }

  //Modification d'une donnée
  Future<void> editAzote (Azote a) async {
    //Modification d'une donnée
    bool exist = checkValue(a.azote);
    if(exist == false) {
      await AzoteBrain().updateAzote(a);
      getAzote();
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
    for (Azote a in azotes) {
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
                                          "Détails de l'azote",
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
                                                  "Nouvelle Valeur d'azote",
                                                  style: TextStyle(
                                                    color: kDarkBlueTextColor,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              TextFormField(
                                                keyboardType: const TextInputType.numberWithOptions(
                                                    decimal: true, signed: true),
                                                enabled: false,
                                                initialValue:a.azote.toString(),
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
                                                  newAzoteVal = double.parse(value);
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
                         a.azote.toString(),
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
                                              "Modifier une valeur d'azote",
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
                                                      "Nouvelle Valeur",
                                                      style: TextStyle(
                                                        color: kDarkBlueTextColor,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    keyboardType: const TextInputType.numberWithOptions(
                                                        decimal: true, signed: true),
                                                    initialValue:a.azote.toString(),
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
                                                     a.azote = double.parse(value);
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
                                                editAzote(a);
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
                              deleteAzote(a.id);
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
              text: "Gestion de l'azote",
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
                                'Ajouter une nouvelle valeur',
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
                                        "Nouvelle valeur d'azote",
                                        style: TextStyle(
                                          color: kDarkBlueTextColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      keyboardType: const TextInputType.numberWithOptions(
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
                                        newAzoteVal = double.parse(value);
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
                                  addAzote(newAzoteVal);
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
