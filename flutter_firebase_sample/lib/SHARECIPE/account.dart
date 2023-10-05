class Account {
  final String id;
  final String email;
  final String name;
  final String birthdate;
  final String profilePic;
  final String bio;

  Account({
    required this.id,
    required this.email,
    required this.name,
    required this.birthdate,
    required this.profilePic,
    required this.bio,
  });
  static Account fromJson(Map<String, dynamic> json) => Account(
        id: json['ID'],
        email: json['Email'],
        name: json['Name'],
        profilePic: json['Profilepic'],
        birthdate: json['Birthdate'],
        bio: json['Bio'],
      );
  Map<String, dynamic> toJson() => {
        'ID': id,
        'Name': name,
        'Email': email,
        'Birthdate': birthdate,
        'Profilepic': profilePic,
        'Bio': bio,
      };
}
