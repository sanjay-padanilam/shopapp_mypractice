import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_ui_sample/controller/homescreen_controller.dart';
import 'package:shoping_ui_sample/view/cartscreen/cartscreen.dart';

import 'package:shoping_ui_sample/view/productdetailsscreen/productdetailsscreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<HomescreenController>().getcatagories();
      await context.read<HomescreenController>().getallProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: context.watch<HomescreenController>().cataorylist.length,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Discover",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            actions: [
              Stack(
                children: [
                  Icon(
                    Icons.notification_add_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
                  Positioned(
                    right: 0,
                    top: 2,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 10,
                      child: Text(
                        "1",
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
          bottomNavigationBar: NavigationBar(
            destinations: [
              NavigationDestination(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  label: "home"),
              NavigationDestination(
                  icon: Icon(
                    Icons.favorite_border,
                    size: 30,
                  ),
                  label: "Saved"),
              NavigationDestination(
                  icon: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Cartscreen(),
                          ));
                    },
                    child: Icon(
                      Icons.local_mall_outlined,
                      size: 30,
                    ),
                  ),
                  label: "cart"),
              NavigationDestination(
                  icon: Icon(
                    Icons.settings,
                    size: 30,
                  ),
                  label: "Settings"),
            ],
          ),
          body: Consumer<HomescreenController>(
            builder: (context, providerbj, child) => providerbj.isloading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ListTile(
                            leading: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 35,
                            ),
                            title: Text(
                              "Search anything",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                            trailing: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(13)),
                                  height: 50,
                                  width: 46,
                                ),
                                Positioned(
                                  top: 15,
                                  left: 10,
                                  child: Icon(
                                    Icons.filter_list,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TabBar(
                            onTap: (value) {
                              providerbj.selectedindex = value;
                              providerbj.getallProducts(
                                  catagoryindex: providerbj.cataorylist[value]);
                            },
                            tabAlignment: TabAlignment.start,
                            isScrollable: true,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            unselectedLabelStyle: TextStyle(fontSize: 15),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            indicator: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15)),
                            tabs: List.generate(
                              providerbj.cataorylist.length,
                              (index) => Container(
                                  height: 45,
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: Center(
                                      child:
                                          Text(providerbj.cataorylist[index]))),
                            ),
                          ),
                        ),
                        providerbj.isproductloading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Expanded(
                                child: GridView.builder(
                                    itemCount: providerbj.productlist.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 1 / 2,
                                            crossAxisCount: 2),
                                    itemBuilder: (context, index) =>
                                        ElevatedButton(
                                          onPressed: () {
                                            if (providerbj
                                                    .productlist[index].id !=
                                                null) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailsScreen(
                                                      productId: providerbj
                                                          .productlist[index]
                                                          .id!,
                                                    ),
                                                  ));
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 600,
                                                  width: 180,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                          fit: BoxFit.contain,
                                                          image: NetworkImage(
                                                              providerbj
                                                                  .productlist[
                                                                      index]
                                                                  .image
                                                                  .toString()))),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9)),
                                                        child: Icon(
                                                          Icons.favorite_border,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    providerbj
                                                        .productlist[index]
                                                        .title
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                      "\$ ${providerbj.productlist[index].price.toString()}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15))
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                              ),
                      ],
                    ),
                  ),
          )),
    );
  }
}
