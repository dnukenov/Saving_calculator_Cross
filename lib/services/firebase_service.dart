import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ добавлен импорт
import '../models/task_model.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;
  final String uid;

  FirebaseService(this.uid);

  Future<List<Task>> fetchTasks() async {
    final snapshot = await _db.collection('users').doc(uid).collection('tasks').get();
    return snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList(); // ✅ исправлено
  }

  Future<void> addTask(Task task) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task.id)
        .set(task.toJson()); // ✅ исправлено
  }

  Future<void> deleteTask(String id) async {
    await _db.collection('users').doc(uid).collection('tasks').doc(id).delete();
  }

  Future<void> updateTask(Task task) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task.id)
        .update(task.toJson()); // ✅ исправлено
  }

  Future<void> saveAllTasks(List<Task> tasks) async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid; // ✅ имя переменной не конфликтует с полем класса
    if (currentUid == null) return;

    final tasksRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('tasks');

    final batch = FirebaseFirestore.instance.batch();

    for (var task in tasks) {
      final docRef = tasksRef.doc(task.id);
      batch.set(docRef, task.toJson()); // ✅ используется toJson
    }

    await batch.commit();
  }
}



