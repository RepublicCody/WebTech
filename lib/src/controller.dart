part of warships;

List<int> shipss = [2, 3, 3, 4];
int pos = 0;
bool setShip = false;

class GameController{
  GameModel model = new GameModel(1);
  GameView view = new GameView();

  GameController() {
    view.showMenu();
    view.generateMenu();
    view.generateField(model.playingField);
    //  querySelector("#level_1").onClick.listen((Event e) {view.showGame();});
    //  querySelector("#level_2").onClick.listen((Event e) {view.showGame();});
    querySelector("#level_3").onClick.listen((Event e) {
      view.showGame();
    });
    querySelector("#level_4").onClick.listen((Event e) {
      view.showGame();
    });
    querySelector("#zufall").onClick.listen((Event e) {
      view.showGame();
    });
    querySelector("#back").onClick.listen((Event e) {
      view.showMenu();
    });

    querySelector("#level_1").onClick.listen((Event e) {
      lvl_1();
    });
    querySelector("#level_2").onClick.listen((Event e) {
      lvl_2();
    });

    querySelectorAll('tr').onClick.listen(view.search);
  }

  void lvl_1() {
    view.showGame();
  }

  void lvl_2() {
    view.showGame();
  }

}

/*
  var model = new GameModel(16, 8);
  String lvl;
  var game = new gamePlay(row, column);

  final view = new gameView();


  GameController(){
    view.generateField(model.playingField);
    view.generateMenu();


    querySelector("#gameTable").style.display="none";
    querySelector("#level_1").onClick.listen((Event e) {view.showGame();});
    querySelector("#level_2").onClick.listen((Event e) {view.showGame();});
    querySelector("#level_3").onClick.listen((Event e) {view.showGame();});
    querySelector("#level_4").onClick.listen((Event e) {view.showGame();});
    querySelector("#zufall").onClick.listen((Event e) {view.showGame();});
    querySelector("#back").onClick.listen((Event e) {view.showMenu();});

    //querySelector("#level_1").onClick.listen((Event e) {lvl_1();});
    //querySelector("#level_2").onClick.listen((Event e) {lvl_2();});

  GameController() {
    view.generateField(model.playingField);
    view.generateMenu();


    querySelector("#gameTable").style.display = "none";
    querySelector("#level_1").onClick.listen(lvl_1);
    querySelector("#level_2").onClick.listen(view.changeVisability);
    querySelector("#level_3").onClick.listen(view.changeVisability);
    querySelector("#level_4").onClick.listen(view.changeVisability);
    querySelector("#zufall").onClick.listen(view.changeVisability);
    querySelector("#back").onClick.listen(view.goBack);

/*
    switch (lvl) {
      case "level_1":
        {
          // PlayingField lvl_1 = new PlayingField();
          querySelector("#field_0_3").style.backgroundImage =
          'url("images/nebel_getroffen_rot.png")';
        }
        break;

      case "level_2":
        {
          // PlayingField lvl_2 = new PlayingField();
          querySelector("#field_10_3").style.backgroundImage =
          'url("images/nebel_getroffen_rot.png")';
        }
        break;

      case "level_3":
        {
          // PlayingField lvl_3 = new PlayingField();
          querySelector("#field_10_8").style.backgroundImage =
          'url("images/nebel_getroffen_rot.png")';
        }
        break;

      case "level_4":
        {
          // PlayingField lvl_4 = new PlayingField();
          querySelector("#field_12_4").style.backgroundImage =
          'url("images/nebel_getroffen_rot.png")';
        }
        break;

      case "zufall":
        {
          // PlayingField lvl_zufall = new PlayingField();
          querySelector("#field_7_3").style.backgroundImage =
          'url("images/nebel_getroffen_rot.png")';
        }
        break;
    }*/
  }
*/