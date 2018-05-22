part of warships;

class gameView{

  final menu = querySelector("#menu");

  final gameover = querySelector("#gameover");

  final gameTable = querySelector("#gameTable");

//  List<List<HtmlElement>> fields;

  void generateField(){
    //  final field = model.field;
    String table = "";
    int colAnzeige = column -1;
    table += "<tr> <th colspan='$colAnzeige' id='anzeige'></th> <th id='back'></th></tr>";
    for (int xrow = 0; xrow < row; xrow++) {
      table += "<tr id='player'>";
      for (int ycol = 0; ycol < column; ycol++) {
        // final assignment = field[xrow][ycol];
        final pos = "field_${xrow}_${ycol}";
        table += "<td id='$pos' class='field'></td>";
      }
      table += "</tr>";
    }

/*
    // Saves all generated TD elements in field to
    // avoid time intensive querySelector calls in update().
    // Thanks to Johannes Gosch, SoSe 2015.
    fields = new List<List<HtmlElement>>(field.length);
    for (int row = 0; row < field.length; row++) {
      fields[row] = [];
      for (int col = 0; col < field[row].length; col++) {
        fields[row].add(gameTable.querySelector("#field_${row}_${col}"));
      }
    }*/

    gameTable.innerHtml = table;
  }





}
