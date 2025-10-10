//name:muthu
// mobile:9078675645
// email:partha.paul007@gmail.com
// profile:https://lh3.googleusercontent.com/a/ACg8ocIBKFmFRW_QmHemhgZIREXw7esuyKmuTsAUiRcDMUZMaVvq_ZIdFQ=s96-c
// type:NORMAL_LOGIN

class ProfileUpdateRequest {
  ProfileUpdateRequest({
    String? name,
    String? mobile,
    bool? isPoc,
    String? email,
    String? pocFirstName,
    String? pocMobile,
    String? pocEmail,
    String? companyName,
    String? designation,
    String? location,
    String? companyWebsite,
    String? linkedinUrl,
  }) {
    _name = name;
    _mobile = mobile;
    _email = email;
    _isPoc = isPoc;

    _pocFirstName = pocFirstName;
    _pocMobile = pocMobile;
    _pocEmail = pocEmail;

    _companyName = companyName;
    _designation = designation;
    _location = location;
    _companyWebsite = companyWebsite;
    _linkedinUrl = linkedinUrl;
  }

  ProfileUpdateRequest.fromJson(dynamic json) {
    _name = json['name'];
    _mobile = json['mobile'];
    _isPoc = json['is_poc'];
    _email = json['email'];

    _pocFirstName = json['poc_first_name'];
    _pocMobile = json['poc_mobile'];
    _pocEmail = json['poc_email'];

    _companyName = json['company_name'];
    _designation = json['designation'];
    _location = json['location'];
    _companyWebsite = json['company_website'];
    _linkedinUrl = json['linkedin_url'];
  }

  String? _name;
  String? _mobile;
  bool? _isPoc;
  String? _email;

  String? _pocFirstName;
  String? _pocMobile;
  String? _pocEmail;

  String? _companyName;
  String? _designation;
  String? _location;
  String? _companyWebsite;
  String? _linkedinUrl;

  String? get name => _name;

  String? get mobile => _mobile;

  String? get email => _email;

  bool? get isPoc => _isPoc;

  String? get pocFirstName => _pocFirstName;

  String? get pocMobile => _pocMobile;

  String? get pocEmail => _pocEmail;

  String? get companyName => _companyName;

  String? get designation => _designation;

  String? get location => _location;

  String? get companyWebsite => _companyWebsite;

  String? get linkedinUrl => _linkedinUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_name != null) {
      map['name'] = _name;
      map['mobile'] = _mobile;
      map['email'] = _email;
      map['is_poc'] = (_isPoc??false)?1:0;

    }
    if (_pocFirstName != null) {
      map['poc_first_name'] = _pocFirstName;
      map['poc_email'] = _pocEmail;
      map['poc_mobile'] = _pocMobile;
    }

    if (_companyName != null) {
      map['company_name'] = _companyName;
      map['designation'] = _designation;
      map['location'] = _location;
      map['company_website'] = _companyWebsite;
      map['linkedin_url'] = _linkedinUrl;
    }
    return map;
  }
}
