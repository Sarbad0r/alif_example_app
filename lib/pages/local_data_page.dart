import 'package:alif_flutter_app/db/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/api_connections.dart';
import '../models/data.dart';
import '../utils/dimensions.dart';

class LocalDataPage extends StatelessWidget {
  const LocalDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local Data"),
        elevation: 0,
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Data>>(
          future: DbHelper.getAllDataFromDb(),
          builder: (context, snap) {
            bool checkCon = snap.connectionState == ConnectionState.done;
            if (!checkCon) {
              return CircularProgressIndicator(
                color: Colors.green,
              );
            } else if (snap.hasError) {
              return Text("${snap.error}");
            } else if (snap.data == null) {
              return Text("Пусто");
            } else if (snap.data!.isEmpty) {
              return Text("Пусто");
            } else {
              return ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.only(
                      left: Dimensions.size20, right: Dimensions.size20),
                  child: const Divider(
                    color: Colors.black,
                  ),
                ),
                itemCount: snap.data!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      await launchUrlString(
                          "${ApiConnections.URL}${snap.data![index].url}");
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: Dimensions.size20, right: Dimensions.size20),
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
                                              "${snap.data![index].icon}"))),
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
                                        "${snap.data![index].name}",
                                        style: TextStyle(
                                            fontSize: Dimensions.size18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${snap.data![index].startDate}",
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
                            "${snap.data![index].endDate}",
                            style: TextStyle(fontSize: Dimensions.size14),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
