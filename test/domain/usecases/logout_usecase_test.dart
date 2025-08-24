import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskmanager/core/secure_storage_service.dart';
import 'package:taskmanager/domain/usecases/logout_usecase.dart';

import 'logout_usecase_test.mocks.dart';

@GenerateMocks([SecureStorageService])
void main() {
  late MockSecureStorageService mockSecureStorage;
  late LogoutUsecase usecase;

  setUp(() {
    mockSecureStorage = MockSecureStorageService();
    usecase = LogoutUsecase(mockSecureStorage);
  });

  group('LogoutUsecase', () {
    test('should call clearAll and return Right(null)', () async {
      // Arrange
      when(mockSecureStorage.clearAll()).thenAnswer((_) async => {});

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(null));
      verify(mockSecureStorage.clearAll()).called(1);
    });

    test('should throw and not return Right if clearAll fails', () async {
      // Arrange
      when(mockSecureStorage.clearAll()).thenThrow(Exception('fail'));

      // Act
      try {
        await usecase();
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e.toString(), contains('Exception: fail'));
      }

      verify(mockSecureStorage.clearAll()).called(1);
    });
  });
}
