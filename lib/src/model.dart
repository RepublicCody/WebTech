part of warships;

bool hitMedicoreMove = false;
List<int> firstHitMedicoreMove = [0, 0];
List<int> lastHitMedicoreMove = [-1, 0];
List<int> postionHitMedicoreMove = [0, 0];
String lastDirectionMedicoreMove = "no direction";

class GameModel {
  Enemy _enemy;
  PlayingField _playingField;
  Map levels;
  Enemy get enemy => _enemy;
  PlayingField get playingField => _playingField;
  set playingField(PlayingField field) => _playingField = field;

  GameModel() {
    playingField = new PlayingField(ROWCOUNT, COLCOUNT);
    _enemy = new Enemy(this, [4, 3, 3, 2, 2]);
    levelMap(); // TODO: try/catch
    print(levels);
  }

  void generatePlayingField(int level) {
    playingField.newGame();
    enemy.placeShips(playingField.fields);
    playingField.generateField(levels["level_${level}"]);
  }

  Future<Map> levelMap() async {
    var url = "levels.json";  //TODO: move this to a better location
    var response = await HttpRequest.request(url, method:'GET');
    levels = JSON.decode(response.responseText);
    return JSON.decode(response.responseText);
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
    else{halfROWCOUNT = ((ROWCOUNT+1) / 2).toInt();}

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
    mediocreMove();
    // implement strategy
  }

  void randomMove() {
    bool shot = false;
    int halfROWCOUNT;
    if(ROWCOUNT.isEven)halfROWCOUNT = (ROWCOUNT / 2).toInt();
    else{halfROWCOUNT = ((ROWCOUNT+1) / 2).toInt();}
    while(shot == false) {
      //int min = model.playingField.fields.length ~/ 2;
      int row = halfROWCOUNT + _rng.nextInt(ROWCOUNT - halfROWCOUNT);
      int col = _rng.nextInt(COLCOUNT);
      if(model.playingField.fields[row][col]._hit == false) {
        model.fireAt(row, col);
        shot = true;
      }
    }
  }

