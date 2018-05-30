part of warships;

class GameModel {
  Enemy _enemy;
  PlayingField _playingField;

  Enemy get enemy => _enemy;
  PlayingField get playingField => _playingField;
  set playingField(PlayingField field) => _playingField = field;

  GameModel() {
    playingField = new PlayingField(ROWCOUNT, COLCOUNT);
    _enemy = new Enemy(this, [4, 3, 3, 2, 2]);
    //enemy = new Enemy(); later
  }

  void generatePlayingField(int level) {

        //+++generate first level+++
        //playingField.generateField();
        //enemy.placeShips();
        // this can be replaced, once loading lvls from json is implemented
        playingField.shipLengths = [4, 3, 3, 2, 2];
        playingField.newGame();
        List<List<Field>> f = playingField.fields;
        var ship1 = [f[7][4], f[7][5], f[7][6], f[7][7]];
        var ship2 = [f[2][0], f[3][0], f[4][0]];
        var ship3 = [f[0][6], f[1][6], f[2][6]];
        var ship4 = [f[1][0], f[1][7]];
        var ship5 = [f[4][3], f[4][4]];
        playingField.addShip(new Ship(playingField, ship1, false));
        playingField.addShip(new Ship(playingField, ship2, false));
        playingField.addShip(new Ship(playingField, ship3, false));
        playingField.addShip(new Ship(playingField, ship4, false));
        playingField.addShip(new Ship(playingField, ship5, false));
  }

  void fireAt(int row, int col) {
    playingField.fireAt(row, col);
  }

}

class Enemy {
  int _strategy;
  GameModel _model;
  Random _rng;
  List<int> shipLengths;

  set strategy(int value) => _strategy = value;
  int get strategy => _strategy;
  set model(GameModel value) => _model = value;
  GameModel get model => _model;

  Enemy(GameModel model, List<int> shipLengths) {
    this.model = model;
    this.strategy = strategy;
    _rng = new Random();
    this.shipLengths = shipLengths;
  }

  void placeShips(List<List<Field>> fields) {// Es kann passieren, dass ein Schiff nicht platziert werden kann, weil es keine Möglichkeiten mehr gibt
    /*
    //This will generate a List of 12 int from 0 to 99
    var rng = new Random();
    var l = new List.generate(12, (_) => rng.nextInt(100));
    */
    int length;
    int r;      //row
    int c;      //column
    int direction;
    int dummy;
    int halfROWCOUNT;
    bool checkUp = false;
    bool checkRight = false;
    bool checkDown = false;
    bool checkLeft = false;
    bool shipCouldBePlaced = false;
    bool shipPlaced = false;

    if(ROWCOUNT.isEven)halfROWCOUNT = (ROWCOUNT / 2).toInt();
    else{halfROWCOUNT = (ROWCOUNT+1 / 2).toInt();}

    var rand = new Random();


    for(int x = 0; x < shipLengths.length; x++){
      length = shipLengths[x];
      shipPlaced = false;



      while(shipPlaced == false) {

        r = rand.nextInt(halfROWCOUNT);
        c = rand.nextInt(COLCOUNT);

        Field f = fields[r][c];

        if (f._foggy == true) {
          checkUp = false;
          checkRight = false;
          checkDown = false;
          checkLeft = false;
          shipCouldBePlaced = true;

          while (shipCouldBePlaced == true && shipPlaced == false) {
            direction = rand.nextInt(3);

            switch (direction) {
              case 0:
                {
                  if (checkUp == false) {
                    for (int y = 0; y < length; y++) {
                      dummy = r - y;
                      if(dummy > 0 && fields[dummy][c]._foggy == true){
                        shipPlaced = true;
                      }
                      else{shipPlaced = false;}
                    }
                    if(shipPlaced == true){
                      //füge Schiff in die Liste mit Schiffen ein
                      //Füge das Schiff in die Entity ein oder in was ähnliches
                    }

                    checkUp = true;
                  }
                }
                break;
              case 1:
                {
                  if (checkRight == false) {
                    for (int y = 0; y < length; y++) {
                      dummy = c + y;
                      if(dummy >= COLCOUNT)dummy -= COLCOUNT;
                      if(fields[r][dummy]._foggy == true){
                        shipPlaced = true;
                      }
                      else{shipPlaced = false;}
                    }
                    if(shipPlaced == true){
                      //füge Schiff in die Liste mit Schiffen ein
                      //Füge das Schiff in die Entity ein oder in was ähnliches
                    }

                    checkRight = true;
                  }
                }
                break;
              case 2:
                {
                  if (checkDown == false) {
                    for (int y = 0; y < length; y++) {
                      if(fields[r + y][c]._foggy == true){
                        shipPlaced = true;
                      }
                      else{shipPlaced = false;}
                    }
                    if(shipPlaced == true){
                      //füge Schiff in die Liste mit Schiffen ein
                      //Füge das Schiff in die Entity ein oder in was ähnliches
                    }

                    checkDown = true;
                  }
                }
                break;
              case 3:
                {
                  if (checkLeft == false) {
                    for (int y = 0; y < length; y++) {
                      dummy = c - y;
                      if(dummy < 0)dummy += COLCOUNT;
                      if(fields[r][dummy]._foggy == true){
                        shipPlaced = true;
                      }
                      else{shipPlaced = false;}
                    }
                    if(shipPlaced == true){
                      //füge Schiff in die Liste mit Schiffen ein
                      //Füge das Schiff in die Entity ein oder in was ähnliches
                    }
                    checkLeft = true;
                  }
                }
                break;
            }

            if(checkUp == false || checkRight == false ||
                checkDown == false || checkLeft == false){
              shipCouldBePlaced = true;
            }
            else{
              shipCouldBePlaced = false;
            }
          }
        }
      }
    }
  }

