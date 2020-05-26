import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uNet_app/widgets/header.dart';
import 'package:uNet_app/widgets/progress.dart';

//Firestore.instance
final usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

// add finctions here 
class _TimelineState extends State<Timeline> {

  //List<dynamic> users = [];

  @override
  void initState() {
    //getUsers();
    //getUserById();
    //createUser();
    //updateUser();
    deleteUser();

    // TODO: implement initState
    super.initState();
  }
//==========================================================================================================================
  // getUsers(){
  //   userRef.getDocuments().then((QuerySnapshot snapshot){
  //     snapshot.documents.forEach((DocumentSnapshot doc){
  //       print(doc.data);
  //       print(doc.documentID);
  //       print(doc.exists);

  //     });
  //   });
  // }

//######### create functions here 
// Try-1
  // getUserById() async {
  //   final String id = "1t8TPXC9FK2Mv2BxXMVs";
  //   final DocumentSnapshot doc =  await usersRef.document(id).get();
  //          print(doc.data);
  //          print(doc.documentID);
  //          print(doc.exists);
    
  // }

//try-2
  // getUsers() async {
  //   //final QuerySnapshot snapshot = await usersRef.where("isAdmin", isEqualTo: false).getDocuments();
  //   final QuerySnapshot snapshot = await usersRef
  //         //.orderBy("postCount", descending: false)
  //         .getDocuments();
  //   snapshot.documents.forEach((DocumentSnapshot doc){
  //       print(doc.data);
  //       print(doc.documentID);
  //       print(doc.exists);
  //     });
  // }

  //try-3
  //  getUsers() async{
  //    final QuerySnapshot snapshot = await usersRef.getDocuments();

  //    setState(() {
  //      users = snapshot.documents;
  //    });
  //  }

// Try-1 ---- to display content in timeline page 
  // @override
  // Widget build(context) {
  //   return Scaffold(
  //     appBar: header(context, isAppTitle: true ),
  //     body: Container(
  //       child: ListView(children: users.map((user) => Text(user ['username'])).toList(),
  //       )
  //     ),
  //   );
  // }
//================================================================================================================


// ### CRUD Applications ###
createUser(){
  usersRef
        .document("asdfghjd")
        .setData({"username": 'Prashant', "postCount": 0, "isAdmin": false});
}

updateUser() async{
  final doc = await usersRef
        .document("Akq9mtkDXpVgvspKD2bX").get();
        //.updateData({"username": 'Dadus', "postCount": 0, "isAdmin": false});
  if (doc.exists){
    doc.reference.updateData({"username": 'Dadus', "postCount": 0, "isAdmin": false});
  }
}

deleteUser() async{
    final DocumentSnapshot doc = await usersRef.document("Akq9mtkDXpVgvspKD2bX").get();
        if (doc.exists){
          doc.reference.delete();
        }
}

//try-2 --- fetching data using single Widget
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot){
            if (!snapshot.hasData){
              return circularProgress();
            }
            final List<Text> children = snapshot.data.documents.map((doc) => Text(doc['username'])).toList();
            return Container(
                child: ListView(
                    children: children,
                ),
            );
        },
        ),
    );
  }
}
