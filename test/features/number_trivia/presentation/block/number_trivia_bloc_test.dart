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
  late NumberTriviaBloc block;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    block = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Emtty', () {
    expect(block.initialState, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
        'should call IputConverter to validate and convert the string to an unsigned integer',
        () async {
      when(mockInputConverter.stringToUnsignedInteger('sgsdg'))
          .thenReturn(Right(tNumberParsed));

      block.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger('sgsdg'));

      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInteger('sgsdg'))
          .thenReturn(Left(InvalidInputFailure()));

      block.add(GetTriviaForConcreteNumber(tNumberString));

      final expected = [
        Empty(),
        Error(errorMessage: '', message: INVALID_INPUT_FAILURE_MESSAGE)
      ];
      expectLater(block.state, emitsInOrder(expected));
    });
  });
}
