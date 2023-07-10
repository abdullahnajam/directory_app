import 'package:directory_app/utils/constants.dart';
import 'package:directory_app/widgets/profile_image.dart';
import 'package:flutter/material.dart';

class SocialIcon extends StatelessWidget {
  String name,url;


  SocialIcon({required this.name,required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: Stack(
        children: [
          ProfilePicture(url: url,height: 25,),
          Positioned(
            bottom: 0,
            right: 5,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: primaryColor,
              child: Image.asset('assets/images/$name.png',height: 8,color: Colors.white,),
            ),
          )
        ],
      ),

    );

  }
}
