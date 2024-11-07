import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shoping_ui_sample/controller/cartscreen_controller.dart';
import 'package:shoping_ui_sample/view/paymentsucessscreen/payment_success_screen.dart';

class Cartscreen extends StatefulWidget {
  const Cartscreen({super.key});

  @override
  State<Cartscreen> createState() => _CartscreenState();
}

class _CartscreenState extends State<Cartscreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<CartScreenController>().getAllProducts();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Cart"),
        ),
        body: Consumer<CartScreenController>(
          builder: (context, cartScreenController, child) => Column(
            children: [
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      cartScreenController.storedProducts[index]
                                          ["image"],
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "\$ ${cartScreenController.storedProducts[index]["amount"].toString()}",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 20),
                                        ),
                                        Text(
                                          cartScreenController
                                              .storedProducts[index]["name"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          cartScreenController
                                                  .storedProducts[index]
                                              ["description"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            cartScreenController.incrementQty(
                                                currentqty: cartScreenController
                                                        .storedProducts[index]
                                                    ["qty"],
                                                id: cartScreenController
                                                        .storedProducts[index]
                                                    ["id"]);
                                          },
                                          child: Icon(Icons.add)),
                                      Text(
                                        cartScreenController
                                            .storedProducts[index]["qty"]
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            cartScreenController.decrementQty(
                                                currentqty: cartScreenController
                                                        .storedProducts[index]
                                                    ["qty"],
                                                id: cartScreenController
                                                        .storedProducts[index]
                                                    ["id"]);
                                          },
                                          child: Icon(Icons.remove)),
                                    ],
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  cartScreenController.removeProduct(
                                      cartScreenController.storedProducts[index]
                                          ["id"]);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "Remove",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 20,
                        ),
                    itemCount: cartScreenController.storedProducts.length),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Amount :",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          "\$ ${cartScreenController.totalcartvalue.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Razorpay razorpay = Razorpay();
                        var options = {
                          // 'key': 'rzp_live_ILgsfZCZoFIKMb',
                          'key': 'rzp_test_1DP5mmOlF5G5ag',
                          'theme.color': '#00ff00',
                          'amount':
                              "${cartScreenController.totalcartvalue * 100}",
                          'name': 'Sanjay Technopark',
                          'description': 'Fine T-Shirt',
                          'retry': {'enabled': false, 'max_count': 1},
                          'send_sms_hash': true,
                          'timeout': 120,
                          'prefill': {
                            'contact': '8888888888',
                            'email': 'test@razorpay.com'
                          },
                          'external': {
                            'wallets': ['paytm']
                          }
                        };

                        razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                            handlePaymentErrorResponse);
                        razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                            handlePaymentSuccessResponse);
                        razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                            handleExternalWalletSelected);
                        razorpay.open(options);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              "CHECKOUT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.shopping_cart_checkout_rounded,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(),
      ),
      (route) => false,
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
