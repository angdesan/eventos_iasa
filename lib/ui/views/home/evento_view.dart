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
        title: Padding(
          padding: EdgeInsets.only(top: 26),
          child: Text(
            "Próximos Eventos",
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
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  title: Text(
                    evento.nombre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evento.descripcion,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.date_range, color: Colors.grey, size: 16),
                          SizedBox(width: 4),
                          Expanded(
                              child: Text(
                                'Fecha: ${evento.fecha.toLocal().toString()}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey, size: 16),
                          SizedBox(width: 4),
                          Expanded(
                              child: Text(
                                'Ubicación: ${evento.ubicacion}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () =>{
                    Navigator.of(context)
                        .pushNamed("/invitado",
                        arguments: evento)
                  },
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.event_available_rounded,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () =>{
                      Navigator.of(context)
                          .pushNamed("/invitado",
                          arguments: evento)
                    },
                    icon: Icon(
                      Icons.app_registration,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              )
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
