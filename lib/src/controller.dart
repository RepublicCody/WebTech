part of warships;

List<int> shipss = [2, 3, 3, 4];
int pos = 0;

class GameController {
  GameModel model = new GameModel(16, 8);
  GameView view = new GameView();

  GameController() {
    view.showMenu();
    view.generateField(model.playingField);
    view.generateMenu();
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

    querySelectorAll('tr').onClick.listen(search);
  }

  void lvl_1() {
    PlayingField lvl_1 = new PlayingField(row, column);
    view.showGame();
  }

  void lvl_2() {
    // PlayingField lvl_1 = new PlayingField();
    querySelector("#field_10_3").style.backgroundImage =
        'url("images/nebel_getroffen_rot.png")';
    view.showGame();
  }

  void search(MouseEvent event) {
    if (event.target is Element) {
      Element target = event.target;

      if (pos < shipss.length) {
        int length = shipss[pos];

        if (target.attributes["class"] == "water") {
          target.attributes["class"] = "shipStart";
          String id = target.attributes["id"];
          List<int> rowCol = getRowCol(id);
          setArrow(rowCol, length);
        }


        else if (target.attributes["class"] == "up") {
          List<int> rowCol = getRowCol(target.attributes["id"]);
          int r = rowCol[0];
          int c = rowCol[1];
          querySelector('#field_' + (r + 1).toString() + '_' + (c).toString()).attributes["class"] = "ship_vertical_back";

          if (length > 2) {
            for (int x = 0; x < length - 2; x++) {
              querySelector('#field_' + (r - x).toString() + '_' + (c).toString()).attributes["class"] = "ship_vertical";
            }
            querySelector('#field_' + (r - length + 2).toString() + '_' + (c).toString()).attributes["class"] = "ship_vertical_front";
          } else {
            target.attributes["class"] = "ship_vertical_front";
          }
          pos++;
          removeArrows(r, c, "up");
        }


        else if (target.attributes["class"] == "right") {
          List<int> rowCol = getRowCol(target.attributes["id"]);
          int r = rowCol[0];
          int c = rowCol[1];
          querySelector('#field_' + (r).toString() + '_' + (c - 1).toString()).attributes["class"] = "ship_horizontal_front";

          if (length > 2) {
            for (int x = 0; x < length - 2; x++) {
              querySelector('#field_' + (r).toString() + '_' + (c + x).toString()).attributes["class"] = "ship_horizontal";
            }
            querySelector('#field_' + (r).toString() + '_' + (c + length - 2).toString()).attributes["class"] = "ship_horizontal_back";
          } else {
            target.attributes["class"] = "ship_horizontal_back";
          }
          pos++;
          removeArrows(r, c, "right");
        }


        else if (target.attributes["class"] == "down") {
          List<int> rowCol = getRowCol(target.attributes["id"]);
          int r = rowCol[0];
          int c = rowCol[1];
          querySelector('#field_' + (r - 1).toString() + '_' + (c).toString()).attributes["class"] = "ship_vertical_front";

          if (length > 2) {
            for (int x = 0; x < length - 2; x++) {
              querySelector('#field_' + (r + x).toString() + '_' + (c).toString()).attributes["class"] = "ship_vertical";
            }
            querySelector('#field_' + (r + length - 2).toString() + '_' + (c).toString()).attributes["class"] = "ship_vertical_back";
          } else {
            target.attributes["class"] = "ship_vertical_back";
          }
          pos++;
          removeArrows(r, c, "down");
        }


        else if (target.attributes["class"] == "left") {
          List<int> rowCol = getRowCol(target.attributes["id"]);
          int r = rowCol[0];
          int c = rowCol[1];
          querySelector('#field_' + (r).toString() + '_' + (c + 1).toString()).attributes["class"] = "ship_horizontal_back";

          if (length > 2) {
            for (int x = 0; x < length - 2; x++) {
              querySelector('#field_' + (r).toString() + '_' + (c - x).toString()).attributes["class"] = "ship_horizontal";
            }
            querySelector('#field_' + (r).toString() + '_' + (c - length + 2).toString()).attributes["class"] = "ship_horizontal_front";
          } else {
            target.attributes["class"] = "ship_horizontal_front";
          }
          pos++;
          removeArrows(r, c, "left");
        }
      }
    }
  }

