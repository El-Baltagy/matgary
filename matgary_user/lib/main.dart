import 'package:flutter/material.dart';
import 'package:matgary_user/shared/utils/app_theme.dart';
import 'package:matgary_user/shared/utils/global.dart';
import 'package:matgary_user/shared/widgets/loader.dart';
import 'package:matgary_user/view/screens/auth/customer_login.dart';
import 'package:matgary_user/view/screens/lay_out/lay_out.dart';
import 'package:provider/provider.dart';
import 'controller/provider/auth.dart';
import 'controller/provider/product_detail.dart';
import 'controller/provider/theme.dart';
import 'controller/provider/upload_product.dart';



void main() {
  runApp( MultiProvider(
      providers:[
        Provider(create: (context) => AuthProv()),
        Provider(create: (context) => ThemeProv()),
        Provider(create: (context) => UploadProv()),
        Provider(create: (context) => ProductDetailProv()..createDatabase()),

      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matgary Admin',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeProv>(context).isDarkTheme? ThemeMode.dark: ThemeMode.light,

      home:  StreamBuilder(
        stream: fAuth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          if (snapshot.hasData ) {
            return const SupplierHomeScreen();
          }
          return  const Login();
        },
      ),
    );
  }
}

