

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/selfa.dart';

class SelafOperations{
  FirebaseFirestore fireStoreDataBase = FirebaseFirestore.instance;
  Stream<List<Selfa>> getSelafList() {
    return fireStoreDataBase.collection('selaf')
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => Selfa.fromDocumentSnapshot(document))
        .toList());
  }
}