import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskEvent {}

class LoadTasks extends TaskEvent {}

class UpdateTask extends TaskEvent {
  final int cardIndex;
  final int taskIndex;
  final bool isDone;

  UpdateTask(this.cardIndex, this.taskIndex, this.isDone);
}

class EditCard extends TaskEvent {
  final int cardIndex;
  final String cardName;
  final List<Task> tasks;

  EditCard(this.cardIndex, this.cardName, this.tasks);
}

class AddCard extends TaskEvent {
  final String cardName;
  final List<Task> tasks;

  AddCard(this.cardName, this.tasks);

  @override
  List<Object?> get props => [cardName, tasks];
}

class DeleteCard extends TaskEvent {
  final int cardIndex;

  DeleteCard(this.cardIndex);

  @override
  List<Object?> get props => [cardIndex];
}

class TaskState {
  List<Card> cards;

  TaskState(this.cards);
}

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskState([])) {
    on<LoadTasks>(_onLoadTasks);
    on<UpdateTask>(_onUpdateTask);
    on<EditCard>(_onEditCard);
    on<AddCard>(_onAddCard);
    on<DeleteCard>(_onDeleteCard);

    _loadInitialData().then((cards) {
      add(LoadTasks());
    });
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    final cards = await _loadInitialData();
    emit(TaskState(cards));
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    var cards = List<Card>.from(state.cards);
    cards[event.cardIndex].tasks[event.taskIndex].isDone = event.isDone;
    await _saveToStorage(cards);
    emit(TaskState(cards));
  }

  Future<void> _onEditCard(EditCard event, Emitter<TaskState> emit) async {
    var cards = List<Card>.from(state.cards);
    cards[event.cardIndex] = Card(
      cardName: event.cardName,
      cardId: cards[event.cardIndex].cardId,
      tasks: event.tasks,
    );
    await _saveToStorage(cards);
    emit(TaskState(cards));
  }

  Future<void> _onAddCard(AddCard event, Emitter<TaskState> emit) async {
    var cards = List<Card>.from(state.cards);
    int newCardId = cards.isEmpty ? 1 : cards.last.cardId + 1;
    cards.add(Card(
      cardName: event.cardName,
      cardId: newCardId,
      tasks: event.tasks,
    ));
    await _saveToStorage(cards);
    emit(TaskState(cards));
  }

  Future<void> _onDeleteCard(DeleteCard event, Emitter<TaskState> emit) async {
    var cards = List<Card>.from(state.cards);
    cards.removeAt(event.cardIndex);
    await _saveToStorage(cards);
    emit(TaskState(cards));
  }

  Future<List<Card>> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cards');
    if (jsonString != null) {
      List<dynamic> decodedJson = json.decode(jsonString);
      return decodedJson.map((json) => Card.fromJson(json)).toList();
    } else {
      return [
        Card(
          cardName: 'folderName',
          cardId: 1,
          tasks: [
            Task(description: 'desc', isDone: true),
            Task(description: 'desc1', isDone: false),
            Task(description: 'desc2', isDone: false),
          ],
        ),
      ];
    }
  }

  Future<void> _saveToStorage(List<Card> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(cards.map((card) => card.toJson()).toList());
    await prefs.setString('cards', jsonString);
  }
}
