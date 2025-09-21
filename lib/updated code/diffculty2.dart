import 'dart:ui';
import 'package:flutter/material.dart';

class DifficultySelectionPage extends StatelessWidget {
  const DifficultySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> difficulties = [
      {
        "name": "Beginner",
        "color": const Color(0xFF4CAF50),
        "icon": Icons.star_border,
      },
      {
        "name": "Intermediate",
        "color": const Color(0xFF2196F3),
        "icon": Icons.trending_up,
      },
      {
        "name": "Advanced",
        "color": const Color(0xFFFF9800),
        "icon": Icons.flash_on,
      },
      {
        "name": "Expert",
        "color": const Color(0xFFE91E63),
        "icon": Icons.workspace_premium,
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Select Difficulty",
          style: TextStyle(
            fontFamily: "McLaren",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1F2243), Color(0xFF4A4E91)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 90),
            child: GridView.builder(
              itemCount: difficulties.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                final difficulty = difficulties[index];
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => QuizPage(
                    //       selectedDifficulty: difficulty["name"].toLowerCase(),
                    //     ),
                    //   ),
                    // );
                  },
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.9, end: 1),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    difficulty["icon"],
                                    size: 40,
                                    color: difficulty["color"],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    difficulty["name"],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: difficulty["color"],
                                      fontFamily: "McLaren",
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Tap to start",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 20),

            child: Text(
              "Note: uopn selecting a difficulty, the quiz will start immediately.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
