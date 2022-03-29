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
* Classe ProfileEditScreen
*
* Permet la modification d'un profil
*
* */

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final Profile profile;

  @override
  _ProfileEditScreen createState() => _ProfileEditScreen();
}

class _ProfileEditScreen extends State<ProfileEditScreen> {

  //Initialisation d'un profil par défaut, d'un niveau par défaut
  ProfileBrain profileBrain = ProfileBrain();
  List<Level> levels = [];
  Level selectedLevel = Level(level: "Niveau I", id: 0);

  String name = 'Profile 1';
  int volume = 9;
  int pressure = 200;
  int detendor = 200;
  int nbBottle = 1;
  int speed = 10;
  int conso = 10;
  int vRep = 6;
  int vRap = 10;

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

  //Récupération du niveau sélectionné
  Future<void> getSelectedLevel(int id) async {

    Level sl = await LevelBrain().listLevelById(id);
    setState(() {
      selectedLevel = sl;
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

  //Modification d'un profile
  void submitProfile(name, volume, pressure, detendor, nbBottle, conso, speed, vRep, vRap, context) async {

    Profile profile = Profile(id: widget.profile.id, speed: speed, consommation: conso, nbBottle: nbBottle, name: name, vRap: vRap, vRep: vRep, volume: volume, pressure: pressure, detendor: detendor, selected: 1, levelId: selectedLevel.id);

    await profileBrain.updateProfile(profile);

    Navigator.pop(context, true);

  }

  //Réarrangement des niveaux pour que le niveau
  //sélectionné apparraisse en premier
  Future<void> reorderLevels(int id) async {

    List<Level> lvls = await LevelBrain().listLevel();

    Level selLevel = await LevelBrain().listLevelById(id);
    lvls.removeWhere((element) => element.level == selLevel.level);
    lvls.insert(0, selLevel);

    setState(() {
      levels = lvls;
    });
  }

  //Initialisation de la page et récupération des données
  //passée en paramètre
  @override
  void initState(){
    super.initState();
    getLevels();
    getSelectedLevel(widget.profile.levelId);
    reorderLevels(widget.profile.levelId);
    name = widget.profile.name;
    vRap = widget.profile.vRap;
    vRep = widget.profile.vRep;
    volume = widget.profile.volume;
    pressure = widget.profile.pressure;
    detendor = widget.profile.detendor;
    conso = widget.profile.consommation;
    speed = widget.profile.speed;
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
              text: "Modifier votre profil",
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
                    TextFormField(
                      initialValue: widget.profile.name,
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
                        setState(() {
                          name = value;
                        });
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
                            volume = volumePickerItems[value];
                          },
                          itemUnit: "\nLitres",
                          itemName: "Volume\n",
                          defaultItem: widget.profile.volume.toDouble(),
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
                            pressure = pressurePickerItems[value];
                          },
                          itemUnit: "\nBars",
                          itemName: "Pression\n",
                          defaultItem: widget.profile.pressure.toDouble(),
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
                            detendor = detendorPickerItems[value];
                          },
                          itemUnit: "\nBars",
                          itemName: "Détendeur\n",
                          defaultItem: widget.profile.detendor.toDouble(),
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
                            conso = consoPickerItems[value];
                          },
                          itemUnit: "\nl / min",
                          itemName: "Consommation d'air",
                          defaultItem: widget.profile.consommation.toDouble(),
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
                            nbBottle = nbBottlePickerItems[value];
                          },
                          itemUnit: "\nBouteilles",
                          itemName: "Bouteille\n",
                          defaultItem: widget.profile.nbBottle.toDouble(),
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
                            speed = speedPickerItems[value];
                          },
                          itemUnit: "\nm / min",
                          itemName: "Vitesse de descente",
                          defaultItem: widget.profile.speed.toDouble(),
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
                            vRap = vRapPickerItems[value];
                          },
                          itemUnit: "\nm / min",
                          itemName: "V. remontée avant paliers",
                          defaultItem: widget.profile.vRap.toDouble(),
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
                            vRep = vRepPickerItems[value];
                          },
                          itemUnit: "\nm / min",
                          itemName: "V. remontée entre paliers",
                          defaultItem: widget.profile.vRep.toDouble(),
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
                submitProfile(name, volume, pressure, detendor, nbBottle, conso, speed, vRep, vRap, context);
              },
              child: const Padding(
                padding: EdgeInsets.only(
                  bottom: 15,
                  right: 10,
                  left: 10,
                  top: 15,
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
        ],
      ),
    );
  }
}
