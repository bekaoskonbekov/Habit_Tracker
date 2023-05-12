import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime _selectedDay = DateTime.utc(2023, 01, 16);
  DateTime _focusedDay = DateTime.now();
  String _date = DateFormat.yMMMd().format(DateTime.now());
  DateTime dateNow = DateTime.now();
  DateTime createdUserDate = DateTime(2018, 1, 13);

  get() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      createdUserDate = doc['timestamp'].toDate();
    });
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    get();
    super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calendar"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Column(
              children: [
                /// calendar
                TableCalendar(
                  headerStyle: HeaderStyle(formatButtonVisible: false),
                  calendarStyle: CalendarStyle(
                      selectedDecoration:
                          BoxDecoration(shape: BoxShape.circle)),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    print(DateFormat.yMMMd().format(selectedDay));
                    setState(() {
                      _date = DateFormat.yMMMd().format(selectedDay);
                      _selectedDay = selectedDay;
                      _focusedDay =
                          focusedDay; // update `_focusedDay` here as well
                    });
                  },
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(
                      dateNow.year - 1, dateNow.month + 2, dateNow.day),
                  lastDay: DateTime.utc(
                      dateNow.year + 1, dateNow.month + 2, dateNow.day),
                  currentDay: _focusedDay,
                ),

                Divider(
                  height: 20,
                ),

                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text('Completed tasks')),

                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('habitOnDate')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('habitDate')
                        .doc(_date)
                        .collection('habits')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          child: Text(
                            'No task done',
                          ),
                        );
                      }

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            children: snapshot.data!.docs.map((doc) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  doc['habitName'],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ));
  }
}
