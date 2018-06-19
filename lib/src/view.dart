part of warships;

class GameView {
  final menu = querySelector("#menu");

  final gameover = querySelector("#gameover");

  final gameTable = querySelector("#gameTable");

  final message = querySelector("#message");

  List<List<HtmlElement>> fields;

  void generateField(PlayingField playingField) {
    //List<List<Field>> tiles = playingField.fields;
    int text = playingField.colCount - 1;
    String table = "<tbody><tr><th colspan='$text' id='text'></th> <th id='back' class='back'></th></tr>";
    for (int row = 0; row < playingField.rowCount; row++) {
      table += "<tr>";
      for (int col = 0; col < playingField[row].length; col++) {
        var terrain = playingField[row][col].entity;
        var position = "field_${row}_${col}";
        table += "<td id ='${position}' class='${cssClass(playingField[row][col])}'></td>";
      }
      table += "</tr>";
    }
    table += "</tbody>";
    gameTable.innerHtml = table;
    fieldSize();

    fields = new List<List<HtmlElement>>(playingField.rowCount);
    for (int row = 0; row < playingField.rowCount; row++) {
      fields[row] = new List<HtmlElement>();
      for(int col = 0; col < playingField[row].length; col++) {
        fields[row].add(querySelector("#field_${row}_${col}"));
      }
    }
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
    menuString += '<input type="button" id="zufall" class="button" value="Random"></input>';

    menu.innerHtml = menuString;
  }

  void generateGameoverscreen() {
    String gameoverString;
    gameoverString = '<div id="gameoverText"></div><br>';
    gameoverString += '<input type="button" id="menuGameover" class="button" value="Menu"></input> <br>';
    gameoverString += '<input type="button" id="nextGameover" class="button" value="Next Game"></input>';
    gameoverString += '<input type="button" id="restartGameover" class="button" value="Restart"></input>';
    gameover.innerHtml = gameoverString;
  }

  void generateMessage() {
    String messageString;
    messageString = '<div id="messageBox">';
    messageString += '<div id="messageLevel"></div>';
    messageString += '<div id="messageText">Place your ships in the lower field and take care of islands, they may look like ships</div>';
    messageString += '<input type="button" id="messageNext" class="button" value="Play"></input>';
    messageString += '</div>';

    message.innerHtml = messageString;
  }

  void update(PlayingField playingField) {
    //List<List<Field>> tiles = playingField.fields;
    for (int row = 0; row < fields.length; row++) {
      for (int col = 0; col < fields[row].length; col++) {
        this.fields[row][col].attributes["class"] = cssClass(playingField[row][col]);
      }
    }
  }

