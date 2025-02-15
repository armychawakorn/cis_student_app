import 'package:cis_student_app/firebase_options.dart';
import 'package:cis_student_app/views/add_student_screen.dart';
import 'package:cis_student_app/views/edit_student_screen.dart';
import 'package:cis_student_app/views/student_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student App CIS KKU',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.indigo[400],
        hintColor: Colors.grey[400],
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
            fontFamily: 'ComputerFont',
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo[400],
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo[400],
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo[400]!),
          ),
          labelStyle: TextStyle(color: Colors.grey[400]),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
        cardTheme: CardTheme(
          color: Colors.grey[850],
          margin: EdgeInsets.all(8.0),
        ),
        listTileTheme: ListTileThemeData(
          textColor: Colors.white,
          iconColor: Colors.white70,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      initialRoute: StudentListScreen.routeName,
      routes: {
        StudentListScreen.routeName: (context) => StudentListScreen(),
        AddStudentScreen.routeName: (context) => AddStudentScreen(),
        EditStudentScreen.routeName: (context) => EditStudentScreen(),
      },
    );
  }
}
