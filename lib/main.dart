import 'package:directory_app/provider/user_provider.dart';
import 'package:directory_app/screens/homepage.dart';
import 'package:directory_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataProvider>(
            create: (_) => UserDataProvider(),
          ),


        ],
        child:  MaterialApp(
          title: 'Directory App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          home: SplashScreen(),
        )

    );
  }
}

