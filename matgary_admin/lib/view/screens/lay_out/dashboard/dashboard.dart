import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matgary_admin/shared/utils/app_methods.dart';
import '../../../../shared/utils/global.dart';
import '../../../../shared/widgets/app_bar_widgets.dart';
import '../../../../shared/widgets/capertino_dialouge.dart';
import 'minor_sc/manage_products.dart';
import 'minor_sc/supplier_balance.dart';
import 'minor_sc/supplier_orders/supplier_orders.dart';
import 'minor_sc/supplier_statics.dart';
import 'minor_sc/visit_store.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Dashboard',
        ),
        actions: [
          IconButton(
              onPressed: () {
               showMyDialog(
                    context: context,
                    title: 'Log Out',
                    content: 'Are you sure to log out ?',
                    tabNo: () {
                      Navigator.pop(context);
                    },
                    tabYes: () async {
                      await fAuth.signOut();

                    });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          crossAxisCount: 2,
          children: List.generate(icons.length, (index) {
            return InkWell(
              onTap: () {
             GoPage.push(context, path: pages[index]);
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.purpleAccent.shade200,
                color: Colors.blueGrey.withOpacity(0.7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      icons[index],
                      size: 50,
                      color: Colors.yellowAccent,
                    ),
                    Text(
                      label[index].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 24,
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          fontFamily: 'Acme'),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
List<String> label = [
  'my store',
  'orders',
  'manage products',
  'balance',
  'statics'
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart
];

List<Widget> pages = [
  VisitStore(suppId: fAuth.currentUser!.uid),
  const SupplierOrders(),
  const ManageProducts(),
  const Balance(),
  const Statics()
];