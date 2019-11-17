import 'package:equatable/equatable.dart';

class GameEvent extends Equatable{
  @override
  List<Object> get props => null;

}

class Create extends GameEvent{
  final int rows;
  final int columns;
  Create(this.rows, this.columns);
}

class NextPressed extends GameEvent{}