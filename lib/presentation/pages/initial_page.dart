import 'package:flutter/material.dart';
import 'package:task_dropper/data/datasources/local_source.dart';
import 'package:task_dropper/data/models/task_model.dart';

class InitialPage extends StatefulWidget {
  final int? userId;

  const InitialPage({super.key, required this.userId});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final LocalDataSource _localDataSource = LocalDataSource();
  List<Task> _listTasks = [];

  bool _isLoading = true;

  void _refreshTasks(int userId) async {
    final data = await _localDataSource.getTasksForUser(userId);
    setState(() {
      _listTasks = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTasks(widget.userId!);
  }

  final TextEditingController _titleTaskController = TextEditingController();
  final TextEditingController _descriptionTaskController = TextEditingController();
  final TextEditingController _updatedAtController = TextEditingController();

  Future<void> _insertTask() async {
    if(_titleTaskController.text != null && _titleTaskController.text != ""){
      await _localDataSource.insertTask(
      _titleTaskController.text,
      _descriptionTaskController.text,
      widget.userId!,      
    );
    final snackBar = SnackBar(content: Text('Task adicionada com sucesso!'), backgroundColor: Colors.green);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _refreshTasks(widget.userId!);
    }else{
      final snackBar = SnackBar(content: Text('Preencha corretamente os campos'), backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _refreshTasks(widget.userId!);
    }
  }

  Future<void> _updateTask(int id) async {
    final existingTask = _listTasks.firstWhere((element) => element.id == id);
    final updatedAt = DateTime.now();

    final updatedTask = Task(
      id: id,
      title: _titleTaskController.text,
      description: _descriptionTaskController.text,
      isDeleted: existingTask.isDeleted,
      isCompleted: existingTask.isCompleted,
      createdAt: existingTask.createdAt,
      updatedAt: updatedAt,
      userId: widget.userId!,
    );

    await _localDataSource.updateTask(updatedTask);
    _refreshTasks(widget.userId!);
  }

   void _deleteTask(int? id) async {
    if (id != null) {
      await _localDataSource.changeTaskDeletedStatus(id, true);
      _refreshTasks(widget.userId!);
    }
  }

  void showForm(int? id) {
    if (id != null) {
      final existingTask =_listTasks.firstWhere((element) => element.id == id);
      _titleTaskController.text = existingTask.title;
      _descriptionTaskController.text = existingTask.description;
    } else {
      _updatedAtController.text = '';
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleTaskController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descriptionTaskController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _insertTask();
                }
                if (id != null) {
                  await _updateTask(id);
                }

                _titleTaskController.text = '';
                _descriptionTaskController.text = '';

                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Create Task' : 'Update Task'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child:
          const Text("Cadastro de tarefas",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          )),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: _listTasks.length,
              itemBuilder: (context, index) => Card(
                color: Colors.blue,
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(_listTasks[index].title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
                  subtitle: Text(_listTasks[index].description,
                   style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.white,
                          onPressed: () => showForm(_listTasks[index].id),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.white,
                          onPressed: () => _deleteTask(_listTasks[index].id),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => showForm(_listTasks[index].id),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showForm(null),
        foregroundColor: Colors.white),
      );
  }
}
