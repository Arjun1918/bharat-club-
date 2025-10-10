/// error : false
/// statusCode : 200
/// statusMessage : "OK"
/// data : {"banner":[{"id":1,"title":"Banner Img 1","small_text":"Banner Image 1","file_name":"banner1.png","file_type":"Banner","file_url":"https://hcm-storage.ap-south-1.linodeobjects.com/club_portal/banner/banner1.png","sort_order":1,"status":1},{"id":4,"title":"Banner Img 2","small_text":"Banner Image 2","file_name":"banner2.jpeg","file_type":"Banner","file_url":"https://hcm-storage.ap-south-1.linodeobjects.com/club_portal/banner/banner2.jpeg","sort_order":2,"status":1}]}
/// responseTime : 1722914640

class BannerListResponse {
  BannerListResponse({
      this.error, 
      this.statusCode, 
      this.statusMessage, 
      this.data, 
      this.responseTime,});

  BannerListResponse.fromJson(dynamic json) {
    error = json['error'];
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    data = json['data'] != null ? BannerListResponseData.fromJson(json['data']) : null;
    responseTime = json['responseTime'];
  }
  bool? error;
  int? statusCode;
  String? statusMessage;
  BannerListResponseData? data;
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

/// banner : [{"id":1,"title":"Banner Img 1","small_text":"Banner Image 1","file_name":"banner1.png","file_type":"Banner","file_url":"https://hcm-storage.ap-south-1.linodeobjects.com/club_portal/banner/banner1.png","sort_order":1,"status":1},{"id":4,"title":"Banner Img 2","small_text":"Banner Image 2","file_name":"banner2.jpeg","file_type":"Banner","file_url":"https://hcm-storage.ap-south-1.linodeobjects.com/club_portal/banner/banner2.jpeg","sort_order":2,"status":1}]

class BannerListResponseData {
  BannerListResponseData({
      this.banner,});

  BannerListResponseData.fromJson(dynamic json) {
    if (json['sponsor'] != null) {
      banner = [];
      json['sponsor'].forEach((v) {
        banner?.add(BannerShow.fromJson(v));
      });
    }
  }
  List<BannerShow>? banner;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (banner != null) {
      map['sponsor'] = banner?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// title : "Banner Img 1"
/// small_text : "Banner Image 1"
/// file_name : "banner1.png"
/// file_type : "Banner"
/// file_url : "https://hcm-storage.ap-south-1.linodeobjects.com/club_portal/banner/banner1.png"
/// sort_order : 1
/// status : 1

class BannerShow {
  BannerShow({
      this.id, 
      this.title, 
      this.smallText, 
      this.fileName, 
      this.fileType, 
      this.fileUrl,
      this.status,});

  BannerShow.fromJson(dynamic json) {
    id = json['id'];
    title = json['company_name'];
    smallText = json['website'];
    fileName = json['file_name'];
    fileType = json['file_type'];
    fileUrl = json['file_url'];
    status = json['status'];
  }
  int? id;
  String? title;
  String? smallText;
  String? fileName;
  String? fileType;
  String? fileUrl;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['company_name'] = title;
    map['website'] = smallText;
    map['file_name'] = fileName;
    map['file_type'] = fileType;
    map['file_url'] = fileUrl;
    map['status'] = status;
    return map;
  }

}