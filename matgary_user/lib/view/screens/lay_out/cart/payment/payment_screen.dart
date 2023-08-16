// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../../shared/utils/global.dart';
import '../../../../../shared/widgets/app_bar_widgets.dart';
import '../../../../../shared/widgets/loader.dart';
import '../../../../../shared/widgets/progrfess_dialouge.dart';
import '../../../../../shared/widgets/yellow_button.dart';



late Map<Stripe,dynamic>paymentIntentData;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  late String orderId;
  CollectionReference customers = FirebaseFirestore.instance.
  collection('customers');

  void showProgress() {

    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wait ..', progressBgColor: Colors.red);
  }


  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 10.0;
    return FutureBuilder<DocumentSnapshot>(
        future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
                child: Center(
              child: CircularProgressIndicator(),
            ));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Material(
              color: Colors.grey.shade200,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade200,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.grey.shade200,
                    leading: const AppBarBackButton(),
                    title: const AppBarTitle(
                      title: 'Payment',
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      '${totalPaid.toStringAsFixed(2)} USD',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total order',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Text(
                                      '${totalPrice.toStringAsFixed(2)} USD',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Shipping Coast',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Text(
                                      '10.00' + (' USD'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                RadioListTile(
                                  value: 1,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title: const Text('Cash On Delivery'),
                                  subtitle: const Text('Pay Cash At Home'),
                                ),
                                RadioListTile(
                                  value: 2,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title:
                                      const Text('Pay via visa / Master Card'),
                                  subtitle: const Row(
                                    children: [
                                      Icon(Icons.payment, color: Colors.blue),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Icon(
                                            FontAwesomeIcons.ccMastercard,
                                            color: Colors.blue),
                                      ),
                                      Icon(FontAwesomeIcons.ccVisa,
                                          color: Colors.blue)
                                    ],
                                  ),
                                ),
                                RadioListTile(
                                  value: 3,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title: const Text('Pay via Paypal'),
                                  subtitle: const Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.paypal,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 15),
                                      Icon(
                                        FontAwesomeIcons.ccPaypal,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: YellowButton(
                        label: 'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                        width: 1,
                        onPressed: () async {
                          if (selectedValue == 1) {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 100),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                'Pay At Home ${totalPaid.toStringAsFixed(2)} \$',
                                                style: const TextStyle(
                                                    fontSize: 24),
                                              ),
                                              YellowButton(
                                                  label:
                                                      'Confirm ${totalPaid.toStringAsFixed(2)} \$',
                                                  onPressed: () async {
                                                    // showProgress();
                                                    // for (var item in context
                                                    //     .read<Cart>()
                                                    //     .getItems) {
                                                    //   CollectionReference
                                                    //       orderRef =
                                                    //       FirebaseFirestore
                                                    //           .instance
                                                    //           .collection(
                                                    //               'orders');
                                                    //   orderId =
                                                    //       const Uuid().v4();
                                                    //   await orderRef
                                                    //       .doc(orderId)
                                                    //       .set({
                                                    //     'cid': data['cid'],
                                                    //     'custname':
                                                    //         data['name'],
                                                    //     'email': data['email'],
                                                    //     'address':
                                                    //         data['address'],
                                                    //     'phone': data['phone'],
                                                    //     'profileimage': data[
                                                    //         'profileimage'],
                                                    //     'sid': item.suppId,
                                                    //     'proid':
                                                    //         item.documentId,
                                                    //     'orderid': orderId,
                                                    //     'ordername': item.name,
                                                    //     'orderimage': item
                                                    //         .imagesUrl.first,
                                                    //     'orderqty': item.qty,
                                                    //     'orderprice': item.qty *
                                                    //         item.price,
                                                    //     'deliverystatus':
                                                    //         'preparing',
                                                    //     'deliverydate': '',
                                                    //     'orderdate':
                                                    //         DateTime.now(),
                                                    //     'paymentstatus':
                                                    //         'cash on delivery',
                                                    //     'orderreview': false,
                                                    //   }).whenComplete(() async {
                                                    //     await FirebaseFirestore
                                                    //         .instance
                                                    //         .runTransaction(
                                                    //             (transaction) async {
                                                    //       DocumentReference
                                                    //           documentReference =
                                                    //           FirebaseFirestore
                                                    //               .instance
                                                    //               .collection(
                                                    //                   'products')
                                                    //               .doc(item
                                                    //                   .documentId);
                                                    //       DocumentSnapshot
                                                    //           snapshot2 =
                                                    //           await transaction.get(
                                                    //               documentReference);
                                                    //       transaction.update(
                                                    //           documentReference,
                                                    //           {
                                                    //             'instock':
                                                    //                 snapshot2[
                                                    //                         'instock'] -
                                                    //                     item.qty
                                                    //           });
                                                    //     });
                                                    //   });
                                                    // }
                                                    // context
                                                    //     .read<Cart>()
                                                    //     .clearCart();
                                                    // Navigator.popUntil(
                                                    //     context,
                                                    //     ModalRoute.withName(
                                                    //         '/customer_home'));
                                                  },

                                                  width: 0.9)
                                            ]),
                                      ),
                                    ));
                          } else if (selectedValue == 2) {
                            int payment=totalPaid.round();
                            int paymentInCent=payment*100;
                           await makePayment(
                              data: data,
                              total:paymentInCent.toString() ,
                              currency:'usd'
                            );
                          } else if (selectedValue == 3) {
                            print('paypal');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Loader();
        });
  }