  void makeMove() {
    randomMove();
    // implement strategy
  }

  void randomMove() {
    int min = model.playingField.fields.length ~/ 2;
    int row = min + _rng.nextInt(model.playingField.fields.length - min);
    int col = _rng.nextInt(model.playingField.fields[0].length);
    print("firing at ${row},${col}");
    model.fireAt(row, col);
  }

  void mediocreMove() { // for a lack of a better name
    //TODO: implement medium difficulty
  }

  void cleverMove() {
    //TODO: implement hard difficulty
  }
}

class PlayingField {
  List<List<Field>> _fields;
  List<Ship> _ships;
  List<int> _shipLengths;
  ShipBuilder _builder;

  List<List<Field>> get fields => _fields;
  set fields(List<List<Field>> fields) => _fields = fields;
  List<Ship> get ships => _ships;
  set ships(List<Ship> ships) => _ships = ships;
  List<int> get shipLengths => _shipLengths;
  set shipLengths(List<int> value) => _shipLengths = value;

  PlayingField(int rows, int cols/*, List<int> shipLengths*/) {
    //this.shipLengths = shipLengths; // moved to generatePlayingField in GameModel
    fields = initializeFields(rows, cols);
    ships = new List<Ship>();
    //terrain = new List<Entity>();
  }

  void newGame() {
    fields = initializeFields(fields.length, fields.first.length);
    ships = new List<Ship>();
  }

  List<List<Field>> initializeFields(int rows, int cols) {
    var outerList = new List<List<Field>>(rows);
    for (int row = 0; row < rows; row++) {
      var innerList = new List<Field>(cols);
      for (int col = 0; col < cols; col++) {
        innerList[col] = row >= rows / 2 ? new Field(row, col, false): new Field(row, col, true);
      }
      outerList[row] = innerList;
    }
    return outerList;
  }

  void fireAt(int row, int col) {
    fields[row][col].fireAt();
  }

  void generateField(int rocks, int items) {
    for (int i = 0; i < rocks; i++) {
      //generate rocks
    }
    for (int i = 0; i < items; i++) {
      //generate items
    }
  }

  bool shipBuildingComplete() {
    return shipLengths.length * 2== ships.length;
  }

  void addShip(Ship ship) {
    ships.add(ship);
    ship.place();
  }

  bool buildShip(int row, int col) {
    Field f = fields[row][col];
    if (f.entity == null && !f.foggy) {
      if (_builder != null)_builder.remove();
      _builder = new ShipBuilder(this, row, col, shipLengths[ships.length - shipLengths.length]); //TODO: put correct length here
    } else if(f.entity is ShipBuilder) {
      ShipBuilder sb = f.entity;
      sb.buildShip(f);
      return true;
    }
    return false;
  }

