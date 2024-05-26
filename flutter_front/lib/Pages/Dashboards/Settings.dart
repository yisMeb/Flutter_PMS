import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:developer' as developer;

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
                    notification = newValue; // Update state on change
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
              },
            ),
            SizedBox(height: 10),
            SettingsTile(
              icon: Icons.group,
              title: 'Teams',
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
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
                    // Add logic to update password (placeholder for now)
                    print('Passwords updated successfully!');
                    // You can potentially access passed user info using widget.currentUser if provided
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
}
