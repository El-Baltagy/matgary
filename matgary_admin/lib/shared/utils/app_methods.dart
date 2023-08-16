//snak bar
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'global.dart';

showSnackBar(var _scaffoldKey, String message,{int duration=2,Color backgroundColor=Colors.yellow,Color textColor=Colors.black}) {
  _scaffoldKey.currentState!.hideCurrentSnackBar();
  _scaffoldKey.currentState!.showSnackBar(SnackBar(
      duration:  Duration(seconds: duration),
      backgroundColor: backgroundColor,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style:  TextStyle(
          fontSize: 18,
          color: textColor,
        ),
      )));
}

//store delete files
Future<String> storeFileToFirebase(String ref, File file) async {
  UploadTask uploadTask = firestorage.ref().child(ref).putFile(file);
  TaskSnapshot snap = await uploadTask;
  String downloadUrl = await snap.ref.getDownloadURL();
  return downloadUrl;
}

deleteFileFromFirebase(String ref) async {
  firestorage.ref().child(ref).delete();

}

class GoPage{
  static void pushReplacement(
      context, {
        required Widget path,
        var curve = Curves.ease,
        double y=0.2,
        double x=0,
      }
      ) =>
      Navigator.pushReplacement(
          context,
          _createRoute(Sc: path,curve:curve,X:x ,Y:y ));

  static void navigateAndFinish(
      context,
      widget,
      {bool Rt = false}
      ) =>
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ), (route) =>Rt,
      );

  static void  push(context, {
    required Widget path,
    var curve = Curves.ease,
    double y=0.2,
    double x=0,
  }) {
    Navigator.
    push(context,_createRoute(Sc: path,curve:curve,X:x ,Y:y ));
  }

  static _createRoute({
    required Widget Sc,
    required var curve,
    required double X,Y,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Sc,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(X,Y);
        const end = Offset.zero;

        var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
