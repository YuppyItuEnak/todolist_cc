import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist_cc/views/pages/home.dart';

class UpdateForm extends StatefulWidget {
  final String taskId;
  final String currentTitle;
  final String currentDescription;
  final DateTime currentDateTime;

  const UpdateForm({
    Key? key,
    required this.taskId,
    required this.currentTitle,
    required this.currentDescription,
    required this.currentDateTime,
  }) : super(key: key);

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _descController = TextEditingController(text: widget.currentDescription);
    _selectedDate = widget.currentDateTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.currentDateTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _updateTask() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DateTime taskDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Tasks')
            .doc(widget.taskId)
            .update({
          'title': _titleController.text,
          'description': _descController.text,
          'dateTime': Timestamp.fromDate(taskDateTime),
        });

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => homepage()),
            (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => homepage()),
                (route) => false);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(fontSize: 17, color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(width: 1.5, color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black))),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(width: 1.5, color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black))),
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Date: ${DateFormat('yMd').format(_selectedDate)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Choose Date'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Time: ${_selectedTime.format(context)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectTime(context),
                      child: Text('Choose Time'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _updateTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6200EE), // Background color
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
