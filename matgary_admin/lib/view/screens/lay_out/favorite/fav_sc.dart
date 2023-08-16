import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matgary_admin/shared/utils/app_colors.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import '../../../../controller/cubit/product_detail/ProDetailState.dart';
import '../../../../controller/cubit/product_detail/product_detail.dart';
import '../../../../shared/utils/global.dart';
import '../../../../shared/widgets/gallery.dart';
import '../../../../shared/widgets/loader.dart';
import '../../../../shared/widgets/product_item_builder.dart';



// class FavScreen extends StatelessWidget {
//   const FavScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final bloc=BlocProvider.of<ProDetailBloc>(context);
//     return Scaffold(
//         body: bloc.saveData.isEmpty ?
//         Center(
//           child: Text("No Favourite Items",
//               style: Theme.of(context).textTheme.headlineSmall!
//                   .copyWith(fontSize: 18.5.sp,
//                 color: AppColors.primaryColor,
//                 fontWeight: FontWeight.w500,)),
//         ) :
//         Padding(
//           padding:  const EdgeInsets.symmetric(horizontal: 10.0).copyWith(bottom: 130.h,top: 10),
//           child: GalleryWidget(
//               dataFavStream(context)
//           ),
//         )
//     );
//   }
//
// }

class FavScreen extends StatelessWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc=BlocProvider.of<ProDetailBloc>(context);
    return Scaffold(
        body: bloc.saveData.isEmpty ?
        Center(
          child: Text("No Favourite Items",
              style: Theme.of(context).textTheme.headlineSmall!
                  .copyWith(fontSize: 18.5.sp,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,)),
        ) :
        Padding(
          padding:  const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
          child: BlocBuilder<ProDetailBloc, ProDetailState>(
               builder: (context, state) {
            return StaggeredGridView.countBuilder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: bloc.saveData.length,
              crossAxisCount: 2,
            staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
              itemBuilder: (context, index) =>
                  StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('products')
                        .where('proid', isEqualTo: bloc.saveData[index]['proid'])
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loader();
                      }

                      return  ProductItemBuilder(
                        products: snapshot.data!.docs[0],
                      );
                    },
                  ),
              );
  },
),
        )
    );
  }
}