  // just for testing purposes
  String toString() {
    var fieldString = "";
    for (int i = 0; i < fields.length; i++) {
      fieldString += "\n";
      for (int j = 0; j < fields[i].length; j++) {
        fieldString += fields[i][j].toString();
        fieldString += " ";
      }
    }
    return fieldString;
  }

  bool gameOver() {
    int friendly = 0;
    int enemy = 0;
    for (int i = 0; i < ships.length; i++) {
      if (ships[i].friendly) friendly++;
      else enemy++;
    }
    return friendly <= 0 || enemy <= 0;
  }

  int enemyShipCount() {
    int count = 0;
    for (int i = 0; i < ships.length; i++) {
      if (!ships[i].friendly) count++;
    }
    return count;
  }
}

class Field{
  int _row;
  int _col;
  bool _hit;
  bool _foggy;
  Entity _entity;

  int get row => _row;
  set row(int row) => _row = row;
  int get col => _col;
  set col(int col) => _col = col;
  bool get hit => _hit;
  set hit(bool hit) => _hit = hit;
  Entity get entity => _entity;
  set entity(Entity entity) => _entity = entity;
  bool get foggy => _foggy;
  set foggy(bool value) => _foggy = value;

  Field(int row, int col, bool foggy){
    this.row = row;
    this.col = col;
    this.foggy = foggy;
    this.hit = false;
    //this.entity = null;
  }

  void fireAt() {
    if (entity is Ship) {
      Ship s = entity;
      s.fireAt(this);
    } else {
      hit = true;
    }
  }

  // just for testing purposes
  String toString() => entity == null ? "." : entity is Ship ? "S" : entity is Rock ? "R" : entity is ShipBuilder ? "B" : "P";
}

class Entity {
  PlayingField _playingField;
  List<Field> _fields;

  PlayingField get playingField => _playingField;
  set playingField(PlayingField value) => _playingField = value;
  List<Field> get fields => _fields;
  set fields(List<Field> value) => _fields = value;

  Entity(PlayingField playingField, List<Field> fields) {
    this.playingField = playingField;
    this.fields = fields;
  }

  void place() {
    for (int i = 0; i < fields.length; i++) {
      fields[i].entity = this;
    }
  }
}

class Ship extends Entity {
  bool destroyed;
  bool _vertical;
  bool _friendly;

  bool get vertical => _vertical;
  set vertical(bool value) => _vertical = value;
  bool get friendly => _friendly;

  Ship(PlayingField pField, List<Field> fields, bool friendly)
      : super(pField, fields) {
    destroyed = false;
    this._friendly = friendly;
    this.vertical = fields.first.col == fields.last.col;

    if (fields.last != back()) {
      this.fields = fields.reversed.toList();
    }
  }

  bool reenters() {
    bool first = false;
    bool last = false;
    for (int i = 0; i < fields.length; i++) {
      if (fields[i].col == 0) first = true;
      if (fields[i].col == playingField.fields[fields[i].row].length - 1)
        last = true;
    }
    return first && last;
  }

  Field back() {
    //can probably be improved
    Field f;
    if (!vertical) {
      for (int i = 0; i < fields.length; i++) {
        f = fields[i];
        bool hasNext = false;
        for (int j = 0; j < fields.length; j++) {
          if (fields[j].col == fields[i].col + 1) hasNext = true;
          if (fields[i].col == playingField.fields.first.length - 1 &&
              fields[j].col == 0) hasNext = true;
        }
        if (!hasNext) {
          return f;
        }
      }
      return null;
    } else {
      for (int i = 0; i < fields.length; i++) {
        f = fields[i];
        bool hasNext = false;
        for (int j = 0; j < fields.length; j++) {
          if (fields[j].row == fields[i].row + 1) hasNext = true;
        }
        if (!hasNext) {
          return f;
        }
      }
      return null;
    }
  }

  bool isDamaged() {
    for (int i = 0; i < fields.length; i++) {
      if (fields[i].hit) return true;
    }
    return false;
  }

  void fireAt(Field f) {
    f.hit = true;
    bool sunk = true;
    for (int i = 0; i < fields.length; i++) {
      if (!fields[i].hit) {
        sunk = false;
      }
    }
    if (sunk) {
      sinkShip();
      print("Schiff versenkt");
    }
  }

