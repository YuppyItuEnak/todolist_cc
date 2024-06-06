import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todolist_cc/services/Auth_Service.dart';
import 'package:todolist_cc/views/pages/addForm.dart';
import 'package:todolist_cc/views/pages/signup.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  Authclass authclass = Authclass();

  Stream<List<Map<String, dynamic>>> _getTasks() {
    return FirebaseFirestore.instance
        .collection('ToDoCC')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'title': doc['title'],
                'description': doc['description'],
                'dateTime': (doc['dateTime'] as Timestamp).toDate(),
              })
          .toList();
    });
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
                        DateFormat.yMMMMd().format(DateTime.now()),
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
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Color.fromRGBO(138, 43, 226, 1),
                  selectedTextColor: Colors.white,
                  dateTextStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ))
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No tasks available'));
                  } else {
                    List<Map<String, dynamic>> tasks = snapshot.data!;
                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> task = tasks[index];
                        return _buildTaskItem(
                          task['title'],
                          DateFormat('hh:mm a').format(task['dateTime']),
                          DateFormat('yMd').format(task['dateTime']),
                          description: task['description'],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String title, String date, String time,
      {String? description}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.radio_button_unchecked),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(date),
                Text(" at "),
                Text(time)
              ],
            ),
            if (description != null) ...[
              SizedBox(height: 5),
              Text(description),
            ]
          ],
        ),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
