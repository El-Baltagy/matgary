import 'package:flutter/material.dart';
import '../../shared/network/local/cach_helper.dart';


class ThemeProv extends ChangeNotifier{
  bool isDarkTheme=CashHelper.getBoolean(key: 'theme')??false;

  void updateTheme(context ) {


    isDarkTheme=!isDarkTheme;

    CashHelper.saveData(key: 'theme', value: isDarkTheme);
    print('saved succefully.......................................');

    notifyListeners();
  }
}