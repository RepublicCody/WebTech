part of warships;


class gameController{

  var game = new gamePlay(row, column);

  final view = new gameView();


  gameController(){
    view.generateField();
    view.generateMenu();


    querySelector("#gameTable").style.display="none";
    querySelector("#level_1").onClick.listen(view.changeVisability);

  }
}