import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../mode/membership_type/membership_type_response.dart';
import '../../mode/registration/registration_response.dart';
import 'pref_constants.dart';

class SharedPrefs {
  // Singleton approach
  static final SharedPrefs _instance = SharedPrefs._internal();

  factory SharedPrefs() => _instance;

  SharedPrefs._internal();

  SharedPreferences? sharedPreferences;

  sharedPreferencesInstance() async {
    if (sharedPreferences == null) {
      return sharedPreferences = await SharedPreferences.getInstance();
    } else {
      return sharedPreferences;
    }
  }

  /// AppUserToke
  Future<void> setUserLoginStatus(String? loginStatus) async {
    /// debugPrint("setToken $bearerToken");
    sharedPreferences!.setString(PrefConstants.sLoginStatus, loginStatus ?? "");
  }

  Future<String> getUserLoginStatus() async {
    String value =
        sharedPreferences!.getString(PrefConstants.sLoginStatus) ?? "";
    if (value.isNotEmpty) {
      return value;
    }
    return "";
  }

  /// AppUserToke
  Future<void> setUserToken(String? bearerToken) async {
    /// debugPrint("setToken $bearerToken");
    sharedPreferences!.setString(PrefConstants.token, bearerToken ?? "");
  }

  Future<String> getUserToken() async {
    String value = sharedPreferences!.getString(PrefConstants.token) ?? "";
    if (value.isNotEmpty) {
      return value;
    }
    return "";
  }

  Future<void> setUserDetails(String? setUserDetails) async {
    sharedPreferences!.setString(
      PrefConstants.sUserDetails,
      setUserDetails ?? "",
    );
  }

  Future<RegistrationUser> getUserDetails() async {
    String value =
        sharedPreferences!.getString(PrefConstants.sUserDetails) ?? "";
    if (value.isNotEmpty) {
      return RegistrationUser.fromJson(json.decode(value));
    }
    return RegistrationUser();
  }

  //MebershipType Data
  Future<void> setMembershipTypeAll(String? setMembershipTypeAll) async {
    sharedPreferences!.setString(
      PrefConstants.sMembershipTypeAll,
      setMembershipTypeAll ?? "",
    );
  }

  Future<List<MembershipTypeData>> getMembershipTypeAll() async {
    String value =
        sharedPreferences!.getString(PrefConstants.sMembershipTypeAll) ?? "";
    if (value.isNotEmpty) {
      List<dynamic> jsonList = jsonDecode(value);
      return jsonList.map((e) => MembershipTypeData.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> logout() async {
    await sharedPreferences?.remove(PrefConstants.token);
    await sharedPreferences?.remove(PrefConstants.sUserDetails);
    await sharedPreferences?.remove(PrefConstants.sLoginStatus);
  }
}
