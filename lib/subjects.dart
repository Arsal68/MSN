import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:msn_project/provider/subject_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Subject class to represent each subject
class Subject {
  final String name;
  final IconData icon;
  final Color color1;
  final Color color2;

  Subject({
    required this.name,
    required this.icon,
    required this.color1,
    required this.color2,
  });
}

class Subjects extends StatefulWidget {
  const Subjects({super.key});

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  String selectedSubject = '';
  Map<String, bool> completedSubjects = {};

  @override
  void initState() {
    super.initState();
    fetchCompletedSubjects();
  }

  void fetchCompletedSubjects() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('user_progress')
        .doc(user.uid)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      Map<String, bool> tempCompleted = {};
      data.forEach((subject, value) {
        if (value is Map<String, dynamic>) {
          int total = value.length;
          int completedCount = 0;
          value.forEach((key, val) {
            if (val['completed'] == true) completedCount++;
          });
          double percent = (completedCount / total) * 100;
          tempCompleted[subject.toLowerCase()] = percent == 100;
        }
      });

      setState(() {
        completedSubjects = tempCompleted;
      });
    }
  }

  // List of subjects
  final List<Subject> subjects = [
    Subject(
      name: "App Development",
      icon: Icons.smartphone,
      color1: Color(0xffEB0000),
      color2: Color(0xffFFD93D),
    ),
    Subject(
      name: "Data Analyst",
      icon: Icons.analytics,
      color1: Color(0xff36D1DC),
      color2: Color(0xff5B86E5),
    ),
    Subject(
      name: "Web Development",
      icon: MdiIcons.web,
      color1: Color(0xffA4FF5F),
      color2: Color(0xff004D15),
    ),
    Subject(
      name: "Gen AI",
      icon: MdiIcons.robot,
      color1: Color(0xff6A11CB),
      color2: Color(0xff2575FC),
    ),
    Subject(
      name: "Dot Net Development",
      icon: MdiIcons.codeTags,
      color1: Color(0xffF7971E),
      color2: Color(0xffFFD200),
    ),
    Subject(
      name: "Graphic Designing",
      icon: Icons.color_lens,
      color1: Color(0xffFF512F),
      color2: Color(0xffDD2476),
    ),
    Subject(
      name: "Digital Marketing",
      icon: Icons.campaign,
      color1: Color(0xff11998E),
      color2: Color(0xff38EF7D),
    ),
    Subject(
      name: "Python Programming",
      icon: MdiIcons.languagePython,
      color1: Color(0xffF7971E),
      color2: Color(0xffFFD200),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        title: Text(
          "Subjects",
          style: TextStyle(
            fontFamily: "Mclaren",
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff1D1F45),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: subjects.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1, // ensures perfect squares
                ),
                itemBuilder: (context, index) {
                  final subj = subjects[index];
                  bool isSelected = selectedSubject == subj.name;
                  bool isCompleted =
                      completedSubjects[subj.name.toLowerCase()] ?? false;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSubject = subj.name;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isSelected
                              ? [subj.color1, subj.color2]
                              : [Color(0xff1D1F45), Color(0xff1D1F45)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.white24,
                          width: isSelected ? 3.5 : 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  subj.icon,
                                  size: 55,
                                  color: isSelected
                                      ? Colors.white
                                      : subj.color1,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  subj.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Mclaren",
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white70,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          if (isCompleted)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                backgroundColor: selectedSubject.isEmpty
                    ? Colors.grey.shade600
                    : Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
              ),
              onPressed: selectedSubject.isEmpty
                  ? null
                  : () {
                      Provider.of<SubjectProvider>(
                        context,
                        listen: false,
                      ).setSubject(selectedSubject);
                      Navigator.pop(context);
                    },
              child: Text(
                "Next",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Mclaren",
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
