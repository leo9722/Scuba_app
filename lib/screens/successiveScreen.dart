import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/components/profileDisplayFieldC.dart';
import 'package:scuba/model/ProfileBrain.dart';
import 'package:scuba/model/calculator.dart';
import 'package:scuba/model/dataClasses.dart';
import 'package:scuba/screens/resultSuccessiveScreen.dart';
import '../constants.dart';
import '../model/DivingTableBrain.dart';

/*
* Classe SuccessiveScreen
*
* Permet le calcul d'une plongée successive
*
* */
class SuccessiveScreen extends StatefulWidget {
  const SuccessiveScreen({
    Key? key, required this.time, required this.group
  }) : super(key: key);

  final Time time;
  final String group;

  @override
  _SuccessiveScreen createState() => _SuccessiveScreen();
}

class _SuccessiveScreen extends State<SuccessiveScreen> {

  //Initialisation des données
  List<Profile> profiles = [];
  ProfileBrain profileBrain = ProfileBrain();
  Profile chosenProfile = Profile(speed: 0, consommation: 0, nbBottle: 0, name: "0", vRap: 0, vRep: 0, volume: 0, pressure: 0, detendor: 0, selected: 1, levelId: 0);
  Calculator calculator = Calculator();
  List<DivingTable> tables = [];
  int selectedIndex = 0;
  int deep = 0;
  int dTime = 0;
  int intervalle = 0;
  String dropdownValue = "MN90";
  TimeOfDay defaultTime = const TimeOfDay(hour: 1, minute: 30);
  TimeOfDay picked = const TimeOfDay(hour: 1, minute: 30);

  //Récupération des items pour le cupertino
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

  //Récupération des profiles
  void getProfiles() async {
    profiles = await profileBrain.listProfile();
    chosenProfile = await profileBrain.getSelectedProfile();

    setState(() {
      profiles;
      chosenProfile;
    });
  }

  //Validation des données
  void checkIfItValid(context) {
    bool valid = false;

    chosenProfile = profiles[selectedIndex];
    //print(chosenProfile.toMap());
    intervalle = picked.hour * 60 + picked.minute;

    if ((dTime != 0 && deep != 0) && dropdownValue.isNotEmpty) {
      valid = true;
    }

    if (valid) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultSuccessiveScreen(deep: deep, chosenProfile: chosenProfile, table: dropdownValue,
              group: widget.group, itTime: intervalle, dTime: dTime,),
        )
      );
    }
  }

  //Sélection d'un intervalle
  Future<void> selectTime(BuildContext context) async {
    picked = (await showTimePicker(
      context: context,
      initialTime: defaultTime,
      confirmText: "Valider",
      cancelText: "Annuler",
      helpText: "",
      minuteLabelText: "Minutes",
      hourLabelText: "Heures",
      initialEntryMode: TimePickerEntryMode.input,
    ))!;

    setState(() {

      defaultTime = picked;
      intervalle = picked.hour * 60 + picked.minute;

    });

  }

  //Initialisation de la page
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
            child: HeaderC(text: "Plongée successive"),
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
                              "Profondeur (m)",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
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
                    flex: 3,
                  ),
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
                              "Temps (min)",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
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
                              dTime = int.parse(value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  Flexible(
                    flex: 25,
                    child: GestureDetector(
                      onTap: (){
                        selectTime(context);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                "Intervalle",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
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
                            decoration: InputDecoration(
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                              fillColor: Colors.white30,
                              filled: true,
                              enabled: false,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white70,
                                ),
                              ),
                              hintText: "0",
                              label: Text(
                                "${picked.hour} h ${picked.minute} m",
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                intervalle = int.parse(value);
                              });
                            },
                          ),
                        ],
                      ),
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
