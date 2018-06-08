import 'package:WebTech/dartwarships.dart';

void main() {
  //var game = new GameController();
  var model = new GameModel();
  model.generatePlayingField(1);
  model.loadLevel(1);
}