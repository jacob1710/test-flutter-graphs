import 'dart:ffi';
import 'dart:math';

import 'package:charts_painter/chart.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart' as FLC;
import 'package:collection/collection.dart';
// import 'package:graphic/graphic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

  }

  double maxVal = 100;
  double graphNeedsChangeCount = 0;
  double secondGraphNeedsChangeCount = 0;
  int itemsInList = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: IconButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.inversePrimary),
      ),
        iconSize:50,
        onPressed: () {
          setState(() {
            itemsInList = 1+Random().nextInt(6);
            print(itemsInList);
            valuesDouble = List.generate(itemsInList, (index) {
              return Random().nextDouble()*maxVal;
            });
            valuesDouble2 = List.generate(itemsInList, (index) {
              return Random().nextDouble()*maxVal;
            });
            values = List.generate(itemsInList, (index) {
              return Random().nextInt(maxVal.toInt());
            });
            values2 = List.generate(itemsInList, (index) {
              return Random().nextInt(maxVal.toInt());
            });
            print(valuesDouble);
            graphNeedsChangeCount ++;
            secondGraphNeedsChangeCount ++;
          });
        },
        icon: Icon(Icons.refresh_rounded),
      ),
      body: Center(
        child: SingleChildScrollView(
          // height: 300,
          child: Column(
            children: [
              Container(
                height: 300,
                  child: get2()
              ),
              SizedBox(
                height: 300,
                width: 300,
                child: charts.OrdinalComboChart(
                    _createSampleData(),
                  animate: true,
                  animationDuration: Duration(milliseconds: 500),
                  behaviors: [
                    charts.LinePointHighlighter(
                      symbolRenderer: charts.CircleSymbolRenderer(

                      ),
                    )
                  ],
                  // Configure the default renderer as a bar renderer.
                  defaultRenderer: charts.BarRendererConfig(
                      groupingType: charts.BarGroupingType.grouped),
                  // Custom renderer configuration for the line series. This will be used for
                  // any series that does not define a rendererIdKey.
                  customSeriesRenderers: [
                    charts.LineRendererConfig(
                        symbolRenderer: charts.RectSymbolRenderer(

                        ),
                      includePoints: true,
                      stacked: false,
                      // ID used to link series to this renderer.
                        customRendererId: 'customLine'),
                    charts.LineRendererConfig(
                        symbolRenderer: charts.CircleSymbolRenderer(

                        ),
                        // ID used to link series to this renderer.
                        customRendererId: 'straightLine'),
                    // charts.LineRendererConfig(
                    //     // ID used to link series to this renderer.
                    //     customRendererId: 'straightLine'),
                    // charts.LineRendererConfig(
                    //
                    // )
                  ]),
              ),
              // Chart(
              //   state: ChartState<void>(
              //       data: ChartData.fromList(
              //         valuesDouble
              //             .map((e) => ChartItem(e.toDouble()))
              //             .toList(),
              //         axisMin: 10
              //         // axisMax: 8,
              //       ),
              //       itemOptions: BarItemOptions(
              //         padding: const EdgeInsets.symmetric(horizontal: 2.0),
              //         barItemBuilder: (_) => BarItem(
              //             color: Theme.of(context).colorScheme.secondary),
              //         maxBarWidth: 3.0,
              //       ),
              //       backgroundDecorations: [
              //         GridDecoration(
              //           showHorizontalGrid: true,
              //           horizontalAxisStep: 15,
              //           gridColor: Theme.of(context).dividerColor,
              //         ),
              //       ],
              //       foregroundDecorations: [
              //         TargetLineDecoration(
              //           target: 39,
              //           colorOverTarget: Theme.of(context).colorScheme.error,
              //           targetLineColor:
              //           Theme.of(context).colorScheme.secondary,
              //         ),
              //       ]),
              // ),
              // Chart(
              //   state: ChartState<void>(
              //       data: ChartData.fromList(
              //           valuesDouble
              //               .map((e) => ChartItem(e.toDouble()))
              //               .toList(),
              //           axisMin: 10
              //         // axisMax: 8,
              //       ),
              //       itemOptions: BarItemOptions(
              //         padding: const EdgeInsets.symmetric(horizontal: 2.0),
              //         barItemBuilder: (_) => BarItem(
              //             color: Theme.of(context).colorScheme.secondary),
              //         maxBarWidth: 3.0,
              //       ),
              //       backgroundDecorations: [
              //         GridDecoration(
              //           showHorizontalGrid: true,
              //           horizontalAxisStep: 15,
              //           gridColor: Theme.of(context).dividerColor,
              //         ),
              //       ],
              //       foregroundDecorations: [
              //         SparkLineDecoration(
              //           listIndex: 0,
              //           lineWidth: 10,
              //           fill: false,
              //           lineColor: Colors.red,
              //         ),
              //         TargetLineDecoration(
              //           target: 39,
              //           colorOverTarget: Theme.of(context).colorScheme.error,
              //           targetLineColor:
              //           Theme.of(context).colorScheme.secondary,
              //         ),
              //       ]),
              // ),
            ],
          ),
        )
      )
    );
  }
  Widget get2(){
    double width = 30;
    return Stack(
      children: [
        Container(
          width: ((width+4)*(values.length+1)),
          // key: ValueKey(secondGraphNeedsChangeCount),
          child: BarChart(
              BarChartData(
                maxY: 100,
                  groupsSpace: 5,
                  alignment: BarChartAlignment.start,
                  titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)
                      ),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)
                      ),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              // interval: ((maxValue-minValue)/3).roundToDouble(),
                              reservedSize: 40)
                      ),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: getTitles
                          )
                      )
                  ),
                  borderData: FlBorderData(
                      show: false
                  ),
                  extraLinesData: ExtraLinesData(
                      extraLinesOnTop: true,
                      horizontalLines: [
                        HorizontalLine(y: values.average, label: HorizontalLineLabel(show: true), color: Colors.yellow)
                      ]
                  ),
                  barGroups: List.generate(values.length, (index){
                    return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                              fromY: 0,
                              width: width,
                              borderRadius: BorderRadius.zero,
                              toY: values[index].toDouble(),
                              color: values[index] >= baseline?Colors.green:Colors.red
                          )
                        ]
                    );
                  }).toList(),
                  // barGroups: values.map((e) => BarChartGroupData(
                  //     x: values.indexOf(e),
                  //   barRods: [
                  //**/
                  //   ]
                  // )).toList()
                  gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: false
                    // horizontalInterval: 15
                  )
              ),
            swapAnimationDuration: Duration(seconds: 1),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          // height: 150,
          width: ((width+6)*(values.length+1)),
          // key: ValueKey(graphNeedsChangeCount),
          // width: 200,
          child: LineChart(
              LineChartData(
                  maxX: values.length.toDouble() - 0.5,
                  minX: -0.45,
                  minY: 0,
                  maxY: 100,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)
                      ),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)
                      ),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) => Text("")
                          )
                      ),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) => Text("")
                          )
                      )
                  ),
                  lineBarsData: [
                    LineChartBarData(
                        dotData: FlDotData(

                        ),
                        lineChartStepData: LineChartStepData(stepDirection: 1),
                        spots: List.generate(values2.length, (index){
                          return FlSpot(index.toDouble(),values2[index].toDouble(),

                          );
                        }).toList())],
                  gridData: FlGridData(
                    show: false,
                  )
              ),
            swapAnimationDuration: Duration(milliseconds: 500),
          ),
        ),
        Visibility(
          visible: false,
          child: Container(
            width: ((width+4)*(values.length+1)),
            // key: ValueKey(secondGraphNeedsChangeCount),
            child: BarChart(
                BarChartData(
                    maxY: 100,
                    groupsSpace: 5,
                    alignment: BarChartAlignment.start,
                    titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)
                        ),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)
                        ),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                // interval: ((maxValue-minValue)/3).roundToDouble(),
                                reservedSize: 40)
                        ),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: getTitles
                            )
                        )
                    ),
                    borderData: FlBorderData(
                        show: false
                    ),
                    extraLinesData: ExtraLinesData(
                        extraLinesOnTop: true,
                        horizontalLines: [
                          HorizontalLine(y: values.average, label: HorizontalLineLabel(show: true), color: Colors.yellow)
                        ]
                    ),
                    barGroups: List.generate(values.length, (index){
                      return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                                fromY: 0,
                                width: width,
                                borderRadius: BorderRadius.zero,
                                toY: values[index].toDouble(),
                                color: Colors.transparent
                            )
                          ]
                      );
                    }).toList(),
                    // barGroups: values.map((e) => BarChartGroupData(
                    //     x: values.indexOf(e),
                    //   barRods: [
                    //**/
                    //   ]
                    // )).toList()
                    gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: false
                      // horizontalInterval: 15
                    )
                )
            ),
          ),
        ),
        // Container(
        //   height: 300,
        //   width: 400,
        //   child: FLC.VerticalBarChart(
        //       painter: FLC.VerticalBarChartPainter(
        //           verticalBarChartContainer: FLC.VerticalBarChartTopContainer(
        //               chartData: FLC.ChartData(
        //                   dataRows: [valuesDouble],
        //                   chartOptions: FLC.ChartOptions(
        //
        //                   ),
        //                   dataRowsLegends: ["Teams"],
        //                   xUserLabels: strVals
        //               )
        //           )
        //       )
        //   ),
        // )
        // charts.NumericComboChart(
        //
        //   defaultRenderer: charts.LineRendererConfig(),
        // )
      ],
    );
  }

}


