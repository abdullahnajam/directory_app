import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../model/user_model.dart';
import '../provider/user_provider.dart';
import '../screens/my_profile.dart';
import '../widgets/custom_dailogs.dart';

class AuthenticationApi{

  //intent 0 = register ; 1= login ; 2 = forgot password ; 3 = delete account

  static Future<bool> login(String phone)async{
    List<UserModel> users=[];
    await FirebaseFirestore.instance.collection('users').where('phone',isEqualTo: phone).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        UserModel model=UserModel.fromMap(data, doc.reference.id);
        users.add(model);
      });
    });

    return users.length>0?true:false;
  }

  static Future<bool> checkIfUserExists(String phone)async{
    List<UserModel> users=[];
    await FirebaseFirestore.instance.collection('users').where('phone',isEqualTo: phone).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        UserModel model=UserModel.fromMap(data, doc.reference.id);
        users.add(model);
      });
    });

    return users.length>0?true:false;
  }

  Future<void> verifyPhoneNumber(String phoneNumber,context,int intent,var data) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: 'Please Wait',barrierDismissible: true);

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval of verification code completed.
        // Sign the user in (or link) with the auto-generated credential.
        /*await _auth.currentUser!.reload();
        if (_auth.currentUser == null) {
          await _auth.signInWithCredential(credential);
        }*/
      },
      verificationFailed: (FirebaseAuthException e) {
        pr.close();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: 'Auth Error ${e.code} : ${e.message}',
        );
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        // Handle other errors here
      },
      codeSent: (String verificationId, int? resendToken) async {
        pr.close();
        print('verify $data');
        showOtpDialog(context,intent,verificationId,data);
        // Save the verification ID somewhere, for example, using SharedPreferences.
        // Use the verificationId to build the credential by combining
        // the verification code entered by the user and the verification ID.
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        pr.close();
        // Auto-resolution timed out
      },
    );
  }
  Future<void> loginWithYouTube(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(

      scopes: ['email', 'https://www.googleapis.com/auth/youtube.readonly'],
    );
    try {
      final account = await _googleSignIn.signIn();

      // Access the YouTube-related data from the account object
      final accessToken = await account!.authentication.then((value) => value.accessToken);
      final idToken = await account.authentication.then((value) => value.idToken);

      // Use the accessToken and idToken for YouTube API requests
      print('Access Token: $accessToken');
      print('ID Token: $idToken');

      final youtubeHandle = await fetchYouTubeHandle(accessToken!);
      print('YouTube Handle: $youtubeHandle');
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'youtube':youtubeHandle
      });
      final provider = Provider.of<UserDataProvider>(context, listen: false);
      provider.setYoutube(youtubeHandle);
    } catch (e) {
      print('Error s: $e');
    }
  }

  Future<String> fetchYouTubeHandle(String accessToken) async {
    String youtubeHandle='';
    final url = 'https://www.googleapis.com/youtube/v3/channels?part=snippet&mine=true';
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    };

    final response = await get(Uri.parse(url), headers: headers);
    print('youtube api ${response.body}');
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      print('youtube api $decodedResponse');
      final items = decodedResponse['items'] as List<dynamic>;
      if (items.isNotEmpty) {
        final snippet = items[0]['snippet'];
        youtubeHandle = snippet['customUrl'];
        return youtubeHandle;
      }
    }

    return youtubeHandle;
  }


  static Future<void> register(BuildContext context,PhoneAuthCredential credential)async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: 'Please Wait' );
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInWithCredential(credential).then((value)async{
        String? token="";
        if(!kIsWeb){
          FirebaseMessaging _fcm=FirebaseMessaging.instance;
          token=await _fcm.getToken();
        }
        final provider = Provider.of<UserDataProvider>(context, listen: false);
        Map<String,dynamic> data={
          'phone':provider.userData!.phone,
          'status':'Approved',
          'token':token,
          'firstName':provider.userData!.firstName,
          'lastName':provider.userData!.lastName,
          'profilePic':'',
          'fb':'',
          'following':[],
          'instagram':'',
          'youtube':'',
          'mastodon':'',
          'city':'',
          'country':'',
        };
        UserModel model=UserModel.fromMap(
            data,
            FirebaseAuth.instance.currentUser!.uid
        );
        provider.setUserData(model);
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(data);
        pr.close();
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MyProfile()), (Route<dynamic> route) => false);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const MyProfile()));

      }).onError((error, stackTrace) {
        pr.close();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: error.toString(),
        );
      });
    }
    else{
      String? token="";
      if(!kIsWeb){
        FirebaseMessaging _fcm=FirebaseMessaging.instance;
        token=await _fcm.getToken();
      }
      final provider = Provider.of<UserDataProvider>(context, listen: false);


      Map<String,dynamic> data={
        'phone':provider.userData!.phone,
        'status':'Approved',
        'token':token,
        'firstName':provider.userData!.firstName,
        'lastName':provider.userData!.lastName,
        'profilePic':'',
        'following':[],
        'fb':'',
        'instagram':'',
        'youtube':'',
        'mastodon':'',
        'city':'',
        'country':'',
      };
      UserModel model=UserModel.fromMap(
          data,
          FirebaseAuth.instance.currentUser!.uid
      );
      provider.setUserData(model);
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(data);
      pr.close();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const MyProfile()));

      //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MyProfile()), (Route<dynamic> route) => false);
    }

  }

  static Future<void> signIn(BuildContext context,PhoneAuthCredential credential)async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: 'Signing In' );

    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInWithCredential(credential).then((value)async{
        pr.close();
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) async{
          if (documentSnapshot.exists) {
            print("user exists");
            Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
            UserModel user=UserModel.fromMap(data,documentSnapshot.reference.id);
            print("user ${user.userId} ${user.status}");
            String? token="";

            if(!kIsWeb){
              FirebaseMessaging _fcm=FirebaseMessaging.instance;
              token=await _fcm.getToken();
            }
            print('fcm token else $token');
            FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
              'token':token,
            });
            final provider = Provider.of<UserDataProvider>(context, listen: false);
            provider.setUserData(user);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const MyProfile()));
          }
          else{
            print('Firebase auth id ${FirebaseAuth.instance.currentUser!.uid}');
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: 'No User In Database',
            );
          }

        });

      }).onError((error, stackTrace) {
        pr.close();
        CoolAlert.show(
          context: context,
          title: 'Login Error',
          type: CoolAlertType.error,
          text: error.toString(),
        );
      });
    }
    else{
      pr.close();
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) async{
        if (documentSnapshot.exists) {
          print("user exists");
          Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
          UserModel user=UserModel.fromMap(data,documentSnapshot.reference.id);
          print("user ${user.userId} ${user.status}");
          String? token="";
          if(!kIsWeb){
            FirebaseMessaging _fcm=FirebaseMessaging.instance;
            token=await _fcm.getToken();
          }
          print('fcm token else $token');
          FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
            'token':token,
          });
          final provider = Provider.of<UserDataProvider>(context, listen: false);
          provider.setUserData(user);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const MyProfile()));
        }




      });
    }


  }









}