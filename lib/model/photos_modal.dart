// ignore_for_file: public_member_api_docs, sort_constructors_first
class PhotosModel {
  String imgSrc;
  String photosName;

  PhotosModel({
    required this.imgSrc,
    required this.photosName,
  });

  static PhotosModel fromApiToApp(Map<String, dynamic> photoMap) {
    return PhotosModel(
        imgSrc: (photoMap["src"])["portrait"],
        photosName: photoMap["photographer"]);
  }
}
