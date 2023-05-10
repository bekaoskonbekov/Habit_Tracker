import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../const/utils.dart';
import '../firebase/firebase_firestore_helper.dart';
import '../firebase/firebase_storage_helper.dart';
import '../model/user_model.dart';

class AppProvider extends ChangeNotifier {
  UserModel? _userModel;
  UserModel get getUserInformation => _userModel!;

  void getUserInfoFirebase() async {
    _userModel = await FirebaseFirestoreHelper.instance.getUserInformation();
    notifyListeners();
  }

  void updateUserInfoFirebase(
      BuildContext context, UserModel userModel, File? file) async {
    if (file == null) {
      showLoaderDialog(context);

      _userModel = userModel;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    } else {
      showLoaderDialog(context);

      String imageUrl =
          await FirebaseStorageHelper.instance.uploadUserImage(file);
      _userModel = userModel.copyWith(image: imageUrl);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
    showMessage("Successfully updated profile");

    notifyListeners();
  }
}
