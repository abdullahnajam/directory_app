import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_list_picker/country_list_picker.dart' as picker;
import 'package:country_state_city/country_state_city.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:directory_app/api/auth_api.dart';
import 'package:directory_app/screens/homepage.dart';
import 'package:directory_app/screens/my_profile.dart';
import 'package:directory_app/screens/profile.dart';
import 'package:directory_app/widgets/profile_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../model/user_model.dart';
import '../provider/user_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';



Future<void> showOtpDialog(BuildContext context,int intent,String verificationId, var data) async {
  String otp='';
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.6,
              padding: const EdgeInsets.all(20),
              width: Responsive.getOtpDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 40,

                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)
                                ),
                                child: Image.asset('assets/images/lockIcon.png',height: 15,),
                              )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Confirm the phone',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          const SizedBox(height: 10,),
                          const Text('Please input the 6-digit code we just send to your number.',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),
                          //SizedBox(height: 20,),
                          //Text('Edit my mobile number',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.grey[700]),),

                          const SizedBox(height: 40,),
                          Text('Verification code',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.grey[700]),),
                          const SizedBox(height: 20,),
                          OtpTextField(
                            numberOfFields: 6,
                            fieldWidth: Responsive.isMobile(context)?38: 50,
                            borderColor: primaryColor,
                            //set to true to show as box or false to show as dash
                            showFieldAsBox: true,
                            //runs when a code is typed in
                            onCodeChanged: (String code) {
                              otp=code;
                            },
                            //runs when every textfield is filled
                            onSubmit: (String verificationCode)async{
                              print('verification code $verificationCode');

                              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: verificationCode,
                              );

                              if(intent==2){
                                AuthenticationApi.register(context,credential);
                              }
                              else if(intent==1){
                                AuthenticationApi.signIn(context,credential);
                              }
                              else if(intent==3){
                                await FirebaseAuth.instance.currentUser!.updatePhoneNumber(credential).then((value)async{
                                  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                    'phone':FirebaseAuth.instance.currentUser!.phoneNumber,
                                    'visibility':true
                                  });
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  provider.setPhone(FirebaseAuth.instance.currentUser!.phoneNumber!);
                                  Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: 'update email error ${error.toString()}',
                                  );
                                });
                              }
                              else if(intent==4){
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('phone').add({
                                  'name':data['name'],
                                  'visibility':data['visibility']
                                });
                                Navigator.pop(context);
                              }
                              else if(intent==5){
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('phone').doc(data['id']).update({
                                  'name':data['name'],
                                  'visibility':data['visibility']
                                });
                                Navigator.pop(context);
                              }


                            }, // end onSubmit// end onSubmit
                          ),
                          const SizedBox(height: 20,),
                          Text('Didn’t get a code? Click to resend.',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.grey[700]),),
                          const SizedBox(height: 20,),
                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){

                                      Navigator.pop(context);

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Cancel',style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async{
                                      print('$otp $intent');
                                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: otp,
                                      );
                                      print(credential);
                                      if(intent==2){
                                        AuthenticationApi.register(context,credential);
                                      }
                                      else if(intent==1){
                                        AuthenticationApi.signIn(context,credential);
                                      }
                                      else if(intent==3){
                                        await FirebaseAuth.instance.currentUser!.updatePhoneNumber(credential).then((value)async{
                                          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                            'phone':FirebaseAuth.instance.currentUser!.phoneNumber,
                                            'visibility':true
                                          });
                                          final provider = Provider.of<UserDataProvider>(context, listen: false);
                                          provider.setPhone(FirebaseAuth.instance.currentUser!.phoneNumber!);
                                          Navigator.pop(context);
                                        }).onError((error, stackTrace){
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: 'update email error ${error.toString()}',
                                          );
                                        });
                                      }
                                      else if(intent==4){
                                        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                                            .collection('phone').add({
                                          'name':data['name'],
                                          'visibility':data['visibility']
                                        });
                                        Navigator.pop(context);
                                      }
                                      else if(intent==5){
                                        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                                            .collection('phone').doc(data['id']).update({
                                          'name':data['name'],
                                          'visibility':data['visibility']
                                        });
                                        Navigator.pop(context);
                                      }

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Confirm',style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showAddEmailDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  var _controller=TextEditingController();
  String visibility='Yes';
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                height: 40,

                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: const Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Add Email',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          const SizedBox(height: 10,),
                          const Text('Email',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          TextFormField(
                            controller: _controller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.5
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 0.5,
                                ),
                              ),
                              hintText: 'Email',
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                          const SizedBox(height: 20,),
                          const SizedBox(height: 20,),
                          const Text('Visibility',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(color: Colors.grey.shade300)
                            ),
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: DropdownButton<String>(
                              value: visibility,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(

                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  visibility = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Cancel',style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async{
                                      await FirebaseAuth.instance.currentUser!.updateEmail(_controller.text).then((value)async{
                                        await FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value)async{
                                          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('emails').doc(FirebaseAuth.instance.currentUser!.uid).set({
                                            'visibility':visibility
                                          });
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.info,
                                            text: 'A verification has been sent. Please verify and login again',
                                          );
                                        }).onError((error, stackTrace){
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: 'verification error ${error.toString()}',
                                          );
                                        });
                                      }).onError((error, stackTrace){
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: 'update email error ${error.toString()}',
                                        );
                                      });


                                      //Navigator.pop(context);

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Save',style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showEditEmailDialog(BuildContext context,String email,String access) async {
  final _formKey = GlobalKey<FormState>();
  var _controller=TextEditingController();
  _controller.text=email;
  String visibility=access;
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                height: 40,

                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: const Icon(Icons.edit_outlined),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Edit Email',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          const SizedBox(height: 10,),
                          const Text('Email',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                flex:7,
                                child: TextFormField(
                                  controller: _controller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },

                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: 'Email',
                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex:3,
                                child: InkWell(
                                  onTap: ()async{
                                    await FirebaseAuth.instance.currentUser!.updateEmail(_controller.text).then((value)async{
                                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('emails').doc(FirebaseAuth.instance.currentUser!.uid).delete();
                                      Navigator.pop(context);
                                    }).onError((error, stackTrace){
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: 'update email error ${error.toString()}',
                                      );
                                    });

                                  },
                                  child: Container(
                                    height: 50,


                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(7)
                                    ),
                                    alignment: Alignment.center,
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.delete,color: Colors.red,),
                                        SizedBox(width: 8,),
                                        Text('Delete',style: TextStyle(color: Colors.red),)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20,),
                          const SizedBox(height: 20,),
                          const Text('Visibility',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(color: Colors.grey.shade300)
                            ),
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: DropdownButton<String>(
                              value: visibility,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(

                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  visibility = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Cancel',style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async{
                                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('emails').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                        'visibility':visibility
                                      });
                                      if(_controller.text!=email){
                                        await FirebaseAuth.instance.currentUser!.updateEmail(_controller.text).then((value)async{
                                          await FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value){
                                            CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.info,
                                              text: 'A verification has been sent',
                                            );
                                          }).onError((error, stackTrace){
                                            CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text: 'verification error ${error.toString()}',
                                            );
                                          });
                                        }).onError((error, stackTrace){
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: 'update email error ${error.toString()}',
                                          );
                                        });
                                      }
                                      else{
                                        Navigator.pop(context);
                                      }





                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Update',style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showEditLinkDialog(BuildContext context,String link,String id) async {
  final _formKey = GlobalKey<FormState>();
  var _controller=TextEditingController();
  _controller.text=link;
  String visibility='Yes';
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                height: 40,

                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: const Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Edit Email',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          const SizedBox(height: 10,),
                          const Text('Email',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),

                          Row(
                            children: [
                              Expanded(
                                flex:7,
                                child: TextFormField(
                                  controller: _controller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },

                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: 'Link',
                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex:3,
                                child: InkWell(
                                  onTap: ()async{
                                    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('links').doc(id).delete();
                                    Navigator.pop(context);

                                  },
                                  child: Container(
                                    height: 50,


                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(7)
                                    ),
                                    alignment: Alignment.center,
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.delete,color: Colors.red,),
                                        SizedBox(width: 8,),
                                        Text('Delete',style: TextStyle(color: Colors.red),)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20,),
                          const SizedBox(height: 20,),
                          const Text('Visibility',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(color: Colors.grey.shade300)
                            ),
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: DropdownButton<String>(
                              value: visibility,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(

                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  visibility = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Cancel',style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async{

                                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                                          .collection('links').doc(id).update({
                                        "name":_controller.text,
                                        "visibility":visibility,
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Update',style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showAddPhoneDialog(BuildContext context) async {

  var phoneController=TextEditingController();
  String phone='+92';
  final _formKey = GlobalKey<FormState>();
  String visibility='Yes';
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                height: 40,

                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: const Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Add Phone Number',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          const SizedBox(height: 10,),
                          const Text('Phone Number',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                width: 70,
                                child: picker.CountryListPicker(
                                  isShowDownIcon:false,
                                  isShowInputField: false,
                                  isShowCountryName: false,
                                  border: InputBorder.none,
                                  flagSize: Size (30,30),
                                  initialCountry: picker.Countries.United_States,
                                  diallingCodeStyle: TextStyle(fontSize: 15),
                                  onCountryChanged: ((value) {
                                    print('${value.dialing_code}');
                                    phone='${value.dialing_code}';
                                  }),
                                  /*onChanged: (value) {
                                  phone='$value';
                                },*/
                                ),
                              ),
                              Expanded(
                                child:  TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  controller: phoneController,

                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: 'Enter your phone number',
                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20,),
                          const SizedBox(height: 20,),
                          const Text('Visibility',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(color: Colors.grey.shade300)
                            ),
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: DropdownButton<String>(
                              value: visibility,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(

                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  visibility = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Cancel',style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async{
                                      bool exists=false;
                                      final provider = Provider.of<UserDataProvider>(context, listen: false);
                                      if(provider.userData!.phone=='$phone${phoneController.text.trim()}'){
                                        exists=true;
                                      }

                                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                                          .collection('phone').where('name',isEqualTo: '$phone${phoneController.text.trim()}').get().then((QuerySnapshot querySnapshot) {
                                        querySnapshot.docs.forEach((doc) {
                                          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                                          exists=true;
                                        });
                                      });
                                      if(!exists){
                                        AuthenticationApi authApi=AuthenticationApi();
                                        Map<String,dynamic> data={
                                          'name':'$phone${phoneController.text.trim()}',
                                          'visibility':visibility,
                                        };
                                        authApi. verifyPhoneNumber('$phone${phoneController.text.trim()}', context, 4,data);
                                      }
                                      else{
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: 'Phone Number already added',
                                        );
                                      }


                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Save',style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showEditMainPhoneDialog(BuildContext context,String phone) async {
  var phoneController=TextEditingController();
  String phone='+92';
  final _formKey = GlobalKey<FormState>();
  String visibility='Yes';
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                height: 40,

                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: const Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Add Phone Number',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          const SizedBox(height: 10,),
                          const Text('Phone Number',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                width: 70,
                                child: picker.CountryListPicker(
                                  isShowDownIcon:false,
                                  isShowInputField: false,
                                  isShowCountryName: false,
                                  border: InputBorder.none,
                                  flagSize: Size (30,30),
                                  initialCountry: picker.Countries.United_States,
                                  diallingCodeStyle: TextStyle(fontSize: 15),
                                  onCountryChanged: ((value) {
                                    print('${value.dialing_code}');
                                    phone='${value.dialing_code}';
                                  }),
                                  /*onChanged: (value) {
                                  phone='$value';
                                },*/
                                ),
                              ),
                              Expanded(
                                child:  TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  controller: phoneController,

                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: 'Enter your phone number',
                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20,),
                          const SizedBox(height: 20,),
                          const Text('Visibility',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(color: Colors.grey.shade300)
                            ),
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: DropdownButton<String>(
                              value: visibility,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(

                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  visibility = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Cancel',style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async{
                                      AuthenticationApi authApi=AuthenticationApi();
                                      authApi. verifyPhoneNumber('$phone${phoneController.text.trim()}', context, 3,null);

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Save',style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
/*
Future<void> showAvailableContactsDialog(BuildContext context,List<UserModel> users,List<String> invites) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.9,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child:Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )
                    ),
                    child: Stack(
                      children: [
                        */
/*Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              height: 40,

                              child: Container(
                                padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)
                                ),
                                child: const Icon(Icons.add),
                              )
                          ),
                        ),*//*

                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                            child: InkWell(
                              child: const Icon(Icons.close,color: Colors.black,size: 20,),
                              onTap: ()=>Navigator.pop(context),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        const Text('We found the crew!',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                        const SizedBox(height: 10,),
                        const Text('We found your friends in the Internet Phonebook, let\'s follow them.',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                        const SizedBox(height: 10,),
                        Container(
                          height: MediaQuery.of(context).size.height*0.3,
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (BuildContext context,int index){
                              return ListTile(
                                leading: ProfilePicture(url: users[index].profilePic,height: 30,width: 30,),
                                title: Text('${users[index].firstName} ${users[index].lastName}'),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: ()async{
                              final provider = Provider.of<UserDataProvider>(context, listen: false);

                              for(int i= 0;i<users.length;i++){
                                if(!provider.userData!.following.contains(users[i].userId)){
                                  provider.followUser(users[i].userId);
                                }

                              }
                              showInviteContantsDialog(context, invites);

                            },
                            child: Container(
                              height: 50,


                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text('Follow',style: TextStyle(color: Colors.white),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,


                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text('Cancel',style: TextStyle(color: Colors.black),)
                                ],
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  )



                ],
              ),
            ),
          );
        },
      );
    },
  );
}
*/

/*Future<void> showInviteContantsDialog(BuildContext context,List<String> invites) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.9,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child:Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              height: 40,

                              child: Container(
                                padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)
                                ),
                                child: const Icon(Icons.person_add_alt_1),
                              )
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                            child: InkWell(
                              child: const Icon(Icons.close,color: Colors.black,size: 20,),
                              onTap: ()=>Navigator.pop(context),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        const Text('Invite your contacts',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                        const SizedBox(height: 10,),
                        const Text('Invite a contact on your phone to always have up-to-date phone email, links and social media.',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                        const SizedBox(height: 10,),
                        Container(
                          height: MediaQuery.of(context).size.height*0.3,
                          child: ListView.builder(
                            itemCount: invites.length,
                            itemBuilder: (BuildContext context,int index){
                              return ListTile(

                                title: Text(invites[index]),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: ()async{
                               await sendSMS(message: 'https://directorywebsite-v6.web.app/', recipients: invites).then((value){

                              })
                                  .catchError((onError) {
                                print(onError);
                              });


                            },
                            child: Container(
                              height: 50,


                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text('Invite',style: TextStyle(color: Colors.white),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,


                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text('Cancel',style: TextStyle(color: Colors.black),)
                                ],
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  )



                ],
              ),
            ),
          );
        },
      );
    },
  );
}*/
Future<void> showEditPhoneDialog(BuildContext context,Map<String,dynamic> data) async {
  var phoneController=TextEditingController();
  String phone='+92';
  final _formKey = GlobalKey<FormState>();
  String visibility=data['visibility'];
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                height: 40,

                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: const Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Add Phone Number',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          const SizedBox(height: 10,),
                          const Text('Phone Number',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                flex:7,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 70,
                                      child: picker.CountryListPicker(
                                        isShowDownIcon:false,
                                        isShowInputField: false,
                                        isShowCountryName: false,
                                        border: InputBorder.none,
                                        flagSize: Size (30,30),
                                        initialCountry: picker.Countries.United_States,
                                        diallingCodeStyle: TextStyle(fontSize: 15),
                                        onCountryChanged: ((value) {
                                          print('${value.dialing_code}');
                                          phone='${value.dialing_code}';
                                        }),
                                        /*onChanged: (value) {
                                  phone='$value';
                                },*/
                                      ),
                                    ),
                                    Expanded(
                                      child:  TextFormField(
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        controller: phoneController,

                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(15),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(7.0),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 0.5
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(7.0),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.5,
                                            ),
                                          ),
                                          hintText: 'Enter your phone number',
                                          // If  you are using latest version of flutter then lable text and hint text shown like this
                                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex:3,
                                child: InkWell(
                                  onTap: ()async{
                                    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('phone').doc(data['id']).delete();
                                    Navigator.pop(context);

                                  },
                                  child: Container(
                                    height: 50,


                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(7)
                                    ),
                                    alignment: Alignment.center,
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.delete,color: Colors.red,),
                                        SizedBox(width: 8,),
                                        Text('Delete',style: TextStyle(color: Colors.red),)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20,),
                          const SizedBox(height: 20,),
                          const Text('Visibility',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(color: Colors.grey.shade300)
                            ),
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: DropdownButton<String>(
                              value: visibility,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(

                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  visibility = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Cancel',style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async{
                                      AuthenticationApi authApi=AuthenticationApi();
                                      Map<String,dynamic> phoneData={
                                        'id':data['id'],
                                        'name':'$phone${phoneController.text.trim()}',
                                        'visibility':visibility,
                                      };
                                      authApi. verifyPhoneNumber('$phone${phoneController.text.trim()}', context, 5,phoneData);

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Save',style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
Future<void> showReportDialog(BuildContext context) async {

  var _reportController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.5,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                height: 40,

                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: const Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Send Report',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          const SizedBox(height: 10,),
                          const Text('Report',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          TextFormField(
                            maxLines: 5,
                            minLines: 5,
                            controller: _reportController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.5
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 0.5,
                                ),
                              ),
                              hintText: 'Write your complain here',
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                          const SizedBox(height: 20,),

                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Cancel',style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async{
                                      await FirebaseFirestore.instance.collection('reports').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                        'userId':FirebaseAuth.instance.currentUser!=null?FirebaseAuth.instance.currentUser!.uid:"",
                                        'report':_reportController.text
                                      });

                                      Navigator.pop(context);

                                      

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Send',style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
Future<void> showAddCityCountryDialog(BuildContext context) async {
  List countries = await getAllCountries();
  List cities = await getAllCities();
  String countryCode='';
  var _countryController=TextEditingController();
  var _cityController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                height: 40,

                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: const Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Add City/Country',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          const SizedBox(height: 10,),
                          const Text('Country',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Container(
                            height: 50,
                            child: TypeAheadField(

                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _countryController,

                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: 'Enter Country',
                                  // If  you are using latest version of flutter then lable text and hint text shown like this
                                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                              noItemsFoundBuilder: (context) {
                                return const ListTile(
                                  leading: Icon(Icons.error),
                                  title: Text('No Data Found'),
                                );
                              },
                              suggestionsCallback: (pattern) async {

                                List<Country> search=[];


                                countries.forEach((element) {
                                  if (element.name.toString().toLowerCase().contains(pattern.toLowerCase()))
                                    search.add(element);
                                });

                                return search;
                              },
                              itemBuilder: (context, Country suggestion) {
                                return ListTile(
                                  leading: const Icon(Icons.place_outlined),
                                  title: Text(suggestion.name),
                                );
                              },
                              onSuggestionSelected: (Country suggestion)async {
                                _countryController.text=suggestion.name;
                                countryCode=suggestion.isoCode;
                                cities=await getCountryCities(suggestion.isoCode);


                              },
                            ),
                          ),
                          const SizedBox(height: 20,),
                          const Text('City',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Container(
                            height: 50,
                            child: TypeAheadField(

                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _cityController,

                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: 'Enter City',
                                  // If  you are using latest version of flutter then lable text and hint text shown like this
                                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                              noItemsFoundBuilder: (context) {
                                return const ListTile(
                                  leading: Icon(Icons.error),
                                  title: Text('No Data Found'),
                                );
                              },
                              suggestionsCallback: (pattern) async {

                                List<City> search=[];


                                cities.forEach((element) {
                                  if (element.name.toString().toLowerCase().contains(pattern.toLowerCase()))
                                    search.add(element);
                                });

                                return search;
                              },
                              itemBuilder: (context, City suggestion) {
                                return ListTile(
                                  leading: const Icon(Icons.place_outlined),
                                  title: Text(suggestion.name),
                                );
                              },
                              onSuggestionSelected: (City suggestion) {
                                _cityController.text=suggestion.name;


                              },
                            ),
                          ),

                          const SizedBox(height: 20,),

                          const SizedBox(height: 20,),
                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Cancel',style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async{
                                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                        'city':_cityController.text,
                                        'country':_countryController.text
                                      });
                                      final provider = Provider.of<UserDataProvider>(context, listen: false);
                                      provider.setCountry(_countryController.text);
                                      provider.setCity(_cityController.text);
                                      Navigator.pop(context);

                                      

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Save',style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showEditCityCountryDialog(BuildContext context) async {
  List countries = await getAllCountries();
  List cities = await getAllCities();
  String countryCode='';
  var _countryController=TextEditingController();
  var _cityController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                height: 40,

                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: const Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Add City/Country',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          const SizedBox(height: 10,),
                          const Text('Country',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Container(
                            height: 50,
                            child: TypeAheadField(

                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _countryController,

                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: 'Enter Country',
                                  // If  you are using latest version of flutter then lable text and hint text shown like this
                                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                              noItemsFoundBuilder: (context) {
                                return const ListTile(
                                  leading: Icon(Icons.error),
                                  title: Text('No Data Found'),
                                );
                              },
                              suggestionsCallback: (pattern) async {

                                List<Country> search=[];


                                countries.forEach((element) {
                                  if (element.name.toString().toLowerCase().contains(pattern.toLowerCase()))
                                    search.add(element);
                                });

                                return search;
                              },
                              itemBuilder: (context, Country suggestion) {
                                return ListTile(
                                  leading: const Icon(Icons.place_outlined),
                                  title: Text(suggestion.name),
                                );
                              },
                              onSuggestionSelected: (Country suggestion)async {
                                _countryController.text=suggestion.name;
                                countryCode=suggestion.isoCode;
                                cities=await getCountryCities(suggestion.isoCode);


                              },
                            ),
                          ),
                          const SizedBox(height: 20,),
                          const Text('City',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Container(
                            height: 50,
                            child: TypeAheadField(

                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _cityController,

                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: 'Enter City',
                                  // If  you are using latest version of flutter then lable text and hint text shown like this
                                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                              noItemsFoundBuilder: (context) {
                                return const ListTile(
                                  leading: Icon(Icons.error),
                                  title: Text('No Data Found'),
                                );
                              },
                              suggestionsCallback: (pattern) async {

                                List<City> search=[];


                                cities.forEach((element) {
                                  if (element.name.toString().toLowerCase().contains(pattern.toLowerCase()))
                                    search.add(element);
                                });

                                return search;
                              },
                              itemBuilder: (context, City suggestion) {
                                return ListTile(
                                  leading: const Icon(Icons.place_outlined),
                                  title: Text(suggestion.name),
                                );
                              },
                              onSuggestionSelected: (City suggestion) {
                                _cityController.text=suggestion.name;


                              },
                            ),
                          ),

                          const SizedBox(height: 20,),

                          const SizedBox(height: 20,),
                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){

                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Cancel',style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async{
                                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                        'city':_cityController.text,
                                        'country':_countryController.text
                                      });
                                      final provider = Provider.of<UserDataProvider>(context, listen: false);
                                      provider.setCountry(_countryController.text);
                                      provider.setCity(_cityController.text);
                                      Navigator.pop(context);



                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Save',style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showAddSocialMediaDialog(BuildContext context,int socialMedia,String title) async {
  //1: insta ; 2: fb ; 3: mastedon ; 4: youtube

  var _controller=TextEditingController();

  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                height: 40,

                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: const Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          Text('Add $title url',style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          const SizedBox(height: 10,),
                          Text('$title',style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          TextFormField(
                            controller: _controller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.5
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 0.5,
                                ),
                              ),
                              hintText: 'Enter $title',
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),

                          const SizedBox(height: 20,),
                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Cancel',style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async{
                                      String key='';
                                      if(socialMedia==1){
                                        key='instagram';
                                      }
                                      else if(socialMedia==2){
                                      key='fb';

                                      }
                                      else if(socialMedia==3){
                                      key='mastodon';
                                      }
                                      else if(socialMedia==4){
                                      key='youtube';

                                      }
                                      /*await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                        key:_controller.text
                                      });
                                      final provider = Provider.of<UserDataProvider>(context, listen: false);
                                      if(socialMedia==1){
                                        provider.setInstagram(_controller.text);
                                      }
                                      else if(socialMedia==2){
                                        provider.setFacebook(_controller.text);
                                      }
                                      else if(socialMedia==3){
                                        provider.setMastedon(_controller.text);
                                      }
                                      else if(socialMedia==4){
                                        provider.setYoutube(_controller.text);
                                      }*/


                                      //Navigator.pop(context);

                                      

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Save',style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showAddLinkDialog(BuildContext context) async {
  String visibility='Yes';
  var _controller=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                height: 40,

                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: const Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Add Link',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          const SizedBox(height: 10,),
                          const Text('Link',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          TextFormField(
                            controller: _controller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.5
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 0.5,
                                ),
                              ),
                              hintText: 'Link',
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                          const SizedBox(height: 20,),
                          const SizedBox(height: 20,),
                          const Text('Visibility',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(color: Colors.grey.shade300)
                            ),
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: DropdownButton<String>(
                              value: visibility,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(

                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  visibility = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Cancel',style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async{
                                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('links').add({
                                        'name':_controller.text,
                                        'visibility':visibility
                                      });
                                      Navigator.pop(context);


                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text('Save',style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}


Future<void> showCountryDialog(BuildContext context, int intent)async{
  List<Country> countries = await getAllCountries();
  return showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context,setState){
            return Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              insetAnimationDuration: const Duration(seconds: 1),
              insetAnimationCurve: Curves.fastOutSlowIn,
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.7,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      margin: const EdgeInsets.all(10),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(


                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: 'Search',
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        noItemsFoundBuilder: (context) {
                          return const ListTile(
                            leading: Icon(Icons.error),
                            title: Text('No Data Found'),
                          );
                        },
                        suggestionsCallback: (pattern) async {

                          List<Country> search=[];


                          countries.forEach((element) {
                            if (element.name.contains(pattern))
                              search.add(element);
                          });

                          return search;
                        },
                        itemBuilder: (context, Country suggestion) {
                          return ListTile(
                            title: Text(suggestion.name),
                          );
                        },
                        onSuggestionSelected: (Country suggestion) {
                          //_countryController.text=suggestion.name;

                          Navigator.pop(context);
                          //showCityDialog(suggestion,departure);

                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: countries.length,
                        itemBuilder: (BuildContext context,int index){
                          return ListTile(
                            onTap: (){

                            },
                            title: Text(countries[index].name),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
  );
}

/*Future<void> showCityDialog(BuildContext context,Country country){
  return null;
  *//*return showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context,setState){
            return Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              insetAnimationDuration: const Duration(seconds: 1),
              insetAnimationCurve: Curves.fastOutSlowIn,
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.7,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      margin: const EdgeInsets.all(10),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(


                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: 'Search',
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        noItemsFoundBuilder: (context) {
                          return ListTile(
                            leading: Icon(Icons.error),
                            title: Text('No Data Found'),
                          );
                        },
                        suggestionsCallback: (pattern) async {

                          List<City> search=[];
                          await FirebaseFirestore.instance
                              .collection('cities').doc(city.id).collection('neighborhood').orderBy('name',descending: false)
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.forEach((doc) {
                              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                              CityModel model=CityModel.fromMap(data, doc.reference.id);
                              if (model.name.contains(pattern))
                                search.add(model);
                            });
                          });

                          return search;
                        },
                        itemBuilder: (context, City suggestion) {
                          return ListTile(
                            leading: const Icon(Icons.place_outlined),
                            title: Text(suggestion.name.tr()),
                          );
                        },
                        onSuggestionSelected: (City suggestion) {
                          final provider = Provider.of<CreateRideProvider>(context, listen: false);
                          setState(() {
                            if(departure){
                              provider.setDeparture('${city.name}:${suggestion.name}');
                              _departureController.text='${suggestion.name.toString().tr()}, ${city.name.tr()}';
                            }
                            else{
                              provider.setArrival('${city.name}:${suggestion.name}');
                              _arrivalController.text='${suggestion.name.toString().tr()}, ${city.name.tr()}';
                            }
                          });
                          Navigator.pop(context);

                        },
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('cities').doc(city.id).collection('neighborhood').orderBy('name',descending: false).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  const Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                ],
                              ),
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data!.size==0){
                            return Center(
                                child: Text('No Data Found'.tr(),style: TextStyle(color: Colors.black))
                            );

                          }

                          return ListView(
                            shrinkWrap: true,
                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                              return Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: ListTile(
                                  onTap: (){
                                    final provider = Provider.of<CreateRideProvider>(context, listen: false);

                                    setState(() {
                                      if(departure){

                                        _departureController.text='${data['name'].toString().tr()}, ${city.name.tr()}';
                                        provider.setDeparture('${city.name}:${data['name']}');
                                      }
                                      else{
                                        provider.setArrival('${city.name}:${data['name']}');
                                        _arrivalController.text='${data['name'].toString().tr()}, ${city.name.tr()}';
                                      }
                                    });
                                    Navigator.pop(context);
                                  },
                                  leading: const Icon(Icons.place_outlined),
                                  title: Text('${data['name']}'.tr(),style: const TextStyle(color: Colors.black),),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
  );*//*
}*/

Future<void> showSuccessDialog(BuildContext context) async {


  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.4,
              padding: const EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset('assets/images/success.png',height: 25,)
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                            child: InkWell(
                              child: const Icon(Icons.close,color: Colors.black,size: 20,),
                              onTap: ()=>Navigator.pop(context),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        const Text('Success!',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                        const SizedBox(height: 10,),
                        const Text('Thank you account have been completed.',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                        const SizedBox(height: 20,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Homepage()));

                            },
                            child: Container(
                              height: 50,


                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text('Go to Homepage',style: TextStyle(color: Colors.white),)
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  )



                ],
              ),
            ),
          );
        },
      );
    },
  );
}