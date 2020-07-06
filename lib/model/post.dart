class PostModel {
  String title;
  String description;
  String userId;
  String updatedAt;
  String createdAt;
  String pinned;
  int id;

  PostModel(
      {this.title,
      this.description,
      this.userId,
      this.updatedAt,
      this.createdAt,
      this.pinned,
      this.id});

  PostModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    userId = json['user_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    pinned = json['pinned'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['pinned'] = this.pinned;
    data['id'] = this.id;
    return data;
  }
}
