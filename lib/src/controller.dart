part of warships;

class GameController{
  GameModel model = new GameModel(1);
  GameView view = new GameView();

  var menuListener;
  var tableListener;

  GameController() {
    view.showMenu();
    view.generateMenu();
    view.generateField(model.playingField);
    
    menuListener = querySelectorAll('.button').onClick.listen(selectLevel);
    tableListener = querySelectorAll('tr').onClick.listen(buildShips);
    addListeners();
  }

  //TODO: possibly belongs into the view ???
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
      //model.enemy.makeMove(); TODO: enemy makes their move here
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
      model = new GameModel(int.parse(m.group(1)));
      view.update(model.playingField);
      view.showGame();
    }
  }

  void goBack() {
    view.showMenu();
    model = null;
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
    view.search(e);
  }


  void buildShips(MouseEvent e) {
    if (e.target is Element) {
      HtmlElement element = e.target;
      var rc = rowCol(element.id);
      model.playingField.buildShip(rc[0], rc[1]);
      view.update(model.playingField);
    }
  }

}


