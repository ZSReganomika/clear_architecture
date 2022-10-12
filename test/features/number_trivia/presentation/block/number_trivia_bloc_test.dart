import 'package:clear_architecture_test_flutter/core/error/failures.dart';
import 'package:clear_architecture_test_flutter/core/usecase/usecase.dart';
import 'package:clear_architecture_test_flutter/core/util/input_converter.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

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
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Emtty', () {
    expect(bloc.initialState, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
    final tParams = Params(number: tNumberParsed);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger('sgsdg'))
            .thenReturn(Right(tNumberParsed));

    test(
        'should call IputConverter to validate and convert the string to an unsigned integer',
        () async {
      setUpMockInputConverterSuccess();
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger('sgsdg'));

      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInteger('sgsdg'))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [
        Empty(),
        Error(errorMessage: '', message: INVALID_INPUT_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(tParams))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(tParams));

      verify(mockGetConcreteNumberTrivia(tParams));
    });

    test('should emit [Loading, Loaded] when data is gotten succesfully',
        () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(tParams))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [
        Empty(), //block.initialState
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when data is gotten succesfully',
        () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(tParams))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Empty(), //block.initialState
        Loading(),
        Error(errorMessage: '', message: SERVER_FAILURE_MESSAGE),
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(tParams))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Empty(), //block.initialState
        Loading(),
        Error(errorMessage: '', message: SERVER_FAILURE_MESSAGE),
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('GetRandomForConcreteNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the random use case', () async {
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(NoParams()));

      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten succesfully',
        () async {
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [
        Empty(), //block.initialState
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when data is gotten succesfully',
        () async {
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Empty(), //block.initialState
        Loading(),
        Error(errorMessage: '', message: SERVER_FAILURE_MESSAGE),
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Empty(), //block.initialState
        Loading(),
        Error(errorMessage: '', message: SERVER_FAILURE_MESSAGE),
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
