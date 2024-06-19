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
  final dataMap = <String, double>{
    "Asisten": 5,
    "No Asisten":10
  };

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
      body: Container(
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
            FutureBuilder(
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
                            borderRadius: BorderRadius.circular(8.0),
                            icon: const Icon(Icons.event_available),
                            hint: const Text("Evento a Seleccionar"),
                            value: _selectedOption,
                            onChanged: (newValue){
                              setState(() {
                                _selectedOption = newValue!;
                              });
                            }),
                      )
                    ],
                  );
                }
            ),
            SizedBox(height: 50,),
            PieChart(
              dataMap: dataMap,
              chartType: ChartType.disc,
              baseChartColor: Colors.grey[300]!,
              colorList: colorList,
            ),
          ],
        ),
      ),
    );
  }

}