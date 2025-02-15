import 'package:cis_student_app/class/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentService {
  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('students');

  Future<void> addStudent(Student student) async {
    await studentsCollection.add(student.toMap());
  }

  Stream<List<Student>> getStudents() {
    return studentsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Student.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updateStudent(Student student) async {
    await studentsCollection.doc(student.id).update(student.toMap());
  }

  Future<void> deleteStudent(String studentId) async {
    await studentsCollection.doc(studentId).delete();
  }
}
