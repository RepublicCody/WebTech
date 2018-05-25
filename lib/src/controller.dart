part of warships;


class GameController{

  var model = new GameModel(16, 8);

  final view = new gameView();


  GameController(){
    view.generateField(model.playingField);
    view.generateMenu();


    querySelector("#gameTable").style.display="none";
    querySelector("#level_1").onClick.listen((Event e) {view.showGame();});

  }
}