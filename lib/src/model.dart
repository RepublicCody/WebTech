part of warships;

class GameModel {
  Enemy _enemy;
  PlayingField _playingField;
  List<int> _shipLengths;

  Enemy get enemy => _enemy;
  PlayingField get playingField => _playingField;
  set playingField(PlayingField field) => _playingField = field;
  List<int> get shipLengths => _shipLengths;

  GameModel(int level) {
    playingField = new PlayingField(ROWCOUNT, COLCOUNT);
    Ship s = new Ship(playingField, 14, 2, 14, 5, false);
    Ship s1 = new Ship(playingField, 9, 0, 11, 0, false);
    switch (level) {
      case 1:
        _shipLengths = [2, 2, 3, 4, 5];
        break;
    //TODO: complete level implementation
    }
  }

  void fireAt(int row, int col) {
    playingField.fireAt(row, col);
  }
}

class Enemy {
  int _strategy;
  GameModel _model;
  Random _rng;
  int prevHitRow;
  int prevHitCol;

  set strategy(int value) => _strategy = value;
  int get strategy => _strategy;
  set model(GameModel value) => _model = value;
  GameModel get model => _model;

  Enemy(int strategy, List<int> ShipLengths) {
    this.strategy = strategy;
    _rng = new Random(100);
  }

  void placeShips(int shipCount) {
    //TODO: enemy places their ships
    // Just a level dummy for testing
  }

  void makeMove() {
    switch (strategy) {
      case 1:
        randomMove();
        break;
      case 2:
        mediocreMove();
        break;
      case 3:
        cleverMove();
        break;
    }
    print("Strategy doesn't exist");
  }

