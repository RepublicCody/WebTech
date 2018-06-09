part of warships;

class GameView {
  final menu = querySelector("#menu");

  final gameover = querySelector("#gameover");

  final gameTable = querySelector("#gameTable");

  final message = querySelector("#message");

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
    fieldSize();

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
    int counter = 1;
    menuString = '<div id="menu_head">Warships</div><br>';
    for (int x = 1; x < 5; x++) {
      for (int y = 1; y <= 2; y++) {
        menuString +=
        '<input type="button" id="level_$counter" class="button" value="Level $counter"></input>';
        counter++;
      }
     // menuString +='<br>';
    }
    menuString +=
    '<input type="button" id="level_$counter" class="button" value="Level $counter"></input>';
    menuString += '<input type="button" id="zufall" class="button" value="Zufall"></input>';

    menu.innerHtml = menuString;
  }

  void generateGameoverscreen() {
    String gameoverString;
    gameoverString = '<div id="gameover_head">Game Over!</div><br>';
    gameoverString += '<div id="gameoverText"></div><br>';
    gameoverString += '<input type="button" id="menuGameover" class="button" value="Menü"></input> <br>';
    gameoverString += '<input type="button" id="nextGameover" class="button" value="Nächstes Spiel"></input>';
    gameoverString += '<input type="button" id="restartGameover" class="button" value="Neuer Versuch"></input>';
    gameover.innerHtml = gameoverString;
  }

  void generateMessage() {
    String messageString;
    messageString = '<div id="messageText">Bitte platziere deine Schiffe im unteren Spielfeld</div>';
    messageString += '<input type="button" id="messageNext" class="button" value="Weiter"></input>';

    message.innerHtml = messageString;
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
      String css = "ship";
      Ship s = f.entity;
      css += s.vertical ? "_vertical" : "_horizontal";
      css += s.fields.first == f ? "_front" : s.fields.last == f ? "_back" : "";
      css += f.hit ? "_hit" : "";
      return css;
    }
    if (f.entity is ShipBuilder) {
      String css = "shipbuilder";
      ShipBuilder sb = f.entity;
      switch (sb.fields.indexOf(f)) {
        case 0:
          css += "_center";
          break;
        case 1:
          css += "_north";
          break;
        case 2:
          css += "_east";
          break;
        case 3:
          css += "_south";
          break;
        case 4:
          css += "_west";
      }
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
void fieldSize(){
    String w;
    String h;

    int x = window.innerHeight-1;
    double calculation = (x/(ROWCOUNT+1))-3;


    w = calculation.toString() + "px";
    h = calculation.toString() + "px";

    querySelectorAll("td").style.width = w;
    querySelectorAll("td").style.height = h;

    querySelectorAll("th").style.height = h;

    querySelector("#back").style.width = w;
    querySelector("#back").style.height = h;

}

  void showGame() {
    querySelector("#menu").style.display="none";
    querySelector("#gameTable").style.display="block";
    querySelector("#gameover").style.display="none";
    querySelector("#message").style.display="none";
  }

  void showMenu() {
    querySelector("#menu").style.display="block";
    querySelector("#gameTable").style.display="none";
    querySelector("#gameover").style.display="none";
    querySelector("#message").style.display="none";
  }

  void showGameover(){
    querySelector("#menu").style.display="none";
    querySelector("#gameTable").style.display="block";
    querySelector("#gameover").style.display="block";
    querySelector("#message").style.display="none";
  }

  void showMessage(){
    querySelector("#menu").style.display="none";
    querySelector("#gameTable").style.display="block";
    querySelector("#message").style.display="block";
    querySelector("#gameover").style.display="none";
  }

  void setGameoverText(String s) {
    querySelector('#gameoverText').innerHtml = s;
  }

  void setInGameText(String s) {
    querySelector('#text').innerHtml = s;
  }
}
