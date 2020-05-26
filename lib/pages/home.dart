//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uNet_app/models/user.dart';
import 'package:uNet_app/pages/activity_feed.dart';
import 'package:uNet_app/pages/create_account.dart';
import 'package:uNet_app/pages/profile.dart';
import 'package:uNet_app/pages/search.dart';
import 'package:uNet_app/pages/timeline.dart';
import 'package:uNet_app/pages/upload.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection("users");
final DateTime timestamp = DateTime.now();
User currentUser ;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() { 
    super.initState();
    pageController = PageController(
      //initialPage: 2
    );
    //Detects When user signed in 
    googleSignIn.onCurrentUserChanged.listen((account) { 
      handleSignIn(account);
    }, onError: (err){
      print('Error signing in: $err');
    }
    );
    //reAuthenticate user when app is restarted
    googleSignIn.signInSilently(suppressErrors: false)
    .then((account){
      handleSignIn(account);
    }).catchError((err){
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account){
        if (account != null){
        //print('User signed in : $account');
        createUserInFirestore();
        setState(() {
          isAuth = true;
        });
      }
      else{
        setState(() {
          isAuth = false;
        });
      }

  }

  createUserInFirestore() async {
    // 1/ check if user exists in users collection in database according to id
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();
    //2/ if user dosnt exist then go to set up your Profile page
    if (!doc.exists){
      final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));

      usersRef.document(user.id).setData({
          "id" : user.id ,
          "username" : username,
          "photoUrl" : user.photoUrl,
          "email" : user.email,
          "displayName" : user.displayName,
          "bio" : "",
          "timestamp" : timestamp
      });
      doc = await usersRef.document(user.id).get();
    }
    //3/ get username from create account. use it to make new user
    currentUser = User.fromDocument(doc);
    print(currentUser);
    print(currentUser.username);
  }
  @override
  void dispose() { 
    pageController.dispose();
    super.dispose();
  }

  login(){
    googleSignIn.signIn();
  }


  logout(){
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex;
    });
  }
// to use animation for going from one page to another page
  onTap(int pageIndex){
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,

    );
  }

  Scaffold buildAuthScreen(){
    return Scaffold(
      body: PageView(
        children: <Widget>[
          //Timeline(),
          RaisedButton(
            child: Text('Logout'),
            onPressed: logout,
            ),
          ActivityFeed(),
          Upload(currentUser: currentUser),
          Search(),
          Profile()
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),

      bottomNavigationBar: CupertinoTabBar(
        
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).accentColor ,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot),),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active),),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera, size: 35.0,),),
          BottomNavigationBarItem(icon: Icon(Icons.search),),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),),
        ],

        ),

    );
    // return RaisedButton(
    //   child: Text('Logout'),
    //   onPressed: logout,
    // );
  }

  Widget buildUnAuthScreen(){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
              
            ]
          )

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('#uNet',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 795.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:AssetImage('assets/images/google_signin_button.png'),
                   ),
                ),
              ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}