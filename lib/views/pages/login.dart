import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:todolist_cc/services/Auth_Service.dart';
import 'package:todolist_cc/views/pages/home.dart';
import 'package:todolist_cc/views/pages/signup.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool circular = false;
  Authclass authclass = Authclass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/bear_icon.png', height: 100, width: 100),
              Text(
                "Login",
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  authclass.googleSignIn(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 60,
                  child: Card(
                    color: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(width: 1, color: Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Continue with Google",
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "or",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 15,
              ),
              textInputItem("Email ...", _emailController, false),
              SizedBox(
                height: 15,
              ),
              textInputItem("Password ...", _passwordController, true),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    circular = true;
                  });
                  try {
                    firebase_auth.UserCredential userCredential =
                        await firebaseAuth.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text);
                    print(userCredential.user?.email);
                    setState(() {
                      circular = false;
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => homepage()),
                        (route) => false);
                  } catch (e) {
                    final snackbar = SnackBar(content: Text(e.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    setState(() {
                      circular = false;
                    });
                  }
                },
                child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.teal),
                    child: Center(
                      child: circular
                          ? CircularProgressIndicator()
                          : Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "If you don't have an account?",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => signup()),
                      (route) => false);
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textInputItem(
      String labelText, TextEditingController controller, bool obscuretext) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obscuretext,
        style: TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(fontSize: 17, color: Colors.black),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(width: 1.5, color: Colors.blue)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(width: 1, color: Colors.grey))),
      ),
    );
  }
}
