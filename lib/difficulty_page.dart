import 'quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DifficultySelectionPage extends StatefulWidget {
  final String subject;

  const DifficultySelectionPage({super.key, required this.subject});

  @override
  State<DifficultySelectionPage> createState() =>
      _DifficultySelectionPageState();
}

class _DifficultySelectionPageState extends State<DifficultySelectionPage> {
  Map<String, dynamic> difficultyStatus = {};
  bool isLoading = true;

  final List<String> difficulties = [
    "beginner",
    "intermediate",
    "advanced",
    "expert",
  ];

  @override
  void initState() {
    super.initState();
    fetchDifficultyStatus();
  }

  /// Fetch difficulty unlock + completion status from Firestore
  Future<void> fetchDifficultyStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection("user_progress")
        .doc(user.uid);
    final snapshot = await docRef.get();

    if (snapshot.exists) {
      final data = snapshot.data() ?? {};
      setState(() {
        difficultyStatus =
            data[widget.subject.toLowerCase()] ??
            {
              "beginner": {"unlocked": true, "completed": false},
              "intermediate": {"unlocked": false, "completed": false},
              "advanced": {"unlocked": false, "completed": false},
              "expert": {"unlocked": false, "completed": false},
            };
        isLoading = false;
      });
    } else {
      // If no data, create default structure
      difficultyStatus = {
        "beginner": {"unlocked": true, "completed": false},
        "intermediate": {"unlocked": false, "completed": false},
        "advanced": {"unlocked": false, "completed": false},
        "expert": {"unlocked": false, "completed": false},
      };

      await FirebaseFirestore.instance
          .collection("user_progress")
          .doc(user.uid)
          .set({
            widget.subject.toLowerCase(): difficultyStatus,
          }, SetOptions(merge: true));

      setState(() => isLoading = false);
    }
  }

  /// Mark difficulty as completed and unlock next one
  Future<void> completeDifficulty(String difficulty) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDocRef = FirebaseFirestore.instance
        .collection("user_progress")
        .doc(user.uid);
    final snapshot = await userDocRef.get();

    double overallProgress = 0.0;

    // Get the current stored progress if exists
    if (snapshot.exists && snapshot.data()!.containsKey("overall_progress")) {
      overallProgress = snapshot["overall_progress"] ?? 0.0;
    }

    final nextIndex = difficulties.indexOf(difficulty) + 1;

    // Check if this difficulty was already completed
    bool wasAlreadyCompleted =
        difficultyStatus[difficulty]?["completed"] ?? false;

    // Mark current difficulty as completed
    difficultyStatus[difficulty] = {"unlocked": true, "completed": true};

    // Unlock next difficulty if exists
    if (nextIndex < difficulties.length) {
      final nextDifficulty = difficulties[nextIndex];
      difficultyStatus[nextDifficulty] = {
        "unlocked": true,
        "completed": difficultyStatus[nextDifficulty]?["completed"] ?? false,
      };
    }

    // ✅ Increment overall progress only if this is the first time completing
    if (!wasAlreadyCompleted) {
      overallProgress += 100 / 32; // ~3.125% per level
      if (overallProgress > 100) overallProgress = 100;
    }

    // ✅ Update Firestore with difficulty progress + overall progress
    await userDocRef.set({
      widget.subject.toLowerCase(): difficultyStatus,
      "overall_progress": overallProgress,
    }, SetOptions(merge: true));

    setState(() {});
  }

  /// Start quiz and mark completion after quiz ends
  void startQuiz(String difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPage(
          subject: widget.subject,
          difficulty: difficulty,
          onQuizCompleted: () async {
            await completeDifficulty(difficulty);
          },
        ),
      ),
    ).then((_) {
      // Refresh status when returning from quiz
      fetchDifficultyStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1D1F45)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Difficulty",
          style: TextStyle(
            fontFamily: "McLaren",
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1D1F45),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: difficulties.length,
          itemBuilder: (context, index) {
            final difficulty = difficulties[index];
            final status =
                difficultyStatus[difficulty] ??
                {"unlocked": false, "completed": false};

            final isUnlocked = status["unlocked"] ?? false;
            final isCompleted = status["completed"] ?? false;

            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: ListTile(
                leading: Icon(
                  isUnlocked
                      ? (isCompleted ? Icons.check_circle : Icons.lock_open)
                      : Icons.lock,
                  color: isUnlocked
                      ? (isCompleted ? Colors.green : Colors.blue)
                      : Colors.grey,
                  size: 30,
                ),
                title: Text(
                  difficulty[0].toUpperCase() + difficulty.substring(1),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? Colors.black : Colors.grey,
                  ),
                ),
                subtitle: Text(
                  isCompleted ? "Completed" : "Not Completed",
                  style: TextStyle(
                    fontSize: 14,
                    color: isCompleted ? Colors.green : Colors.grey,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: isUnlocked ? () => startQuiz(difficulty) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUnlocked
                        ? const Color(0xFF1D1F45)
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isUnlocked ? (isCompleted ? "Retry" : "Start") : "Locked",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
