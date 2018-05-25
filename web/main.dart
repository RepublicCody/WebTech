import 'dart:html';
import 'package:WebTech/dartwarships.dart';


int anzahl = 2;

void main() {

  var game = new gameController();


if(anzahl == 2) {
  querySelector('#anzeige').innerHtml =
      'Noch ' + anzahl.toString() + ' Schiffe vorhanden';
}

  querySelectorAll('.field').onClick.listen(search);





}



void search(MouseEvent event) {
  bool hit = false;
  bool sh1 = true;
  bool sh2 = true;
  if (event.target is Element) {
    Element target = event.target;
    // print(target.attributes["id"]);
    //id = target.attributes["id"];
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



