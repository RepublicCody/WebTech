part of warships;

class GameView {
  final menu = querySelector("#menu");

  final gameover = querySelector("#gameover");

  final gameTable = querySelector("#gameTable");

  List<List<HtmlElement>> fields;

  void generateField(PlayingField playingField) {
    List<List<Field>> tiles = playingField.fields;
    int text = tiles[0].length - 1;
    String table = "<tbody><tr><th colspan='$text' id='text'></th> <th id='back' class='back'></th></tr>";
    for (int row = 0; row < tiles.length; row++) {
      table += "<tr>";        //Ich wäre dafür tr noch die class enemy und player zu geben, zumindest kann ich mir gut vorstellen, dass man damit später beim Schiffe platzieren leichtes Spiel hat
      for (int col = 0; col < tiles[row].length; col++) {
        var terrain = tiles[row][col].entity;
        var position = "field_${row}_${col}";
        table += "<td id ='${position}' class='${cssClass(tiles[row][col])}'></td>";
      }
      table += "</tr>";
    }
    table += "</tbody>";
    gameTable.innerHtml = table;
    fields = new List<List<HtmlElement>>(tiles.length);
    for (int row = 0; row < tiles.length; row++) {
      fields[row] = new List<HtmlElement>();
      for(int col = 0; col < tiles[row].length; col++) {
        fields[row].add(querySelector("#field_${row}_${col}"));
      }
    }

    //TODO: width und height des gameTables anpassen
  }


  void generateMenu() {
    String menuString;
    menuString = '<div id="menu_head">Warships Menu</div><br>';
    for (int x = 1; x < 5; x++) {
      menuString +=
          '<input type="button" id="level_$x" class="button" value="Level $x"></input> <br>';
    }
    menuString += '<input type="button" id="zufall" class="button" value="Zufall"></input>';

    menu.innerHtml = menuString;
  }

  void update(PlayingField playingField) {
    List<List<Field>> tiles = playingField.fields;
    for (int row = 0; row < fields.length; row++) {
      for (int col = 0; col < fields[row].length; col++) {
        this.fields[row][col].attributes["class"] = cssClass(tiles[row][col]);
      }
    }
  }

  String cssClass(Field f) {
    if (f.foggy) {
      return f.hit ? f.entity == null ? "fog_miss" : "fog_hit" : "fog";
    }
    if (f.entity == null) {
      return f.hit ? "water_miss" : "water";
    }
    if (f.entity is Ship) {
      String css = "";
      Ship s = f.entity;
      css += s.vertical ? "_vertical" : "_horizontal";
      css += s.fields.indexOf(f) == 0 ? "_front" : s.fields.indexOf(f) == s.fields.length ? "_back" : "";
      css += f.hit ? "_hit" : "";
      return css;
    }
    if (f.entity is Rock) {
      return f.hit ? "rock_hit" : "rock";
    }
    if (f.entity is PowerUp) {
      return "powerup";
    }
    return "";
  }

  void showGame() {
    querySelector("#menu").style.display="none";
    querySelector("#gameTable").style.display="block";
  }
  //void goBack(Event e){

  void showMenu() {
    querySelector("#menu").style.display="block";
    querySelector("#gameTable").style.display="none";
  }




