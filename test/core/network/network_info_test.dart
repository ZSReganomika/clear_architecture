import 'package:clear_architecture_test_flutter/core/network/ntwork_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecher extends Mock implements DataConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockDataConnectionChecher mockDataConnectionChecher;

  setUp(() {
    mockDataConnectionChecher = MockDataConnectionChecher();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecher);
  });

  group('isConnected', (() async {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      final tHasConnectionFuture = Future.value(true);

      when(mockDataConnectionChecher.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);

      final result = networkInfo.isConnected;

      verify(mockDataConnectionChecher.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  }));
}
