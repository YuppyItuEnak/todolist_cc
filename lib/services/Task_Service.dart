import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getTasks() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Tasks')
          .snapshots();
    }
    return Stream.empty();
  }
}
