import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matgary_user/view/screens/lay_out/profile/profile.dart';
import 'package:provider/provider.dart';
import '../../../controller/provider/product_detail.dart';
import '../../../shared/utils/global.dart';
import 'cart/cart.dart';
import 'categorey/catogery_sc.dart';
import 'home_screen/home.dart';

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({Key? key}) : super(key: key);

  @override
  _SupplierHomeScreenState createState() => _SupplierHomeScreenState();
}

class _SupplierHomeScreenState extends State<SupplierHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<ProductDetailProv>(context);

    return Scaffold(
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
          ),

          BottomNavigationBarItem(
            icon: badges.Badge(
                showBadge: provider.cartData.isEmpty ? false : true,
                padding: const EdgeInsets.all(2),
                badgeColor: Colors.yellow,
                badgeContent: Text(
                  provider.cartData.length.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                child: const Icon(Icons.shopping_cart)),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),

        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}


final List<Widget> tabs = [
  const HomeScreen(),
  const CategoryScreen(),
  const CartScreen(),
  ProfileScreen(
    documentId: fAuth.currentUser!.uid,
  ),
];