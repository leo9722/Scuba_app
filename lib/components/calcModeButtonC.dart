import 'package:flutter/material.dart';
import '../constants.dart';

/*
* Component CalcModeButton
*
* Composant utilisé pour les modes de calculs
* Représente un bouton-image
*
* */

class CalcModeButton extends StatelessWidget {

  const CalcModeButton(
      {Key? key, required this.text, required this.image, required this.onTap})
      : super(key: key);

  final String text;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(350, 115),
          primary: kLightGrayTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
          child: Column(
            children: [
              const Spacer(
                flex: 1,
              ),
              Flexible(
                flex: 3,
                child: FittedBox(
                  child: Text(
                    text,
                    style:
                        const TextStyle(fontSize: 20, color: kDarkBlueTextColor),
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              Flexible(
                flex: 3,
                child: Image.asset(image),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
