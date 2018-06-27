part of warships;

class GameModel {
  Enemy _enemy;
  PlayingField _playingField;
  List<Map> levels;
  Enemy get enemy => _enemy;
  PlayingField get playingField => _playingField;
  set playingField(PlayingField field) => _playingField = field;

  GameModel() {
    playingField = new PlayingField(ROWCOUNT, COLCOUNT);
    _enemy = new Enemy(this);
    _enemy = new Enemy(this);
    loadLevels();
  }

  void generatePlayingField(int level) {
    playingField.newGame();
    playingField.generateField(levels[level - 1]);
    enemy.strategy = levels[level - 1]["enemyStrategy"];
    enemy.placeShips(playingField);
    enemy.resetAI();
  }

  int randomLevel() {
    int lvlCount = levels.length;
    Random rng = new Random();
    return 1 + rng.nextInt(lvlCount);
  }

  void loadLevels() {
    HttpRequest.getString("levels.json").then((resp) => levels = JSON.decode(resp));
  }

  void fireAt(int row, int col) {
    playingField.fireAt(row, col);
  }

}

class Enemy {

  bool hitMove = false;
  List<int> firstHitMove = [0, 0];
  List<int> lastHitMove = [-1, 0];
  List<int> postionHitMove = [0, 0];
  String lastDirectionMove = "no direction";
  
  bool strategieMove = false;

  List<int> allHitsColMove = [];
  List<int> allHitsRowMove = [];

  int sunkShipCount = 0;

  int _strategy;
  GameModel _model;
  Random _rng;
  List<int> shipLengths;

  set strategy(int value) => _strategy = value;
  int get strategy => _strategy;
  set model(GameModel value) => _model = value;
  GameModel get model => _model;

  Enemy(GameModel model) {
    this.model = model;
    this.strategy = 0;
    _rng = new Random();
  }

  void placeShips(PlayingField pf) {  // It's possible, that a ship can't be placed, because there's no more space left on the playing field
    for (int i = 0; i < pf.enemyShipLengths.length; i++) {
      while(pf.enemyShipCount() < pf.enemyShipLengths.length) {
        Field f = pf.randomField(0, pf.rowCount ~/ 2);
        pf.buildShip(f.row, f.col, false);
      }
    }
  }

  void makeMove() {

    switch (_strategy) {
      case 0:
        randomMove();
        break;
      case 1:
        mediocreMove();
        break;
      case 2:
        hardcoreMove();
        break;
      case 3:
        randomHardcoreMove();
        break;
    }
  }

  void randomMove() {
    bool shot = false;
    int halfROWCOUNT;
    if(ROWCOUNT.isEven)halfROWCOUNT = (ROWCOUNT / 2).toInt();
    else{halfROWCOUNT = ((ROWCOUNT+1) / 2).toInt();}
    while(shot == false) {
      int row = halfROWCOUNT + _rng.nextInt(ROWCOUNT - halfROWCOUNT);
      int col = _rng.nextInt(COLCOUNT);
      if(model.playingField[row][col]._hit == false) {
        model.fireAt(row, col);
        shot = true;
      }
    }
  }

  void mediocreMove() { // for a lack of a better name

    int row = postionHitMove[0];
    int col = postionHitMove[1];
    List<int> list = [0, 0];

    list = [row, col];
    if(hitMove == false){

      template(list);

    } else {
      foundShip();
    }
    postionHitMove[0] = row;
    postionHitMove[1] = col;
  }

  void hardcoreMove() {

    int row = postionHitMove[0];
    int col = postionHitMove[1];
    List<int> list = [0, 0];

    if(strategieMove == false){
      col = _rng.nextInt(2);
      strategieMove = true;
    }

    list = [row, col];
    if(hitMove == false){

      template(list);

    } else {
      foundShip();
    }
    postionHitMove[0] = row;
    postionHitMove[1] = col;
  }

  void randomHardcoreMove() {

    int row = postionHitMove[0];
    int col = postionHitMove[1];
    List<int> list = [0, 0];

    if(strategieMove == false){
      col = _rng.nextInt(model.playingField._colCount);
      row = _rng.nextInt(model.playingField._rowCount - model.playingField._enemyRows);
      strategieMove = true;
    }

    list = [row, col];
    if(hitMove == false){

      template(list);

    }else{

      foundShip();

    }
    postionHitMove[0] = row;
    postionHitMove[1] = col;
  }

