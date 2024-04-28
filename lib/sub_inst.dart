import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todo/search_task.dart';
import 'package:todo/sub_detail.dart';

class subjects extends StatefulWidget {
  final String stduentname;
  subjects({Key? key, required this.stduentname}) : super(key: key);

  @override
  _subjectsState createState() => _subjectsState();
}

class _subjectsState extends State<subjects> {
  TextEditingController subjectname = TextEditingController();
  Set<String> subjectKeys = {}; // Using Set instead of List for unique values

  @override
  void initState() {
    fetchStudentKeys();
    super.initState();
  }

  void fetchStudentKeys() {
    DatabaseReference dbRef = FirebaseDatabase.instance
        .ref()
        .child("Student")
        .child(widget.stduentname);
    dbRef.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? data =
          dataSnapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          subjectKeys.clear(); // Clear existing keys before adding new ones
          data.forEach((key, value) {
            subjectKeys.add(key.toString());
          });
        });
      }
    }, onError: (error) {
      print("Error fetching student data: $error");
      // Handle error as needed
    });
  }

  void addSubject() {
    String subnam = subjectname.text;
    final dbRef = FirebaseDatabase.instance
        .ref()
        .child("Student")
        .child(widget.stduentname);
    dbRef.update({subnam: true}).then((_) {
      setState(() {
        subjectKeys.add(subnam);
        subjectname.clear();
      }); // Refresh the list of subjects
    });
    print('Sajid dakh la bhai');
    print(subjectKeys);
  }

  void deleteSubject(String subjectName) {
    final dbRef = FirebaseDatabase.instance
        .ref()
        .child("Student")
        .child(widget.stduentname);
    dbRef.child(subjectName).remove().then((_) {
      setState(() {
        subjectKeys.remove(subjectName);
      }); // Refresh the list of subjects
      print('Subject $subjectName deleted successfully');
    }).catchError((error) {
      print('Failed to delete subject: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/student_register.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Text(
                  "Hi! ${widget.stduentname}",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(right: 40, top: 20, left: 40),
                child: TextField(
                  controller: subjectname,
                  style: const TextStyle(),
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: "Enter New Subjects",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 0,
                width: 300,
                child: ElevatedButton(
                  onPressed: addSubject,
                  child: Text("Add New Subject"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(
                            255, 255, 201, 219)), // Change color here
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            searchingtask(stduentname: widget.stduentname),
                      ),
                    );
                  },
                  child: Text("Searching Task"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(
                            255, 255, 201, 219)), // Change color here
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: subjectKeys.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Center(
                          child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 239, 194),
                            borderRadius: BorderRadius.circular(15)),
                        width: 400,
                        height: 60,
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: ListTile(
                          title: Text(
                            subjectKeys.elementAt(index),
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                deleteSubject(subjectKeys.elementAt(index));
                              },
                              icon: Icon(Icons.delete)),
                        ),
                      )),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => subjectdetail(
                                studentName: widget.stduentname,
                                subjectName: subjectKeys.elementAt(index),
                              ),
                            ),
                            (route) => false);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
