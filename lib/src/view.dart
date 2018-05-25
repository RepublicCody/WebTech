part of warships;

class gameView {
  final menu = querySelector("#menu");

  final gameover = querySelector("#gameover");

  final gameTable = querySelector("#gameTable");

  List<List<HtmlElement>> fields;

  void generateField() {
    //  final field = model.field;
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
        // final assignment = field[xrow][ycol];
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

  void generateMenu() {
    String menuString;

    menuString = '<div id="menu_head">Warships Menu</div><br>';

    for (int x = 1; x < 5; x++) {
      menuString +=
          '<input type="button" id="level_$x" value="Level $x"></input> <br>';
    }
    menuString += '<input type="button" id="zufall" value="Zufall"></input>';

    menu.innerHtml = menuString;
  }

  void changeVisability(Event e){

    querySelector("#menu").style.display="none";
    querySelector("#gameTable").style.display="block";
  }


}
