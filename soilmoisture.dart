import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class SoilData{
  final double domain;
  final double measure;
  List <SoilData> topFiveData=[];

  SoilData({
    required this.domain,
    required this.measure,
  }); //ganti
  dynamic operator [](String key) {
    switch (key) {
      case 'domain':
        return domain;
      case 'measure':
        return measure;
      case 'topFiveData':
        return topFiveData;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }
}
class SoilmoistureWidget extends StatelessWidget {
   SoilmoistureWidget({Key? key, required this.soil}) : super(key: key);
  final int soil;
  final streamChart = FirebaseFirestore.instance
      .collection('soil')
      .snapshots(includeMetadataChanges: true);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color(0xFF0A2647),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5, top: 40),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFFEAE3E3),
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        'Soil Moisture', //ganti
                        style: TextStyle(
                            color: Color(0xFFEAE3E3),
                            fontFamily: 'Inter',
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Container(
                        width: 148,
                        height: 107,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(0xFF144272),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 15, top: 10),
                                  child: Text(
                                    'Current',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                      color: Color(0xFFEAE3E3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Soil Moisture', //ganti
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                      color: Color(0xFFEAE3E3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 26, top: 5),
                                  child: Text(
                                    '$soil%', //ganti
                                    style: TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Gilroy',
                                      color: Color(0xFFEAE3E3),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: streamChart,
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data available'));
                  }

                  List<SoilData> SoilDataList = snapshot.data!.docs.map((e) {
                    return SoilData(
                      domain: e.data()['timevalue'].toDouble(),
                      measure: e.data()['soil'].toDouble(), //ganti
                    );
                  }).toList();

                  // Sort the list in descending order based on the 'domain' (timevalue)

                  SoilDataList.sort((a, b) => b.domain.compareTo(a.domain));

                  // Take the first 5 data points with the greatest 'timevalue'
                  List<SoilData> topFiveData =
                      SoilDataList.take(5).toList(); //ganti

                  // Sort the top 5 data points in ascending order based on the 'timevalue' (domain)
                  topFiveData.sort((a, b) => a.domain.compareTo(b.domain));

                  // Convert the top 5 data points into FlSpot objects for chart plotting
                  List<FlSpot> spots = topFiveData.map((data) {
                    return FlSpot(data.domain, data.measure);
                  }).toList();

                  return AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, top: 10.0, right: 30.0, bottom: 10.0),
                      child: LineChart(
                        LineChartData(
                            minX: topFiveData.first
                                .domain, //buat ini sama dengan line titles
                            maxX: topFiveData.last.domain,
                            // minX: 0,
                            // maxX: 5,
                            minY: 0,
                            maxY: 100,
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                axisNameWidget: Text(
                                  '',
                                  style: //buat ganti title yang paling bawah dari graph
                                      TextStyle(
                                    color: Color(0Xff8B98B1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'inter',
                                  ),
                                ),
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  interval: 1,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    const style = TextStyle(
                                      color: Color(0Xff8B98B1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'inter',
                                    );
                                    Widget text;
                                    if (value.toInt() ==
                                        topFiveData[0]['domain']) {
                                      // topFiveData case
                                      text = Text(
                                          '${topFiveData[0]['domain']}'
                                              .toString(),
                                          style: style);
                                    } else if (value.toInt() ==
                                        topFiveData[1]['domain']) {
                                      // topFiveData case
                                      text = Text(
                                          '${topFiveData[1]['domain']}'
                                              .toString(),
                                          style: style);
                                    } else if (value.toInt() ==
                                        topFiveData[2]['domain']) {
                                      // topFiveData case
                                      text = Text(
                                          '${topFiveData[2]['domain']}'
                                              .toString(),
                                          style: style);
                                    } else if (value.toInt() ==
                                        topFiveData[3]['domain']) {
                                      // topFiveData case
                                      text = Text(
                                          '${topFiveData[3]['domain']}'
                                              .toString(),
                                          style: style);
                                    } else if (value.toInt() ==
                                        topFiveData[4]['domain']) {
                                      // topFiveData case
                                      text = Text(
                                          '${topFiveData[4]['domain']}'
                                              .toString(),
                                          style: style);
                                    } else {
                                      text = Text('', style: style);
                                    }
                                    return SideTitleWidget(
                                      child: text,
                                      axisSide: meta.axisSide,
                                    );
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                            ), //make a widget .dart file for this
                            gridData: FlGridData(
                              show: false, //buat bikin kotak2
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: const Color(0xFF144272),
                                  strokeWidth: 1,
                                );
                              },
                              drawVerticalLine: true,
                              getDrawingVerticalLine: (value) {
                                return FlLine(
                                  color: const Color(0xFF144272),
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            borderData: FlBorderData(
                              show: false, //buat bikin border disekitar graph
                              border: Border.all(
                                color: const Color(0xff37434d),
                                width: 1,
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: Color(0xFF576CBC),
                                barWidth: 5,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF576CBC).withOpacity(0.5),
                                      Color(0xFF8B98B1).withOpacity(0.0)
                                    ],
                                    stops: [0.0, 1.0],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  );
                },
              ),
              StreamBuilder(
                stream: streamChart,
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data available'));
                  }

                  List<SoilData> SoilDataList = snapshot.data!.docs.map((e) {
                    return SoilData(
                      domain: e.data()['timevalue'].toDouble(),
                      measure: e.data()['soil'].toDouble(), //ganti
                    );
                  }).toList();

                  // Sort the list in descending order based on the 'domain' (timevalue)

                  SoilDataList.sort((a, b) => b.domain.compareTo(a.domain));

                  // Take the first 5 data points with the greatest 'timevalue'
                  List<SoilData> topFiveData = SoilDataList.take(5).toList();

                  // Sort the top 5 data points in ascending order based on the 'timevalue' (domain)
                  topFiveData.sort((a, b) => a.domain.compareTo(b.domain));

                  // Convert the top 5 data points into FlSpot objects for chart plotting
                  List<FlSpot> spots = topFiveData.map((data) {
                    return FlSpot(data.domain, data.measure);
                  }).toList();
                  const styleTitle = TextStyle(
                    color: Color(0XFFFCFFE7),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'inter',
                  );
                  const styleBody = TextStyle(
                    color: Color(0Xff8B98B1),
                    fontWeight: FontWeight.bold,
                    fontSize: 15.23,
                    fontFamily: 'inter',
                  );
                  return Align(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Soil Moisture by Time', //ganti
                              style: TextStyle(
                                color: Color(0xFFEAE3E3),
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                fontFamily: 'inter',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 19, left: 5, right: 125, bottom: 10),
                              child: Column(
                                children: [
                                  Text('Time', style: styleTitle),
                                  SizedBox(height: 17),
                                  Text(
                                    '${topFiveData[0]['domain']}',
                                    style: styleBody,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '${topFiveData[1]['domain']}',
                                    style: styleBody,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '${topFiveData[2]['domain']}',
                                    style: styleBody,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '${topFiveData[3]['domain']}',
                                    style: styleBody,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '${topFiveData[4]['domain']}',
                                    style: styleBody,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 19, left: 10, right: 10, bottom: 10),
                              child: Column(
                                children: [
                                  Text('Soil', style: styleTitle), //ganti
                                  SizedBox(height: 17),
                                  Text(
                                    '${topFiveData[0]['measure']}',
                                    style: styleBody,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '${topFiveData[1]['measure']}',
                                    style: styleBody,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '${topFiveData[2]['measure']}',
                                    style: styleBody,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '${topFiveData[3]['measure']}',
                                    style: styleBody,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '${topFiveData[4]['measure']}',
                                    style: styleBody,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }
}
