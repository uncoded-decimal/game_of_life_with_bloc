import 'package:equatable/equatable.dart';

class GameState extends Equatable {
  @override
  List<Object> get props => null;
}

class GetGameConfig extends GameState {}

class GetStartCondition extends GameState {
  GetStartCondition();
}

class NextState extends GameState {}

class GameEnd extends GameState {
  final String message;
  GameEnd({this.message});
}
