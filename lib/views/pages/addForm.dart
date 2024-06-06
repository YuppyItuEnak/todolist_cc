import 'package:flutter/material.dart';

void main() {
  runApp(AddFormApp());
}

class AddFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddFormScreen(),
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Color(0xFF1E1E1E),
      ),
    );
  }
}

class AddFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text('Create New Todo'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddForm(),
      ),
    );
  }
}

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Task Title', style: TextStyle(fontSize: 18, color: Colors.white)),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Task Title',
            filled: true,
            fillColor: Color(0xFF2C2C2C),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 16),
        Text('Description', style: TextStyle(fontSize: 18, color: Colors.white)),
        SizedBox(height: 8),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Task Description',
            filled: true,
            fillColor: Color(0xFF2C2C2C),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6200EE), // Background color
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Add Todo', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}
