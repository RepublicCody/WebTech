part of warships;

class gamePlay{
  //test
  int row;
  int column;

  gamePlay(int row, int column){
    this.row = row;
    this.column = column;
  }
/*
  List<List<Symbol>> get field {
    var _field = new Iterable.generate(_size, (row) {
      return new Iterable.generate(_size, (col) => #empty).toList();
    }).toList();
    mice.forEach((m) {
      if (m.row < size && m.col < size)
        _field[m.row][m.col] = #mouse;
      else
        print (m);
    });
    snake.body.forEach((s) {
      final r = s['row'];
      final c = s['col'];
      if (r < 0 || r >= _size) return;
      if (c < 0 || c >= _size) return;
      _field[r][c] = #snake;
    });
    return _field;
  }

*/


  
}




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

      var shipFields = ship.getFields();

      for (int x = 0; x < shipFields.length; x++) {
        String id = "#" + shipFields[x].toString();

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