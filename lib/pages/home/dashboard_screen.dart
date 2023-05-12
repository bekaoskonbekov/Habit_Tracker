import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:habit_tracer/generated/locale_keys.g.dart';
import 'package:habit_tracer/pages/home/calendar_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/app_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _name = '';
  String _tasks = '';
  double percent = 0;

  habitDate(bool isHabit, String habitId, String habitName) async {
    get();

    /// formatting date
    String formatDate = DateFormat.yMMMd().format(DateTime.now());

    try {
      if (isHabit) {
        /// create habitOnDate is habit is true
        await FirebaseFirestore.instance
            .collection('habitOnDate')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('habitDate')
            .doc(formatDate)
            .collection('habits')
            .doc(habitId)
            .set({
          "userId": FirebaseAuth.instance.currentUser!.uid,
          "habitId": habitId,
          "date": formatDate,
          "isHabit": isHabit,
          "habitName": habitName
        }).whenComplete(() async {
          await FirebaseFirestore.instance
              .collection('habitOnDate')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('habitDate')
              .doc(formatDate)
              .set({'count': FieldValue.increment(1)}, SetOptions(merge: true));
        });
      } else {
        /// delete habitOnDate if isHabit is false
        await FirebaseFirestore.instance
            .collection('habitOnDate')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('habitDate')
            .doc(formatDate)
            .collection('habits')
            .doc(habitId)
            .delete()
            .whenComplete(() async {
          await FirebaseFirestore.instance
              .collection('habitOnDate')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('habitDate')
              .doc(formatDate)
              .set(
                  {'count': FieldValue.increment(-1)}, SetOptions(merge: true));
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  get() async {
    try {
      DocumentSnapshot usersDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      DocumentSnapshot habitsDoc = await FirebaseFirestore.instance
          .collection('habits')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      DocumentSnapshot habitDoneDoc = await FirebaseFirestore.instance
          .collection('habitOnDate')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('habitDate')
          .doc(DateFormat.yMMMd().format(DateTime.now()))
          .get();

      setState(() {
        _name = usersDoc['name'];
        _tasks = habitsDoc['count'].toString();
        percent = habitsDoc['count'] > 0
            ? double.parse(
                (habitDoneDoc['count'] / habitsDoc['count']).toStringAsFixed(2))
            : 0;
      });
      print(percent.toStringAsFixed(2));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: AssetImage('assets/main.png'), fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// username
                  Text(
                    LocaleKeys.hi.tr(),
                  ),
                  Text(
                    _name,
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  /// total tasks to do today
                  Text(
                    'You have $_tasks habbits today',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),

            /// calendar button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    DateFormat.yMMMd().format(DateTime.now()),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    /// Navigate to CalenderScreen
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalenderScreen()));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        'Calendar',
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      percent == 1
                          ? Text(' You did It.. Congrats!!')
                          : percent < 0.5
                              ? Text('Start to do your tasks')
                              : Text('You\'re almost done go ahead'),
                      Text('${percent * 100}%')
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // /// progress bar
                  GFProgressBar(
                    percentage: percent < 0 ? 0 : percent,
                    lineHeight: 10,
                  ),
                ],
              ),
            ),

            Divider(
              height: 20,
            ),

            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('habits')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('habit')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: Text('No data'),
                    );
                  }

                  return Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map((doc) {
                        return CheckBoxTileDate(
                          onChanged: (val) {
                            habitDate(val!, doc['habitId'], doc['habit']);
                          },
                          habit: doc['habit'],
                          habitId: doc['habitId'],
                        );
                      }).toList(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class CheckBoxTileDate extends StatefulWidget {
  final String habitId;
  final String habit;
  final void Function(bool?) onChanged;
  CheckBoxTileDate(
      {required this.habitId, required this.habit, required this.onChanged});
  @override
  State<CheckBoxTileDate> createState() => _CheckBoxTileDateState();
}

class _CheckBoxTileDateState extends State<CheckBoxTileDate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('habitOnDate')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('habitDate')
            .doc(DateFormat.yMMMd().format(DateTime.now()))
            .collection('habits')
            .doc(widget.habitId)
            .snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return CheckboxListTile(
            value: snapshot.data!.exists ? snapshot.data!['isHabit'] : false,
            onChanged: widget.onChanged,
            title: Text(widget.habit),
            checkboxShape: CircleBorder(),
            controlAffinity: ListTileControlAffinity.leading,
          );
        });
  }
}
