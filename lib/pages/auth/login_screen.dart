import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracer/pages/auth/sign_up_screen.dart';
import 'package:habit_tracer/widgets/custom_bottom_bar.dart';
import '../../const/routes.dart';
import '../../const/utils.dart';
import '../../services/firebase/firebase_auth_helper.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/top_titles.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isShowPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopTitles(
                  subtitle: "Welcome back to Habbit Tracker appbeka@gmail.com",
                  title: "Login"),
              const SizedBox(
                height: 46.0,
              ),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  hintText: "E-mail",
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                controller: password,
                obscureText: isShowPassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(
                    Icons.password_sharp,
                  ),
                  suffixIcon: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                      padding: EdgeInsets.zero,
                      child: Icon(
                        isShowPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      )),
                ),
              ),
              const SizedBox(
                height: 36.0,
              ),
              PrimaryButton(
                  title: "Login",
                  onPressed: () async {
                    bool isValidated =
                        loginVaildation(email.text, password.text);
                    if (isValidated) {
                      bool isLogined = await FirebaseAuthHelper.instance
                          .login(email.text, password.text, context);
                      if (isLogined) {
                        Routes.instance.pushAndRemoveUntil(
                            widget: CustomBottomBar(), context: context);
                      }
                    }
                  }),
              const SizedBox(
                height: 24.0,
              ),
              const Center(child: Text("Don't have an account?")),
              const SizedBox(
                height: 12.0,
              ),
              Center(
                child: CupertinoButton(
                  onPressed: () {
                    Routes.instance
                        .push(widget: const SignUpScreen(), context: context);
                  },
                  child: Text(
                    "Create an account",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
