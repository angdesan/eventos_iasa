import 'package:eventos_iasa/ui/routes.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class Exampleapp extends StatefulWidget {
  const Exampleapp({Key? key}) :super(key: key);

  @override
  State<Exampleapp> createState() => _ExampleApp(); 
}

class _ExampleApp extends State<Exampleapp> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: AppColors.mainColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light),
      initialRoute: '/',
      onGenerateRoute: Routes.generateRoute,
    );
  }
}