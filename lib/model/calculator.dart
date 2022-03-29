import 'dart:core';
import 'package:scuba/model/dataClasses.dart';

/*
* Classe Calculator
* Permet le calcul d'une plongée
*
* */

class Calculator {

  //Récupération de la liste des paliers existants
  List<int> getPaliers(Time temps, int deep) {
    List<int> paliers = [];

    if (temps.p15 != 0) {
      paliers = [15, 15, 12, 12, 9, 9, 6, 6, 3, 3, 0];
    } else if (temps.p12 != 0) {
      paliers = [12, 12, 9, 9, 6, 6, 3, 3, 0];
    } else if (temps.p9 != 0) {
      paliers = [9, 9, 6, 6, 3, 3, 0];
    } else if (temps.p6 != 0) {
      paliers = [6, 6, 3, 3, 0];
    } else if (temps.p3 != 0) {
      paliers = [3, 3, 0];
    }

    return paliers;
  }

  //Calcul du volume consommé
  double getVolumeConso(double respiration, double temps, double pressure) {
    double volume = respiration * temps * pressure;
    return volume.roundToDouble();
  }

  //Calcul du volume restant
  double getVolumeLeft(double volumeRestant, double volumeConso) {
    //print("Vol rest : " + volumeRestant.toString() + " Vol conso : " + volumeConso.toString());
    return (volumeRestant - volumeConso).roundToDouble();
  }

  //Calcul de la pression restante
  double getPressureLeft(double pressionRestante, double pressionConso) {
    return (pressionRestante - pressionConso).roundToDouble();
  }

  //Pression médiane, si phase de descente / montée
  double medianPressure(int profondeur) {
    double pressionMediane = 1 + profondeur / 20;
    return pressionMediane;
  }

  //Calcul de la pression
  double getPressure(int profondeur) {
    double pressure = 1 + profondeur / 10;
    return pressure;
  }

  //Récupération des temps pour les paliers existants
  List<int> getTempsPaliers(Time temps) {
    List<int> tempsPaliers = [];

    if (temps.p15 != 0) {
      tempsPaliers = [temps.p15, 0, temps.p12, 0, temps.p9, 0, temps.p6, 0, temps.p3, 0];
    } else if (temps.p12 != 0) {
      tempsPaliers = [temps.p12, 0, temps.p9, 0, temps.p6, 0, temps.p3, 0];
    } else if (temps.p9 != 0) {
      tempsPaliers = [temps.p9, 0, temps.p6, 0, temps.p3, 0];
    } else if (temps.p6 != 0) {
      tempsPaliers = [temps.p6, 0, temps.p3, 0];
    } else if (temps.p3 != 0) {
      tempsPaliers = [temps.p3, 0];
    }

    return tempsPaliers;
  }

  //Calcul de la respiration : respiration possible ou non
  // en fonction de la pression restante et du détendeur
  bool getBreath(int detendor, double pressureLeft){

    return pressureLeft > detendor ? true : false;

  }

  /*
  * Pour chaque niveau :
  * Descente / Remontée ? (bool)
  *   => pression mediane ou non
  *
  * Pression conso
  * Volume conso
  *
  * MAJ Pression,volume,temps tot
  *
  * Append divingInfo
  * */

