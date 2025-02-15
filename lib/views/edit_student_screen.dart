import 'package:cis_student_app/class/student.dart';
import 'package:cis_student_app/services/student_service.dart';
import 'package:flutter/material.dart';

class EditStudentScreen extends StatefulWidget {
  static const routeName = '/edit-student';

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _majorController = TextEditingController();
  final StudentService _studentService = StudentService();
  Student? _student;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _student = ModalRoute.of(context)!.settings.arguments as Student?;
    if (_student != null) {
      _nameController.text = _student!.name;
      _studentIdController.text = _student!.studentId;
      _majorController.text = _student!.major;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลนักศึกษา',
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
                    _updateStudent();
                  }
                },
                child: Text('บันทึกการแก้ไข',
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

  void _updateStudent() async {
    if (_student == null) return;

    Student updatedStudent = Student(
      id: _student!.id,
      name: _nameController.text,
      studentId: _studentIdController.text,
      major: _majorController.text,
    );

    try {
      await _studentService.updateStudent(updatedStudent);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('แก้ไขข้อมูลนักศึกษาแล้ว',
                style: TextStyle(fontFamily: 'ComputerFont'))),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('เกิดข้อผิดพลาดในการแก้ไขข้อมูล',
                style: TextStyle(fontFamily: 'ComputerFont'))),
      );
    }
  }
}