  void resetAI(){

    sunkShipCount = 0;

    hitMove = false;
    firstHitMove = [0, 0];
    lastHitMove = [-1, 0];
    postionHitMove = [0, 0];
    lastDirectionMove = "no direction";

    strategieMove = false;
    allHitsColMove = [];
    allHitsRowMove = [];
  }

  bool checkSunkShip(){
    int counter = 0;
    for(int i = 0; i < model.playingField.ships.length; i++){
      if(model.playingField.ships[i].sunk == true && model.playingField.ships[i].friendly == true)counter++;
    }
    if(counter > sunkShipCount){
      sunkShipCount = counter;
      return true;
    }
    return false;
  }
  
  void template(List<int> list){
    int row = list[0];
    int col = list[1];
    int halfROWCOUNT = model.playingField._enemyRows;
    int rowcount = model.playingField._rowCount;
    int colcount = model.playingField._colCount;

    if(model.playingField[row + halfROWCOUNT][col]._hit == false) {
      model.fireAt(row + halfROWCOUNT, col);

      if(model.playingField[row + halfROWCOUNT][col]._entity != null) {
        hitMove = true;
        firstHitMove[0] = (row+halfROWCOUNT);
        firstHitMove[1] = col;
        allHitsRowMove.add(row+halfROWCOUNT);
        allHitsColMove.add(col);
        if(checkSunkShip() == true)hitMove = false;
      }
    }else {
      do {
        if (row + halfROWCOUNT == rowcount - 1 && col == colcount - 2) {
          row = 0;
          if (rowcount.isOdd) {
            col = colcount.isEven ? 1 : 0;
          } else {
            col = colcount.isEven ? 0 : 1;
          }
        } else if (row + halfROWCOUNT == rowcount - 1 && col == colcount - 1) {
          row = 0;
          if (rowcount.isOdd) {
            col = colcount.isEven ? 0 : 1;
          } else {
            col = colcount.isEven ? 1 : 0;
          }
        } else if (col == colcount - 1) {
          row++;
          col = colcount.isEven ? 0 : 1;
        } else if (col == colcount - 2) {
          row++;
          col = colcount.isEven ? 1 : 0;
        } else {
          col += 2;
        }
      } while (model.playingField[row + halfROWCOUNT][col]._hit == true);

      model.fireAt(row + halfROWCOUNT, col);

      if (model.playingField[row + halfROWCOUNT][col]._entity != null) {
        hitMove = true;
        firstHitMove[0] = (row + halfROWCOUNT);
        firstHitMove[1] = col;
        allHitsRowMove.add(row+halfROWCOUNT);
        allHitsColMove.add(col);
        if (checkSunkShip() == true) hitMove = false;
      }
    }
  }

