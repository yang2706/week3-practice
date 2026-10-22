import 'package:test/test.dart';
import '../lib/service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");
    lms.addCourse(courseId: 'C1', courseName: "Mobile Development");
    

    for (final student in lms.students){
      print('ID: ${student.id} Name: ${student.name}');
    }

    for (final course in lms.courses){
      print("CourseID: ${course.id} Course Name: ${course.name}");
    }

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    lms.removeCourse(courseId: 'C1');
    //after remove
    print('Students after removal: ${lms.students.length}');
    print('Courses after removal: ${lms.courses.length}');
    expect(lms.students.length, 0);
  });

  test('enrolls an existing student in an existing course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    expect(lms.students.first.courseIds, contains('C1'));
    expect(lms.courses.first.studentIds, contains('S1'));
  });

  test('rejects enrollment if student does not exist', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    expect(
      () => lms.enrollStudent(studentId: 'S1', courseId: 'C1'),
      throwsException,
    );
  });

  test('rejects enrollment if course does not exist', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');

    expect(
      () => lms.enrollStudent(studentId: 'S1', courseId: 'C1'),
      throwsException,
    );
  });

  test('rejects duplicate enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    expect(
      () => lms.enrollStudent(studentId: 'S1', courseId: 'C1'),
      throwsException,
    );

    expect(lms.students.first.courseIds.length, 1);
    expect(lms.courses.first.studentIds.length, 1);
    //after enroll
    print('Course: ${lms.students.first.courseIds.length}');
    print('Student: ${lms.courses.first.studentIds.length}');
  });

  
  test('removes an existing enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1');

    expect(lms.students.first.courseIds, isEmpty);
    expect(lms.courses.first.studentIds, isEmpty);
  });

  test('rejects removal of a nonexistent enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    expect(
      () => lms.discardStudentFromCourse(
        studentId: 'S1',
        courseId: 'C1',
      ),
      throwsException,
    );
  });

  test('student and course still exist after enrollment removal', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1');

    expect(lms.students.length, 1);
    expect(lms.courses.length, 1);
    expect(lms.students.first.id, 'S1');
    expect(lms.courses.first.id, 'C1');
  });

  test('removing a student cleans all course enrollments', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.addCourse(courseId: 'C2', courseName: 'Dart');

    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.enrollStudent(studentId: 'S1', courseId: 'C2');

    lms.removeStudent(studentId: 'S1');

    expect(lms.students, isEmpty);
    expect(lms.courses.length, 2);
    expect(lms.courses[0].studentIds, isEmpty);
    expect(lms.courses[1].studentIds, isEmpty);
  });
  
  
  test('adds a valid result', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    lms.addResult(
      studentId: 'S1',
      courseId: 'C1',
      score: 85.0,
    );

    expect(lms.results.length, 1);
    expect(lms.results.first.studentId, 'S1');
    expect(lms.results.first.courseId, 'C1');
    expect(lms.results.first.score, 85.0);
    expect(lms.results.first.id, 'R1');
  });

  test('rejects result for nonexistent student', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    expect(
      () => lms.addResult(
        studentId: 'S999',
        courseId: 'C1',
        score: 85.0,
      ),
      throwsException,
    );
  });

  test('rejects result for nonexistent course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');

    expect(
      () => lms.addResult(
        studentId: 'S1',
        courseId: 'C999',
        score: 85.0,
      ),
      throwsException,
    );
  });

  test('rejects result if student is not enrolled', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    expect(
      () => lms.addResult(
        studentId: 'S1',
        courseId: 'C1',
        score: 85.0,
      ),
      throwsException,
    );
  });

  test('rejects invalid score', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    expect(
      () => lms.addResult(
        studentId: 'S1',
        courseId: 'C1',
        score: 101.0,
      ),
      throwsException,
    );

    expect(
      () => lms.addResult(
        studentId: 'S1',
        courseId: 'C1',
        score: -1.0,
      ),
      throwsException,
    );

    expect(lms.results, isEmpty);
  });

  test('rejects duplicate results for the same course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    lms.addResult(
      studentId: 'S1',
      courseId: 'C1',
      score: 85.0,
    );

    expect(
      () => lms.addResult(
        studentId: 'S1',
        courseId: 'C1',
        score: 90.0,
      ),
      throwsException,
    );

    expect(lms.results.length, 1);
    expect(lms.results.first.score, 85.0);
  });

 }
