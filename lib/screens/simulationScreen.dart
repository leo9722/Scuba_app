import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/model/ProfileBrain.dart';
import 'package:scuba/model/calculator.dart';
import 'package:scuba/model/dataClasses.dart';
import 'package:scuba/screens/resultSimulationScreen.dart';
import '../constants.dart';
import '../model/DivingTableBrain.dart';

/*
* Classe SimulationScreen
*
* Permet le calcul et d'une simulation
*
* */

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SimulationScreen createState() => _SimulationScreen();
}

class _SimulationScreen extends State<SimulationScreen> {

  //Initialisation de données par défaut
  List<Profile> profiles = [];
  ProfileBrain profileBrain = ProfileBrain();
  Profile chosenProfile = Profile(speed: 0, consommation: 0, nbBottle: 0, name: "0", vRap: 0, vRep: 0, volume: 0, pressure: 0, detendor: 0, selected: 1, levelId: 0);
  List<DivingTable> tables = [];
  Calculator calculator = Calculator();



  int p3 = 0;
  int p6 = 0;
  int p9 = 0;
  int p12 = 0;
  int p15 = 0;

  double pressureLeft = 0;
  double volumeLeft = 0;

  int selectedIndex = 0;
  int deep = 0;
  int time = 0;
  String dropdownValue = "MN90";

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

  //Récupération des profils
  void getProfiles() async {

    profiles = await profileBrain.listProfile();
    chosenProfile = await profileBrain.getSelectedProfile();

    setState(() {
      profiles;
      chosenProfile;
    });
  }


  //Validation si données valides (temps & profondeur > 0)
  void checkIfItValid(context) {
    bool valid = false;

    chosenProfile = profiles[selectedIndex];
    //print(chosenProfile.toMap());

    if (time != 0 && deep != 0 && dropdownValue.isNotEmpty) {
      if(pressureLeft >= 0 && volumeLeft >= 0){
        valid = true;
      }
    }

    if (valid) {

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ResultSimulationScreen(dTime: time, deep: deep, chosenProfile: chosenProfile, table: dropdownValue, p3: p3, p6: p6, p9: p9, p12: p12, p15: p15, pressureLeft: pressureLeft, volumeLeft: volumeLeft)
        ),
      );
    }
  }

  //Initialisation de la page et récupération des profiles
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
            child: HeaderC(text: "Simulation"),
            flex: 3,
          ), //3 Header
          Flexible(
            flex: 2,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
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
          ), // 3 Fields
          Flexible(
            flex: 2,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
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
                            chosenProfile = profiles[value];
                            selectedIndex = value;
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
          ), //
          const Flexible(
            flex: 1,
            child: Center(
              child: Text(
                "Paliers (en mètres)",
                style: TextStyle(
                  color: kLightGrayTextColor,
                  fontSize: 18,
                ),
              ),
            ),
          ), // 3 P
          Flexible(
            flex: 2,
            child: Padding(
              padding:
              const EdgeInsets.only(left: 15.0, right: 15.0),
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
                              p3 = int.parse(value);
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
                              p6 = int.parse(value);
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
                              p9 = int.parse(value);
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
                              p12 = int.parse(value);
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
                              p15 = int.parse(value);
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
            child: Padding(
              padding:
              const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "Pression restante",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
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
                              pressureLeft = double.parse(value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Flexible(
                    flex: 25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "Volume restant",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
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
                             volumeLeft = double.parse(value);
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
                  // print(chosenProfile.toMap());
                  // print("Profondeur : " +
                  //     deep.toString() +
                  //     " | Temps : " +
                  //     time.toString() +
                  //     " | Table : " +
                  //     getTable(dropdownValue));
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
                    'Simuler',
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
