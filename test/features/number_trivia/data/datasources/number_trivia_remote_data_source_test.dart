import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_flutter_tdd_clean_architecture/core/errors/exceptions.dart';
import 'package:trivia_flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixtures_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSource remoteDataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number
    being the endpoint and with application/json header''', () async {
      // Arrange
      setUpMockHttpClientSuccess200();
      // Act
      remoteDataSource.getConcreteNumberTrivia(tNumber);
      // Assert
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // Arrange
      setUpMockHttpClientSuccess200();
      // Act
      final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);
      // Assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // Arrange
      setUpMockHttpClientFailure404();
      // Act
      final call = remoteDataSource.getConcreteNumberTrivia;
      // Assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number
    being the input and with application/json header''', () async {
      // Arrange
      setUpMockHttpClientSuccess200();
      // Act
      remoteDataSource.getRandomNumberTrivia();
      // Assert
      verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // Arrange
      setUpMockHttpClientSuccess200();
      // Act
      final result = await remoteDataSource.getRandomNumberTrivia();
      // Assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // Arrange
      setUpMockHttpClientFailure404();
      // Act
      final call = remoteDataSource.getRandomNumberTrivia;
      // Assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
