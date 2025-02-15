**สร้างโดย:** นายชวกร เนืองภา นักศึกษาชั้นปีที่ 3 สาขาวิทยาการคอมพิวเตอร์และสารสนเทศ มหาวิทยาลัยขอนแก่น (CIS KKU)

**คำอธิบายโปรเจค:**

แอปพลิเคชันนี้เป็นแอปพลิเคชัน Flutter สำหรับบันทึกและจัดการข้อมูลนักศึกษา สาขาวิทยาการคอมพิวเตอร์และสารสนเทศ มหาวิทยาลัยขอนแก่น (CIS KKU)  ผู้ใช้สามารถเพิ่มข้อมูลนักศึกษาใหม่, ดูรายชื่อนักศึกษาทั้งหมด, แก้ไขข้อมูลนักศึกษาที่มีอยู่, และลบข้อมูลนักศึกษาที่ไม่ต้องการได้

**เทคโนโลยีหลักที่ใช้:**

* **Flutter:**  Framework สำหรับพัฒนา UI ของแอปพลิเคชัน
* **Firebase:** Backend-as-a-Service จาก Google ที่ใช้สำหรับ:
    * **Firestore:**  ฐานข้อมูล NoSQL แบบ Cloud สำหรับจัดเก็บข้อมูลนักศึกษา

**คำอธิบายโค้ด Firebase ในแต่ละไฟล์:**

**1. `lib/services/student_service.dart`:**

* **วัตถุประสงค์:** ไฟล์นี้เป็นส่วนที่ **จัดการการสื่อสารกับ Firebase Firestore โดยตรง**  เป็นเสมือนตัวกลางระหว่าง UI และฐานข้อมูล Firebase ทำหน้าที่ในการสร้าง (Create), อ่าน (Read), อัปเดต (Update), และลบ (Delete) ข้อมูลนักศึกษา (CRUD Operations)

* **การทำงาน:**
    * **`studentsCollection`:**
        ```dart
        final CollectionReference studentsCollection =
            FirebaseFirestore.instance.collection('students');
        ```
        - บรรทัดนี้สร้าง Reference ไปยัง **Collection ชื่อ `students`** ใน Firestore Database ของคุณ  Collection นี้จะเป็นที่เก็บข้อมูลนักศึกษาทั้งหมด
    * **`addStudent(Student student)` (Create):**
        ```dart
        Future<void> addStudent(Student student) async {
          await studentsCollection.add(student.toMap());
        }
        ```
        - ฟังก์ชันนี้ใช้สำหรับ **เพิ่มข้อมูลนักศึกษาใหม่** ลงใน Firestore
        - `studentsCollection.add(student.toMap())`:  เรียกใช้ฟังก์ชัน `add()` บน `studentsCollection` เพื่อเพิ่ม Document ใหม่เข้าไปใน Collection
            - `student.toMap()`: แปลง Object `Student` (จาก `lib/class/student.dart`) ให้เป็น `Map<String, dynamic>` เพื่อให้ Firestore สามารถจัดเก็บข้อมูลได้
    * **`getStudents()` (Read - Stream):**
        ```dart
        Stream<List<Student>> getStudents() {
          return studentsCollection.snapshots().map((snapshot) {
            return snapshot.docs.map((doc) {
              return Student.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            }).toList();
          });
        }
        ```
        - ฟังก์ชันนี้ใช้สำหรับ **อ่านข้อมูลนักศึกษาทั้งหมด** จาก Firestore และส่งข้อมูลออกมาในรูปแบบ `Stream`
        - `studentsCollection.snapshots()`:  สร้าง `Stream` ที่จะปล่อยข้อมูลทุกครั้งที่มีการเปลี่ยนแปลงใน Collection `students` (เช่น มีการเพิ่ม, แก้ไข, หรือลบข้อมูล)
        - `.map((snapshot) { ... })`:  แปลง `QuerySnapshot` ที่ได้จาก `snapshots()` ให้เป็น `List<Student>`
            - `snapshot.docs.map((doc) { ... })`:  วนลูปผ่านแต่ละ `DocumentSnapshot` ใน `QuerySnapshot`
            - `Student.fromMap(doc.data() as Map<String, dynamic>, doc.id)`:  แปลงข้อมูลจาก `DocumentSnapshot` (ซึ่งอยู่ในรูปแบบ `Map`) กลับมาเป็น Object `Student` (จาก `lib/class/student.dart`) โดยใช้ Factory Constructor `Student.fromMap`
                - `doc.data() as Map<String, dynamic>`: ดึงข้อมูลจาก Document และแปลงเป็น `Map`
                - `doc.id`:  ดึง Document ID จาก Firestore
            - `.toList()`:  แปลงผลลัพธ์จาก `map()` เป็น `List<Student>`
    * **`updateStudent(Student student)` (Update):**
        ```dart
        Future<void> updateStudent(Student student) async {
          await studentsCollection.doc(student.id).update(student.toMap());
        }
        ```
        - ฟังก์ชันนี้ใช้สำหรับ **แก้ไขข้อมูลนักศึกษาที่มีอยู่แล้ว** ใน Firestore
        - `studentsCollection.doc(student.id).update(student.toMap())`: เรียกใช้ฟังก์ชัน `update()` บน Document ที่มี ID ตรงกับ `student.id`
            - `student.id`:  Document ID ของนักศึกษาที่จะแก้ไข (มาจาก Firestore ตอนอ่านข้อมูล)
            - `student.toMap()`: แปลง Object `Student` (ที่แก้ไขแล้ว) เป็น `Map` เพื่อส่งไปอัปเดตใน Firestore
    * **`deleteStudent(String studentId)` (Delete):**
        ```dart
        Future<void> deleteStudent(String studentId) async {
          await studentsCollection.doc(studentId).delete();
        }
        ```
        - ฟังก์ชันนี้ใช้สำหรับ **ลบข้อมูลนักศึกษา** ออกจาก Firestore
        - `studentsCollection.doc(studentId).delete()`:  เรียกใช้ฟังก์ชัน `delete()` บน Document ที่มี ID ตรงกับ `studentId`

