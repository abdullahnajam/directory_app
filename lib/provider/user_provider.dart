import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/user_model.dart';

class UserDataProvider extends ChangeNotifier {

  UserModel? userData;

  void setUserData(UserModel user) {
    this.userData = user;
    notifyListeners();
  }

  void setImage(String value) {
    userData!.profilePic = value;
    notifyListeners();
  }
  void setPhone(String value) {
    userData!.phone = value;
    notifyListeners();
  }

  void setCountry(String value) {
    userData!.country = value;
    notifyListeners();
  }

  void followUser(String value)async{

    userData!.following.add(value);
    await FirebaseFirestore.instance.collection('users').doc(userData!.userId).update({
      "following":userData!.following,
    });
    notifyListeners();
  }

  void unFollowUser(String value)async{

    userData!.following.remove(value);
    await FirebaseFirestore.instance.collection('users').doc(userData!.userId).update({
      "following":userData!.following,
    });
    notifyListeners();
  }

  void setCity(String value) {
    userData!.city = value;
    notifyListeners();
  }

  void setFirstName(String value) {
    userData!.firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    userData!.lastName = value;
    notifyListeners();
  }

  void setInstagram(String value) {
    userData!.instagram = value;
    notifyListeners();
  }

  void setFacebook(String value) {
    userData!.fb = value;
    notifyListeners();
  }

  void setMastedon(String value) {
    userData!.mastodon = value;
    notifyListeners();
  }

  void setYoutube(String value) {
    userData!.youtube = value;
    notifyListeners();
  }







}
