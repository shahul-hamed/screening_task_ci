import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:screening_task_ci/common/widgets/my_elevated_button.dart';
import 'package:screening_task_ci/view/device_info_view.dart';
import 'package:screening_task_ci/view/product_details_view.dart';
import 'package:screening_task_ci/view/product_list_view.dart';
import 'package:screening_task_ci/viewmodel/product_details_viewmodel.dart';
import 'package:screening_task_ci/viewmodel/product_list_viewmodel.dart';
import 'package:uni_links5/uni_links.dart';

import 'model/product_model.dart';
import 'viewmodel/device_info_view_model.dart';

void main() async{
  // Initialize Hive
  await Hive.initFlutter();

  // Register the Product adapter
  Hive.registerAdapter(ProductAdapter());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductListViewModel()),
      ChangeNotifierProvider(create: (_) => ProductDetailsViewModel()),
      ChangeNotifierProvider(create: (_) => DeviceInfoViewModel()),
    ],
    child: const MyApp(),
  ),);
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  late StreamSubscription _sub;
  @override
  void initState() {
   _initDeepLink();
    super.initState();
  }
  void _initDeepLink() async {
    // For incoming links when the app is opened from a cold start
    try {
      final initialLink = await getInitialLink();
      _handleDeepLink(initialLink);
    } catch (e) {
      print("Error getting initial link: $e");
    }

    // For incoming links while the app is running
    _sub = linkStream.listen((String? link) {
      _handleDeepLink(link);
    });
  }
  void _handleDeepLink(String? link) {
    if (link != null) {
      Uri uri = Uri.parse(link);
      if (uri.scheme == 'myapp' && uri.host == 'products') {
        String productId = uri.pathSegments.first;
        // Navigate to Product Details Page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailsView(productId: productId)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          appBar: AppBar(title: Text("Task home"),),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Use below buttons to navigate products and device info pages",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                SizedBox(height: 5,),
                /// using customized button
                MyElevatedButton(text: "Products",
                    onPressed: (){
                  print("heere");
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductListView()));
                }),
                MyElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DeviceInfoView()));

                }, text: "Device Info"),
              ],
            ),
          ),
          ),
    );
  }

  @override
  void dispose() {
    _sub.cancel();  // Clean up the subscription
    super.dispose();
  }
}

