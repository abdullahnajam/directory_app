import 'package:directory_app/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

import '../utils/constants.dart';
import '../utils/responsive.dart';

Future<void> showOtpDialog(BuildContext context,bool login) async {

  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.7,
              padding: EdgeInsets.all(20),
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
                      decoration: BoxDecoration(
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
                                padding: EdgeInsets.all(10),
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
                              padding: EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: Icon(Icons.close,color: Colors.black,size: 20,),
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
                          SizedBox(height: 20,),
                          Text('Confirm the phone',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          SizedBox(height: 10,),
                          Text('Please input the 6-digit code we just send to +1 (***) *** 1234.',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),
                          SizedBox(height: 20,),
                          Text('Edit my mobile number',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.grey[700]),),

                          SizedBox(height: 40,),
                          Text('Verification code',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.grey[700]),),
                          SizedBox(height: 20,),
                          OtpTextField(
                            numberOfFields: 6,
                            fieldWidth: Responsive.isMobile(context)?38: 50,
                            borderColor: primaryColor,
                            //set to true to show as box or false to show as dash
                            showFieldAsBox: true,
                            //runs when a code is typed in
                            onCodeChanged: (String code) {
                              //handle validation or checks here
                            },
                            //runs when every textfield is filled
                            onSubmit: (String verificationCode)async{





                            }, // end onSubmit
                          ),
                          SizedBox(height: 20,),
                          Text('Didn’t get a code? Click to resend.',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.grey[700]),),
                          SizedBox(height: 20,),
                          Row(
                            children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){

                                      Navigator.pop(context);
                                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
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
                                    onTap: (){
                                      Navigator.pop(context);
                                      if(login){
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));
                                      }
                                      else{
                                        showSuccessDialog(context);
                                      }

                                      //

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
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
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: EdgeInsets.all(20),
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
                      decoration: BoxDecoration(
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
                                  padding: EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: Icon(Icons.close,color: Colors.black,size: 20,),
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
                          SizedBox(height: 20,),
                          Text('Add Email',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          SizedBox(height: 10,),
                          Text('Email',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          SizedBox(height: 10,),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
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
                          SizedBox(height: 20,),
                          Text('Visibility',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          SizedBox(height: 10,),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
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
                              hintText: 'Visibility',
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
                                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
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
                                    onTap: (){
                                      Navigator.pop(context);
                                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
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

Future<void> showAddPhoneDialog(BuildContext context) async {

  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: EdgeInsets.all(20),
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
                      decoration: BoxDecoration(
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
                                  padding: EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: Icon(Icons.close,color: Colors.black,size: 20,),
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
                          SizedBox(height: 20,),
                          Text('Add Phone Number',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          SizedBox(height: 10,),
                          Text('Phone Number',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          SizedBox(height: 10,),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
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
                              hintText: 'Phone Number',
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                          const SizedBox(height: 20,),
                          SizedBox(height: 20,),
                          Text('Visibility',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          SizedBox(height: 10,),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
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
                              hintText: 'Visibility',
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
                                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
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
                                    onTap: (){
                                      Navigator.pop(context);
                                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
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

  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.65,
              padding: EdgeInsets.all(20),
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
                      decoration: BoxDecoration(
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
                                  padding: EdgeInsets.fromLTRB(10,6,10,10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: Icon(Icons.add),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: Icon(Icons.close,color: Colors.black,size: 20,),
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
                          SizedBox(height: 20,),
                          Text('Add Link',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                          SizedBox(height: 10,),
                          Text('Link',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          SizedBox(height: 10,),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
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
                          SizedBox(height: 20,),
                          Text('Visibility',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                          SizedBox(height: 10,),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
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
                              hintText: 'Visibility',
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
                                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
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
                                    onTap: (){
                                      Navigator.pop(context);
                                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));

                                    },
                                    child: Container(
                                      height: 50,


                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
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
Future<void> showSuccessDialog(BuildContext context) async {


  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.4,
              padding: EdgeInsets.all(20),
              width: Responsive.getDailogWidth(context),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
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
                              padding: EdgeInsets.all(10),
                              child: Image.asset('assets/images/success.png',height: 25,)
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.only(top: 5,right: 10,bottom: 5),
                            child: InkWell(
                              child: Icon(Icons.close,color: Colors.black,size: 20,),
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
                        SizedBox(height: 20,),
                        Text('Success!',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                        SizedBox(height: 10,),
                        Text('Thank you account have been completed.',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                        SizedBox(height: 20,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));

                            },
                            child: Container(
                              height: 50,


                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              alignment: Alignment.center,
                              child: Row(
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