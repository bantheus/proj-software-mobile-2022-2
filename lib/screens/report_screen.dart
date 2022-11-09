import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../repositories/pet_repository.dart';

class ReportPage extends StatefulWidget {
  ReportPage();

  @override
  State<ReportPage> createState() => _ReportPageState();
}

enum Periodo { atual, historico }

class _ReportPageState extends State<ReportPage> {
  List<Color> cores = [
    Color(0xFF3F51B5),
  ];
  Periodo periodo = Periodo.atual;
  Map historico = {};
  List datas = [];
  List<FlSpot> dadosGrafico = [];
  double maxX = 0;
  double maxY = 0;
  double minY = 0;
  ValueNotifier<bool> loaded = ValueNotifier(false);
  late PetRepository repositorio;

  setDados() async {
    loaded.value = false;
    dadosGrafico = [];
    datas = [];

    if (historico.isEmpty) {
      historico = repositorio.getHistoricoPet();
    }
    //dados selecionados em uma lista e formata data
    //limites
    maxX = historico.length.toDouble();
    maxY = 0;
    minY = double.infinity;

    for (var value in historico.values) {
      maxY = value > maxY ? value : maxY;
      minY = value < minY ? value : minY;
    }
    //passar para array do FlSpot
    var i = 0;
    for (var key in historico.keys) {
      dadosGrafico.add(FlSpot(
          i.toDouble(), //indice
          historico[key]));
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

  @override
  Widget build(BuildContext context) {
    repositorio = context.read<PetRepository>();

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
              )
            ])));
  }
}
