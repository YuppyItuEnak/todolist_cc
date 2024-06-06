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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("PriorityPal", style: TextStyle(fontWeight: FontWeight.bold),),
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
              children: [Expanded(child: DatePicker(
                DateTime.now(),
                height: 100,
                width: 60,
                initialSelectedDate: DateTime.now(),
                selectionColor: Color.fromRGBO(138, 43, 226, 1),
                selectedTextColor: Colors.white,
                dateTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
              ))],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildTaskItem('Project retrospective', '4:50 PM'),
                  _buildTaskItem('Evening team meeting', '4:50 PM'),
                  _buildTaskItem('Create monthly deck', 'Today'),
                  _buildTaskItem('Shop for groceries', '6:00 PM',
                      subtasks: ['Pick up bag', 'Rice', 'Meat']),
                
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildStatusCard(String title, String count, Color color) {
  //   return Container(
  //     width: 80,
  //     height: 80,
  //     decoration: BoxDecoration(
  //       color: color.withOpacity(0.2),
  //       borderRadius: BorderRadius.circular(15.0),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(
  //           count,
  //           style: TextStyle(
  //             fontSize: 24.0,
  //             color: color,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         SizedBox(height: 5),
  //         Text(
  //           title,
  //           style: TextStyle(fontSize: 16.0, color: color),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTaskItem(String title, String time, {List<String>? subtasks}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.radio_button_unchecked),
        title: Text(title),
        subtitle: subtasks != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(time),
                  SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        subtasks.map((subtask) => Text('- $subtask')).toList(),
                  ),
                ],
              )
            : Text(time),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
