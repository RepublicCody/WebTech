part of warships;

// TODO: add classes for Moves
class GameModel{
  Enemy _enemy;
  PlayingField _playingField;

  Enemy get enemy => _enemy;
  PlayingField get playingField => _playingField;
  set playingField(PlayingField field) => _playingField = field;

  GameModel(int rows, int cols) {
    playingField = new PlayingField(rows, cols);
  }
}

class Enemy {
  int _strategy;
  GameModel _gamemodel;

  set strategy(int value) => _strategy = value;
  set gamemodel(GameModel value) => _gamemodel = value;

  Enemy(int strategy) {
    this.strategy = strategy;
  }

  void placeShips() {
    //TODO: enemy places their ships
  }

  void makeMove() {
    // TODO: enemy makes his moves here, resulting move depends on strategy
  }
}

class PlayingField {
  List<List<Field>> _fields;
  List<Ship> _ships;
  List<Terrain> _terrain;

  List<List<Field>> get fields => _fields;
  set fields(List<List<Field>> fields) => _fields = fields;
  List<Ship> get ships => ships;
  set ships(List<Ship> ships) => _ships = ships;

  PlayingField(int rows, int cols) {
    var outerList = new List<List<Field>>(rows);
    for (int row = 0; row < rows; row++) {
      var innerList = new List<Field>(cols);
      for (int col = 0; col < cols; col++) {

        innerList[col] = row >= rows / 2 ? new Field(row, col, "water"): new Field(row, col, "fog");
      }
      outerList[row] = innerList;
    }
    fields = outerList;
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
  String _entity;

  int get row => _row;
  set row(int row) => _row = row;
  int get col => _col;
  set col(int col) => _col = col;
  bool get hit => _hit;
  set hit(bool hit) => _hit = hit;
  String get entity => _entity;
  set entity(String entity) => _entity = entity;

  Field(int row, int col, String entity){
    this.row = row;
    this.col = col;
    hit = false;
    this.entity = entity;
  }

  void fireAt() {
    // TODO: fireAt logic
  }

  // just for testing purposes
  String toString() => entity == "ship" ? "S" : entity == "rock" ? "R" : entity == "power_up" ? "P" : ".";
}

class Ship{
  bool destroyed;
  bool _vertical;
  bool _friendly;
  PlayingField playingField;

  List<Field> _fields;
  List<Field> get fields => _fields;
  bool get vertical => _vertical;
  set vertical(bool value) => _vertical = value;
  set fields(List<Field> fields) => _fields = fields;

  Ship(PlayingField pField, int startRow, int startCol, int endRow, int endCol){
    this.destroyed = false;
    this.playingField = pField;
    fields = new List<Field>();
    if (startRow == endRow) { // for horizontal ships
      for (int col  = startCol; col <= endCol; col++) {
        fields.add(playingField.fields[startRow][col]);
        //print("${startRow}-${col}"); //just for testing
      }
      vertical = false;
    } else if (startCol == endCol){ // for vertical ships
      for (int row = startRow; row <= endRow; row++) {
        fields.add(playingField.fields[row][startCol]);
        //print("${row}-${startCol}"); //just for testing
      }
      vertical = true;
    } else {
      print("Something went wrong");
    }
  }

  void place() {
    for (int i = 0; i < fields.length; i++) {
      fields[i].entity = "ship";
    }
  }

  void move(int distance) { // TODO: make ships reenter the playing field from the opposite side if moved beyond borders
    for (int i = 0; i < fields.length; i++) {
      fields[i] = vertical ? playingField.fields[fields[i].row + distance][fields[i].col]
          : playingField.fields[fields[i].row][fields[i].col + distance];
    }
  }
}

class Terrain {
  Field _field;
  PlayingField _playingField;

  PlayingField get playingField => _playingField;
  set playingField(PlayingField value) => _playingField = value;
  Field get field => _field;
  set field(Field value) => _field = value;

  Terrain(PlayingField playingField, int row, int col) {
    this.playingField = playingField;
    this.field = this.playingField.fields[row][col];
  }
}

class Rock extends Terrain {
  Rock(PlayingField field, int row, int col) : super(field, row, col);

  void place() {
    field.entity = "rock";
  }
}

class PowerUp extends Terrain {
  PowerUp(PlayingField field, int row, int col) : super(field, row, col);

  void place() {
    field.entity = "power_up";
  }

  void activate() {
    // TODO: activate the powerups effect
  }
}