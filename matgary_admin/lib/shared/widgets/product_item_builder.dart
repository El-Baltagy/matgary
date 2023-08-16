import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matgary_admin/shared/utils/global.dart';
import 'package:matgary_admin/shared/widgets/product_detail_sc.dart';
import '../../controller/cubit/product_detail/ProDetailState.dart';
import '../../controller/cubit/product_detail/product_detail.dart';
import '../network/local/cach_helper.dart';
import '../utils/app_methods.dart';



class ProductItemBuilder extends StatefulWidget {
  final dynamic products;

  const ProductItemBuilder({Key? key, required this.products}) : super(key: key);

  @override
  State<ProductItemBuilder> createState() => _ProductItemBuilderState();
}

class _ProductItemBuilderState extends State<ProductItemBuilder> {

  late bool isFav;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFav=CashHelper.getBoolean(key: '${widget.products['proid']} isSaved')??false;
  }
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];
    return InkWell(
      onTap: () {
        GoPage.push(context, path: ProductDetailsScreen(
          proList: widget.products,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Container(
                      constraints:
                      const BoxConstraints(minHeight: 100, maxHeight: 250),
                      child: Image(
                        image: NetworkImage(widget.products['proimages'][0]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          widget.products['proname'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '\$ ',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  widget.products['price'].toStringAsFixed(2),
                                  style: onSale != 0
                                      ? const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                      decoration:
                                      TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w600)
                                      : const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                onSale != 0
                                    ? Text(
                                  ((1 -
                                      (widget.products[
                                      'discount'] /
                                          100)) *
                                      widget.products['price'])
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )
                                    : const Text(''),
                              ],
                            ),
                            widget.products['uid'] == fAuth.currentUser!.uid
                                ? IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                )):
                            BlocBuilder<ProDetailBloc, ProDetailState>(
                             builder: (context, state) {
                               final bloc=BlocProvider.of<ProDetailBloc>(context,listen: false);
                               return IconButton(
                                onPressed: () {
                                  if (!isFav) {
                                    CashHelper.saveData(key: '${widget.products['proid']} isSaved', value: true);
                                    bloc.InsertTODatabase(context,
                                      idProduct: widget.products['proid'],
                                    );
                                  } else{
                                    CashHelper.saveData(key: '${widget.products['proid']} isSaved', value: false);
                                    bloc.DeleteDatebase(context,id:(widget.products['proid']).toString());
                                    // if (widget.isFavSC) {
                                    //   cubit.clearItem(widget.index);
                                    // }
                                  }
                                  setState(() {
                                    isFav=CashHelper.getBoolean(key: '${widget.products['proid']} isSaved')!;
                                  });

                                },

                                icon:   Icon(
                                  isFav ? Icons.favorite:
                                  Icons.favorite_outline,
                                  color: Colors.red,
                                  size: 30,
                                )
                            );
  },
)
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onSale != 0
                ? Positioned(
              top: 30,
              left: 0,
              child: Container(
                height: 25,
                width: 80,
                decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                child: Center(child: Text('Save ${onSale.toString()} %')),
              ),
            )
                : Container(
              color: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
