// To parse this JSON data, do
//
//     final cameo = cameoFromJson(jsonString);

import 'dart:convert';

class Cameo {
  Cameo({
    this.gigsDetails,
    this.videoPath,
    this.similarGigs,
    this.reviews,
  });

  GigsDetails gigsDetails;
  List<dynamic> videoPath;
  List<SimilarGig> similarGigs;
  List<dynamic> reviews;

  factory Cameo.fromRawJson(String str) => Cameo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cameo.fromJson(Map<String, dynamic> json) => Cameo(
        gigsDetails: GigsDetails.fromJson(json["gigs_details"]),
        videoPath: List<dynamic>.from(json["video_path"].map((x) => x)),
        similarGigs: List<SimilarGig>.from(
            json["similar_gigs"].map((x) => SimilarGig.fromJson(x))),
        reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "gigs_details": gigsDetails.toJson(),
        "video_path": List<dynamic>.from(videoPath.map((x) => x)),
        "similar_gigs": List<dynamic>.from(similarGigs.map((x) => x.toJson())),
        "reviews": List<dynamic>.from(reviews.map((x) => x)),
      };
}

class GigsDetails {
  GigsDetails({
    this.id,
    this.userId,
    this.deliveringDays,
    this.costType,
    this.currencyType,
    this.currencySign,
    this.title,
    this.gigPrice,
    this.isSuperfast,
    this.categoryId,
    this.gigDetails,
    this.requirements,
    this.superFastCharges,
    this.superFastDeliveryDesc,
    this.superFastDays,
    this.totalViews,
    this.country,
    this.stateName,
    this.image,
    this.gigUsercount,
    this.gigRating,
    this.email,
    this.username,
    this.fullname,
    this.userTimezone,
    this.verified,
    this.status,
    this.city,
    this.address,
    this.zipcode,
    this.langSpeaks,
    this.uniqueCode,
    this.countryId,
    this.state,
    this.profession,
    this.professionName,
    this.contact,
    this.description,
    this.userThumbImage,
    this.userProfileImage,
    this.favourite,
    this.youtubeUrl,
    this.vimeoUrl,
    this.vimeoVideoId,
    this.gigTags,
    this.extraGigs,
  });

  String id;
  String userId;
  String deliveringDays;
  String costType;
  String currencyType;
  String currencySign;
  String title;
  String gigPrice;
  String isSuperfast;
  String categoryId;
  String gigDetails;
  String requirements;
  String superFastCharges;
  String superFastDeliveryDesc;
  String superFastDays;
  dynamic totalViews;
  String country;
  String stateName;
  String image;
  String gigUsercount;
  String gigRating;
  String email;
  String username;
  String fullname;
  String userTimezone;
  String verified;
  String status;
  String city;
  String address;
  String zipcode;
  String langSpeaks;
  String uniqueCode;
  String countryId;
  String state;
  String profession;
  String professionName;
  String contact;
  String description;
  String userThumbImage;
  String userProfileImage;
  String favourite;
  String youtubeUrl;
  String vimeoUrl;
  String vimeoVideoId;
  String gigTags;
  List<ExtraGig> extraGigs;

