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

}
