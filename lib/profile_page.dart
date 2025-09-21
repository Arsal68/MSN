import 'package:flutter/material.dart';
import 'package:msn_project/login_page.dart';
import 'package:msn_project/admin_login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedProfile = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 31, 69),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select your profile',
              style: TextStyle(
                fontFamily: 'Mclaren',
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  showCheckmark: false,
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 40,
                        color: selectedProfile == 'user'
                            ? Colors.white
                            : Color.fromARGB(255, 207, 28, 50),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "USER",
                        style: TextStyle(
                          color: selectedProfile == 'user'
                              ? Colors.white
                              : Color.fromARGB(255, 207, 28, 50),
                        ),
                      ),
                    ],
                  ),
                  selected: selectedProfile == 'user',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedProfile = selected ? 'user' : '';
                    });
                  },
                  selectedColor: Color.fromARGB(255, 207, 28, 50),
                  backgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),

                const SizedBox(width: 15),

                // ADMIN ChoiceChip
                ChoiceChip(
                  elevation: 40,
                  showCheckmark: false,
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_person,
                        size: 40,
                        color: selectedProfile == 'admin'
                            ? Colors.white
                            : Color.fromARGB(255, 207, 28, 50),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "ADMIN",
                        style: TextStyle(
                          color: selectedProfile == 'admin'
                              ? Colors.white
                              : Color.fromARGB(255, 207, 28, 50),
                        ),
                      ),
                    ],
                  ),
                  selected: selectedProfile == 'admin',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedProfile = selected ? 'admin' : '';
                    });
                  },
                  selectedColor: Color.fromARGB(255, 207, 28, 50),
                  backgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint(selectedProfile);
                  selectedProfile == "admin"
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminLoginPage(),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 40,
                  backgroundColor: Color.fromARGB(255, 207, 28, 50),
                ),
                child: Text(
                  "Proceed",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "Mclaren",
                    fontWeight: FontWeight.bold,
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
