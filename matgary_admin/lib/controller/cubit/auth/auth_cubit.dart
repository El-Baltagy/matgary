import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/user_model.dart';
import '../../../shared/utils/app_methods.dart';
import '../../../shared/utils/global.dart';
import '../../../shared/widgets/progrfess_dialouge.dart';
import 'auth_state.dart';

class AuthBloc extends Cubit<AuthState>{

  AuthBloc():super(initialState());

//dialouge
  late BuildContext buildContext;
  showDialouge(context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          buildContext=c;
          return ProgressDialog(message: "Processing, Please wait...",);
        }
    );
    emit(showDialougeSuccess());
  }
  hideDialouge(context,{int duration=2})async{
    await Future.delayed( Duration(seconds: duration),() {
      Navigator.of(context).pop('buildContext');
    },);
    emit(hideDialougeSuccess());
  }

  //sign in with email password

  signIn(context,String email,String password,)async{
    showDialouge(context);
    try{
      User? user= (await fAuth.signInWithEmailAndPassword(email: email, password: password)).user;
      if (user!=null) {

        await Future.delayed(const Duration(seconds: 2),() {
          Navigator.of(context).pop('buildContext');
        },);
      }
      emit(signInSuccess());
      hideDialouge(context);
    }on FirebaseAuthException catch  (e){
      print(e.toString());
      emit(signInFail());
      hideDialouge(context,duration: 1);
    }


  }


  //Register
 Future<bool?> register(BuildContext context,
      {required String email,
        required String password,
        required File image,
        required String name,
         })async{
   showDialouge(context);
    try{
      UserCredential userC=await fAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user=userC.user;
      if (user!=null) {
       await createUser(
            userName: name,
            email: user.email!,
           profilePic: image,
            uId: user.uid);}
      emit(registerSuccess());
      ()=> hideDialouge(context);

    }on FirebaseAuthException catch (e){
      print(e.message);
      Fluttertoast.showToast(msg: e.message!,backgroundColor: Colors.red);
      emit(registerFail());
      hideDialouge(context,duration: 1);
    }

  }


  //save user data

  String uid = fAuth.currentUser!.uid;
   createUser({
    required String userName,
    required String email,
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
         uid: uId!,);

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
      emit(pickImgSuccess());
      return true;
    }catch (e){
      emit(pickImgFail());
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
      emit(pickImgSuccess());
    } else {
      print('No image selected.');
      emit(pickImgFail());
    }

  }

  //password
  bool passwordStrong=false;
  changePassword(bool val){
    passwordStrong=val;
    emit(passwordChange());
  }



}