import 'package:cis_student_app/class/student.dart';
import 'package:cis_student_app/services/student_service.dart';
import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  static const routeName = '/add-student';

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _majorController = TextEditingController();
  final StudentService _studentService = StudentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลนักศึกษา',
            style: TextStyle(fontFamily: 'ComputerFont')),
        leading: BackButton(),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'ชื่อนักศึกษา',
                    labelStyle: TextStyle(
                        fontFamily: 'ComputerFont', color: Colors.white70),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
                style:
                    TextStyle(color: Colors.white, fontFamily: 'ComputerFont'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อนักศึกษา';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _studentIdController,
                decoration: InputDecoration(
                    labelText: 'รหัสนักศึกษา',
                    labelStyle: TextStyle(
                        fontFamily: 'ComputerFont', color: Colors.white70),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
                style:
                    TextStyle(color: Colors.white, fontFamily: 'ComputerFont'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรหัสนักศึกษา';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _majorController,
                decoration: InputDecoration(
                    labelText: 'สาขาวิชา',
                    labelStyle: TextStyle(
                        fontFamily: 'ComputerFont', color: Colors.white70),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
                style:
                    TextStyle(color: Colors.white, fontFamily: 'ComputerFont'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกสาขาวิชา';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addStudent();
                  }
                },
                child: Text('บันทึก',
                    style: TextStyle(fontFamily: 'ComputerFont')),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700]),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[900],
    );
  }

  void _addStudent() async {
    Student newStudent = Student(
      name: _nameController.text,
      studentId: _studentIdController.text,
      major: _majorController.text,
    );

    try {
      await _studentService.addStudent(newStudent);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('เพิ่มข้อมูลนักศึกษาแล้ว',
                style: TextStyle(fontFamily: 'ComputerFont'))),
      );
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('เกิดข้อผิดพลาดในการเพิ่มข้อมูล',
                style: TextStyle(fontFamily: 'ComputerFont'))),
      );
    }
  }
}
