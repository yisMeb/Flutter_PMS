import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pmanager/Pages/Dashboards/home_Dashboard.dart';
import 'package:pmanager/Pages/auth_service.dart';
import 'dart:developer' as developer;

import 'package:pmanager/Pages/landing_page.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _LoginPageState();
}

class _LoginPageState extends State<login_page> {
  final _auth = AuthService();
  String? email;
  String? password;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100), // Space for the logo
            Image.asset(
              "images/logo.png", // Path to your logo image asset
              height: 100,
            ),
            const SizedBox(height: 20), // Space between logo and form fields

            errorMessage != null
                ? Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  )
                : const SizedBox(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    onChanged: (value) => email = value,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    onChanged: (value) => password = value,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        //  forgot password
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      //  login
                      _login();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color.fromARGB(255, 54, 52, 163),
                      foregroundColor: Colors.white,
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      child: Text('LogIn'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _login() async {
    final user = await _auth.loginUserwithEmailandPassword(
        email.toString(), password.toString());
    if (user != null) {
      developer.log("Login Success");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeDashboard()),
      );
    } else {
      setState(() {
        errorMessage = "Login Failed. Please check your credentials.";
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
