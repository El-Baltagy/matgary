class UserModel {
  final String name;
  // final String phone;
  final String email;
  final String uid;
  final String profilePic;
  UserModel(  {
    required this.name,
    required this.uid,
    // required this.phone,
    required this.email,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      // 'phone': phone,
      'uid': uid,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ,
      uid: map['uid'] ,
      // phone: map['phone'] ,
      profilePic: map['profilePic'] ?? '',
      email:  map['email'],
    );
  }
}
