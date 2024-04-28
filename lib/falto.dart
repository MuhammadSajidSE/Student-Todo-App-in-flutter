//   import 'package:firebase_database/firebase_database.dart';
// void fetchAndOrganizeTasksByDateForStudent(
//       String studentName, DateTime date) {
//     DatabaseReference studentRef =
//         FirebaseDatabase.instance.ref().child("Student").child(studentName);
//     Map<String, List<Map<dynamic, dynamic>>> tasksBySubject = {};
//     studentRef
//         .once()
//         .then((DataSnapshot snapshot) {
//           Map<dynamic, dynamic> subjects =
//               snapshot.value as Map<dynamic, dynamic>;
//           if (subjects != null) {
//             for (String subjectName in subjects.keys) {
//               DatabaseReference subjectRef = studentRef.child(subjectName);
//               subjectRef
//                   .orderByChild('date')
//                   .equalTo(_formatDate(date))
//                   .once()
//                   .then((DataSnapshot snapshot) {
//                     Map<dynamic, dynamic> tasks =
//                         snapshot.value as Map<dynamic, dynamic>;
//                     if (tasks != null) {
//                       // Add tasks to the map under the current subject name
//                       tasksBySubject[subjectName] =
//                           tasks.values.toList() as List<Map<dynamic, dynamic>>;
//                     }
//                   } as FutureOr Function(DatabaseEvent value))
//                   .catchError((error) {
//                 print('Error fetching tasks for $subjectName: $error');
//               });
//             }
//           }
//         } as FutureOr Function(DatabaseEvent value))
//         .then((_) {
//       print(
//           'Tasks organized by subject for $studentName on $date: $tasksBySubject');
//     }).catchError((error) {
//       print('Error fetching subjects for student $studentName: $error');
//     });
//   }

//   String _formatDate(DateTime date) {
//     // Format date as mm-dd-yyyy
//     return '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}-${date.year}';
//   }