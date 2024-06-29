import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/bloc/task_bloc.dart';
import 'package:flutter_app/models/task_model.dart';

class CreateCardPage extends StatefulWidget {
  @override
  _CreateCardPageState createState() => _CreateCardPageState();
}

class _CreateCardPageState extends State<CreateCardPage> {
  late TextEditingController _cardNameController;
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _cardNameController = TextEditingController();
    _tasks = [];
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

  void _saveCard() {
    if (_cardNameController.text.isNotEmpty && _tasks.isNotEmpty) {
      context.read<TaskBloc>().add(AddCard(
            _cardNameController.text,
            _tasks,
          ));
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка'),
          content: Text('Введите название и добавьте хотя бы одну задачу.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание карточки'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveCard,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              onPressed: _saveCard,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
