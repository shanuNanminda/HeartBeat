import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:heartbeat/Widgets/patient_presc_listview.dart';
import 'package:heartbeat/Widgets/quantity_card.dart';
import 'package:heartbeat/models/dummy_lists.dart';
import 'package:heartbeat/screens/patient_external_prescription.dart';
import 'package:intl/intl.dart';

class PatientView extends StatefulWidget {
  static const String routeName = 'patientView';

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  var isLabtest = false;

  final List<Map<String, Object>> tempMedicinesList = [];
  final List<Map<String, Object>> tempTestsList = [];
  var medicineQuantity = 1;

  void getQuantity(int number) {
    medicineQuantity = number;
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!isLabtest)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    elevation: 200,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return SingleChildScrollView(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: DropdownSearch(
                                  hint: 'medicines',
                                  showSearchBox: true,
                                  items: DummyLists.medicines,
                                  onChanged: (value) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          backgroundColor:
                                              Colors.black.withOpacity(0),
                                          child: StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                              return QuantityCard(
                                                medicineQuantity: 1,
                                                getQuantity: getQuantity,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ).then((_) {
                                      setState(
                                        () {
                                          tempMedicinesList.add(
                                            {
                                              'medicine': value.toString(),
                                              'count': medicineQuantity
                                            },
                                          );
                                        },
                                      );
                                    });

                                    medicineQuantity = 1;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...tempMedicinesList.map((e) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(e['medicine'] as String),
                                          Text(
                                            e['count'] as int > 1
                                                ? 'x' +
                                                    e['count'].toString() +
                                                    ' Nos'
                                                : 'x' + e['count'].toString(),
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: DropdownSearch(
                                  hint: 'tests',
                                  showSearchBox: true,
                                  items: DummyLists.tests
                                      .map((e) => e['test_name'] as String)
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      tempTestsList.add(DummyLists.tests
                                          .firstWhere((element) =>
                                              element['test_name'] == value));
                                    });
                                    print(tempTestsList.toString());
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...tempTestsList.map((e) {
                                      return Text(e.toString());
                                    }),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          DummyLists.dummyPrescs
                                              .addAll(tempMedicinesList.map(
                                            (e) => {
                                              'doctor_name': 'test',
                                              'patient_id': '1',
                                              'presc_type': 'medicine',
                                              'prescripton': e['medicine']!,
                                              'date': DateTime.now(),
                                              'count': e['count']!,
                                            },
                                            // MedicinePrescription(
                                            //     e['medicine']
                                            //         as String,
                                            //     DateTime.now(),
                                            //     e['count'] as int,
                                            //     'Docname')
                                          ));

                                          DummyLists.dummyPrescs
                                              .addAll(tempTestsList.map((e) => {
                                                    'doctor_name': 'test',
                                                    'patient_id': '1',
                                                    'presc_type': 'test',
                                                    'prescripton':
                                                        e['test_name']!,
                                                    'date': DateTime.now(),
                                                    'count': 1,
                                                  }));

                                          DummyLists.dummyPrescs.map((e) {
                                            print(e['']);
                                          });
                                          print(
                                              DummyLists.dummyPrescs.toList());
                                          tempMedicinesList.clear();
                                          tempTestsList.clear();
                                          Navigator.pop(context);
                                        },
                                        child: Text('Prescribe')),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                    },
                  );
                },
                child: Icon(Icons.add),
              ),
            ),
          GestureDetector(
            onTap: () {
              setState(() {
                isLabtest = !isLabtest;
              });
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Colors.blue,
                ),
                height: 90,
                width: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isLabtest ? Icons.text_snippet : Icons.biotech,
                      size: 60,
                      color: Colors.white,
                    ),
                    Text(
                      isLabtest ? 'Prescriptions' : 'Lab results',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                )),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 70, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'gender',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'age',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              title: Text(arg),
            ),
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isLabtest ? 'Labtests' : 'Previous Prescriptions',
                          style: TextStyle(fontSize: 20),
                        ),
                        if (!isLabtest)
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    PatientExternalPrescriptios.routeName);
                              },
                              child: Text('External Prescriptions'))
                      ],
                    ),
                  ),
                  Divider(),
                  if (!isLabtest) PatientPrescListView(notifyParent: () {}),
                  if (isLabtest)
                    ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: DummyLists.dummyPrescs.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(DummyLists.dummyPrescs[index]
                                      ['prescription']
                                  .toString()),
                              subtitle: Text(DummyLists.dummyPrescs[index]
                                      ['date']
                                  .toString()),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
