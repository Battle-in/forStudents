class Product{
  String url;
  String title;
  String description;

  Product(this.url, this.title, this.description);

  @override
  String toString() {
    return '{url: $url, title: $title, description: $description}';
  }
}