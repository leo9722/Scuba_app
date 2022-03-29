import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/components/profileDescSpacerC.dart';
import 'package:scuba/components/profileNavItemC.dart';
import 'package:scuba/components/profileRowC.dart';
import 'package:scuba/constants.dart';
import 'package:scuba/model/LevelBrain.dart';
import 'package:scuba/model/ProfileBrain.dart';
import 'package:scuba/model/dataClasses.dart';
import 'package:scuba/screens/profileCreateScreen.dart';
import 'package:scuba/screens/profileDeleteScreen.dart';
import 'package:scuba/screens/profileEditScreen.dart';
import 'package:scuba/screens/profileHistoryScreen.dart';

/*
* Classe ProfileMainScreen
*
* Affiche les informations sur le profil sélectionné
* avec navigation sur les pages edit, delete et create
* pour un profil
*
* Accès à l'historique du profil sélectionné également
*
* */
class ProfileMainScreen extends StatefulWidget {
  const ProfileMainScreen({Key? key}) : super(key: key);

  @override
  _ProfileMainScreen createState() => _ProfileMainScreen();
}

class _ProfileMainScreen extends State<ProfileMainScreen> {

  //Initialisation de données par défaut
  //Nom, liste des profiles, profile sélectionné, ancien profil sélectionné
  String name = "Bobby de cuba";
  List<Profile> profiles = [];
  Profile selectedProfile = Profile(
      speed: 0,
      consommation: 0,
      nbBottle: 0,
      name: "Loading...",
      vRap: 0,
      vRep: 0,
      volume: 0,
      pressure: 0,
      detendor: 0,
      selected: 0,
      levelId: 0);
  Profile oldProfile = Profile(
      speed: 0,
      consommation: 0,
      nbBottle: 0,
      name: "Loading...",
      vRap: 0,
      vRep: 0,
      volume: 0,
      pressure: 0,
      detendor: 0,
      selected: 0,
      levelId: 0);
  ProfileBrain profileBrain = ProfileBrain();
  int initialItem = 0;
  Level profileLevel = Level(level: "");

  final FixedExtentScrollController _controller =
      FixedExtentScrollController(initialItem: 0);

  //Booléen qui va déterminer l'activation ou non du bouton supprimer
  bool enabled = false;

  //Récupération des noms des profiles pour le cupertino
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

  //Actualisation du profil sélectionné
  void updateSelected(Profile profile) async {
    Profile selectedProfile = await profileBrain.listProfileById(profile.id);

    selectedProfile.selected = 1;
    oldProfile.selected = 0;

    profileBrain.updateProfile(oldProfile);
    profileBrain.updateProfile(selectedProfile);
  }

  //Récupération du profil sélectionné
  void getSelectedProfile() async {
    Profile selected = await profileBrain.getSelectedProfile();
    selectedProfile = selected;

    profileLevel = await LevelBrain().listLevelById(selectedProfile.levelId);

    setState(() {
      selectedProfile = selected;
      profileLevel;
    });
  }

  //Récupération du niveau du profil sélectionné
  void getSelectedLevel(int id) async {
    Level pl = await LevelBrain().listLevelById(id);

    setState(() {
      profileLevel = pl;
    });
  }

  //Récupération de tous les profiles
  void getProfiles() async {

    profiles = await profileBrain.listProfile();
    Profile selected = await profileBrain.getSelectedProfile();
    profileLevel = await LevelBrain().listLevelById(selected.levelId);
    selectedProfile = selected;

    //Activation du bouton supprimer si au moins 2 profils
    if (profiles.length == 1) {
      enabled = false;
    } else {
      enabled = true;
    }
  }

  //Récupération de l'item initial pour le cupertino
  //ici, le profil sélectionné
  int getInitialItem() {
    initialItem = 0;
    for (var profile in profiles) {
      if (profile.selected != 1) {
        initialItem++;
      }
    }

    setState(() {
      initialItem;
    });

    _controller.jumpToItem(initialItem);
    return initialItem;
  }

