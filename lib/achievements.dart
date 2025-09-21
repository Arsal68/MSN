import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Achievements extends StatelessWidget {
  const Achievements({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      {
        "title": "Quiz Champion",
        "icon": MdiIcons.trophy,
        "color": const Color(0xffFFD700),
        "description": "Won multiple quizzes with high scores.",
      },
      {
        "title": "Fast Learner",
        "icon": MdiIcons.rocketLaunch,
        "color": const Color(0xff4FACFE),
        "description": "Completed lessons quickly and efficiently.",
      },
      {
        "title": "Top Scorer",
        "icon": MdiIcons.starCircle,
        "color": const Color(0xffFF6B6B),
        "description": "Achieved top scores in assessments.",
      },
      {
        "title": "Streak Master",
        "icon": MdiIcons.fire,
        "color": const Color(0xffFF512F),
        "description": "Maintained a long learning streak.",
      },
      {
        "title": "Certificate Earned",
        "icon": MdiIcons.certificate,
        "color": const Color(0xff6A11CB),
        "description": "Earned a completion certificate.",
      },
      {
        "title": "Badge Collector",
        "icon": MdiIcons.medal,
        "color": const Color(0xff00C9A7),
        "description": "Collected multiple achievement badges.",
      },
      {
        "title": "Consistency Pro",
        "icon": MdiIcons.calendarCheck,
        "color": const Color(0xff20BF55),
        "description": "Logged in consistently every day.",
      },
      {
        "title": "Level Completed",
        "icon": MdiIcons.checkDecagram,
        "color": const Color(0xffFFD93D),
        "description": "Successfully completed a learning level.",
      },
      {
        "title": "Leaderboard King",
        "icon": MdiIcons.crown,
        "color": const Color(0xffFFB200),
        "description": "Ranked 1st on the leaderboard.",
      },
      {
        "title": "Problem Solver",
        "icon": MdiIcons.lightbulbOnOutline,
        "color": const Color(0xff36D1DC),
        "description": "Solved complex problems and puzzles.",
      },
      {
        "title": "Time Efficient",
        "icon": MdiIcons.clockCheckOutline,
        "color": const Color(0xffFF9F43),
        "description": "Completed tasks in record time.",
      },
      {
        "title": "Knowledge Seeker",
        "icon": MdiIcons.bookOpenPageVariant,
        "color": const Color(0xff8E2DE2),
        "description": "Explored and learned new concepts regularly.",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff1D1F45),
        title: const Text(
          "Achievements",
          style: TextStyle(
            fontFamily: "Mclaren",
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: achievements.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return AchievementCard(
              title: achievement['title'] as String,
              icon: achievement['icon'] as IconData,
              color: achievement['color'] as Color,
              description: achievement['description'] as String,
            );
          },
        ),
      ),
    );
  }
}

class AchievementCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;

  const AchievementCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });

  @override
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _showDescriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff252755),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(widget.icon, color: widget.color, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: "Mclaren",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          widget.description,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: "Mclaren",
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text("Close", style: TextStyle(fontFamily: "Mclaren")),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: () => _showDescriptionDialog(context),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color.withOpacity(0.15), Colors.white12],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: widget.color.withOpacity(0.8), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: widget.color.withOpacity(0.2),
                child: Icon(widget.icon, size: 30, color: widget.color),
              ),
              const SizedBox(height: 8),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "Mclaren",
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
