import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/utils/app_list.dart';
import '../../models/product_model.dart';
import '../../shared/utils/app_methods.dart';
import '../../shared/utils/global.dart';

class UploadProv extends ChangeNotifier{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  final ImagePicker _picker = ImagePicker();

  String mainCategValue = 'select category';
  String subCategValue = 'subcategory';

  late String proId;

  late double price;
  late int quantity;
  late String proName;
  late String proDesc;
   int discount = 0;

  List<String> subCategList = [];
  List<String> imagesUrlList = [];

  List<XFile>? imagesFileList = [];

  void pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
        imagesFileList = pickedImages;

    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }


  void selectedMainCateg(String? value) {
    for(int i=0;i<maincateg.length;i++){
      if (value == 'select category') {
        subCategList = [];
      }else{
        subCategList=maincategList[i];
      }
    }
    // if (value == 'select category') {
    //   subCategList = [];
    // } else if (value == 'men') {
    //   subCategList = men;
    // } else if (value == 'women') {
    //   subCategList = women;
    // } else if (value == 'electronics') {
    //   subCategList = electronics;
    // } else if (value == 'accessories') {
    //   subCategList = accessories;
    // } else if (value == 'shoes') {
    //   subCategList = shoes;
    // } else if (value == 'home & garden') {
    //   subCategList = homeandgarden;
    // } else if (value == 'beauty') {
    //   subCategList = beauty;
    // } else if (value == 'kids') {
    //   subCategList = kids;
    // } else if (value == 'bags') {
    //   subCategList = bags;
    // }
    print(value);
      mainCategValue = value!;
      subCategValue = 'subcategory';
   notifyListeners();
  }
  void selectedSubCateg(String? value){
    subCategValue=value!;
    notifyListeners();
  }
  void savePrice(String? value){
    price = double.parse(value!);
    notifyListeners();
  }
  void saveDiscount(String? value){
    discount = int.parse(value!);
    notifyListeners();
  }
  void saveQuantity(String? value){
    quantity = int.parse(value!);
    notifyListeners();
  }
  void saveProductName(String? value){
    proName = value!;
    notifyListeners();
  }
  void saveProDesc(String? value){
    proDesc = value!;
    notifyListeners();
  }

  floatingAction1st(){
    imagesFileList!.isEmpty?
    pickProductImages():
    imagesFileList! .clear();
    notifyListeners();
  }

  //uplaod data
  void uploadProduct() async {
    await uploadImages().whenComplete(() => uploadData());
  }

  Future<void> uploadImages() async {
    if (mainCategValue != 'select category' && subCategValue != 'subcategory') {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        if (imagesFileList!.isNotEmpty) {

            for (var image in imagesFileList!) {
              Reference ref =firestorage
                  .ref('products/${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imagesUrlList.add(value);
                });
              });
            }
        } else {
          showSnackBar(
              scaffoldKey, 'please pick images first');
        }
      } else {
        showSnackBar(scaffoldKey, 'please fill all fields');
      }
    }
    else {
      showSnackBar(scaffoldKey, 'please select categories');
    }
    try{

    }catch (e){
      print(e.toString());
      showSnackBar(scaffoldKey, e.toString());
    }
  }

  void uploadData() async {
    if (imagesUrlList.isNotEmpty) {
      CollectionReference productRef = firestore.collection('products');

      proId = const Uuid().v4();
      ProductModel _productModel=ProductModel(
        proId: proId ,
        uId: fAuth.currentUser!.uid ,
        mainCategValue: mainCategValue,
        subCategValue: subCategValue,
        price:  price,
        quantity: quantity,
        proName:proName  ,
        proDesc:  proDesc,
        imagesUrlList:imagesUrlList  ,
        discount: discount ,
      );
      await productRef.doc(proId).set(
          _productModel.toMap()).whenComplete(() {
          imagesFileList = [];
          mainCategValue = 'select category';
          subCategList = [];
          imagesUrlList = [];

        formKey.currentState!.reset();
      });
      notifyListeners();
    } else {
      print('no images');
    }
  }


}