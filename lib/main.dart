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

Color get kFlashPicksBlue => const Color.fromRGBO(5, 47, 107, 1);
charts.Color get kChartsFlashPicksBlue => const charts.Color(r: 5, g: 47, b: 107);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool showPreviousLines = false;

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

  }

  double maxVal = 100;
  double graphNeedsChangeCount = 0;
  double secondGraphNeedsChangeCount = 0;
  int itemsInList = 1;
  Widget googleChart = SizedBox.shrink();

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
            itemsInList = 1+Random().nextInt(15);
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
            updateGoogleChart();
          });
        },
        icon: Icon(Icons.refresh_rounded),
      ),
      body: Center(
        child: SingleChildScrollView(
          // height: 300,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Prev. Lines"),
                  Switch.adaptive(
                      value: showPreviousLines,
                      onChanged: (newVal){
                        setState(() {
                          showPreviousLines = newVal;
                          updateGoogleChart();
                        });
                      }
                  )
                ],
              ),
              Container(
                height: 300,
                  child: get2()
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Text("NFL Games 20/9 - 1/11"),
              )
              // SizedBox(
              //   height: 300, width: 300,
              //   child: googleChart
              // ),
              //




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

  void updateGoogleChart() async {
    setState(() {
      googleChart = SizedBox.shrink();
    });
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
        googleChart = charts.OrdinalComboChart(
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
              if(showPreviousLines)
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
            ]
        );
    });

  }

double containerWidth = 350;

  Widget get2(){

    // bar was 34 * length+1
    // line was 35.2 * length+1


    double barTotalWidth = containerWidth - 40;
    // double width = values.length
    double barWidth = ((barTotalWidth) / (values.length)) - 5;

    double lineWidth = containerWidth;

    double minY = 0;


    return Stack(
      children: [
        SizedBox(
          width: containerWidth,
          // width: ((width+4)*(values.length+1)),
          // key: ValueKey(secondGraphNeedsChangeCount),
          child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: kFlashPicksBlue
                  )
                ),
                minY: minY,
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
                      show: true
                  ),
                  extraLinesData: showPreviousLines? null : ExtraLinesData(
                      extraLinesOnTop: true,
                      horizontalLines: [
                        HorizontalLine(
                            y: values.average,
                            label: HorizontalLineLabel(
                                show: true,
                                style: TextStyle(
                                  color: Colors.white,
                                  background: Paint()..color = kFlashPicksBlue
                                    ..strokeWidth = 16
                                    ..style = PaintingStyle.stroke,
                                )
                            ),
                            color: kFlashPicksBlue
                        )
                      ]
                  ),
                  barGroups: List.generate(values.length, (index){
                    return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                              fromY: 0,
                              width: barWidth,
                              borderRadius: BorderRadius.zero,
                              toY: values[index].toDouble(),
                              color: values[index] >= values.average?Colors.green:Colors.red
                          )
                        ]
                    );
                  }).toList(),
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
        if(showPreviousLines)
        Container(
          alignment: Alignment.centerLeft,
          // height: 150,
          width: lineWidth,
          // width: ((width+5.2)*(values.length+1)),
          // key: ValueKey(graphNeedsChangeCount),
          // width: 200,
          child: LineChart(
              LineChartData(
                  maxX: values.length.toDouble() - 0.5,
                  minX: -0.45,
                  minY: minY,
                  maxY: 100,
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: kFlashPicksBlue
                    )
                  ),
                  extraLinesData: ExtraLinesData(
                      extraLinesOnTop: true,
                      horizontalLines: [
                        HorizontalLine(
                            y: values.average,
                            label: HorizontalLineLabel(
                                show: true,
                                style: TextStyle(
                                  color: Colors.white,
                                  background: Paint()..color = kFlashPicksBlue
                                    ..strokeWidth = 16
                                    ..style = PaintingStyle.stroke,
                                )
                            ),
                            color: kFlashPicksBlue
                        )
                      ]
                  ),
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
                  // clipData: FlClipData.all(),
                  lineBarsData: [
                    LineChartBarData(
                        color: Colors.grey,
                        dotData: FlDotData(
                          getDotPainter: (spot, val, bar, index){
                            return FlDotSquarePainter(
                              color: Colors.grey,
                              size: 8,
                              strokeWidth: 1
                            );
                          }
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
      ],
    );
  }

}


List<charts.Series<OrdinalSales, String>> _createSampleData() {
  List<OrdinalSales> data = [];
  valuesDouble.forEachIndexed((index, element) {
    data.add(
      OrdinalSales(getTitle(index), element)
    );
  });

  List<OrdinalSales> dataLine = [];
  valuesDouble2.forEachIndexed((index, element) {
    dataLine.add(
        OrdinalSales(getTitle(index), element)
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
    if(showPreviousLines)
    charts.Series<OrdinalSales, String>(
        id: 'customLine',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: dataLine)
    // Configure our custom line renderer for this series.
      ..setAttribute(charts.rendererIdKey, 'customLine'),
    charts.Series<OrdinalSales, String>(
        id: 'straightLine',
        colorFn: (_, __) => kChartsFlashPicksBlue,
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

Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 10,
  );

  var val = value.toInt();

  var maxWidthText = "MMM";
  final Size txtSize = _textSize(maxWidthText, style);
  String text = "";
  if(txtSize.width * values.length < 350){
    text = getTitle(val);
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 8,
    child: Text(text, style: style),
  );
}

// Here it is!
Size _textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
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

String getTitle(int index){
  if(index < _strVals.length){
    return _strVals[index];
  }else{
    return "";
  }
}
List<String> _strVals = [
  "SEA","DEN","LIV","JAX","CIN","LVR","LVR"
];

double baseline = 29.5;
