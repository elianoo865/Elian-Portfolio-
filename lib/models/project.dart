const projectCategories = <String>['Motion', 'Print', 'Branding', 'Social', 'UX', 'Video', 'Other'];

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

  /// Scheduling metadata editable from admin.
  final DateTime? publishedAt;

  /// Rich, ordered content sections used by the project detail page.
  final List<ProjectContentBlock> content;

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
    this.publishedAt,
    this.content = const [],
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


extension ProjectSlugX on Project {
  String get effectiveSlug {
    if (slug != null && slug!.trim().isNotEmpty) return slug!.trim();
    final sanitized = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    return sanitized.replaceAll(RegExp(r'^-|-$'), '');
  }
}
