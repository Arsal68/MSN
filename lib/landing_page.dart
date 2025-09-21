import 'package:flutter/material.dart';
import 'package:msn_project/login_page.dart';
import 'package:msn_project/signup_page.dart';
import 'package:msn_project/profile_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1D1F45), // White background for cleaner look
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 25),

                  // Title text
                  Text(
                    'Welcome to \nMSN ACADEMY',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 207, 28, 50),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Mclaren",
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Subtext / tagline
                  Text(
                    "Learn • Grow • Succeed",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // LOGIN button
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint("Navigating to profile page");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 207, 28, 50),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: const Color.fromARGB(
                          255,
                          207,
                          28,
                          50,
                        ).withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SIGNUP button
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint("Navigating to signup page");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 207, 28, 50),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: const Color.fromARGB(
                          255,
                          207,
                          28,
                          50,
                        ).withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'SIGNUP',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
