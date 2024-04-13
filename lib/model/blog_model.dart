class BlogModel {
  final String id;
  final String title;
  final String subTitle;
  final String body;
  final String dateCreated;

  BlogModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.body,
    required this.dateCreated,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
   // int id_ = 0;
    return BlogModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subTitle: json['subTitle'] ?? '',
      body: json['body'] ?? '',
      dateCreated: json['dateCreated'] ?? '',
    );
  }
}

class BlogList {
  final List<BlogModel> blog;

  BlogList({required this.blog});

 factory BlogList.fromJson(Map<String, dynamic> json) {
  final List<dynamic>? allBlogPostsJson = json['allBlogPosts'];
  final List<BlogModel> allBlogPosts = <BlogModel>[];

  if (allBlogPostsJson != null) {
    allBlogPostsJson.forEach((postJson) {
      if (postJson is Map<String, dynamic>) {
        final BlogModel blogModel = BlogModel.fromJson(postJson);
        allBlogPosts.add(blogModel);
      }
    });
  }

  return BlogList(blog: allBlogPosts);
}
}



