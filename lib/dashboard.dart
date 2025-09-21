import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:msn_project/subjects.dart';
import 'package:msn_project/achievements.dart';
import 'package:msn_project/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:msn_project/difficulty_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:msn_project/provider/subject_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  IconData _selectedIcon = MdiIcons.cat;
  Color _selectedColor = const Color.fromARGB(255, 255, 204, 0);

  final List<IconData> _availableIcons = [
    MdiIcons.wizardHat,
    MdiIcons.chessKnight,
    MdiIcons.alien,
    MdiIcons.unicorn,
    MdiIcons.robot,
    MdiIcons.ninja,
    MdiIcons.emoticonCool,
    MdiIcons.accountCowboyHat,
    MdiIcons.dog,
    MdiIcons.cat,
    MdiIcons.magicStaff,
    MdiIcons.shieldSword,
  ];

  final List<Color> _availableColors = [
    const Color.fromARGB(255, 255, 255, 255),
    const Color.fromARGB(255, 141, 80, 246),
    Colors.redAccent,
    const Color.fromARGB(255, 1, 22, 176),
    Colors.amber,
    const Color.fromARGB(255, 17, 255, 25),
    Colors.orange,
    const Color.fromARGB(255, 255, 49, 118),
    const Color.fromARGB(255, 113, 113, 113),
    Colors.cyan,
  ];

  void _showIconPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        IconData? tempIcon = _selectedIcon;
        Color? tempColor = _selectedColor;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Choose an Avatar Icon",
                      style: TextStyle(
                        fontFamily: "Mclaren",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _availableIcons.map((iconData) {
                        return GestureDetector(
                          onTap: () {
                            setModalState(() => tempIcon = iconData);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: tempIcon == iconData
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: tempIcon == iconData
                                    ? Colors.white
                                    : Colors.grey.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Icon(iconData, size: 40, color: tempColor),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Pick a Color",
                      style: TextStyle(
                        fontFamily: "Mclaren",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      children: _availableColors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            setModalState(() => tempColor = color);
                          },
                          child: CircleAvatar(
                            backgroundColor: color,
                            radius: 20,
                            child: tempColor == color
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedIcon = tempIcon!;
                            _selectedColor = tempColor!;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Apply",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Mclaren",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjectProvider = Provider.of<SubjectProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 6,
        shadowColor: Colors.black54,
        title: const Text(
          "Dashboard",
          style: TextStyle(fontFamily: "Mclaren", color: Colors.black),
          textAlign: TextAlign.center,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.black, size: 28),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("user_progress")
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final overallProgress = ((data["overall_progress"] ?? 0.0) / 100.0);
          final subjectKey = subjectProvider.selectedSubject.toLowerCase();
          final subjectData = data[subjectKey] as Map<String, dynamic>? ?? {};

          int completed = 0;
          for (var level in [
            "beginner",
            "intermediate",
            "advanced",
            "expert",
          ]) {
            if (subjectData[level] is Map &&
                subjectData[level]["completed"] == true) {
              completed++;
            }
          }
          final subjectProgress = completed / 4;

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 72, 77, 171),
                          Color.fromARGB(255, 29, 31, 69),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header + Avatar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ✅ Fetch user's name from Firestore (collection 'user', field 'name')
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user?.uid)
                                  .snapshots(),
                              builder: (context, nameSnapshot) {
                                if (!nameSnapshot.hasData ||
                                    nameSnapshot.data == null) {
                                  return const Text(
                                    "Welcome...",
                                    style: TextStyle(
                                      fontSize: 26,
                                      color: Colors.white,
                                      fontFamily: "Mclaren",
                                    ),
                                  );
                                }
                                final nameData =
                                    nameSnapshot.data!.data()
                                        as Map<String, dynamic>? ??
                                    {};
                                final displayName =
                                    nameData['username'] ?? 'User';
                                return Text(
                                  "Welcome $displayName",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontFamily: "Mclaren",
                                  ),
                                );
                              },
                            ),
                            GestureDetector(
                              onTap: _showIconPicker,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      0,
                                      93,
                                      224,
                                    ),
                                    width: 3,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: const Color.fromARGB(
                                    0,
                                    29,
                                    31,
                                    69,
                                  ),
                                  radius: 32,
                                  child: Icon(
                                    _selectedIcon,
                                    color: _selectedColor,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // 🔹 Subject Progress Bar
                        buildProgressBar(
                          value: subjectProgress,
                          label: "Subject Progress",
                          progressColor: Colors.yellow,
                          labelColor: Colors.white,
                          percentageColor: Colors.white,
                        ),

                        // 🔹 Overall Progress Bar
                        buildProgressBar(
                          value: overallProgress,
                          label: "Overall Progress",
                          progressColor: Colors.greenAccent,
                          labelColor: Colors.white,
                          percentageColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                DashboardCards(
                  title: "Let's Get Started",
                  subtitle: subjectProvider.selectedSubject.isEmpty
                      ? "Select a subject to begin"
                      : "Put your ${subjectProvider.selectedSubject} knowledge to the test!",
                  icon: Icons.play_arrow_rounded,
                  color: const Color(0xffFF4B5C),
                  onTap: () {
                    if (subjectProvider.selectedSubject.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please select a subject before starting!",
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DifficultySelectionPage(
                            subject: subjectProvider.selectedSubject,
                          ),
                        ),
                      );
                    }
                  },
                ),

                DashboardCards(
                  title: "Subjects",
                  subtitle: subjectProvider.selectedSubject.isEmpty
                      ? "Select a subject"
                      : "Current: ${subjectProvider.selectedSubject}",
                  icon: Icons.auto_stories,
                  color: const Color(0xff20BF55),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Subjects()),
                  ),
                ),

                DashboardCards(
                  title: "Achievements",
                  subtitle: "See your achievements here",
                  icon: Icons.emoji_events,
                  color: const Color(0xffFBC02D),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AchievementsPage()),
                  ),
                ),

                const DashboardCards(
                  title: "Certificate",
                  subtitle: "Click here to generate your certificate",
                  icon: Icons.workspace_premium,
                  color: Color(0xff9C27B0),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 🔹 Dashboard Cards Widget
class DashboardCards extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const DashboardCards({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: "Mclaren",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Mclaren",
                color: Colors.white70,
              ),
            ),
            trailing: Icon(icon, size: 40, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// 🔹 Progress Bar Widget
Widget buildProgressBar({
  required double value,
  required String label,
  Color progressColor = Colors.blue,
  Color labelColor = Colors.black,
  Color percentageColor = Colors.black54,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: "Mclaren",
          color: labelColor,
        ),
      ),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 14,
          backgroundColor: Colors.white.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        "${(value * 100).toInt()}%",
        style: TextStyle(
          fontSize: 13,
          fontFamily: "Mclaren",
          color: percentageColor,
        ),
      ),
    ],
  );
}
