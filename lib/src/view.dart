part of warships;

/**
 * The GameView is responsible for manipulating the DOM-Tree. It offers a variety
 * of methods, for example to update the game table, or set the text s for the textfields.
 */
class GameView {
  /**
   * the menu element of the html page
   */
  final menu = querySelector("#menu");

  /**
   * the html's game over screen
   */
  final gameover = querySelector("#gameover");

  /**
   * the html's game table
   */
  final gameTable = querySelector("#gameTable");

  /**
   * the html's in game message
   */
  final message = querySelector("#message");

  /**
   * the device
   */
  final device = querySelector("#device");

  /**
   * the animated message
   */
  final animatedMesage = querySelector("#animatedmessage");

  /**
   * the instructions
   */
  final instruction = querySelector("#instruction");

  /**
   * a list containing every cell of the game table
   */
  List<List<HtmlElement>> fields;

  /**
   * Generats html for the playing field screen
   * Creats a List in a List which contains HtmlElements
   * @param playingField current state of the game
   */
  void generateField(PlayingField playingField) {
    int text = playingField.colCount - 1;
    String table = "<tbody><tr><th colspan='$text' id='text'></th> <th id='back' class='back'></th></tr>";
    for (int row = 0; row < playingField.rowCount; row++) {
      table += "<tr>";
      for (int col = 0; col < playingField[row].length; col++) {
        var terrain = playingField[row][col].entity;
        var position = "field_${row}_${col}";
        var positiondiv = "d_${row}_${col}";
        table += "<td id ='${position}' class='${cssClass(playingField[row][col])}'><div id='${positiondiv}'></div></td>";
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

  /**
   * Generats html for the device screen
   * The screen conatins a button, which is not used yet
   */
  void generateDevice(){
    device.innerHtml = "<input type='button' id='deviceButton' value='Ignore'></input>";
  }

  /**
   * Generats html for the menu
   * The menu contains nine levels, a random level selector and a fullscreen button
   */
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
    }
    menuString +=
    '<input type="button" id="level_$counter" class="button" value="Level $counter"></input>';
    menuString += '<input type="button" id="zufall" class="button" value="Random"></input>';
    menuString += '<input type="button" id="instructionButton" value="Instruction"></input>';
    menuString += '<input type="button" id="fullscreenbutton" class="fullscreen"></input>';
    menuString += '<div id="fullscreendiv" class="fullscreen"></div>';

    menu.innerHtml = menuString;
  }
  /**
   * Generats html for the gameover screen
   * The screen contains a button for the menu, if the player won, a next level button, else a restart button
   */
  void generateGameoverscreen() {
    String gameoverString;
    gameoverString = '<div id="gameoverText"></div><br>';
    gameoverString += '<input type="button" id="menuGameover" class="button" value="Menu"></input> <br>';
    gameoverString += '<input type="button" id="nextGameover" class="button" value="Next Game"></input>';
    gameoverString += '<input type="button" id="restartGameover" class="button" value="Restart"></input>';
    gameover.innerHtml = gameoverString;
  }

  /**
   * Generats html for the message screen
   * The screen contains informations about the round, enemy and player ship count and how difficult it is
   */
  void generateMessage() {
    String messageString;
    messageString = '<div id="messageBox">';
    messageString += '<div id="messageLevel"></div>';
    messageString += '<div id="messageText">Place your ships in the lower field and watch out for islands, they look like ships when hit.</div>';
    messageString += '<div id="match"><div id="player">Player</div><div id="vs">VS</div><div id="enemyplayer"></div>';
    messageString += '<div id="playerside"><div id="playerdestroyer"><div id="pdpicture"></div><div id="pdcount"></div></div>'
        '<div id="playersubmarine"><div id="pspicture"></div><div id="pscount"></div></div>'
        '<div id="playerbattleship"><div id="pbpicture"></div><div id="pbcount"></div></div>'
        '<div id="playercarrier"><div id="pcpicture"></div><div id="pccount"></div></div></div>';
    messageString += '<div id="enemyside"><div id="enemydestroyer"><div id="edpicture"></div><div id="edcount"></div></div>'
        '<div id="enemysubmarine"><div id="espicture"></div><div id="escount"></div></div>'
        '<div id="enemybattleship"><div id="ebpicture"></div><div id="ebcount"></div></div>'
        '<div id="enemycarrier"><div id="ecpicture"></div><div id="eccount"></div></div></div></div>';
    messageString += '<input type="button" id="messageNext" class="button" value="Play"></input>';
    messageString += '</div>';

    message.innerHtml = messageString;
  }

  /**
   * Generates a div for an animated message, not used yet
   */
  void generateAnimatedMessage(){
    animatedMesage.innerHtml = '<div id="animatedmessagetext">Ship sunk</div>';
  }

  /**
   * generates the instructions for the game
   */
  void generateInstruction(){
    String instructionString = "";
    instructionString += '<div id="headInstruction"></div>';
    instructionString += '<div id="pictureInstruction"></div>';
    instructionString += '<div id="messageInstruction"></div>';
    instructionString += '<input type="button" id="nextInstruction1" class="nextIns" value="Next"></input>';
    instructionString += '<input type="button" id="nextInstruction2" class="nextIns" value="Next"></input>';
    instructionString += '<input type="button" id="nextInstruction3" class="nextIns" value="Next"></input>';
    instructionString += '<input type="button" id="nextInstruction4" class="nextIns" value="Next"></input>';
    instructionString += '<input type="button" id="backInstruction" class="button" value="Back"></input>';
    instruction.innerHtml = instructionString;
  }

  /**
   * update DOM tree
   * @param playingFiled current state of the game
   */
  void update(PlayingField playingField) {
    for (int row = 0; row < fields.length; row++) {
      for (int col = 0; col < fields[row].length; col++) {
        this.fields[row][col].attributes["class"] = cssClass(playingField[row][col]);
        querySelector("#d_${row}_${col}").attributes["class"] = animation(playingField[row][col]);
      }
    }
  }

  /**
   * This method is for the div above a Field and contains explosion animations
   * select a red or white cross
   * @param f is a Field which contains informations about hit, entitiy, fog, powerup, rock, ship, shipBuilder, shipMover
   * @returns String with class name
   */
  String animation(Field f){
    if (f.foggy && f.entity is !PowerUp) {
      return f.hit ? f.entity == null ? "animationWhite" : "animationRed" : "empty";
    }else if (f.entity == null) {
      return f.hit ? "animationWhite" : "empty";
    }else if (f.entity is Ship) {
      return f.hit ? "animationRed" : "empty";
    }else if (f.entity is ShipBuilder) {
      return "empty";
    }else if (f.entity is Rock) {
      return f.hit ? "animationRed" : "empty";
    }else if (f.entity is PowerUp) {
      return f.hit ? "animationRed" : "empty";
    }else if (f.entity is ShipMover) {
      return "empty";
    }
    return "empty";
  }

  /**
   * Select a class name for different entities
   * @param f is a Field which contains informations about hit, entitiy, fog, powerup, rock, ship, shipBuilder, shipMover
   * @returns String with class name
   */
  String cssClass(Field f) {
    if (f.foggy && f.entity is !PowerUp) {
      return "fog";
    }else if (f.entity == null) {
      return "water";
    }else if (f.entity is Ship) {
      String css = "";
      css = "ship";
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
      return r;
    }else if (f.entity is PowerUp) {
      String p = "powerup";
      p += f.foggy ? "_fog" : "_water";
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

  /**
   * Calculate the size of td, th, back and body element with window. innerHeigtt
   */
  void fieldSize(){
    String w;
    String h;
    int x;
    double calculation;
/*
    if(window.innerHeight < window.innerWidth){
      x = window.innerWidth - 1;
      calculation = (x / (ROWCOUNT + 1)) - 3;
    }else {*/
      x = window.innerHeight - 1;
      calculation = (x / (ROWCOUNT + 1)) - 3;
    //}

    w = calculation.toString() + "px";
    h = calculation.toString() + "px";

    querySelectorAll("td").style.width = w;
    querySelectorAll("td").style.height = h;

    querySelectorAll("th").style.height = h;

    querySelector("#back").style.width = w;
    querySelector("#back").style.height = h;

    querySelector("#body").style.height = (window.innerHeight).toString() + "px";
    querySelector("#device").style.height = (window.innerHeight).toString() + "px";
    menu.style.height = (window.innerHeight).toString() + "px";


    double d = 0.0;
    for(int p = 0; p < COLCOUNT; p++){
      d += calculation+3;
    }
    querySelector("tbody").style.width = d.toString() + "px";

  }

  /**
   * Change display mode to show the playing field
   */
  void showGame() {
    menu.style.display="none";
    gameTable.style.display="block";
    gameover.style.display="none";
    message.style.display="none";
    instruction.style.display="none";
  }

  /**
   * Change display mode to show the menu
   */
  void showMenu() {
    menu.style.display="block";
    gameTable.style.display="none";
    gameover.style.display="none";
    message.style.display="none";
    instruction.style.display="none";
  }

  /**
   * Change display mode to show the playing field and the gameover screen
   */
  void showGameover(){
    menu.style.display="none";
    gameTable.style.display="block";
    gameover.style.display="block";
    message.style.display="none";
    instruction.style.display="none";
  }

  /**
   * Change display mode to show the playing field and the message screen
   */
  void showMessage(){
    menu.style.display="none";
    gameTable.style.display="block";
    message.style.display="block";
    gameover.style.display="none";
    instruction.style.display="none";
  }

  /**
   * Change display mode to show the animated message
   */
  void showAnimatedMessage(){
    animatedMesage.style.display="block";
  }

  /**
   * Change display mode to hide the animated message
   */
  void hideAnimatedMessage(){
    animatedMesage.style.display="none";
  }

  /**
   * Change display mode to show the instruction
   */
  void showInstruction(){
    menu.style.display="block";
    gameTable.style.display="none";
    gameover.style.display="none";
    message.style.display="none";
    instruction.style.display="block";
  }

  /**
   * updates the instruction page's button
   */
  void changeInstructionButton(int i){
    if(i > 1) {
      String oldButton = '#nextInstruction' + (i - 1).toString();
      querySelector(oldButton).style.display = "none";
    }
    String newButton = '#nextInstruction' + (i).toString();
    if(i < 4)querySelector(newButton).style.display = "block";
  }

  /**
   * Change display mode to hide the device screen
   */
  void hideDevice(){
    querySelector("#device").style.display="none";
  }

  /**
   * Set text for gameover message
   * @param s text for message
   */
  void setGameoverText(String s) {
    querySelector('#gameoverText').innerHtml = s;
  }

  /**
   * Set text for ingame message
   * @param s text for message
   */
  void setInGameText(String s) {
    querySelector('#text').innerHtml = s;
  }

  /**
   * Set text for level in message screen
   * @param s text for message
   */
  void setInGameLevel(String s) {
    querySelector('#messageLevel').innerHtml = s;
  }

  /**
   * Set text for AI name
   * @param s text for message
   */
  void setMessageEnemy(String s) {
    querySelector('#enemyplayer').innerHtml = s;
  }

  /**
   * Set ship count for message screen
   * @param s list which contains ship count
   */
  void setShipCount(List<String> s) {
    querySelector('#pdcount').innerHtml = s[0];
    querySelector('#pscount').innerHtml = s[1];
    querySelector('#pbcount').innerHtml = s[2];
    querySelector('#pccount').innerHtml = s[3];

    querySelector('#edcount').innerHtml = s[4];
    querySelector('#escount').innerHtml = s[5];
    querySelector('#ebcount').innerHtml = s[6];
    querySelector('#eccount').innerHtml = s[7];
  }

  /**
   * sets the texts and pictures for the instructions
   * @param object the object
   * @param picture the picture to be displayed
   * @param text the text to be displayed
   */
  void setInstruction(String object, String picture, String text){
    querySelector("#pictureInstruction").attributes["class"] = picture;
    querySelector("#messageInstruction").innerHtml = text;
    querySelector("#headInstruction").innerHtml = object;
  }

  /**
   * Make fullscreen request
   * @param i can be 0 or 1, 0 for exit fullscreen, 1 for fullscreen
   * @param element which should request for fullscreen
   */
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