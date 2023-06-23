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

  void setCountry(String value) {
    userData!.country = value;
    notifyListeners();
  }

  void followUser(String value) {
    userData!.country = value;
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







}
