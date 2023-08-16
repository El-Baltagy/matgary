import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matgary_admin/shared/utils/app_colors.dart';
import '../../../shared/utils/global.dart';
import '../../../shared/widgets/button.dart';
import '../../../shared/widgets/ttf.dart';


class ForgetPasswordSC extends StatelessWidget {
  ForgetPasswordSC({super.key});
  final emailController=TextEditingController();
  final  GlobalKey<FormState> formKey=GlobalKey<FormState>();



  Future<void> resetPassword()async{
    try{
      await fAuth.sendPasswordResetEmail(email: emailController.text.trim());
      Fluttertoast.showToast(msg: "Password reset Link has been sent to your mail");
    }on FirebaseException catch(e){
      print(e.toString());
    };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back,color: AppColors.primaryColor,)),
      ),
      body:Form(
        key:formKey ,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(

            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                'Enter Your Email and we will send you a Password reset Link',
                // style: ,
              ),
              const SizedBox(
                height: 30,
              ),
              buildTextFormField(
                controller: emailController,
                type:  TextInputType.emailAddress ,
                labelTitle:'Email Address' ,
                prefix:Icons.email_outlined,
                validator:(val) => valid(val!, 5, 40,isEmail: true,contrller: emailController),
              ),
              Button(
                  color:AppColors.primaryColor,
                  text: 'reset password'.toUpperCase(),
                  onPressed:() async{
                    if (formKey.currentState!.validate()) {
                      await resetPassword();

                    }
                  }
              )
            ],
          ),
        ),
      ) ,
    );
  }
}
