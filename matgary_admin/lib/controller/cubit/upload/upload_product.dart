import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:matgary_admin/controller/cubit/upload/upload_product_state.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/utils/app_list.dart';
import '../../../models/product_model.dart';
import '../../../shared/utils/app_methods.dart';
import '../../../shared/utils/global.dart';

class UploadProBloc extends Cubit<UploadProState>{

  UploadProBloc():super(initialState());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();
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
        emit(pickProductImagesSuccess());
    } catch (e) {
      print(e.toString());
      emit(pickProductImagesFail());
    }
  }


  void selectedMainCateg(String? value) {
    for(int i=0;i<maincateg.length;i++){
      if (value == 'select category') {
        subCategList = [];
      }else{
        if (value==maincateg[i]) {
          subCategList=maincategList[i-1];
        }
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
    emit(selectedMainCategSuccess());
  }
  void selectedSubCateg(String? value){
    subCategValue=value!;
    emit(selectedSubCategSuccess());
  }
  void savePrice(String? value){
    price = double.parse(value!);
    emit(savePriceSuccess());
  }
  void saveDiscount(String? value){
    discount = int.parse(value!);
    emit(saveDiscountSuccess());
  }
  void saveQuantity(String? value){
    quantity = int.parse(value!);
    emit(saveQuantitySuccess());
  }
  void saveProductName(String? value){
    proName = value!;
    emit(saveProductNameSuccess());
  }
  void saveProDesc(String? value){
    proDesc = value!;
    emit(saveProDescSuccess());
  }

  floatingAction1st(){
    imagesFileList!.isEmpty?
    pickProductImages():
    imagesFileList! .clear();
    emit(floatingAction1stSuccess());
  }

  //uplaod data
  void uploadProduct() async {
    await uploadImages().whenComplete(() => uploadData());
    emit(uploadProductSuccess());
  }

  Future<void> uploadImages() async {

    try{
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
      emit(uploadImagesSuccess());

    }catch (e){
      print(e.toString());
      showSnackBar(scaffoldKey, e.toString());
      emit(uploadImagesFail());

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
      }).catchError((e){

      });
      emit(uploadDataSuccesss());
    } else {
      print('no images');
    }
  }


}