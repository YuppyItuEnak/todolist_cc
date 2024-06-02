import 'package:flutter/material.dart';
import 'package:todolist_cc/services/Auth_Service.dart';
import 'package:todolist_cc/views/pages/home.dart';
import 'package:todolist_cc/views/pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = signup();
  Authclass authclass = Authclass();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? token = await authclass.getToken();
    print("tokne");
    if (token != null)
      setState(() {
        currentPage = homepage();
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: currentPage,
    );
  }
}
