import 'dart:html';
//import 'package:warships/warships.dart';

String id;
Element tabelle = querySelector("#T1");

void main() {




 // querySelector("#T1").style.visibility="hidden";
  querySelector("#T1").style.display="none";
  querySelector("#level_1").onClick.listen(changeVisability);

  int anzahl = 3;
/*
  Objekt powerup = new Objekt("powerup", "powerup.png");
  Objekt nebel = new Objekt("nebel", "images/nebel.png");
  Objekt nebel_getroffen_rot = new Objekt("nebel_getroffen_rot", "images/nebel_getroffen_rot.png");
  Objekt powerup_nebel = new Objekt("powerup_nebel", "images/power_nebel.png");
  Objekt powerup_nebel_rot = new Objekt("powerup_nebel_rot", "images/powerup_nebel_rot.png");
  Objekt powerup_nebel_weiss = new Objekt("powerup_nebel_weiss", "images/powerup_nebel_weiss.png");
  Objekt powerup_wasser = new Objekt("powerup_wasser", "images/power_wasser.png");
  Objekt powerup_wasser_rot = new Objekt("powerup_wasser_rot", "images/powerup_wasser_rot.png");
  Objekt powerup_wasser_weiss = new Objekt("powerup_wasser_weiss", "images/powerup_wasser_weiss.png");

  Objekt wasser = new Objekt("wasser", "images/wasser.png");
  Objekt wasser_getroffen_weiss = new Objekt("wasser_getroffen_weiss", "images/wasser_getroffen_weiss.png");

  Objekt schiff_mitte_vertikal = new Objekt("schiff_mitte_vertikal", "images/schiff_mitte_vertikal.png");
  Objekt felsen = new Objekt("felsen", "test");


  Feld A0 = new Feld("A0", false, false, wasser);
  Feld A1 = new Feld("A1", false, false, wasser);
  Feld A2 = new Feld("A2", false, false, wasser);
  Feld A3 = new Feld("A3", false, false, wasser);
  Feld A4 = new Feld("A4", false, false, wasser);
  Feld A5 = new Feld("A5", false, false, wasser);
  Feld A6 = new Feld("A6", false, false, wasser);
  Feld A7 = new Feld("A7", false, false, wasser);
  Feld A8 = new Feld("A8", false, false, wasser);

  Feld B0 = new Feld("B0", false, false, wasser);
  Feld B1 = new Feld("B1", false, false, wasser);
  Feld B2 = new Feld("B2", false, false, wasser);
  Feld B3 = new Feld("B3", false, false, wasser);
  Feld B4 = new Feld("B4", false, false, wasser);
  Feld B5 = new Feld("B5", false, false, wasser);
  Feld B6 = new Feld("B6", false, false, wasser);
  Feld B7 = new Feld("B7", false, false, wasser);
  Feld B8 = new Feld("B8", false, false, wasser);

  Feld C0 = new Feld("C0", false, false, wasser);
  Feld C1 = new Feld("C1", false, false, wasser);
  Feld C2 = new Feld("C2", false, false, wasser);
  Feld C3 = new Feld("C3", false, false, wasser);
  Feld C4 = new Feld("C4", false, false, wasser);
  Feld C5 = new Feld("C5", false, false, wasser);
  Feld C6 = new Feld("C6", false, false, wasser);
  Feld C7 = new Feld("C7", false, false, wasser);
  Feld C8 = new Feld("C8", false, false, wasser);

  Feld D0 = new Feld("D0", false, false, wasser);
  Feld D1 = new Feld("D1", false, false, wasser);
  Feld D2 = new Feld("D2", false, false, wasser);
  Feld D3 = new Feld("D3", false, false, wasser);
  Feld D4 = new Feld("D4", false, false, wasser);
  Feld D5 = new Feld("D5", false, false, wasser);
  Feld D6 = new Feld("D6", false, false, wasser);
  Feld D7 = new Feld("D7", false, false, wasser);
  Feld D8 = new Feld("D8", false, false, wasser);

  Feld E0 = new Feld("E0", false, false, wasser);
  Feld E1 = new Feld("E1", false, false, wasser);
  Feld E2 = new Feld("E2", false, false, wasser);
  Feld E3 = new Feld("E3", false, false, wasser);
  Feld E4 = new Feld("E4", false, false, wasser);
  Feld E5 = new Feld("E5", false, false, wasser);
  Feld E6 = new Feld("E6", false, false, wasser);
  Feld E7 = new Feld("E7", false, false, wasser);
  Feld E8 = new Feld("E8", false, false, wasser);

  Feld F0 = new Feld("F0", false, false, wasser);
  Feld F1 = new Feld("F1", false, false, wasser);
  Feld F2 = new Feld("F2", false, false, wasser);
  Feld F3 = new Feld("F3", false, false, wasser);
  Feld F4 = new Feld("F4", false, false, wasser);
  Feld F5 = new Feld("F5", false, false, wasser);
  Feld F6 = new Feld("F6", false, false, wasser);
  Feld F7 = new Feld("F7", false, false, wasser);
  Feld F8 = new Feld("F8", false, false, wasser);

  Feld G0 = new Feld("G0", false, false, wasser);
  Feld G1 = new Feld("G1", false, false, wasser);
  Feld G2 = new Feld("G2", false, false, wasser);
  Feld G3 = new Feld("G3", false, false, wasser);
  Feld G4 = new Feld("G4", false, false, wasser);
  Feld G5 = new Feld("G5", false, false, wasser);
  Feld G6 = new Feld("G6", false, false, wasser);
  Feld G7 = new Feld("G7", false, false, wasser);
  Feld G8 = new Feld("G8", false, false, wasser);

  Feld H0 = new Feld("H0", false, false, wasser);
  Feld H1 = new Feld("H1", false, false, wasser);
  Feld H2 = new Feld("H2", false, false, wasser);
  Feld H3 = new Feld("H3", false, false, wasser);
  Feld H4 = new Feld("H4", false, false, wasser);
  Feld H5 = new Feld("H5", false, false, wasser);
  Feld H6 = new Feld("H6", false, false, wasser);
  Feld H7 = new Feld("H7", false, false, wasser);
  Feld H8 = new Feld("H8", false, false, wasser);

  Feld I0 = new Feld("I0", false, false, wasser);
  Feld I1 = new Feld("I1", false, false, wasser);
  Feld I2 = new Feld("I2", false, false, wasser);
  Feld I3 = new Feld("I3", false, false, wasser);
  Feld I4 = new Feld("I4", false, false, wasser);
  Feld I5 = new Feld("I5", false, false, wasser);
  Feld I6 = new Feld("I6", false, false, wasser);
  Feld I7 = new Feld("I7", false, false, wasser);
  Feld I8 = new Feld("I8", false, false, wasser);

  Feld J0 = new Feld("J0", false, false, wasser);
  Feld J1 = new Feld("J1", false, false, wasser);
  Feld J2 = new Feld("J2", false, false, wasser);
  Feld J3 = new Feld("J3", false, false, wasser);
  Feld J4 = new Feld("J4", false, false, wasser);
  Feld J5 = new Feld("J5", false, false, wasser);
  Feld J6 = new Feld("J6", false, false, wasser);
  Feld J7 = new Feld("J7", false, false, wasser);
  Feld J8 = new Feld("J8", false, false, wasser);

  Feld K0 = new Feld("K0", false, false, wasser);
  Feld K1 = new Feld("K1", false, false, wasser);
  Feld K2 = new Feld("K2", false, false, wasser);
  Feld K3 = new Feld("K3", false, false, wasser);
  Feld K4 = new Feld("K4", false, false, wasser);
  Feld K5 = new Feld("K5", false, false, wasser);
  Feld K6 = new Feld("K6", false, false, wasser);
  Feld K7 = new Feld("K7", false, false, wasser);
  Feld K8 = new Feld("K8", false, false, wasser);

  Feld L0 = new Feld("L0", false, false, wasser);
  Feld L1 = new Feld("L1", false, false, wasser);
  Feld L2 = new Feld("L2", false, false, wasser);
  Feld L3 = new Feld("L3", false, false, wasser);
  Feld L4 = new Feld("L4", false, false, wasser);
  Feld L5 = new Feld("L5", false, false, wasser);
  Feld L6 = new Feld("L6", false, false, wasser);
  Feld L7 = new Feld("L7", false, false, wasser);
  Feld L8 = new Feld("L8", false, false, wasser);

  Feld M0 = new Feld("M0", false, false, wasser);
  Feld M1 = new Feld("M1", false, false, wasser);
  Feld M2 = new Feld("M2", false, false, wasser);
  Feld M3 = new Feld("M3", false, false, wasser);
  Feld M4 = new Feld("M4", false, false, wasser);
  Feld M5 = new Feld("M5", false, false, wasser);
  Feld M6 = new Feld("M6", false, false, wasser);
  Feld M7 = new Feld("M7", false, false, wasser);
  Feld M8 = new Feld("M8", false, false, wasser);

  Feld N0 = new Feld("N0", false, false, wasser);
  Feld N1 = new Feld("N1", false, false, wasser);
  Feld N2 = new Feld("N2", false, false, wasser);
  Feld N3 = new Feld("N3", false, false, wasser);
  Feld N4 = new Feld("N4", false, false, wasser);
  Feld N5 = new Feld("N5", false, false, wasser);
  Feld N6 = new Feld("N6", false, false, wasser);
  Feld N7 = new Feld("N7", false, false, wasser);
  Feld N8 = new Feld("N8", false, false, wasser);

  Feld O0 = new Feld("O0", false, false, wasser);
  Feld O1 = new Feld("O1", false, false, wasser);
  Feld O2 = new Feld("O2", false, false, wasser);
  Feld O3 = new Feld("O3", false, false, wasser);
  Feld O4 = new Feld("O4", false, false, wasser);
  Feld O5 = new Feld("O5", false, false, wasser);
  Feld O6 = new Feld("O6", false, false, wasser);
  Feld O7 = new Feld("O7", false, false, wasser);
  Feld O8 = new Feld("O8", false, false, wasser);


  var felder=[M2, N2];
  var objekte=[schiff_mitte_vertikal];

  Schiff zweier = new Schiff(2);
  Schiff dreier = new Schiff(3);
  Schiff drei = new Schiff(3);

  zweier.setFelder(felder);
  zweier.setObjekte(objekte);

  felder=[A2, A3, A4];

  dreier.setFelder(felder);
  dreier.setObjekte(objekte);


//print(test);
//test = "#" + test;

  String test = "#" + zweier.getFelder()[0].toString();*/
  String test = "#E2";

  querySelector(test).style.backgroundImage='url("images/wasser_getroffen_weiss.png")';



  querySelector('#anzeige').innerHtml =
      'Noch ' + anzahl.toString() + ' Schiffe vorhanden';

  // querySelector("#A2").innerHtml = "X";
  //querySelectorAll('.Feld').onClick.listen(finde);
  //String id;
  //var id = querySelectorAll('.Feld').onClick.listen(finde);
  querySelectorAll('.Feld').onClick.listen(finde);
  //querySelector("#"+id).innerHtml="test";
//print(id);
  // querySelector('#' + K2.getIDFeld()).innerHtml = 'String';

//  var schiffe = [zweier, dreier];

 // setzteSchiffe(schiffe);

}

  void changeVisability(Event e){

      querySelector("#menu").style.display="none";
   //   querySelector("#T1").style.visibility="visible";
      querySelector("#T1").style.display="block";
  }

void finde(MouseEvent event) {
  if (event.target is Element) {
    Element target = event.target;
    // print(target.attributes["id"]);
    id = target.attributes["id"];
    //  target.innerHtml ="X";
    //  target.innerHtml="background='wasser.png'";
    //  target.innerHtml='background-image: url("wasser.png")';
    //  var style = target.style;
    //  style.background='background-image: url("wasser.png")';
    target.style.backgroundImage="url('images/test.png')";
  }
}
