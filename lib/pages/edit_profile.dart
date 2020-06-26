import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:uNet_app/models/user.dart';
import 'package:uNet_app/pages/home.dart';
import 'package:uNet_app/widgets/progress.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile({ this.currentUserId});


  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController collageNameController = TextEditingController();
  TextEditingController departmentNameController = TextEditingController();
  bool isLoading = false;
  User user;
  bool _displayNameValid = true;
  bool _bioValid = true;
  bool _departmentNameValid = true;
  bool _collageNameValid = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.document(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user.displayName;
    bioController.text = user.bio;
    collageNameController.text = user.collageName;
    departmentNameController.text = user.departmentName;
    setState(() {
      isLoading = false;
    });

  }

  Column buildDisplayNameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text("Display Name",
          style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _displayNameValid ? null : "Display Name too short",
          ),

        ),
      ],
    );
  }

  Column buildBioField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("Bio",
          style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update Bio",
            errorText: _bioValid ? null : "Bio too long",
          ),

        ),
      ],
    );
  }

  Column buildDepartmentNameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("Department Name",
          style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: departmentNameController,
          decoration: InputDecoration(
            hintText: "Update Department",
            errorText: _departmentNameValid ? null : "Wrong Department Name",
          ),

        ),
      ],
    );
  }

  Column buildCollageNameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("Display Collage",
          style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: collageNameController,
          decoration: InputDecoration(
            hintText: "Update Collage Name",
            errorText: _collageNameValid ? null : "Wrong collage Name",
          ),

        ),
      ],
    );
  }
  
  // Validation for Edit Profile
  updateProfileData(){
    setState(() {
      displayNameController.text.trim().length < 3 || displayNameController.text.isEmpty ? _displayNameValid = false : _displayNameValid = true;

      bioController.text.trim().length > 50 ? _bioValid = false : _bioValid = true;

      collageNameController.text.trim().length > 50 || collageNameController.text.isEmpty ? _collageNameValid = false : _collageNameValid = true;

      departmentNameController.text.trim().length > 20 || departmentNameController.text.isEmpty ? _departmentNameValid = false : _departmentNameValid = true;
    });
    if(_displayNameValid && _bioValid && _collageNameValid && _departmentNameValid){
    //if (_displayNameValid && _bioValid){
      usersRef.document(widget.currentUserId).updateData({
        "displayName" : displayNameController.text,
        "bio": bioController.text,
        "departmentName" : departmentNameController.text,
        "collageName" : collageNameController.text,
        });
        SnackBar snackbar = SnackBar(content: Text("Profile Updated!!!"),);
        _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              size: 35.0,
              color: Colors.redAccent,
            ), 
            onPressed: () => Navigator.pop(context),
            ),
        ],
      ),
      body: isLoading ? 
      circularProgress() : ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0
                  ),
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),

                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children:<Widget>[
                      buildDisplayNameField(),
                      buildBioField(),
                      buildDepartmentNameField(),
                      buildCollageNameField(),
                      
                    ]
                  ),
                ),
                Divider(
                  thickness: 3.0,
                ),
                RaisedButton(
                  onPressed: updateProfileData,
                  child: Text(
                    "Update Profile",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: FlatButton.icon(
                    onPressed: logout,
                    icon: Icon(Icons.cancel, color: Colors.red,),
                    label: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20.0,
                        ),
                    ),

                    
                  ),
                ),

              ],
              ),
          ),
        ],
      ),
    );
  }
}
