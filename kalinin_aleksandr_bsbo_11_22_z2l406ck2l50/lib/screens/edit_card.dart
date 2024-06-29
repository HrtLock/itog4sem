import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/bloc/task_bloc.dart';
import 'package:flutter_app/models/task_model.dart';

class EditCardPage extends StatefulWidget {
  final int index;

  EditCardPage({required this.index});

  @override
  _EditCardPageState createState() => _EditCardPageState();
}

class _EditCardPageState extends State<EditCardPage> {
  late TextEditingController _cardNameController;
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    var card = context.read<TaskBloc>().state.cards[widget.index];
    _cardNameController = TextEditingController(text: card.cardName);
    _tasks = List<Task>.from(card.tasks);
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    super.dispose();
  }

  void _addTask() {
    setState(() {
      _tasks.add(Task(description: '', isDone: false));
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _saveChanges() {
    context.read<TaskBloc>().add(EditCard(
          widget.index,
          _cardNameController.text,
          _tasks,
        ));
    Navigator.pop(context);
  }

  void _confirmDeleteCard() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подтверждение удаления'),
        content: Text('Вы уверены, что хотите удалить эту карточку?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCard();
            },
            child: Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _deleteCard() {
    context.read<TaskBloc>().add(DeleteCard(widget.index));
    Navigator.pop(context); // Go back to the previous screen after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактирование карточки'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _confirmDeleteCard,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cardNameController,
              decoration: InputDecoration(labelText: 'Название карточки'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: TextField(
                      controller: TextEditingController(
                          text: _tasks[index].description),
                      decoration: InputDecoration(labelText: 'Описание задачи'),
                      onChanged: (value) {
                        _tasks[index].description = value;
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeTask(index),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Добавить задачу'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
