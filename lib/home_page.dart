import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/task_model.dart';
import 'services/firebase_service.dart';
import 'services/hive_service.dart';
import 'services/connectivity_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> _tasks = [];
  bool _isGuest = true;
  FirebaseService? _firebaseService;
  final _hiveService = HiveService();
  final _connectivityService = ConnectivityService();
  final _uuid = const Uuid();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final user = FirebaseAuth.instance.currentUser;
      setState(() {
        _isGuest = user == null || user.isAnonymous;
        _firebaseService = (!_isGuest && user != null) ? FirebaseService(user.uid) : null;
      });
      await _loadTasks();
    });
  }

  Future<void> _loadTasks() async {
    List<Task> tasks = [];
    bool isOnline = false;
    try {
      isOnline = await _connectivityService.isConnected();
    } catch (_) {}
    try {
      if (isOnline && !_isGuest && _firebaseService != null) {
        tasks = await _firebaseService!.fetchTasks();
      } else {
        tasks = await _hiveService.loadTasks();
      }
    } catch (_) {}
    setState(() {
      _tasks.clear();
      _tasks.addAll(tasks);
      _isLoading = false;
    });
  }

  Future<void> _saveAll() async {
    if (!_isGuest && _firebaseService != null) {
      await _firebaseService!.saveAllTasks(_tasks);
    }
    await _hiveService.saveTasks(_tasks);
  }

  void _addTask(String title) async {
    final task = Task(id: _uuid.v4(), title: title, savedMoney: 0.0);
    setState(() => _tasks.add(task));
    await _saveAll();
  }

  void _deleteTask(Task task) async {
    setState(() => _tasks.removeWhere((t) => t.id == task.id));
    await _saveAll();
  }

  void _editTaskTitle(Task task) {
    final controller = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editTitle),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () async {
              final updated = task.copyWith(title: controller.text);
              _updateTask(updated);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          )
        ],
      ),
    );
  }

  void _editSavedMoney(Task task) {
    final controller = TextEditingController(text: task.savedMoney.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editSavedMoney),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updated = task.copyWith(savedMoney: double.tryParse(controller.text) ?? 0.0);
              _updateTask(updated);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          )
        ],
      ),
    );
  }

  void _updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      setState(() => _tasks[index] = updatedTask);
      await _saveAll();
    }
  }

  int _lastTap = 0;

  void _handleTap(Task task) {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastTap < 300) {
      _editTaskTitle(task); // double tap
    } else {
      _editSavedMoney(task); // single tap
    }
    _lastTap = now;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(local.month),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: local.about,
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: local.logout,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
          if (!_isGuest)
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: local.settings,
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (_, i) {
                final task = _tasks[i];
                return GestureDetector(
                  onTap: () => _handleTap(task),
                  onLongPress: () => _deleteTask(task),
                  child: Card(
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text('${local.savedMoney}: ${task.savedMoney}'),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: _isGuest
          ? null
          : FloatingActionButton(
              onPressed: () {
                final controller = TextEditingController();
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(local.newMonth),
                    content: TextField(controller: controller),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _addTask(controller.text);
                          Navigator.pop(context);
                        },
                        child: Text(local.add),
                      )
                    ],
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
