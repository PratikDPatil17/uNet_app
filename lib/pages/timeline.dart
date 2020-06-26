import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uNet_app/models/user.dart';
import 'package:uNet_app/pages/home.dart';
import 'package:uNet_app/pages/search.dart';
import 'package:uNet_app/widgets/header.dart';
import 'package:uNet_app/widgets/post.dart';
import 'package:uNet_app/widgets/progress.dart';


//Firestore.instance
final usersRef = Firestore.instance.collection('users');


class Timeline extends StatefulWidget {
  final User currentUser;
  Timeline({this.currentUser});

  @override
  _TimelineState createState() => _TimelineState();
}

// add finctions here 
class _TimelineState extends State<Timeline> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Post> posts;
  List<String> followingList = [];


  //List<dynamic> users = [];

  // @override
  // void initState() {
  //   //getUsers();
  //   //getUserById();
  //   //createUser();
  //   //updateUser();
  //   deleteUser();
  @override
  void initState() {
    super.initState();
    getTimeline();
    getFollowing();
  }

    // TODO: implement initState
    //super.initState();
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
// createUser(){
//   usersRef
//         .document("asdfghjd")
//         .setData({"username": 'Prashant', "postCount": 0, "isAdmin": false});
// }

// updateUser() async{
//   final doc = await usersRef
//         .document("Akq9mtkDXpVgvspKD2bX").get();
//         //.updateData({"username": 'Dadus', "postCount": 0, "isAdmin": false});
//   if (doc.exists){
//     doc.reference.updateData({"username": 'Dadus', "postCount": 0, "isAdmin": false});
//   }
// }

// deleteUser() async{
//     final DocumentSnapshot doc = await usersRef.document("Akq9mtkDXpVgvspKD2bX").get();
//         if (doc.exists){
//           doc.reference.delete();
//         }
// }


getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .document(widget.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .document(currentUser.id)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingList = snapshot.documents.map((doc) => doc.documentID).toList();
    });
  }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return buildUsersToFollow();
    } else {
      return ListView(children: posts);
    }
  }

  buildUsersToFollow() {
    return StreamBuilder(
      stream:
          usersRef.orderBy('timestamp', descending: true).limit(30).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> userResults = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          final bool isAuthUser = currentUser.id == user.id;
          final bool isFollowingUser = followingList.contains(user.id);
          // remove auth user from recommended list
          if (isAuthUser) {
            return;
          } else if (isFollowingUser) {
            return;
          } else {
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
          }
        });
        return Container(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person_add,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Users to Follow",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Column(children: userResults),
            ],
          ),
        );
      },
    );
  }

//try-2 --- fetching data using single Widget
  @override
  Widget build(context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: header(context, isAppTitle: true),
        body: RefreshIndicator(
            onRefresh: () => getTimeline(), child: buildTimeline()));
  }
}
