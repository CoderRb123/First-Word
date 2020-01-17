class VideoDetailsModel {
  int id;
  String Title;
  String Image;
  String videoLink;

  VideoDetailsModel(this.videoLink, this.id, this.Title, this.Image);

  VideoDetailsModel.fromJson(data) {
    this.id = data['id'];
    this.Title = data['title'];
    this.Image = data['image'];
    this.videoLink = data['videolink'];
  }
}
