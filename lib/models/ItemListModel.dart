class ItemListModel {
  int id;
  String Title;
  String imgUrl;
  String hotWord;

  ItemListModel(this.hotWord, this.id, this.Title, this.imgUrl);

  ItemListModel.fromJson(data) {
    this.id = data['id'];
    this.Title = data['title'];
    this.imgUrl = data['image'];
    this.hotWord = data['hotword'];
  }
}
