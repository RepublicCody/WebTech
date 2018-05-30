part of warships;

class GameController{
  GameModel model = new GameModel();
  GameView view = new GameView();

  var menuListener;
  var tableListener;
  var gameoverListener;

  GameController() {
    view.showMenu();
    //view.showGameover();
    view.generateMenu();
    view.generateField(model.playingField);
    view.generateGameoverscreen();
    
    menuListener = querySelectorAll('.button').onClick.listen(selectLevel);
    tableListener = querySelectorAll('tr').onClick.listen(buildShip);
    addListeners();
  }

  // this possibly belongs into the view,
  List<int> rowCol(String cssId) {
    RegExp re = new RegExp("field_([0-9]+)_([0-9]+)");
    Match m = re.firstMatch(cssId);
    return [int.parse(m.group(1)), int.parse(m.group(2))];
  }


  void fireAt(MouseEvent e) {
    print(e.target.runtimeType);
    if (e.target is Element) {
      HtmlElement element = e.target;
      var rc = rowCol(element.id);
      model.fireAt(rc[0], rc[1]);
      model.enemy.makeMove();
      view.update(model.playingField);
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
      view.update(model.playingField);
      view.showGame();
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
    //querySelectorAll('td').onClick.listen(fireAt);
  }

  void buildShip(MouseEvent e) {
    if (e.target is Element) {
      HtmlElement element = e.target;
      var rc = rowCol(element.id);
      model.playingField.buildShip(rc[0], rc[1]);
      view.update(model.playingField);

      if (model.playingField.shipBuildingComplete()) {
        print("ship building complete");
        this.tableListener.cancel();
        this.tableListener = querySelectorAll('tr').onClick.listen(fireAt);  //change to fireat on click on table
        print(model.playingField.ships.length);
      }
    }
  }

}


