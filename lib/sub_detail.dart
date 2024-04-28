import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/sub_inst.dart';
// ignore: camel_case_types
class subjectdetail extends StatefulWidget {
  final String studentName, subjectName;
  const subjectdetail(
      {super.key, required this.studentName, required this.subjectName});
  @override
  State<subjectdetail> createState() => _subjectdetailState();
}
class _subjectdetailState extends State<subjectdetail> {
  TextEditingController task = TextEditingController();
  TextEditingController data = TextEditingController();

  DateTime? selectedDate;
  late String date;
  List<dynamic> alltaskList = [];
  void gettask() {
    final dbrf = FirebaseDatabase.instance
        .ref()
        .child("Student")
        .child(widget.studentName)
        .child(widget.subjectName);
    dbrf.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      print(dataSnapshot.value);
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic>? dataMap =
            dataSnapshot.value as Map<dynamic, dynamic>?;
        print(dataMap);
        if (dataMap != null) {
          setState(() {
            alltaskList.clear();
            alltaskList = dataMap.values.toList();
            print(alltaskList);
          });
        }
      }
    });
  }

  void deleteTask(String targetDate, String targetTasks) async {
    final dbrf = FirebaseDatabase.instance
        .ref()
        .child("Student")
        .child(widget.studentName)
        .child(widget.subjectName);
    dbrf.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic>? dataMap =
            dataSnapshot.value as Map<dynamic, dynamic>?;
        if (dataMap != null) {
          dataMap.forEach((key, value) {
            if (value['date'] == targetDate && value['task'] == targetTasks) {
              dbrf.child(key).remove().then((_) {
                // Task removed successfully
                print("Task removed successfully");
                setState(() {
                  // Update the task list in the state
                  gettask();
                });
              }).catchError((error) {
                // Handle error if remove fails
                print("Error removing task: $error");
              });
            }
          });
        }
      }
    });
  }

  void markdone(String targetDate, String targetTasks, bool doning) async {
    final dbrf = FirebaseDatabase.instance
        .ref()
        .child("Student")
        .child(widget.studentName)
        .child(widget.subjectName);
    dbrf.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic>? dataMap =
            dataSnapshot.value as Map<dynamic, dynamic>?;
        if (dataMap != null) {
          dataMap.forEach((key, value) {
            if (value['date'] == targetDate && value['task'] == targetTasks) {
              dbrf
                  .child(key)
                  .update({
                    "task": targetTasks,
                    "date": targetDate,
                    "done": !doning,
                  })
                  .then((_) {})
                  .catchError((error) {
                    // Handle error if update fails
                    print("Error updating data: $error");
                  });
            }
          });
        }
      }
    });
  }Future<void> inputdialog(String subName) async {
  final TextEditingController task = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text('Add Task of $subName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: task,
                decoration: const InputDecoration(
                  labelText: 'Task',
                ),
              ),
              TextField(
                controller: data,
                decoration: const InputDecoration(
                  labelText: 'Date',
                ),
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
                      selectedDate = pickedDate;
                      // Set the selected date to the date TextField
                      data.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
                    });
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        initialDatePickerMode: DatePickerMode.day,
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                          // Set the selected date to the date TextField
                          data.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
                        });
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedDate != null) {
                        final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
                        final dbRef = FirebaseDatabase.instance
                            .ref()
                            .child("Student")
                            .child(widget.studentName)
                            .child(widget.subjectName)
                            .push();
                        dbRef.set({
                          "task": task.text,
                          "date": formattedDate.toString(),
                          "done": false,
                        }).then((value) {
                          setState(() {
                            // Update the task list in the state
                            gettask();
                          });
                        }).catchError((error) {
                          print("Error setting data: $error");
                          // Handle error as needed
                        });
                        task.clear();
                        data.clear();
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please select a date.'),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: const Text('Save Task'),
                  ),
                ],
              ),
            ],
          ),
        );
      });
    },
  );
}

  void updateTask(String targetDate, String targetTasks, String newTask,
      String newDate) async {
    final dbrf = FirebaseDatabase.instance
        .ref()
        .child("Student")
        .child(widget.studentName)
        .child(widget.subjectName);
    dbrf.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic>? dataMap =
            dataSnapshot.value as Map<dynamic, dynamic>?;
        if (dataMap != null) {
          dataMap.forEach((key, value) {
            if (value['date'] == targetDate && value['task'] == targetTasks) {
              dbrf.child(key).update(
                  {"task": newTask, "date": newDate, "done": false}).then((_) {
                // Task updated successfully
                print("Task updated successfully");
                setState(() {
                  // Update the task list in the state
                  gettask();
                });
              }).catchError((error) {
                // Handle error if update fails
                print("Error updating task: $error");
              });
            }
          });
        }
      }
    });
  }

  Future<void> edittask(String subName, String oldtask, String olddate) async {
    final TextEditingController data = TextEditingController(text: olddate);
    final TextEditingController task = TextEditingController(text: oldtask);
    DateTime? selectedDate =
        DateTime.now(); // Initialize selectedDate with a default value
    bool done = false;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Edit Task of $subName'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: task,
                  decoration: const InputDecoration(
                    labelText: 'Task',
                  ),
                ),
                TextField(
                  controller: data,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          initialDatePickerMode: DatePickerMode.day,
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: const Text('Select Date'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(selectedDate!);
                        updateTask(olddate, oldtask, task.text, formattedDate);
                        Navigator.pop(context);
                      },
                      child: const Text('Save Task'),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  void initState() {
    gettask();
    super.initState();
  }

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
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Text(
                  "Hi! ${widget.studentName} ${widget.subjectName}'s Tasks",
                  style: const TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    inputdialog(widget.subjectName);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(
                            255, 255, 201, 219)), // Change color here
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Add Task",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: alltaskList.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.only(left: 12, right: 12, top: 10),
                    padding: const EdgeInsets.only(left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 255, 237, 194)),
                    child: Container(
                      height: 300,
                      child: ListTile(
                        leading: InkWell(
                          onTap: () {
                            markdone(
                                alltaskList[index]["date"],
                                alltaskList[index]["task"],
                                alltaskList[index]["done"]);
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                color: const Color.fromARGB(
                                    255, 244, 130, 54), // Border color
                                width: 3, // Border width
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          alltaskList[index]["task"],
                          style: TextStyle(
                            fontSize: 20,
                            decoration: alltaskList[index]["done"]
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text("Due Date: ${alltaskList[index]["date"]}"),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                onPressed: () {
                                  deleteTask(
                                    alltaskList[index]["date"],
                                    alltaskList[index]["task"],
                                  );
                                },
                                icon: const Icon(Icons.delete_outline)),
                            IconButton(
                                onPressed: () {
                                  edittask(
                                    widget.subjectName,
                                    alltaskList[index]["task"],
                                    alltaskList[index]["date"],
                                  );
                                },
                                icon: const Icon(Icons.edit_calendar_outlined)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom:
                10.0, // Adjust this value to change the distance from the bottom
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            subjects(stduentname: widget.studentName),
                      ),
                      (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 30.0),
                  backgroundColor: const Color.fromARGB(255, 154, 210, 255),
                ),
                child: Container(
                  width: 80.0, // Set width to decrease the width
                  child: const Center(
                    child: Text(
                      'Back',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white), // Adjust the font size here
                    ), // Text displayed on the button
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
