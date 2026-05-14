import 'package:flutter/material.dart';

enum UserProfileType {
  adolescente,
  gestante,
  tentante,
  menopausa,
}

class UserProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  int _age = 0;
  UserProfileType? _profile;

  String get name => _name;
  String get email => _email;
  int get age => _age;
  UserProfileType? get profile => _profile;

  void updateUserInfo({String? name, String? email, int? age}) {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (age != null) _age = age;
    notifyListeners();
  }

  void updateProfile(UserProfileType newProfile) {
    _profile = newProfile;
    notifyListeners();
  }

  String getProfileName() {
    switch (_profile) {
      case UserProfileType.adolescente:
        return "Adolescente";
      case UserProfileType.gestante:
        return "Gestante";
      case UserProfileType.tentante:
        return "Tentante";
      case UserProfileType.menopausa:
        return "Menopausa";
      default:
        return "Não definido";
    }
  }
}
