import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_ui_sample/controller/cartscreen_controller.dart';
import 'package:shoping_ui_sample/controller/product_detailsscreen_controller.dart';
import 'package:shoping_ui_sample/view/cartscreen/cartscreen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context
            .read<ProductDetailsscreenController>()
            .getProductdetails(widget.productId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Details",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 30,
                  color: Colors.black,
                ),
                Positioned(
                  top: 2,
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.black,
                    child: Text(
                      "1",
                      style: TextStyle(color: Colors.white, fontSize: 5),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Consumer<ProductDetailsscreenController>(
          builder: (context, productdetailscontroller, child) =>
              productdetailscontroller.isloading
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 450,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              productdetailscontroller
                                                      .product?.image
                                                      .toString() ??
                                                  ""))),
                                ),
                                Positioned(
                                  top: 20,
                                  right: 50,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                                Positioned(
                                    right: 60,
                                    top: 36,
                                    child: Icon(
                                      Icons.favorite_border_outlined,
                                      color: Colors.black,
                                      weight: 30,
                                    ))
                              ],
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    productdetailscontroller.product!.title
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      RatingBar.readOnly(
                                        size: 20,
                                        filledIcon: Icons.star,
                                        emptyIcon: Icons.star_border,
                                        initialRating: productdetailscontroller
                                                .product!.rating!.rate ??
                                            0,
                                        maxRating: 5,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${productdetailscontroller.product!.rating!.count}/rating",
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                      maxLines: 3,
                                      textAlign: TextAlign.justify,
                                      productdetailscontroller
                                          .product!.description
                                          .toString()),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "choose size",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          child: Center(
                                            child: Text(
                                              "S",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                          )),
                                      SizedBox(width: 10),
                                      Container(
                                          child: Center(
                                            child: Text(
                                              "M",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: const Color.fromARGB(
                                                  255, 49, 48, 48),
                                            ),
                                          )),
                                      SizedBox(width: 10),
                                      Container(
                                          child: Center(
                                            child: Text(
                                              "L",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text("Price"),
                                    Text(
                                      "\$ ${productdetailscontroller.product!.price.toString()}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    )
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<CartScreenController>()
                                        .addProduct(
                                            productdetailscontroller.product!);
                                    context
                                        .read<CartScreenController>()
                                        .getAllProducts();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Cartscreen(),
                                        ));
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Icon(
                                          Icons.local_mall_outlined,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "add to cart",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ] //colums
                          ,
                        ),
                      ),
                    ),
        ));
  }
}
