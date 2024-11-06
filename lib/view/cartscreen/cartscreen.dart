import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_ui_sample/controller/cartscreen_controller.dart';

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
          builder: (context, cartScreenController, child) => ListView.separated(
              itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartScreenController.storedProducts[index]
                                        ["name"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    cartScreenController.storedProducts[index]
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
                                    onPressed: () {}, child: Icon(Icons.add)),
                                Text(
                                  "qty",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                ElevatedButton(
                                    onPressed: () {},
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
        ));
  }
}
