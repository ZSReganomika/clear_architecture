import 'package:clear_architecture_test_flutter/core/error/exceptions.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/presentation/domain/entities/number_trivia.dart';
import 'package:clear_architecture_test_flutter/core/error/failures.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/presentation/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:analyzer/exception/exception.dart';

import '../../../../core/platform/ntwork_info.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSorce remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
