import 'package:cool_alert/cool_alert.dart';
import 'package:directory_app/screens/auth/create_account.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../api/auth_api.dart';
import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_dailogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String phone='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomAppBar(showSearchBar: true,),
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: Responsive.getWidth(context),
                    child: Column(
                      children: [
                        const SizedBox(height: 30,),
                        const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Login to your account',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),)
                        ),
                        const SizedBox(height: 30,),

                        const Row(
                          children: [
                            Text('Phone number*',style: TextStyle(fontWeight: FontWeight.w500),),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        InternationalPhoneNumberInput(
                          onInputChanged: (value){
                            phone=value.phoneNumber!;
                            print(phone);
                          },

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          //countries: ["JO",'PK'],
                          //controller: _phoneController,
                          inputDecoration: InputDecoration(
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

                        const SizedBox(height: 20,),
                        const Wrap(

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
                        const Text('By continuing your mobile number, you agree to receive SMS for verification.',textAlign: TextAlign.left,),
                        const SizedBox(height: 20,),
                        Center(
                          child: InkWell(
                            onTap: ()async{
                              if(_formKey.currentState!.validate()){
                                final ProgressDialog pr = ProgressDialog(context: context);
                                pr.show(max: 100, msg: 'Please Wait',barrierDismissible: true);
                                await AuthenticationApi.login(phone).then((value){
                                  pr.close();
                                  if(value){
                                    AuthenticationApi authApi=AuthenticationApi();
                                    authApi.verifyPhoneNumber(phone, context, 1);
                                  }
                                  else{
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.error,
                                      text: 'User does not exists',
                                    );
                                  }
                                }).onError((error, stackTrace) {
                                  pr.close();
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });

                              }

                            },
                            child: Container(
                              height: 50,

                              width: MediaQuery.of(context).size.width*0.9,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              alignment: Alignment.center,
                              child: const Text('Send Code',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?',style: TextStyle(color: Colors.grey),),
                            InkWell(
                              onTap: (){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const CreateAccount()));
                              },
                              child: const Text(' Sign Up',style: TextStyle(color: primaryColor),),
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
      ),
    );
  }
}
