import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../constants/colors.dart';

class ReporteView extends StatefulWidget {
  const ReporteView({Key? key}) : super(key: key);

  @override
  _ReporteView createState() => _ReporteView();
}

class _ReporteView extends State<ReporteView> {
  String? _selectedOption;
  final _future = Supabase.instance.client
      .from('evi_Eventos')
      .select();
  late var dataMap;
  late bool _existeDataReporte = false;
  final colorList = <Color>[
    Colors.greenAccent,
    Colors.redAccent
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: 26),
          child: Text(
            "Reporte de Asistencia a Eventos IASA",
            style: TextStyle(
                color: AppColors.text_light,
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    return  Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              "Elija un Evento",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor
              ),
            ),
          ),
          _dropDownButton(),
          SizedBox(height: 16,),
          _pieChartEventos()
        ],
      ),
    );
  }

  Card _pieChartEventos() {
    return Card(
            elevation: 4,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _existeDataReporte? PieChart(
                dataMap: dataMap,
                chartType: ChartType.disc,
                baseChartColor: Colors.grey[300]!,
                colorList: colorList,
                legendOptions: LegendOptions(
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ): Center(
                child: Text(
                  'No existen datos para mostrar',
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
              ),
            )
        );
  }

  FutureBuilder<PostgrestList> _dropDownButton() {
    return FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final eventosIASA = snapshot.data;
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey,width: 1),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black26
                    ),
                    margin: EdgeInsets.only(left: 20,right: 150),
                    child: DropdownButton<String>(
                        items: eventosIASA?.map((toElement) =>
                            DropdownMenuItem(
                                value: toElement['eve_Id'] as String,
                                child: Text(toElement['eve_nombre'] as String)
                            )).toList(),
                        underline: SizedBox(),
                        isExpanded: true,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        borderRadius: BorderRadius.circular(8.0),
                        icon: const Icon(Icons.event_available),
                        hint: const Text("Evento a Seleccionar"),
                        value: _selectedOption,
                        onChanged: (newValue){
                          setState(() {
                            _selectedOption = newValue!;
                            _obtenerReportePorEvento(_selectedOption!);
                          });
                        }),
                  )
                ],
              );
            }
        );
  }

  void _obtenerReportePorEvento(String evento) async {
    try{
      final response = await Supabase.instance.client
          .from('evi_invitados')
          .select('inv_asistenciaEvento')
          .eq('inv_evento',evento);
      double countTrue = 0;
      double countFalse = 0;
      for (var item in response) {
        if (item['inv_asistenciaEvento'] == true) {
          countTrue++;
        } else {
          countFalse++;
        }
      }
      setState(() {
        dataMap =  <String, double>{
          "Asisten": countTrue,
          "No Asisten":countFalse
        };
        _existeDataReporte = true;
      });
    }catch(error){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              content: Text(
                  'Error al realizar la consulta')
          )
      );
      setState(() {
        _existeDataReporte=false;
      });
    }
  }
}