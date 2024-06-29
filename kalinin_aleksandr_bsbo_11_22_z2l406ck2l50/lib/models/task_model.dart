import 'dart:convert';

class Task {
  String description;
  bool isDone;

  Task({
    required this.description,
    this.isDone = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      description: json['description'],
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'isDone': isDone,
    };
  }
}

class Card {
  final String cardName;
  final int cardId;
  final List<Task> tasks;

  Card({
    required this.cardName,
    required this.cardId,
    required this.tasks,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    var tasksList = json['tasks'] as List<dynamic>;
    List<Task> tasks =
        tasksList.map((taskJson) => Task.fromJson(taskJson)).toList();

    return Card(
      cardName: json['card'],
      cardId: json['cardId'],
      tasks: tasks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card': cardName,
      'cardId': cardId,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }
}