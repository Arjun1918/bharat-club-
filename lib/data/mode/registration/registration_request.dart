//name:muthu
// mobile:9078675645
// email:partha.paul007@gmail.com
// profile:https://lh3.googleusercontent.com/a/ACg8ocIBKFmFRW_QmHemhgZIREXw7esuyKmuTsAUiRcDMUZMaVvq_ZIdFQ=s96-c
// type:NORMAL_LOGIN
enum RegistrationRequestType { GOOGLE_LOGIN, NORMAL_LOGIN }

class RegistrationRequest {
  RegistrationRequest({
    String? name,
    String? mobile,
    String? email,
    String? password,
    String? profile,
    String? type,
  }) {
    _name = name;
    _mobile = mobile;
    _email = email;
    _password = password;
    _profile = profile;
    _type = type;
  }

  RegistrationRequest.fromJson(dynamic json) {
    // _name = json['name'];
    // _mobile = json['mobile'];
    _email = json['email'];
    _password = json['password'];
    // _profile = json['profile'];
    // _type = json['type'];
  }

  String? _name;
  String? _mobile;
  String? _email;
  String? _password;
  String? _profile;
  String? _type;

  String? get name => _name;

  String? get mobile => _mobile;

  String? get email => _email;

  String? get password => _password;

  String? get profile => _profile;

  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    // map['name'] = _name;
    // map['mobile'] = _mobile;
    map['email'] = _email;
    map['password'] = _password;
    // map['profile'] = _profile;
    // map['type'] = _type;
    return map;
  }
}
