import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matgary_admin/shared/utils/app_colors.dart';
import '../../../controller/cubit/auth/auth_cubit.dart';
import '../../../controller/cubit/auth/auth_state.dart';
import '../../../shared/widgets/button.dart';
import '../../../shared/widgets/ttf.dart';


class SupplierRegister extends StatefulWidget {
  const SupplierRegister({Key? key}) : super(key: key);

  @override
  _SupplierRegisterState createState() => _SupplierRegisterState();
}

class _SupplierRegisterState extends State<SupplierRegister> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  String passwordConfirmed='';
  bool isPassword1=true;
  bool isPassword2=true;
  // IconData suffix = Icons.visibility_outlined;
  // bool isPassword = true;
final passwordFocus=FocusNode();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AuthHeaderLabel(headerLabel: 'Sign Up'),
                     const Row(
                      children: [
                        BuildImageAvatar(),
                        Column(
                          children: [
                            buildImagePick(isGallery: true,),
                            SizedBox(
                              height: 6,
                            ),
                            buildImagePick(isGallery: false,)
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
                      validator:(val) => valid(val!, 5, 40,isEmail: true,contrller: emailController),
                    ),
                    //password
                    StatefulBuilder(builder: (context, rebuild) =>
                       buildTextFormField(
                        controller: passwordController,
                        type:TextInputType.visiblePassword ,
                        labelTitle:'Password' ,prefix:Icons.lock_outline,
                        isPassword: isPassword1,
                        focusNode: passwordFocus,
                        suffix: isPassword1?
                        Icons.visibility_off:Icons.visibility_outlined,
                        suffixPressed: (){
                          rebuild(() {
                            isPassword1=!isPassword1;
                          });
                        },
                        onSubmit: (val) {
                          setState(() {
                            passwordConfirmed=val;
                          });
                        },

                        validator:(val) => valid(val!, 5, 40),
                      )
                    ),
                    passwordFocus.hasFocus
                    ?BuildPWValidator(passwordController: passwordController)
                    // Column(
                    //   children: [
                    //     //password validator
                    //     SizedBox(
                    //       height: 205,
                    //       child: FlutterPwValidator(
                    //         controller: passwordController,
                    //         minLength: 6,
                    //         uppercaseCharCount: 1,
                    //         numericCharCount: 3,
                    //         specialCharCount: 1,
                    //         width: 400,
                    //         height: 150,
                    //         onSuccess: (){
                    //           setState(() {
                    //             passwordStrong=true;
                    //           });
                    //
                    //         },
                    //         onFail: (){
                    //           setState(() {
                    //             passwordStrong=false;
                    //           });
                    //
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // )
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
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final bloc=context.watch()<AuthBloc>();
                     return Button(
                      color:AppColors.baseColor,text: 'register'.toUpperCase(),radius: 10,
                      onPressed:() async{
                        if (_formKey.currentState!.validate()) {
                          if (bloc.passwordStrong) {
                            await  context.read<AuthBloc>().register(context,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                name: nameController.text.trim(),
                                image:  bloc.image!
                            );
                          } else{
                            Fluttertoast.showToast(msg: "Password Weak");
                          }

                        }
                      },
                    );
  },
),

                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}

class BuildPWValidator extends StatelessWidget {
  const BuildPWValidator({super.key, required this.passwordController});

  final TextEditingController passwordController;
  @override
  Widget build(BuildContext context) {
    final bloc=BlocProvider.of<AuthBloc>(context,listen: false);
    return Column(
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
              bloc.changePassword(true);
            },
            onFail: (){
              bloc.changePassword(false);
            },
          ),
        ),
      ],
    );
  }
}

class BuildImageAvatar extends StatelessWidget {
  const BuildImageAvatar({
    super.key,

  });


  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
           horizontal: 40),
      child: bloc.image == null ?Container(
        color: Colors.green,
      ):CircleAvatar(
        radius: 60,
        backgroundColor: Colors.purpleAccent,
        backgroundImage:  FileImage(File(bloc.image!.path)),
      ),
    );
  }
}

class buildImagePick extends StatelessWidget {
  const buildImagePick({
    super.key, required this.isGallery,

  });
final bool isGallery;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context,listen: false);
    return Container(
      decoration: const BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: IconButton(
        icon:  Icon(
          isGallery?Icons.photo:Icons.camera_alt,
          color: Colors.white,
        ),
        onPressed: () {
            bloc.pickImg(isGallery: isGallery);


        },
      ),
    );
  }
}

// class buildCameraPick extends StatelessWidget {
//   const buildCameraPick({
//     super.key,
//   });
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           color: Colors.purple,
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(15),
//               topRight: Radius.circular(15))),
//       child: Consumer<AuthProv>(
//         builder: (context, provider, child) {
//           return IconButton(
//             icon: const Icon(
//               Icons.camera_alt,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               provider.pickImg(isGallery: false);
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class AuthHeaderLabel extends StatelessWidget {
  final String headerLabel;

  const AuthHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerLabel,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}