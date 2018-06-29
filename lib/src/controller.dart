part of warships;

class GameController{
  GameModel model = new GameModel();
  GameView view = new GameView();

  var menuListener;
  var tableListener;
  var gameoverListener;
  var messageListener;
  var deviceListener;
  var fullscreenListener;
  var exitfullscreenListener;
  var instructionListener;

  int lastPlayed = 0;

  /**
   * Creates a new GameController instance
   */
  GameController() {
    JsObject jsObject = new JsObject.fromBrowserObject(querySelector("#menu"));
    int scrollHeight = jsObject['scrollHeight'];
    jsObject['scrollTop'] = '${scrollHeight}';
    view.generateMenu();
    view.generateField(model.playingField);
    view.generateGameoverscreen();
    view.generateMessage();
    view.generateDevice();
    view.generateAnimatedMessage();
    view.generateInstruction();
    view.showMenu();
    window.onResize.listen((e) => view.fieldSize());
    instructionListener = querySelector("#instructionButton").onClick.listen((MouseEvent e) {changeInstruction(1);});
    instructionListener = querySelector("#nextInstruction1").onClick.listen((MouseEvent e) {changeInstruction(2);});
    instructionListener = querySelector("#nextInstruction2").onClick.listen((MouseEvent e) {changeInstruction(3);});
    instructionListener = querySelector("#nextInstruction3").onClick.listen((MouseEvent e) {changeInstruction(4);});
    instructionListener = querySelector("#backInstruction").onClick.listen((MouseEvent e) {view.showMenu();});
    messageListener = querySelector('#messageNext').onClick.listen((MouseEvent e) {view.showGame();});
    deviceListener = querySelector('#deviceButton').onClick.listen((MouseEvent e) {view.hideDevice();});
    menuListener = querySelectorAll('#menu .button').onClick.listen(selectLevel);
    tableListener = querySelectorAll('td').onClick.listen(buildShip);
    gameoverListener = querySelectorAll('#gameover .button').onClick.listen(gameOver);
    fullscreenListener = querySelector('#fullscreenbutton').onClick.listen((MouseEvent e) {fullscreenMode(querySelector("body"));});
    addListeners();
  }

  /**
   * parses the row and the col of an html table element from it's id
   * @param the element's id
   * @returns a List containing the row and the col of the element
   */
  List<int> rowCol(String cssId) {
    print("Hallo3");
    RegExp re = new RegExp("[a-z]+_([0-9]+)_([0-9]+)");
    print("Hallo4");
    Match m = re.firstMatch(cssId);
    print("Hallo5");
    print(m.group(1));
    print(int.parse(m.group(2)));
    return [int.parse(m.group(1)), int.parse(m.group(2))];
  }

  /**
   * manages the player's actions on the playing field
   */
  void fireAt(MouseEvent e) {
    if (e.target is Element) {
      print("Hallo1");
      HtmlElement element = e.target;
      print("Hallo2");
      print(element.id);
      var rc = rowCol(element.id);
      print("HalloDONE");
      if (rc[0] < model.playingField.enemyRows &&
          !model.playingField[rc[0]][rc[1]].hit) {
        model.playingField.removeMovers();
        int i = model.playingField.enemyShipCount();
        print("enemy ship count before: " + i.toString());
        model.fireAt(rc[0], rc[1]);
        print("enemy ship count after: " + model.playingField.enemyShipCount().toString());
        if(i > model.playingField.enemyShipCount()){
          sunkShipAnimation();
        }
        shipsleftMessage();
        if (model.playingField.gameOver()) {
          view.update(model.playingField);
          gameoverScreen();
          this.tableListener.cancel();
          this.tableListener = querySelectorAll('td').onClick.listen(
              buildShip); //change to fireat on click on table
        } else {
          enemyMove();
        }
      } else if (model.playingField[rc[0]][rc[1]].entity != null) {
        if (model.playingField[rc[0]][rc[1]].entity is Ship) {
          Ship s = model.playingField[rc[0]][rc[1]].entity;
          if (s.friendly) {
            model.playingField.moveShip(rc[0], rc[1]);
            view.update(model.playingField);
          }
        } else if (model.playingField[rc[0]][rc[1]].entity is ShipMover) {
          model.playingField.moveShip(rc[0], rc[1]);
          enemyMove();
          view.update(model.playingField);
        }
      }
    }
  }

  /**
   * initializes th enemy making a move
   */
  void enemyMove() {
    model.enemy.makeMove();
    shipsleftMessage();
    view.update(model.playingField);
  }

  /**
   * instructs the view to show the game over screen after the game is finished
   */
  void gameoverScreen(){
    String text = model.playingField.enemyShipCount() == 0 ? "YOU WIN!" : "YOU LOST!";
    querySelector('#gameoverText').attributes["class"] = model.playingField.enemyShipCount() == 0 ? "win" : "loose";
    querySelector('#nextGameover').style.display = model.playingField.enemyShipCount() == 0 ? "block" : "none";
    querySelector('#restartGameover').style.display = model.playingField.enemyShipCount() == 0 ? "none" : "block";
    view.setGameoverText(text);
    view.showGameover();
  }

  /**
   * manages the users actions on the menu screen
   */
  void selectLevel(MouseEvent e) {
    if (e.target is Element){
      HtmlElement element = e.target;
      RegExp re = new RegExp("level_([0-9]+)");
      if (re.hasMatch(element.id)) {
        Match m = re.firstMatch(element.id);
        model.generatePlayingField(int.parse(m.group(1)));
        lastPlayed = int.parse(m.group(1));
      } else {
        int lvl = model.randomLevel();
        model.generatePlayingField(lvl);
        lastPlayed = lvl;
      }
      view.setInGameText("Place a ${model.playingField.playerShipLengths[0]}-part ship");
      view.setInGameLevel("Level $lastPlayed");
      view.update(model.playingField);
      setMessage();
      view.showMessage();
    }
  }

