import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  addTaskToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user =  await auth.currentUser;
    String? uid = user?.uid ;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descController.text,
      'time': time.toString(),
      'timestamp': time
    });
    Fluttertoast.showToast(msg: 'Task Added');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Task'),),
    body: Container(
    padding: EdgeInsets.all(20),
    child: Column(
      children: [
        Container(
          child: TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Enter Title',
              border: OutlineInputBorder()
            ),
          ),
        ),
        SizedBox(height: 10,),
        Container(
          child: TextField(
            controller: descController,
            decoration: InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder()
            ),
          ),
        ),
        SizedBox(height: 10,),
        Container(
          width: double.infinity,
            height: 50,
            child: ElevatedButton(onPressed: (){
              addTaskToFirebase();
            },
              child: Text('Add Task'),
            )
        )
      ],
    ),
    )
    );
  }
}
