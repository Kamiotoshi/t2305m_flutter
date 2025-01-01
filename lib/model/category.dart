class Category {
  Category({
    required this.slug,
    required this.name,
    required this.url,
  });

  final String? slug;
  final String? name;
  final String? url;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      slug: json["slug"],
      name: json["name"],
      url: json["url"],
    );
  }

}