  void search(MouseEvent event) {
    if (event.target is Element) {
      Element target = event.target;

      if (pos < shipss.length) {
        int length = shipss[pos];

        if (target.attributes["class"] == "water" && setShip == false) {
          target.attributes["class"] = "shipStart";
          setShip = true;
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
          setShip = false;
        }


        else if (target.attributes["class"] == "right") {
          List<int> rowCol = getRowCol(target.attributes["id"]);
          int r = rowCol[0];
          int c = rowCol[1];
          int dummy;
          dummy = c - 1;
          if(dummy < 0)dummy += COLCOUNT;
          querySelector('#field_' + (r).toString() + '_' + (dummy).toString()).attributes["class"] = "ship_horizontal_front";

          if (length > 2) {
            for (int x = 0; x < length - 2; x++) {
              dummy = c + x;
              if(dummy >= COLCOUNT)dummy -= COLCOUNT;
              querySelector('#field_' + (r).toString() + '_' + (dummy).toString()).attributes["class"] = "ship_horizontal";
            }
            dummy = c + length - 2;
            if(dummy >= COLCOUNT)dummy -= COLCOUNT;
            querySelector('#field_' + (r).toString() + '_' + (dummy).toString()).attributes["class"] = "ship_horizontal_back";
          } else {
            target.attributes["class"] = "ship_horizontal_back";
          }
          pos++;
          removeArrows(r, c, "right");
          setShip = false;
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
          setShip = false;
        }


        else if (target.attributes["class"] == "left") {
          List<int> rowCol = getRowCol(target.attributes["id"]);
          int r = rowCol[0];
          int c = rowCol[1];
          int dummy;
          dummy = c + 1;
          if(dummy >= COLCOUNT)dummy -= COLCOUNT;
          querySelector('#field_' + (r).toString() + '_' + (dummy).toString()).attributes["class"] = "ship_horizontal_back";

          if (length > 2) {
            for (int x = 0; x < length - 2; x++) {
              dummy = c - x;
              if(dummy < 0)dummy += COLCOUNT;
              querySelector('#field_' + (r).toString() + '_' + (dummy).toString()).attributes["class"] = "ship_horizontal";
            }
            dummy = c - length + 2;
            if(dummy < 0)dummy += COLCOUNT;
            querySelector('#field_' + (r).toString() + '_' + (dummy).toString()).attributes["class"] = "ship_horizontal_front";
          } else {
            target.attributes["class"] = "ship_horizontal_front";
          }
          pos++;
          removeArrows(r, c, "left");
          setShip = false;
        }
      }
    }
  }

  void setArrow(List rowCol, int length) {
    int r = rowCol[0];
    int c = rowCol[1];
    int dummy;
    bool possible = false;
    bool arrow = false;

    Element up = querySelector('#field_' + (r - 1).toString() + '_' + (c).toString());
    dummy = c + 1;
    if(dummy >= COLCOUNT)dummy -= COLCOUNT;
    Element right = querySelector('#field_' + (r).toString() + '_' + (dummy).toString());
    dummy = r + 1;
    Element down;
    if(dummy < ROWCOUNT) {
      down = querySelector(
          '#field_' + (dummy).toString() + '_' + (c).toString());
    }
    dummy = c - 1;
    if(dummy < 0)dummy += COLCOUNT;
    Element left = querySelector('#field_' + (r).toString() + '_' + (dummy).toString());


    if (up.attributes["class"] == "water") {
      possible = true;
      for(int x = 1; x < length; x++){
        if(querySelector('#field_' + (r - x).toString() + '_' + (c).toString()).attributes["class"] != "water"){
          possible = false;
        }
      }
      if(possible == true){
        up.attributes["class"] = "up";
        arrow = true;
      }
    }
    if (right.attributes["class"] == "water") {
      possible = true;
      int dummy;
      for (int x = 1; x < length; x++) {
        dummy = c + x;
        if(dummy >= COLCOUNT)dummy -= COLCOUNT;
        if (querySelector('#field_' + (r).toString() + '_' + (dummy).toString())
            .attributes["class"] != "water") {
          possible = false;
        }
      }
      if(possible == true){
        right.attributes["class"] = "right";
        arrow = true;
      }
    }
    if (down.attributes["class"] == "water") {
      possible = true;
      int dummy;
      for (int x = 1; x < length; x++) {
        dummy = r + x;
        if(dummy < ROWCOUNT) {
          if (querySelector('#field_' + (dummy).toString() + '_' + (c).toString()).attributes["class"] != "water") {
            possible = false;
          }
        }else{
          possible = false;
        }
      }
      if(possible == true) {
        down.attributes["class"] = "down";
        arrow = true;
      }
    }
    if (left.attributes["class"] == "water") {
      possible = true;
      int dummy;
      for (int x = 1; x < length; x++) {
        dummy = c - x;
        if(dummy < 0)dummy += COLCOUNT;
        if (querySelector('#field_' + (r).toString() + '_' + (dummy).toString()).attributes["class"] != "water") {
          possible = false;
        }
      }
      if(possible == true) {
        left.attributes["class"] = "left";
        arrow = true;
      }
    }
    if(arrow == false){
      querySelector('#field_' + (r).toString() + '_' + (c).toString()).attributes["class"] = "water";
      setShip = false;
    }
  }

