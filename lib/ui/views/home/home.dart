import 'package:eventos_iasa/constants/colors.dart';
import 'package:eventos_iasa/ui/views/home/evento_view.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
class HomeView extends StatefulWidget{
  @override
  _HomeView createState() => _HomeView();
}
class _HomeView extends State<HomeView> {
  int _currentPage = 1;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage,
        keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: PageView(
        controller: _pageController,
        children: [EventosView()],
        onPageChanged: (int index){
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }

  CurvedNavigationBar _bottomBar() {
    return CurvedNavigationBar(
      index: _currentPage,
      color: AppColors.primaryColor,
      backgroundColor: AppColors.background,
      animationDuration: const Duration(milliseconds: 300),
      items: const <Widget>[
        Icon(Icons.edit_calendar_outlined, size: 30, color:
        AppColors.text_dark,),
        Icon(Icons.home, size: 30, color: AppColors.text_dark,),
        Icon(Icons.analytics_outlined, size: 30, color:
        AppColors.text_dark,),
      ],
      onTap: (int index){
        setState(() {
          _currentPage = index;
          _pageController!.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease);
        });
      },
    );
  }

}