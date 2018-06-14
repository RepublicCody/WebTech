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
    levelList(); // TODO: try/catch
  }

  void generatePlayingField(int level) {
    playingField.newGame();
    playingField.generateField(levels[level - 1]["level_$level"]);
    enemy.strategy = levels[level - 1]["level_$level"]["enemyStrategy"];
    enemy.placeShips(playingField);
    enemy.resetAI();
  }

  int randomLevel() {
    int lvlCount = levels.length;
    Random rng = new Random();
    return 1 + rng.nextInt(lvlCount);
  }

  Future<List> levelList() async {
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

  bool hitMedicoreMove = false;
  List<int> firstHitMedicoreMove = [0, 0];
  List<int> lastHitMedicoreMove = [-1, 0];
  List<int> postionHitMedicoreMove = [0, 0];
  String lastDirectionMedicoreMove = "no direction";
  
  bool strategieHardcoreMove = false;
  bool hitHardcoreMove = false;
  List<int> firstHitHardcoreMove = [0, 0];
  List<int> lastHitHardcoreMove = [-1, 0];
  List<int> postionHitHardcoreMove = [0, 0];
  String lastDirectionHardcoreMove = "no direction";

  bool strategieRandomHardcoreMove = false;
  bool hitRandomHardcoreMove = false;
  List<int> firstHitRandomHardcoreMove = [0, 0];
  List<int> lastHitRandomHardcoreMove = [-1, 0];
  List<int> postionHitRandomHardcoreMove = [0, 0];
  List<int> allHitsColRandomHardcoreMove = [];
  List<int> allHitsRowRandomHardcoreMove = [];
  String lastDirectionRandomHardcoreMove = "no direction";

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
    //mediocreMove();
    //hardcoreMove();
    //randomHardcoreMove();

    switch (_strategy) {
      case 0:
        print("starte KI randomMove");
        randomMove();
        break;
      case 1:
        print("starte KI mediocreMove");
        mediocreMove();
        break;
      case 2:
        print("starte KI hardcoreMove");
        hardcoreMove();
        break;
      case 3:
        print("starte KI randomHardcoreMove");
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
    int sLength;
    int halfROWCOUNT;
    if(ROWCOUNT.isEven)halfROWCOUNT = (ROWCOUNT / 2).toInt();
    else{halfROWCOUNT = ((ROWCOUNT+1) / 2).toInt();}
    int row = postionHitMedicoreMove[0];
    int col = postionHitMedicoreMove[1];
    int x, y, top, right, down, left;
    bool shot = false;

    if(hitMedicoreMove == false){

      if(model.playingField[row + halfROWCOUNT][col]._hit == false) {
        sLength = model.playingField.ships.length;
        model.fireAt(row + halfROWCOUNT, col);

        if(model.playingField[row + halfROWCOUNT][col]._entity != null) {
          hitMedicoreMove = true;
          firstHitMedicoreMove[0] = (row+halfROWCOUNT);
          firstHitMedicoreMove[1] = col;
          if(sLength > model.playingField.ships.length)hitMedicoreMove = false;

        }


      }else{
          do {
            if (row + halfROWCOUNT == ROWCOUNT - 1 && col == COLCOUNT - 2) {
              row = 0;
              if(ROWCOUNT.isOdd) {
                col = COLCOUNT.isEven ? 1 : 0;
              }else{
                col = COLCOUNT.isEven ? 0 : 1;
              }
            } else
            if (row + halfROWCOUNT == ROWCOUNT - 1 && col == COLCOUNT - 1) {
              row = 0;
              if(ROWCOUNT.isOdd) {
                col = COLCOUNT.isEven ? 0 : 1;
              }else{
                col = COLCOUNT.isEven ? 1 : 0;
              }
            } else if (col == COLCOUNT - 1) {
              row++;
              col = COLCOUNT.isEven ? 0 : 1;
            } else if (col == COLCOUNT - 2) {
              row++;
              col = COLCOUNT.isEven ? 1 : 0;
            } else {
              col += 2;
            }
            print("row: $row und col $col");
          } while (model.playingField[row + halfROWCOUNT][col]._hit == true);

        sLength = model.playingField.ships.length;
        model.fireAt(row + halfROWCOUNT, col);

        if(model.playingField[row + halfROWCOUNT][col]._entity != null) {
          hitMedicoreMove = true;
          firstHitMedicoreMove[0] = (row+halfROWCOUNT);
          firstHitMedicoreMove[1] = col;
          if(sLength > model.playingField.ships.length)hitMedicoreMove = false;

        }
      }


    } else {

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
            if (model.playingField[top][y]._hit == false &&
                model.playingField[top][y]._foggy == false) {
              sLength = model.playingField.ships.length;
              model.fireAt(top, y);

              if(sLength > model.playingField.ships.length) {
                hitMedicoreMove = false;
                lastHitMedicoreMove[0] = -1;
                lastDirectionMedicoreMove = "no direction";
              }
              if(model.playingField[top][y]._entity != null) {
                lastHitMedicoreMove[0] = top;
                lastHitMedicoreMove[1] = y;
              }
              shot = true;
            } else {
              lastDirectionMedicoreMove = "down";
              lastHitMedicoreMove[0] = -1;
            }
            break;
          case "right":
            if (model.playingField[x][right]._hit == false) {
              sLength = model.playingField.ships.length;
              model.fireAt(x, right);

              if(sLength > model.playingField.ships.length) {
                hitMedicoreMove = false;
                lastHitMedicoreMove[0] = -1;
                lastDirectionMedicoreMove = "no direction";
              }
              if(model.playingField[x][right]._entity != null) {
                lastHitMedicoreMove[0] = x;
                lastHitMedicoreMove[1] = right;
              }
              shot = true;
            } else {
              lastDirectionMedicoreMove = "left";
              lastHitMedicoreMove[0] = -1;
            }
            break;
          case "down":
            if (model.playingField[down][y]._hit == false &&
                model.playingField[down][y]._foggy == false) {
              sLength = model.playingField.ships.length;
              model.fireAt(down, y);

              if(sLength > model.playingField.ships.length) {
                hitMedicoreMove = false;
                lastHitMedicoreMove[0] = -1;
                lastDirectionMedicoreMove = "no direction";
              }
              if(model.playingField[down][y]._entity != null) {
                lastHitMedicoreMove[0] = down;
                lastHitMedicoreMove[1] = y;
              }
              shot = true;
            } else {
              lastDirectionMedicoreMove = "right";
              lastHitMedicoreMove[0] = -1;
            }
            break;
          case "left":
            if (model.playingField[x][left]._hit == false) {
              sLength = model.playingField.ships.length;
              model.fireAt(x, left);

              if(sLength > model.playingField.ships.length) {
                hitMedicoreMove = false;
                lastHitMedicoreMove[0] = -1;
                lastDirectionMedicoreMove = "no direction";
              }
              if(model.playingField[x][left]._entity != null) {
                lastHitMedicoreMove[0] = x;
                lastHitMedicoreMove[1] = left;
              }
              shot = true;
            } else {
              hitMedicoreMove = false;
              lastHitMedicoreMove[0] = -1;
              lastDirectionMedicoreMove = "no direction";
              shot = true;
              print("muss wohl ein Felsen sein");
              mediocreMove();
            }
            break;
          case "no direction":

            lastDirectionMedicoreMove = "top";
            break;
          default:
            lastHitMedicoreMove[0] = -1;
            print("Hier passiert nichts");
            break;
        }
      }

    }
    postionHitMedicoreMove[0] = row;
    postionHitMedicoreMove[1] = col;
  }

  void hardcoreMove() {
    int sLength;
    int halfROWCOUNT;
    if(ROWCOUNT.isEven)halfROWCOUNT = (ROWCOUNT / 2).toInt();
    else{halfROWCOUNT = ((ROWCOUNT+1) / 2).toInt();}
    int row = postionHitHardcoreMove[0];
    int col = postionHitHardcoreMove[1];

    if(strategieHardcoreMove == false){
      col = _rng.nextInt(2);
      strategieHardcoreMove = true;
    }

    int x, y, top, right, down, left;
    bool shot = false;

    if(hitHardcoreMove == false){

      if(model.playingField[row + halfROWCOUNT][col]._hit == false) {
        sLength = model.playingField.ships.length;
        model.fireAt(row + halfROWCOUNT, col);

        if(model.playingField[row + halfROWCOUNT][col]._entity != null) {
          hitHardcoreMove = true;
          firstHitHardcoreMove[0] = (row+halfROWCOUNT);
          firstHitHardcoreMove[1] = col;
          if(sLength > model.playingField.ships.length)hitHardcoreMove = false;

        }


      }else{
        do {
          if (row + halfROWCOUNT == ROWCOUNT - 1 && col == COLCOUNT - 2) {
            row = 0;
            if(ROWCOUNT.isOdd) {
              col = COLCOUNT.isEven ? 1 : 0;
            }else{
              col = COLCOUNT.isEven ? 0 : 1;
            }
          } else
          if (row + halfROWCOUNT == ROWCOUNT - 1 && col == COLCOUNT - 1) {
            row = 0;
            if(ROWCOUNT.isOdd) {
              col = COLCOUNT.isEven ? 0 : 1;
            }else{
              col = COLCOUNT.isEven ? 1 : 0;
            }
          } else if (col == COLCOUNT - 1) {
            row++;
            col = COLCOUNT.isEven ? 0 : 1;
          } else if (col == COLCOUNT - 2) {
            row++;
            col = COLCOUNT.isEven ? 1 : 0;
          } else {
            col += 2;
          }
          print("row: $row und col $col");
        } while (model.playingField[row + halfROWCOUNT][col]._hit == true);

        sLength = model.playingField.ships.length;
        model.fireAt(row + halfROWCOUNT, col);

        if(model.playingField[row + halfROWCOUNT][col]._entity != null) {
          hitHardcoreMove = true;
          firstHitHardcoreMove[0] = (row+halfROWCOUNT);
          firstHitHardcoreMove[1] = col;
          if(sLength > model.playingField.ships.length)hitHardcoreMove = false;

        }
      }


    }else{

      while(shot == false) {

        if(lastHitHardcoreMove[0] == -1){
          x = firstHitHardcoreMove[0];
          y = firstHitHardcoreMove[1];

        }else{
          x = lastHitHardcoreMove[0];
          y = lastHitHardcoreMove[1];
        }

        top = x - 1;
        if(top <= halfROWCOUNT){}
        right = y + 1;
        if(right >= COLCOUNT)right -= COLCOUNT;
        down = x + 1;
        if(down >= ROWCOUNT)down -= ROWCOUNT;
        left = y - 1;
        if(left < 0)left += COLCOUNT;

        switch (lastDirectionHardcoreMove) {
          case "top":
            if (model.playingField[top][y]._hit == false &&
                model.playingField[top][y]._foggy == false) {
              sLength = model.playingField.ships.length;
              model.fireAt(top, y);

              if(sLength > model.playingField.ships.length) {
                hitHardcoreMove = false;
                lastHitHardcoreMove[0] = -1;
                lastDirectionHardcoreMove = "no direction";
              }
              if(model.playingField[top][y]._entity != null) {
                lastHitHardcoreMove[0] = top;
                lastHitHardcoreMove[1] = y;
              }
              shot = true;
            } else {
              lastDirectionHardcoreMove = "down";
              lastHitHardcoreMove[0] = -1;
            }
            break;
          case "right":
            if (model.playingField[x][right]._hit == false) {
              sLength = model.playingField.ships.length;
              model.fireAt(x, right);

              if(sLength > model.playingField.ships.length) {
                hitHardcoreMove = false;
                lastHitHardcoreMove[0] = -1;
                lastDirectionHardcoreMove = "no direction";
              }
              if(model.playingField[x][right]._entity != null) {
                lastHitHardcoreMove[0] = x;
                lastHitHardcoreMove[1] = right;
              }
              shot = true;
            } else {
              lastDirectionHardcoreMove = "left";
              lastHitHardcoreMove[0] = -1;
            }
            break;
          case "down":
            if (model.playingField[down][y]._hit == false &&
                model.playingField[down][y]._foggy == false) {
              sLength = model.playingField.ships.length;
              model.fireAt(down, y);

              if(sLength > model.playingField.ships.length) {
                hitHardcoreMove = false;
                lastHitHardcoreMove[0] = -1;
                lastDirectionHardcoreMove = "no direction";
              }
              if(model.playingField[down][y]._entity != null) {
                lastHitHardcoreMove[0] = down;
                lastHitHardcoreMove[1] = y;
              }
              shot = true;
            } else {
              lastDirectionHardcoreMove = "right";
              lastHitHardcoreMove[0] = -1;
            }
            break;
          case "left":
            if (model.playingField[x][left]._hit == false) {
              sLength = model.playingField.ships.length;
              model.fireAt(x, left);

              if(sLength > model.playingField.ships.length) {
                hitHardcoreMove = false;
                lastHitHardcoreMove[0] = -1;
                lastDirectionHardcoreMove = "no direction";
              }
              if(model.playingField[x][left]._entity != null) {
                lastHitHardcoreMove[0] = x;
                lastHitHardcoreMove[1] = left;
              }
              shot = true;
            } else {
              hitHardcoreMove = false;
              lastHitHardcoreMove[0] = -1;
              lastDirectionHardcoreMove = "no direction";
              shot = true;
              print("muss wohl ein Felsen sein");
              hardcoreMove();
            }
            break;
          case "no direction":

            lastDirectionHardcoreMove = "top";
            break;
          default:
            lastHitHardcoreMove[0] = -1;
            print("Hier passiert nichts");
            break;
        }
      }

    }
    postionHitHardcoreMove[0] = row;
    postionHitHardcoreMove[1] = col;
  }

  void randomHardcoreMove() {
    int sLength;
    int halfROWCOUNT;
    if(ROWCOUNT.isEven)halfROWCOUNT = (ROWCOUNT / 2).toInt();
    else{halfROWCOUNT = ((ROWCOUNT+1) / 2).toInt();}
    int row = postionHitRandomHardcoreMove[0];
    int col = postionHitRandomHardcoreMove[1];

    if(strategieRandomHardcoreMove == false){
      col = _rng.nextInt(COLCOUNT);
      row = _rng.nextInt(ROWCOUNT - halfROWCOUNT);
      print("randRow: $row randCol: $col");
      strategieRandomHardcoreMove = true;
    }

    int x, y, top, right, down, left;
    bool shot = false;

    if(hitRandomHardcoreMove == false){

      if(model.playingField[row + halfROWCOUNT][col]._hit == false) {
        sLength = model.playingField.ships.length;
        model.fireAt(row + halfROWCOUNT, col);

        if(model.playingField[row + halfROWCOUNT][col]._entity != null) {
          hitRandomHardcoreMove = true;
          firstHitRandomHardcoreMove[0] = (row+halfROWCOUNT);
          firstHitRandomHardcoreMove[1] = col;
          allHitsRowRandomHardcoreMove.add(row+halfROWCOUNT);
          allHitsColRandomHardcoreMove.add(col);
          if(sLength > model.playingField.ships.length)hitRandomHardcoreMove = false;

        }


      }else{
        do {
          if (row + halfROWCOUNT == ROWCOUNT - 1 && col == COLCOUNT - 2) {
            row = 0;
            if(ROWCOUNT.isOdd) {
              col = COLCOUNT.isEven ? 1 : 0;
            }else{
              col = COLCOUNT.isEven ? 0 : 1;
            }
          } else
          if (row + halfROWCOUNT == ROWCOUNT - 1 && col == COLCOUNT - 1) {
            row = 0;
            if(ROWCOUNT.isOdd) {
              col = COLCOUNT.isEven ? 0 : 1;
            }else{
              col = COLCOUNT.isEven ? 1 : 0;
            }
          } else if (col == COLCOUNT - 1) {
            row++;
            col = COLCOUNT.isEven ? 0 : 1;
          } else if (col == COLCOUNT - 2) {
            row++;
            col = COLCOUNT.isEven ? 1 : 0;
          } else {
            col += 2;
          }
          print("row: $row und col $col");
        } while (model.playingField[row + halfROWCOUNT][col]._hit == true);

        sLength = model.playingField.ships.length;
        model.fireAt(row + halfROWCOUNT, col);

        if(model.playingField[row + halfROWCOUNT][col]._entity != null) {
          hitRandomHardcoreMove = true;
          firstHitRandomHardcoreMove[0] = (row+halfROWCOUNT);
          firstHitRandomHardcoreMove[1] = col;
          allHitsRowRandomHardcoreMove.add(row+halfROWCOUNT);
          allHitsColRandomHardcoreMove.add(col);
          if(sLength > model.playingField.ships.length)hitRandomHardcoreMove = false;

        }
      }


    }else{

      while(shot == false) {

        if(lastHitRandomHardcoreMove[0] == -1){
          x = firstHitRandomHardcoreMove[0];
          y = firstHitRandomHardcoreMove[1];
        }else{
          x = lastHitRandomHardcoreMove[0];
          y = lastHitRandomHardcoreMove[1];
        }

        top = x - 1;
        if(top <= halfROWCOUNT){}
        right = y + 1;
        if(right >= COLCOUNT)right -= COLCOUNT;
        down = x + 1;
        if(down >= ROWCOUNT)down -= ROWCOUNT;
        left = y - 1;
        if(left < 0)left += COLCOUNT;

        switch (lastDirectionRandomHardcoreMove) {
          case "top":
            if (model.playingField[top][y]._hit == false &&
                model.playingField[top][y]._foggy == false) {
              sLength = model.playingField.ships.length;
              model.fireAt(top, y);

              if(model.playingField[top][y]._entity != null) {
                lastHitRandomHardcoreMove[0] = top;
                lastHitRandomHardcoreMove[1] = y;
                allHitsRowRandomHardcoreMove.add(top);
                allHitsColRandomHardcoreMove.add(y);
              }

              if(sLength > model.playingField.ships.length) {
                hitRandomHardcoreMove = false;
                lastHitRandomHardcoreMove[0] = -1;
                lastDirectionRandomHardcoreMove = "no direction";
                int l = allHitsRowRandomHardcoreMove.length;
                for(int p = 0; p < l; p++) {
                  for (int z = 0; z <= 5; z++) {
                    if(allHitsRowRandomHardcoreMove.length > p) {
                      if (allHitsRowRandomHardcoreMove[p] == (top + z) && allHitsColRandomHardcoreMove[p] == y) {
                        allHitsRowRandomHardcoreMove.removeAt(p);
                        allHitsColRandomHardcoreMove.removeAt(p);
                        z = 0;
                        l--;
                      }
                    }
                  }
                }
                if(allHitsRowRandomHardcoreMove.length != 0){
                  firstHitRandomHardcoreMove[0] = allHitsRowRandomHardcoreMove[0];
                  firstHitRandomHardcoreMove[1] = allHitsColRandomHardcoreMove[0];
                  hitRandomHardcoreMove = true;
                  lastHitRandomHardcoreMove[0] = -1;
                }
              }

              shot = true;
            } else {
              lastDirectionRandomHardcoreMove = "down";
              lastHitRandomHardcoreMove[0] = -1;
            }
            break;
          case "right":
            if (model.playingField[x][right]._hit == false) {
              sLength = model.playingField.ships.length;
              model.fireAt(x, right);

              if(sLength > model.playingField.ships.length) {
                hitRandomHardcoreMove = false;
                lastHitRandomHardcoreMove[0] = -1;
                lastDirectionRandomHardcoreMove = "no direction";
                int l = allHitsRowRandomHardcoreMove.length;
                for(int p = 0; p < l; p++) {
                  for (int z = 0; z <= 5; z++) {
                    if(allHitsRowRandomHardcoreMove.length > p) {
                      if(allHitsColRandomHardcoreMove[p] == right-z && allHitsRowRandomHardcoreMove[p] == x){
                        allHitsRowRandomHardcoreMove.removeAt(p);
                        allHitsColRandomHardcoreMove.removeAt(p);
                        z = 0;
                        l--;
                      }
                    }
                  }
                }
                if(allHitsRowRandomHardcoreMove.length != 0){
                  firstHitRandomHardcoreMove[0] = allHitsRowRandomHardcoreMove[0];
                  firstHitRandomHardcoreMove[1] = allHitsColRandomHardcoreMove[0];
                  hitRandomHardcoreMove = true;
                  lastHitRandomHardcoreMove[0] = -1;
                }
              }
              if(model.playingField[x][right]._entity != null) {
                lastHitRandomHardcoreMove[0] = x;
                lastHitRandomHardcoreMove[1] = right;
                allHitsRowRandomHardcoreMove.add(x);
                allHitsColRandomHardcoreMove.add(right);
              }
              shot = true;
            } else {
              lastDirectionRandomHardcoreMove = "left";
              lastHitRandomHardcoreMove[0] = -1;
            }
            break;
          case "down":
            if (model.playingField[down][y]._hit == false &&
                model.playingField[down][y]._foggy == false) {
              sLength = model.playingField.ships.length;
              model.fireAt(down, y);

              if(model.playingField[down][y]._entity != null) {
                lastHitRandomHardcoreMove[0] = down;
                lastHitRandomHardcoreMove[1] = y;
                allHitsRowRandomHardcoreMove.add(down);
                allHitsColRandomHardcoreMove.add(y);
              }

              if(sLength > model.playingField.ships.length) {
                hitRandomHardcoreMove = false;
                lastHitRandomHardcoreMove[0] = -1;
                lastDirectionRandomHardcoreMove = "no direction";
                int l = allHitsRowRandomHardcoreMove.length;
                for(int p = 0; p < l; p++) {
                  for (int z = 0; z <= 5; z++) {
                    if(allHitsRowRandomHardcoreMove.length > p) {
                      if (allHitsRowRandomHardcoreMove[p] == (down - z) && allHitsColRandomHardcoreMove[p] == y) {
                        allHitsRowRandomHardcoreMove.removeAt(p);
                        allHitsColRandomHardcoreMove.removeAt(p);
                        z = 0;
                        l--;
                      }
                    }
                  }
                }
                if(allHitsRowRandomHardcoreMove.length != 0){
                  firstHitRandomHardcoreMove[0] = allHitsRowRandomHardcoreMove[0];
                  firstHitRandomHardcoreMove[1] = allHitsColRandomHardcoreMove[0];
                  hitRandomHardcoreMove = true;
                  lastHitRandomHardcoreMove[0] = -1;
                }
              }

              shot = true;
            } else {
              lastDirectionRandomHardcoreMove = "right";
              lastHitRandomHardcoreMove[0] = -1;
            }
            break;
          case "left":
            if (model.playingField[x][left]._hit == false) {
              sLength = model.playingField.ships.length;
              model.fireAt(x, left);

              if(sLength > model.playingField.ships.length) {
                hitRandomHardcoreMove = false;
                lastHitRandomHardcoreMove[0] = -1;
                lastDirectionRandomHardcoreMove = "no direction";
                int l = allHitsRowRandomHardcoreMove.length;
                for(int p = 0; p < l; p++) {
                  for (int z = 0; z <= 5; z++) {
                    if(allHitsRowRandomHardcoreMove.length > p) {
                      if(allHitsColRandomHardcoreMove[p] == left+z && allHitsRowRandomHardcoreMove[p] == x){
                        allHitsRowRandomHardcoreMove.removeAt(p);
                        allHitsColRandomHardcoreMove.removeAt(p);
                        z = 0;
                        l--;
                      }
                    }
                  }
                }
                if(allHitsRowRandomHardcoreMove.length != 0){
                  firstHitRandomHardcoreMove[0] = allHitsRowRandomHardcoreMove[0];
                  firstHitRandomHardcoreMove[1] = allHitsColRandomHardcoreMove[0];
                  hitRandomHardcoreMove = true;
                  lastHitRandomHardcoreMove[0] = -1;
                }
              }
              if(model.playingField[x][left]._entity != null) {
                lastHitRandomHardcoreMove[0] = x;
                lastHitRandomHardcoreMove[1] = left;
                allHitsRowRandomHardcoreMove.add(x);
                allHitsColRandomHardcoreMove.add(left);
              }
              shot = true;
            } else {
              hitRandomHardcoreMove = false;
              lastHitRandomHardcoreMove[0] = -1;
              lastDirectionRandomHardcoreMove = "no direction";
              shot = true;
              print("muss wohl ein Felsen sein");
              randomHardcoreMove();
            }
            break;
          case "no direction":

            lastDirectionRandomHardcoreMove = "top";
            break;
          default:
            lastHitRandomHardcoreMove[0] = -1;
            print("Hier passiert nichts");
            break;
        }
      }

    }
    postionHitRandomHardcoreMove[0] = row;
    postionHitRandomHardcoreMove[1] = col;
  }

  void resetAI(){
    hitMedicoreMove = false;
    firstHitMedicoreMove = [0, 0];
    lastHitMedicoreMove = [-1, 0];
    postionHitMedicoreMove = [0, 0];
    lastDirectionMedicoreMove = "no direction";

    strategieHardcoreMove = false;
    hitHardcoreMove = false;
    firstHitHardcoreMove = [0, 0];
    lastHitHardcoreMove = [-1, 0];
    postionHitHardcoreMove = [0, 0];
    lastDirectionHardcoreMove = "no direction";

    strategieRandomHardcoreMove = false;
    hitRandomHardcoreMove = false;
    firstHitRandomHardcoreMove = [0, 0];
    lastHitRandomHardcoreMove = [-1, 0];
    postionHitRandomHardcoreMove = [0, 0];
    allHitsColRandomHardcoreMove = [];
    allHitsRowRandomHardcoreMove = [];
    lastDirectionRandomHardcoreMove = "no direction";
  }
}