  void randomMove() {
    int row = _rng.nextInt(model.playingField.fields.length);
    int col = _rng.nextInt(model.playingField.fields[0].length);
    model.fireAt(row, col);
    prevHitRow = row;
    prevHitCol = col;
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

  List<List<Field>> get fields => _fields;
  set fields(List<List<Field>> fields) => _fields = fields;
  List<Ship> get ships => _ships;
  set ships(List<Ship> ships) => _ships = ships;
  //List<Entity> get terrain => _terrain;
  //set terrain(List<Entity> terrain) => _terrain = terrain;

  PlayingField(int rows, int cols) {
    var outerList = new List<List<Field>>(rows);
    for (int row = 0; row < rows; row++) {
      var innerList = new List<Field>(cols);
      for (int col = 0; col < cols; col++) {
        innerList[col] = row >= rows / 2 ? new Field(row, col, false): new Field(row, col, true);
      }
      outerList[row] = innerList;
    }
    fields = outerList;

    ships = new List<Ship>();
    //terrain = new List<Entity>();
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

  void placeShips() {
    for (int i = 0; i < ships.length; i++) {
      ships[i].place();
    }
  }

  void buildShip(int row, int col) {
    Field f = fields[row][col];
    if (f.entity == null && !f.foggy) {
      new ShipBuilder(this, row, col, 3); //TODO: put correct length here
    }
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

  Ship(PlayingField pField, int startRow, int startCol, int endRow, int endCol, bool reenters) : super(pField, null){
    playingField.ships.add(this);
    this.destroyed = false;
    this.playingField = pField;
    fields = new List<Field>();
    if (startRow == endRow) { // for horizontal ships
      if (reenters) {
        if (startCol < endCol) {
          var dummy = startCol;
          startCol = endCol;
          endCol = dummy;
        }
        for (int col = startCol; col < playingField.fields[startRow].length;col++) {
          fields.add(playingField.fields[startRow][col]);
        }
        for (int col = 0; col <= endCol; col++) {
          fields.add(playingField.fields[startRow][col]);
        }
      } else {
        if (startCol > endCol) { // swap start and endcol if endcol < startcol
          var dummy = startCol;
          startCol = endCol;
          endCol = dummy;
        }
        for (int col = startCol; col <= endCol; col++) {
          fields.add(playingField.fields[startRow][col]);
        }
      }
      vertical = false;
    } else if (startCol == endCol){ // for vertical ships
      if (startRow > endRow) {      // swap start and endrow if endrow < startrow
        var dummy = startRow;
        startRow = endRow;
        endRow = dummy;
      }
      for (int row = startRow; row <= endRow; row++) {
        fields.add(playingField.fields[row][startCol]);
      }
      vertical = true;
    } else {
      print("Ships have to be aligned either vertically or horizontally.");
    }
    place();
  }

  bool isDamaged() {
    for (int i = 0; i < fields.length; i++) {
      if (fields[i].hit) return true;
    }
    return false;
  }

  void fireAt(Field f) {
    f.hit = true;
  }

  void sinkShip(){//TODO: sink ship and replace field with water
    for(int i = 0; i < fields.length; i++) {
      if (fields[i].entity == this) fields[i].entity = null;
    }
    playingField.ships.remove(this);
  }

  void move(int distance) {
    // TODO: make ships reenter the playing field from the opposite side if moved beyond borders
    if (vertical) {
      playingField.ships[playingField.ships.indexOf(this)] = new Ship(playingField, fields.first.row + distance, fields.first.col,
          fields.last.row + distance, fields.last.col, false);
    } else {
      playingField.ships[playingField.ships.indexOf(this)] = new Ship(playingField, fields.first.row, fields.first.col + distance,
          fields.last.row, fields.last.col + distance, fields.first.row + distance < 0 || fields.last.row + distance > playingField.fields.length);
    }
    sinkShip();
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
  ShipBuilder(PlayingField field, int row, int col, int shipLength) : super(field, null) {
    this.shipLength = shipLength;
    this.fields = new List<Field>();
    fields.add(field.fields[row][col]);       // center
    fields.add(field.fields[row - 1][col]);   // north
    fields.add(field.fields[row][col + 1]);   // east
    fields.add(field.fields[row + 1][col]);   // south
    fields.add(field.fields[row][col - 1]);   // west

    // check if direction is blocked or foggy, remove if it is
    for (int dir = 1; dir < fields.length; dir++) {
      bool unOccupied = true;
      int rowDiff = fields[0].row - fields[dir].row;
      int colDiff = fields[0].col - fields[dir].col;
      for (int r = row, c = col, i = 0; i < shipLength; r -= rowDiff, c -= colDiff, i++) {
        if (c < 0) r = field.fields[row].length;
        if (c > field.fields[row].length) c = 0;  // still has to be tested
        if (r > field.fields.length || r < 0) {
          unOccupied == false;
        } else if(field.fields[r][c].entity != null || field.fields[r][c].foggy) {
          unOccupied = false;
        }

      }
      if (!unOccupied) {
        fields.removeAt(dir);
      }
    }
    place();
  }

}









/*
part of warships;

class GameModel {
  Enemy _enemy;
  PlayingField _playingField;
  List<int> _shipLengths;

  Enemy get enemy => _enemy;
  PlayingField get playingField => _playingField;
  set playingField(PlayingField field) => _playingField = field;
  List<int> get shipLengths => _shipLengths;

  GameModel(int level) {
    playingField = new PlayingField(ROWCOUNT, COLCOUNT);
    Ship s = new Ship(playingField, 14, 2, 14, 5, false);
    Ship s1 = new Ship(playingField, 9, 0, 11, 0, false);
    switch (level) {
      case 1:
        _shipLengths = [2, 2, 3, 4, 5];
        break;
    //TODO: complete level implementation
    }
  }

  void fireAt(int row, int col) {
    playingField.fireAt(row, col);
  }
}

class Enemy {
  int _strategy;
  GameModel _model;
  Random _rng;
  int prevHitRow;
  int prevHitCol;

  set strategy(int value) => _strategy = value;
  int get strategy => _strategy;
  set model(GameModel value) => _model = value;
  GameModel get model => _model;

  Enemy(int strategy, List<int> ShipLengths) {
    this.strategy = strategy;
    _rng = new Random(100);
  }

  void placeShips(int shipCount) {
    //TODO: enemy places their ships
    // Just a level dummy for testing
  }

  void makeMove() {
    switch (strategy) {
      case 1:
        randomMove();
        break;
      case 2:
        mediocreMove();
        break;
      case 3:
        cleverMove();
        break;
    }
    print("Strategy doesn't exist");
  }

  void randomMove() {
    int row = _rng.nextInt(model.playingField.fields.length);
    int col = _rng.nextInt(model.playingField.fields[0].length);
    model.fireAt(row, col);
    prevHitRow = row;
    prevHitCol = col;
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

  List<List<Field>> get fields => _fields;
  set fields(List<List<Field>> fields) => _fields = fields;
  List<Ship> get ships => _ships;
  set ships(List<Ship> ships) => _ships = ships;
  //List<Entity> get terrain => _terrain;
  //set terrain(List<Entity> terrain) => _terrain = terrain;

  PlayingField(int rows, int cols) {
    var outerList = new List<List<Field>>(rows);
    for (int row = 0; row < rows; row++) {
      var innerList = new List<Field>(cols);
      for (int col = 0; col < cols; col++) {
        innerList[col] = row >= rows / 2 ? new Field(row, col, false): new Field(row, col, true);
      }
      outerList[row] = innerList;
    }
    fields = outerList;

    ships = new List<Ship>();
    //terrain = new List<Entity>();
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

  void placeShips() {
    for (int i = 0; i < ships.length; i++) {
      ships[i].place();
    }
  }

  void buildShip(int row, int col) {

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
  String toString() => entity == null ? "." : entity is Ship ? "S" : entity is Rock ? "R" : "P";
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

  Ship(PlayingField pField, int startRow, int startCol, int endRow, int endCol, bool reenters) : super(pField, null){
    playingField.ships.add(this);
    this.destroyed = false;
    this.playingField = pField;
    fields = new List<Field>();
    if (startRow == endRow) { // for horizontal ships
      if (reenters) {
        if (startCol < endCol) {
          var dummy = startCol;
          startCol = endCol;
          endCol = dummy;
        }
        for (int col = startCol; col < playingField.fields[startRow].length;col++) {
          fields.add(playingField.fields[startRow][col]);
        }
        for (int col = 0; col <= endCol; col++) {
          fields.add(playingField.fields[startRow][col]);
        }
      } else {
        if (startCol > endCol) { // swap start and endcol if endcol < startcol
          var dummy = startCol;
          startCol = endCol;
          endCol = dummy;
        }
        for (int col = startCol; col <= endCol; col++) {
          fields.add(playingField.fields[startRow][col]);
        }
      }
      vertical = false;
    } else if (startCol == endCol){ // for vertical ships
      if (startRow > endRow) {      // swap start and endrow if endrow < startrow
        var dummy = startRow;
        startRow = endRow;
        endRow = dummy;
      }
      for (int row = startRow; row <= endRow; row++) {
        fields.add(playingField.fields[row][startCol]);
      }
      vertical = true;
    } else {
      print("Ships have to be aligned either vertically or horizontally.");
    }
    place();
  }

  bool isDamaged() {
    for (int i = 0; i < fields.length; i++) {
      if (fields[i].hit) return true;
    }
    return false;
  }

  void fireAt(Field f) {
    f.hit = true;
  }

  void sinkShip(){//TODO: sink ship and replace field with water
    for(int i = 0; i < fields.length; i++) {
      if (fields[i].entity == this) fields[i].entity = null;
    }
    playingField.ships.remove(this);
  }

  void move(int distance) {
    // TODO: make ships reenter the playing field from the opposite side if moved beyond borders
    if (vertical) {
      playingField.ships[playingField.ships.indexOf(this)] = new Ship(playingField, fields.first.row + distance, fields.first.col,
          fields.last.row + distance, fields.last.col, false);
    } else {
      playingField.ships[playingField.ships.indexOf(this)] = new Ship(playingField, fields.first.row, fields.first.col + distance,
          fields.last.row, fields.last.col + distance, fields.first.row + distance < 0 || fields.last.row + distance > playingField.fields.length);
    }
    sinkShip();
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

*/