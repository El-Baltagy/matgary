import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matgary_admin/shared/utils/app_colors.dart';
import 'package:matgary_admin/view/screens/auth/supplier_sign_up.dart';

import '../../../controller/cubit/auth/auth_cubit.dart';
import '../../../shared/utils/app_methods.dart';
import '../../../shared/widgets/button.dart';
import '../../../shared/widgets/ttf.dart';
import 'forget_password.dart';


class SupplierLogin extends StatefulWidget {
  const SupplierLogin({Key? key}) : super(key: key);

  @override
  _SupplierLoginState createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPassword=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextFormField(
                      controller: emailController,
                      type:  TextInputType.emailAddress ,
                      labelTitle:'Email Address' ,
                      prefix:Icons.email_outlined,
                      validator:(val) => valid(val!, 5, 40,isEmail: true,contrller: emailController),
                    ),
                    StatefulBuilder(
                      builder: (context, rebuild) => buildTextFormField(
                        controller:passwordController ,
                        type:TextInputType.visiblePassword,
                        labelTitle:'Password',
                        prefix: Icons.lock_outline,
                        suffix: isPassword?
                        Icons.visibility_off:Icons.visibility_outlined,
                        isPassword: isPassword,
                        suffixPressed:() {
                          rebuild(() {
                            isPassword = !isPassword;
                          });
                        },
                        validator: (val) =>valid(val!, 5, 40),
                      ), ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () {
                          GoPage.push(context, path: ForgetPasswordSC());
                        }, child: const Text('Forget Your Password'))
                      ],
                    ),
                    Button(
                        color:AppColors.primaryColor,
                        padding: 2,
                        text: 'login'.toUpperCase(),
                        onPressed:() async{
                          if (_formKey.currentState!.validate()) {
                            await context.read<AuthBloc>().signIn(context,
                              emailController.text.trim(),
                              passwordController.text.trim(),);
                          }
                        }
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Don\'t Have Account? ',
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                        TextButton(
                            onPressed: (){
                              GoPage.push(context, path: const SupplierRegister());
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
