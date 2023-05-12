import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracer/services/firebase/firebase_firestore_helper.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  TextEditingController _controller = TextEditingController();
  final _key = GlobalKey<FormState>();

  /// add habit to database
  addHabit(String habit) async {
    if (_key.currentState!.validate()) {
      final String id =
          FirebaseFirestore.instance.collection('habits').doc().id;

      /// to dismiss the keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      try {
        ///adding habits to firebase
        await FirebaseFirestore.instance
            .collection('habits')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('habit')
            .doc(id)
            .set({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          "habitId": id,
          "habit": habit,
          "timeStamp": DateTime.now(),
        }).whenComplete(() async {
          await FirebaseFirestore.instance
              .collection('habits')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({"count": FieldValue.increment(1)}, SetOptions(merge: true));
        });

        _controller.clear();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  /// delete habit from database
  delete(String habitId) async {
    /// deleting habit from habits collection
    await FirebaseFirestore.instance
        .collection('habits')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('habit')
        .doc(habitId)
        .delete();

    /// decreasing count form habits collection
    await FirebaseFirestore.instance
        .collection('habits')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"count": FieldValue.increment(-1)}, SetOptions(merge: true));

    /// getting habit from habitOnDate collection
    DocumentSnapshot _doc = await FirebaseFirestore.instance
        .collection('habitOnDate')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('habitDate')
        .doc(DateFormat.yMMMd().format(DateTime.now()))
        .collection('habits')
        .doc(habitId)
        .get();

    /// checking if doc exists
    if (_doc.exists) {
      /// deleting habits from habitOnDate
      await FirebaseFirestore.instance
          .collection('habitOnDate')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('habitDate')
          .doc(DateFormat.yMMMd().format(DateTime.now()))
          .collection('habits')
          .doc(habitId)
          .delete();

      /// decreasing count from habit on date
      await FirebaseFirestore.instance
          .collection('habitOnDate')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('habitDate')
          .doc(DateFormat.yMMMd().format(DateTime.now()))
          .set({"count": FieldValue.increment(-1)}, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Habbit"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),

        /// making a form
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: AssetImage('assets/progress.png'),
                        fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// total tasks to do today
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Write habit you want to build',
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _controller,
                validator: (val) =>
                    val!.trim().isEmpty ? 'Please fill input' : null,
                decoration: InputDecoration(
                    hintText: '...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  addHabit(_controller.text.trim());
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Add',
                  ),
                ),
              ),
              Divider(
                height: 40,
              ),
              Text(
                'Previous Habits you Added',
              ),
              SizedBox(
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
                      return CircularProgressIndicator();
                    }

                    return Expanded(
                        child: ListView(
                      children: snapshot.data!.docs.map((doc) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(doc['habit']),
                            IconButton(

                                /// delete function
                                onPressed: () {
                                  delete(doc['habitId']);
                                },
                                icon: Icon(Icons.delete))
                          ],
                        );
                      }).toList(),
                    ));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
