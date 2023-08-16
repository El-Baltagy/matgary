import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matgary_admin/controller/cubit/upload/upload_product_state.dart';
import '../../../../controller/cubit/upload/upload_product.dart';
import '../../../../shared/utils/app_list.dart';


class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  _UploadProductScreenState createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final bloc=context.watch<UploadProBloc>();
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: bloc.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //to do later ui

                  Row(children: [
                    //images
                    Container(
                      color: Colors.blueGrey.shade100,
                      height: size.width * 0.5,
                      width: size.width * 0.5,
                      child: previewImages()
                    ),
                    //catg subCateg
                    SizedBox(
                      height: size.width * 0.5,
                      width: size.width * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //category
                          Column(
                            children: [
                              const Text(
                                '* select main category',
                                style: TextStyle(color: Colors.red),
                              ),
                              BlocBuilder<UploadProBloc, UploadProState>(
                                builder: (context, state) {
                               return DropdownButton(
                                  iconSize: 40,
                                  iconEnabledColor: Colors.red,
                                  dropdownColor: Colors.yellow.shade400,
                                  value: bloc.mainCategValue,
                                  items:
                                  //can be made with list.generate
                                  maincateg
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),

                                  onChanged: (String? value) {
                                    context.read<UploadProBloc>().selectedMainCateg(value);
                                  });
  },
)
                            ],
                          ),
                          //sub category
                          Column(
                            children: [
                              const Text(
                                '* select subcategory',
                                style: TextStyle(color: Colors.red),
                              ),
                              BlocBuilder<UploadProBloc, UploadProState>(
                              builder: (context, state) {
                                return DropdownButton(
                                  iconSize: 40,
                                  iconEnabledColor: Colors.red,
                                  iconDisabledColor: Colors.black,
                                  dropdownColor: Colors.yellow.shade400,
                                  menuMaxHeight: 500,
                                  disabledHint: const Text('select category'),
                                  value: bloc.subCategValue,
                                  items: bloc.subCategList
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    context.read<UploadProBloc>().selectedSubCateg(value);
                                  });
  },
)
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
                  
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Colors.yellow,
                      thickness: 1.5,
                    ),
                  ),
                  
                  const Row(
                    children: [
                      BuildPrice(),
                      BuildDiscount(),
                    ],
                  ),
                  
                  const BuildQuantity(),
                  
                  const BuildProductNam(),
                  
                  const BuildProductDesc()
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActBtn());
  }
  
}

class BuildProductDesc extends StatelessWidget {
  const BuildProductDesc({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'please enter product description';
              }
              return null;
            },
            onSaved: (value) {
              context.read<UploadProBloc>().saveProDesc(value);
            },
            maxLength: 800,
            maxLines: 5,
            decoration: textFormDecoration.copyWith(
              labelText: 'product description',
              hintText: 'Enter product description',
            ))
      ),
    );
  }
}

class BuildProductNam extends StatelessWidget {
  const BuildProductNam({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'please enter product name';
              }
              return null;
            },
            onSaved: (value) {
              context.read<UploadProBloc>().saveProductName(value);
            },
            maxLength: 100,
            maxLines: 3,
            decoration: textFormDecoration.copyWith(
              labelText: 'product name',
              hintText: 'Enter product name',
            ))
      ),
    );
  }
}

class BuildQuantity extends StatelessWidget {
  const BuildQuantity({
    super.key,
  });
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'please enter Quantity';
              } else if (value.isValidQuantity() != true) {
                return 'not valid quantity';
              }
              return null;
            },
            onSaved: (value) {
              context.read<UploadProBloc>().saveQuantity(value);
            },
            keyboardType: TextInputType.number,
            decoration: textFormDecoration.copyWith(
              labelText: 'Quantity',
              hintText: 'Add Quantity',
            ))
      ),
    );
  }
}

class BuildDiscount extends StatelessWidget {
  const BuildDiscount({
    super.key,

  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.38,
        child: TextFormField(
            maxLength: 2,
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              } else if (value.isValidDiscount() != true) {
                return 'invalid discount';
              }
              return null;
            },
            onSaved: (String? value) {
              context.read<UploadProBloc>().saveDiscount(value);
            },
            keyboardType:
            const TextInputType.numberWithOptions(
                decimal: true),
            decoration: textFormDecoration.copyWith(
              labelText: 'discount',
              hintText: 'discount .. %',
            ))
      ),
    );
  }
}

class BuildPrice extends StatelessWidget {
  const BuildPrice({
    super.key,});



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.38,
        child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'please enter price';
              } else if (value.isValidPrice() != true) {
                return 'invalid price';
              }
              return null;
            },
            onSaved: (String? value) {
              context.read<UploadProBloc>().savePrice(value);
            },
            keyboardType:
            const TextInputType.numberWithOptions(
                decimal: true),
            decoration: textFormDecoration.copyWith(
              labelText: 'price',
              hintText: 'price .. \$',
            ))
      ),
    );
  }
}



var textFormDecoration = InputDecoration(
  labelText: 'price',
  hintText: 'price .. \$',
  labelStyle: const TextStyle(color: Colors.purple),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.yellow, width: 1),
      borderRadius: BorderRadius.circular(10)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      borderRadius: BorderRadius.circular(10)),
);

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$').hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}



class FloatingActBtn extends StatelessWidget {
  const FloatingActBtn({
    super.key,
  });



  @override
  Widget build(BuildContext context) {
    final bloc=BlocProvider.of<UploadProBloc>(context);
    final blocRead=context.read<UploadProBloc>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: BlocBuilder<UploadProBloc, UploadProState>(
  builder: (context, state) {
    return FloatingActionButton(
            onPressed: () {
              blocRead.floatingAction1st();
            },
            backgroundColor: Colors.yellow,
            child: bloc.imagesFileList!.isEmpty
                ? const Icon(
              Icons.photo_library,
              color: Colors.black,
            )
                : const Icon(
              Icons.delete_forever,
              color: Colors.black,
            ),
          );
  },
),
        ),
        FloatingActionButton(
          onPressed:  () {
            blocRead.uploadProduct();
          },
          backgroundColor: Colors.yellow,
          child:  const Icon(
            Icons.upload,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}

class previewImages extends StatelessWidget {
  const previewImages({super.key});
  @override
  Widget build(BuildContext context) {
    final bloc=BlocProvider.of<UploadProBloc>(context);
    if (bloc.imagesFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: bloc.imagesFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(bloc.imagesFileList![index].path));
          });
    } 
    else {
      return const Center(
        child: Text('you have not \n \n picked images yet !',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      );
    }
  }
}
