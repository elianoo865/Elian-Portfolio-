import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../models/project.dart';
import '../state/portfolio_state.dart';
import '../widgets/responsive_container.dart';
import '../widgets/section_header.dart';

class ProjectDetailPage extends StatefulWidget {
  final String slug;
  const ProjectDetailPage({super.key, required this.slug});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  double _spacingMultiplier = 1;

  @override
  Widget build(BuildContext context) {
    final items = PortfolioStateScope.of(context).projectItems;
    final project = _findProject(items, widget.slug);

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
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in project.tags) Chip(label: Text(tag)),
                ],
              ),
              if (project.publishedAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Published: ${_fmtDateTime(project.publishedAt!)}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
              ],
              if (project.detailIntro != null && project.detailIntro!.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(project.detailIntro!, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
              ],
              const SizedBox(height: 18),
              Text('Image Spacing Control', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              Slider(
                min: 0,
                max: 2,
                value: _spacingMultiplier,
                label: _spacingMultiplier.toStringAsFixed(2),
                onChanged: (v) => setState(() => _spacingMultiplier = v),
              ),
              const SizedBox(height: 8),

              // Behance-like stacked content flow (not card-grid).
              ...project.content.map(_buildBlock),

              if (project.content.isEmpty) ...[
                if (project.galleryImages.isNotEmpty)
                  _ImageStackBlock(
                    images: project.galleryImages,
                    overlap: false,
                    baseMargin: 14,
                    spacingMultiplier: _spacingMultiplier,
                  ),
                if (project.videoUrl != null && project.videoUrl!.isNotEmpty)
                  _VideoBlock(title: 'Project Video', videoUrl: project.videoUrl!),
              ],

              if (project.link != null && project.link!.isNotEmpty) ...[
                const SizedBox(height: 20),
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

  Widget _buildBlock(ProjectContentBlock block) {
    switch (block.type) {
      case ProjectContentType.text:
        return _TextBlock(title: block.title, body: block.body);
      case ProjectContentType.video:
        return _VideoBlock(title: block.title.isEmpty ? 'Video' : block.title, videoUrl: block.url ?? '');
      case ProjectContentType.carousel:
        return _CarouselBlock(images: block.images);
      case ProjectContentType.imageStack:
        return _ImageStackBlock(
          images: block.images,
          overlap: block.overlapImages,
          baseMargin: block.baseMargin,
          spacingMultiplier: _spacingMultiplier,
        );
      case ProjectContentType.quote:
        return _QuoteBlock(quote: block.body, author: block.title);
    }
  }

  static Project? _findProject(List<Project> items, String routeSlug) {
    for (final project in items) {
      final value = project.effectiveSlug;
      if (value == routeSlug) return project;
    }
    return null;
  }


  static String _fmtDateTime(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${value.year}-${two(value.month)}-${two(value.day)} ${two(value.hour)}:${two(value.minute)}';
  }

  static Future<void> _open(String value) async {
    await launchUrl(Uri.parse(value), mode: LaunchMode.externalApplication);
  }
}

class _TextBlock extends StatelessWidget {
  final String title;
  final String body;
  const _TextBlock({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          if (title.isNotEmpty) const SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyLarge?.copyWith(height: 1.55)),
        ],
      ),
    );
  }
}

class _QuoteBlock extends StatelessWidget {
  final String quote;
  final String author;
  const _QuoteBlock({required this.quote, required this.author});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: theme.colorScheme.primary, width: 4)),
          color: theme.colorScheme.surface.withOpacity(0.6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('“$quote”', style: theme.textTheme.titleLarge?.copyWith(fontStyle: FontStyle.italic)),
            if (author.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('— $author', style: theme.textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImageStackBlock extends StatelessWidget {
  final List<String> images;
  final bool overlap;
  final double baseMargin;
  final double spacingMultiplier;

  const _ImageStackBlock({
    required this.images,
    required this.overlap,
    required this.baseMargin,
    required this.spacingMultiplier,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < images.length; i++)
            Transform.translate(
              offset: overlap ? Offset(0, i == 0 ? 0 : -34 * spacingMultiplier) : Offset.zero,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: overlap ? 0 : (baseMargin * spacingMultiplier),
                  left: overlap && i.isOdd ? 22 : 0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(overlap ? 0 : 10),
                  child: Image.network(
                    images[i],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 430,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(
                      height: 280,
                      child: Center(child: Icon(Icons.broken_image_outlined)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CarouselBlock extends StatefulWidget {
  final List<String> images;
  const _CarouselBlock({required this.images});

  @override
  State<_CarouselBlock> createState() => _CarouselBlockState();
}

class _CarouselBlockState extends State<_CarouselBlock> {
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

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (v) => setState(() => _index = v),
              itemCount: widget.images.length,
              itemBuilder: (context, i) => Image.network(widget.images[i], fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              OutlinedButton(onPressed: () => _controller.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut), child: const Text('Prev')),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut), child: const Text('Next')),
              const Spacer(),
              Text('${_index + 1}/${widget.images.length}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _VideoBlock extends StatefulWidget {
  final String title;
  final String videoUrl;
  const _VideoBlock({required this.title, required this.videoUrl});

  @override
  State<_VideoBlock> createState() => _VideoBlockState();
}

class _VideoBlockState extends State<_VideoBlock> {
  VideoPlayerController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl.isEmpty) return;
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _ready && _controller != null ? VideoPlayer(_controller!) : const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () {
              if (_controller == null) return;
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
        ],
      ),
    );
  }
}