  void setArrow(List rowCol, int length) {
    int r = rowCol[0];
    int c = rowCol[1];
    bool possible = false;

    Element up =
        querySelector('#field_' + (r - 1).toString() + '_' + (c).toString());
    Element right =
        querySelector('#field_' + (r).toString() + '_' + (c + 1).toString());
    Element down =
        querySelector('#field_' + (r + 1).toString() + '_' + (c).toString());
    Element left =
        querySelector('#field_' + (r).toString() + '_' + (c - 1).toString());


    if (up.attributes["class"] == "water") {
      possible = true;
      for(int x = 1; x < length; x++){
        if(querySelector('#field_' + (r - x).toString() + '_' + (c).toString()).attributes["class"] != "water"){
          possible = false;
        }
      }
       if(possible == true){
        up.attributes["class"] = "up";
        }
    }
    if (right.attributes["class"] == "water") {
      possible = true;
      for (int x = 1; x < length; x++) {
        if (querySelector('#field_' + (r + x).toString() + '_' + (c).toString())
            .attributes["class"] != "water") {
          possible = false;
        }
      }
      if(possible == true){
      right.attributes["class"] = "right";
      }
    }
    if (down.attributes["class"] == "water") {
      down.attributes["class"] = "down";
    }
    if (left.attributes["class"] == "water") {
      left.attributes["class"] = "left";
    }
  }

  List getRowCol(String fieldID) {
    List<String> rowCol = [];
    rowCol = fieldID.split("_");
    List<int> rowColInt = [int.parse(rowCol[1]), int.parse(rowCol[2])];
    return rowColInt;
  }

  void removeArrows(int r, int c, String direction){
    if(direction == "up"){
      if (querySelector('#field_' + (r + 2).toString() + '_' + (c).toString()).attributes["class"] == "down") {
        querySelector('#field_' + (r + 2).toString() + '_' + (c).toString()).attributes["class"] = "water";
      }
      if (querySelector('#field_' + (r + 1).toString() + '_' + (c + 1).toString()).attributes["class"] == "right") {
        querySelector('#field_' + (r + 1).toString() + '_' + (c + 1).toString()).attributes["class"] = "water";
      }
      if (querySelector('#field_' + (r + 1).toString() + '_' + (c - 1).toString()).attributes["class"] == "left") {
        querySelector('#field_' + (r + 1).toString() + '_' + (c - 1).toString()).attributes["class"] = "water";
      }
    }

    if(direction == "right"){
      if (querySelector('#field_' + (r + 1).toString() + '_' + (c - 1).toString()).attributes["class"] == "down") {
        querySelector('#field_' + (r + 1).toString() + '_' + (c - 1).toString()).attributes["class"] = "water";
      }
      if (querySelector('#field_' + (r - 1).toString() + '_' + (c - 1).toString()).attributes["class"] == "up") {
        querySelector('#field_' + (r - 1).toString() + '_' + (c - 1).toString()).attributes["class"] = "water";
      }
      if (querySelector('#field_' + (r).toString() + '_' + (c - 2).toString()).attributes["class"] == "left") {
        querySelector('#field_' + (r).toString() + '_' + (c - 2).toString()).attributes["class"] = "water";
      }
    }

    if(direction == "down"){
      if (querySelector('#field_' + (r - 2).toString() + '_' + (c).toString()).attributes["class"] == "up") {
        querySelector('#field_' + (r - 2).toString() + '_' + (c).toString()).attributes["class"] = "water";
      }
      if (querySelector('#field_' + (r - 1).toString() + '_' + (c + 1).toString()).attributes["class"] == "right") {
        querySelector('#field_' + (r - 1).toString() + '_' + (c + 1).toString()).attributes["class"] = "water";
      }
      if (querySelector('#field_' + (r - 1).toString() + '_' + (c - 1).toString()).attributes["class"] == "left") {
        querySelector('#field_' + (r - 1).toString() + '_' + (c - 1).toString()).attributes["class"] = "water";
      }
    }

    if(direction == "left"){
      if (querySelector('#field_' + (r + 1).toString() + '_' + (c + 1).toString()).attributes["class"] == "down") {
        querySelector('#field_' + (r + 1).toString() + '_' + (c + 1).toString()).attributes["class"] = "water";
      }
      if (querySelector('#field_' + (r - 1).toString() + '_' + (c + 1).toString()).attributes["class"] == "up") {
        querySelector('#field_' + (r - 1).toString() + '_' + (c + 1).toString()).attributes["class"] = "water";
      }
      if (querySelector('#field_' + (r).toString() + '_' + (c + 2).toString()).attributes["class"] == "right") {
        querySelector('#field_' + (r).toString() + '_' + (c + 2).toString()).attributes["class"] = "water";
      }
    }
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
