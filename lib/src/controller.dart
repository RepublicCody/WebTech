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

  int lastPlayed = 0;

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
    view.showMenu();
    window.onResize.listen((e) => view.fieldSize());
    messageListener = querySelector('#messageNext').onClick.listen((MouseEvent e) {view.showGame();});
    deviceListener = querySelector('#deviceButton').onClick.listen((MouseEvent e) {view.hideDevice();});
    menuListener = querySelectorAll('#menu .button').onClick.listen(selectLevel);
    tableListener = querySelectorAll('td').onClick.listen(buildShip);
    gameoverListener = querySelectorAll('#gameover .button').onClick.listen(gameOver);
    fullscreenListener = querySelector('#fullscreenbutton').onClick.listen((MouseEvent e) {fullscreenMode(0, querySelector("body"));});
    exitfullscreenListener = querySelector('#exitfullscreenbutton').onClick.listen((MouseEvent e) {fullscreenMode(1, querySelector("body"));});
    addListeners();
  }

  List<int> rowCol(String cssId) {
    RegExp re = new RegExp("field_([0-9]+)_([0-9]+)");
    Match m = re.firstMatch(cssId);
    return [int.parse(m.group(1)), int.parse(m.group(2))];
  }


  void fireAt(MouseEvent e) {
    if (e.target is Element) {
      HtmlElement element = e.target;
      var rc = rowCol(element.id);
      if(rc[0] < model.playingField.enemyRows){
        model.fireAt(rc[0], rc[1]);
        view.setInGameText("${model.playingField.enemyShipCount()} Ships left");
        if (model.playingField.gameOver()) {
          view.update(model.playingField);
          gameoverScreen();
          this.tableListener.cancel();
          this.tableListener = querySelectorAll('td').onClick.listen(buildShip);  //change to fireat on click on table
        } else {
            model.enemy.makeMove();
            view.setInGameText("${model.playingField.enemyShipCount()} Ships left");
            view.update(model.playingField);

            if (model.playingField.moveShips) {
              this.tableListener.cancel();
              this.tableListener =
                  querySelectorAll('td').onClick.listen(moveShip);
              view.setInGameText("Move a Ship");
            }

            if (model.playingField.gameOver()) {
              view.update(model.playingField);
              gameoverScreen();
              this.tableListener.cancel();
              this.tableListener = querySelectorAll('td').onClick.listen(buildShip);  //change to fireat on click on table
            }
        }
      }
    }
  }

  void moveShip(MouseEvent e) {
    if (e.target is Element) {
      HtmlElement element = e.target;
      var rc = rowCol(element.id);
      if (rc[0] >= model.playingField.enemyRows) {
        bool completed = model.playingField.moveShip(rc[0], rc[1]);
        view.update(model.playingField);
        if (completed) {
          this.tableListener.cancel();
          this.tableListener = querySelectorAll('td').onClick.listen(fireAt);
          view.setInGameText("${model.playingField.enemyShipCount()} Ships left");
        }
      }
    }
  }

  void gameoverScreen(){
    String text = model.playingField.enemyShipCount() == 0 ? "YOU WIN!" : "YOU LOST!";
    querySelector('#gameoverText').attributes["class"] = model.playingField.enemyShipCount() == 0 ? "win" : "loose";
    querySelector('#nextGameover').style.display = model.playingField.enemyShipCount() == 0 ? "block" : "none";
    querySelector('#restartGameover').style.display = model.playingField.enemyShipCount() == 0 ? "none" : "block";
    view.setGameoverText(text);
    view.showGameover();
  }

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

  void goBack() {
    this.tableListener.cancel();
    this.tableListener = querySelectorAll('td').onClick.listen(buildShip);
    view.showMenu();
  }

  //  this can be disposed of once all listeners are implemented properly
  void addListeners() {
    querySelector("#zufall").onClick.listen((Event e) {
      setMessage();
      view.showMessage();
    });

    querySelector("#back").onClick.listen((Event e) {
      goBack();
    });
  }

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
        view.setInGameText("${model.playingField.enemyShipCount()} Ships left");
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

  void fullscreenMode(int i, Element element){
    view.changeButton(i);
    view.fullscreenWorkaround(i, element);
  }

  void sunkShipAnimation(){

  }
}


