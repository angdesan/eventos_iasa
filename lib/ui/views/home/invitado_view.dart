import 'package:eventos_iasa/models/invitado.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/colors.dart';
import '../../../models/evento.dart';

class InvitadoView extends StatefulWidget {
  final Evento evento;
  InvitadoView(this.evento);
  @override
  _InvitadoView createState() => _InvitadoView();
}

class _InvitadoView extends State<InvitadoView> {
  late final SupabaseClient _supabaseClient;
  TextEditingController _busquedaUsuario = TextEditingController();
  List<dynamic> _consultaInvitados = [];
  @override
  void initState() {
    super.initState();
    _supabaseClient = Supabase.instance.client;
    _obtenerInvitados();
  }
  @override
  void dispose() {
    _busquedaUsuario.dispose();
    super.dispose();
  }

  void _obtenerInvitados() async {
    try{
      final response = await _supabaseClient
          .from('evi_invitados')
          .select()
          .eq('inv_evento', widget.evento.id);
      setState(() {
        _consultaInvitados = response;
      });
    }catch(error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              content: Text(
                  'Error al obtener los invitados')
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: AppColors.text_light,
              size: 28,
            ),
            onPressed: () => Navigator.of(context)
                .pushNamed("/registro", arguments: widget.evento),//Aún no está creado
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Buscar Invitados de "+ widget.evento.nombre,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            ) ,
          ),
          SizedBox(height: 20.0,),
          TextField(
            controller: _busquedaUsuario,
            decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none
              ),
              hintText: "eg: Angelo Sanchez",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (text) async {
              final response = await _supabaseClient
                  .from('evi_invitados')
                  .select()
                  .eq('inv_evento', widget.evento.id)
              .ilike('inv_nombres', '$text%');
              setState(() {
                _consultaInvitados = response;
              });

            },
          ),
          SizedBox(height: 20.0,),
          Expanded(
            child: ListView.builder(
                itemCount: _consultaInvitados.length,
                itemBuilder: (context, index){
                  final invitadoConsulta = _consultaInvitados[index];
                  Invitado invitado = new Invitado(invitadoConsulta['inv_cedula'],
                      invitadoConsulta['inv_evento'],
                      invitadoConsulta['inv_nombres'],
                      invitadoConsulta['inv_correo'],
                      invitadoConsulta['inv_telefono'],
                      invitadoConsulta['inv_asistenciaEvento']);
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
                            invitado.nombres,
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
                                "0"+invitado.id.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.email_outlined, color: Colors.grey, size: 16),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${invitado.correo}',
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
                                  Icon(Icons.phone, color: Colors.grey, size: 16),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${invitado.telefono}',
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
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.event_available_rounded,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          trailing: !invitado.asistenciaEvento? IconButton(
                            onPressed: () =>{
                              _mostrarDialogoActualizar(invitado)
                            },
                            icon: Icon(
                              Icons.pending_actions_outlined,
                              color: AppColors.primaryColor,
                            ),
                          ): Icon(Icons.check),
                        ),
                      )
                  );
                }),

          ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoActualizar(Invitado invitado) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Evita cerrar el diálogo haciendo clic fuera de él
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Asistencia'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de querer confirmar tu asistencia al evento?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                _notificarAsistencia(invitado);
                Navigator.of(context).pop();
                _obtenerInvitados();
              },
            ),
          ],
        );
      },
    );
  }
  
  void _notificarAsistencia(Invitado invitado) async {
    await _supabaseClient
        .from('evi_invitados')
        .update({'inv_asistenciaEvento':true})
        .eq('inv_cedula', invitado.id)
        .eq('inv_evento', invitado.evento);
  }

}