List<charts.Series<OrdinalSales, String>> _createSampleData() {
  List<OrdinalSales> data = [];
  valuesDouble.forEachIndexed((index, element) {
    data.add(
      OrdinalSales(strVals[index], element)
    );
  });

  List<OrdinalSales> dataLine = [];
  valuesDouble2.forEachIndexed((index, element) {
    dataLine.add(
        OrdinalSales(strVals[index], element)
    );
  });

  return [
    charts.Series<OrdinalSales, String>(
        id: 'Data',
        colorFn: (ord,val) {
          if(ord.sales > 50){
            return charts.MaterialPalette.green.shadeDefault;
          }else{
            return charts.MaterialPalette.red.shadeDefault;
          }
        },
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data),
    charts.Series<OrdinalSales, String>(
        id: 'customLine',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: dataLine)
    // Configure our custom line renderer for this series.
      ..setAttribute(charts.rendererIdKey, 'customLine'),
    charts.Series<OrdinalSales, String>(
        id: 'straightLine',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => valuesDouble.average,
        data: data)
    // Configure our custom line renderer for this series.
      ..setAttribute(charts.rendererIdKey, 'straightLine'),
  ];
}


/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}



Widget getOverlapped(){
  double width = 40;
  return AspectRatio(
    aspectRatio: 1.80,
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.0),
                // height: 150,
                child: BarChart(
                    BarChartData(
                        groupsSpace: 5,
                        alignment: BarChartAlignment.start,
                        titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)
                            ),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)
                            ),
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    // interval: ((maxValue-minValue)/3).roundToDouble(),
                                    reservedSize: 40)
                            ),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: getTitles
                                )
                            )
                        ),
                        borderData: FlBorderData(
                            show: false
                        ),
                        extraLinesData: ExtraLinesData(
                            extraLinesOnTop: true,
                            horizontalLines: [
                              HorizontalLine(y: baseline, label: HorizontalLineLabel(show: true), color: Colors.blue)
                            ]
                        ),
                        barGroups: List.generate(values.length, (index){
                          return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                    fromY: 0,
                                    width: width,
                                    borderRadius: BorderRadius.zero,
                                    toY: values[index].toDouble(),
                                    color: values[index] >= baseline?Colors.green:Colors.red
                                )
                              ]
                          );
                        }).toList(),
                        // barGroups: values.map((e) => BarChartGroupData(
                        //     x: values.indexOf(e),
                        //   barRods: [
                        //**/
                        //   ]
                        // )).toList()
                        gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: false
                          // horizontalInterval: 15
                        )
                    )
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 150,
                  width: ((width+4)*7),
                  // width: 200,
                  child: LineChart(
                      LineChartData(
                          maxX: 5.5,
                          minX: -0.5,
                          minY: 0,
                          maxY: 50,
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                              show: true,
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)
                              ),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)
                              ),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) => Text("")
                                  )
                              ),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) => Text("")
                                  )
                              )
                          ),
                          lineBarsData: [
                            LineChartBarData(
                                dotData: FlDotData(

                                ),
                                lineChartStepData: LineChartStepData(stepDirection: 1),
                                spots: List.generate(values.length, (index){
                                  return FlSpot(index.toDouble(),values[index].toDouble(),

                                  );
                                }).toList())],
                          gridData: FlGridData(
                            show: false,
                          )
                      )
                  ),
                ),
              ),
            ),
          ],
        ),
        // Container(
        //   height: 300,
        //   width: 400,
        //   child: FLC.VerticalBarChart(
        //       painter: FLC.VerticalBarChartPainter(
        //           verticalBarChartContainer: FLC.VerticalBarChartTopContainer(
        //               chartData: FLC.ChartData(
        //                   dataRows: [valuesDouble],
        //                   chartOptions: FLC.ChartOptions(
        //
        //                   ),
        //                   dataRowsLegends: ["Teams"],
        //                   xUserLabels: strVals
        //               )
        //           )
        //       )
        //   ),
        // )
        // charts.NumericComboChart(
        //
        //   defaultRenderer: charts.LineRendererConfig(),
        // )
      ],
    ),
  );
}

Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  var val = value.toInt();
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 16,
    child: Text(strVals[val], style: style),
  );
}

double get maxValue => values.reduce(max).toDouble();
double get minValue => values.reduce(min).toDouble();


List<num> values = [
  20.0,10.0,44.0,32.0,32.0,50.1,50.1
];

List<num> values2 = [
  20.0,10.0,44.0,32.0,32.0,50.1,50.1
];

List<double> valuesDouble= [
  20.0,10.0,44.0,32.0,32.0,50.1,50.1
];

List<double> valuesDouble2 = [
  20.0,10.0,44.0,32.0,32.0,50.1,50.1
];
List<String> strVals = [
  "SEA","DEN","LIV","JAX","CIN","LVR","LVR"
];

double baseline = 29.5;
