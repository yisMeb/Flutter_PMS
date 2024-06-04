import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pmanager/Pages/Dashboards/home_Dashboard.dart';
import 'package:pmanager/Pages/auth_service.dart';
import 'dart:developer' as developer;

import 'package:pmanager/Pages/landing_page.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  String email = '';
  String? verificationCode;
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
                      labelText: 'Enter Email',
                    ),
                    onChanged: (value) => email = value,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      resetPassword(email);
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
                      child: Text('Send Reset Link'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pushNamed(context, '/login');
      // Show a success message or dialog to the user
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'The email address is not associated with an account.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
      } else {
        errorMessage = 'An error occurred. Please try again later.';
      }
    }
  }
}
