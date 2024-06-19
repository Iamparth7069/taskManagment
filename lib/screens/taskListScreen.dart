import 'package:flutter/material.dart';
import 'package:module_5_assignment/model/task.dart';
import 'package:module_5_assignment/screens/taskScreen.dart';

import '../dbHelper/dbhelper.dart';


class MyTaskListPage extends StatefulWidget {
  const MyTaskListPage({super.key});

  @override
  State<MyTaskListPage> createState() => _MyTaskListPageState();
}

class _MyTaskListPageState extends State<MyTaskListPage> {
  List<Task> taskList = [];
  var dbHelper = DbHelper();

  void initState() {
    fetchTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color getPriorityColor(String priority) {
      switch (priority) {
        case 'High':
          return Colors.red;
        case 'Medium':
          return Colors.blue;
        case 'Low':
          return Colors.green;
        default:
          return Colors.green;
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Task List Screen'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            Task? person = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskFormScreen(null),
                )
            );
            if(person != null){
              taskList.insert(0, person);
              refreshList(taskList);
            }
          },
          child: Icon(Icons.add),
        ),
        body: Padding(
          padding: EdgeInsets.all(5),
          child: ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (context, index){
              return Card(
                elevation: 5,
                shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Name : ${taskList[index].name}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Description : ${taskList[index].description}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      title: Text('Date : ${taskList[index].date}'),
                      subtitle: Text('Time : ${taskList[index].time}'),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Priority : ${taskList[index].priority}',
                        style: TextStyle(
                          color: getPriorityColor(taskList[index].priority!),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        TextButton(
                          onPressed: () async {
                            Task? person = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskFormScreen(taskList[index]),
                              ),);
                            if (person != null) {
                              var index = taskList.indexWhere((element) => element.id == person.id);
                              taskList[index] = person;
                              refreshList(taskList);
                            }
                          },
                          child: Text('Edit'),
                        ),
                        TextButton(
                          onPressed: () {
                            var task = taskList[index];
                            deleteRecord(task);
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        )
    );
  }
  Future<void> fetchTaskList() async {
    var task = await dbHelper.getTask();
    refreshList(task);
  }

  void refreshList(List<Task> tasks) {
    setState(() {
      taskList = tasks;
    });
  }

  Future<void> deleteRecord(Task task) async {
    var id = await dbHelper.deleteTask(task.id!);
    if (id == 1) {
      taskList.removeWhere((element) => element.id == task.id);
      refreshList(taskList);
    }
  }
}
