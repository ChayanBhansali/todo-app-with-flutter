import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/screens/addtask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'description.dart';
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  String? uid = '';
  @override
  void initState() {
    getuid();
    super.initState();
  }
  getuid() async{
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = await auth.currentUser;
  setState(() {
    uid = user?.uid;
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        actions: [
          IconButton(onPressed: ()async{
            FirebaseAuth.instance.signOut();
          },
              icon: Icon(Icons.logout)
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance
            .collection('tasks')
            .doc(uid)
            .collection('mytasks')
            .snapshots() ,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());

          }else{
            final docs = snapshot.data?.docs;
            return ListView.builder(
                itemCount: docs!.length,
              itemBuilder: (context, index) {
                var time = (docs[index]['timestamp'] as Timestamp).toDate();

                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Description(
                              title: docs[index]['title'],
                              description: docs[index]['description'],
                            )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(10)),
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(docs[index]['title'],
                                      )
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                      DateFormat.yMd().add_jm().format(time)))
                            ]),
                        Container(
                            child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                ),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(uid)
                                      .collection('mytasks')
                                      .doc(docs[index]['time'])
                                      .delete();
                                }))
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
        ),
        // color: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask()));
      },
      child: Icon(Icons.add, color: Colors.white,),
        
      ),
    );
  }
}
