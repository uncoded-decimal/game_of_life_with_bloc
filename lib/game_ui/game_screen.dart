import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_of_life/game_bloc/bloc.dart';
import 'package:game_of_life/game_ui/game_ui.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameBloc>(
      builder: (context) => GameBloc(),
      child: Scaffold(
        backgroundColor: Colors.cyan,
        body: BlocBuilder<GameBloc, GameState>(
          builder: (BuildContext context, GameState state) {
            if (state is GetGameConfig)
              return GamePlot();
            else if (state is GetStartCondition)
              return GameInputScreen();
            else
              return Container(
                color: Colors.blue,
              );
          },
        ),
      ),
    );
  }
}
