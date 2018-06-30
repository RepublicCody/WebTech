part of warships;

/**
 * The game model contains the models components and is used by the controller.
 */
class GameModel {
  /**
   * the game's enemy
   */
  Enemy _enemy;

  /**
   * the game's playing field
   */
  PlayingField _playingField;

  Enemy get enemy => _enemy;
  PlayingField get playingField => _playingField;
  set playingField(PlayingField field) => _playingField = field;

  /**
   * creates a new GameModel instance
   */
  GameModel() {
    playingField = new PlayingField(ROWCOUNT, COLCOUNT);
    _enemy = new Enemy(this);
  }

  /**
   * generates a playing field according to one of the levels
   * @param level the id of the level, which should be generated
   */
  void generatePlayingField(Map level) {
    playingField.newGame();
    playingField.generateField(level);
    enemy.strategy = level["enemyStrategy"];
    enemy.placeShips(playingField);
    enemy.resetAI();
  }

  /**
   * fires at one of the playing field's fields
   * @param row the playing field's row to be fired at
   * @param col the playing field's col to be fired at
   */
  void fireAt(int row, int col) {
    playingField.fireAt(row, col);
  }

}

/**
 * Represents the player's enemy in the game. Contains various KIs for firing on the
 * player's ships and placing enemy ships.
 */
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

  /**
   * randomly places the enemy's ships
   * @param pf the games playing field
   */
  void placeShips(PlayingField pf) {  // It's possible, that a ship can't be placed, because there's no more space left on the playing field
    for (int i = 0; i < pf.enemyShipLengths.length; i++) {
      while(pf.enemyShipCount() < pf.enemyShipLengths.length) {
        Field f = pf.randomField(0, pf.rowCount ~/ 2);
        pf.buildShip(f.row, f.col, false);
      }
    }
  }

  /**
   * selects the strategy to exectute
   */
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

  /**
   * fires randomly at a field in the player's territory which has not been hit yet
   */
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

  /**
   * executes a move following a mediocre strategy
   */
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

  /**
   * executes a move following a clever strategy
   */
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

  /**
   * executes a move following a clever strategy, starting at a random field
   */
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

  /**
   * resets the ai for a new game
   */
  void resetAI() {

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

  /**
   * check if shot ships is sunk
   */
  bool checkSunkShip() {
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

  /**
   * maka a template move
   */
  void template(List<int> list) {
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

  /**
   * search for other parts of a ship
   */
  void foundShip() {

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
        innerList[col] = row >= _enemyRows ? new Field(row, col, false): new Field(row, col, true);
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

/**
 * The field class represents the tiles of the playing field. Each field can hold
 * an entity like for example a ship or a power up
 */
class Field{
  /**
   * the row in the field's PlayingField
   */
  int _row;

  /**
   * the column in the field's playing field
   */
  int _col;

  /**
   * amount of times the field has been fired at
   */
  int _hitCounter = 0;

  /**
   * describes if the field has been fired at
   */
  bool _hit;

  /**
   * true if the field is foggy, false if not
   */
  bool _foggy;

  /**
   * the entity this field holds
   */
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

  /**
   * creates a field instance
   * @param row the y position of the field on the playingfield
   * @param col the x position of the field on the playingfield
   * @param foggy true for foggy field else false
   */
  Field(int row, int col, bool foggy){
    this.row = row;
    this.col = col;
    this.foggy = foggy;
    this.hit = false;
    //this.entity = null;
  }

  /**
   * fires at the field and its entity if it holds one
   */
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

/**
 * Represents an object on the playing field like for example ships, rocks etc.
 */
class Entity {
  /**
   * the playing field, which contains the entity
   */
  PlayingField _playingField;

  PlayingField get playingField => _playingField;
  set playingField(PlayingField value) => _playingField = value;

  /**
   * Creates a new entity instance
   */
  Entity(PlayingField playingField) {
    this.playingField = playingField;
  }
}

/**
 * Represents a ship. A ship always belongs to one of the party's and has to be destroyed
 * by the other party in order to win the game. Ships can be moved according to their alignment.
 */
class Ship extends Entity {
  /**
   * true if the ship is aligned vertically from the player's perspective,
   * false if aligned horizontally
   */
  bool _vertical;

  /**
   * true if the ship belongs to the player, false if it belongs to the enemy
   */
  bool _friendly;

  /**
   * true if every part of the ship has been fired at, false if not
   */
  bool _sunk;

  /**
   * a list containing the fields, which hold the ship
   */
  List<Field> fields;

  bool get vertical => _vertical;
  set vertical(bool value) => _vertical = value;
  bool get friendly => _friendly;
  bool get sunk => _sunk;

  /**
   * Creates a new  ship instance
   * @param pField the playingField, which contains the ship
   * @param fields the fields, which contain the ship
   * @param friendly describes who the ship belongs to
   */
  Ship(PlayingField pField, List<Field> fields, bool friendly) : super(pField) {
    this._friendly = friendly;
    this.vertical = fields.first.col == fields.last.col;
    this.fields = fields;
    _sunk = false;
    if (fields.last != back()) {
      this.fields = fields.reversed.toList();
    }
  }

  /**
   * static factory method for the ship class. decides which type of ship to create,
   * based on its length
   * @param pf the playing field, which contains the ship
   * @param fields the fields which contain the ship
   * @param friendly describes who the ship belongs to
   * @returns a new instance of one of the ship classes, based on the length of the fields list
   */
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

  /**
   * places the ship on the playing field
   */
  void place() {
    for (int i = 0; i < fields.length; i++) {
      fields[i].entity = this;
    }
  }

  /**
   * checks if the ship is placed over the playing field borders and reenters on
   * the other side
   * @returns true if the ship reenters the playing field, false if not
   */
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

  /**
   * gets the back of the ship
   * @returns the back of the ship
   */
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

  /**
   * checks if the ship is damaged
   * @returns true if one of the ship's parts have been fired at, false if not
   */
  bool isDamaged() {
    for (int i = 0; i < fields.length; i++) {
      if (fields[i].hit) return true;
    }
    return false;
  }

  /**
   * fires at the ship, damaging the part which has been fired on
   * @param f the field, which is being attacked
   */
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

  /**
   * sinks the ship
   */
  void sinkShip() {
    _sunk = true;
  }

  /**
   * moves the ship according to it's alignment (to the west or the east for horizontal
   * ships, to the north or the south for vertical ships) by a given distanced
   * @param dir the direction and distance, if negative, the direction is north or left
   *            if positive thedirection ist south or east
   */
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

/**
 * A five part ship is a carrier.
 */
class Carrier extends Ship {

  /**
   * Creates a new Carrier instance.
   * @param pf the playing field containing the ship
   * @param fields the ship's fields
   * @param friendly describes who the ship belongs to
   */
  Carrier(PlayingField pf, List<Field> fields, bool friendly) : super(pf, fields, friendly);
}

/**
 * A four part ship is a battleship.
 */
class BattleShip extends Ship {

  /**
   * Creates a new BattleShip instance.
   * @param pf the playing field containing the ship
   * @param fields the ship's fields
   * @param friendly describes who the ship belongs to
   */
  BattleShip(PlayingField pf, List<Field> fields, bool friendly) : super(pf, fields, friendly);
}

/**
 * A three part ship is a submarine.
 */
class Submarine extends Ship {

  /**
   * Creates a new Submarine instance.
   * @param pf the playing field containing the ship
   * @param fields the ship's fields
   * @param friendly describes who the ship belongs to
   */
  Submarine(PlayingField pf, List<Field> fields, bool friendly) : super(pf, fields, friendly);
}

/**
 * A two part ship is a destroyer.
 */
class Destroyer extends Ship {

  /**
   * Creates a new Destroyer instance.
   * @param pf the playing field containing the ship
   * @param fields the ship's fields
   * @param friendly describes who the ship belongs to
   */
  Destroyer(PlayingField pf, List<Field> fields, bool friendly) : super(pf, fields, friendly);
}

/**
 * A rock is an obstacle on the playing field. Ships can't move over it.
 */
class Rock extends Entity {

  /**
   * the field containing the rock
   */
  Field _field;

  Field get field => _field;

  /**
   * creates a new Rock instance
   * @param field the playing field containing the rock
   * @param row the y position on the playing field
   * @param col the x position on the playing field
   */
  Rock(PlayingField field, int row, int col) : super(field) { // maybe construct via field and not via row/col
    _field = field[row][col];
  }

  /**
   * places the rock on the playing field
   */
  void place() {
    _field.entity = this;
  }
}

/**
 * A power up grants the player randomly one of two positive effects. The two effects are
 * - the player's shots affect an increased radius
 * - one of the enemy's ships is revealed
 */
class PowerUp extends Entity { // The type of powerup is determined randomly on activation

  /**
   * the field containing the power up
   */
  Field _field;

  Field get field => _field;

  /**
   * creates a new PowerUp instance
   * @param field the field containing the power up
   * @param row the power up's y position on the playing field
   * @param col the power up's x position on the playing field
   */
  PowerUp(PlayingField field, int row, int col) : super(field) {
    _field = field[row][col];
  }

  /**
   * places the power up on the playing field
   */
  void place() {
    _field.entity = this;
  }

  /**
   * Randomly chooses one of the power ups effects and activates it.
   * The possible effects are:
   * - the player's shots affect an increased radius
   * - one of the enemy's ships is revealed
   */
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

  /**
   * reveals one of the enemy's ships
   */
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

  /**
   * increases the player's shots radius
   */
  void radiusPu() {
    playingField.radiusPuRounds = 2;
  }

}

/**
 * A ShipBuilder constructs ships for either the enemy or the player. It consists of
 * one centerfield and four direction fields, one for each of the cardinal directions.
 */
class ShipBuilder extends Entity{
  /**
   * the lenght of the ship to be constructed
   */
  int shipLength;

  /**
   * the row of the center of the ship builder
   */
  int centerRow;

  /**
   * the column of the center of the ship builder
   */
  int centerCol;

  /**
   * the fields containing the ship builder
   */
  List<Field> _fields;

  /**
   * true if the ship to be constructed belongs to the player else false
   */
  bool _friendly;

  List<Field> get fields => _fields;
  set fields(List<Field> fields) => _fields = fields;

  /**
   * creates a new ShipBuilder instance
   * @param field the playing field containing the ship builder
   * @param row the row of the center of the ship builder
   * @param col the column of the center of the ship builder
   * @param friendly describes who the ship will belong to
   */
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

  /**
   * places the ship builder on the palying field
   */
  void place() {
    for (int i = 0; i < fields.length; i++) {
      if (fields[i] != null) {
        fields[i].entity = this;
      }
    }
  }

  /**
   * removes the ship builder from the playing field
   */
  void remove() {
    for (int i = 0; i < fields.length; i++) {
      if (fields[i] != null && fields[i].entity == this) {
        fields[i].entity = null;
      }
    }
  }

  /**
   * constructs a new ship on the playing field
   * @param f one of the ship builder's fields, indicating the direction, the ship should be built in
   */
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

  /**
   * gets a random direction field from the ship builder
   * @returns a random direction field from the ship builder
   */
  Field randomDirection() {
    var fieldsClean = fields;
    fieldsClean.removeWhere((f) => f == null);
    if (fieldsClean.length == null) return null;  // in case no direction is possible
    var rng = new Random();
    var index = rng.nextInt(fieldsClean.length);
    return fieldsClean[index];
  }

}

/**
 * Instances of this class assist the player in moving their ships.
 */
class ShipMover extends Entity {
  /**
   * the ship to be moved
   */
  Ship _ship;

  /**
   * the fields which contain this ship mover
   */
  List<Field> _fields;

  List<Field> get fields => _fields;
  Ship get ship => _ship;

  /**
   * creates a new ShipMover instance
   * @param pf the playingfield containing the ship builder
   * @param ship the ship to be moved
   */
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

  /**
   * move the ship builder's ship in a specific direction
   * @param direction if the direction is negative the ship is moved westwards if
   *                  it is aligned horizontally and northwards if it is aligned
   *                  vertically, if it is positive the ship is moved to the east
   *                  if it is aligned horizontally and to the south if it's aligned
   *                  vertically. This parameter also determines how far the ship
   *                  will move.
   */
  void moveShip(Field direction) {
    remove();
    if (_fields.indexOf(direction) == 0) {
      _ship.move(-1);
    } else {
      _ship.move(1);
    }
  }

  /**
   * removes the ship builder from the playing field
   */
  void remove() {
    for (int i = 0; i < _fields.length; i++) {
      if (_fields[i].entity == this) {
        _fields[i].entity = null;
      }
    }
  }
}