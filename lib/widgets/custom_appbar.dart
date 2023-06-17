import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/logo.png',height: 50,fit: BoxFit.cover,),
        if(kIsWeb)
          Row(
            children: [
              
            ],
          )
        else
          InkWell(
            onTap: (){

            },
            child: Image.asset('assets/images/menu.png',height: 50,fit: BoxFit.cover,),
          )
      ],
    );
  }
}
