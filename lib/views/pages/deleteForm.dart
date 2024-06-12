import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist_cc/views/pages/home.dart';

class AddForm extends StatefulWidget {
  final String? taskId;
  final String? currentTitle;
  final String? currentDescription;
  final DateTime? currentDateTime;

  const AddForm({
    Key? key,
    this.taskId,
    this.currentTitle,
    this.currentDescription,
    this.currentDateTime,
  }) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _titleController.text = widget.currentTitle!;
      _descriptionController.text = widget.currentDescription!;
      _selectedDate = widget.currentDateTime!;
    }
  }

  Future<void> _deleteTask() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && widget.taskId != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Tasks')
          .doc(widget.taskId)
          .delete();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => homepage()),
          (route) => false);
    }
  }

  void _confirmDeleteTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTask();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (widget.taskId == null) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .collection('Tasks')
              .add({
            'title': _titleController.text,
            'description': _descriptionController.text,
            'dateTime': _selectedDate,
          });
        } else {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .collection('Tasks')
              .doc(widget.taskId)
              .update({
            'title': _titleController.text,
            'description': _descriptionController.text,
            'dateTime': _selectedDate,
          });
        }

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
          widget.taskId == null ? "Add Task" : "Edit Task",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text(widget.taskId == null ? "Add" : "Save"),
              ),
              if (widget.taskId != null) ...[
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _confirmDeleteTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text("Delete"),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
