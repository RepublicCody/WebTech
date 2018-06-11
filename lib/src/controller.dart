part of warships;

class GameController{
  GameModel model = new GameModel();
  GameView view = new GameView();

  var menuListener;
  var tableListener;
  var gameoverListener;

  int lastPlayed = 0;

  GameController() {
    view.generateMenu();
    view.generateField(model.playingField);
    view.generateGameoverscreen();
    view.showMenu();
    //view.showGame();
    //iew.showGameover();
    menuListener = querySelectorAll('#menu .button').onClick.listen(selectLevel);
    tableListener = querySelectorAll('td').onClick.listen(buildShip);
    gameoverListener = querySelectorAll('#gameover .button').onClick.listen(gameOver);
    addListeners();
  }

  // this possibly belongs into the view,
  List<int> rowCol(String cssId) {
    RegExp re = new RegExp("field_([0-9]+)_([0-9]+)");
    Match m = re.firstMatch(cssId);
    return [int.parse(m.group(1)), int.parse(m.group(2))];
  }


  void fireAt(MouseEvent e) {
    if (e.target is Element) {
      HtmlElement element = e.target;
      var rc = rowCol(element.id);
      model.fireAt(rc[0], rc[1]);
      view.setInGameText("${model.playingField.enemyShipCount()} Gegnerische Schiffe übrig");
      if (model.playingField.gameOver()) {
        String text = model.playingField.enemyShipCount() == 0 ? "Herzlichen Glückwunsch, Du hast gewonnen!" : "Schade, Du hast verloren!";
        view.setGameoverText(text);
        view.showGameover();
        this.tableListener.cancel();
        this.tableListener = querySelectorAll('td').onClick.listen(buildShip);  //change to fireat on click on table
      } else {
        model.enemy.makeMove();
        view.update(model.playingField);
        if (model.playingField.gameOver()) {
          view.showGameover();
          this.tableListener.cancel();
          this.tableListener = querySelectorAll('td').onClick.listen(buildShip);  //change to fireat on click on table
        }
      }
    }
  }

  void selectLevel(MouseEvent e) {
    if (e.target is Element){
      HtmlElement element = e.target;
      RegExp re = new RegExp("level_([0-9]+)");
      Match m = re.firstMatch(element.id);
      // TODO: implement random level
      print("start level ${m.group(1)}");
      model.generatePlayingField(int.parse(m.group(1)));
      view.setInGameText("${model.playingField.playerShipLengths[0]}er Schiff setzen");
      lastPlayed = int.parse(m.group(1));
      view.update(model.playingField);
      view.showGame();
    }
  }

  void gameOver(Event e) {
    if (e.target is Element) {
      HtmlElement element = e.target;
      if (element.id == "menuGameover") {
        view.showMenu();
      } else if (element.id == "nextGameover"){
        model.generatePlayingField(lastPlayed + 1);
        view.setInGameText("${model.playingField.playerShipLengths[0]}er Schiff setzen");
        lastPlayed++;
        view.update(model.playingField);
        view.showGame();
      }
    }
  }

  void goBack() {
    view.showMenu();
  }

  //  this can be disposed of once all listeners are implemented properly
  void addListeners() {
    querySelector("#zufall").onClick.listen((Event e) {
      view.showGame();
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
            "${model.playingField.playerShipLengths[model.playingField.playerShipCount()]}er Schiff setzen");
      }
      view.update(model.playingField);
      if (model.playingField.shipBuildingComplete()) {
        this.tableListener.cancel();
        this.tableListener = querySelectorAll('tr').onClick.listen(fireAt);  //change to fireat on click on table
        view.setInGameText("${model.playingField.enemyShipCount()} Gegnerische Schiffe übrig");
      }
    }
  }

}


