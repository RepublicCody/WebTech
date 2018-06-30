part of warships;
/**
 * The GameController class is the application's controller. It insteracts with
 * the game's model and view to make it playable
 */
class GameController{

  /**
   * the games model contains contains the logic for the game
   */
  GameModel _model = new GameModel();

  /**
   * the game's view manipulates the html dom tree and is instructed by the controller
   */
  GameView _view = new GameView();

  /**
   * the listener for level selection buttons
   */
  var _menuListener;

  /**
   * the listener for the actual game
   */
  var _tableListener;

  /**
   * the listener for the game over screen
   */
  var _gameoverlistener;

  /**
   * the listener for the message
   */
  var _messageListener;

  /**
   * TODO
   */
  var _deviceListener;

  /**
   * the listener for entering full screen mode
   */
  var _fullscreenListener;

  /**
   * the listener for exiting full screen mode
   */
  var _exitFullscreenListener;

  /**
   * the listener for the instructions
   */
  var _instructionListener;

  /**
   * The levels
   */
  var _levels;

  /**
   * The last level played
   */
  int _lastPlayed = 0;

  /**
   * Creates a new GameController instance
   */
  GameController() {
    loadlevels();
    JsObject jsObject = new JsObject.fromBrowserObject(querySelector("#menu"));
    int scrollHeight = jsObject['scrollHeight'];
    jsObject['scrollTop'] = '${scrollHeight}';
    _view.generateField(_model.playingField);
    _view.generateMenu();
    _view.generateGameoverscreen();
    _view.generateMessage();
    _view.generateDevice();
    _view.generateAnimatedMessage();
    _view.generateInstruction();
    _view.showMenu();
    window.onResize.listen((e) => _view.fieldSize());
    _instructionListener = querySelector("#instructionButton").onClick.listen((MouseEvent e) {changeInstruction(1);});
    _instructionListener = querySelector("#nextInstruction1").onClick.listen((MouseEvent e) {changeInstruction(2);});
    _instructionListener = querySelector("#nextInstruction2").onClick.listen((MouseEvent e) {changeInstruction(3);});
    _instructionListener = querySelector("#nextInstruction3").onClick.listen((MouseEvent e) {changeInstruction(4);});
    _instructionListener = querySelector("#backInstruction").onClick.listen((MouseEvent e) {_view.showMenu();});
    _messageListener = querySelector('#messageNext').onClick.listen((MouseEvent e) {_view.showGame();});
    _deviceListener = querySelector('#deviceButton').onClick.listen((MouseEvent e) {_view.hideDevice();});
    _menuListener = querySelectorAll('#menu .button').onClick.listen(selectLevel);
    _tableListener = querySelectorAll('td').onClick.listen(buildShip);
    _gameoverlistener = querySelectorAll('#gameover .button').onClick.listen(gameOver);
    _fullscreenListener = querySelector('#fullscreenbutton').onClick.listen((MouseEvent e) {fullscreenMode(querySelector("body"));});
    addListeners();
  }

  /**
   * loads the game's levels
   */
  void loadlevels() {
    HttpRequest.getString("levels.json").then((resp) => _levels = JSON.decode(resp));
  }

  /**
   * parses the row and the col of an html table element from it's id
   * @param the element's id
   * @returns a List containing the row and the col of the element
   */
  List<int> rowCol(String cssId) {
    RegExp re = new RegExp("[a-z]+_([0-9]+)_([0-9]+)");
    Match m = re.firstMatch(cssId);
    print(m.group(1));
    print(int.parse(m.group(2)));
    return [int.parse(m.group(1)), int.parse(m.group(2))];
  }

  /**
   * manages the player's actions on the playing field
   * 
   */
  void fireAt(MouseEvent e) {
    if (e.target is Element) {
      HtmlElement element = e.target;
      print(element.id);
      var rc = rowCol(element.id);
      if (rc[0] < _model.playingField.enemyRows &&
          !_model.playingField[rc[0]][rc[1]].hit) {
        _model.playingField.removeMovers();
        int i = _model.playingField.enemyShipCount();
        _model.fireAt(rc[0], rc[1]);
        if(i > _model.playingField.enemyShipCount()){
          sunkShipAnimation();
        }
        shipsleftMessage();
        if (_model.playingField.gameOver()) {
          _view.update(_model.playingField);
          gameoverScreen();
          this._tableListener.cancel();
          this._tableListener = querySelectorAll('td').onClick.listen(
              buildShip); //change to fireat on click on table
        } else {
          enemyMove();
        }
      } else if (_model.playingField[rc[0]][rc[1]].entity != null) {
        if (_model.playingField[rc[0]][rc[1]].entity is Ship) {
          Ship s = _model.playingField[rc[0]][rc[1]].entity;
          if (s.friendly) {
            _model.playingField.moveShip(rc[0], rc[1]);
            _view.update(_model.playingField);
          }
        } else if (_model.playingField[rc[0]][rc[1]].entity is ShipMover) {
          _model.playingField.moveShip(rc[0], rc[1]);
          enemyMove();
          _view.update(_model.playingField);
        }
      }
    }
  }

