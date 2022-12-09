import 'dart:io';
import 'package:csv/csv.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../repositories/pet_repository.dart';

class ReportPage extends StatefulWidget {
  ReportPage();

  @override
  State<ReportPage> createState() => _ReportPageState();
}

enum Periodo { atual, historico }

class _ReportPageState extends State<ReportPage> {
  bool loading = false; //feedback enquanto carrega
  List<String> years = [];

  List<Color> cores = [
    Color(0xFF3F51B5),
  ];
  Periodo periodo = Periodo.atual;
  Map historico = {};
  Map dadosPeriodo = {};
  List datas = [];
  List<FlSpot> dadosGrafico = [];
  double maxX = 0;
  double maxY = 0;
  double minY = 0;
  ValueNotifier<bool> loaded = ValueNotifier(false);
  late PetRepository repositorio;

  generateCsv(String year) async {
    setState(() => loading = true);
    print(year);
    List<List<String>> data = repositorio.getReportAdoptions(year);
    String csv = ListToCsvConverter().convert(data);

    var file = File('');
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);
      file = File('${dir.path}/relatorioAdocao$year.csv');
      try {
        file.writeAsString(csv);
        setState(() => loading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(feedbackSnackbar(text: "Dowload finalizado"));
      } on FileSystemException catch (e) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(feedbackSnackbar(text: e));

        // handle error
      }
    }
  }

  setDados() async {
    loaded.value = false;
    dadosGrafico = [];
    datas = [];

    if (historico.isEmpty) {
      historico = repositorio.getHistoricoPet();
    }

    if (periodo.name == 'atual') {
      dadosPeriodo = new Map.fromIterable(
          historico.keys.where((k) => k.year == DateTime.now().year),
          key: (k) => k,
          value: (k) => historico[k]);
    } else {
      dadosPeriodo = historico;
    }
    //dados selecionados em uma lista e formata data
    //limites
    maxX = dadosPeriodo.length.toDouble();
    maxY = 0;
    minY = double.infinity;

    for (var value in dadosPeriodo.values) {
      maxY = value > maxY ? value : maxY;
      minY = value < minY ? value : minY;
    }
    //passar para array do FlSpot
    var i = 0;
    for (var key in dadosPeriodo.keys) {
      dadosGrafico.add(FlSpot(
          i.toDouble(), //indice
          dadosPeriodo[key]));
      datas.add(key);
      i = i + 1;
    }
    loaded.value = true;
  }

  LineChartData getChartData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: dadosGrafico,
          isCurved: true,
          colors: cores,
          barWidth: 2,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            colors: cores.map((color) => color.withOpacity(0.15)).toList(),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Color(0xFF343434),
          getTooltipItems: (data) {
            return data.map((item) {
              final date = getDate(item.spotIndex);
              return LineTooltipItem(
                item.y.toString(),
                TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '\n $date',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(.5),
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  getDate(int index) {
    DateTime date = datas[index];

    return DateFormat('MM/yyyy').format(date);
  }

  chartButton(Periodo p, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton(
        onPressed: () => setState(() => periodo = p),
        child: Text(label),
        style: (periodo != p)
            ? ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.grey),
              )
            : ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.indigo[50]),
              ),
      ),
    );
  }

  feedbackSnackbar({text}) {
    return SnackBar(
      //behavior: SnackBarBehavior.floating,
      content: Text(text),
      duration: Duration(milliseconds: 3000),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    repositorio = context.read<PetRepository>();
    years = repositorio.getYearsAdoptions();
    String selectedYear = years[0];

    setDados();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Padding(
            padding: EdgeInsets.all(24),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Relatório",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
              Container(
                child: AspectRatio(
                  aspectRatio: 2,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            chartButton(Periodo.atual, 'Atual'),
                            chartButton(Periodo.historico, 'Historico'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: ValueListenableBuilder(
                          valueListenable: loaded,
                          builder: (context, bool isLoaded, _) {
                            return (isLoaded)
                                ? LineChart(
                                    getChartData(),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  DropdownButton<String>(
                    value: selectedYear,
                    icon: const Icon(Icons.arrow_circle_down),
                    iconSize: 20,
                    elevation: 40,
                    // underline: Container(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedYear = newValue!;
                      });
                    },
                    items: List.generate(
                      years.length,
                      (index) => DropdownMenuItem(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(years[index]),
                        ),
                        value: years[index],
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => generateCsv(selectedYear),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.indigo),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: (loading)
                            ? [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: SizedBox(
                                    //width: double.infinity,
                                    //height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ]
                            : [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Dowload",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                      ),
                    ),
                  ),
                ],
              ),
            ])));
  }
}
