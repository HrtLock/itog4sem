import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/bloc/task_bloc.dart';
import 'package:flutter_app/screens/main_page.dart';
import 'package:dio/dio.dart';
import 'bloc/api_bloc.dart';

import 'screens/gallery_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(),
        ),
        BlocProvider<ApiBloc>(
          create: (context) => ApiBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green, // Акцентный цвет зеленый
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // Скругление кнопок
              ),
            ),
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ApiBloc apiBloc = context.read<ApiBloc>();

    void _updateWorldTime() {
      apiBloc.updateWorldTime();
    }

    void _navigateToGallery() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GalleryPage()),
      );
    }

    void _navigateToTaskFolders() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Главная страница'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ApiBloc, String>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Рандомный факт о кошках',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  state,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateWorldTime,
                  child: Text('Обновить факт'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _navigateToGallery,
                  child: Text('Галерея с изображениями'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _navigateToTaskFolders,
                  child: Text('Папки задач'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
