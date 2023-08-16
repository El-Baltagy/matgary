class ProductModel {
  final double price;
  final int quantity;
  final String proName;
  final String proDesc;
  final String proId;
  final String uId;
  final int discount ;
  final List<String> imagesUrlList ;
  final String mainCategValue ;
  final String subCategValue ;
  ProductModel(   {
    required this.price,
    required this.quantity,
    required  this.proName,
    required  this.proDesc,
    required this.proId,
    required this.uId,
    required this.discount,
    required this.imagesUrlList,
    required this.mainCategValue,
    required this.subCategValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'proid': proId,
      'maincateg': mainCategValue,
      'subcateg': subCategValue,
      'price': price,
      'instock': quantity,
      'proname': proName,
      'prodesc': proDesc,
      'uid': uId,
      'proimages': imagesUrlList,
      'discount': discount,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      proId: map['proid'] ,
      uId:  map['uId'],
      mainCategValue: map['maincateg'] ,
      subCategValue: map['subcateg'] ,
      price: map['price'] ,
      quantity: map['instock'] ,
      proName:  map['proname'],
      proDesc:  map['prodesc'],
      imagesUrlList:  map['proimages'],
      discount:  map['discount'],
    );
  }
}
