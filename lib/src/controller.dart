part of warships;


class gameController{

  var model = new GameModel();

  final view = new gameView();


  gameController(){
    view.generateField();
    view.generateMenu();


    querySelector("#gameTable").style.display="none";
    querySelector("#level_1").onClick.listen(view.changeVisability);

  }
}