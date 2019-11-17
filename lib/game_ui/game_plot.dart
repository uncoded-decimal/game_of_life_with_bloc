import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_of_life/game_bloc/bloc.dart';

class GamePlot extends StatefulWidget {
  @override
  _GamePlotState createState() => _GamePlotState();
}

class _GamePlotState extends State<GamePlot> {
  TextEditingController _rowCount = TextEditingController();
  TextEditingController _columnCount = TextEditingController();
  int nRow, nCol;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(width: 3.0),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'How big do you want the Grid to be?',
              style: theme.textTheme.title,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              maxLength: 2,
              style: theme.textTheme.subhead,
              // decoration: InputDecoration.collapsed(
              //   hintText: 'Row Count',
              // ),
              controller: _rowCount,
            ),
            TextField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: 2,
              // decoration: InputDecoration.collapsed(hintText: 'Column Count'),
              controller: _columnCount,
              onChanged: (text) {
                setState(() {});
              },
            ),
            FlatButton(
              onPressed: isGridValid()
                  ? () {
                      print('creating universe in grid $nRow x $nCol ...');
                      BlocProvider.of<GameBloc>(context)
                          .add(Create(nRow, nCol));
                    }
                  : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Create Simulation'),
                  Icon(Icons.arrow_forward)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isGridValid() {
    String col = _columnCount.value.text;
    String row = _rowCount.value.text;
    if (isNotEmpty(col) && isNotEmpty(row)) {
      nCol = int.parse(col);
      nRow = int.parse(col);
      if ((nCol > 0) && (nRow > 0)) {
        return true;
      } else
        return false;
    } else
      return false;
  }
}