  void foundShip(){

    int halfROWCOUNT = model.playingField._enemyRows;
    int rowcount = model.playingField._rowCount;
    int colcount = model.playingField._colCount;
    int x, y, top, right, down, left;
    bool shot = false;

    while(shot == false) {

      if(lastHitMove[0] == -1){
        x = firstHitMove[0];
        y = firstHitMove[1];

      }else{
        x = lastHitMove[0];
        y = lastHitMove[1];
      }

      top = x - 1;
      if(top <= halfROWCOUNT){}
      right = y + 1;
      if(right >= colcount)right -= colcount;
      down = x + 1;
      if(down >= rowcount)down -= rowcount;
      left = y - 1;
      if(left < 0)left += colcount;

      switch (lastDirectionMove) {
        case "top":
          if (model.playingField[top][y]._hit == false &&
              model.playingField[top][y]._foggy == false) {
            model.fireAt(top, y);

            if(model.playingField[top][y]._entity != null) {
              lastHitMove[0] = top;
              lastHitMove[1] = y;
              allHitsRowMove.add(top);
              allHitsColMove.add(y);
            }

            if(checkSunkShip() == true) {
              hitMove = false;
              lastHitMove[0] = -1;
              lastDirectionMove = "no direction";
              int l = allHitsRowMove.length;
              for(int p = 0; p < l; p++) {
                for (int z = 0; z <= 5; z++) {
                  if(allHitsRowMove.length > p) {
                    if (allHitsRowMove[p] == (top + z) && allHitsColMove[p] == y) {
                      allHitsRowMove.removeAt(p);
                      allHitsColMove.removeAt(p);
                      z = 0;
                      l--;
                    }
                  }
                }
              }
              if(allHitsRowMove.length != 0){
                firstHitMove[0] = allHitsRowMove[0];
                firstHitMove[1] = allHitsColMove[0];
                hitMove = true;
                lastHitMove[0] = -1;
              }
            }

            shot = true;
          } else {
            lastDirectionMove = "down";
            lastHitMove[0] = -1;
          }
          break;
        case "right":
          if (model.playingField[x][right]._hit == false) {
            model.fireAt(x, right);

            if(model.playingField[x][right]._entity != null) {
              lastHitMove[0] = x;
              lastHitMove[1] = right;
              allHitsRowMove.add(x);
              allHitsColMove.add(right);
            }

            if(checkSunkShip() == true) {
              hitMove = false;
              lastHitMove[0] = -1;
              lastDirectionMove = "no direction";
              int l = allHitsRowMove.length;
              for(int p = 0; p < l; p++) {
                for (int z = 0; z <= 5; z++) {
                  if(allHitsRowMove.length > p) {
                    if(allHitsColMove[p] == right-z && allHitsRowMove[p] == x){
                      allHitsRowMove.removeAt(p);
                      allHitsColMove.removeAt(p);
                      z = 0;
                      l--;
                    }
                  }
                }
              }
              if(allHitsRowMove.length != 0){
                firstHitMove[0] = allHitsRowMove[0];
                firstHitMove[1] = allHitsColMove[0];
                hitMove = true;
                lastHitMove[0] = -1;
              }
            }

            shot = true;
          } else {
            lastDirectionMove = "left";
            lastHitMove[0] = -1;
          }
          break;
        case "down":
          if (model.playingField[down][y]._hit == false &&
              model.playingField[down][y]._foggy == false) {
            model.fireAt(down, y);

            if(model.playingField[down][y]._entity != null) {
              lastHitMove[0] = down;
              lastHitMove[1] = y;
              allHitsRowMove.add(down);
              allHitsColMove.add(y);
            }

            if(checkSunkShip() == true) {
              hitMove = false;
              lastHitMove[0] = -1;
              lastDirectionMove = "no direction";
              int l = allHitsRowMove.length;
              for(int p = 0; p < l; p++) {
                for (int z = 0; z <= 5; z++) {
                  if(allHitsRowMove.length > p) {
                    if (allHitsRowMove[p] == (down - z) && allHitsColMove[p] == y) {
                      allHitsRowMove.removeAt(p);
                      allHitsColMove.removeAt(p);
                      z = 0;
                      l--;
                    }
                  }
                }
              }
              if(allHitsRowMove.length != 0){
                firstHitMove[0] = allHitsRowMove[0];
                firstHitMove[1] = allHitsColMove[0];
                hitMove = true;
                lastHitMove[0] = -1;
              }
            }

            shot = true;
          } else {
            lastDirectionMove = "right";
            lastHitMove[0] = -1;
          }
          break;
        case "left":
          if (model.playingField[x][left]._hit == false) {
            model.fireAt(x, left);

            if(model.playingField[x][left]._entity != null) {
              lastHitMove[0] = x;
              lastHitMove[1] = left;
              allHitsRowMove.add(x);
              allHitsColMove.add(left);
            }

            if(checkSunkShip() == true) {
              hitMove = false;
              lastHitMove[0] = -1;
              lastDirectionMove = "no direction";
              int l = allHitsRowMove.length;
              for(int p = 0; p < l; p++) {
                for (int z = 0; z <= 5; z++) {
                  if(allHitsRowMove.length > p) {
                    if(allHitsColMove[p] == left+z && allHitsRowMove[p] == x){
                      allHitsRowMove.removeAt(p);
                      allHitsColMove.removeAt(p);
                      z = 0;
                      l--;
                    }
                  }
                }
              }
              if(allHitsRowMove.length != 0){
                firstHitMove[0] = allHitsRowMove[0];
                firstHitMove[1] = allHitsColMove[0];
                hitMove = true;
                lastHitMove[0] = -1;
              }
            }

            shot = true;
          } else {
            hitMove = false;
            lastHitMove[0] = -1;
            lastDirectionMove = "no direction";
            shot = true;
            print("muss wohl ein Felsen sein");
            mediocreMove();
          }
          break;
        case "no direction":

          lastDirectionMove = "top";
          break;
        default:
          lastHitMove[0] = -1;
          print("Hier passiert nichts");
          break;
      }
    }
  }
}

