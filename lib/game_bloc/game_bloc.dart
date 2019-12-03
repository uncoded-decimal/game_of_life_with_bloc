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
    } else if (event is NextPressed) {
      yield* _calculateNext(event.map);
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

  ///Calculates the next state the 2-D plot will achieve
  Stream<GameState> _calculateNext(Map<Rect, bool> map) async* {
    Map<Rect, bool> nextState = {};

    map.forEach((cell, cellAlive) {
      //The starting vertex of the rect
      final currentRectOffset = cell.topLeft;

      final topLeftCell = map.keys
          .where((testRect) =>
              testRect.topLeft ==
              (currentRectOffset -
                  Offset(
                    (Constants.cellSpace + Constants.cellHeight),
                    (Constants.cellSpace + Constants.cellWidth),
                  )))
          .single;

      final topCenterCell = map.keys
          .where((testRect) =>
              testRect.topLeft ==
              (currentRectOffset -
                  Offset(
                    (Constants.cellSpace + Constants.cellHeight),
                    0,
                  )))
          .single;

      final topRightCell = map.keys
          .where((testRect) =>
              testRect.topLeft ==
              (currentRectOffset -
                  Offset(
                    (Constants.cellSpace + Constants.cellHeight),
                    -(Constants.cellSpace + Constants.cellWidth),
                  )))
          .single;

      final centerLeftCell = map.keys
          .where((testRect) =>
              testRect.topLeft ==
              (currentRectOffset -
                  Offset(
                    0,
                    (Constants.cellSpace + Constants.cellWidth),
                  )))
          .single;

      final centerRightCell = map.keys
          .where((testRect) =>
              testRect.topLeft ==
              (currentRectOffset -
                  Offset(
                    0,
                    -(Constants.cellSpace + Constants.cellWidth),
                  )))
          .single;

      final bottomLeftCell = map.keys
          .where((testRect) =>
              testRect.topLeft ==
              (currentRectOffset -
                  Offset(
                    -(Constants.cellSpace + Constants.cellHeight),
                    (Constants.cellSpace + Constants.cellWidth),
                  )))
          .single;

      final bottomCenterCell = map.keys
          .where((testRect) =>
              testRect.topLeft ==
              (currentRectOffset -
                  Offset(
                    -(Constants.cellSpace + Constants.cellHeight),
                    0,
                  )))
          .single;

      final bottomRightCell = map.keys
          .where((testRect) =>
              testRect.topLeft ==
              (currentRectOffset -
                  Offset(
                    -(Constants.cellSpace + Constants.cellHeight),
                    -(Constants.cellSpace + Constants.cellWidth),
                  )))
          .single;

      final neighbours = [
        topLeftCell,
        topCenterCell,
        topRightCell,
        centerLeftCell,
        centerRightCell,
        bottomLeftCell,
        bottomCenterCell,
        bottomRightCell
      ];

      int aliveNeighboursCount = 0;

      for (Rect neighbourCell in neighbours) {
        if (map[neighbourCell]) {
          aliveNeighboursCount++;
        }
      }

      if (aliveNeighboursCount < 2 && cellAlive) {
        nextState[cell] = false; //cell dies due to underpopulation
      } else if (aliveNeighboursCount > 3 && cellAlive) {
        nextState[cell] = false; //cell dies due to overpopulation
      } else if (aliveNeighboursCount == 3 && !cellAlive) {
        nextState[cell] =
            true; //cell becomes alive because of optimal condition
      } else {
        nextState[cell] =
            cellAlive; //cell remains alive or dead because its neighbours haven't changed
      }
    });

    if(nextState == purgatory){
      yield GameEnd(message: 'Same State');
    } else {
      purgatory = nextState;
      yield NextState();
    }
  }
}
