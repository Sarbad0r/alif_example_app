import 'package:alif_flutter_app/models/api_connections.dart';
import 'package:alif_flutter_app/pages/local_data_page.dart';
import 'package:alif_flutter_app/state_management/data_provider.dart';
import 'package:alif_flutter_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();

  bool internet = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((event) {
      var check = event == InternetConnectionStatus.connected;
      if (check) {
        internet = true;
        setState(() {});
        var dataListProvider =
            Provider.of<DataProvider>(context, listen: false);
        dataListProvider.getAllData();
        _scrollController.addListener(() {
          if (_scrollController.position.maxScrollExtent ==
              _scrollController.offset) {
            dataListProvider.getAllData();
          }
        });
      } else {
        internet = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var dataListProvider = Provider.of<DataProvider>(context);
    return RefreshIndicator(
      onRefresh: () async {
        dataListProvider.clearDataList();
        dataListProvider.getAllData();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LocalDataPage()));
                },
                child: Text(
                  "Local data",
                  style: TextStyle(
                      color: Colors.white, fontSize: Dimensions.size14),
                ))
          ],
          backgroundColor: Colors.green,
          title: Text(
            "Alif example app",
            style: TextStyle(color: Colors.white, fontSize: Dimensions.size20),
          ),
          elevation: 0,
        ),
        body: Column(
          children: [
            if (!internet)
              const Expanded(
                child: Center(
                  child: Text("Проверьте интернет соединение"),
                ),
              )
            else if (dataListProvider.dataList.isEmpty)
              const Expanded(
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.green,
                )),
              )
            else
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: Dimensions.size15),
                  child: ListView.separated(
                    controller: _scrollController,
                    separatorBuilder: (BuildContext context, int index) =>
                        Padding(
                      padding: EdgeInsets.only(
                          left: Dimensions.size20, right: Dimensions.size20),
                      child: const Divider(
                        color: Colors.black,
                      ),
                    ),
                    itemCount: dataListProvider.dataList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < dataListProvider.dataList.length) {
                        return InkWell(
                          onTap: () async {
                            await launchUrlString(
                                "${ApiConnections.URL}${dataListProvider.dataList[index].url}");
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.size20,
                                right: Dimensions.size20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: Dimensions.size70,
                                        height: Dimensions.size70,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "${dataListProvider.dataList[index].icon}"))),
                                      ),
                                      SizedBox(
                                        width: Dimensions.size10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${dataListProvider.dataList[index].name}",
                                              style: TextStyle(
                                                  fontSize: Dimensions.size18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${dataListProvider.dataList[index].startDate}",
                                              style: TextStyle(
                                                  fontSize: Dimensions.size14),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  "${dataListProvider.dataList[index].endDate}",
                                  style: TextStyle(fontSize: Dimensions.size14),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return dataListProvider.hasMore == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.green,
                              ))
                            : Container();
                      }
                    },
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
