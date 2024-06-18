import 'dart:async';

import 'package:eventos_iasa/constants/colors.dart';
import 'package:eventos_iasa/utils/util.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashView createState() => _SplashView();
}

class _SplashView extends State<SplashView> {
  Timer? _delaySplash;

  @override
  void initState() {
    super.initState();
    _delaySplash = Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed("/home");
    });
  }
  @override
  void dispose() {
    super.dispose();
    _delaySplash!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Util.sizeScreen(context: context).width*0.40,
              height: Util.sizeScreen(context: context).width * 0.40,
              child: Icon(Icons.insert_invitation_outlined, color: AppColors.text_dark, size: 150),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text("EVENTOS IASA",
            style: TextStyle(
              fontSize:32,
              color: AppColors.text_dark,
              fontWeight:FontWeight.bold
            ),
            textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

}