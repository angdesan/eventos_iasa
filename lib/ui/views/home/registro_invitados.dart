import 'package:eventos_iasa/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistroInvitados extends StatefulWidget {
  const RegistroInvitados({Key? key}) : super(key: key);

  @override
  _RegistroInvitados createState() => _RegistroInvitados();
}
class _RegistroInvitados extends State<RegistroInvitados> {
  final _future = Supabase.instance.client
      .from('evi_Eventos')
      .select();
  String? _selectedOption;
  int _currentStep = 0;
  TextEditingController _cedula = TextEditingController();
  TextEditingController _nombres = TextEditingController();
  TextEditingController _correo = TextEditingController();
  TextEditingController _telefono = TextEditingController();
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
        title: Text(
          "Registro",
          style: TextStyle(color: AppColors.text_light),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: const Text(
              "Formulario de Registro a un evento de IASA",
              style: TextStyle(
                fontSize: 16,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              type: StepperType.vertical,
              steps: _formularioRegistroInvitados(),
              onStepTapped: (step) => setState(() =>
              _currentStep = step),
              onStepContinue: _currentStep == _formularioRegistroInvitados().length - 1
                  ? ()
              {
                _insertarInvitado();
                Navigator.of(context).pushReplacementNamed("/home");
              }
                  : () {
                final isLastStep = _currentStep ==
                    _formularioRegistroInvitados().length - 1;
                if (isLastStep) {
                  print("complete");
                } else {
                  setState(() => _currentStep += 1);
                }
              },
              onStepCancel: _currentStep == 0
                  ? () {}
                  : () {
                setState(() => _currentStep -= 1);
              },
            ),
          ),
        ],
      ),
    );
  }
  List<Step> _formularioRegistroInvitados() => [
    Step(
        title: Text("Evento"),
        isActive: _currentStep >= 0,
        content: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final eventosIASA = snapshot.data;
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 0,right: 150),
                    child: DropdownButton<String>(
                        items: eventosIASA?.map((toElement) =>
                            DropdownMenuItem(
                                value: toElement['eve_Id'] as String,
                                child: Text(toElement['eve_nombre'] as String)
                            )).toList(),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(16.0),
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
    ),
    Step(
      title: const Text("Cedula"),
      isActive: _currentStep >= 0,
      content: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 150),
            child: TextField(
              key: ValueKey("cedula"),
              controller: _cedula,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_rounded),
                  labelText: "cedula",
                  hintText: "Ingrese su numero de cedula",
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16.0))),
            ), )
        ],
      ),
    ),
    Step(
      title: const Text("Nombre y Apellido"),
      isActive: _currentStep >= 0,
      content: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 150),
            child: TextField(
              key: ValueKey("Nombre"),
              controller: _nombres,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_rounded),
                  labelText: "Nombres",
                  hintText: "Ingrese su nombre completo",
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16.0))),
            ), )
        ],
      ),
    ),
    Step(
      title: const Text("Correo"),
      isActive: _currentStep >= 0,
      content: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 150),
            child: TextField(
              key: ValueKey("Correo"),
              controller: _correo,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Correo",
                  contentPadding:
                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Ingrese su correo",
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16.0))),
            ),
          )
        ],
      ),
    ),
    Step(
      title: const Text("Telefono"),
      isActive: _currentStep >= 0,
      content: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 150),
            child: TextField(
              key: ValueKey("Telefono"),
              controller: _telefono,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: "Telefono",
                  contentPadding:
                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Ingrese su telefono",
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16.0))),
            ),
          )
        ],
      ),
    )
  ];

  void _insertarInvitado() async{
    final response = await Supabase.instance.client
        .from("evi_invitados")
        .insert(
        {
          'inv_cedula': int.parse(_cedula.text),
          'inv_evento': _selectedOption,
          'inv_nombres': _nombres.text,
          'inv_correo': _correo.text,
          'inv_telefono': int.parse(_telefono.text),
          'inv_asistenciaEvento': false
        });
  }

}