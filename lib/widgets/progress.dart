import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


// Container circularProgress() {
//   return Container(
//       alignment: Alignment.center,
//       padding: EdgeInsets.only(top: 10.0),
//       child: CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation(Colors.red),
//       ));
// }

Container circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 100.0),
    child: SpinKitThreeBounce(
      color: Colors.red,
      size: 40.0,
      //valueColor: AlwaysStoppedAnimation(Colors.redAccent)
    ),
  );
}

Container linearProgress() {
  return Container(
    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.redAccent)
    ),
  );
}
