import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

buildTextFormField({
  required String labelTitle,
  Function(String)? onChange,
  String? Function(String?)? validator,
  TextEditingController? controller,
  FocusNode? focusNode,
  bool isPassword=false,
  IconData? suffix,
  IconData? prefix,
  int maxLines=1,
  bool readOnly=false,
  VoidCallback? OnTap,
  Function(PointerDownEvent)? OnTapOutside,
  Function(String)? onSubmit,
  Function()? suffixPressed,
  TextInputType type=TextInputType.emailAddress,
  EdgeInsetsGeometry? padding=const EdgeInsets.fromLTRB(15, 0, 15, 0),
  InputBorder? border= const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10))
  )
}) {
  return Padding(
    padding:  EdgeInsets.only(bottom: 15.h),
    child: TextFormField(
      // textAlign: TextAlign.center,
      onFieldSubmitted: onSubmit,
      validator: validator ,
      obscureText: isPassword,
      keyboardType:type,
      maxLines: maxLines,
      controller:controller ,
      autovalidateMode:AutovalidateMode.onUserInteraction ,
      focusNode: focusNode,
      onChanged: onChange,
      onTap: OnTap,

      onTapOutside: OnTapOutside,
      decoration: InputDecoration(
          suffixIcon: IconButton(onPressed: suffixPressed, icon: Icon(suffix,color: Colors.purpleAccent)),
          prefixIcon: Icon(prefix,color: Colors.purpleAccent,) ,
          labelText: labelTitle,labelStyle: TextStyle(
          color: Color(0xff2e386b)
      ),
          contentPadding:  padding,
          border: border,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color(0xff2e386b),width: 1
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),

          focusedBorder:  OutlineInputBorder(
              borderSide: BorderSide(
                  color:  Colors.purpleAccent,width: 2
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))
          )
      ),
    ),
  );
}


valid(String val,int min,int max,{ bool isEmail=false,TextEditingController? contrller})
{

  if (val.isEmpty) {
    return 'can\'t be Empty';
  } if (val.length<min) {
    return 'can\'t be less than $min';
  }   if(val.length>max){
    return 'can\'t be greater than $max';
  } if (isEmail) {
    return !contrller!.text.contains ("@")? "E-mail Adress is no't valid" :null;
  }
}