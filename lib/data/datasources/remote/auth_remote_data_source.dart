import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:taskmanager/core/secure_storage_service.dart';
import 'package:taskmanager/domain/entities/user_entity.dart';

@injectable
class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final SecureStorageService _secureStorageService;

  AuthRemoteDataSource(this._firebaseAuth, this._secureStorageService);

  Future<UserEntity> login(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) throw Exception('User not found');
    await _secureStorageService.saveUser(user.uid);
    return UserEntity(id: user.uid, email: user.email ?? '');
  }

  Future<UserEntity> register(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) throw Exception('Registration failed');
    await _secureStorageService.saveUser(user.uid);
    return UserEntity(id: user.uid, email: user.email ?? '');
  }

  Future<void> logout() async => _firebaseAuth.signOut();
}
