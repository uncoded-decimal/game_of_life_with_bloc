import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:game_of_life/bloc_deligate.dart';
import 'package:game_of_life/game_ui/game_screen.dart';
// import 'package:flutter/foundation.dart';

void main() {
  //as an added bonus, if you're on desktop just uncomment the following
  //line and it should run just fine
  // debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}
