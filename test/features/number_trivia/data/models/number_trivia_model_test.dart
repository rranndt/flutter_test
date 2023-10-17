import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: 1);

  test('should be a subclass of NumberTrivia entity', () async {
    // Assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer',
        () async {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      // Act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // Assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should return a valid model when the JSON number is regarded as a double',
        () async {
      // Arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      // Act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // Assert
      expect(result, equals(tNumberTriviaModel));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      // Act
      final result = tNumberTriviaModel.toJson();
      // Assert
      final expectedMap = {'text': 'Test text', 'number': 1};
      expect(result, equals(expectedMap));
    });
  });
}
