import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseServices {
  final DatabaseReference _teamsRef =
      FirebaseDatabase.instance.ref().child('Teams');
  final DatabaseReference _projectsRef =
      FirebaseDatabase.instance.ref().child('Projects');
  final DatabaseReference _subtasksRef =
      FirebaseDatabase.instance.ref().child('Subtasks');
  final DatabaseReference _tasksRef =
      FirebaseDatabase.instance.ref().child('Subtasks');
  final DatabaseReference _remindersRef =
      FirebaseDatabase.instance.ref().child('Reminders');

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

  Future<List<Map<String, dynamic>>> fetchProjects() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userEmail = user.email;
    final snapshot =
        await _projectsRef.orderByChild('userEmail').equalTo(userEmail).once();

    if (snapshot.snapshot.value == null) {
      return [];
    }

    final projectsData =
        Map<String, dynamic>.from(snapshot.snapshot.value as Map);
    List<Map<String, dynamic>> projectsList = [];
    projectsData.forEach((key, value) {
      Map<String, dynamic> project = Map<String, dynamic>.from(value as Map);
      projectsList.add(project);
    });

    return projectsList;
  }

  Future<void> createSubtask({
    required String taskName,
    required String taskDescription,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> selectedTeamMembers,
    required String projectName,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userEmail = user.email;

    final userEmailTaskName = '$userEmail-$taskName';

    final snapshot = await _subtasksRef
        .orderByChild('userEmail_taskName')
        .equalTo(userEmailTaskName)
        .once();

    if (snapshot.snapshot.value != null) {
      throw Exception('Task with the same name already exists');
    }

    final newSubtaskRef = _subtasksRef.push();
    await newSubtaskRef.set({
      'taskName': taskName,
      'taskDescription': taskDescription,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'userEmail': userEmail,
      'userEmail_taskName': userEmailTaskName,
      'selectedTeamMembers': selectedTeamMembers,
      'projectName': projectName,
      'isDone': false,
    });
  }

  Future<List<Map<String, dynamic>>> fetchTasks(
      {required String projectName}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userEmail = user.email;
    final snapshot =
        await _tasksRef.orderByChild('userEmail').equalTo(userEmail).once();

    if (snapshot.snapshot.value == null) {
      return [];
    }

    final tasksData = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
    List<Map<String, dynamic>> tasksList = [];
    tasksData.forEach((key, value) {
      Map<String, dynamic> task = Map<String, dynamic>.from(value as Map);
      if (task['projectName'] == projectName) {
        tasksList.add(task);
      }
    });

    return tasksList;
  }

  Future<void> deleteTask(String taskName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userEmail = user.email;

    final snapshot = await _tasksRef
        .orderByChild('userEmail_taskName')
        .equalTo('$userEmail-$taskName')
        .once();

    if (snapshot.snapshot.value != null) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      for (final entry in data.entries) {
        final taskKey = entry.key;
        await _tasksRef.child(taskKey).remove();
      }
    }
  }

  Future<void> markTaskAsDone(String taskName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userEmail = user.email;

    final snapshot = await _tasksRef
        .orderByChild('userEmail_taskName')
        .equalTo('$userEmail-$taskName')
        .once();

    if (snapshot.snapshot.value != null) {
      final tasksData =
          Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      tasksData.forEach((key, value) async {
        final taskKey = key;
        await _tasksRef.child(taskKey).update({'isDone': true});
      });
    }
  }

  Future<int> fetchSubtaskCount(String projectName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userEmail = user.email;
    final snapshot = await _subtasksRef
        .orderByChild('projectName')
        .equalTo(projectName)
        .once();

    if (snapshot.snapshot.value == null) {
      return 0;
    }

    final tasksData = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
    return tasksData.length;
  }

  Future<List<Map<String, dynamic>>> fetchSubtasks() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final DataSnapshot snapshot = await _subtasksRef
          .orderByChild('userEmail')
          .equalTo(user.email)
          .once()
          .then((event) => event.snapshot);

      if (snapshot.value != null) {
        final List<Map<String, dynamic>> subtasks = [];
        Map<dynamic, dynamic> data = snapshot.value as dynamic;
        data.forEach((key, value) {
          subtasks.add({
            'taskId': key,
            ...value,
          });
        });
        return subtasks;
      } else {
        return [];
      }
    } catch (error) {
      throw Exception('Failed to fetch subtasks: $error');
    }
  }

  Future<void> createReminder({
    required String title,
    required DateTime reminderTime,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final newReminderRef = _remindersRef.push();
    await newReminderRef.set({
      'title': title,
      'reminderTime': reminderTime.toIso8601String(),
      'userEmail': user.email,
    });
  }
}
