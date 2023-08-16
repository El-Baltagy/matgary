import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matgary_admin/shared/network/local/cach_helper.dart';
import 'package:matgary_admin/shared/utils/app_theme.dart';
import 'package:matgary_admin/shared/utils/global.dart';
import 'package:matgary_admin/shared/widgets/loader.dart';
import 'package:matgary_admin/view/screens/auth/supplier_login.dart';
import 'package:matgary_admin/view/screens/lay_out/lay_out.dart';
import 'controller/cubit/auth/auth_cubit.dart';
import 'controller/cubit/bloc_observe.dart';
import 'controller/cubit/product_detail/product_detail.dart';
import 'controller/cubit/theme/theme_cubit.dart';
import 'controller/cubit/upload/upload_product.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CashHelper.init();

  runApp(
      MultiBlocProvider(
      providers:[
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => ProDetailBloc()..createDatabase()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => UploadProBloc()),

  ],
      child:
      const MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Matgary Admin',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: BlocProvider.of<ThemeCubit>(context).isDarkTheme? ThemeMode.dark: ThemeMode.light,

          home:
          StreamBuilder(
            stream: fAuth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }

              if (snapshot.hasData ) {
                return const SupplierHomeScreen();
              }

              return  const SupplierLogin();
            },
          ),
        );
      },
    );
  }
}
