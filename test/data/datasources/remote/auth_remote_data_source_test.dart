import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskmanager/core/secure_storage_service.dart';
import 'package:taskmanager/data/datasources/remote/auth_remote_data_source.dart';
import 'package:taskmanager/domain/entities/user_entity.dart';

import 'auth_remote_data_source_test.mocks.dart';

// Generate mocks for the external deps we interact with
@GenerateMocks([FirebaseAuth, UserCredential, User, SecureStorageService])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockSecureStorageService mockSecureStorage;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late AuthRemoteDataSource dataSource;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockSecureStorage = MockSecureStorageService();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    dataSource = AuthRemoteDataSource(mockFirebaseAuth, mockSecureStorage);
  });

  group('login', () {
    test('returns UserEntity and saves uid when Firebase returns a user',
        () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const uid = 'uid-123';

      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn(uid);
      when(mockUser.email).thenReturn(email);
      when(mockSecureStorage.saveUser(any)).thenAnswer((_) async {
        return;
      });

      // Act
      final result = await dataSource.login(email, password);

      // Assert
      expect(result, isA<UserEntity>());
      expect(result.id, uid);
      expect(result.email, email);

      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).called(1);

      verify(mockSecureStorage.saveUser(uid)).called(1);
      verifyNoMoreInteractions(mockSecureStorage);
    });

    test('throws when Firebase returns null user', () async {
      // Arrange
      const email = 'nobody@example.com';
      const password = 'pass';

      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(null);

      // Act & Assert
      expect(
        () => dataSource.login(email, password),
        throwsA(isA<Exception>()),
      );

      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).called(1);

      // ensure we did NOT save anything
      verifyZeroInteractions(mockSecureStorage);
    });
  });

  group('register', () {
    test('returns UserEntity and saves uid when Firebase returns a user',
        () async {
      // Arrange
      const email = 'newuser@example.com';
      const password = 'password!';
      const uid = 'uid-xyz';

      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn(uid);
      when(mockUser.email).thenReturn(email);
      when(mockSecureStorage.saveUser(any)).thenAnswer((_) async {
        return;
      });

      // Act
      final result = await dataSource.register(email, password);

      // Assert
      expect(result.id, uid);
      expect(result.email, email);

      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).called(1);
      verify(mockSecureStorage.saveUser(uid)).called(1);
    });

    test('throws when Firebase returns null user', () async {
      // Arrange
      const email = 'fail@example.com';
      const password = '12345678';

      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(null);

      // Act & Assert
      expect(
        () => dataSource.register(email, password),
        throwsA(isA<Exception>()),
      );

      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).called(1);
      verifyZeroInteractions(mockSecureStorage);
    });
  });

  group('logout', () {
    test('calls FirebaseAuth.signOut', () async {
      // Arrange
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {
        return;
      });

      // Act
      await dataSource.logout();

      // Assert
      verify(mockFirebaseAuth.signOut()).called(1);
      verifyNoMoreInteractions(mockFirebaseAuth);
    });
  });
}
