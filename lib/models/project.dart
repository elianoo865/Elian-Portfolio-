enum ProjectContentType {
  text,
  video,
  carousel,
  imageStack,
  quote,
}

class ProjectContentBlock {
  final ProjectContentType type;

  /// Generic text fields used by different block types.
  final String title;
  final String body;

  /// Used for video links or external embeds.
  final String? url;

  /// Used for image-based blocks.
  final List<String> images;

  /// Layout flags to get a Behance-like visual rhythm.
  final bool overlapImages;
  final double baseMargin;

  const ProjectContentBlock({
    required this.type,
    this.title = '',
    this.body = '',
    this.url,
    this.images = const [],
    this.overlapImages = false,
    this.baseMargin = 12,
  });
}

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


extension ProjectContentTypeLabel on ProjectContentType {
  String get label {
    switch (this) {
      case ProjectContentType.text:
        return 'Text';
      case ProjectContentType.video:
        return 'Video';
      case ProjectContentType.carousel:
        return 'Carousel';
      case ProjectContentType.imageStack:
        return 'Image Stack';
      case ProjectContentType.quote:
        return 'Quote';
    }
  }
}
