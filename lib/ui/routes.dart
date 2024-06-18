import 'package:eventos_iasa/ui/views/home/home.dart';
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