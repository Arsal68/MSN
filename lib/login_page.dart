import 'package:flutter/material.dart';
import 'package:msn_project/dashboard.dart';
import 'package:msn_project/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var viewpass = true;
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<bool> loginuser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color.fromARGB(255, 207, 28, 50),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(
      //       bottom: Radius.circular(20), // Round bottom corners
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         debugPrint("Navigatin to landing page");
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => LandingPage()),
      //         );
      //       },
      //       icon: Icon(Icons.back_hand),
      //     ),
      //   ],
      //   title: const Text('Login', style: TextStyle(color: Colors.white)),
      // ),
      backgroundColor: Color.fromARGB(255, 29, 31, 69),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                debugPrint("Navigatin to singup page");
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
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Optional: rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "User Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: "Mclaren",
                            ),
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
                              if (!value.contains('@')) {
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
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final success = await loginuser();
                                if (success) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Dashboard(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Login failed. Please check your email and password.',
                                      ),
                                    ),
                                  );
                                }
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

                            child: Text(
                              "Login",
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
          ],
        ),
      ),
    );
  }
}