makePayment({
  required dynamic data,required String total,required String currency
})async{
  //create payment
  //init payment
  //display payment

  paymentIntentData=await createPaymentIntent(total,currency);
  await Stripe.instance.initPaymentSheet(
      paymentSheetParameters:  SetupPaymentSheetParameters(
        paymentIntentClientSecret:paymentIntentData['client_secret'],
        applePay: true,
        googlePay: true,
        merchantDisplayName: 'Flutter Stripe Store Demo',
        merchantCountryCode: 'EG'
      ));

  await displayPaymentSheet(data);
}

createPaymentIntent(String total,String currency)async{
  final url=Uri.parse('https://api.stripe.com/v1/payment_intents');
  Map<String,dynamic> body={
    'currency': currency,
    'amount': total,
    // 'items': [
    //   {'id': 'id'}
    // ],
    // 'request_three_d_secure': 'any',
    // e-mail of the customer which has set up payment method
    // 'email': _email,
  };
  Map<String,String> headers={
    'Authorization': 'Bearer ${StripeConfig.StripeSecKey}',
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  final response=await post(
    url, body:body , headers: headers,
  );
  return jsonDecode(response.body);
}

displayPaymentSheet(dynamic data)async{

    await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(clientSecret: paymentIntentData['client_secret'],confirmPayment: true)
    ).then((_) async {
      showProgress();
      for (var item in context
          .read<Cart>()
          .getItems) {
        CollectionReference
        orderRef =
        firestore
            .collection(
            'orders');
        orderId =
            const Uuid().v4();
        await orderRef
            .doc(orderId)
            .set({
          'cid': data['cid'],
          'custname':
          data['name'],
          'email': data['email'],
          'address':
          data['address'],
          'phone': data['phone'],
          'profileimage': data[
          'profileimage'],
          'sid': item.suppId,
          'proid':
          item.documentId,
          'orderid': orderId,
          'ordername': item.name,
          'orderimage': item
              .imagesUrl.first,
          'orderqty': item.qty,
          'orderprice': item.qty *
              item.price,
          'deliverystatus':
          'preparing',
          'deliverydate': '',
          'orderdate':
          DateTime.now(),
          'paymentstatus':
          // 'cash on delivery',
          'paid online',
          'orderreview': false,
        }).whenComplete(() async {
          await FirebaseFirestore
              .instance
              .runTransaction(
                  (transaction) async {
                DocumentReference
                documentReference =
                FirebaseFirestore
                    .instance
                    .collection(
                    'products')
                    .doc(item
                    .documentId);
                DocumentSnapshot
                snapshot2 =
                await transaction.get(
                    documentReference);
                transaction.update(
                    documentReference,
                    {
                      'instock':
                      snapshot2[
                      'instock'] -
                          item.qty
                    });
              });
        });
      }
      context
          .read<Cart>()
          .clearCart();
      Navigator.popUntil(
          context,
          ModalRoute.withName(
              '/customer_home'));
    }).catchError((e){
      print(e.toString());
    });

}}