import 'package:flutter/material.dart';

class landing_page extends StatelessWidget {
  const landing_page({super.key});

  @override
  Widget build(BuildContext context) {
    return 
       Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: 1,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.all(60),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Image.asset(
                          "images/welsom.png",
                          height: 300,
                        ),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 39,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "Let US Help You ",
                              ),
                              TextSpan(
                                text: "Manage",
                                style: TextStyle(color: Color.fromARGB(255, 54, 52, 163)),
                              ),
                              TextSpan(
                                text: " Your Project",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 55,
              margin: const EdgeInsets.all(45),
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: 
                  IconButton(
                    onPressed: () {
                          Navigator.pushNamed(context, '/login');
                    },
                    icon: const Icon(
                      Icons.arrow_circle_right,
                      size: 66, // Increased size to 35
                      color: Color.fromARGB(255, 54, 52, 163), // Changed color to white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