**2. `lib/views/student_list_screen.dart`:**

* **วัตถุประสงค์:** หน้าจอแสดง **รายชื่อนักศึกษา** ที่ดึงมาจาก Firestore และเป็นหน้าจอหลักของแอปพลิเคชัน

* **การทำงาน (Firebase Related):**
    * **`StreamBuilder<List<Student>>`:**
        ```dart
        StreamBuilder<List<Student>>(
          stream: _studentService.getStudents(),
          builder: (context, snapshot) { ... }
        )
        ```
        - ใช้ `StreamBuilder` เพื่อรับข้อมูลนักศึกษาแบบ Real-time จาก `_studentService.getStudents()`
        - `stream: _studentService.getStudents()`:  กำหนด `Stream` ที่จะรับข้อมูล (มาจาก `StudentService`)
        - `builder: (context, snapshot) { ... }`:  ส่วน Builder ที่จะสร้าง UI ตามสถานะของ `snapshot` (ข้อมูลที่ได้จาก `Stream`)
            - **`snapshot.hasError`:**  แสดงข้อความ Error หากเกิดปัญหาในการโหลดข้อมูล
            - **`snapshot.connectionState == ConnectionState.waiting`:** แสดง `CircularProgressIndicator` ระหว่างรอโหลดข้อมูล
            - **`!snapshot.hasData || snapshot.data!.isEmpty`:** แสดงข้อความ "ไม่มีข้อมูลนักศึกษา" หากไม่มีข้อมูลนักศึกษาใน Firestore
            - **`List<Student> students = snapshot.data!;`:**  ถ้ามีข้อมูล, ดึงข้อมูลนักศึกษาจาก `snapshot.data!` มาเก็บใน `List<Student>`
    * **การลบข้อมูล:**
        ```dart
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _deleteStudent(student.id);
          },
        )
        ```
        - เมื่อผู้ใช้กดปุ่มลบในแต่ละรายการนักศึกษา, จะเรียกฟังก์ชัน `_deleteStudent(student.id)`
        - `_deleteStudent(student.id)`:  เรียกใช้ `_studentService.deleteStudent(student.id)` เพื่อสั่งให้ `StudentService` ทำการลบข้อมูลนักศึกษาคนนั้นๆ จาก Firestore

**3. `lib/views/add_student_screen.dart`:**

* **วัตถุประสงค์:** หน้าจอสำหรับ **เพิ่มข้อมูลนักศึกษาใหม่** ลงใน Firestore

* **การทำงาน (Firebase Related):**
    * **`_addStudent()` function:**
        ```dart
        void _addStudent() async {
          Student newStudent = Student( ... ); // สร้าง Object Student จากข้อมูลที่กรอก
          try {
            await _studentService.addStudent(newStudent); // เรียกใช้ StudentService เพื่อเพิ่มข้อมูล
            Navigator.pop(context); // กลับไปหน้า List
            // ... แสดง SnackBar แจ้งเตือน
          } catch (error) {
            // ... แสดง SnackBar แจ้งเตือน Error
          }
        }
        ```
        - ฟังก์ชัน `_addStudent()` จะถูกเรียกเมื่อผู้ใช้กดปุ่ม "บันทึก" ในหน้าจอเพิ่มข้อมูล
        - `Student newStudent = Student( ... )`: สร้าง Object `Student` ใหม่ โดยดึงข้อมูลจาก `TextFormField` ต่างๆ ใน Form
        - `await _studentService.addStudent(newStudent)`:  เรียกใช้ `_studentService.addStudent(newStudent)` เพื่อสั่งให้ `StudentService` ทำการเพิ่มข้อมูลนักศึกษาใหม่นี้ลงใน Firestore