  /**
   * initializes th enemy making a move
   */
  void enemyMove() {
    _model.enemy.makeMove();
    shipsleftMessage();
    _view.update(_model.playingField);
  }

  /**
   * instructs the view to show the game over screen after the game is finished
   */
  void gameoverScreen(){
    String text = _model.playingField.enemyShipCount() == 0 ? "YOU WIN!" : "YOU LOST!";
    querySelector('#gameoverText').attributes["class"] = _model.playingField.enemyShipCount() == 0 ? "win" : "loose";
    querySelector('#nextGameover').style.display = _model.playingField.enemyShipCount() == 0 ? "block" : "none";
    querySelector('#restartGameover').style.display = _model.playingField.enemyShipCount() == 0 ? "none" : "block";
    _view.setGameoverText(text);
    _view.showGameover();
  }

  /**
   * manages the users actions on the level selection buttons
   * @param e the event
   */
  void selectLevel(MouseEvent e) {
    if (e.target is Element){
      HtmlElement element = e.target;
      RegExp re = new RegExp("level_([0-9]+)");
      if (re.hasMatch(element.id)) {
        Match m = re.firstMatch(element.id);
        _model.generatePlayingField(_levels[int.parse(m.group(1)) - 1]);//int.parse(m.group(1)));
        _lastPlayed = int.parse(m.group(1));
      } else {
        Random r = new Random();
        int lvl = r.nextInt(_levels.length);
        _model.generatePlayingField(_levels[lvl - 1]);
        _lastPlayed = lvl;
      }
      _view.setInGameText("Place a ${_model.playingField.playerShipLengths[0]}-part ship");
      _view.setInGameLevel("Level $_lastPlayed");
      _view.update(_model.playingField);
      setMessage();
      _view.showMessage();
    }
  }

  /**
   * manages the users actions on the game over screen
   * @param e the event
   */
  void gameOver(Event e) {
    if (e.target is Element) {
      HtmlElement element = e.target;
      if (element.id == "menuGameover") {
        _view.showMenu();
      } else if (element.id == "nextGameover") {
        _model.generatePlayingField(_levels[_lastPlayed + 1]);
        _view.setInGameText(
            "Place a ${_model.playingField.playerShipLengths[0]}-part ship");
        _view.setInGameLevel("Level " + (_lastPlayed+1).toString());
        _lastPlayed++;
        _view.update(_model.playingField);
        setMessage();
        _view.showMessage();
      } else if (element.id == "restartGameover") {
        _model.generatePlayingField(_levels[_lastPlayed]);
        _view.setInGameText(
            "Place a ${_model.playingField.playerShipLengths[0]}-part ship");
        _view.setInGameLevel("Level $_lastPlayed");
        _view.update(_model.playingField);
        setMessage();
        _view.showMessage();
      }
    }
  }

  /**
   * resets the listeners on the table
   */
  void goBack() {
    this._tableListener.cancel();
    this._tableListener = querySelectorAll('td').onClick.listen(buildShip);
    _view.showMenu();
  }

  /**
   * adds listeners to the random level button and the home button
   */
  void addListeners() {
    querySelector("#zufall").onClick.listen((Event e) {
      setMessage();
      _view.showMessage();
    });

    querySelector("#back").onClick.listen((Event e) {
      goBack();
    });
  }

  /**
   * manages the player's ship building
   */
  void buildShip(MouseEvent e) {
    if (e.target is Element) {
      HtmlElement element = e.target;
      var rc = rowCol(element.id);
      bool completed = _model.playingField.buildShip(rc[0], rc[1], true);
      if (completed && _model.playingField.playerShipCount() < _model.playingField.playerShipLengths.length) {
        _view.setInGameText(
            "Place a ${_model.playingField.playerShipLengths[_model.playingField.playerShipCount()]}-part ship");
      }
      _view.update(_model.playingField);
      if (_model.playingField.shipBuildingComplete()) {
        this._tableListener.cancel();
        this._tableListener = querySelectorAll('tr').onClick.listen(fireAt);  //change to fireat on click on table
        shipsleftMessage();
      }
    }
  }

