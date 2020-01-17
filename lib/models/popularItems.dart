class popularItems {
  int id;
  String Title;
  String imgUrl;

  popularItems(this.id, this.Title, this.imgUrl);

  popularItems.fromJson(data) {
    this.id = data['id'];
    this.Title = data['title'];
    this.imgUrl = data['image'];
  }
}
