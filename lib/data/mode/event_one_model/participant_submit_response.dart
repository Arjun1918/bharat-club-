import 'dart:convert';

/// error : false
/// statusCode : 200
/// statusMessage : "OK"
/// data : {"error": false, "response": "{\"event_id\":\"2\",\"participant_name\":\"Andrew\",\"email_address\":\"andrew12@benchmarkit.com.my\",\"no_of_participants\":\"1\",\"status\":1,\"member_no_of_adults\":\"2\",\"member_no_of_child\":\"0\",\"member_no_of_child_free\":\"0\",\"guest_no_of_adults\":\"0\",\"guest_no_of_child\":\"0\",\"guest_no_of_child_free\":\"0\",\"vegetarian\":\"0\",\"non_vegetarian\":\"0\",\"jain\":\"0\",\"subscription_included\":\"0\",\"total_amount_paid\":\"112\",\"membership_id\":\"K7123124\",\"updated_at\":\"2024-11-23T04:21:35.000000Z\",\"created_at\":\"2024-11-23T04:21:35.000000Z\",\"id\":69}", "message": "Your data has been successfully submitted"}
/// responseTime : 1732335695

class ParticipantSubmitResponse {
  ParticipantSubmitResponse({
    this.error,
    this.statusCode,
    this.statusMessage,
    this.data,
    this.responseTime,
  });

  ParticipantSubmitResponse.fromJson(dynamic json) {
    error = json['error'];
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    data = json['data'] != null
        ? ParticipantSubmitResponseData.fromJson(json['data'])
        : null;
    responseTime = json['responseTime'];
  }

  bool? error;
  int? statusCode;
  String? statusMessage;
  ParticipantSubmitResponseData? data;
  int? responseTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['statusCode'] = statusCode;
    map['statusMessage'] = statusMessage;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['responseTime'] = responseTime;
    return map;
  }
}

class ParticipantSubmitResponseData {
  ParticipantSubmitResponseData({
    this.response,
    this.message,
  });

  ParticipantSubmitResponseData.fromJson(dynamic json) {
    response = json['response'] != null
        ? ResponseData.fromJson(jsonDecode(json['response']))
        : null;
    message = json['message'];
  }

  ResponseData? response;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (response != null) {
      map['response'] = response?.toJson();
    }
    map['message'] = message;
    return map;
  }
}

class ResponseData {
  ResponseData({
    this.eventId,
    this.participantName,
    this.emailAddress,
    this.noOfParticipants,
    this.status,
    this.memberNoOfAdults,
    this.memberNoOfChild,
    this.memberNoOfChildFree,
    this.guestNoOfAdults,
    this.guestNoOfChild,
    this.guestNoOfChildFree,
    this.vegetarian,
    this.nonVegetarian,
    this.jain,
    this.subscriptionIncluded,
    this.totalAmountPaid,
    this.membershipId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  ResponseData.fromJson(dynamic json) {
    eventId = json['event_id'];
    participantName = json['participant_name'];
    emailAddress = json['email_address'];
    noOfParticipants = json['no_of_participants'];
    status = json['status'];
    memberNoOfAdults = json['member_no_of_adults'];
    memberNoOfChild = json['member_no_of_child'];
    memberNoOfChildFree = json['member_no_of_child_free'];
    guestNoOfAdults = json['guest_no_of_adults'];
    guestNoOfChild = json['guest_no_of_child'];
    guestNoOfChildFree = json['guest_no_of_child_free'];
    vegetarian = json['vegetarian'];
    nonVegetarian = json['non_vegetarian'];
    jain = json['jain'];
    subscriptionIncluded = json['subscription_included'];
    totalAmountPaid = json['total_amount_paid'];
    membershipId = json['membership_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  String? eventId;
  String? participantName;
  String? emailAddress;
  int? noOfParticipants;
  int? status;
  int? memberNoOfAdults;
  int? memberNoOfChild;
  int? memberNoOfChildFree;
  int? guestNoOfAdults;
  int? guestNoOfChild;
  int? guestNoOfChildFree;
  int? vegetarian;
  int? nonVegetarian;
  int? jain;
  bool? subscriptionIncluded;
  int? totalAmountPaid;
  String? membershipId;
  String? updatedAt;
  String? createdAt;
  int? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['event_id'] = eventId;
    map['participant_name'] = participantName;
    map['email_address'] = emailAddress;
    map['no_of_participants'] = noOfParticipants;
    map['status'] = status;
    map['member_no_of_adults'] = memberNoOfAdults;
    map['member_no_of_child'] = memberNoOfChild;
    map['member_no_of_child_free'] = memberNoOfChildFree;
    map['guest_no_of_adults'] = guestNoOfAdults;
    map['guest_no_of_child'] = guestNoOfChild;
    map['guest_no_of_child_free'] = guestNoOfChildFree;
    map['vegetarian'] = vegetarian;
    map['non_vegetarian'] = nonVegetarian;
    map['jain'] = jain;
    map['subscription_included'] = subscriptionIncluded;
    map['total_amount_paid'] = totalAmountPaid;
    map['membership_id'] = membershipId;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    map['id'] = id;
    return map;
  }
}