  void mediocreMove() { // for a lack of a better name
    int sLength;
    int halfROWCOUNT;
    if(ROWCOUNT.isEven)halfROWCOUNT = (ROWCOUNT / 2).toInt();
    else{halfROWCOUNT = ((ROWCOUNT+1) / 2).toInt();}
    int row = postionHitMedicoreMove[0];
    int col = postionHitMedicoreMove[1];
    int x, y, top, right, down, left;
    bool shot = false;
    bool directionTop = false, directionRight = false, directionDown = false, directionLeft = false;
    //print("row: $row und col $col");

    if(hitMedicoreMove == false){

      if(model.playingField.fields[row + halfROWCOUNT][col]._hit == false) {
        sLength = model.playingField.ships.length;
        model.fireAt(row + halfROWCOUNT, col);

        if(model.playingField.fields[row + halfROWCOUNT][col]._entity is Ship) {
          hitMedicoreMove = true;
          firstHitMedicoreMove[0] = (row+halfROWCOUNT);
          firstHitMedicoreMove[1] = col;
          if(sLength > model.playingField.ships.length)hitMedicoreMove = false;

        }


      }else{
        do {
          if(row + halfROWCOUNT == ROWCOUNT-1 && col >= COLCOUNT-2) {
            row = 0;
            col = 1;
          } else if(col == COLCOUNT-1){
            row++;
            col = 1;

          } else if(col == COLCOUNT-2){
            row++;
            col = 0;

          } else{
            col += 2;
          }print("row: $row und col $col");
        } while(model.playingField.fields[row + halfROWCOUNT][col]._hit == true);

        sLength = model.playingField.ships.length;
        model.fireAt(row + halfROWCOUNT, col);

        if(model.playingField.fields[row + halfROWCOUNT][col]._entity is Ship) {
          hitMedicoreMove = true;
          firstHitMedicoreMove[0] = (row+halfROWCOUNT);
          firstHitMedicoreMove[1] = col;
          if(sLength > model.playingField.ships.length)hitMedicoreMove = false;

        }
      }


    }else{

      int t = 4;


      while(shot == false) {

        if(lastHitMedicoreMove[0] == -1){
          x = firstHitMedicoreMove[0];
          y = firstHitMedicoreMove[1];

        }else{
          x = lastHitMedicoreMove[0];
          y = lastHitMedicoreMove[1];
        }

        top = x - 1;
        if(top <= halfROWCOUNT){}
        right = y + 1;
        if(right >= COLCOUNT)right -= COLCOUNT;
        down = x + 1;
        if(down >= ROWCOUNT)down -= ROWCOUNT;
        left = y - 1;
        if(left < 0)left += COLCOUNT;

        switch (lastDirectionMedicoreMove) {
          case "top":
            if (model.playingField.fields[top][y]._hit == false &&
                model.playingField.fields[top][y]._foggy == false) {
              t = 0;
              shot = true;
            } else {
              lastDirectionMedicoreMove = "down";
              lastHitMedicoreMove[0] = -1;
            }
            break;
          case "right":
            if (model.playingField.fields[x][right]._hit == false) {
              t = 1;
              shot = true;
            } else {
                lastDirectionMedicoreMove = "left";
                lastHitMedicoreMove[0] = -1;
            }
            break;
          case "down":
            if (model.playingField.fields[down][y]._hit == false &&
                model.playingField.fields[down][y]._foggy == false) {
              t = 2;
              shot = true;
            } else {
                lastDirectionMedicoreMove = "right";
                lastHitMedicoreMove[0] = -1;
            }
            break;
          case "left":
            if (model.playingField.fields[x][left]._hit == false) {
              t = 3;
              shot = true;
            } else {
                print("scheiße");
            }
            break;
          case "no direction":

              lastDirectionMedicoreMove = "top";
            break;
          default:
          lastHitMedicoreMove[0] = -1;
          t = 4;
            break;
        }
      }






        switch (t) {
          case 0:
            sLength = model.playingField.ships.length;
            model.fireAt(top, y);

            if(sLength > model.playingField.ships.length) {
              hitMedicoreMove = false;
              lastHitMedicoreMove[0] = -1;
              lastDirectionMedicoreMove = "no direction";
            }
            if(model.playingField.fields[top][y]._entity is Ship) {
              lastHitMedicoreMove[0] = top;
              lastHitMedicoreMove[1] = y;
            }

            break;
          case 1:
            sLength = model.playingField.ships.length;
            model.fireAt(x, right);

            if(sLength > model.playingField.ships.length) {
              hitMedicoreMove = false;
              lastHitMedicoreMove[0] = -1;
              lastDirectionMedicoreMove = "no direction";
            }
            if(model.playingField.fields[x][right]._entity is Ship) {
              lastHitMedicoreMove[0] = x;
              lastHitMedicoreMove[1] = right;
            }


            break;
          case 2:
            sLength = model.playingField.ships.length;
            model.fireAt(down, y);

            if(sLength > model.playingField.ships.length) {
              hitMedicoreMove = false;
              lastHitMedicoreMove[0] = -1;
              lastDirectionMedicoreMove = "no direction";
            }
            if(model.playingField.fields[down][y]._entity is Ship) {
              lastHitMedicoreMove[0] = down;
              lastHitMedicoreMove[1] = y;
            }


            break;
          case 3:
            sLength = model.playingField.ships.length;
            model.fireAt(x, left);

            if(sLength > model.playingField.ships.length) {
              hitMedicoreMove = false;
              lastHitMedicoreMove[0] = -1;
              lastDirectionMedicoreMove = "no direction";
            }
            if(model.playingField.fields[x][left]._entity is Ship) {
              lastHitMedicoreMove[0] = x;
              lastHitMedicoreMove[1] = left;
            }

            break;


          case 4:
            print("Hier passiert nichts");
            break;
        }


    }
    postionHitMedicoreMove[0] = row;
    postionHitMedicoreMove[1] = col;
  }

  void cleverMove() {
    //TODO: implement hard difficulty
  }
}

