import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracer/model/user_model.dart';
import 'package:habit_tracer/pages/auth/sign_up_screen.dart';
import 'package:habit_tracer/widgets/custom_bottom_bar.dart';
import '../../const/routes.dart';
import '../../services/google/google_sign_in.dart';
import '../../widgets/primary_button.dart';
import 'login_screen.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kToolbarHeight + 12,
            ),
            Center(
              child: Text(
                "Welcome",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Center(
              child: Text(
                'Habbit Tracker',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            Center(
              child: Image(
                image: AssetImage('assets/main.png'),
              ),
            ),
            SizedBox(
              height: 52,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CupertinoButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.facebook,
                  size: 45,
                  color: Colors.blue,
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  UserModel myuser =
                      auth.signInWithGoogle(context: context) as UserModel;
                  if (myuser != null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomBottomBar()));
                  }
                },
                child: Image.asset(
                  'assets/googlelogo.png',
                  scale: 25,
                ),
              ),
            ]),
            SizedBox(
              height: 18,
            ),
            PrimaryButton(
              title: 'Login',
              onPressed: () {
                Routes.instance.push(widget: Login(), context: context);
              },
            ),
            SizedBox(
              height: 18,
            ),
            PrimaryButton(
              title: 'Sign Up',
              onPressed: () {
                Routes.instance.push(widget: SignUpScreen(), context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
