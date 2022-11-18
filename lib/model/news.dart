class News {
  final String title;
  final String link;

  News({required this.title,required this.link});

  @override
  int get hashCode => Object.hash(title.toLowerCase().trim(), link.toLowerCase().trim());

  @override
  bool operator ==(Object other) => super.hashCode == other.hashCode;
}