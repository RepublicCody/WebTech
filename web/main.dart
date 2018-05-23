import 'dart:html';
import 'package:WebTech/dartwarships.dart';


String id;
Element tabelle = querySelector("#gameTable");

var s1 = ["A2", "A3", "A4"];
var s2 = ["B7", "C7", "D7"];

int anzahl = 2;

void main() {
  var game = new gameController();

  querySelector("#gameTable").style.display="none";
  querySelector("#level_1").onClick.listen(changeVisability);




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

  Objekt schiff_mitte_vertikal = new Objekt("Ship_mitte_vertikal", "images/schiff_mitte_vertikal.png");
  Objekt schiff_vorne_vertikal = new Objekt("Ship_mitte_vertikal", "images/schiff_vorne_vertikal.png");
  Objekt schiff_hinten_vertikal = new Objekt("Ship_mitte_vertikal", "images/schiff_hinten_vertikal.png");

  Objekt schiff_mitte_horizontal = new Objekt("Ship_mitte_vertikal", "images/schiff_mitte_horizontal.png");
  Objekt schiff_vorne_horizontal = new Objekt("Ship_mitte_vertikal", "images/schiff_vorne_horizontal.png");
  Objekt schiff_hinten_horizontal = new Objekt("Ship_mitte_vertikal", "images/schiff_hinten_horizontal.png");

  Objekt felsen = new Objekt("felsen", "test");


  Field A0 = new Field("wasser");
  Field A1 = new Field("wasser");
  Field A2 = new Field("wasser");
  Field A3 = new Field("wasser");
  Field A4 = new Field("wasser");
  Field A5 = new Field("wasser");
  Field A6 = new Field("wasser");
  Field A7 = new Field("wasser");
  Field A8 = new Field("wasser");

  Field B0 = new Field("wasser");
  Field B1 = new Field("wasser");
  Field B2 = new Field("wasser");
  Field B3 = new Field("wasser");
  Field B4 = new Field("wasser");
  Field B5 = new Field("wasser");
  Field B6 = new Field("wasser");
  Field B7 = new Field("wasser");
  Field B8 = new Field("wasser");

  Field C0 = new Field("wasser");
  Field C1 = new Field("wasser");
  Field C2 = new Field("wasser");
  Field C3 = new Field("wasser");
  Field C4 = new Field("wasser");
  Field C5 = new Field("wasser");
  Field C6 = new Field("wasser");
  Field C7 = new Field("wasser");
  Field C8 = new Field("wasser");

  Field D0 = new Field("wasser");
  Field D1 = new Field("wasser");
  Field D2 = new Field("wasser");
  Field D3 = new Field("wasser");
  Field D4 = new Field("wasser");
  Field D5 = new Field("wasser");
  Field D6 = new Field("wasser");
  Field D7 = new Field("wasser");
  Field D8 = new Field("wasser");

  Field E0 = new Field("wasser");
  Field E1 = new Field("wasser");
  Field E2 = new Field("wasser");
  Field E3 = new Field("wasser");
  Field E4 = new Field("wasser");
  Field E5 = new Field("wasser");
  Field E6 = new Field("wasser");
  Field E7 = new Field("wasser");
  Field E8 = new Field("wasser");

  Field F0 = new Field("wasser");
  Field F1 = new Field("wasser");
  Field F2 = new Field("wasser");
  Field F3 = new Field("wasser");
  Field F4 = new Field("wasser");
  Field F5 = new Field("wasser");
  Field F6 = new Field("wasser");
  Field F7 = new Field("wasser");
  Field F8 = new Field("wasser");

  Field G0 = new Field("wasser");
  Field G1 = new Field("wasser");
  Field G2 = new Field("wasser");
  Field G3 = new Field("wasser");
  Field G4 = new Field("wasser");
  Field G5 = new Field("wasser");
  Field G6 = new Field("wasser");
  Field G7 = new Field("wasser");
  Field G8 = new Field("wasser");

  Field H0 = new Field("wasser");
  Field H1 = new Field("wasser");
  Field H2 = new Field("wasser");
  Field H3 = new Field("wasser");
  Field H4 = new Field("wasser");
  Field H5 = new Field("wasser");
  Field H6 = new Field("wasser");
  Field H7 = new Field("wasser");
  Field H8 = new Field("wasser");

  Field I0 = new Field("wasser");
  Field I1 = new Field("wasser");
  Field I2 = new Field("wasser");
  Field I3 = new Field("wasser");
  Field I4 = new Field("wasser");
  Field I5 = new Field("wasser");
  Field I6 = new Field("wasser");
  Field I7 = new Field("wasser");
  Field I8 = new Field("wasser");

  Field J0 = new Field("wasser");
  Field J1 = new Field("wasser");
  Field J2 = new Field("wasser");
  Field J3 = new Field("wasser");
  Field J4 = new Field("wasser");
  Field J5 = new Field("wasser");
  Field J6 = new Field("wasser");
  Field J7 = new Field("wasser");
  Field J8 = new Field("wasser");

  Field K0 = new Field("wasser");
  Field K1 = new Field("wasser");
  Field K2 = new Field("wasser");
  Field K3 = new Field("wasser");
  Field K4 = new Field("wasser");
  Field K5 = new Field("wasser");
  Field K6 = new Field("wasser");
  Field K7 = new Field("wasser");
  Field K8 = new Field("wasser");

  Field L0 = new Field("wasser");
  Field L1 = new Field("wasser");
  Field L2 = new Field("wasser");
  Field L3 = new Field("wasser");
  Field L4 = new Field("wasser");
  Field L5 = new Field("wasser");
  Field L6 = new Field("wasser");
  Field L7 = new Field("wasser");
  Field L8 = new Field("wasser");

  Field M0 = new Field("wasser");
  Field M1 = new Field("wasser");
  Field M2 = new Field("wasser");
  Field M3 = new Field("wasser");
  Field M4 = new Field("wasser");
  Field M5 = new Field("wasser");
  Field M6 = new Field("wasser");
  Field M7 = new Field("wasser");
  Field M8 = new Field("wasser");

  Field N0 = new Field("wasser");
  Field N1 = new Field("wasser");
  Field N2 = new Field("wasser");
  Field N3 = new Field("wasser");
  Field N4 = new Field("wasser");
  Field N5 = new Field("wasser");
  Field N6 = new Field("wasser");
  Field N7 = new Field("wasser");
  Field N8 = new Field("wasser");

  Field O0 = new Field("wasser");
  Field O1 = new Field("wasser");
  Field O2 = new Field("wasser");
  Field O3 = new Field("wasser");
  Field O4 = new Field("wasser");
  Field O5 = new Field("wasser");
  Field O6 = new Field("wasser");
  Field O7 = new Field("wasser");
  Field O8 = new Field("wasser");

/*
  var Fielder=["M2", "N2"];
  var Objekte=[schiff_vorne_vertikal, schiff_hinten_vertikal];

  Ship zweier = new Ship(2);
  Ship dreier = new Ship(3);
  Ship dreier2 = new Ship(3);

  zweier.setFields(Fielder);
  zweier.setObjekte(Objekte);

  Fielder=["A2", "A3", "A4"];
//  Objekte=[schiff_vorne_horizontal, schiff_mitte_horizontal, schiff_hinten_horizontal];
  Objekte=[nebel, nebel, nebel];

  dreier.setFields(Fielder);
  dreier.setObjekte(Objekte);

  Fielder=["B7", "C7", "D7"];
//  Objekte=[schiff_vorne_vertikal, schiff_mitte_vertikal, schiff_hinten_vertikal];

  dreier2.setFields(Fielder);
  dreier2.setObjekte(Objekte);

  placeShipe(zweier);
  placeShipe(dreier);
  placeShipe(dreier2);

  print("test");
*/
//print(test);
//test = "#" + test;

  //String test = "#" + zweier.getFielder()[0].toString();
//  String test = "#E2";

//  querySelector(test).style.backgroundImage='url("images/wasser_getroffen_weiss.png")';

if(anzahl == 2) {
  querySelector('#anzeige').innerHtml =
      'Noch ' + anzahl.toString() + ' Schiffe vorhanden';
}
  // querySelector("#A2").innerHtml = "X";
  //querySelectorAll('.Field').onClick.listen(finde);
  //String id;
  //var id = querySelectorAll('.Field').onClick.listen(finde);



  querySelectorAll('.field').onClick.listen(finde);



  //querySelector("#"+id).innerHtml="test";
//print(id);
  // querySelector('#' + K2.getIDField()).innerHtml = 'String';

//  var Shipe = [zweier, dreier];

 // setzteShipe(Shipe);

  querySelector("#field_6_3").style.backgroundImage = 'url("images/nebel_getroffen_rot.png")';


}

  void changeVisability(Event e){

      querySelector("#menu").style.display="none";
   //   querySelector("#gameTable").style.visibility="visible";
      querySelector("#gameTable").style.display="block";
  }

