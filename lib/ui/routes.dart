import 'package:eventos_iasa/models/evento.dart';
import 'package:eventos_iasa/ui/views/home/home.dart';
import 'package:eventos_iasa/ui/views/home/invitado_view.dart';
import 'package:eventos_iasa/ui/views/home/registro_invitado.dart';
import 'package:flutter/material.dart';
import 'package:eventos_iasa/ui/views/Splash/splash.dart';
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashView());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeView() );
      case '/invitado':
        Evento _evento = args as Evento;
        return MaterialPageRoute(builder: (_)=> InvitadoView(_evento));
      case '/registro':
        Evento _evento = args as Evento;
        return MaterialPageRoute(builder: (_)=> RegistroInvitado(_evento));
    default:
    return _errorRoute();
    }
  }
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("ERROR"),
        ),
      );
    });
  }
}