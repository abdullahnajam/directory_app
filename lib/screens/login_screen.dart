import 'package:directory_app/screens/create_account.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_dailogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomAppBar(showSearchBar: true,),
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: Responsive.getWidth(context),
                  child: Column(
                    children: [
                      const SizedBox(height: 30,),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text('Login to your account',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),)
                      ),
                      const SizedBox(height: 30,),

                      Row(
                        children: [
                          Text('Phone number*',style: TextStyle(fontWeight: FontWeight.w500),),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        keyboardType: TextInputType.phone,
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
                          hintText: 'Enter your phone number',
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Wrap(

                        runAlignment: WrapAlignment.start,
                        alignment: WrapAlignment.start,
                        children: [
                          Text('To learn more, see  ',style: TextStyle(color: Colors.grey),),
                          Text('Terms of Service',style: TextStyle(color: primaryColor),),
                          Text(' and ',style: TextStyle(color: Colors.grey),),
                          Text('Privacy Policy.',style: TextStyle(color: primaryColor),),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Text('By continuing your mobile number, you agree to receive SMS for verification.',textAlign: TextAlign.left,),
                      const SizedBox(height: 20,),
                      Center(
                        child: InkWell(
                          onTap: (){
                            showOtpDialog(context,true);

                          },
                          child: Container(
                            height: 50,

                            width: MediaQuery.of(context).size.width*0.9,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(7)
                            ),
                            alignment: Alignment.center,
                            child: Text('Send Code',style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?',style: TextStyle(color: Colors.grey),),
                          InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const CreateAccount()));
                            },
                            child: Text(' Sign Up',style: TextStyle(color: primaryColor),),
                          )

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
