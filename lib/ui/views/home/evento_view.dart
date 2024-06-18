import 'package:eventos_iasa/constants/colors.dart';
import 'package:eventos_iasa/models/evento.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventosView extends StatefulWidget {
  const EventosView({Key? key}) : super(key: key);

  @override
  _EventosView createState() => _EventosView();
}

class _EventosView extends State<EventosView> {
  final _future = Supabase.instance.client.from('evi_Eventos').select();
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
          "Elegir Evento",
          style: TextStyle(color: AppColors.text_light),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final eventosIASA = snapshot.data!;
        return ListView.builder(
          itemCount: eventosIASA.length,
          itemBuilder: (context, index) {
            final eventoConsulta = eventosIASA[index];
            Evento evento = new Evento(
                eventoConsulta['eve_Id'],
                eventoConsulta['eve_nombre'],
                eventoConsulta['eve_descripcion'],
                DateTime.parse(eventoConsulta['eve_fecha']),
                eventoConsulta['eve_ubicacion']);
            return Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.grey.shade100),
              child: ListTile(
                title: Text(
                  evento.nombre,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(evento.descripcion+"\n"+
                    "Fecha: "+ evento.fecha.toUtc().toString()+"\n"+
                    "Ubicacion: "+evento.ubicacion
                ),
                onTap: () =>{
                  Navigator.of(context)
                      .pushNamed("/evento",
                      arguments: evento)
                },
                leading: Icon(
                  Icons.event_available_rounded,
                  color: AppColors.primaryColor,
                ),
                trailing: IconButton(
                  onPressed: () =>{
                    Navigator.of(context)
                        .pushNamed("/evento",
                    arguments: evento)
                  },
                  icon: Icon(
                      Icons.app_registration,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _insertarInvitado() async {
    final response =
        await Supabase.instance.client.from("evi_invitados").insert({
      'inv_cedula': int.parse(_cedula.text),
      'inv_evento': _selectedOption,
      'inv_nombres': _nombres.text,
      'inv_correo': _correo.text,
      'inv_telefono': int.parse(_telefono.text),
      'inv_asistenciaEvento': false
    });
  }
}
