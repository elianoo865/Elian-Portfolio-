import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../models/project.dart';
import '../state/portfolio_state.dart';
import '../widgets/hover_card.dart';
import '../widgets/responsive_container.dart';
import '../widgets/section_header.dart';

class ProjectDetailPage extends StatelessWidget {
  final String slug;
  const ProjectDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final items = PortfolioStateScope.of(context).projectItems;
    final project = _findProject(items, slug);

    if (project == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off_rounded, size: 36),
              const SizedBox(height: 10),
              const Text('Project not found'),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 26, bottom: 40),
        child: ResponsiveContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: project.title, subtitle: project.subtitle),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in project.tags)
                    Chip(
                      label: Text(tag),
                      side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                    ),
                ],
              ),
              if (project.detailIntro != null && project.detailIntro!.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  project.detailIntro!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.82),
                    height: 1.45,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (project.galleryImages.isNotEmpty)
                _GalleryCarousel(images: project.galleryImages),
              if (project.videoUrl != null && project.videoUrl!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _EmbeddedVideoCard(videoUrl: project.videoUrl!),
              ],
              if (project.link != null && project.link!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () => _open(project.link!),
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Open Behance Project'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static Project? _findProject(List<Project> items, String routeSlug) {
    for (final project in items) {
      final value = project.slug ?? _slugify(project.title);
      if (value == routeSlug) return project;
    }
    return null;
  }

  static String _slugify(String text) {
    final sanitized = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    return sanitized.replaceAll(RegExp(r'^-|-$'), '');
  }

  static Future<void> _open(String value) async {
    await launchUrl(Uri.parse(value), mode: LaunchMode.externalApplication);
  }
}

class _GalleryCarousel extends StatefulWidget {
  final List<String> images;
  const _GalleryCarousel({required this.images});

  @override
  State<_GalleryCarousel> createState() => _GalleryCarouselState();
}

class _GalleryCarouselState extends State<_GalleryCarousel> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index >= widget.images.length - 1) return;
    _controller.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
  }

  void _prev() {
    if (_index <= 0) return;
    _controller.previousPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HoverCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Image Carousel', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: widget.images.length,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemBuilder: (context, i) {
                    return Image.network(
                      widget.images[i],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.broken_image_outlined, size: 38));
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton.icon(onPressed: _prev, icon: const Icon(Icons.chevron_left), label: const Text('Previous')),
                const SizedBox(width: 8),
                OutlinedButton.icon(onPressed: _next, icon: const Icon(Icons.chevron_right), label: const Text('Next')),
                const Spacer(),
                Text('${_index + 1} / ${widget.images.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmbeddedVideoCard extends StatefulWidget {
  final String videoUrl;
  const _EmbeddedVideoCard({required this.videoUrl});

  @override
  State<_EmbeddedVideoCard> createState() => _EmbeddedVideoCardState();
}

class _EmbeddedVideoCardState extends State<_EmbeddedVideoCard> {
  VideoPlayerController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _ready = true);
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HoverCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Embedded Video', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _ready && _controller != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          VideoPlayer(_controller!),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor: theme.colorScheme.primary,
                                bufferedColor: theme.colorScheme.primary.withOpacity(0.35),
                                backgroundColor: Colors.black26,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () {
                    if (!_ready || _controller == null) return;
                    if (_controller!.value.isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                    setState(() {});
                  },
                  icon: Icon((_controller?.value.isPlaying ?? false) ? Icons.pause : Icons.play_arrow),
                  label: Text((_controller?.value.isPlaying ?? false) ? 'Pause' : 'Play'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    if (_controller == null) return;
                    _controller!.seekTo(Duration.zero);
                    _controller!.pause();
                    setState(() {});
                  },
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Restart'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
