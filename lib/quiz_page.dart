import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends StatefulWidget {
  final String subject;
  final String difficulty;
  final Future<void> Function(int score) onQuizCompleted; // pass score

  const QuizPage({
    super.key,
    required this.subject,
    required this.difficulty,
    required this.onQuizCompleted,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  String? selectedOption;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<String> questionDocs = [
    "question 1",
    "question 2",
    "question 3",
    "question 4",
  ];
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;

  int timeLeft = 60;
  Timer? _timer;

  // Track correct answers
  int correctAnswers = 0;

  String _mapSubjectName(String subject) {
    switch (subject) {
      case "App Development":
        return "app dev";
      case "Web Development":
        return "web dev";
      case "Dot Net Development":
        return "dot net";
      case "Data Analyst":
        return "data analysis";
      case "Digital Marketing":
        return "digital marketing";
      case "Python Programming":
        return "python programming";
      case "Gen AI":
        return "gen ai";
      case "Graphic Designing":
        return "graphic designing";
      default:
        return subject.toLowerCase();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    _fetchQuestions();
    _startTimer();
  }

  Future<void> _fetchQuestions() async {
    try {
      String firestoreSubject = _mapSubjectName(widget.subject);

      List<Map<String, dynamic>> fetchedQuestions = [];
      for (String docName in questionDocs) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('fields')
            .doc(firestoreSubject)
            .collection('levels')
            .doc(widget.difficulty)
            .collection('quizzes')
            .doc(docName)
            .get();

        if (snapshot.exists) {
          fetchedQuestions.add({
            "mcq": snapshot.get('mcq'),
            "options": snapshot.get('options'),
            "correctOpt": snapshot.get('correct opt'), // correct option
          });
        }
      }

      setState(() {
        questions = fetchedQuestions;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching questions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    timeLeft = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        _goToNextQuestion();
      }
    });
  }

  Future<void> _goToNextQuestion() async {
    // Check if current answer is correct
    if (selectedOption != null &&
        selectedOption == questions[currentQuestionIndex]["correctOpt"]) {
      correctAnswers++;
    }

    if (currentQuestionIndex < questionDocs.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = null;
        _controller.forward(from: 0);
        _startTimer();
      });
    } else {
      _timer?.cancel();

      int score = ((correctAnswers / questionDocs.length) * 100).round();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "🎉 Quiz Completed! Score: $score%",
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Save score & update Firestore
      await widget.onQuizCompleted(score);

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1F2243)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 29, 31, 69),
        title: Text(
          "${widget.subject} Quiz",
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "McLaren",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timer + Difficulty
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Difficulty: ${widget.difficulty}",
                    style: const TextStyle(
                      color: Color(0xFF1F2243),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 93, 97, 172),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          "$timeLeft sec",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Progress Bar
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questionDocs.length,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 93, 97, 172),
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 20),

              // Question Text
              Text(
                "Q${currentQuestionIndex + 1}) ${questions[currentQuestionIndex]["mcq"]}",
                style: const TextStyle(
                  color: Color(0xFF1F2243),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "McLaren",
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 25),

              // Options
              ...questions[currentQuestionIndex]["options"].map<Widget>((
                option,
              ) {
                final isSelected = selectedOption == option;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = option;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? const Color.fromARGB(255, 93, 97, 172)
                          : Colors.grey.shade100,
                      border: Border.all(
                        color: isSelected
                            ? const Color.fromARGB(255, 93, 97, 172)
                            : Colors.grey.shade400,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isSelected
                              ? Colors.white
                              : const Color.fromARGB(255, 93, 97, 172),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1F2243),
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Next / Finish button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedOption == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select an option first!"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }
                    _goToNextQuestion();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 29, 31, 69),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                  ),
                  child: Text(
                    currentQuestionIndex < questionDocs.length - 1
                        ? "Next"
                        : "Finish",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
