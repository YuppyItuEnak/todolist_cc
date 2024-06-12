import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todolist_cc/services/Auth_Service.dart';
import 'package:todolist_cc/services/Task_Service.dart';
import 'package:todolist_cc/views/pages/addForm.dart';
import 'package:todolist_cc/views/pages/updateForm.dart';
import 'package:todolist_cc/views/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';  

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  Authclass authclass = Authclass();
  DateTime _selectedDate = DateTime.now();
  TaskService taskService = TaskService();

  List<Map<String, dynamic>> _filterTasks(List<Map<String, dynamic>> tasks) {
    return tasks.where((task) {
      DateTime taskDate = task['dateTime'];
      return taskDate.year == _selectedDate.year &&
             taskDate.month == _selectedDate.month &&
             taskDate.day == _selectedDate.day;
    }).toList();
  }

  Future<void> _deleteTask(String taskId) async {
    User? user = FirebaseAuth.instance.currentUser;  
    if (user != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm Deletion"),
            content: Text("Are you sure you want to delete this task?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(user.uid)
                      .collection('Tasks')
                      .doc(taskId)
                      .delete();
                  Navigator.of(context).pop();
                },
                child: Text("Delete"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "PriorityPal",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () async {
                await authclass.logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => signup()),
                    (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(_selectedDate),
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      Text(
                        "Today's Task",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => AddForm()),
                        (route) => false);
                  },
                  child: Container(
                    width: 100,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueAccent),
                    child: Center(
                      child: Text(
                        "+ Add Task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                    child: DatePicker(
                  DateTime.now(),
                  height: 100,
                  width: 60,
                  initialSelectedDate: _selectedDate,
                  selectionColor: Colors.teal,
                  selectedTextColor: Colors.white,
                  dateTextStyle: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                  dayTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  monthTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  onDateChange: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                )),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: taskService.getTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('No tasks found', style: TextStyle(color: Colors.black),));
                  }
                  final tasks = snapshot.data!.docs.map((doc) {
                    return {
                      'id': doc.id,
                      'title': doc['title'],
                      'description': doc['description'],
                      'dateTime': (doc['dateTime'] as Timestamp).toDate(),
                    };
                  }).toList();

                  final filteredTasks = _filterTasks(tasks);

                  return ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blueAccent,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                task['description'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                DateFormat.yMMMMd()
                                    .add_jm()
                                    .format(task['dateTime']),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateForm(
                                            taskId: task['id'],
                                            currentTitle: task['title'],
                                            currentDescription: task['description'],
                                            currentDateTime: task['dateTime'],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.white),
                                    onPressed: () async {
                                      await _deleteTask(task['id']);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