  //Calcul de toutes les informations en utilisant les fonctions
  //écrites au dessus
  DivingResults divingCalculator(int profondeur, Time temps, Profile profile) {

    //Récupération des données initiales
    double respiration = profile.consommation.toDouble(); //Volume respiration
    double vDescente = profile.speed.toDouble(); //Vitesse descente
    double vRAP = profile.vRap.toDouble(); //Vitesse remontée avant paliers
    double vREP = profile.vRep.toDouble(); //Vitesse remontée entre paliers
    bool breath = true;


    //print("Vrep : " + vREP.toString() + " Vrap : " + vRAP.toString());

    //Initialisation des données
    List<DivingInfo> infosDiving = [];
    List<DivingInfo> infosPaliers = [];

    double pression = profile.pressure.toDouble();
    double volume = profile.volume.toDouble() * profile.nbBottle;
    double pressionRestante = profile.pressure.toDouble();
    double volumeConso = 0.0;
    double volumeRestant = profile.volume.toDouble() * profile.pressure.toDouble();
    double pressionMediane = 0.0;
    double tempsTotal = 0;
    double tempsR = 0;

    breath = getBreath(profile.detendor, pressionRestante);

    List<int> paliers = [];
    paliers = getPaliers(temps, profondeur);
    List<int> tempsPaliers = [];
    tempsPaliers = getTempsPaliers(temps);

    infosDiving.add(DivingInfo(currentDeep: 0,
        volumeLeft: volumeRestant,
        volumeConso: 0,
        pressureLeft: pressionRestante,
        pressureConso: 0,
        time: 0,
        totalTime: tempsTotal, breath: breath));


    //Descente
    //print("Paliers : " + paliers.toString());

    double tempsDescente = profondeur / vDescente;
    double consoDescente = getVolumeConso(
        respiration, tempsDescente, medianPressure(profondeur)).roundToDouble();
    //print("Temps descente : " + tempsDescente.toString() + " | Conso descente : " + consoDescente.toString());

    tempsTotal += tempsDescente;
    volumeRestant = getVolumeLeft(volumeRestant, consoDescente);
    double pressionConso = (volumeRestant / volume).roundToDouble();
    pressionRestante = getPressureLeft(pressionRestante, pressionConso);
    breath = getBreath(profile.detendor, pressionConso);
    //print("Breath : " + breath.toString() + " | Pr : " + pressionRestante.toString());

    infosDiving.add(DivingInfo(currentDeep: profondeur,
        volumeLeft: volumeRestant,
        volumeConso: consoDescente,
        pressureLeft: pressionConso,
        pressureConso: pressionRestante,
        time: tempsDescente,
        totalTime: tempsTotal, breath: breath));

    // print("Descente");
    // print("Pression restante : " + pressionRestante.toString());
    // print("Pression conso : " + pressionConso.toString());


    //Pronfondeur
    double consoProfondeur = getVolumeConso(
        respiration, (temps.time - tempsDescente), getPressure(profondeur));
    //print("Temps au fond : " + (temps.time - tempsDescente).toString() + " | Conso au fond : " + consoProfondeur.toString());

    tempsTotal = temps.time.toDouble();
    volumeRestant = getVolumeLeft(volumeRestant, consoProfondeur);
    pressionConso = (volumeRestant / volume).roundToDouble();
    pressionRestante = getPressureLeft(pressionRestante, pressionConso);
    breath = getBreath(profile.detendor, pressionConso);

    infosDiving.add(DivingInfo(currentDeep: profondeur,
        volumeLeft: volumeRestant,
        volumeConso: consoProfondeur,
        pressureLeft: pressionRestante,
        pressureConso: pressionConso,
        time: temps.time - tempsDescente,
        totalTime: tempsTotal, breath: breath));
    //
    // print("Au fond");
    // print("Pression restante : " + pressionRestante.toString());
    // print("Pression conso : " + pressionConso.toString());



    //Remontée avant palier
    if (tempsPaliers.isNotEmpty) {

      //print("Paliers");

      double tempsRemonteePremierPalier = (profondeur - paliers[0]) / vRAP;
      double consoRemonteePremierPalier = getVolumeConso(
          respiration, tempsRemonteePremierPalier,
          medianPressure(profondeur - paliers[0]));

      tempsTotal += tempsRemonteePremierPalier;
      volumeRestant = getVolumeLeft(volumeRestant, consoRemonteePremierPalier);
      pressionConso = (volumeRestant / volume).roundToDouble();
      pressionRestante = getPressureLeft(pressionRestante, pressionConso);
      breath = getBreath(profile.detendor, pressionConso);

      infosDiving.add(DivingInfo(currentDeep: profondeur ~/ 2,
          volumeLeft: volumeRestant,
          volumeConso: consoRemonteePremierPalier,
          pressureLeft: pressionConso,
          pressureConso: pressionRestante,
          time: tempsRemonteePremierPalier,
          totalTime: tempsTotal,breath: breath));

      // print("Avant palier");
      // print("Pression restante : " + pressionRestante.toString());
      // print("Pression conso : " + pressionConso.toString());

      //print("Temps remontée premier palier : " + tempsRemonteePremierPalier.toString() + " | Conso remontée premier palier : " + consoRemonteePremierPalier.toString());

      //Paliers
      // print("Paliers");
      for (int i = 0; i < paliers.length - 1; i++) {
        if (i % 2 != 0) {
          //print("Descente / Remontee : " + paliers[i].toString() + " -> " + paliers[i + 1].toString());
          pressionMediane = medianPressure(paliers[i]);
          tempsR = (paliers[i] - paliers[i + 1]) / vREP;
          //print("TempsR : " + tempsR.toString());
          volumeConso = getVolumeConso(respiration, tempsR, pressionMediane);
          volumeRestant = getVolumeLeft(volumeRestant, volumeConso);
          pressionRestante = (volumeRestant / volume).roundToDouble();
          tempsTotal += tempsR;
          breath = getBreath(profile.detendor, pressionRestante);

          infosPaliers.add(DivingInfo(currentDeep: paliers[i],
              volumeLeft: volumeRestant,
              volumeConso: volumeConso,
              pressureLeft: pressionRestante,
              pressureConso: pressionConso,
              time: tempsR,
              totalTime: tempsTotal,breath: breath));


          // print("Pression restante : " + pressionRestante.toString());
          // print("Pression conso : " + pressionConso.toString());

          //print("Volume consommé : " + volumeConso.toString());
          //print("Pression médiane : " + pressionMediane.toString());
        } else {
          //print("Statique : " + paliers[i].toString() + " pendant : " + tempsPaliers[i].toString());

          pression = getPressure(paliers[i]);
          volumeConso = getVolumeConso(respiration, tempsPaliers[i].toDouble(), pression);
          volumeRestant = getVolumeLeft(volumeRestant, volumeConso);
          pressionRestante = (volumeRestant / volume).roundToDouble();
          tempsTotal += tempsPaliers[i];
          breath = getBreath(profile.detendor, pressionRestante);

          infosPaliers.add(DivingInfo(currentDeep: paliers[i],
              volumeLeft: volumeRestant,
              volumeConso: volumeConso,
              pressureLeft: pressionRestante,
              pressureConso: pressionConso,
              time: tempsPaliers[i].toDouble(),
              totalTime: tempsTotal,breath: breath));


          // print("Pression restante : " + pressionRestante.toString());
          // print("Pression conso : " + pressionConso.toString());

          //print("Volume consommé : " + volumeConso.toString());
          //print("Pression médiane : " + pression.toString());
        }
      }

    } else {

      //print("Pas de paliers");

      double tempsRemonteePremierPalier = (profondeur) / vRAP;
      double consoRemonteePremierPalier = getVolumeConso(
          respiration, tempsRemonteePremierPalier,
          medianPressure(profondeur));

      tempsTotal += tempsRemonteePremierPalier;
      volumeRestant = getVolumeLeft(volumeRestant, consoRemonteePremierPalier);
      pressionConso = (volumeRestant / volume).roundToDouble();
      pressionRestante = getPressureLeft(pressionRestante, pressionConso);
      breath = getBreath(profile.detendor, pressionConso);

      infosDiving.add(DivingInfo(currentDeep: profondeur ~/ 2,
          volumeLeft: volumeRestant,
          volumeConso: consoRemonteePremierPalier,
          pressureLeft: pressionRestante,
          pressureConso: pressionConso,
          time: tempsRemonteePremierPalier,
          totalTime: tempsTotal,breath: breath));
    }

    breath = getBreath(profile.detendor, pressionConso);

    infosPaliers.add(DivingInfo(currentDeep: 0,
        volumeLeft: volumeRestant,
        volumeConso: volumeConso,
        pressureLeft: pressionRestante,
        pressureConso: pressionConso,
        time: -1,
        totalTime: tempsTotal,breath: breath));

    infosDiving.add(DivingInfo(currentDeep: 0,
        volumeLeft: volumeRestant,
        volumeConso: volumeConso,
        pressureLeft: pressionRestante,
        pressureConso: pressionConso,
        time: -1,
        totalTime: tempsTotal, breath: breath));


    return DivingResults(infoDiving: infosDiving,
        infoPaliers: infosPaliers,
        initPressure: pression,
        totalTime: tempsTotal,
        finalPressure: pressionRestante,
        finalVolume: volumeRestant,
        initVolume: volume);

  }
}