/**
 * The PlayingField class contains all entities of the game. It is divided into
 * the northern half and the southern half each of which function as one party's
 * territory
 */
class PlayingField {
  /**
   * A 2d list containing all tiles(Fields) of the playing field
   */
  List<List<Field>> _fields;

  /**
   * A list containing both party's ships
   */
  List<Ship> _ships;

  /**
   * A list containing the lengths of the player's ships
   */
  List<int> _playerShipLengths;

  /**
   * The lengths of the enemy's ships
   */
  List<int> _enemyShipLengths;

  /**
   * The player's ship builder
   */
  ShipBuilder _playerBuilder;

  /**
   * the enemy's ship builder
   */
  ShipBuilder _enemyBuilder;

  /**
   * the player's ship mover
   */
  ShipMover _mover;

  /**
   * the playing fields's number of rows
   */
  int _rowCount;

  /**
   * the playing field's number of columns
   */
  int _colCount;

  /**
   * the amount of the enemy territory's rows
   */
  int _enemyRows;

  /**
   * the radius power ups left turns
   */
  int _radiusPuRounds;

  operator [](int index) => _fields[index];

  List<Ship> get ships => _ships;
  List<int> get playerShipLengths => _playerShipLengths;
  List<int> get enemyShipLengths => _enemyShipLengths;
  int get rowCount => _rowCount;
  int get colCount => _colCount;
  int get enemyRows => _enemyRows;
  set radiusPuRounds(int rounds) => _radiusPuRounds = rounds;

  /**
   * creates a new PlayingField instance
   * @param rows the playing field's number of rows
   * @param cols the playing field's number of columns
   */
  PlayingField(int rows, int cols) {
    this._rowCount = rows;
    this._colCount = cols;
    _enemyRows = rowCount ~/ 2;
    _fields = initializeFields(rows, cols);
    _ships = new List<Ship>();
    _radiusPuRounds = 0;
  }

  /**
   * resets the playing field for a new game
   */
  void newGame() {
    _fields = initializeFields(rowCount, colCount);
    _ships = new List<Ship>();
  }

  /**
   * @param rows the playing field's number of rows
   * @param cols the playing field's number of columns
   */
  List<List<Field>> initializeFields(int rows, int cols) {
    var outerList = new List<List<Field>>(rows);
    for (int row = 0; row < rows; row++) {
      var innerList = new List<Field>(cols);
      for (int col = 0; col < cols; col++) {
        innerList[col] = row >= _enemyRows ? new Field(row, col, false): new Field(row, col, true); // ??
      }
      outerList[row] = innerList;
    }
    return outerList;
  }

  /**
   * Attacks a specific tile of the playing field
   * @param row the target field's row
   * @param col the target field's column
   */
  void fireAt(int row, int col) {
    if (row < _enemyRows) {
      _fields[row][col].fireAt();
      if (_radiusPuRounds > 0) {
        _radiusPuRounds--;
        Field f = _fields[row][col];
        if (north(f) != null) north(f).fireAt();
        east(f).fireAt();
        if (south(f).row < enemyRows)south(f).fireAt();
        west(f).fireAt();
      }
    } else {
      _fields[row][col].fireAt();

    }
  }

  /**
   * generates a random field with a given number of rocks, power ups and ships
   * @param level a map containing the information for the generation of the playingField
   */
  void generateField(Map level) {// TODO: complete
    _playerShipLengths = level["playerShips"];
    _enemyShipLengths = level["enemyShips"];
    for (int i = 0; i < level["playerRocks"]; i++) {
      Field f = randomField(0, rowCount ~/ 2);
      if (f.entity == null) {
        f.entity = new Rock(this, f.row, f.col);
      } else {
        i--;
      }
    }
    for (int i = 0; i < level["enemyRocks"]; i++) {
      Field f = randomField(enemyRows, rowCount);
      if (f.entity == null) {
        f.entity = new Rock(this, f.row, f.col);
      } else {
        i--;
      }
    }
    for (int i = 0; i < level["enemyPowUps"]; i++) {
      Field f = randomField(0, enemyRows);
      if (f.entity == null) {
        f.entity = new PowerUp(this, f.row, f.col);
      } else {
        i--;
      }
    }
  }

