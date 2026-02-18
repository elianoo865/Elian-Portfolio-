class Project {
  final String title;
  final String subtitle;
  final String category;
  final List<String> tags;
  final String? link;

  /// Optional slug used in routes (`/projects/:slug`).
  /// If missing, it will be generated from [title].
  final String? slug;

  /// Optional richer case-study fields for project detail pages.
  final String? detailIntro;
  final List<String> galleryImages;
  final String? videoUrl;

  const Project({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.tags,
    this.link,
    this.slug,
    this.detailIntro,
    this.galleryImages = const [],
    this.videoUrl,
  });
}
