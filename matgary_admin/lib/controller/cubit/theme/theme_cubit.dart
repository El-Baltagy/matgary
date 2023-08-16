import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matgary_admin/controller/cubit/theme/theme_state.dart';

import '../../../shared/network/local/cach_helper.dart';


class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(initiallState());
  static ThemeCubit get(context) => BlocProvider.of(context);

  bool isDarkTheme=CashHelper.getBoolean(key: 'theme')??false;



// Future<bool> setDark(value){
//   return CashHelper.saveData(key: 'theme', value: value);
// }
  void updateTheme(context ) {
    emit(loadingState());
    isDarkTheme=!isDarkTheme;
    emit(themeState());
    CashHelper.saveData(key: 'theme', value: isDarkTheme);
    print('saved succefully.......................................');
    // RestartWidget.restartApp(context);
    emit(initiallState());
  }
}
