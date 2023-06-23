import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel{
  String userId,phone,status,token;
  String firstName,lastName,profilePic;
  List followers,following;
  String fb,instagram,youtube,mastodon;
  String city, country;




  UserModel.fromMap(Map<String,dynamic> map,String key)
      : userId=key,
        phone = map['phone']??"",
        fb = map['fb']??"",
        city = map['city']??"",
        country = map['country']??"",
        youtube = map['youtube']??"",
        instagram = map['instagram']??"",
        mastodon = map['mastodon']??"",

        followers = map['followers']??[],
        following = map['following']??[],
        status = map['status']??"",
        firstName = map['firstName']??"",
        lastName = map['lastName']??"",
        profilePic = map['profilePic']??"",
        token = map['token']??"";



  UserModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}