  List getRowCol(String fieldID) {
    List<String> rowCol = [];
    rowCol = fieldID.split("_");
    List<int> rowColInt = [int.parse(rowCol[1]), int.parse(rowCol[2])];
    return rowColInt;
  }

  void removeArrows(int r, int c, String direction){
    int dummy;
    if(direction == "up"){
      if (querySelector('#field_' + (r + 2).toString() + '_' + (c).toString()).attributes["class"] == "down") {
        querySelector('#field_' + (r + 2).toString() + '_' + (c).toString()).attributes["class"] = "water";
      }
      dummy = c + 1;
      if(dummy >= COLCOUNT)dummy -= COLCOUNT;
      if (querySelector('#field_' + (r + 1).toString() + '_' + (dummy).toString()).attributes["class"] == "right") {
        querySelector('#field_' + (r + 1).toString() + '_' + (dummy).toString()).attributes["class"] = "water";
      }
      dummy = c - 1;
      if(dummy < 0)dummy += COLCOUNT;
      if (querySelector('#field_' + (r + 1).toString() + '_' + (dummy).toString()).attributes["class"] == "left") {
        querySelector('#field_' + (r + 1).toString() + '_' + (dummy).toString()).attributes["class"] = "water";
      }
    }

    if(direction == "right"){
      dummy = c - 1;
      if(dummy < 0)dummy += COLCOUNT;
      if (querySelector('#field_' + (r + 1).toString() + '_' + (dummy).toString()).attributes["class"] == "down") {
        querySelector('#field_' + (r + 1).toString() + '_' + (dummy).toString()).attributes["class"] = "water";
      }
      dummy = c - 1;
      if(dummy < 0)dummy += COLCOUNT;
      if (querySelector('#field_' + (r - 1).toString() + '_' + (dummy).toString()).attributes["class"] == "up") {
        querySelector('#field_' + (r - 1).toString() + '_' + (dummy).toString()).attributes["class"] = "water";
      }
      dummy = c - 2;
      if(dummy < 0)dummy += COLCOUNT;
      if (querySelector('#field_' + (r).toString() + '_' + (dummy).toString()).attributes["class"] == "left") {
        querySelector('#field_' + (r).toString() + '_' + (dummy).toString()).attributes["class"] = "water";
      }
    }

    if(direction == "down"){
      if (querySelector('#field_' + (r - 2).toString() + '_' + (c).toString()).attributes["class"] == "up") {
        querySelector('#field_' + (r - 2).toString() + '_' + (c).toString()).attributes["class"] = "water";
      }
      dummy = c + 1;
      if(dummy >= COLCOUNT)dummy -= COLCOUNT;
      if (querySelector('#field_' + (r - 1).toString() + '_' + (dummy).toString()).attributes["class"] == "right") {
        querySelector('#field_' + (r - 1).toString() + '_' + (dummy).toString()).attributes["class"] = "water";
      }
      dummy = c - 1;
      if(dummy < 0)dummy += COLCOUNT;
      if (querySelector('#field_' + (r - 1).toString() + '_' + (dummy).toString()).attributes["class"] == "left") {
        querySelector('#field_' + (r - 1).toString() + '_' + (dummy).toString()).attributes["class"] = "water";
      }
    }

    if(direction == "left"){
      dummy = c + 1;
      if(dummy >= COLCOUNT)dummy -= COLCOUNT;
      if (querySelector('#field_' + (r + 1).toString() + '_' + (dummy).toString()).attributes["class"] == "down") {
        querySelector('#field_' + (r + 1).toString() + '_' + (dummy).toString()).attributes["class"] = "water";
      }
      dummy = c + 1;
      if(dummy >= COLCOUNT)dummy -= COLCOUNT;
      if (querySelector('#field_' + (r - 1).toString() + '_' + (dummy).toString()).attributes["class"] == "up") {
        querySelector('#field_' + (r - 1).toString() + '_' + (dummy).toString()).attributes["class"] = "water";
      }
      dummy = c + 2;
      if(dummy >= COLCOUNT)dummy -= COLCOUNT;
      if (querySelector('#field_' + (r).toString() + '_' + (dummy).toString()).attributes["class"] == "right") {
        querySelector('#field_' + (r).toString() + '_' + (dummy).toString()).attributes["class"] = "water";
      }
    }
  }



}
