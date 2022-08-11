import 'dart:convert';

import 'package:alif_flutter_app/db/db_helper.dart';
import 'package:alif_flutter_app/models/api_connections.dart';
import 'package:alif_flutter_app/models/data.dart';
import 'package:alif_flutter_app/models/data_abs.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DataProvider extends ChangeNotifier implements DataAbs {
  final List<Data> _dataList = [];

  List<Data> get dataList => _dataList;

  ///
  ///

  @override
  Future<void> getAllData() async {
    List<Data> emptyList = [];
    int maxLength = 3;
    try {
      var res = await http
          .get(Uri.parse("${ApiConnections.URL}/service/v2/upcomingGuides"));
      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);
        List<dynamic> list = json['data'];

        for (int i = 0; i < list.length; i++) {
          emptyList.add(Data.fromJson(list[i]));
          _dataList.add(Data.fromJson(list[i]));
        }
        await DbHelper.saveDataToDb(emptyList);

        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
