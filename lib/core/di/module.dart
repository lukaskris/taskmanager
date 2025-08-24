import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:taskmanager/core/secure_storage_service.dart';

@module
abstract class RegisterModule {
  SecureStorageService get secureStorage => SecureStorageService();
  HiveInterface get hive => Hive;
  FirebaseDatabase get firebase => FirebaseDatabase.instance;
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}
