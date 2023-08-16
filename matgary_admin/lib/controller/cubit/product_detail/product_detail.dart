import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../../shared/utils/app_methods.dart';
import 'ProDetailState.dart';

class ProDetailBloc extends Cubit<ProDetailState>{

  ProDetailBloc():super(initialState());

  Database? db ;
  List<Map> saveData = [];

  clearItem(index){
    saveData.removeAt(index);
    emit(clearItemSuccess());
  }
  void createDatabase() async {
    db = await openDatabase(
        'MATGAR.db',
        version: 1,
        onCreate: (database,version)
        {
          database.execute("CREATE TABLE MATGAR (proid TEXT)").then((_)
          {

            print("MATGAR Table created successfully");
          }).catchError((e)=>print("error during create table"));
        },
        onOpen: (database)
        {
          // get Data from Database Method & emit()
          getDatabase(database);
          print("MATGAR.db opened successfully");
        }
    );
    emit(createDatabaseSuccess());
  }

  // 2. Insert Data to food table
  Future<void> InsertTODatabase(context,{
    required String idProduct,

  })
  async {

    try{

      await db?.transaction((txn) async {
        txn.rawInsert('INSERT INTO MATGAR(proid) VALUES ("$idProduct")').
        whenComplete((){
          print('...........................................');
          print("Data was inserted to Database where idProduct is .............$idProduct");
          showSnackBar(
            context,"item added to Favourite successfully",
            backgroundColor: Colors.green,
          );
          getDatabase(db!);
        });


      });

    }catch (e){
      print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
      print(e.toString());
    }

    emit(InsertTODatabaseSuccess());
  }

  // 3. get Data form Database
  Future getDatabase(Database database,)
  {
    // saveData.clear();
    return database.rawQuery("SELECT * FROM MATGAR").then((value)
    {
      saveData=value;
      print('$value'.toString());
      emit(getDatabaseSuccess());
    }).catchError((e){
      print("error during get data from database");
      emit(getDatabaseFail());
    });
  }

  Future<void>DeleteDatebase(context,{required String id}) async{
    try{
      await db?.rawUpdate(
          'DELETE FROM FOOD WHERE proid = ?',
          [id]
      ).whenComplete((){
        print('deleted..................................  $id');
        showSnackBar(
          context,"item Favourite Successfully" ,
        );
      });
      getDatabase(db!);
      emit(DeleteDatebaseSuccess());
    }catch (e){
      print('.....................');
      print(e.toString());
      emit(DeleteDatebaseFail());
    }

  }


}
