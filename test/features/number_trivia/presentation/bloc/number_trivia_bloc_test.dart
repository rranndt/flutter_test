import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_flutter_tdd_clean_architecture/core/errors/failures.dart';
import 'package:trivia_flutter_tdd_clean_architecture/core/utils/input_converter.dart';
import 'package:trivia_flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia_flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia])
@GenerateMocks([GetRandomNumberTrivia])
@GenerateMocks([InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be empty', () async {
    // Assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaFroConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async* {
      // Arrange
      setUpMockInputConverterSuccess();
      // Act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // Assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [error] when the input is invalid', () async* {
      // Arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      final expected = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      // Act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // Assert
      expectLater(bloc, emitsInOrder(expected));
    });

    test('should get data from the concrete usecase', () async* {
      // Arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // Act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetRandomNumberTrivia(any));
      // Assert
      verify(mockGetConcreteNumberTrivia(any));
    });

    test('should emits [Loading, Loaded] when data is gotten successfully',
        () async* {
      // Arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // Act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // Assert
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc, emitsInOrder(expected));
    });

    test('should emits [Loading, Error] when getting data fails', () async* {
      // Arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // Act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // Assert
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));
    });

    test(
        'should emits [Loading, Error] with a proper message for the error getting data fails',
        () async* {
      // Arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // Act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // Assert
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the random usecase', () async* {
      // Arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // Act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // Assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emits [Loading, Loaded] when data is gotten successfully',
        () async* {
      // Arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // Act
      bloc.add(GetTriviaForRandomNumber());
      // Assert
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc, emitsInOrder(expected));
    });

    test('should emits [Loading, Error] when getting data fails', () async* {
      // Arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // Act
      bloc.add(GetTriviaForRandomNumber());
      // Assert
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));
    });

    test(
        'should emits [Loading, Error] with a proper message for the error when getting data fails',
        () async* {
      // Arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // Act
      bloc.add(GetTriviaForRandomNumber());
      // Assert
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));
    });
  });
}
