import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:game_of_life/constants.dart';
import 'package:game_of_life/game_bloc/bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  int rows, columns;
  List<Offset> listOfPositions = [];
  Map<Rect, bool> purgatory = {};

  List<Offset> get positions => listOfPositions;
  int get rowCount => rows;
  int get columnCount => columns;

  int generationCount;

  @override
  GameState get initialState => GetGameConfig();

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    if (event is Create) {
      rows = event.rows;
      columns = event.columns;
      generationCount = 0;
      yield* _calculateMap();
    } else if (event is StopGame) {
      yield GetGameConfig();
    } else if (event is NextPressed){
      yield* _calculateNext();
    }
  }

  Stream<GameState> _calculateMap() async* {
    //loop for each row
    for (int i = 0; i < rows; i++) {
      //loop for each column
      for (int j = 0; j < columns; j++) {
        final posX = j * (Constants.cellWidth + Constants.cellSpace);
        final posY = i * (Constants.cellHeight + Constants.cellSpace);
        listOfPositions.add(Offset(posX, posY));
      }
    }
    yield GetStartCondition();
  }

  Stream<GameState> _calculateNext() async* {
    //TODO: Implement the logic
  }
}