  /**
   * provides a random tile from the playing field between a minimal row and a maximal row
   * @param minRow the minimal row
   * @param maxRow the maximal row
   * @returns a random field between the min- and maxRow
   */
  Field randomField(int minRow, int maxRow) {
    Random rng = new Random();
    int row;
    int col;
    col = rng.nextInt(colCount);
    row = minRow + rng.nextInt(maxRow - minRow);
    return _fields[row][col];
  }

  /**
   * checks if there are any ships left to build
   * @returns true if all ships are built, false if not
   */
  bool shipBuildingComplete() {
    return playerShipCount() >= playerShipLengths.length;
  }

  /**
   * adds a ship to the playingfield
   * @param ship the ship to be added
   */
  void addShip(Ship ship) {
    ships.add(ship);
    ship.place();
  }

  /**
   * adds a ShipBuilder to construct a ship
   * @param row the target row for the ship builder
   * @param col the target col for the ship builder
   * @returns true if ship is completed, false if not
   */
  bool buildShip(int row, int col, bool friendly) {
    Field f = _fields[row][col];
    if (f.entity == null/* && !f.foggy*/) {
      if (friendly) {
        if (_playerBuilder != null) _playerBuilder.remove();
        _playerBuilder = new ShipBuilder(this, row, col, playerShipLengths[playerShipCount()], true);
      } else {
        if (_enemyBuilder != null) _enemyBuilder.remove();
        _enemyBuilder = new ShipBuilder(this, row, col, enemyShipLengths[enemyShipCount()], false);
        Field dir = _enemyBuilder.randomDirection();
        return buildShip(dir.row, dir.col, false);
      }
    } else if(f.entity is ShipBuilder) {
      ShipBuilder sb = f.entity;
      sb.buildShip(f);
      return true;
    }
    return false;
  }

  /**
   * adds a ShipMover to move a ship
   * @param row the target row for the ship mover
   * @param col the target col for the ship mover
   * @returns true if the ship has been moved, false if not
   */
  bool moveShip(int row, int col) {
    if (_fields[row][col].entity is Ship) {
      Ship s = _fields[row][col].entity;
      if (_mover != null)_mover.remove();
      _mover = new ShipMover(this, s);
    } else if (_fields[row][col].entity is ShipMover){
      ShipMover m = _fields[row][col].entity;
      m.moveShip(_fields[row][col]);
      return true;
    }
    return false;
  }

  /**
   * removes the ShipMovers from the playing field
   */
  void removeMovers() {
    if (_mover != null)
    _mover.remove();
  }

  /**
   * checks if the game is over
   * @returns true if the game is over, false if not
   */
  bool gameOver() {
    return playerShipCount() <= 0 || enemyShipCount() <= 0;
  }

  /**
   * counts the enemy's ships which have not sunk
   * @return the number of enemy ships which have not sunk
   */
  int enemyShipCount() {
    int count = 0;
    ships.forEach((s) => count += !s.friendly && !s.sunk ? 1 : 0);
    return count;
  }

  /**
   * counts the player's ships which have not sunk
   * @return the number of player ships which have not sunk
   */
  int playerShipCount() {
    int count = 0;
    ships.forEach((s) => count += s.friendly && !s.sunk ? 1 : 0);
    return count;
  }

  /**
   * finds the field to the north of a known field if there is one
   * @param f the known field
   * @returns the field to the north of the known field if there is one, else null
   */
  Field north(Field f) {
    if (_fields[f.row][f.col] != null) {
      if (f.row - 1 < 0) return null;
      else return _fields[f.row - 1][f.col];
    }
    return null;
  }
  /**
   * finds the field to the east of a known field
   * @param f the known field
   * @returns the field to the east of the known field if there is none
   *          the first field of the known field's row is returned
   */
  Field east(Field f) {
    if (_fields[f.row][f.col] != null) {
      if (f.col + 1 >= colCount) return _fields[f.row][0];
      else return _fields[f.row][f.col + 1];
    }
    return null;
  }

