// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../const/routes.dart';
import '../../firebase/firebase_auth_helper.dart';
import '../../model/user_model.dart';
import '../../provider/app_provider.dart';
import '../../widgets/primary_button.dart';
import '../auth/chage_password/change_password.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;
  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(15, 50, 15, 20),
        children: [
          image == null
              ? CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: const CircleAvatar(
                      radius: 55, child: Icon(Icons.camera_alt)),
                )
              : CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 55,
                  ),
                ),
          PrimaryButton(
            title: "Update",
            onPressed: () async {
              UserModel userModel = appProvider.getUserInformation
                  .copyWith(name: textEditingController.text);

              appProvider.updateUserInfoFirebase(context, userModel, image);
            },
          ),
          // ignore: prefer_const_constructors
          Padding(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            child: Center(
                child: Text(
              '',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            )),
          ),
          Center(
              child: Text(
            "What a wonderful day!!",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
          )),
          Padding(
            padding: EdgeInsets.all(10),
            child: Divider(),
          ),
          GestureDetector(
            // onTap: () {
            //   Routes.instance
            //       .push(widget: EditProfileScreen(), context: context);
            // },
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text("My Account Info"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              Routes.instance.push(widget: ChangePassword(), context: context);
            },
            child: ListTile(
              leading: Icon(Icons.payment),
              title: Text("Change Password"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text("All of my habits"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About This App"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          Center(
            child: TextButton(
              onPressed: (() {}),
              child: InkWell(
                onTap: () {
                  FirebaseAuthHelper.instance.signOut();
                  setState(() {});
                },
                child: Text(
                  "Log Out",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
