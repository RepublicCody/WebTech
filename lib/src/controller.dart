part of warships;


class gameController{

  var game = new gamePlay(row, column);

  final view = new gameView();


  gameController(){
    view.generateField();
  }
}