  //Initialisation de la page et récupération des données
  @override
  void initState() {
    super.initState();
    getProfiles();
    getSelectedProfile();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
      ),
      child: ScaffoldGradientBackground(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Flexible(
              flex: 3,
              child: HeaderC(text: "Votre profil"),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 17,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const FittedBox(
                              child: Text(
                                "Changer mon profil actuel",
                                style: TextStyle(
                                  color: kLightGrayTextColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: CupertinoPicker(
                                scrollController: _controller,
                                itemExtent: 50.0,
                                looping: true,
                                onSelectedItemChanged: (selectedIndex) {
                                  setState(
                                    () {
                                      oldProfile = selectedProfile;
                                      selectedProfile = profiles[selectedIndex];
                                      getSelectedLevel(selectedProfile.levelId);
                                      updateSelected(selectedProfile);
                                    },
                                  );
                                },
                                children: getItems(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        flex: 3,
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                 ProfileHistoryScreen(selectedProfile: selectedProfile),
                              ),
                            ).then((_) {
                              setState(() {
                                profiles = [];
                                getProfiles();
                                getSelectedProfile();
                                getInitialItem();
                              });
                            });
                          },
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.history_toggle_off_outlined,
                            color: kDarkBlueTextColor,
                            size: 35,
                          ),
                        ),
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
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    children: [
                      const ProfileDescSpacerC(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: ProfileNavItemC(
                              text: "Ajouter",
                              enabled: true,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileCreateScreen(),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    profiles = [];
                                    getProfiles();
                                    getSelectedProfile();
                                    getInitialItem();
                                  });
                                });
                              },
                            ),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 8,
                            child: ProfileNavItemC(
                              enabled: true,
                              text: "Modifier",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileEditScreen(
                                        profile: selectedProfile),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    profiles = [];
                                    getProfiles();
                                    getSelectedProfile();
                                  });
                                });
                              },
                            ),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 8,
                            child: ProfileNavItemC(
                              enabled: enabled,
                              text: "Supprimer",
                              onPressed: () {
                                if (enabled) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileDeleteScreen(
                                          profile: selectedProfile),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      profiles = [];
                                      getProfiles();
                                      getSelectedProfile();
                                    });
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const ProfileDescSpacerC(height: 2),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: ProfileRowC(
                          tooltipText: "Niveau de plongée",
                          infoText: "Niveau",
                          value: profileLevel.level,
                          unit: ""),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileDescSpacerC(height: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: ProfileRowC(
                          tooltipText: "Volume d'air dans la bouteille",
                          infoText: "Volume d'air",
                          value: selectedProfile.volume.toDouble().toString(),
                          unit: "litres"),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileDescSpacerC(height: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileRowC(
                          tooltipText: "Pression de la bouteille",
                          infoText: "Pression",
                          value: selectedProfile.pressure.toDouble().toString(),
                          unit: "bars"),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileDescSpacerC(height: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileRowC(
                          tooltipText: "Tarage du détendeur",
                          infoText: "Tarage du détendeur",
                          value: selectedProfile.detendor.toDouble().toString(),
                          unit: "bars"),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileDescSpacerC(height: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileRowC(
                          tooltipText: "Vitesse de descente",
                          infoText: "Vitesse de descente",
                          value: selectedProfile.speed.toDouble().toString(),
                          unit: "m/min"),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileDescSpacerC(height: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileRowC(
                          tooltipText: "Consommation d'air",
                          infoText: "Consommation d'air",
                          value: selectedProfile.consommation
                              .toDouble()
                              .toString(),
                          unit: "l/m"),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileDescSpacerC(height: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileRowC(
                          tooltipText: "Nombre de bouteilles",
                          infoText: "Nombre de bouteilles",
                          value: selectedProfile.nbBottle.toDouble().toString(),
                          unit: ""),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileDescSpacerC(height: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileRowC(
                          tooltipText: "Vitesse de remontée avant paliers",
                          infoText: "Vitesse de remontée avant paliers",
                          value: selectedProfile.vRap.toDouble().toString(),
                          unit: "m/min"),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileDescSpacerC(height: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: ProfileRowC(
                          tooltipText: "Vitesse de remontée entre paliers",
                          infoText: "Vitesse de remontée entre paliers",
                          value: selectedProfile.vRep.toDouble().toString(),
                          unit: "m/min"),
                    ),
                  ],
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
  }
}
