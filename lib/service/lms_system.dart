import 'dart:ffi';
import'../model/result.dart';
import '../model/student.dart';
import '../model/course.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<Result> results = [];
  int _nextResultId = 1;
 
  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }

  void addCourse({required String courseId, required String courseName}){

    Course? course = _findCourseOrNull(courseId);
    if (course != null) {
      throw Exception('Course $course already exists');
    }

    courses.add(Course(id: courseId, name: courseName));
  }

  void enrollStudent({required String courseId, required String studentId}){
    
    //chack student
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $student not found!');
    }
    //check course
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $course not found!');
    }
    //check student enrolled course
    if (student.courseIds.contains(courseId)) {
    throw Exception(
      'Student $studentId is already enrolled in $courseId!',
    );

  }
  student.courseIds.add(courseId);
  course.studentIds.add(studentId);
  }

  
  void discardStudentFromCourse({required String studentId,required String courseId}) {
  //Student must exist
  Student? student = _findStudentOrNull(studentId);

  if (student == null) {
    throw Exception('Student $studentId not found!');
  }

  //Course must exist
  Course? course = _findCourseOrNull(courseId);

  if (course == null) {
    throw Exception('Course $courseId not found!');
  }

  //Student must be enrolled in this course
  if (!student.courseIds.contains(courseId)) {
    throw Exception(
      'Student $studentId is not enrolled in course $courseId!',
    );
  }

  // 4. Remove the relationship
  student.courseIds.remove(courseId);
  course.studentIds.remove(studentId);
  
  results.removeWhere(
  (result) =>
      result.studentId == studentId &&
      result.courseId == courseId,
  );
}
 
void addResult({
  required String studentId,
  required String courseId,
  required double score,
}) {
  // 1. Check student exists
  Student? student = _findStudentOrNull(studentId);

  if (student == null) {
    throw Exception('Student $studentId not found!');
  }

  // 2. Check course exists
  Course? course = _findCourseOrNull(courseId);

  if (course == null) {
    throw Exception('Course $courseId not found!');
  }

  // 3. Student must be enrolled
  if (!student.courseIds.contains(courseId)) {
    throw Exception(
      'Student $studentId is not enrolled in course $courseId!',
    );
  }

  // 4. Validate score
  if (score < 0 || score > 100) {
    throw Exception('Score must be between 0 and 100!');
  }

  // 5. Reject duplicate results
  final duplicate = results.any(
    (result) =>
        result.studentId == studentId &&
        result.courseId == courseId,
  );

  if (duplicate) {
    throw Exception(
      'A result already exists for student $studentId '
      'in course $courseId!',
    );
  }

  // 6. Create and store the result
  results.add(
    Result(
      id: 'R${_nextResultId++}',
      studentId: studentId,
      courseId: courseId,
      score: score,
    ),
  );
}


 
 
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found!');
    }

    for (final courseId in List<String>.from(student.courseIds)) {
    Course? course = _findCourseOrNull(courseId);

    if (course != null) {
      course.studentIds.remove(studentId);
    }
  }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);
    results.removeWhere((result) => result.studentId == studentId,);
 
  }

  void removeCourse({required String courseId}) {
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found!');

    }
    //remove course
    courses.removeWhere((course) => course.id == courseId);
    results.removeWhere((result) => result.courseId == courseId,);
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null; // not found
  }

  Course? _findCourseOrNull(String courseId) {
    for (Course c in courses) {
      if (c.id == courseId) {
        return c;
      }
    }
    return null; // not found
  } 
}
