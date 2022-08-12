import 'dart:convert';

import 'package:alif_flutter_app/db/db_helper.dart';
import 'package:alif_flutter_app/models/api_connections.dart';
import 'package:alif_flutter_app/models/data.dart';
import 'package:alif_flutter_app/models/data_abs.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DataProvider extends ChangeNotifier implements DataAbs {
  final List<Data> _dataList = [];
  int page = 1;
  bool hasMore = true;
  List<Data> get dataList => _dataList;

  void clearDataList() {
    page = 1;
    hasMore = true;
    _dataList.clear();
    notifyListeners();
  }

  ///
  ///

  @override
  Future<void> getAllData() async {
    if (hasMore == false) return;
    List<Data> emptyList = [];
    int maxLength = 15;
    try {
      var res = await http.get(Uri.parse(
          "${ApiConnections.URL}/service/v2/upcomingGuides/?page=$page"));
      if (res.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(res.body);
        List<dynamic> list = map['data'];
        if (list.isNotEmpty) {
          for (int i = 0; i < list.length; i++) {
            _dataList.add(Data.fromJson(list[i]));
          }
          page++;
          hasMore = true;
          if (list.length < maxLength) {
            hasMore = false;
          }
          notifyListeners();
        } else {
          hasMore = false;
          notifyListeners();
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
