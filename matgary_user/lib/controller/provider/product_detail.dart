import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../shared/utils/app_methods.dart';


class ProductDetailProv extends ChangeNotifier{

  // double get totalPrice {
  //   var total = 0.0;
  //
  //   for (var item in _list) {
  //     total += item.price * item.qty;
  //   }
  //   return total;
  // }

  Database? db ;
  List<Map> cartData = [];


  void clearCart() {
    cartData.clear();
    notifyListeners();
  }
  clearItem(index){
    cartData.removeAt(index);

  }
  void createDatabase() async {
    db = await openDatabase(
        'CART.db',
        version: 1,
        onCreate: (database,version)
        {
          database.execute("CREATE TABLE CART (proid TEXT,proname TEXT,prodesc TEXT,proimages TEXT,price TEXT,totalPrice TEXT,discount INTEGER ,quantity INTEGER )").then((value)
          {
            notifyListeners();
            print("CCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
            print("CART Table created successfully");
          }).catchError((e)=>print("error during create table"));
        },
        onOpen: (database)
        {
          // get Data from Database Method & emit()
          getDatabase(database);
          print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
          print("CART.db opened successfully");
        }
    );
  }

  // 2. Insert Data to food table
  Future<void> InsertTODatabase(context,{
    required String idProduct,
    required String proname,
    required String proimages,
    required String price,
    required String totalPrice,
    required int discount,

  })
  async {
    print('......................$idProduct');

    try{

      await db?.transaction((txn) async {
        txn.rawInsert('INSERT INTO CART(proid,proname,proimages,price,totalPrice,discount,quantity) VALUES ("$idProduct","$proname","$proimages","$price","$totalPrice","$discount","1",)').
        whenComplete((){
          print('...........................................');
          print("Data was inserted to Database where idProduct is .............$idProduct");
          showSnackBar(
            context,"item deleted from Cart successfully",
            backgroundColor: Colors.green,
          );
          getDatabase(db!);
        });


      });

    }catch (e){
      print('IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII');
      print(e.toString());
    }

    notifyListeners();
  }

  // 3. get Data form Database
  Future getDatabase(Database database,)
  {
    // saveData.clear();
    return database.rawQuery("SELECT * FROM CART").then((value)
    {
      cartData=value;
      print('$value'.toString());
      notifyListeners();
    }).catchError((e)=>print("error during get data from database"));
  }

  Future<void>DeleteDatebase(context,{required String id}) async{
    try{
      await db?.rawUpdate(
          'DELETE FROM CART WHERE proid = ?',
          [id]
      ).whenComplete((){
        print('deleted..................................  $id');
        showSnackBar(
          context,"item added to cart Successfully" ,
        );
      });
      getDatabase(db!);
    }catch (e){
      print('DDDDDDDDDDDDDDDDDDDDDDDDD');
      print(e.toString());
    }

  }

  void updateDatebase({required String id,required bool isIncrease})async{
    try{
      double? qnt;
       double? price;

      List<Map<String, dynamic>>? list = await db?.rawQuery('SELECT * FROM CART WHERE proid = ?', [id]);

      qnt=double.parse((list?[0]['quantity']!).toString());
      price=double.parse(list?[0]['price']!);

      final totalQnt=isIncrease?qnt++:qnt--;
      final totalPrice=(totalQnt*price).toString();

      await db?.rawUpdate(
    'UPDATE CART SET quantity = $totalQnt ,totalPrice=$totalPrice WHERE proid = ?',
    [id]
    ).whenComplete((){
    print('updated..................................  $id');

    });
      notifyListeners();
    getDatabase(db!);
    }catch (e){
    print('UUUUUUUUUUUUUUUUUUUUUUUUU');
    print(e.toString());
    }
    notifyListeners();
  }


}
