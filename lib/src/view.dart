part of warships;

class gameView {
  final menu = querySelector("#menu");

  final gameover = querySelector("#gameover");

  final gameTable = querySelector("#gameTable");

  List<List<HtmlElement>> fields;

  /*
  void generateField(PlayingField playingField) {
    //  final field = model.field;
    List<List<Field>> field = playingField.fields;
    int enemy;
    if (row.isEven) {
      enemy = (row / 2).toInt();
    } else {
      enemy = ((row + 1) / 2).toInt();
    }

    String table = "";
    int colAnzeige = column - 1;
    table +=
        "<tr> <th colspan='$colAnzeige' id='anzeige'></th> <th id='back'></th></tr>";
    for (int xrow = 0; xrow < row; xrow++) {
      if (enemy > 0) {
        table += "<tr id='enemy'>";
        enemy--;
      } else {
        table += "<tr id='player'>";
      }
      for (int ycol = 0; ycol < column; ycol++) {
        final pos = "field_${xrow}_${ycol}";
        table += "<td id='$pos' class='field'></td>";
      }
      table += "</tr>";
    }
    gameTable.innerHtml = table;

    fields = new List<List<HtmlElement>>(row);
    for (int c = 0; c < row; c++) {
      fields[c] = [];
      for (int d = 0; d < column; d++) {
        fields[c].add(gameTable.querySelector("#field_${c}_${d}"));
      }
    }
  }
  */


  void generateField(PlayingField playingField) {
    List<List<Field>> tiles = playingField.fields;
    int text = tiles[0].length - 1;
    String table = "<tbody><tr><th colspan='$text' id='text'></th> <th id='back' class='back'></th></tr>";
    for (int row = 0; row < tiles.length; row++) {
      table += "<tr>";        //Ich wäre dafür tr noch die class enemy und player zu geben, zumindest kann ich mir gut vorstellen, dass man damit später beim Schiffe platzieren leichtes Spiel hat
      for (int col = 0; col < tiles[row].length; col++) {
        var terrain = tiles[row][col].entity;
        var position = "field_${row}_${col}";
        table += "<td id ='${position}' class='${terrain}'></td>";
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

  void showGame() {
    querySelector("#menu").style.display="none";
    querySelector("#gameTable").style.display="block";
  }

  void showMenu() {
    querySelector("#menu").style.display="block";
    querySelector("#gameTable").style.display="none";
  }


}
