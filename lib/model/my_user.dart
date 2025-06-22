
class MyUser {
  static const String collectionName = "users";
  String? Name;
  String? id;
  String? email;
  String? phone;

  MyUser({this.id, this.email, this.Name,this.phone});

  MyUser.fromFireStore(Map<String, dynamic> data)
      : this(
    id: data["id"],
    Name: data["Name"],
    email: data["email"],
    phone: data["phone"],
  );

  Map<String, dynamic> toFireStore() {
    return {
      "Name": Name,
      "id": id,
      "email": email,
      "phone": phone,


    };
  }
}
