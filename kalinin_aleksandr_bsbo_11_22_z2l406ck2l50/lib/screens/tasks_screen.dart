import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/bloc/task_bloc.dart';
import 'package:folding_cell/folding_cell.dart';
import 'edit_card.dart';

class CellListView extends StatefulWidget {
  @override
  _CellListViewState createState() => _CellListViewState();
}

class _CellListViewState extends State<CellListView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return Container(
          color: Color(0xFF),
          child: ListView.builder(
            itemCount: state.cards.length,
            itemBuilder: (context, index) {
              return SimpleFoldingCell.create(
                frontWidget: _buildFrontWidget(context, index),
                innerWidget: _buildInnerWidget(context, index),
                cellSize: Size(MediaQuery.of(context).size.width, 125),
                padding: EdgeInsets.all(15),
                animationDuration: Duration(milliseconds: 300),
                borderRadius: 10,
                onOpen: () => print('$index cell opened'),
                onClose: () => print('$index cell closed'),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFrontWidget(BuildContext context, int index) {
    return Builder(
      builder: (BuildContext context) {
        var card = context.read<TaskBloc>().state.cards[index];
        return Container(
          color: Color(0xFFffcd3c),
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(card.cardName),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: TextButton(
                  onPressed: () {
                    final foldingCellState =
                        context.findAncestorStateOfType<SimpleFoldingCellState>();
                    foldingCellState?.toggleFold();
                  },
                  child: Text(
                    "Показать",
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(80, 40),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildInnerWidget(BuildContext context, int index) {
    var card = context.read<TaskBloc>().state.cards[index];
    return Builder(
      builder: (context) {
        return Container(
          color: Color(0xFFecf2f9),
          padding: EdgeInsets.only(top: 10),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(card.cardName),
              ),
              Align(
                alignment: Alignment.center,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: card.tasks.length,
                  itemBuilder: (context, id) {
                    return CheckboxListTile(
                      title: Text(card.tasks[id].description),
                      value: card.tasks[id].isDone,
                      onChanged: (newValue) {
                        context
                            .read<TaskBloc>()
                            .add(UpdateTask(index, id, newValue!));
                      },
                    );
                  },
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCardPage(index: index),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      },
                      child: Text("Изменить"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(80, 40),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final foldingCellState =
                            context.findAncestorStateOfType<SimpleFoldingCellState>();
                        foldingCellState?.toggleFold();
                      },
                      child: Text(
                        "Закрыть",
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(80, 40),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