  /**
   * finds the field to the south of a known field if there is one
   * @param f the known field
   * @returns the field to the south of the known field if there is one, else null
   */
  Field south(Field f) {
    if (_fields[f.row][f.col] != null) {
      if (f.row + 1 >= rowCount) return null;
      else return _fields[f.row + 1][f.col];
    }
    return null;
  }
  /**
   * finds the field to the west of a known field
   * @param f the known field
   * @returns the field to the west of the known field if there is none
   *          the last field of the known field's row is returned
   */
  Field west(Field f) {
    if (_fields[f.row][f.col] != null) {
      if (f.col - 1 < 0)
        return _fields[f.row][colCount - 1];
      else
        return _fields[f.row ][f.col - 1];
    }
    return null;
  }
}

class Field{
  int _row;
  int _col;
  int _hitCounter = 0;
  bool _hit;
  bool _foggy;
  Entity _entity;

  int get row => _row;
  set row(int row) => _row = row;
  int get col => _col;
  set col(int col) => _col = col;
  int get hitCounter => _hitCounter;
  set hitCounter(int hitCounter) => _hitCounter = hitCounter;
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
    hitCounter++;
    if (entity is Ship) {
      Ship s = entity;
      s.fireAt(this);
    } else if (entity is PowerUp) {
      PowerUp p = entity;
      p.activate();
      hit = true;
    } else {
      hit = true;
    }
  }
}

class Entity {
  PlayingField _playingField;

  PlayingField get playingField => _playingField;
  set playingField(PlayingField value) => _playingField = value;

  Entity(PlayingField playingField) {
    this.playingField = playingField;
  }
}

class Ship extends Entity {
  bool destroyed;
  bool _vertical;
  bool _friendly;
  bool _sunk;
  List<Field> fields;

  bool get vertical => _vertical;
  set vertical(bool value) => _vertical = value;
  bool get friendly => _friendly;
  bool get sunk => _sunk;

  Ship(PlayingField pField, List<Field> fields, bool friendly) : super(pField) {
    destroyed = false;
    this._friendly = friendly;
    this.vertical = fields.first.col == fields.last.col;
    this.fields = fields;
    _sunk = false;
    if (fields.last != back()) {
      this.fields = fields.reversed.toList();
    }
  }

  static Ship makeShip(PlayingField pf, List<Field> fields, bool friendly) {
    switch (fields.length) {
      case 2:
        return new Destroyer(pf, fields, friendly);
        break;
      case 3:
        return new Submarine(pf, fields, friendly);
        break;
      case 4:
        return new BattleShip(pf, fields, friendly);
        break;
      case 5:
        return new Carrier(pf, fields, friendly);
        break;
    }
    return null;
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
      if (fields[i].col == playingField.colCount - 1)
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
          if (fields[i].col == playingField.colCount - 1 &&
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
      print("Schiff versenkt");//Hier könnte ihr animierter Code stehen
    }
  }

  void sinkShip() {
    _sunk = true;
  }

  void move(int dir) {
    List<Field> newShip = new List<Field>();
    for (int i = 0; i < fields.length; i++) {
        Field f = fields[i];
        if (dir < 0) {
          newShip.add(vertical ? playingField.north(f) : playingField.west(f));
        } else if (dir > 0){
          newShip.add(vertical ? playingField.south(f) : playingField.east(f));
        }
    }

    fields.forEach((f) => f.entity = null);
    playingField.ships.remove(this);

    playingField.addShip(Ship.makeShip(playingField, newShip, friendly));
  }


}

class Carrier extends Ship {
  Carrier(PlayingField pf, List<Field> fields, bool friendly) : super(pf, fields, friendly);
}

class BattleShip extends Ship {
  BattleShip(PlayingField pf, List<Field> fields, bool friendly) : super(pf, fields, friendly);
}

class Submarine extends Ship {
  Submarine(PlayingField pf, List<Field> fields, bool friendly) : super(pf, fields, friendly);
}

class Destroyer extends Ship {
  Destroyer(PlayingField pf, List<Field> fields, bool friendly) : super(pf, fields, friendly);
}

class Rock extends Entity {
  Field _field;