class PlayingField {
  List<List<Field>> _fields;
  List<Ship> _ships;
  List<int> _playerShipLengths;
  List<int> _enemyShipLengths;
  ShipBuilder _playerBuilder;
  ShipBuilder _enemyBuilder;
  ShipMover _mover;
  int _rowCount;
  int _colCount;
  int _enemyRows;
  bool moveShips;

  int _radiusPuRounds;
  //int _visionPuRounds;

  operator [](int index) => _fields[index];

  List<Ship> get ships => _ships;
  List<int> get playerShipLengths => _playerShipLengths;
  List<int> get enemyShipLengths => _enemyShipLengths;
  int get rowCount => _rowCount;
  int get colCount => _colCount;
  int get enemyRows => _enemyRows;

  set radiusPuRounds(int rounds) => _radiusPuRounds = rounds;
  //set visionPuRounds(int rounds) => _radiusPuRounds = rounds;

  PlayingField(int rows, int cols) {
    this._rowCount = rows;
    this._colCount = cols;
    _enemyRows = rowCount ~/ 2;
    _fields = initializeFields(rows, cols);
    _ships = new List<Ship>();
    _radiusPuRounds = 0;
    moveShips = false;
  }

  void newGame() {
    _fields = initializeFields(rowCount, colCount);
    _ships = new List<Ship>();
  }

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
    print("fire at $row, $col");
  }

  void generateField(Map level) {// TODO: complete
    _playerShipLengths = level["playerShips"];
    _enemyShipLengths = level["enemyShips"];
    moveShips = level["moveShips"];
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
        print(f.row);
        print(f.col);
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
    return _fields[row][col];
  }

  bool shipBuildingComplete() {
    return playerShipCount() >= playerShipLengths.length;
  }

  void addShip(Ship ship) {
    ships.add(ship);
    ship.place();
  }

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

  // just for testing purposes
  String toString() {
    var fieldString = "";
    for (int i = 0; i < rowCount; i++) {
      fieldString += "\n";
      for (int j = 0; j < colCount; j++) {
        fieldString += _fields[i][j].toString();
        fieldString += " ";
      }
    }
    return fieldString;
  }

  bool gameOver() {
    return enemyShipCount() <= 0 || playerShipCount() <= 0;
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

  Field north(Field f) {
    if (_fields[f.row][f.col] != null) {
      if (f.row - 1 < 0) return null;
      else return _fields[f.row - 1][f.col];
    }
    return null;
  }
  Field east(Field f) {
    if (_fields[f.row][f.col] != null) {
      if (f.col + 1 >= colCount) return _fields[f.row][0];
      else return _fields[f.row][f.col + 1];
    }
    return null;
  }
  Field south(Field f) {
    if (_fields[f.row][f.col] != null) {
      if (f.row + 1 >= rowCount) return null;
      else return _fields[f.row + 1][f.col];
    }
    return null;
  }
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
      print("Schiff versenkt");
    }
  }

  void sinkShip() {
    for (int i = 0; i < fields.length; i++) {
      if (fields[i].entity == this) fields[i].entity = null;
    }
    playingField.ships.remove(this);
  }

  //TODO: not tested
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
    sinkShip();
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
        print("enemy ship found");
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
      //playingField.addShip(new Ship(playingField, shipFields, _friendly));
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