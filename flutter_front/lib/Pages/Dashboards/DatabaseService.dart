import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseServices {
  final DatabaseReference _projectsRef =
      FirebaseDatabase.instance.ref().child('Projects');

  Future<void> createProject({
    required String title,
    required String details,
    required List<String> teamMembers,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userEmail = user.email;

    final newProjectRef = _projectsRef.push();
    await newProjectRef.set({
      'title': title,
      'details': details,
      'teamMembers': teamMembers,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'userEmail': userEmail,
    });
  }
}
