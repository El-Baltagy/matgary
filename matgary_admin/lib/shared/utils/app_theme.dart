import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:matgary_admin/shared/utils/app_colors.dart';


final lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Poppins',
  // primarySwatch: primaryColor,
  iconTheme:const IconThemeData(
      color: AppColors.primaryColor
  ) ,
  primaryColor: AppColors.primaryColor,
  primarySwatch: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.lightBackgroundColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color:Colors.black ),
    systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent,
        statusBarIconBrightness:Brightness.dark,
        systemNavigationBarColor:Colors.transparent ),
  ),
  textTheme: const TextTheme(

      labelLarge: TextStyle(color: Colors.red)),
  // colorScheme: ColorScheme(background: lightBackgroundColor)
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Poppins',
  primaryColor: AppColors.primaryColor,
  backgroundColor: AppColors.darkBackgroundColor,
  scaffoldBackgroundColor: const Color(0xFF00040F),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color:Colors.white ),
      backgroundColor: Colors.transparent,systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:Brightness.light,systemNavigationBarColor:Colors.transparent)
  ),
  textTheme: const TextTheme(
    labelLarge: TextStyle(color: AppColors.darkTextColor),
  ),

);



extension ThemeExtras on ThemeData {

  static Brightness get currentSystemBrightness =>
      SchedulerBinding.instance.window.platformBrightness;

  Color get textColor => brightness == Brightness.light
      ?  Colors.grey
      : Colors.white;

//theme
  String get textTh => brightness == Brightness.dark
      ?  "Dark Mode": "Light Mode";
  IconData get iconTh => brightness == Brightness.dark
      ?   Icons.dark_mode_outlined: Icons.light_mode;
  Color get iconCo => brightness == Brightness.dark
      ?   primaryColor: Colors.grey;
  bool get boolTh => brightness == Brightness.light
      ?   true: false;


}
