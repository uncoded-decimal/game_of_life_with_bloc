import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_of_life/constants.dart';
import 'package:game_of_life/game_bloc/bloc.dart';
import 'package:game_of_life/game_ui/game_painter.dart';

class GameInputScreen extends StatefulWidget {
  @override
  _GameInputScreenState createState() => _GameInputScreenState();
}

class _GameInputScreenState extends State<GameInputScreen> {
  Map<Rect, bool> _cells = {};
  GameBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<GameBloc>(context);
    _calculateRects();
  }

  ///builds boxes from the [positions] obtained
  ///from the bloc
  void _calculateRects() {
    bloc.positions.forEach((position) {
      //construct a Rect and then add it to the map
      final rect = Rect.fromLTWH(position.dx + 20, position.dy + 20,
          Constants.cellWidth, Constants.cellHeight);
      _cells[rect] = false;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: size.width - 20,
              constraints: BoxConstraints(
                  minHeight: size.height / 2, maxHeight: size.height - 100),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: 5.0, color: Colors.blue)),
              foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: 5.0, color: Colors.blue)),
              child: GestureDetector(
                onTapDown: (tapDetails) => _onSelect(tapDetails),
                child: CustomPaint(
                  size: Size(
                    bloc.rowCount * Constants.cellWidth +
                        (bloc.rowCount - 1) * Constants.cellSpace +
                        40,
                    bloc.columnCount * Constants.cellHeight +
                        (bloc.columnCount - 1) * Constants.cellSpace +
                        40,
                  ),
                  painter: GamePainter(map: _cells),
                  willChange: true,
                ),
              ),
            ),
          ),
          _buttonBar()
        ],
      ),
    );
  }

  //redraw the entire widget because a cell state has
  //been changed
  void _onSelect(TapDownDetails tapDetails) {
    //iterates through [_cells]' [keys] to check which [RenderBox]
    //laid surrounds the tapped point and returns the appropriate Rect
    final box = _cells.keys
        // .toList()
        .lastWhere((localRect) => localRect.contains(tapDetails.localPosition),
            orElse: () => null);
    //one-tap to add cell to alive list
    //another to remove it
    setState(() {
      _cells.update(box, (x) => !x);
    });
  }

  Widget _buttonBar() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () => bloc.add(StopGame()),
            heroTag: 'back_button',
            child: Icon(Icons.stop),
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: () => bloc.add(NextPressed(_cells)),
            heroTag: 'next_button',
            child: Icon(Icons.navigate_next),
          ),
        ],
      );
}
