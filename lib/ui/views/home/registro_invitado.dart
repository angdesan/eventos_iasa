import 'package:eventos_iasa/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/evento.dart';

class RegistroInvitado extends StatefulWidget {
  final Evento evento;
  RegistroInvitado(this.evento);

  @override
  _RegistroInvitado createState() => _RegistroInvitado();
}

class _RegistroInvitado extends State<RegistroInvitado> {
  final TextEditingController _controllerCedula =
  TextEditingController();
  final TextEditingController _controllerNombre =
  TextEditingController();
  final TextEditingController _controllerCorreo =
  TextEditingController();
  final TextEditingController _controllerTelefono =
  TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.text_dark,
      appBar: AppBar(
        backgroundColor: AppColors.text_dark,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: AppColors.text_dark,
            ),
            onPressed: () => Navigator.of(context)
                .pushNamed("/home"),//Aún no está creado
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                  "Registro a Evento "+widget.evento.nombre,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: _controllerCedula,
                keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.perm_identity_outlined),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0,
                          20.0, 15.0),
                      hintText: "Ingrese su cedula",
                      labelText: "Cedula",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      )
                  )
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                  controller: _controllerNombre,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_rounded),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0,
                          20.0, 15.0),
                      hintText: "Ingrese su nombre",
                      labelText: "Nombre",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      )
                  )
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                  controller: _controllerCorreo,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0,
                          20.0, 15.0),
                      hintText: "Ingrese su Correo",
                      labelText: "Correo",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      )
                  )
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                  controller: _controllerTelefono,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_rounded),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0,
                          20.0, 15.0),
                      hintText: "Ingrese su numero de Telefono",
                      labelText: "Telefono",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      )
                  )
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {
                    _insertarInvitado()
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      textStyle: TextStyle(fontSize: 16, color:
                      Colors.white),
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text("Registrar a Evento",style: TextStyle(color:
                  AppColors.text_dark),),
                ),
              ),
            ],
          ),
        )
    );
  }

  void _insertarInvitado() async{
    if(_controllerCedula.text.isEmpty || _controllerNombre.text.isEmpty ||
    _controllerCorreo.text.isEmpty || _controllerTelefono.text.isEmpty){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Por favor llene todos los campos')));
    } else {
      try{
        await Supabase.instance.client
            .from("evi_invitados")
            .insert(
            {
              'inv_cedula': int.parse(_controllerCedula.text),
              'inv_evento': widget.evento.id,
              'inv_nombres': _controllerNombre.text,
              'inv_correo': _controllerCorreo.text,
              'inv_telefono': int.parse(_controllerTelefono.text),
              'inv_asistenciaEvento': false
            });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Se inscrito al evento correctamente')));
        Navigator.of(context).pushReplacementNamed("/home");
      } catch(error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Ocurrió un error al realizar el registro')));
      }

    }
  }

}