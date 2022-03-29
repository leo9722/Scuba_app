import 'package:flutter/material.dart';
import 'package:scuba/constants.dart';

/*
* Component ProfileNavItemC
*
* Composant utilisé pour la navigation
* sur la page principale profile (boutons)
*
* */

class ProfileNavItemC extends StatelessWidget {
  const ProfileNavItemC({Key? key, required this.text, required this.onPressed, required this.enabled}) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    double fontSize = 13;

    if(queryData.size.width <= 400){

      fontSize = 10;

    }

    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<
            RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        backgroundColor:
        MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if(enabled){
              return kLightPurpleButtonColor;
            } else {
              return kLightGrayTextColor;
            }
          },
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 15,
          right: 8,
          left: 8,
          top: 15,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
          ),
        ),
      ),
    );

  }

}