**4. `lib/views/edit_student_screen.dart`:**

* **วัตถุประสงค์:** หน้าจอสำหรับ **แก้ไขข้อมูลนักศึกษาที่มีอยู่แล้ว** ใน Firestore

* **การทำงาน (Firebase Related):**
    * **`_updateStudent()` function:**
        ```dart
        void _updateStudent() async {
          Student updatedStudent = Student( ... ); // สร้าง Object Student ที่แก้ไขแล้ว
          try {
            await _studentService.updateStudent(updatedStudent); // เรียกใช้ StudentService เพื่อแก้ไขข้อมูล
            Navigator.pop(context); // กลับไปหน้า List
            // ... แสดง SnackBar แจ้งเตือน
          } catch (error) {
            // ... แสดง SnackBar แจ้งเตือน Error
          }
        }
        ```
        - ฟังก์ชัน `_updateStudent()` จะถูกเรียกเมื่อผู้ใช้กดปุ่ม "บันทึกการแก้ไข" ในหน้าจอแก้ไขข้อมูล
        - `Student updatedStudent = Student( ... )`: สร้าง Object `Student` ใหม่ โดยดึงข้อมูลจาก `TextFormField` ต่างๆ ใน Form (โดยมีข้อมูลเดิมของนักศึกษาคนนั้นๆ เติมไว้อยู่แล้ว)
        - `await _studentService.updateStudent(updatedStudent)`: เรียกใช้ `_studentService.updateStudent(updatedStudent)` เพื่อสั่งให้ `StudentService` ทำการแก้ไขข้อมูลนักศึกษาใน Firestore

**5. `lib/main.dart`:**

* **วัตถุประสงค์:** ไฟล์ Main ของแอปพลิเคชัน, จุดเริ่มต้นการทำงานของแอป และทำการ **Initial Firebase**

* **การทำงาน (Firebase Related):**
    * **`Firebase.initializeApp()`:**
        ```dart
        Future<void> main() async {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
          runApp(MyApp());
        }
        ```
        - `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);`:  ทำการ **Initialize (เริ่มต้น)** Firebase SDK เมื่อแอปพลิเคชันเริ่มทำงาน
            - `Firebase.initializeApp()`: ฟังก์ชันสำหรับ Initialize Firebase
            - `options: DefaultFirebaseOptions.currentPlatform`:  กำหนดค่า Configuration ของ Firebase โดยอ่านจากไฟล์ `firebase_options.dart` (ซึ่งถูกสร้างขึ้นตอน Config Firebase ในโปรเจค)
        - การ Initialize Firebase ใน `main()` เป็นสิ่งจำเป็นเพื่อให้แอปพลิเคชันสามารถใช้งาน Firebase Services ต่างๆ ได้ (เช่น Firestore, Authentication, ฯลฯ)

**สรุปการทำงานร่วมกับ Firebase:**

แอปพลิเคชันนี้ใช้ Firebase Firestore เป็นฐานข้อมูลหลักในการจัดเก็บข้อมูลนักศึกษา การทำงานร่วมกับ Firebase สามารถสรุปได้ดังนี้:

1. **Initial Firebase:** ในไฟล์ `main.dart` ทำการ Initialize Firebase SDK เมื่อแอปเริ่มทำงาน
2. **StudentService:** ไฟล์ `student_service.dart` ทำหน้าที่เป็นตัวกลางในการสื่อสารกับ Firestore โดยมีฟังก์ชัน CRUD (`addStudent`, `getStudents`, `updateStudent`, `deleteStudent`) เพื่อจัดการข้อมูลใน Collection `students`
3. **UI Views:** หน้าจอต่างๆ (`student_list_screen.dart`, `add_student_screen.dart`, `edit_student_screen.dart`) เรียกใช้ฟังก์ชันจาก `StudentService` เพื่อทำการ CRUD ข้อมูลนักศึกษาผ่าน UI
4. **Data Flow:** ข้อมูลนักศึกษาจะถูกดึงมาจาก Firestore ผ่าน `Stream` ใน `student_list_screen.dart` และมีการส่งข้อมูลไปยัง Firestore เมื่อมีการเพิ่ม, แก้ไข, หรือลบข้อมูล ผ่าน `StudentService`
