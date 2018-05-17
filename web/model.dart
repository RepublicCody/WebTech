//part of warships;
import 'dart:html';

class Field{

  bool hit;
  String entity;

  Field(String entity){
  this.hit = false;
  this.entity = entity;
  }

  bool getHit(){return this.hit;}

  void setHit(bool boolean){this.hit = boolean;}

  String getEntity(){return this.entity;}

  void setEntity(String entity){this.entity = entity;}

}

class Ship{
  bool destroyed;
  int shipLength;

  var fields = [];
  var objekte = [];

  Ship(int shipLength){
    this.shipLength = shipLength;
    this.destroyed = false;
    this.fields = [];
    this.objekte = [];
  }


  bool getDestroyed(){
    return this.destroyed;
  }
  void setDestroyed(bool boolean){
    this.destroyed = boolean;
  }

  int getShipLength(){
    return this.shipLength;
  }

  void setShipLength(int shipLength){
    this.shipLength = shipLength;
  }

  List getFields(){
    return this.fields;
  }

  void setFields(List fields){
    this.fields = fields;
  }

  List getObjekte(){
    return this.objekte;
  }

  void setObjekte(List objekte){
    this.objekte = objekte;
  }
}

class PlayingField{

  var fields = new List.generate(9, (_) => new List(15)); // x[1] = [4, 5, 6]; ->   [[null, null, null], [4, 5, 6]]
  var friendlyShip = [];
  var enemyShip = [];
  int powerUpActive;
  String enemyStrategie;


  void initializeShips(int small, int medium, int large, int veryLarge){

    Ship schiff = new Ship(2);
    Ship schiff2 = new Ship(3);

    placeShip(schiff);
    placeShip(schiff2);
  }

  void initializePowRcks(int pow, int rck){

    var listeX = [];
    var listeY = [];

    for(int x = 0; x < 9; x++){
      for(int y = 0; y < 15; y++){

      }
    }
  }


  void placeShip(Ship ship){

      var felder = ship.getFields();

      for (int x = 0; x < felder.length; x++) {
        String id = "#" + felder[x].toString();

        //String img = "url('" + obj.getBild() + "')";
        //print(img);
        String img = "images/schiff_mitte_vertikal.png";
        querySelector(id).style.backgroundImage = "url('" + img + "')";
      }
  }
}

class Entity{

  int rock;
  int ship;
  int powerUp;

  Entitiy(int rock, int ship, int powerUp){
    this.rock = rock;
    this.ship = ship;
    this.powerUp = powerUp;
  }
}

class Objekt{
  String bez;
  String bild;

  Objekt(String bez, String bild){
    this.bez = bez;
    this.bild = bild;
  }

  String getBild(){return this.bild;}

}