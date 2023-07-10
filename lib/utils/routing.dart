/*
import 'package:directory_app/screens/auth/login_screen.dart';
import 'package:directory_app/screens/homepage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart' hide Router;
class FluroRouter {
  static var router = FluroRouter();

  static var firstScreen = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return const Homepage();
      });

  static var secondScreen = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return const LoginScreen();
      });

  static void configureRoutes(FluroRouter router) {
    router.define(kLoginRoute, handler: _loginHandler);
    router.define(kRegisterRoute, handler: _registerHandler);
    router.define(kHomeRoute, handler: _homeHandler);
    router.define(kProfileRoute, handler: _profileHandler);
    router.define(kNotificationsRoute, handler: _notificationsHandler);
    router.define(kChatRoute, handler: _chatHandler);
  }

  static dynamic defineRoutes() {

    router.define("/", handler: firstScreen);
    router.define("second", handler: secondScreen);
  }
}*/
import 'package:directory_app/screens/auth/login_screen.dart';
import 'package:directory_app/screens/homepage.dart';
import 'package:go_router/go_router.dart';

