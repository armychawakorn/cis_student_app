class Student {
  String id;
  String name;
  String studentId;
  String major;

  Student({
    this.id = '',
    required this.name,
    required this.studentId,
    required this.major,
  });

  factory Student.fromMap(Map<String, dynamic> map, String documentId) {
    return Student(
      id: documentId,
      name: map['name'] ?? '',
      studentId: map['studentId'] ?? '',
      major: map['major'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'studentId': studentId,
      'major': major,
    };
  }
}
