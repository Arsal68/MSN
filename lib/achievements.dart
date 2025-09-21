import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final List<Map<String, dynamic>> achievements = [
    {
      "title": "First Step",
      "icon": MdiIcons.flagCheckered,
      "color": const Color(0xff4FACFE),
      "description": "Complete the first level of any subject.",
    },
    {
      "title": "Halfway Hero",
      "icon": MdiIcons.progressCheck,
      "color": const Color(0xffFF9F43),
      "description": "Complete one subject halfway (2 levels).",
    },
    {
      "title": "Master of One",
      "icon": MdiIcons.school,
      "color": const Color(0xff8E2DE2),
      "description": "Complete one subject fully.",
    },
    {
      "title": "Expert Unlocked",
      "icon": MdiIcons.brain,
      "color": const Color(0xffFF6B6B),
      "description": "Complete the Expert difficulty of any subject.",
    },
    {
      "title": "All-Rounder",
      "icon": MdiIcons.medal,
      "color": const Color(0xff20BF55),
      "description": "Complete four different subjects.",
    },
    {
      "title": "Quarter Milestone",
      "icon": MdiIcons.chartDonut,
      "color": const Color(0xffFFD93D),
      "description": "Reach 25% overall progress.",
    },
    {
      "title": "App Dev Master",
      "icon": MdiIcons.cellphoneLink,
      "color": const Color(0xffEB0000),
      "description": "Complete App Development fully.",
    },
    {
      "title": "Data Analyst Master",
      "icon": MdiIcons.chartLine,
      "color": const Color(0xff36D1DC),
      "description": "Complete Data Analyst fully.",
    },
    {
      "title": "Web Dev Master",
      "icon": MdiIcons.web,
      "color": const Color(0xff5B86E5),
      "description": "Complete Web Development fully.",
    },
    {
      "title": "Gen AI Master",
      "icon": MdiIcons.robot,
      "color": const Color(0xff6A11CB),
      "description": "Complete Gen AI fully.",
    },
    {
      "title": ".NET Master",
      "icon": MdiIcons.microsoftVisualStudio,
      "color": const Color(0xffF7971E),
      "description": "Complete Dot Net Development fully.",
    },
    {
      "title": "Design Master",
      "icon": MdiIcons.palette,
      "color": const Color(0xffFF512F),
      "description": "Complete Graphic Designing fully.",
    },
    {
      "title": "Marketing Master",
      "icon": MdiIcons.bullhorn,
      "color": const Color(0xff38EF7D),
      "description": "Complete Digital Marketing fully.",
    },
    {
      "title": "Python Master",
      "icon": MdiIcons.languagePython,
      "color": const Color(0xffFFD200),
      "description": "Complete Python Programming fully.",
    },
  ];

  /// Titles of achievements already unlocked by this user
  List<String> unlocked = [];

  @override
  void initState() {
    super.initState();
    _loadUnlocked();
  }

  Future<void> _loadUnlocked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snap = await FirebaseFirestore.instance
        .collection('user_progress')
        .doc(user.uid)
        .collection('achievements')
        .get();

    setState(() {
      unlocked = snap.docs.map((d) => d.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F5F9),
      appBar: AppBar(
        title: const Text(
          "Achievements",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: achievements.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final a = achievements[index];
            return AchievementCard(
              title: a['title'] as String,
              icon: a['icon'] as IconData,
              activeColor: a['color'] as Color,
              description: a['description'] as String,
              unlocked: unlocked.contains(a['title']),
            );
          },
        ),
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color activeColor;
  final String description;
  final bool unlocked;

  const AchievementCard({
    super.key,
    required this.title,
    required this.icon,
    required this.activeColor,
    required this.description,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    final Color displayColor = unlocked ? activeColor : Colors.grey.shade400;

    return GestureDetector(
      onTap: () {
        if (!unlocked) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              title,
              style: TextStyle(
                color: displayColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(description),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [displayColor.withOpacity(0.15), Colors.white12],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: displayColor, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: displayColor.withOpacity(0.2),
              child: Icon(icon, size: 30, color: displayColor),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontFamily: "Mclaren",
                color: unlocked ? Colors.black : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
