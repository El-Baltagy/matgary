import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matgary_admin/shared/utils/app_methods.dart';
import '../../../../shared/utils/global.dart';
import '../../../../shared/widgets/app_bar_widgets.dart';
import '../dashboard/minor_sc/visit_store.dart';


class StoresScreen extends StatefulWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  _StoresScreenState createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Stores',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              firestore.collection('suppliers').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text('${snapshot.data!.docs.length} Stores Avilable'),
                  SizedBox(height: 20.h),
                  GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 25,
                          crossAxisSpacing: 25,
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            GoPage.push(context, path: VisitStore(
                              suppId: snapshot.data!.docs[index]['uid'],
                            ));
                          },
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: Image.asset('images/inapp/store.jpg'),
                                  ),
                                  Positioned(
                                      bottom: 28,
                                      left: 10,
                                      child: SizedBox(
                                        height: 48,
                                        width: 100,
                                        child: Image.network(
                                          snapshot.data!.docs[index]['storelogo'],
                                          fit: BoxFit.cover,
                                        ),
                                      ))
                                ],
                              ),
                              Text(
                                  snapshot.data!.docs[index]['storename']
                                      .toLowerCase(),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontFamily: 'AkayaTelivigala',
                                  ))
                            ],
                          ),
                        );
                      }),
                ],
              );
            }
            return const Center(
              child: Text('No Stores Avilable'),
            );
          },
        ),
      ),
    );
  }
}
