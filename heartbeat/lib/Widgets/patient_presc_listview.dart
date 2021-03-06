import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heartbeat/models/dummy_lists.dart';
import 'package:heartbeat/providers/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PatientPrescListView extends StatefulWidget {
  final Function() notifyParent;

  const PatientPrescListView({Key? key, required this.notifyParent})
      : super(key: key);

  @override
  State<PatientPrescListView> createState() => _PatientPrescListViewState();
}

class _PatientPrescListViewState extends State<PatientPrescListView> {
  @override
  Widget build(BuildContext context) {
    final dummyPrescsList = Provider.of<DBHelper>(context).dummyPrescs;

    final todaysList = dummyPrescsList.where((element) {
      final date = DateFormat('ddmmyy').format(element['date'] as DateTime);
      print(date + '......');
      return date == DateFormat('ddmmyy').format(DateTime.now());
    }).toList();

    final todays_1_List = dummyPrescsList.where((element) {
      final date = element['date'] as DateTime;
      return date.isBefore(DateTime.now().subtract(Duration(days: 1))) &&
          date.isAfter(DateTime.now().subtract(Duration(days: 2)));
    }).toList();

    final olderList = dummyPrescsList.where((element) {
      final date = element['date'] as DateTime;
      return date.isBefore(DateTime.now().subtract(Duration(days: 2)));
    }).toList();

    prescCard(int index) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.black.withOpacity(0),
              child: Card(
                child: Container(
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(DateFormat('dd.MM.yyyy')
                                .format(
                                    dummyPrescsList[index]['date'] as DateTime)
                                .toString()),
                            Text('Dr. ' +
                                dummyPrescsList[index]['doctor_name']
                                    .toString()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 90, 10, 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(dummyPrescsList[index]['medicine']
                                  .toString()),
                            ),
                            Expanded(
                              child: Text(' x' +
                                  dummyPrescsList[index]['count'].toString()),
                            ),
                            Expanded(
                                child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                  const Icon(
                                    Icons.add_circle,
                                    color: Colors.blue,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg: 'item added to cart');
                                        widget.notifyParent();
                                        DummyLists.kart
                                            .add(dummyPrescsList[index]);
                                      },
                                      icon: Icon(Icons.shopping_cart)),
                                ])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ExpansionTile(
          title: Text('Today'),
          children: [
            ListView.builder(
              itemCount: todaysList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    prescCard(index);
                  },
                  title: Text(DateFormat('dd/MM/yyyy')
                      .format(todaysList[index]['date'] as DateTime)),
                );
              },
            )
          ],
        ),
        ExpansionTile(
          title: Text('yesterday'),
          children: [
            ListView.builder(
              itemCount: todays_1_List.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    prescCard(index);
                  },
                  title: Text(DateFormat('dd/MM/yyyy')
                      .format(todays_1_List[index]['date'] as DateTime)),
                );
              },
            )
          ],
        ),
        ExpansionTile(
          title: Text('Older'),
          children: [
            ListView.builder(
              itemCount: olderList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => prescCard(index),
                  title: Text(DateFormat('dd/MM/yyyy')
                      .format(olderList[index]['date'] as DateTime)),
                );
              },
            )
          ],
        ),
        ExpansionTile(
          title: Text('Uploaded precripstions'),
          children: [
            ListView.builder(
              itemCount: dummyPrescsList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        FileImage(dummyPrescsList[index]['image'] as File),
                  ),
                  title: Text(
                      (dummyPrescsList[index]['date'] as DateTime).toString()),
                );
              },
            )
          ],
        ),
      ],
    );
  }
}
