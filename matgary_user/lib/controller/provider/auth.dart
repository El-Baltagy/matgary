import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../shared/utils/app_methods.dart';
import '../../shared/utils/global.dart';
import '../../shared/widgets/progrfess_dialouge.dart';

class AuthProv extends ChangeNotifier{


  //sign in with email password
  late BuildContext buildContext;
  signIn(String email,String password,context)async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          buildContext=c;
          notifyListeners();
          return ProgressDialog(message: "Processing, Please wait...",);
        }
    );
   User? user= (await fAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    if (user!=null) {

    await Future.delayed(const Duration(seconds: 2),() {
      Navigator.of(context).pop('buildContext');
    },);
    }

  }

  //Register
 Future<bool?> register(BuildContext context,
      {required String email,
        required String password,
        required String phone,
        required File image,
        required String name,
         })async{
    try{
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext c)
          {
            return ProgressDialog(message: "Processing, Please wait...",);
          }
      );
      UserCredential userC=await fAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user=userC.user;
      if (user!=null) {
       await createUser(
            userName: name,
            email: user.email!,
           profilePic: image,
            uId: user.uid,
           phone: phone);
      }

      await Future.delayed(const Duration(seconds: 2),() {
        Navigator.of(context).pop(true);
      },);
    }on FirebaseAuthException catch (e){
      print(e.message);
      Navigator.of(context).pop(true);
      Fluttertoast.showToast(msg: e.message!,backgroundColor: Colors.red);
    }

  }
  String uid = fAuth.currentUser!.uid;
  //save user data
   createUser({
    required String userName,
    required String email,
    required String phone,
    required File profilePic,
    required String? uId,
  }) async{
    try{

      late String photoUrl ;

       photoUrl = await storeFileToFirebase('profileImg/$uid', profilePic,);

     UserModel model = UserModel(
        name: userName,
         email: email,
         profilePic: photoUrl,
         uid: uId!,
         phone: phone);

    await firestore.collection('users').doc(uId).set(model.toMap());

    }on FirebaseException catch (e){
      debugPrint(e.toString());
    }

  }


  File? image;
  final ImagePicker _picker = ImagePicker();

  selectImage(context) {
    try{
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading:  const Icon(Icons.photo_library),
                      title:  const Text('Gallery'),
                      onTap: () async{
                        await pickImg(isGallery: true);
                        Navigator.pop(context);
                      }),
                  ListTile(
                    leading:  const Icon(Icons.photo_camera),
                    title:  const Text('Camera'),
                    onTap: () async{
                      await pickImg(isGallery: false);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          });
      return true;
    }catch (e){
      print(e.toString());
      return false;
    }

  }

  Future pickImg({
    required bool isGallery
  }) async {
    final pickedFile = await _picker.pickImage(source: isGallery?ImageSource.gallery:ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    notifyListeners();
  }
}