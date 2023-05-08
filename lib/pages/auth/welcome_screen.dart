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
            const SizedBox(
              height: kToolbarHeight + 12,
            ),
            Column(
              children: const [
                Text(
                  "Welcome to our Habit Tracker mobile app!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                    'Start tracking your habits and unlock your full potential for positive change.')
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            const Center(
              child: Image(
                image: AssetImage('assets/main.png'),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/googlelogo.png',
                scale: 25,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            PrimaryButton(
              title: 'Login',
              onPressed: () {
                Routes.instance.push(widget: const Login(), context: context);
              },
            ),
            const SizedBox(
              height: 18,
            ),
            PrimaryButton(
              title: 'Sign Up',
              onPressed: () {
                Routes.instance
                    .push(widget: const SignUpScreen(), context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
