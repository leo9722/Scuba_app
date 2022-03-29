import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/components/profileDisplayFieldC.dart';
import 'package:scuba/model/DeepBrain.dart';
import 'package:scuba/model/DivingTableBrain.dart';
import 'package:scuba/model/ProfileBrain.dart';
import 'package:scuba/model/calculator.dart';
import 'package:scuba/model/dataClasses.dart';
import 'package:scuba/screens/resultCalculScreen.dart';
import '../constants.dart';

/*
* Screen : Calcul d'une plongée
*
* Permet le calcul d'une plongée, en fonction de paramètres données
* */
class CalculScreen extends StatefulWidget {
  const CalculScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CalculScreen createState() => _CalculScreen();
}

class _CalculScreen extends State<CalculScreen> {

  //Liste de profiles vide, création d'un profil par défaut
  List<Profile> profiles = [];
  ProfileBrain profileBrain = ProfileBrain();
  Profile chosenProfile = Profile(speed: 0, consommation: 0, nbBottle: 0, name: "0", vRap: 0, vRep: 0, volume: 0, pressure: 0, detendor: 0, selected: 1, levelId: 0);

  //Initialisation du calculateur
  Calculator calculator = Calculator();

  //Liste de tables & profondeurs vides
  List<DivingTable> tables = [];
  List<List<Deep>> deepsByTable = [[]];


  //Initialisation des paramètres
  int selectedIndex = 0;
  int deep = 0;
  int time = 0;
  String dropdownValue = "MN90";

  //Récupération des items pour le cupertino (selecteur) en fonction des profiles
  List<Widget> getItems() {
    List<Widget> pickerItems = [];

    for (Profile profile in profiles) {
      pickerItems.add(
        Container(
          color: Colors.white24,
          child: Align(
            child: Text(
              profile.name,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            alignment: Alignment.center,
          ),
        ),
      );
    }

    return pickerItems;
  }

  //Récupération des profiles
  void getProfiles() async {
    profiles = await profileBrain.listProfile();
    chosenProfile = await profileBrain.getSelectedProfile();

    setState(() {
      profiles;
      chosenProfile;
    });
  }

  Future<void> getDivingTablesAndDeeps() async {

    tables = await DivingTableBrain().listDivingTable();

    // List<Deep> deeps = [];
    //
    // for(DivingTable t in tables){
    //
    //   deeps = await DeepBrain().listDeepByTable(t.id);
    //   deepsByTable.add(deeps);
    //
    // }

  }

  List<String> getTableItems(){

    List<String> tableItems = [];

    for(DivingTable t in tables){
      tableItems.add(t.name);
    }


    return tableItems;
  }

  //Fonction de validation
  void checkIfItValid(context) {
    bool valid = false;

    chosenProfile = profiles[selectedIndex];

    if ((time != 0 && deep != 0) && dropdownValue.isNotEmpty) {
      valid = true;
    }

    //Si les données sont valides, on passe aux résultats
    if (valid) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultCalculScreen(
                chosenProfile: chosenProfile,
                dTime: time,
                deep: deep,
                table: dropdownValue)),
      );
    } else {
      print("Non valide");
    }
  }

  //Initialisation de la page et récupération des profils
  @override
  void initState() {
    super.initState();
    getDivingTablesAndDeeps();
    getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      resizeToAvoidBottomInset: false,
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF32a5ff),
          Color(0xFF334ac9),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Flexible(
            child: HeaderC(text: "Calcul"),
            flex: 3,
          ),
          const Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Flexible(
                    flex: 20,
                    child: Text(
                      "Table de plongée : ",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Flexible(
                    flex: 25,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor: Colors.white10,
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_sharp,
                        color: Colors.white70,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      underline: Container(
                        color: kLightPurpleButtonColor,
                        height: 1,
                      ),
                      value: dropdownValue,
                      items: getTableItems()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ), // 2 Table
          Flexible(
            flex: 3,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "Profondeur (en mètres)",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false, signed: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                              ),
                            ),
                            fillColor: Colors.white30,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white70,
                              ),
                            ),
                            hintText: "0",
                          ),
                          onChanged: (value) {
                            setState(() {
                              deep = int.parse(value);
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
                    flex: 25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "Temps (en minutes)",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false, signed: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            fillColor: Colors.white30,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white70,
                              ),
                            ),
                            hintText: "0",
                          ),
                          onChanged: (value) {
                            setState(() {
                              time = int.parse(value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ), // 3 Fi
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 50,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            selectedIndex = value;
                            chosenProfile = profiles[selectedIndex];
                          });
                        },
                        looping: true,
                        children: getItems(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ), // 3 Profile
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      flex: 3,
                      child: ProfileDisplayFieldC(
                        fieldName: "Volume\n",
                        fieldUnit: "litres",
                        fieldValue: chosenProfile.volume,
                      )),
                  const Spacer(
                    flex: 1,
                  ),
                  Flexible(
                      flex: 3,
                      child: ProfileDisplayFieldC(
                        fieldName: "Pression\n",
                        fieldUnit: "bars",
                        fieldValue: chosenProfile.pressure,
                      )),
                  const Spacer(
                    flex: 1,
                  ),
                  Flexible(
                      flex: 3,
                      child: ProfileDisplayFieldC(
                        fieldName: "Detendeur\n",
                        fieldUnit: "bars",
                        fieldValue: chosenProfile.detendor,
                      )),
                  const Spacer(
                    flex: 1,
                  ),
                  Flexible(
                      flex: 3,
                      child: ProfileDisplayFieldC(
                        fieldName: "Consommation d'air",
                        fieldUnit: "l / min",
                        fieldValue: chosenProfile.consommation,
                      )),
                ],
              ),
            ),
          ), // 2 D
          const Spacer(
            flex: 1,
          ), // isplay 1
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      flex: 3,
                      child: ProfileDisplayFieldC(
                        fieldName: "Bouteilles\n",
                        fieldUnit: "",
                        fieldValue: chosenProfile.nbBottle,
                      )),
                  const Spacer(
                    flex: 1,
                  ),
                  Flexible(
                      flex: 3,
                      child: ProfileDisplayFieldC(
                        fieldName: "Vitesse de descente",
                        fieldUnit: "m / min",
                        fieldValue: chosenProfile.speed,
                      )),
                  const Spacer(
                    flex: 1,
                  ),
                  Flexible(
                      flex: 3,
                      child: ProfileDisplayFieldC(
                        fieldName: "V. remontée avant paliers",
                        fieldUnit: "m / min",
                        fieldValue: chosenProfile.vRap,
                      )),
                  const Spacer(
                    flex: 1,
                  ),
                  Flexible(
                      flex: 3,
                      child: ProfileDisplayFieldC(
                        fieldName: "V. remontée entre paliers",
                        fieldUnit: "m / min",
                        fieldValue: chosenProfile.vRep,
                      )),
                ],
              ),
            ),
          ), //
          Flexible(
            flex: 3,
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return kSubmitButton;
                    },
                  ),
                ),
                onPressed: () {
                  checkIfItValid(context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(
                    bottom: 15,
                    right: 25,
                    left: 25,
                    top: 15,
                  ),
                  child: Text(
                    'Calculer',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ), // 3 Button
          const Spacer(
            flex: 1,
          ), // 1
        ],
      ),
    );
  }
}