  String cssClass(Field f) {
    if (f.foggy && f.entity is !PowerUp) {
      return f.hit ? f.entity == null ? "fog_miss" : "fog_hit" : "fog";
    }else if (f.entity == null) {
      return f.hit ? "water_miss" : "water";
    }else if (f.entity is Ship) {
      String css = "ship";
      Ship s = f.entity;
      if(f.entity is Destroyer && s.vertical == false){//Horizontal
        css += "_2";
        css += s.vertical ? "_vertical" : "_horizontal";
        css += s.fields.last == f ? "_front" : s.fields.first == f ? "_back" : "_middel";
      }else if(f.entity is Destroyer && s.vertical == true){//Vertikal
        css += "_2";
        css += s.vertical ? "_vertical" : "_horizontal";
        css += s.fields.first == f ? "_front" : s.fields.last == f ? "_back" : "_middel";
      }else if(f.entity is Submarine && s.vertical == false){//Horizontal
        css += "_3";
        css += s.vertical ? "_vertical" : "_horizontal";
        css += s.fields.last == f ? "_front" : s.fields.first == f ? "_back" : "_middel";
      }else if(f.entity is Submarine && s.vertical == true){//Vertiakl
        css += "_3";
        css += s.vertical ? "_vertical" : "_horizontal";
        css += s.fields.first == f ? "_front" : s.fields.last == f ? "_back" : "_middel";
      }else if(f.entity is BattleShip && s.vertical == false){//Vertikal
        css += "_4";
        css += s.vertical ? "_vertical" : "_horizontal";
        css += s.fields.last == f ? "_front" : s.fields.first == f ? "_back" : "_middel";
        if(s.fields[1] == f){
          css += "_1";
        }else if(s.fields[2] == f){
          css += "_2";
        }
      }else if(f.entity is BattleShip && s.vertical == true) {//Horizontal
        css += "_4";
        css += s.vertical ? "_vertical" : "_horizontal";
        css += s.fields.first == f ? "_front" : s.fields.last == f
            ? "_back"
            : "_middel";
        if (s.fields[1] == f) {
          css += "_2";
        } else if (s.fields[2] == f) {
          css += "_1";
        }
      }else if(f.entity is Carrier && s.vertical == false){//Vertikal
        css += "_5";
        css += s.vertical ? "_vertical" : "_horizontal";
        css += s.fields.last == f ? "_front" : s.fields.first == f ? "_back" : "_middel";
        if(s.fields[1] == f){
          css += "_1";
        }else if(s.fields[2] == f){
          css += "_2";
        }else if(s.fields[3] == f){
          css += "_3";
        }
      }else if(f.entity is Carrier && s.vertical == true){//Horizontal
        css += "_5";
        css += s.vertical ? "_vertical" : "_horizontal";
        css += s.fields.first == f ? "_front" : s.fields.last == f ? "_back" : "_middel";
        if(s.fields[1] == f){
          css += "_3";
        }else if(s.fields[2] == f){
          css += "_2";
        }else if(s.fields[3] == f){
          css += "_1";
        }
      }

      css += f.hit ? "_hit" : "";
      return css;
    }else if (f.entity is ShipBuilder) {
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
    }else if (f.entity is Rock) {
      String r = "rock";
      if(f._row.isEven && f._col.isEven)r += "_1";
      if(f._row.isOdd && f._col.isEven || f._row.isEven && f._col.isOdd)r += "_2";
      if(f._row.isOdd && f._col.isOdd)r += "_3";
      r += f.hit ? "_hit" : "";
      return r;
    }else if (f.entity is PowerUp) {
      String p = "powerup";
      p += f.foggy ? "_fog" : "_water";
      p += f._hit ? "_hit" : "";
      print(p);
      return p;
    }else if (f.entity is ShipMover) {
      ShipMover m = f.entity;
      if (m.fields.indexOf(f) == 0) {
        return m.ship.vertical ? "shipbuilder_north" : "shipbuilder_west";
      } else {
        return m.ship.vertical ? "shipbuilder_south" : "shipbuilder_east";
      }
    }
    return "";
  }

  void fieldSize(){
    String w;
    String h;
    int x;
    double calculation;

    if(window.innerHeight < window.innerWidth){
      x = window.innerWidth - 1;
      calculation = (x / (ROWCOUNT + 1)) - 3;
    }else {
      x = window.innerHeight - 1;
      calculation = (x / (ROWCOUNT + 1)) - 3;
    }

    w = calculation.toString() + "px";
    h = calculation.toString() + "px";

    querySelectorAll("td").style.width = w;
    querySelectorAll("td").style.height = h;

    querySelectorAll("th").style.height = h;

    querySelector("#back").style.width = w;
    querySelector("#back").style.height = h;

    double d = 0.0;
    for(int p = 0; p < COLCOUNT; p++){
      d += calculation+3;
    }
    querySelector("tbody").style.width = d.toString() + "px";

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

  void setInGameLevel(String s) {
    querySelector('#messageLevel').innerHtml = s;
  }

  void fullscreenWorkaround(Element element) {
    var elem = new JsObject.fromBrowserObject(element);

    if (elem.hasProperty("requestFullscreen")) {
      elem.callMethod("requestFullscreen");
    }
    else {
      List<String> vendors = ['moz', 'webkit', 'ms', 'o'];
      for (String vendor in vendors) {
        String vendorFullscreen = "${vendor}RequestFullscreen";
        if (vendor == 'moz') {
          vendorFullscreen = "${vendor}RequestFullScreen";
        }
        if (elem.hasProperty(vendorFullscreen)) {
          elem.callMethod(vendorFullscreen);
          return;
        }
      }
    }
  }
}
