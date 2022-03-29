import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/components/profileItemSelectionC.dart';
import 'package:scuba/model/LevelBrain.dart';
import 'package:scuba/model/ProfileBrain.dart';
import 'package:scuba/model/dataClasses.dart';
import '../constants.dart';

/*
* Classe ProfileCreateScreen
*
* Permet la création d'un profil
*
* */
class ProfileCreateScreen extends StatefulWidget {
  const ProfileCreateScreen({Key? key,}) : super(key: key);

  @override
  _ProfileCreateScreen createState() => _ProfileCreateScreen();
}

class _ProfileCreateScreen extends State<ProfileCreateScreen> {

  //Initialisation d'un profil par défaut, d'un niveau par défaut
  ProfileBrain profileBrain = ProfileBrain();
  Profile newProfile = Profile(speed: 20, consommation: 20, nbBottle: 1, name: "Default profile", vRap: 10, vRep: 6, volume: 9, pressure: 100, detendor: 5, selected: 1, levelId: 0);
  List<Level> levels = [];
  Level selectedLevel = Level(level: "Niveau I");

  //Valeurs pour les cupertinos 
  List volumePickerItems = [9, 12, 15, 18];
  List pressurePickerItems = [100, 150, 200, 250, 300, 500];
  List detendorPickerItems = [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
  List nbBottlePickerItems = [1,2];
  List speedPickerItems = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50];
  List consoPickerItems = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30];
  List vRapPickerItems = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30];
  List vRepPickerItems = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];

  //Récupération de l'index sélectionné pour les cupertinos
  int getPickerIndex(value) {
    return value;
  }

  //Récupération des niveaux
  Future<void> getLevels() async {

    List<Level> lvls = await LevelBrain().listLevel();
    setState(() {
      levels = lvls;
    });
  }

  //Récupération des items pour les cupertinos
  List<Widget> getItems() {

    List<Widget> pickerItems = [];

    for (Level l in levels) {
      pickerItems.add(
        Container(
          color: Colors.white24,
          child: Align(
            child: Text(
              l.level,
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


  //Ajout du profil
  void submitProfile(context) async {

    Profile selectedProfile = await profileBrain.getSelectedProfile();
    selectedProfile.selected = 0;

    await profileBrain.updateProfile(selectedProfile);
    await profileBrain.insertProfile(newProfile);

    Navigator.pop(context, true);

  }

  //Initialisation de la page et récupération des niveaux
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
        begin: Alignment.topCenter,
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
              text: "Ajouter un profil",
            ),
            flex: 3,
          ),
          const Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 3,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        "Nom du profil",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    TextField(
                      maxLines: 1,
                      maxLength: 15,
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
                        hintText: "...",
                      ),
                      onChanged: (value) {
                        newProfile.name = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        "Niveau",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    CupertinoPicker(
                      itemExtent: 50.0,
                      looping: true,
                      onSelectedItemChanged: (selectedIndex) {
                        setState(() {
                          selectedLevel = levels[selectedIndex];
                          newProfile.levelId = selectedLevel.id;
                        });
                      },
                      children: getItems(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 7,
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 4,
                        child: ProfileItemSelectionC(
                          onChange: (value) {
                            newProfile.volume = volumePickerItems[value];
                          },
                          itemUnit: "\nLitres",
                          itemName: "Volume\n",
                          defaultItem: 9.0,
                          pickerItems: volumePickerItems,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Flexible(
                        flex: 4,
                        child: ProfileItemSelectionC(
                          onChange: (value) {
                            newProfile.pressure = pressurePickerItems[value];
                          },
                          itemUnit: "\nBars",
                          itemName: "Pression\n",
                          defaultItem: 100.0,
                          pickerItems: pressurePickerItems,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Flexible(
                        flex: 4,
                        child: ProfileItemSelectionC(
                          onChange: (value) {
                            newProfile.detendor = detendorPickerItems[value];
                          },
                          itemUnit: "\nBars",
                          itemName: "Détendeur\n",
                          defaultItem: 5.0,
                          pickerItems: detendorPickerItems,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Flexible(
                        flex: 4,
                        child: ProfileItemSelectionC(
                          onChange: (value) {
                            newProfile.consommation = consoPickerItems[value];
                          },
                          itemUnit: "\nl / min",
                          itemName: "Consomation d'air",
                          defaultItem: 20.0,
                          pickerItems: consoPickerItems,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 4,
                        child: ProfileItemSelectionC(
                          onChange: (value) {
                            newProfile.nbBottle = nbBottlePickerItems[value];
                          },
                          itemUnit: "\nBouteilles",
                          itemName: "Bouteille\n",
                          defaultItem: 1.0,
                          pickerItems: nbBottlePickerItems,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Flexible(
                        flex: 4,
                        child: ProfileItemSelectionC(
                          onChange: (value) {
                            newProfile.speed = speedPickerItems[value];
                          },
                          itemUnit: "\nm / min",
                          itemName: "Vitesse de descente",
                          defaultItem: 20.0,
                          pickerItems: speedPickerItems,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Flexible(
                        flex: 4,
                        child: ProfileItemSelectionC(
                          onChange: (value) {
                            newProfile.vRap = vRapPickerItems[value];
                          },
                          itemUnit: "\nm / min",
                          itemName: "V. remontée avant paliers",
                          defaultItem: 10.0,
                          pickerItems: vRapPickerItems,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Flexible(
                        flex: 4,
                        child: ProfileItemSelectionC(
                          onChange: (value) {
                            newProfile.vRep = vRepPickerItems[value];
                          },
                          itemUnit: "\nm / min",
                          itemName: "V. remontée entre paliers",
                          defaultItem: 6.0,
                          pickerItems: vRepPickerItems,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return kLightPurpleButtonColor;
                  },
                ),
              ),
              onPressed: (){
                submitProfile(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(
                  bottom: 15,
                  right: 10,
                  left: 10,
                  top: 15,
                ),
                child: Text(
                  'Valider',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

