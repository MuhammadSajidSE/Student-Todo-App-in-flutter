import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todo/student_register.dart';
import 'package:todo/sub_inst.dart';

class studentlogin extends StatefulWidget {
  const studentlogin({Key? key}) : super(key: key);
  @override
  State<studentlogin> createState() => _studentloginState();
}

class _studentloginState extends State<studentlogin> {
  List<String> studentNames = [];
  TextEditingController stduentname = TextEditingController();
  String errorMessage = "";

void checkStudentName() {
  String name = stduentname.text.trim();
  if (name.isNotEmpty) {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Student").child(name);
    dbRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => subjects(stduentname: stduentname.text),
          ),
        );
      } else {
        // Student name does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student name does not exist')),
        );
      }
    }, onError: (error) {
      print("Error fetching student data: $error");
      // Handle error as needed
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter a student name')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/student_register.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                'Welcome\nStudent Task',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: stduentname,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Enter Your Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Go to Dashboard',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    checkStudentName();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            child: const Text("If Don't have an account"),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const studentregistertion(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
