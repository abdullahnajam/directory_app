import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:directory_app/screens/homepage.dart';
import 'package:directory_app/screens/my_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user_model.dart';
import '../provider/user_provider.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with TickerProviderStateMixin{
  AnimationController? animationController;
  @override
  void initState() {
    super.initState();
    print('firebase user ${FirebaseAuth.instance.currentUser}');


    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )
      ..forward()
      ..repeat(reverse: true);
    _loadWidget();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }
  final splashDelay = 2;


  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }


  void navigationPage() async{
    if(FirebaseAuth.instance.currentUser!=null){
      print('userId ${FirebaseAuth.instance.currentUser!.uid}');
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) async{
        if (documentSnapshot.exists) {
          print("user exists");
          Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
          UserModel user=UserModel.fromMap(data,documentSnapshot.reference.id);
          print("user ${user.userId} ${user.status}");
          if(user.status=="Pending"){
            FirebaseAuth.instance.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Homepage()));

          }
          else if(user.status=="Blocked"){
            FirebaseAuth.instance.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Homepage()));
          }
// Get all countries

          else if(user.status=="Approved"){

            final provider = Provider.of<UserDataProvider>(context, listen: false);
            provider.setUserData(user);
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyProfile()));



          }
        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Homepage()));
        }

      });
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Homepage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child:  Padding(
                  padding: const EdgeInsets.all(20),
                  child: AnimatedBuilder(
                    animation: animationController!,
                    builder: (context, child) {
                      return Container(
                        decoration: ShapeDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: const CircleBorder(),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20.0 * animationController!.value),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(50),
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: CircleBorder(),
                      ),
                      child: Image.asset("assets/images/logo.png",width: 250,height: 250,),
                    ),
                  ),
                )
            ),
            const Align(
                alignment: Alignment.bottomCenter,
                child:  Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(""),
                )
            )


          ],
        )
    );
  }
}