  void sinkShip() {
    for (int i = 0; i < fields.length; i++) {
      if (fields[i].entity == this) fields[i].entity = null;
    }
    playingField.ships.remove(this);
  }

  // TODO: not completed
  void move(int distance) {
    List<Field> shipFields = new List<Field>();
    if (vertical) {
      for (int i = 0; i < fields.length; i++) {
        shipFields.add(
            playingField.fields[fields[i + distance].row][fields[i].col]);
      }
    } else {
      for (int i = 0; i < fields.length; i++) {
        shipFields.add(
            playingField.fields[fields[i].row][fields[i + distance].col]);
      }
    }
    sinkShip();
    playingField.addShip(new Ship(playingField, shipFields, _friendly));
  }
}

class Rock extends Entity {
  Rock(PlayingField field, int row, int col) : super(field, null) {
    this.fields = new List<Field>();
    fields.add(field.fields[row][col]);
  }
}

class PowerUp extends Entity {
  PowerUp(PlayingField field, int row, int col) : super(field, null) {
    this.fields = new List<Field>();
    fields.add(field.fields[row][col]);
  }

  void activate() {
    // TODO: activate the powerups effect
  }
}

class ShipBuilder extends Entity{
  int shipLength;
  int centerRow;
  int centerCol;

  ShipBuilder(PlayingField field, int row, int col, int shipLength) : super(field, null) {
    this.shipLength = shipLength;
    this.fields = new List<Field>();
    this.centerRow = row;
    this.centerCol = col;
    //add fields to the list
    fields.add(field.fields[row][col]);                                                   // center
    fields.add(row - 1 >= 0 ? field.fields[row - 1][col] : null);                         // north
    fields.add(field.fields[row][col + 1 < field.fields[row].length ? col + 1 : 0]);      // east
    fields.add(row + 1 < field.fields.length ? field.fields[row + 1][col] : null);        // south
    fields.add(field.fields[row][col - 1 >= 0 ? col - 1 : field.fields[row].length - 1]); // west

    // check if direction is blocked or foggy, remove if it is
    for (int dir = 1; dir < fields.length; dir++) {
      if (fields[dir] != null) {
        bool unOccupied = true;
        int rowDiff = fields[0].row - fields[dir].row;
        int colDiff = fields[0].col - fields[dir].col;
        if (colDiff > 1) {
          colDiff = -1;
        }
        if (colDiff < -1) {
          colDiff = 1;
        }
        for (int r = row, c = col, i = 0; i < shipLength; r -= rowDiff, c -= colDiff, i++) {
          if (c < 0) c = field.fields[row].length - 1;
          if (c >= field.fields[row].length) c = 0;
          if (r >= field.fields.length || r < 0) {
            unOccupied = false;
          } else if (field.fields[r][c].entity != null || field.fields[r][c].foggy) {
            unOccupied = false;
          }
        }
        if (!unOccupied) {
          fields[dir] = null;
        }
      }
      }
    place();
  }

  void place() {
    for (int i = 0; i < fields.length; i++) {
      if (fields[i] != null) {
        fields[i].entity = this;
      }
    }
  }

  void remove() {
    for (int i = 0; i < fields.length; i++) {
      if (fields[i] != null && fields[i].entity == this) {
        fields[i].entity = null;
      }
    }
  }

  void buildShip(Field f) {
    if (fields.contains(f) && f != fields.first) {
      List<Field> shipFields = new List<Field>();
      var rowDiff = centerRow - f.row;
      var colDiff = centerCol - f.col;
      if (colDiff > 1) {
        colDiff = -1;
      }
      if (colDiff < -1) {
        colDiff = 1;
      }
      for (int r = centerRow, c = centerCol, i = 0; i < shipLength;
      r -= rowDiff, c -= colDiff, i++) {
        if (c < 0) {
          c = playingField.fields[centerRow].length - 1;
        }
        if (c >= playingField.fields[centerRow].length) {
          c = 0;
        }
        shipFields.add(playingField.fields[r][c]);
      }
      remove();
      playingField.addShip(new Ship(playingField, shipFields, true));
    }
  }

}