  /**
   * manages the users actions on the game over screen
   */
  void gameOver(Event e) {
    if (e.target is Element) {
      HtmlElement element = e.target;
      if (element.id == "menuGameover") {
        view.showMenu();
      } else if (element.id == "nextGameover") {
        model.generatePlayingField(lastPlayed + 1);
        view.setInGameText(
            "Place a ${model.playingField.playerShipLengths[0]}-part ship");
        view.setInGameLevel("Level " + (lastPlayed+1).toString());
        lastPlayed++;
        view.update(model.playingField);
        setMessage();
        view.showMessage();
      } else if (element.id == "restartGameover") {
        model.generatePlayingField(lastPlayed);
        view.setInGameText(
            "Place a ${model.playingField.playerShipLengths[0]}-part ship");
        view.setInGameLevel("Level $lastPlayed");
        view.update(model.playingField);
        setMessage();
        view.showMessage();
      }
    }
  }

  /**
   * resets the listeners on the table
   */
  void goBack() {
    this.tableListener.cancel();
    this.tableListener = querySelectorAll('td').onClick.listen(buildShip);
    view.showMenu();
  }

  /**
   * adds listeners to the random level button and the home button
   */
  void addListeners() {
    querySelector("#zufall").onClick.listen((Event e) {
      setMessage();
      view.showMessage();
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
      bool completed = model.playingField.buildShip(rc[0], rc[1], true);
      if (completed && model.playingField.playerShipCount() < model.playingField.playerShipLengths.length) {
        view.setInGameText(
            "Place a ${model.playingField.playerShipLengths[model.playingField.playerShipCount()]}-part ship");
      }
      view.update(model.playingField);
      if (model.playingField.shipBuildingComplete()) {
        this.tableListener.cancel();
        this.tableListener = querySelectorAll('tr').onClick.listen(fireAt);  //change to fireat on click on table
        shipsleftMessage();
      }
    }
  }

  void setMessage(){
    List<String> s = ["0", "0", "0", "0", "0", "0", "0", "0"];
    List<int> c = [0,0,0,0,0,0,0,0];

    for(int i = 0; i < model.playingField.ships.length; i++){
      if(model.playingField.ships[i] is Destroyer){
        if(model.playingField.ships[i]._friendly == true){
          c[0]++;
        }else{c[4]++;}
      }else if(model.playingField.ships[i] is Submarine){
        if(model.playingField.ships[i]._friendly == true){
          c[1]++;
        }else{c[5]++;}
      }else if(model.playingField.ships[i] is BattleShip){
        if(model.playingField.ships[i]._friendly == true){
          c[2]++;
        }else{c[6]++;}
      }else if(model.playingField.ships[i] is Carrier){
        if(model.playingField.ships[i]._friendly == true){
          c[3]++;
        }else{c[7]++;}
      }
    }

    for(int i = 0; i < model.playingField.playerShipLengths.length; i++){
      if(model.playingField.playerShipLengths[i] == 2){
          c[0]++;
      }else if(model.playingField.playerShipLengths[i] == 3){
          c[1]++;
      }else if(model.playingField.playerShipLengths[i] == 4){
          c[2]++;
      }else if(model.playingField.playerShipLengths[i] == 5){
          c[3]++;
      }
    }

    for(int x = 0; x < c.length; x++){
      s[x] = "x " + c[x].toString();
    }
    String t = "";

    switch(model.enemy._strategy){
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

    view.setMessageEnemy(t);
    view.setShipCount(s);

  }

  /**
   * instructs the view to display how many ships the enemy has left
   */
  void shipsleftMessage(){
    if(model.playingField.enemyShipCount() == 1){
      view.setInGameText("${model.playingField.enemyShipCount()} Ship left");
    }else {
      view.setInGameText(
          "${model.playingField.enemyShipCount()} Ships left");
    }
  }

  void fullscreenMode(Element element){
    view.fullscreenWorkaround(element);
  }

  /**
   * requests the view to display the animation for sinking a ship
   */
  void sunkShipAnimation(){
    view.showAnimatedMessage();
    new Timer(new Duration(milliseconds: 500), () => view.hideAnimatedMessage());
  }

  /**
   * requests the view to display the tutorial for the game
   */
  void changeInstruction(int i){
    String object = "";
    String picture = "";
    String text = "";
    if(i == 1){
      view.showInstruction();
      object = "Placing a Ship";
      picture = "shipbuilder_center";
      text = "Place your ships in the lower field. "
          "You and the enemy can place them beyond the left and the right border.";
      view.changeInstructionButton(i);
      view.setInstruction(object, picture, text);
    }else if(i == 2){
      object = "Island";
      picture = "rock_2";
      text = "Islands are obstacles which block the way of your ships. "
          "If you attack one on the enemy's territory, "
          "it might look like you've hit a ship. Don't be fooled.";
      view.changeInstructionButton(i);
      view.setInstruction(object, picture, text);
    }else if(i == 3){
      object = "Moving a Ship";
      picture = "shipbuilder_east";
      text = "In order to move a ship, "
          "simply tap on it and use the arrows to move it. "
          "You can choose between moving a ship and attacking the enemy every round.";
      view.changeInstructionButton(i);
      view.setInstruction(object, picture, text);
    }else if(i == 4){
      object = "PowerUp";
      picture = "powerup_fog";
      text = "Attacking power ups randomly activates one of two effects. "
          "They either reveal one of the enemy's ships or increase the radius of your attacks.";
      view.changeInstructionButton(i);
      view.setInstruction(object, picture, text);
    }
  }
}


