import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pmanager/Pages/Dashboards/home_Dashboard.dart';
import 'dart:developer' as developer;
import 'package:pmanager/Pages/auth_service.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _MySignupState();
}

class _MySignupState extends State<Signup> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String? _fullName;
  String? _email;
  String? _password;
  String? errorMessage;

  bool _validateFields() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100), // Top space for the logo
            Image.asset(
              "images/logo.png", // Logo image asset
              height: 100,
            ),
            const SizedBox(height: 20), // Space between logo and form fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                onChanged: () => setState(() {}),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                      ),
                      onChanged: (value) => _fullName = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    errorMessage != null
                        ? Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          )
                        : const SizedBox(),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      onChanged: (value) => _email = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      onChanged: (value) => _password = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _validateFields()
                          ? () {
                              // Perform signup
                              _signUp();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color.fromARGB(255, 54, 52, 163),
                        foregroundColor: Colors.white,
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: Text('Sign Up'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            // Left divider
                            thickness: 1,
                            color: Colors.grey,
                            indent: 20.0,
                            endIndent: 20.0,
                          ),
                        ),
                        Padding(
                          // Center text
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            // Right divider
                            thickness: 1,
                            color: Colors.grey,
                            indent: 20.0,
                            endIndent: 20.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(color: Colors.black, width: 0.5),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        maximumSize: const Size(250.0, 40.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/google_icon.png",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text('Sign In with Google'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 163, 245),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text('Log In'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signUp() async {
    final user = await _auth.createUserwithEmailandPassword(
        _email.toString(), _password.toString());
    if (user != null) {
      developer.log("Success");
      await FirebaseDatabase.instance.ref().child('users').child(user.uid).set({
        'fullName': _fullName,
        'email': _email,
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeDashboard()),
      );
    } else {
      developer.log("SignUp Failed");
      setState(() {
        errorMessage = "SignUp Failed. Please try again later";
      });
      developer.log("Login Failed");
    }
  }

  _signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.user?.displayName);

    if (userCredential.user != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeDashboard()));
    }
  }
}