void finde(MouseEvent event) {
  bool hit = false;
  bool sh1 = true;
  bool sh2 = true;
  if (event.target is Element) {
    Element target = event.target;
    // print(target.attributes["id"]);
    id = target.attributes["id"];

    for(int x = 0; x < s1.length; x++){
      if(s1[x] == id && hit == false){
        target.style.backgroundImage='url("images/nebel_getroffen_rot.png")';
        s1[x] = null;
        hit = true;
      }
    }

    for(int x = 0; x < s1.length; x++){
      if(s2[x] == id && hit == false){
        target.style.backgroundImage='url("images/nebel_getroffen_rot.png")';
        s2[x] = null;
        hit = true;
      }
    }


      if(sh1 == true && s1[0] == null && s1[1] == null && s1[2] == null) {
        querySelector("#A2").style.backgroundImage =
        'url("images/schiff_getroffen_vorne_horizontal.png")';
        querySelector("#A3").style.backgroundImage =
        'url("images/schiff_getroffen_mitte_horizontal.png")';
        querySelector("#A4").style.backgroundImage =
        'url("images/schiff_getroffen_hinten_horizontal.png")';

        if (anzahl != 0 && sh1 == true){
          print("1");
          anzahl = 0;
      /*  querySelector('#anzeige').innerHtml =
            'Noch ' + anzahl.toString() + ' Schiffe vorhanden';*/
          sh1 = false;
      }
      }



      if(sh2 == true && s2[0] == null && s2[1] == null && s2[2] == null){
        querySelector("#B7").style.backgroundImage = 'url("images/schiff_getroffen_vorne_vertikal.png")';
        querySelector("#C7").style.backgroundImage = 'url("images/schiff_getroffen_mitte_vertikal.png")';
        querySelector("#D7").style.backgroundImage = 'url("images/schiff_getroffen_hinten_vertikal.png")';

        if(anzahl !=0 && sh2 == true) {
          print("2");
          anzahl = 1;
          /*   querySelector('#anzeige').innerHtml =
              'Noch ' + anzahl.toString() + ' Schiffe vorhanden';*/
          sh2 = false;
        }
      }



    //  target.innerHtml ="X";
    //  target.innerHtml="background='wasser.png'";
    //  target.innerHtml='background-image: url("wasser.png")';
    //  var style = target.style;
    //  style.background='background-image: url("wasser.png")';
if(anzahl == 1 || anzahl == 0) {
  querySelector('#anzeige').innerHtml =
      'Noch ' + anzahl.toString() + ' Schiffe vorhanden';
}

if(hit == false) {
  target.style.backgroundImage = 'url("images/wasser_getroffen_weiss.png")';
}
  }


}

void placeShipe(Ship ship){

  var felder = ship.getFields();
  var objekte = ship.getObjekte();

  for (int x = 0; x < felder.length; x++) {
    String id = "#" + felder[x].toString();
    Objekt obj = objekte[x];

    String img = "url('" + obj.getBild() + "')";
    querySelector(id).style.backgroundImage = img;
  }
}



