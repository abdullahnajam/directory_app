import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 600;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  static double getWidth(BuildContext context){
    if(isMobile(context)){
      return MediaQuery.of(context).size.width;
    }
    else if(isDesktop(context)){
      return MediaQuery.of(context).size.width*0.5;
    }
    else{
      return MediaQuery.of(context).size.width*0.75;
    }
  }

  static double getProfileScreenWidth(BuildContext context){
    if(isMobile(context)){
      return MediaQuery.of(context).size.width*0.85;
    }
    else if(isDesktop(context)){
      return MediaQuery.of(context).size.width*0.35;
    }
    else{
      return MediaQuery.of(context).size.width*0.5;
    }
  }
  static double getDailogWidth(BuildContext context){
    if(isMobile(context)){
      return MediaQuery.of(context).size.width*0.8;
    }
    else if(isDesktop(context)){
      return MediaQuery.of(context).size.width*0.4;
    }
    else{
      return MediaQuery.of(context).size.width*0.6;
    }
  }
  static double getHeadacheGridViewHeight(BuildContext context){
    if(isMobile(context)){
      return MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 4.3);
    }
    else if(isDesktop(context)){
      return MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.1);
    }
    else{
      return MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.5);
    }
  }


  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (_size.width >= 1100) {
      return desktop;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (_size.width >= 850 && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }
}
