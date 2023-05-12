import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracer/const/extensions/extension.dart';
import 'package:habit_tracer/generated/locale_keys.g.dart';
import 'package:habit_tracer/pages/home/edit_profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../const/routes.dart';
import '../../services/firebase/firebase_auth_helper.dart';
import '../../provider/app_provider.dart';
import '../../widgets/primary_button.dart';
import '../auth/chage_password/change_password.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final List locale = [
  //   {'name': 'English', 'locale': Locale('en', 'US')},
  //   {'name': 'Русский', 'locale': Locale('ru', 'IN')},
  // ];

  bool get isDark => Theme.of(context).brightness == Brightness.dark;
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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        padding: EdgeInsets.fromLTRB(15, 50, 15, 20),
        children: [
          appProvider.getUserInformation.image == null
              ? const Icon(
                  Icons.person_outline,
                  size: 120,
                )
              : CircleAvatar(
                  backgroundImage:
                      NetworkImage(appProvider.getUserInformation.image!),
                  radius: 60,
                ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              appProvider.getUserInformation.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Text(
              appProvider.getUserInformation.email,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          SizedBox(
            width: 130,
            child: PrimaryButton(
              title: "Edit Profile",
              onPressed: () {
                Routes.instance
                    .push(widget: EditProfileScreen(), context: context);
              },
            ),
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
            LocaleKeys.what_a_wonderful_day.tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          )),
          Padding(
            padding: EdgeInsets.all(10),
            child: Divider(),
          ),
          GestureDetector(
            onTap: () {
              // Routes.instance
              //     .push(widget: EditProfileScreen(), context: context);
            },
            child: GestureDetector(
              onTap: () {
                buildLanguageDialog(context);
              },
              child: ListTile(
                leading: Icon(Icons.language_rounded),
                title: Text(LocaleKeys.change_lang.tr()),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              Routes.instance.push(widget: ChangePassword(), context: context);
            },
            child: ListTile(
              leading: Icon(Icons.payment),
              title: Text(LocaleKeys.change_pass.tr()),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Divider(),

          SwitchListTile(
            subtitle: ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text(LocaleKeys.dark_mode.tr()),
            ),
            value: context.isDark,
            onChanged: (value) {
              context.isDark
                  ? AdaptiveTheme.of(context).setLight()
                  : AdaptiveTheme.of(context).setDark();
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.info),
            title: Text(LocaleKeys.about_this_app.tr()),
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
                  LocaleKeys.log_out.tr(),
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

  buildLanguageDialog(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text(LocaleKeys.choose_your_lang.tr()),
            content: Container(
                width: double.maxFinite,
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 58.0),
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            context.setLocale(Locale('ru'));
                          },
                          child: Text("Русский")),
                      Divider(),
                      TextButton(
                        onPressed: () {
                          context.setLocale(Locale('en'));
                        },
                        child: Text("English"),
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
