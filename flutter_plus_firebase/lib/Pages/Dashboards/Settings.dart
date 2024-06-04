import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

import 'package:pmanager/Pages/Dashboards/Teams.dart';
import 'package:pmanager/Pages/landing_page.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notification = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/avatar.png'),
              ),
            ),
            SizedBox(height: 20),
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            SettingsTile(
              icon: Icons.notifications,
              title: 'Notifications',
              trailing: Switch(
                value: notification,
                onChanged: (newValue) {
                  setState(() {
                    notification = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            SettingsTile(
              icon: Icons.lock,
              title: 'Password',
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdatePasswordScreen()),
                );
              },
            ),
            SizedBox(height: 10),
            SettingsTile(
              icon: Icons.logout,
              title: 'Logout',
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle logout logic
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) =>
                      logoutConfirmationBottomSheet(context),
                );
              },
            ),
            SizedBox(height: 10),
            SettingsTile(
              icon: Icons.group,
              title: 'Teams',
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Teams()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  SettingsTile({
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: trailing,
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      tileColor: Colors.white,
      selectedTileColor: Colors.grey[200],
      selected: false,
    );
  }
}

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _oldPasswordController,
                      obscureText:
                          !_showOldPassword, // Toggle visibility based on state
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min, // Row doesn't expand
                          children: [
                            IconButton(
                              icon: Icon(Icons.visibility),
                              onPressed: () => setState(
                                  () => _showOldPassword = !_showOldPassword),
                            ),
                          ],
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your old password.';
                        }
                        return null; // Pass validation if no errors
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0), // Add spacing between TextFields
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _newPasswordController,
                      obscureText:
                          !_showNewPassword, // Toggle visibility based on state
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min, // Row doesn't expand
                          children: [
                            IconButton(
                              icon: Icon(Icons.visibility),
                              onPressed: () => setState(
                                  () => _showNewPassword = !_showNewPassword),
                            ),
                          ],
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new password.';
                        }
                        return null; // Pass validation if no errors
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0), // Add spacing between TextFields
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText:
                          !_showConfirmPassword, // Toggle visibility based on state
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min, // Row doesn't expand
                          children: [
                            IconButton(
                              icon: Icon(Icons.visibility),
                              onPressed: () => setState(() =>
                                  _showConfirmPassword = !_showConfirmPassword),
                            ),
                          ],
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password.';
                        } else if (value != _newPasswordController.text) {
                          return 'Passwords do not match.';
                        }
                        return null; // Pass validation if no errors
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0), // Add spacing before button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    changePassword(
                        currentPassword: _oldPasswordController.text,
                        newPassword: _newPasswordController.text,
                        context: context);
                    developer.log('Passwords updated successfully!');
                  }
                },
                child: Text('Update Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No user is currently signed in."),
      ));
      return;
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    try {
      // Re-authenticate the user
      await user.reauthenticateWithCredential(credential);
      // Update the password
      await user.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password changed successfully."),
      ));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? "An error occurred."),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error occurred."),
      ));
    }
  }
}

Widget logoutConfirmationBottomSheet(context) {
  return Container(
    height: 300, // Adjust height as needed
    width: 400,
    padding: const EdgeInsets.all(20.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0), // Add rounded corners
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
      children: [
        const Text('Are you sure you want to log out?'),
        const SizedBox(height: 30.0), // Add spacing between text and buttons
        Column(
          // Replace the Row with a nested Column
          mainAxisSize: MainAxisSize.min, // Wrap content vertically
          children: [
            ElevatedButton(
              onPressed: () async {
                developer.log("Logout succesful");
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => landing_page()),
                      (Route<dynamic> route) => false);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Error logging out. Please try again.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color.fromARGB(255, 54, 52, 163),
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Text('Log Out'),
              ),
            ),
            const SizedBox(height: 10.0), // Add spacing between buttons

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color.fromARGB(255, 194, 49, 49),
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Text('Cancel'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
