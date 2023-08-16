import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../controller/provider/auth.dart';
import '../../../shared/utils/app_colors.dart';
import '../../../shared/utils/global.dart';
import '../../../shared/widgets/button.dart';
import '../../../shared/widgets/ttf.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<
      ScaffoldMessengerState>();


  CollectionReference suppliers = firestore.collection('suppliers');
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  final rePasswordController = TextEditingController();

  String passwordConfirmed='';
  bool isInside=false;
  bool passwordStrong=false;
  bool isPassword1=true;
  bool isPassword2=true;
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProv>(context);
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const AuthHeaderLabel(headerLabel: 'Sign Up'),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.purpleAccent,
                              backgroundImage: provider.image == null ? null
                                  : FileImage(File(provider.image!.path)),
                            ),
                          ),
                          const Column(
                            children: [
                              buildCameraPick(),
                              SizedBox(
                                height: 6,
                              ),
                              buildGalleryPick()
                            ],
                          )
                        ],
                      ),
                      // name
                      buildTextFormField(
                        controller: nameController,
                        type:TextInputType.name ,
                        labelTitle:'User Name' ,
                        prefix:Icons.person,

                        validator:(val) => valid(val!, 5, 40),
                      ),

                      //email
                      buildTextFormField(
                        controller: emailController,
                        type:TextInputType.emailAddress ,
                        labelTitle:'Email Address' ,
                        prefix:Icons.email_outlined,
                        OnTap:(){
                          setState(() {
                            isInside=false;
                          });
                        },

                        validator:(val) => valid(val!, 5, 40,isEmail: true,contrller: emailController),
                      ),
                      //password
                      StatefulBuilder(builder: (context, rebuild) =>
                         buildTextFormField(
                          controller: passwordController,
                          type:TextInputType.visiblePassword ,
                          labelTitle:'Password' ,prefix:Icons.lock_outline,
                          isPassword: isPassword1,
                          suffix: isPassword1?
                          Icons.visibility_off:Icons.visibility_outlined,
                          suffixPressed: (){
                            rebuild(() {
                              isPassword1=!isPassword1;
                            });
                          },
                          OnTap:(){
                            setState(() {
                              isInside=true;
                            });
                          },
                          onChange: (val) {
                            setState(() {
                              passwordConfirmed=val;
                            });
                          },

                          validator:(val) => valid(val!, 5, 40),
                        )
                      ),
                      isInside?Column(
                        children: [
                          //password validator
                          SizedBox(
                            height: 205,
                            child: FlutterPwValidator(
                              controller: passwordController,
                              minLength: 6,
                              uppercaseCharCount: 1,
                              numericCharCount: 3,
                              specialCharCount: 1,
                              width: 400,
                              height: 150,
                              onSuccess: (){
                                setState(() {
                                  passwordStrong=true;
                                });

                              },
                              onFail: (){
                                setState(() {
                                  passwordStrong=false;
                                });

                              },
                            ),
                          ),
                        ],
                      )
                          : Container(),


                      //confirm password
                      StatefulBuilder(
                          builder: (context, rebuild) =>
                            buildTextFormField(
                                controller: rePasswordController,
                                type:TextInputType.visiblePassword ,
                                labelTitle:'Confirm Password' ,prefix:Icons.lock_outline,
                                isPassword: isPassword2,
                                suffix: isPassword2?
                                Icons.visibility_off:Icons.visibility_outlined,
                                suffixPressed: (){
                                  rebuild(() {isPassword2=!isPassword2;});
                                },
                                OnTap:(){
                                  setState(() {
                                    isInside=false;
                                  });
                                },

                                validator:(val) {
                                  if (val!=passwordConfirmed) {
                                    return 'Non Identical Password..';
                                  }

                                },
                              )),

                      const SizedBox(
                        height: 20.0,
                      ),
                      // action
                      Consumer<AuthProv>(
                       builder: (context, provider, child) {
                       return Button(
                        color:AppColors.baseColor,text: 'register'.toUpperCase(),radius: 10,
                        onPressed:() async{
                          if (_formKey.currentState!.validate()) {
                            if (passwordStrong) {
                              await provider.register(context,
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  name: nameController.text.trim(),
                                  image: provider.image!,
                                  phone: ''
                              );
                            } else{
                              Fluttertoast.showToast(msg: "Password Weak");
                            }

                          }
                        },
                      );
  },
)

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class buildGalleryPick extends StatelessWidget {
  const buildGalleryPick({
    super.key,

  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: Consumer<AuthProv>(
        builder: (context, provider, child) {
          return IconButton(
            icon: const Icon(
              Icons.photo,
              color: Colors.white,
            ),
            onPressed: () {
              provider.pickImg(isGallery: true);
            },
          );
        },
      ),
    );
  }
}

class buildCameraPick extends StatelessWidget {
  const buildCameraPick({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15))),
      child: Consumer<AuthProv>(
        builder: (context, provider, child) {
          return IconButton(
            icon: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            onPressed: () {
              provider.pickImg(isGallery: false);
            },
          );
        },
      ),
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String headerLabel;

  const AuthHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerLabel,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/welcome_screen');
              },
              icon: const Icon(
                Icons.home_work,
                size: 40,
              ))
        ],
      ),
    );
  }
}