class VideoModel {
  int id;
  String Title;
  String Image;

  VideoModel(this.id, this.Title, this.Image);

  VideoModel.fromJson(data) {
    this.id = data['id'];
    this.Title = data['title'];
    this.Image = data['image'];
  }
}