class PlayingField {
  List<List<Field>> _fields;
  List<Ship> _ships;
  List<int> _playerShipLengths;
  List<int> _enemyShipLengths;
  ShipBuilder _builder;
  int _rowCount;
  int _colCount;
  List<List<Field>> get fields => _fields;
  set fields(List<List<Field>> fields) => _fields = fields;
  List<Ship> get ships => _ships;
  set ships(List<Ship> ships) => _ships = ships;
  List<int> get playerShipLengths => _playerShipLengths;
  List<int> get enemyShipLengths => _enemyShipLengths;
  int get rowCount => _rowCount;
  int get colCount => _colCount;

  PlayingField(int rows, int cols) {
    this._rowCount = rows;
    this._colCount = cols;
    fields = initializeFields(rows, cols);
    ships = new List<Ship>();
    //terrain = new List<Entity>();
  }

  void newGame() {
    fields = initializeFields(rowCount, colCount);
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

  void generateField(Map level) {// TODO: complete
    _playerShipLengths = level["playerShips"];
    _enemyShipLengths = level["enemyShips"];

    for (int i = 0; i < level["playerRocks"]; i++) {
      Field f = randomField(0, rowCount ~/ 2);
      if (f.entity == null) {
        f.entity = new Rock(this, f.row, f.col);
        print("new Rock at ${f.row} - ${f.col}");
      } else {
        i--;
      }
    }

    for (int i = 0; i < level["playerRocks"]; i++) {
      Field f = randomField(rowCount ~/ 2, rowCount);
      if (f.entity == null) {
        f.entity = new Rock(this, f.row, f.col);
        print("new Rock at ${f.row} - ${f.col}");
      } else {
        i--;
      }
    }
  }

  Field randomField(int minRow, int maxRow) {
    Random rng = new Random();
    int row;
    int col;
    col = rng.nextInt(colCount);
    row = minRow + rng.nextInt(maxRow - minRow);
    return fields[row][col];
  }

  bool shipBuildingComplete() {
    return playerShipCount() >= playerShipLengths.length;
  }

  void addShip(Ship ship) {
    ships.add(ship);
    ship.place();
  }

  bool buildShip(int row, int col) {
    Field f = fields[row][col];
    if (f.entity == null && !f.foggy) {
      if (_builder != null)_builder.remove();
      _builder = new ShipBuilder(this, row, col, playerShipLengths[playerShipCount()]);
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

  int playerShipCount() {
    return ships.length - enemyShipCount();
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
  //List<Field> _fields;

  PlayingField get playingField => _playingField;
  set playingField(PlayingField value) => _playingField = value;
  //List<Field> get fields => _fields;
  //set fields(List<Field> value) => _fields = value;

  Entity(PlayingField playingField /*List<Field> fields*/) {
    this.playingField = playingField;
    //this.fields = fields;
  }
  /*
  void place() {
    for (int i = 0; i < fields.length; i++) {
      fields[i].entity = this;
    }
  }
  */
}

class Ship extends Entity {
  bool destroyed;
  bool _vertical;
  bool _friendly;
  List<Field> fields;

  bool get vertical => _vertical;
  set vertical(bool value) => _vertical = value;
  bool get friendly => _friendly;

  Ship(PlayingField pField, List<Field> fields, bool friendly) : super(pField) {
    destroyed = false;
    this._friendly = friendly;
    this.vertical = fields.first.col == fields.last.col;
    this.fields = fields;

    if (fields.last != back()) {
      this.fields = fields.reversed.toList();
    }
  }

  void place() {
    for (int i = 0; i < fields.length; i++) {
      fields[i].entity = this;
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
  Field _field;

  Field get field => _field;

  Rock(PlayingField field, int row, int col) : super(field) { // maybe construct via field and not via row/col
    _field = field.fields[row][col];
  }

  void place() {
    _field.entity = this;
  }
}

class PowerUp extends Entity {
  Field _field;

  Field get field => _field;

  PowerUp(PlayingField field, int row, int col) : super(field) {
    _field = field.fields[row][col];
  }

  void place() {
    _field.entity = this;
  }

  void activate() {
    // TODO: activate the powerups effect
  }
}

class ShipBuilder extends Entity{
  int shipLength;
  int centerRow;
  int centerCol;
  List<Field> _fields;

  List<Field> get fields => _fields;
  set fields(List<Field> fields) => _fields = fields;

  ShipBuilder(PlayingField field, int row, int col, int shipLength) : super(field) {
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