  factory GigsDetails.fromRawJson(String str) =>
      GigsDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GigsDetails.fromJson(Map<String, dynamic> json) => GigsDetails(
        id: json["id"],
        userId: json["user_id"],
        deliveringDays: json["delivering_days"],
        costType: json["cost_type"],
        currencyType: json["currency_type"],
        currencySign: json["currency_sign"],
        title: json["title"],
        gigPrice: json["gig_price"],
        isSuperfast: json["is_superfast"],
        categoryId: json["category_id"],
        gigDetails: json["gig_details"],
        requirements: json["requirements"],
        superFastCharges: json["super_fast_charges"],
        superFastDeliveryDesc: json["super_fast_delivery_desc"],
        superFastDays: json["super_fast_days"],
        totalViews: json["total_views"],
        country: json["country"],
        stateName: json["state_name"],
        image: json["image"],
        gigUsercount: json["gig_usercount"],
        gigRating: json["gig_rating"],
        email: json["email"],
        username: json["username"],
        fullname: json["fullname"],
        userTimezone: json["user_timezone"],
        verified: json["verified"],
        status: json["status"],
        city: json["city"],
        address: json["address"],
        zipcode: json["zipcode"],
        langSpeaks: json["lang_speaks"],
        uniqueCode: json["unique_code"],
        countryId: json["country_id"],
        state: json["state"],
        profession: json["profession"],
        professionName: json["profession_name"],
        contact: json["contact"],
        description: json["description"],
        userThumbImage: json["user_thumb_image"],
        userProfileImage: json["user_profile_image"],
        favourite: json["favourite"].toString(),
        youtubeUrl: json["youtube_url"],
        vimeoUrl: json["vimeo_url"],
        vimeoVideoId: json["vimeo_video_id"],
        gigTags: json["gig_tags"],
        extraGigs: List<ExtraGig>.from(
            json["extra_gigs"].map((x) => ExtraGig.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "delivering_days": deliveringDays,
        "cost_type": costType,
        "currency_type": currencyType,
        "currency_sign": currencySign,
        "title": title,
        "gig_price": gigPrice,
        "is_superfast": isSuperfast,
        "category_id": categoryId,
        "gig_details": gigDetails,
        "requirements": requirements,
        "super_fast_charges": superFastCharges,
        "super_fast_delivery_desc": superFastDeliveryDesc,
        "super_fast_days": superFastDays,
        "total_views": totalViews,
        "country": country,
        "state_name": stateName,
        "image": image,
        "gig_usercount": gigUsercount,
        "gig_rating": gigRating,
        "email": email,
        "username": username,
        "fullname": fullname,
        "user_timezone": userTimezone,
        "verified": verified,
        "status": status,
        "city": city,
        "address": address,
        "zipcode": zipcode,
        "lang_speaks": langSpeaks,
        "unique_code": uniqueCode,
        "country_id": countryId,
        "state": state,
        "profession": profession,
        "profession_name": professionName,
        "contact": contact,
        "description": description,
        "user_thumb_image": userThumbImage,
        "user_profile_image": userProfileImage,
        "favourite": favourite,
        "youtube_url": youtubeUrl,
        "vimeo_url": vimeoUrl,
        "vimeo_video_id": vimeoVideoId,
        "gig_tags": gigTags,
        "extra_gigs": List<dynamic>.from(extraGigs.map((x) => x.toJson())),
      };
}

class ExtraGig {
  ExtraGig({
    this.gigsId,
    this.extraGigs,
    this.currencyType,
    this.currencySign,
    this.extraGigsAmount,
    this.extraGigsDelivery,
    this.isSelected,
  });

  String gigsId;
  String extraGigs;
  String currencyType;
  String currencySign;
  String extraGigsAmount;
  String extraGigsDelivery;
  String isSelected;

  factory ExtraGig.fromRawJson(String str) =>
      ExtraGig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExtraGig.fromJson(Map<String, dynamic> json) => ExtraGig(
        gigsId: json["gigs_id"],
        extraGigs: json["extra_gigs"],
        currencyType: json["currency_type"],
        currencySign: json["currency_sign"],
        extraGigsAmount: json["extra_gigs_amount"],
        extraGigsDelivery: json["extra_gigs_delivery"],
        isSelected: json["is_selected"],
      );

  Map<String, dynamic> toJson() => {
        "gigs_id": gigsId,
        "extra_gigs": extraGigs,
        "currency_type": currencyType,
        "currency_sign": currencySign,
        "extra_gigs_amount": extraGigsAmount,
        "extra_gigs_delivery": extraGigsDelivery,
        "is_selected": isSelected,
      };
}

class SimilarGig {
  SimilarGig({
    this.id,
    this.userId,
    this.deliveringDays,
    this.costType,
    this.currencyType,
    this.currencySign,
    this.title,
    this.gigPrice,
    this.categoryId,
    this.image,
    this.gigUsercount,
    this.gigRating,
    this.country,
    this.stateName,
    this.fullname,
    this.favourite,
  });

  String id;
  String userId;
  String deliveringDays;
  String costType;
  String currencyType;
  String currencySign;
  String title;
  String gigPrice;
  String categoryId;
  String image;
  String gigUsercount;
  String gigRating;
  String country;
  String stateName;
  String fullname;
  String favourite;

  factory SimilarGig.fromRawJson(String str) =>
      SimilarGig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SimilarGig.fromJson(Map<String, dynamic> json) => SimilarGig(
        id: json["id"],
        userId: json["user_id"],
        deliveringDays: json["delivering_days"],
        costType: json["cost_type"],
        currencyType: json["currency_type"],
        currencySign: json["currency_sign"],
        title: json["title"],
        gigPrice: json["gig_price"],
        categoryId: json["category_id"],
        image: json["image"],
        gigUsercount: json["gig_usercount"],
        gigRating: json["gig_rating"],
        country: json["country"],
        stateName: json["state_name"],
        fullname: json["fullname"],
        favourite: json["favourite"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "delivering_days": deliveringDays,
        "cost_type": costType,
        "currency_type": currencyType,
        "currency_sign": currencySign,
        "title": title,
        "gig_price": gigPrice,
        "category_id": categoryId,
        "image": image,
        "gig_usercount": gigUsercount,
        "gig_rating": gigRating,
        "country": country,
        "state_name": stateName,
        "fullname": fullname,
        "favourite": favourite,
      };
}
