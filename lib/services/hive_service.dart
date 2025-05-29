import 'package:hive/hive.dart';
import '../models/task_model.dart';

class HiveService {
  final String boxName = 'tasksBox';

  Future<void> saveTasks(List<Task> tasks) async {
    final box = await Hive.openBox(boxName);
    final taskMaps = tasks.map((task) => task.toJson()).toList(); // ✅ исправлено
    await box.put('tasks', taskMaps);
  }

  Future<List<Task>> loadTasks() async {
    final box = await Hive.openBox(boxName);
    final taskMaps = box.get('tasks', defaultValue: []) as List;
    return taskMaps
        .map((map) => Task.fromJson(Map<String, dynamic>.from(map))) // ✅ исправлено
        .toList();
  }

  Future<void> clearTasks() async {
    final box = await Hive.openBox(boxName);
    await box.delete('tasks');
  }
}
