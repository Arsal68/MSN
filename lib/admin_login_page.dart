import 'package:flutter/material.dart';
import 'package:msn_project/login_page.dart';
import 'package:msn_project/landing_page.dart';

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    final adminID = TextEditingController();
    final passcode = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 31, 69),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                debugPrint("Navigatin to Landing page");
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                            "Admin Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: "Mclaren",
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: adminID,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Admin ID",
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
                                Icons.admin_panel_settings,
                                size: 30,
                                color: Color.fromARGB(255, 207, 28, 50),
                              ),
                              // filled: true,
                              // fillColor: Color.fromARGB(255, 207, 28, 50),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: passcode,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Passcode",
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
                                Icons.vpn_key,
                                size: 30,
                                color: Color.fromARGB(255, 207, 28, 50),
                              ),
                              // filled: true,
                              // fillColor: Color.fromARGB(255, 207, 28, 50),
                            ),
                          ),
                          SizedBox(height: 15),

                          ElevatedButton(
                            onPressed: () {
                              print(adminID.text);
                              print(passcode.text);
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
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: "Mclaren",
                                fontWeight: FontWeight.bold,
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
                "Not an Admin?\nClick here",
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