  Field get field => _field;

  Rock(PlayingField field, int row, int col) : super(field) { // maybe construct via field and not via row/col
    _field = field[row][col];
  }

  void place() {
    _field.entity = this;
  }
}

class PowerUp extends Entity { // The type of powerup is determined randomly on activation
  Field _field;

  Field get field => _field;

  PowerUp(PlayingField field, int row, int col) : super(field) {
    _field = field[row][col];
  }

  void place() {
    _field.entity = this;
  }

  void activate() {
    Random rng = new Random();
    int type = rng.nextInt(2);
    switch(type) {
      case 0:
        radiusPu();
        break;
      case 1:
        visionPu();
        break;
      case 2: // not reachable
      //activate pu2
        break;
    }
    print("PowerUp aktiviert");
    field.entity = null;
  }

  // makes one enemy Ship visible
  void visionPu() {
    Ship ship;
    for (int i = 0; i < playingField.ships.length; i++) {
      ship = playingField.ships[i];
      if (!ship.friendly){
        ship.fields.forEach((Field f) => f.foggy = false);
        break;
      }
    }
    field.entity = null;
  }

  // increases radius of attacks
  void radiusPu() {
    playingField.radiusPuRounds = 2;
  }

}

class ShipBuilder extends Entity{
  int shipLength;
  int centerRow;
  int centerCol;
  List<Field> _fields;
  bool _friendly;

  List<Field> get fields => _fields;
  set fields(List<Field> fields) => _fields = fields;

  ShipBuilder(PlayingField field, int row, int col, int shipLength, bool friendly) : super(field) {
    this.shipLength = shipLength;
    this.fields = new List<Field>();
    this.centerRow = row;
    this.centerCol = col;
    this._friendly = friendly;
    //add fields to the list
    fields.add(field[row][col]);                                         // center
    fields.add(row - 1 >= 0 ? field[row - 1][col] : null);               // north
    fields.add(field[row][col + 1 < field.colCount ? col + 1 : 0]);      // east
    fields.add(row + 1 < field.rowCount ? field[row + 1][col] : null);   // south
    fields.add(field[row][col - 1 >= 0 ? col - 1 : field.colCount - 1]); // west

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
          if (c < 0) c = field.colCount - 1;
          if (c >= field.colCount) c = 0;
          if (r >= field.rowCount || r < 0) {
            unOccupied = false;
          } else if (field[r][c].entity != null
              || (_friendly && field[r][c].foggy)
              || (!_friendly && !field[r][c].foggy)) {
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
          c = playingField.colCount - 1;
        }
        if (c >= playingField.colCount) {
          c = 0;
        }
        shipFields.add(playingField[r][c]);
      }
      remove();
      playingField.addShip(Ship.makeShip(playingField, shipFields, _friendly));
    }
  }

  Field randomDirection() {
    var fieldsClean = fields;
    fieldsClean.removeWhere((f) => f == null);
    if (fieldsClean.length == null) return null;  // in case no direction is possible
    var rng = new Random();
    var index = rng.nextInt(fieldsClean.length);
    return fieldsClean[index];
  }

}

class ShipMover extends Entity {
  Ship _ship;
  List<Field> _fields;
  List<Field> get fields => _fields;
  Ship get ship => _ship;


  ShipMover(PlayingField pf, Ship ship) : super(pf) {
    _ship = ship;
    _fields = new List<Field>();
    if (!ship.isDamaged()) {
      if (!ship.vertical) {
        _fields.add(pf.west(ship.fields.first));
        _fields.add(pf.east(ship.fields.last));
      } else {
        _fields.add(pf.north(ship.fields.first));
       // _fields.add(null);
        _fields.add(pf.south(ship.fields.last));
      }

      //place
      for (int i = 0; i < _fields.length; i++) {
        if (fields[i].entity == null && !fields[i].hit) {
          _fields[i].entity = this;
        }
      }
    }
  }

  void moveShip(Field direction) {
    remove();
    if (_fields.indexOf(direction) == 0) {
      _ship.move(-1);
    } else {
      _ship.move(1);
    }
  }

  void remove() {
    for (int i = 0; i < _fields.length; i++) {
      if (_fields[i].entity == this) {
        _fields[i].entity = null;
      }
    }
  }
}