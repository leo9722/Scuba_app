import 'package:flutter/material.dart';

/*
* Component profileDescSpacerC
*
* Composant utilisé pour séparer les données du profil
*
* */
class ProfileDescSpacerC extends StatelessWidget {
  const ProfileDescSpacerC({Key? key,  required this.height}) : super(key: key);

  final int height;

  @override
  Widget build(BuildContext context) {

    return const Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Divider(color: Colors.white, thickness: 2, height: 0,),
    );
  }
}