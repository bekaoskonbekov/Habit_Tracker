import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracer/pages/auth/sign_up_screen.dart';
import '../../const/routes.dart';
import '../../widgets/primary_button.dart';
import 'login_screen.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kToolbarHeight + 12,
            ),
            Text(
              "Welcome",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Buy any item from using app',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Center(
              child: Image(
                image: AssetImage('assets/main.png'),
              ),
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
                onPressed: () {},
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
