import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/user_model.dart';

class FirebaseStorageHelper {
  static FirebaseStorageHelper instance = FirebaseStorageHelper();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadUserImage(File image) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    TaskSnapshot taskSnapshot = await _storage.ref(userId).putFile(image);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
