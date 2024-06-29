import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class ApiBloc extends Cubit<String> {
  final Dio _dio = Dio();

  ApiBloc() : super('');

  Future<void> updateWorldTime() async {
    try {
      final response = await _dio.get('https://catfact.ninja/fact');
      if (response.statusCode == 200) {
        final data = response.data;
        emit(data['fact']);
      } else {
        emit('Не удалось получить данные');
      }
    } catch (e) {
      emit('Произошла ошибка: $e');
    }
  }
}
