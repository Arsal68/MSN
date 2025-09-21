import 'package:flutter/material.dart';
import 'package:msn_project/login_page.dart';
import 'package:msn_project/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var viewpass = true;
  bool isLoading = false; // Loading state
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> signupUser() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );

      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        'username': username.text.trim(),
        'userid': uid,
        'avatar': 'school',
        'progress': 0,
        "badges": [],
        'certificates': [],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User  account created successfully!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for this email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = e.message ?? 'Signup failed';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Something went wrong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 31, 69),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                debugPrint("Navigating to signup page");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              },
              child: Image.asset(
                "assets/images/logo.png",
                width: 200,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                elevation: 60,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 29, 31, 69),
                    border: Border.all(
                      width: 2,
                      color: Color.fromARGB(255, 207, 28, 50),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "SignUp",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: "Mclaren",
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: username,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 207, 28, 50),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 234, 0),
                                  width: 3,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.account_box,
                                color: Color.fromARGB(255, 207, 28, 50),
                                size: 30,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: email,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 207, 28, 50),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 234, 0),
                                  width: 3,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                size: 30,
                                color: Color.fromARGB(255, 207, 28, 50),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter an email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: password,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 207, 28, 50),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 234, 0),
                                  width: 3,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                size: 30,
                                color: Color.fromARGB(255, 207, 28, 50),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    viewpass = !viewpass;
                                  });
                                },
                                icon: Icon(
                                  viewpass
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 25,
                                  color: Color.fromARGB(255, 207, 28, 50),
                                ),
                              ),
                            ),
                            obscureText: viewpass,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true; // Set loading to true
                                      });
                                      await signupUser();
                                      setState(() {
                                        isLoading =
                                            false; // Reset loading to false
                                      });
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 207, 28, 50),
                              foregroundColor: Colors.white,
                              elevation: 30,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  ) // Show loading indicator
                                : Text(
                                    "Sign up",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: "Mclaren",
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                "Already have an account?\nLogin here",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontFamily: "Mclaren",
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
