import 'package:clear_architecture_test_flutter/core/usecase/usecase.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/presentation/domain/entities/number_trivia.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/presentation/domain/repositories/number_trivia_repository.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/presentation/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/presentation/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia for the number from the repository',
    () async {
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));

      final result = await usecase(NoParams());

      expect(result, Right(tNumberTrivia));

      verify(mockNumberTriviaRepository.getRandomNumberTrivia());

      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