  /**
   * Count and set amount of ships for the message screen
   */
  void setMessage(){
    List<String> s = ["0", "0", "0", "0", "0", "0", "0", "0"];
    List<int> c = [0,0,0,0,0,0,0,0];

    for(int i = 0; i < _model.playingField.ships.length; i++){
      if(_model.playingField.ships[i] is Destroyer){
        if(_model.playingField.ships[i]._friendly == true){
          c[0]++;
        }else{c[4]++;}
      }else if(_model.playingField.ships[i] is Submarine){
        if(_model.playingField.ships[i]._friendly == true){
          c[1]++;
        }else{c[5]++;}
      }else if(_model.playingField.ships[i] is BattleShip){
        if(_model.playingField.ships[i]._friendly == true){
          c[2]++;
        }else{c[6]++;}
      }else if(_model.playingField.ships[i] is Carrier){
        if(_model.playingField.ships[i]._friendly == true){
          c[3]++;
        }else{c[7]++;}
      }
    }

    for(int i = 0; i < _model.playingField.playerShipLengths.length; i++){
      if(_model.playingField.playerShipLengths[i] == 2){
          c[0]++;
      }else if(_model.playingField.playerShipLengths[i] == 3){
          c[1]++;
      }else if(_model.playingField.playerShipLengths[i] == 4){
          c[2]++;
      }else if(_model.playingField.playerShipLengths[i] == 5){
          c[3]++;
      }
    }

    for(int x = 0; x < c.length; x++){
      s[x] = "x " + c[x].toString();
    }
    String t = "";

    switch(_model.enemy.strategy){
      case 0:
        t = "Easy Bot";
        break;
      case 1:
        t = "Medium Bot";
        break;
      case 2:
        t = "Hard Bot";
        break;
      case 3:
        t = "Very Hard Bot";
        break;
    }

    _view.setMessageEnemy(t);
    _view.setShipCount(s);

  }

  /**
   * instructs the view to display how many ships the enemy has left
   */
  void shipsleftMessage(){
    if(_model.playingField.enemyShipCount() == 1){
      _view.setInGameText("${_model.playingField.enemyShipCount()} Ship left");
    }else {
      _view.setInGameText(
          "${_model.playingField.enemyShipCount()} Ships left");
    }
  }

  /**
   * Request for FullscreenMode
   */
  void fullscreenMode(Element element){
    _view.fullscreenWorkaround(element);
  }

  /**
   * requests the view to display the animation for sinking a ship
   */
  void sunkShipAnimation(){
    _view.showAnimatedMessage();
    new Timer(new Duration(milliseconds: 500), () => _view.hideAnimatedMessage());
  }

  /**
   * requests the view to display the tutorial for the game
   * @param i TODO
   */
  void changeInstruction(int i){
    String object = "";
    String picture = "";
    String text = "";
    if(i == 1){
      _view.showInstruction();
      object = "Placing a Ship";
      picture = "shipbuilder_center";
      text = "Place your ships in the lower field. "
          "You and the enemy can place them beyond the left and the right border.";
      _view.changeInstructionButton(i);
      _view.setInstruction(object, picture, text);
    }else if(i == 2){
      object = "Island";
      picture = "rock_2";
      text = "Islands are obstacles which block the way of your ships. "
          "If you attack one on the enemy's territory, "
          "it might look like you've hit a ship. Don't be fooled.";
      _view.changeInstructionButton(i);
      _view.setInstruction(object, picture, text);
    }else if(i == 3){
      object = "Moving a Ship";
      picture = "shipbuilder_east";
      text = "In order to move a ship, "
          "simply tap on it and use the arrows to move it. "
          "You can choose between moving a ship and attacking the enemy every round.";
      _view.changeInstructionButton(i);
      _view.setInstruction(object, picture, text);
    }else if(i == 4){
      object = "PowerUp";
      picture = "powerup_fog";
      text = "Attacking power ups randomly activates one of two effects. "
          "They either reveal one of the enemy's ships or increase the radius of your attacks.";
      _view.changeInstructionButton(i);
      _view.setInstruction(object, picture, text);
    }
  }
}


