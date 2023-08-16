import 'package:flutter/material.dart';

import '../../view/screens/lay_out/home_screen/galleries/gallery_parts.dart';

List<String> tabListGallery = [
  'Men',
  'Women',
  'Shoes',
  'Bags',
  'Electronics',
  'Accessories',
  'Home & Garden',
  'Kids',
  'Beauty'
];

List<Widget> tabViewGallery = [
  MenGalleryScreen(txt: tabListGallery[0]),
  WomenGalleryScreen(txt: tabListGallery[1]),
  ShoesGalleryScreen(txt: tabListGallery[2]),
  BagsGalleryScreen(txt: tabListGallery[3]),
  ElectronicsGalleryScreen(txt: tabListGallery[4]),
  AccessoriesGalleryScreen(txt: tabListGallery[5]),
  HomeGardenGalleryScreen(txt: tabListGallery[6]),
  KidsGalleryScreen(txt: tabListGallery[7]),
  BeautyGalleryScreen(txt: tabListGallery[8])
];

List<String> maincateg = [
  'select category',
...tabListGallery
];
List<List<String>> maincategList=[
  men,
  women,
  shoes,
  bags,
  electronics,
  accessories,
  homeandgarden,
  kids,
  beauty,

];
//
List<String> men = [
  'subcategory',
  'shirt',
  't-shirt',
  'jacket',
  'vest',
  'coat',
  'jeans',
  'shorts',
  'suit',
  'other',
];
List<String> women = [
  'subcategory',
  'dress',
  '2pcs sets',
  't-shirt',
  'top',
  'skirt',
  'jeans',
  'pants',
  'coat',
  'jacket',
  'other'
];
List<String> electronics = [
  'subcategory',
  'phone',
  'computer',
  'laptop',
  'smart tv',
  'phone holder',
  'charger',
  'usb cables',
  'head phone',
  'smart watch',
  'tablet',
  'mouse',
  'keyboard',
  'gaming',
  'other'
];

List<String> shoes = [
  'subcategory',
  'men slippers',
  'men classic',
  'men casual',
  'men boots',
  'men canvas',
  'men sport',
  'men snadals',
  'home slippers',
  'women slippers',
  'women boots',
  'women heels',
  'women sport',
  'women snadals',
  'other'
];

List<String> homeandgarden = [
  'subcategory',
  'living room',
  'bed room',
  'dinning room',
  'kitchen tools',
  'bath access.',
  'furniture',
  'decoration',
  'lighting',
  'garden',
  'other'
];

List<String> beauty = [
  'subcategory',
  'body care',
  'hair care',
  'men perfume',
  'women perfume',
  'make up',
  'other'
];

List<String> accessories = [
  'subcategory',
  'hat',
  'men sunglass',
  'w sunglass',
  'classic watch',
  'gloves',
  'belt waist',
  'ring',
  'necklace',
  'scarf set',
  'anklet',
  'other'
];

List<String> kids = [
  'subcategory',
  'girls sets',
  'girls dress',
  'girls top',
  'girls pants',
  'jacket',
  'sweatshirts',
  'boys sets',
  'boys top',
  'boys pants',
  'home wear',
  'boys suits',
  'baby shoes',
  'other'
];

List<String> bags = [
  'subcategory',
  'wallet',
  'clutch',
  'chest bag',
  'back pack',
  'business bags',
  'laptop bags',
  'women bags',
  'other'
];


//
// List<Widget> tabViewCat =const[
// MenCategory(),
// WomenCategory(),
// ShoesCategory(),
// BagsCategory(),
// ElectronicsCategory(),
// AccessoriesCategory(),
// HomeGardenCategory(),
// KidsCategory(),
// BeautyCategory(),
// ];

