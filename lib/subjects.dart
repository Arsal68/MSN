import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:msn_project/provider/subject_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Subjects extends StatefulWidget {
  const Subjects({super.key});

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  String selectedSubject = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        elevation: 8,
        backgroundColor: const Color(0xff1D1F45),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Subjects",
          style: TextStyle(
            fontFamily: "Mclaren",
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  subjectCard(
                    subjname: "App Development",
                    icon: Icons.smartphone,
                    color1: const Color.fromARGB(255, 235, 0, 0),
                    color2: const Color(0xffFFD93D),
                  ),
                  subjectCard(
                    subjname: "Data Analyst",
                    icon: Icons.analytics,
                    color1: const Color(0xff36D1DC),
                    color2: const Color(0xff5B86E5),
                  ),
                  subjectCard(
                    subjname: "Web Development",
                    icon: MdiIcons.web,
                    color1: const Color.fromARGB(255, 164, 255, 95),
                    color2: const Color.fromARGB(255, 0, 77, 21),
                  ),
                  subjectCard(
                    subjname: "Gen AI",
                    icon: MdiIcons.robot,
                    color1: const Color(0xff6A11CB),
                    color2: const Color(0xff2575FC),
                  ),
                  subjectCard(
                    subjname: "Dot Net Development",
                    icon: MdiIcons.codeTags,
                    color1: const Color(0xffF7971E),
                    color2: const Color(0xffFFD200),
                  ),
                  subjectCard(
                    subjname: "Graphic Designing",
                    icon: Icons.color_lens,
                    color1: const Color(0xffFF512F),
                    color2: const Color(0xffDD2476),
                  ),
                  subjectCard(
                    subjname: "Digital Marketing",
                    icon: Icons.campaign,
                    color1: const Color(0xff11998E),
                    color2: const Color(0xff38EF7D),
                  ),
                  subjectCard(
                    subjname: "Python Programming",
                    icon: MdiIcons.languagePython,
                    color1: const Color(0xffF7971E),
                    color2: const Color(0xffFFD200),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 16,
                ),
                backgroundColor: selectedSubject.isEmpty
                    ? Colors.grey.shade600
                    : Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
              ),
              onPressed: () {
                if (selectedSubject.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('⚠ Please select a subject'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  Provider.of<SubjectProvider>(
                    context,
                    listen: false,
                  ).setSubject(selectedSubject);

                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Next",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Mclaren",
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget subjectCard({
    required String subjname,
    required IconData icon,
    required Color color1,
    required Color color2,
  }) {
    final bool isSelected = selectedSubject == subjname;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSubject = subjname;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [color1, color2]
                : [const Color(0xff1D1F45), const Color(0xff1D1F45)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color1.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
          ],
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white24,
            width: isSelected ? 3.5 : 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 55, color: isSelected ? Colors.white : color1),
            const SizedBox(height: 10),
            Text(
              subjname,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Mclaren",
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
