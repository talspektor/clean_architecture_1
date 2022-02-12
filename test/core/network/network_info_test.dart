import 'package:clean_architecture_1/core/network/network_info.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

main() {
  NetworkInfoImpl networkInfo;
  // MockDataConnectionChecker mockDataConnectionChecker;

  group('isConnected', () {
    // mockDataConnectionChecker = MockDataConnectionChecker();
    // // networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
    // test('should forward the call to DataConnectionChecker.hasConnection',
    //     () async {
    //   // arrange
    //   final tHasConnectionFuture = Future.value(true);
    //
    //   when(mockDataConnectionChecker.hasConnection)
    //       .thenAnswer((_) async => tHasConnectionFuture);
    //   // act
    //   final result = networkInfo.isConnected;
    //   // assert
    //   verify(mockDataConnectionChecker.hasConnection);
    //   expect(result, true);
    // });
  });
}
