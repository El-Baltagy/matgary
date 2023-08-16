import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:matgary_user/shared/widgets/product_item_builder.dart';
import 'package:matgary_user/shared/widgets/visit_store.dart';
import 'package:matgary_user/shared/widgets/yellow_button.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart'as badges ;
import '../../../controller/provider/product_detail.dart';
import '../../network/local/cach_helper.dart';
import '../../utils/app_methods.dart';
import '../../utils/global.dart';
import '../loader.dart';
import 'full_screen_view.dart';



class ProductDetailsScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailsScreen({Key? key, required this.proList})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Stream<QuerySnapshot> _prodcutsStream = firestore
      .collection('proList')
      .where('maincateg', isEqualTo: widget.proList['maincateg'])
      .where('subcateg', isEqualTo: widget.proList['subcateg'])
      .snapshots();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.proList['proimages'];

  late bool isFav;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFav=CashHelper.getBoolean(key: '${widget.proList['proid']} isSaved')??false;
  }
  @override
  Widget build(BuildContext context) {
    var onSale = widget.proList['discount'];
    // var existingItemCart = context.read<Cart>().getItems.firstWhereOrNull(
    //         (element) => element.documentId == widget.proList['proid']);
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      GoPage.push(context, path: FullScreenView(
                        imagesList: imagesList,));
                    },
                    child: Stack(
                      children: [
                        //images
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                            pagination: const SwiperPagination(
                                builder: SwiperPagination.fraction),
                            itemBuilder: (context, index) {
                              return Image(
                                image: NetworkImage(
                                  imagesList[index],
                                ),
                              );
                            },
                            itemCount: imagesList.length,
                          ),
                        ),
                        //pop
                        Positioned(
                            left: 15,
                            top: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            )),
                        //share
                        Positioned(
                            right: 15,
                            top: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  // Share.share(
                                  //   'Look How to Cook this $MealTitle ? check it Now $shareLink',
                                  // );
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //name product
                        Text(
                          widget.proList['proname'],
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //price
                            Row(
                              children: [
                                const Text(
                                  'USD  ',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  widget.proList['price'].toStringAsFixed(2),
                                  style: onSale != 0
                                      ? const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      decoration:
                                      TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w600)
                                      : const TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                onSale != 0
                                    ? Text(
                                  ((1 -
                                      (widget.proList[
                                      'discount'] /
                                          100)) *
                                      widget.proList['price'])
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )
                                    : const Text(''),
                              ],
                            ),

                            Consumer<ProductDetailProv>(
                              builder: (context, prov, child) {
                                return StatefulBuilder(builder:(context, reBuild) =>
                                    IconButton(
                                        onPressed: () {
                                          // if (!isFav) {
                                          //   CashHelper.saveData(key: '${widget.proList['proid']} isSaved', value: true);
                                          //   prov.InsertTODatabase(context,
                                          //       idProduct: widget.proList['proid'],
                                          //     );
                                          // } else{
                                          //   CashHelper.saveData(key: '${widget.proList['proid']} isSaved', value: false);
                                          //   prov.DeleteDatebase(context,id:(widget.proList['proid']).toString());
                                          //   // if (widget.isFavSC) {
                                          //   //   cubit.clearItem(widget.index);
                                          //   // }
                                          // }
                                          // reBuild(() {
                                          //   isFav=CashHelper.getBoolean(key: '${widget.proList['proid']} isSaved')!;
                                          // });

                                        },

                                        icon:   Icon(
                                          isFav ? Icons.favorite:
                                          Icons.favorite_outline,
                                          color: Colors.red,
                                          size: 30,
                                        )
                                    ));
                              },
                            ),
                          ],
                        ),
                        widget.proList['instock'] == 0
                            ? const Text(
                          'this item is out of stock',
                          style: TextStyle(
                              fontSize: 16, color: Colors.blueGrey),
                        )
                            : Text(
                          (widget.proList['instock'].toString()) +
                              (' pieces available in stock'),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueGrey),
                        ),
                        const ProDetailsHeader(
                          label: '   Item Description   ',
                        ),
                        Text(
                          widget.proList['prodesc'],
                          textScaleFactor: 1.1,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey.shade800),
                        ),
                        const ProDetailsHeader(
                          label: '  Similar Items  ',
                        ),

                        //stream products
                        SizedBox(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _prodcutsStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Loader();
                              }

                              if (snapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text(
                                      'This category \n\n has no items yet !',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Acme',
                                          letterSpacing: 1.5),
                                    ));
                              }

                              return SingleChildScrollView(
                                child: StaggeredGridView.countBuilder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    crossAxisCount: 2,
                                    itemBuilder: (context, index) {
                                      return ProductItemBuilder(
                                        products: snapshot.data!.docs[index],
                                      );
                                    },
                                    staggeredTileBuilder: (context) =>
                                    const StaggeredTile.fit(1)),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            GoPage.push(context, path: VisitStore(
                                suppId: widget.proList['uid']));
                          },
                          icon: const Icon(Icons.store)),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          onPressed: () {
                            // GoPage.push(context, path: const CartScreen(
                            //   back: AppBarBackButton(),
                            // ));

                          },
                          icon: badges.Badge(
                              showBadge: Provider.of<ProductDetailProv>(context).cartData.isEmpty
                                  ? false : true,
                              padding: const EdgeInsets.all(2),
                              badgeColor: Colors.yellow,
                              badgeContent: Text(
                                Provider.of<ProductDetailProv>(context).cartData.length
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              child: const Icon(Icons.favorite))),
                    ],
                  ),
                  YellowButton(
                      label: Provider.of<ProductDetailProv>(context).cartData.isEmpty
                          ? 'added to cart'
                          : 'ADD TO CART',
                      onPressed: () {
                        // if (widget.proList['instock'] == 0) {
                        //   showSnackBar(
                        //       _scaffoldKey, 'this item is out of stock');
                        // } else if (existingItemCart != null) {
                        //   showSnackBar(
                        //       _scaffoldKey, 'this item already in cart');
                        // } else {
                        //   context.read<Cart>().addItem(
                        //     widget.proList['proname'],
                        //     onSale != 0
                        //         ? ((1 -
                        //         (widget.proList['discount'] /
                        //             100)) *
                        //         widget.proList['price'])
                        //         : widget.proList['price'],
                        //     1,
                        //     widget.proList['instock'],
                        //     widget.proList['proimages'],
                        //     widget.proList['proid'],
                        //     widget.proList['sid'],
                        //   );
                        // }
                      },
                      width: 0.55)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProDetailsHeader extends StatelessWidget {
  final String label;
  const ProDetailsHeader({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
                color: Colors.yellow.shade900,
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
