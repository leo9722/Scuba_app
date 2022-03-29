import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/model/ProfileBrain.dart';
import 'package:scuba/model/dataClasses.dart';

/*
* Classe ProfileDeleteScreen
*
* Permet la suppression d'un profil
*
* */
class ProfileDeleteScreen extends StatefulWidget {
  const ProfileDeleteScreen({Key? key, required this.profile})
      : super(key: key);

  final Profile profile;

  @override
  State<ProfileDeleteScreen> createState() => _ProfileDeleteScreenState();
}

class _ProfileDeleteScreenState extends State<ProfileDeleteScreen> {

  ProfileBrain profileBrain = ProfileBrain();

  //Suppression d'un profil
  void deleteProfile(Profile profile, context) async {

    int id = profile.id;

    profileBrain.deleteProfile(id);

    Profile randomProfile = await profileBrain.getRandomProfile();
    randomProfile.selected = 1;
    profileBrain.updateProfile(randomProfile);

    Navigator.pop(context);

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
              child: HeaderC(text: "Supprimer votre profil"),
            ),
            Flexible(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Align(
                    child: Text(
                      "Êtes vous sûr de vouloir supprimer votre profil ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Align(
                      child: Text(
                        "Profil actuel : ${widget.profile.name}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Align(
                    child: Text(
                      "(Appuyez longuement sur le boutton pour confirmer)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            Flexible(
              flex: 5,
              child: Center(
                child: GestureDetector(
                  child: Image.asset("images/imgProfileDelete.png"),
                  onLongPress: (){
                    deleteProfile(widget.profile, context);
                  },
                ),
              ),
            ),
            const Spacer(
              flex: 5,
            ),
          ],
        ),
      ),
    );
  }
}
