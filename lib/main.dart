import 'package:alif_flutter_app/pages/home_page.dart';
import 'package:alif_flutter_app/state_management/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<DataProvider>(create: (_) => DataProvider())
    ],
    child: const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  ));
}
