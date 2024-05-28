import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseServices {
  final DatabaseReference _teamsRef =
      FirebaseDatabase.instance.ref().child('Teams');

  Future<List<String>> fetchTeamMembers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userEmail = user.email;
    final snapshot =
        await _teamsRef.orderByChild('teamOwner').equalTo(userEmail).once();

    if (snapshot.snapshot.value == null) {
      return [];
    }

    final teamsData = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
    List<String> teamMembers = [];
    teamsData.forEach((key, value) {
      String memberWithRole = '${value['fullName']} (${value['role']})';
      teamMembers.add(memberWithRole);
    });

    return teamMembers;
  }

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

    final newProjectRef =
        FirebaseDatabase.instance.ref().child('Projects').push();
    await newProjectRef.set({
      'title': title,
      'details': details,
      'teamMembers': teamMembers,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'userEmail': userEmail,
    });
  }

  Future<void> addTeam({
    required String fullName,
    required String email,
    required String role,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userEmail = user.email;
    final newTeamRef = _teamsRef.push();
    await newTeamRef.set({
      'fullName': fullName,
      'email': email,
      'role': role,
      'teamOwner': userEmail,
    });
  }
}
