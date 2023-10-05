import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final Timestamp postTime;
  final String postID;
  final String accPF;
  final String accName;
  final String postDesc;
  final String postRecipe;
  final String postImage;
  final String accountID;
  final String prepTime;
  final String cookTime;
  final String serving;

  Post({
    required this.postTime,
    required this.postID,
    required this.accPF,
    required this.accName,
    required this.postDesc,
    required this.postRecipe,
    required this.postImage,
    required this.accountID,
    required this.prepTime,
    required this.cookTime,
    required this.serving,
  });

  static Post fromJson(Map<String, dynamic> json) => Post(
        postTime: json['Post_time'],
        postID: json['ID'],
        accPF: json['Profile_pic'],
        accName: json['Account_name'],
        postDesc: json['Description'],
        postImage: json['Image'],
        postRecipe: json['Recipe'],
        accountID: json['Account_ID'],
        prepTime: json['Prep_time'],
        cookTime: json['Cook_time'],
        serving: json['Serving'],
      );
  Map<String, dynamic> toJson() => {
        'Post_time': postTime,
        'ID': postID,
        'Profile_pic': accPF,
        'Account_name': accName,
        'Description': postDesc,
        'Image': postImage,
        'Recipe': postRecipe,
        'Account_ID': accountID,
        'Prep_time': prepTime,
        'Cook_time': cookTime,
        'Serving': serving,
      };
}
