import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class searchingtask extends StatefulWidget {
  final String stduentname;
  searchingtask({Key? key, required this.stduentname}) : super(key: key);
  @override
  State<searchingtask> createState() => _searchingtaskState();
}

class _searchingtaskState extends State<searchingtask> {
  late String selectedDate = "";
  TextEditingController data = TextEditingController();
  List<List<Map<String, dynamic>>> tasksList = [];
void fetchAndOrganizeTasksByDateForStudent(String insertDateString) {
  DatabaseReference dbrf = FirebaseDatabase.instance
      .ref()
      .child("Student")
      .child(widget.stduentname);
  dbrf.onValue.listen((event) {
    DataSnapshot dataSnapshot = event.snapshot;
    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic>? dataMap =
          dataSnapshot.value as Map<dynamic, dynamic>?;

      if (dataMap != null) {
        Map<String, List<Map<String, dynamic>>> tasksBySubject = {};

        dataMap.forEach((subject, tasks) {
          if (tasks is Map) {
            List<Map<String, dynamic>> filteredTasks = [];

            tasks.forEach((taskId, taskDetails) {
              if (taskDetails['date'] == insertDateString) {
                filteredTasks.add({
                  'task': taskDetails['task'],
                  'date': taskDetails['date'],
                  'done': taskDetails['done']
                });
              }
            });

            if (filteredTasks.isNotEmpty) {
              tasksBySubject[subject] = filteredTasks;
            }
          }
        });

        // Print the organized tasks
        tasksBySubject.forEach((subject, tasks) {
          print('$subject: $tasks');
        });

        // Print additional information
        print("Date: $insertDateString");
        print("Tasks organized by subject and filtered by date.");
      }
    }
  });
}


  @override
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text(
                "Hi! ${widget.stduentname}",
                style: TextStyle(
                    fontSize: 25, color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 20, top: 20, right: 20),
                    child: TextField(
                      controller: data,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: "Searching Date",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          initialDatePickerMode: DatePickerMode.day,
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            data.text = selectedDate!;
                          });
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25, right: 20),
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      fetchAndOrganizeTasksByDateForStudent(selectedDate!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 114, 192, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Searching",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: tasksList.length,
            //     itemBuilder: (context, index) {
            //       String subject = tasksList[index].keys.first;
            //       List<Map<dynamic, dynamic>> tasks = tasksList[index][subject];
            //       return Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Padding(
            //             padding:
            //                 EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            //             child: Text(
            //               subject,
            //               style: TextStyle(
            //                   fontSize: 20, fontWeight: FontWeight.bold),
            //             ),
            //           ),
            //           ListView.builder(
            //             shrinkWrap: true,
            //             physics: NeverScrollableScrollPhysics(),
            //             itemCount: tasks.length,
            //             itemBuilder: (context, index) {
            //               Map<String, dynamic> task = tasks[index];
            //               return ListTile(
            //                 title: Text(task['task']),
            //                 subtitle: Text(task['date']),
            //                 trailing: Checkbox(
            //                   value: task['done'],
            //                   onChanged: (value) {
            //                     // Handle checkbox change
            //                   },
            //                 ),
            //               );
            //             },
            //           ),
            //           Divider(height: 1, color: Colors.grey),
            //         ],
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}