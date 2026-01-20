class Project {
  final String title;
  final String subtitle;
  final String category;
  final List<String> tags;
  final String? link;

  const Project({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.tags,
    this.link,
  });
}
