// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demarco_teste_pratico/core/database/app_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}

class MocListResult extends Mock implements ListResult {
  @override
  List<Reference> get items => [];
}

class MockConnectivity extends Mock implements Connectivity {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapShotReference extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {
  MockDocumentSnapShotReference({
    required this.itExist,
  });
  bool itExist;
  @override
  // TODO: implement exists
  bool get exists => itExist;
}

class MockUploadTask extends Mock implements UploadTask {}

class MockAppDatabase extends Mock implements AppDatabase {}
