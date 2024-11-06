import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_ui_sample/controller/cartscreen_controller.dart';

import 'package:shoping_ui_sample/controller/homescreen_controller.dart';
import 'package:shoping_ui_sample/controller/product_detailsscreen_controller.dart';
import 'package:shoping_ui_sample/view/getstartedscreen/getstartedscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomescreenController()),
        ChangeNotifierProvider(
            create: (context) => ProductDetailsscreenController()),
        ChangeNotifierProvider(create: (context) => CartScreenController())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GetStartedScreen(),
      ),
    );
  }
}
