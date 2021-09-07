import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:news_app/model/httpExceptionApi.dart';
import '../Configration/Config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTime;
  String _userName = "";
  String _email;
  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userName {
    return this._userName;
  }

  String get userId {
    return _userId;
  }

  String get email {
    return _email;
  }

  Future<void> _authenticate(String email, String password, String urlSegment,
      String userName, String phoneNumber) async {
    Map<String, dynamic> request_body = {
      Config.authEmail: email,
      Config.authPassword: password,
      Config.rSecureToken: true,
    };
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=${Config.webApiKey}";
    try {
      var res =
          await http.post(Uri.parse(url), body: json.encode(request_body));
      final responseData = json.decode(res.body);
      if (responseData['error'] != null) {
        // create model of http exception
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _email = responseData['email'];

      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      if (urlSegment == Config.signUpSegment) {
        var url2 =
            "https://news-app-4e352-default-rtdb.firebaseio.com/users/$_userId.json";

        try {
          var res = await http.post(Uri.parse(url2),
              body: json.encode({
                Config.userName: userName,
                Config.phoneNumber: phoneNumber,
                Config.email: email,
              }));
        } catch (e) {}
      }
      //___________________________REALTIME CODE _______________________________________
      var realtime_url =
          "https://news-app-4e352-default-rtdb.firebaseio.com/users/$_userId.json";
      try {
        var realTime_res = await http.get(Uri.parse(realtime_url));
        final extracted_realTime =
            json.decode(realTime_res.body) as Map<String, dynamic>;

        extracted_realTime.forEach((key, value) {
          _userName = value['username'];
        });
      } catch (e) {}
      //___________________________REALTIME CODE _______________________________________
      notifyListeners();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userData = json.encode({
        Config.tokenP: _token,
        Config.userIdP: _userId,
        Config.emailP: _email,
        'username': _userName,
        Config.expiryDateP: _expiryDate.toIso8601String(),
      });
      prefs.setString(Config.userDataPrefName, userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> login(String email, String password) {
    return this._authenticate(email, password, Config.loginSegment, "", "");
  }

  Future<void> signUp(
      String email, String password, String username, String phoneNumber) {
    return _authenticate(
        email, password, Config.signUpSegment, username, phoneNumber);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString(Config.userDataPrefName);
    if (!prefs.containsKey(Config.userDataPrefName)) {
      return false;
    } else {
      final Map<String, Object> extractedData =
          json.decode(prefs.getString(Config.userDataPrefName))
              as Map<String, Object>;
      final expiryDate = DateTime.parse(extractedData[Config.expiryDateP]);
      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      } else {
        this._token = extractedData[Config.tokenP];
        this._userId = extractedData[Config.userIdP];

        this._email = extractedData[Config.emailP];
        this._userName = extractedData['username'];
        this._expiryDate = expiryDate;

        notifyListeners();

        _autoLogout();

        return true;
      }
    }
  }

  Future<void> logout() async {
    this._token = null;
    this._userId = null;
    this._email = null;
    this._userId = null;
    this._expiryDate = null;
    if (this._authTime != null) {
      this._authTime.cancel();
      this._authTime = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Config.userDataPrefName);
  }

  Future<void> _autoLogout() {
    if (_authTime != null) {
      _authTime.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: timeToExpire), logout);
  }
}
