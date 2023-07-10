import 'package:directory_app/model/user_model.dart';
import 'package:directory_app/provider/search_provider.dart';
import 'package:directory_app/provider/user_provider.dart';
import 'package:directory_app/screens/auth/create_account.dart';
import 'package:directory_app/screens/auth/login_screen.dart';
import 'package:directory_app/screens/homepage.dart';
import 'package:directory_app/screens/my_profile.dart';
import 'package:directory_app/screens/profile.dart';
import 'package:directory_app/screens/search_screen.dart';
import 'package:directory_app/screens/splash_screen.dart';
import 'package:directory_app/screens/user_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        authDomain: "directory-app-27cea.firebaseapp.com",
        apiKey: "AIzaSyAR3fUslOYS1d3IlqtLqd_uCZjTJeVRoi0",
        appId: "1:31156258293:web:4c8deda32ec22f08610cbc",
        messagingSenderId: "31156258293",
        storageBucket: "directory-app-27cea.appspot.com",
        projectId: "directory-app-27cea",
      ),
    );
    if (kIsWeb) {
      // initialiaze the facebook javascript SDK
      await FacebookAuth.i.webAndDesktopInitialize(
        appId: "281617587734794",
        cookie: true,
        xfbml: true,
        version: "v14.0",
      );
    }
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataProvider>(
            create: (_) => UserDataProvider(),
          ),
          ChangeNotifierProvider<SearchProvider>(
            create: (_) => SearchProvider(),
          ),


        ],
        child:  MaterialApp.router(
          routerConfig: _router,
          title: 'Directory App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          //home: LoginScreen(),

        )

    );
  }
  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) =>  SplashScreen(),
      ),
      GoRoute(
        path: '/user-profile/:userId',
        builder: (context, state) =>  ProfileScreen(userId:state.pathParameters['userId']!),
      ),


    ],
  );
}

