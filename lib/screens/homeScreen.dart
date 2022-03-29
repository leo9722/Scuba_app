//import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:im_stepper/stepper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/model/LevelBrain.dart';
import 'package:scuba/model/ProfileBrain.dart';
import 'package:scuba/model/dataClasses.dart';
import 'package:scuba/screens/tutorialScreen.dart';

/*
* Screen : écran d'accueil
* Ecran d'accueil spécifiant le profil sélectionné et son niveau
*
* */
class HomeScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onVisitePage;
  final bool hideStatus;
  const HomeScreen(
      {Key? key,
      required this.menuScreenContext,
      required this.onVisitePage,
      this.hideStatus = false})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Initialisation d'un profil et d'un niveau par défaut
  Profile selectedProfile = Profile(
      speed: 0,
      consommation: 0,
      nbBottle: 0,
      name: " ",
      vRap: 0,
      vRep: 0,
      volume: 0,
      pressure: 0,
      detendor: 0,
      selected: 0,
      levelId: 0);
  Level selectedLevel = Level(level: " ");

  //How R U
  Future<void> playHowRU() async {
    AudioCache().play('hello.wav');
  }

  //Controlleur de refresh
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  //Récupère le profile sélectionné
  void getSelectedProfile() async {
    Profile selected = await ProfileBrain().getSelectedProfile();
    selectedProfile = selected;

    Level level = await LevelBrain().listLevelById(selected.levelId);

    setState(() {
      selectedProfile = selected;
      selectedLevel = level;
    });
  }

  //Refresh (récupération du profil sélectionné)
  void _onRefresh() async {
    getSelectedProfile();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    getSelectedProfile();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
      ),
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        controller: _refreshController,
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
              Flexible(
                flex: 3,
                child: GestureDetector(
                  child: const HeaderC(text: "Accueil"),
                  onLongPress: (){
                    playHowRU();
                  },
                ),
              ),
              const Spacer(
                flex: 2,
              ),
              Flexible(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "~ Scuba Diving ~",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TutorialScreen(),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.info,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 55.0, right: 55.0),
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: Image.asset("images/imgDiver.png"),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Flexible(
                        flex: 4,
                        child: FittedBox(
                          child: Text(
                            selectedProfile.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
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
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: Image.asset("images/level-2.png"),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Flexible(
                        flex: 4,
                        child: FittedBox(
                          child: Text(
                            selectedLevel.level,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(
                flex: 6,
              )
            ],
          ),
        ),
      ),
    );
  }
}
