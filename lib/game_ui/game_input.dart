import 'package:bidirectional_scroll_view/bidirectional_scroll_view.dart';
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
      final rect = Rect.fromLTWH(
          position.dx, position.dy, Constants.cellWidth, Constants.cellHeight);
      _cells[rect] = false;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 30),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(width: 5.0, color: Colors.blue)),
        foregroundDecoration: BoxDecoration(
            // color: Colors.yellow,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(width: 5.0, color: Colors.blue)),
        child: BidirectionalScrollViewPlugin(
          scrollOverflow: Overflow.clip,
          child: GestureDetector(
            onTapDown: (tapDetails) {
              //Get the [RenderBox] for the part of screen
              //available for tapping
              RenderBox boxscreen = context.findRenderObject();
              //From [tapDetails] get the global position of tap
              //and convert it to get the local position inside
              //the [RenderBox]
              final offset = boxscreen.globalToLocal(tapDetails.globalPosition);
              //iterates through [_cells]' [keys] to check which [RenderBox]
              //laid surrounds the tapped point and returns
              //its index
              final box = _cells.keys.toList().lastWhere(
                  (localRect) => localRect.contains(offset),
                  orElse: () => null);
              _onSelect(box);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomPaint(
                size: Size(
                  bloc.rowCount * Constants.cellWidth +
                      (bloc.rowCount - 1) * Constants.cellSpace,
                  bloc.columnCount * Constants.cellHeight +
                      (bloc.columnCount - 1) * Constants.cellSpace,
                ),
                painter: GamePainter(map: _cells),
                willChange: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //redraw the entire widget because a cell state has
  //been changed
  void _onSelect(Rect box) =>
      //one-tap to add cell to alive list
      //another to remove it
      setState(() {
        _cells.update(box, (x) => !x);
      });

  @override
  void dispose() {
    //closing the bloc is necessary to avoid memory leaks
    bloc.close();
    super.dispose();
  }
}
