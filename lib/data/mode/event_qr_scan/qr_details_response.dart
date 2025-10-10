class QrDetailsResponse {
  QrDetailsResponse({
    this.error,
    this.statusCode,
    this.statusMessage,
    this.data,
    this.responseTime,
  });

  QrDetailsResponse.fromJson(dynamic json) {
    error = json['error'];
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    data = json['data'] != null ? QrDetailsResponseData.fromJson(json['data']) : null;
    responseTime = json['responseTime'];
  }

  bool? error;
  int? statusCode;
  String? statusMessage;
  QrDetailsResponseData? data;
  int? responseTime;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['statusCode'] = statusCode;
    data['statusMessage'] = statusMessage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['responseTime'] = responseTime;
    return data;
  }
}

class QrDetailsResponseData {
  QrDetailsResponseData({
    this.error,
    this.response,
    this.isResponseBoolean,
  });

  bool? error;
  QrDetailsResponseDetails? response; 
  bool? isResponseBoolean;

  QrDetailsResponseData.fromJson(dynamic json) {
    error = json['error'];

    // Check if 'response' is a boolean or a Map
    if (json['response'] is bool) {
      isResponseBoolean = json['response'];
      response = null;
    } else if (json['response'] is Map) {
      response = QrDetailsResponseDetails.fromJson(json['response']);
      isResponseBoolean = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;

    // Serialize based on response type
    if (isResponseBoolean != null) {
      data['response'] = isResponseBoolean;
    } else if (response != null) {
      data['response'] = response!.toJson();
    }

    return data;
  }
}

class QrDetailsResponseDetails {
  QrDetailsResponseDetails({
    this.participantName,
    this.membershipID,
    this.memberNoOfAdults,
    this.memberNoOfChild,
    this.memberNoOfChildFree,
    this.guestNoOfAdults,
    this.guestNoOfChild,
    this.guestNoOfChildFree,
    this.memberChildStatus,
    this.guestChildStatus,
    this.status,
    this.eventID,
  });

  QrDetailsResponseDetails.fromJson(dynamic json) {
    participantName = json['participant_name'];
    membershipID = json['membership_id'];
    memberNoOfAdults = json['member_no_of_adults'];
    memberNoOfChild = json['member_no_of_child'];
    memberNoOfChildFree = json['member_no_of_child_free'];
    guestNoOfAdults = json['guest_no_of_adults'];
    guestNoOfChild = json['guest_no_of_child'];
    guestNoOfChildFree = json['guest_no_of_child_free'];
    memberChildStatus = json['member_child_status'];
    guestChildStatus = json['guest_child_status'];
    status = json['status'];
    eventID = json['event_id'];
  }

  String? participantName;
  String? membershipID;
  int? memberNoOfAdults;
  int? memberNoOfChild;
  int? memberNoOfChildFree;
  int? guestNoOfAdults;
  int? guestNoOfChild;
  int? guestNoOfChildFree;
  int? memberChildStatus;
  int? guestChildStatus;
  int? status;
  int? eventID;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['participant_name'] = participantName;
    data['membership_id'] = membershipID;
    data['member_no_of_adults'] = memberNoOfAdults;
    data['member_no_of_child'] = memberNoOfChild;
    data['member_no_of_child_free'] = memberNoOfChildFree;
    data['guest_no_of_adults'] = guestNoOfAdults;
    data['guest_no_of_child'] = guestNoOfChild;
    data['guest_no_of_child_free'] = guestNoOfChildFree;
    data['member_child_status'] = memberChildStatus;
    data['guest_child_status'] = guestChildStatus;
    data['status'] = status;
    data['event_id'] = eventID;
    return data;
  }
}
