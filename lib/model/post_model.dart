class PostModel {
  late String name;
  late String text;
  late String dateTime;
  late String image;
  late String postImage;
  late String uId;

  PostModel(
      {required this.name,
      required this.text,
      required this.dateTime,
      required this.image,
      required this.postImage,
      required this.uId});

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    text = json['text'];
    dateTime = json['dateTime'];
    image = json['image'];
    postImage = json[' postImage'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'text': text,
      'dateTime': dateTime,
      'image': image,
      ' postImage': postImage,
      'uId': uId
    };
  }
}
