import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget bottomTitleWidgets(double value,TitleMeta meta){
  const style=TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  Widget text;
  switch (value.toInt()) {
    case 0: //case perlu diganti dengan value topFiveData
      text=const Text('MAR',style: style);
      break;
    case 1:
      text=const Text('JUN',style: style);
      break;
    case 2:
      text=const Text('SEP',style: style);
      break;
    default:
      text=const Text('x',style: style);
      break;
  }
  return SideTitleWidget(child: text,
  axisSide: meta.axisSide,
  );
}

class LineTitles{
  static getTitleData()=>FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      ),
    ),
  );
}