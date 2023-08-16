import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matgary_admin/shared/utils/app_colors.dart';
import 'package:matgary_admin/shared/utils/global.dart';
import 'package:matgary_admin/view/screens/lay_out/stores/stores.dart';
import 'package:matgary_admin/view/screens/lay_out/upload/upload_product.dart';
import '../../../controller/cubit/product_detail/ProDetailState.dart';
import '../../../controller/cubit/product_detail/product_detail.dart';
import '../../../shared/widgets/loader.dart';
import 'dashboard/dashboard.dart';
import 'favorite/fav_sc.dart';
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
    final bloc=BlocProvider.of<ProDetailBloc>(context);
    print('stmmmmmmmmmmmmmmmmmmmmmmmmmm');
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('orders')
            .where('uid', isEqualTo: fAuth.currentUser!.uid)
            .where('deliverystatus', isEqualTo: 'preparing')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          return Scaffold(
            body: tabs[_selectedIndex],
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

            floatingActionButton:  BlocBuilder<ProDetailBloc, ProDetailState>(
                builder: (context, state) {
                   return badges.Badge(

                showBadge: bloc.saveData.isEmpty ? false : true,
                alignment: AlignmentDirectional.bottomEnd,
                stackFit: StackFit.loose,
                badgeColor: Theme.of(context).scaffoldBackgroundColor,
                badgeContent: Text(
                  bloc.saveData.length.toString(),
                  style: const TextStyle(
                      fontSize: 22,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 4;
                      });
                    },
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          _selectedIndex==4?Colors.transparent:Colors.grey,
                          BlendMode.srcATop),
                      child: Lottie.asset('assets/animation_love.json',
                          // width: 35,
                          // frameRate: FrameRate(60),
                          height: 40.h,
                          fit: BoxFit.cover,
                          repeat: true,
                          alignment: AlignmentDirectional.center
                      ),
                    )));
  },
),


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
                  icon: Icon(Icons.shop),
                  label: 'Stores',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.upload),
                  label: 'Upload',
                ),
                BottomNavigationBarItem(
                  icon: badges.Badge(
                      showBadge: snapshot.data!.docs.isEmpty ? false : true,
                      padding: const EdgeInsets.all(2),
                      badgeColor: Colors.yellow,
                      badgeContent: Text(
                        snapshot.data!.docs.length.toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      child: const Icon(Icons.dashboard)),
                  label: 'Dashboard',
                ),

              ],
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          );
        });
  }
}
const List<Widget> tabs = [
  HomeScreen(),
  StoresScreen(),
  UploadProductScreen(),
  DashboardScreen(),
  FavScreen()
];