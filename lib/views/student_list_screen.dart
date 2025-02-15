import 'package:cis_student_app/class/student.dart';
import 'package:cis_student_app/services/student_service.dart';
import 'package:cis_student_app/views/add_student_screen.dart';
import 'package:cis_student_app/views/edit_student_screen.dart';
import 'package:flutter/material.dart';

class StudentListScreen extends StatefulWidget {
  static const routeName = '/student-list';

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentService _studentService = StudentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายชื่อนักศึกษา สาขาวิทยาการคอมพิวเตอร์',
            style: TextStyle(fontFamily: 'ComputerFont')),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: StreamBuilder<List<Student>>(
        stream: _studentService.getStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('ไม่มีข้อมูลนักศึกษา',
                    style: TextStyle(fontFamily: 'ComputerFont')));
          }

          List<Student> students = snapshot.data!;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              Student student = students[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                color: Colors.grey[850],
                child: ListTile(
                  title: Text(student.name,
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'ComputerFont')),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('รหัส: ${student.studentId}',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'ComputerFont')),
                      Text('สาขา: ${student.major}',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'ComputerFont')),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.yellow[600]),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, EditStudentScreen.routeName,
                              arguments: student);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red[700]),
                        onPressed: () {
                          _confirmDeleteStudent(student.id, student.name);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddStudentScreen.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[700],
      ),
    );
  }

  void _deleteStudent(String studentId) async {
    try {
      await _studentService.deleteStudent(studentId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('ลบข้อมูลนักศึกษาแล้ว',
                style: TextStyle(fontFamily: 'ComputerFont'))),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('เกิดข้อผิดพลาดในการลบข้อมูล',
                style: TextStyle(fontFamily: 'ComputerFont'))),
      );
    }
  }

  void _confirmDeleteStudent(String studentId, String studentName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบข้อมูล',
              style: TextStyle(fontFamily: 'ComputerFont', color: Colors.red)),
          content: Text('คุณต้องการลบข้อมูลนักศึกษา "$studentName" ใช่หรือไม่?',
              style: TextStyle(fontFamily: 'ComputerFont')),
          actions: <Widget>[
            TextButton(
              child:
                  Text('ยกเลิก', style: TextStyle(fontFamily: 'ComputerFont')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยืนยัน',
                  style:
                      TextStyle(fontFamily: 'ComputerFont', color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteStudent(studentId);
              },
            ),
          ],
        );
      },
    );
  }
}
