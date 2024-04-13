class GraphQLQueries {
   String fetchAllBlogs() {
    return r'''
    query fetchAllBlogs {
      allBlogPosts {
        id
        title
        subTitle
        body
        dateCreated
      }
    }
  ''';
   }
}