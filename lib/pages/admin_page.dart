import 'package:flutter/material.dart';

import '../models/experience.dart';
import '../models/project.dart';
import '../state/portfolio_state.dart';
import '../widgets/hover_card.dart';
import '../widgets/responsive_container.dart';
import '../widgets/section_header.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _homeFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();

  late final TextEditingController _pillController;
  late final TextEditingController _headlineController;
  late final TextEditingController _homeDescriptionController;
  late final TextEditingController _calloutTitleController;
  late final TextEditingController _calloutDescriptionController;

  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _behanceController;

  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _pillController = TextEditingController();
    _headlineController = TextEditingController();
    _homeDescriptionController = TextEditingController();
    _calloutTitleController = TextEditingController();
    _calloutDescriptionController = TextEditingController();

    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _linkedinController = TextEditingController();
    _behanceController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    final state = PortfolioStateScope.of(context);
    _pillController.text = state.homePill;
    _headlineController.text = state.homeHeadline;
    _homeDescriptionController.text = state.homeDescription;
    _calloutTitleController.text = state.homeCalloutTitle;
    _calloutDescriptionController.text = state.homeCalloutDescription;
    _emailController.text = state.contactEmail;
    _phoneController.text = state.contactPhone;
    _linkedinController.text = state.contactLinkedin;
    _behanceController.text = state.contactBehance;
    _loaded = true;
  }

  @override
  void dispose() {
    _pillController.dispose();
    _headlineController.dispose();
    _homeDescriptionController.dispose();
    _calloutTitleController.dispose();
    _calloutDescriptionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _linkedinController.dispose();
    _behanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = PortfolioStateScope.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 26, bottom: 40),
        child: ResponsiveContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Admin Dashboard',
                subtitle: 'Update your website content directly from this panel.',
              ),
              const SizedBox(height: 18),
              _FormSection(
                title: 'Home Page Content',
                child: Form(
                  key: _homeFormKey,
                  child: Column(
                    children: [
                      _Field(controller: _pillController, label: 'Top pill text'),
                      const SizedBox(height: 12),
                      _Field(controller: _headlineController, label: 'Headline', maxLines: 2),
                      const SizedBox(height: 12),
                      _Field(controller: _homeDescriptionController, label: 'Description', maxLines: 3),
                      const SizedBox(height: 12),
                      _Field(controller: _calloutTitleController, label: 'Callout title'),
                      const SizedBox(height: 12),
                      _Field(controller: _calloutDescriptionController, label: 'Callout description', maxLines: 3),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: () {
                            if (!_homeFormKey.currentState!.validate()) return;
                            state.updateHome(
                              pill: _pillController.text.trim(),
                              headline: _headlineController.text.trim(),
                              description: _homeDescriptionController.text.trim(),
                              calloutTitle: _calloutTitleController.text.trim(),
                              calloutDescription: _calloutDescriptionController.text.trim(),
                            );
                            _showSavedMessage();
                          },
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Save home content'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _FormSection(
                title: 'Contact Content',
                child: Form(
                  key: _contactFormKey,
                  child: Column(
                    children: [
                      _Field(controller: _emailController, label: 'Email'),
                      const SizedBox(height: 12),
                      _Field(controller: _phoneController, label: 'Phone'),
                      const SizedBox(height: 12),
                      _Field(controller: _linkedinController, label: 'LinkedIn URL'),
                      const SizedBox(height: 12),
                      _Field(controller: _behanceController, label: 'Behance URL'),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: () {
                            if (!_contactFormKey.currentState!.validate()) return;
                            state.updateContact(
                              email: _emailController.text.trim(),
                              phone: _phoneController.text.trim(),
                              linkedin: _linkedinController.text.trim(),
                              behance: _behanceController.text.trim(),
                            );
                            _showSavedMessage();
                          },
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Save contact content'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _ListEditorSection(
                title: 'Projects',
                itemCount: state.projectItems.length,
                onAdd: () {
                  state.updateProjects([
                    ...state.projectItems,
                    Project(
                      title: 'New Project',
                      subtitle: 'Project summary',
                      category: 'Motion',
                      tags: const ['Tag'],
                      publishedAt: DateTime.now(),
                      content: const [
                        ProjectContentBlock(type: ProjectContentType.text, title: 'Overview', body: 'Add project story here.'),
                      ],
                    ),
                  ]);
                },
                child: Column(
                  children: [
                    for (var i = 0; i < state.projectItems.length; i++)
                      _ProjectEditorTile(
                        key: ValueKey('project-$i-${state.projectItems[i].title}'),
                        index: i,
                        project: state.projectItems[i],
                        onChanged: (updated) {
                          final next = [...state.projectItems]..[i] = updated;
                          state.updateProjects(next);
                        },
                        onDelete: () {
                          final next = [...state.projectItems]..removeAt(i);
                          state.updateProjects(next);
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _ListEditorSection(
                title: 'Experience',
                itemCount: state.experienceItems.length,
                onAdd: () {
                  state.updateExperiences([
                    ...state.experienceItems,
                    const Experience(
                      role: 'New role',
                      company: 'Company',
                      location: 'Location',
                      period: 'Period',
                      highlights: ['Key highlight'],
                    ),
                  ]);
                },
                child: Column(
                  children: [
                    for (var i = 0; i < state.experienceItems.length; i++)
                      _ExperienceEditorTile(
                        key: ValueKey('exp-$i-${state.experienceItems[i].role}'),
                        index: i,
                        item: state.experienceItems[i],
                        onChanged: (updated) {
                          final next = [...state.experienceItems]..[i] = updated;
                          state.updateExperiences(next);
                        },
                        onDelete: () {
                          final next = [...state.experienceItems]..removeAt(i);
                          state.updateExperiences(next);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSavedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved successfully.')),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final bool requiredField;

  const _Field({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.requiredField = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: requiredField ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null : null,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }
}

class _FormSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FormSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _ListEditorSection extends StatelessWidget {
  final String title;
  final int itemCount;
  final VoidCallback onAdd;
  final Widget child;

  const _ListEditorSection({required this.title, required this.itemCount, required this.onAdd, required this.child});

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$title ($itemCount)',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
                OutlinedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: const Text('Add item')),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _ProjectEditorTile extends StatefulWidget {
  final Project project;
  final int index;
  final ValueChanged<Project> onChanged;
  final VoidCallback onDelete;

  const _ProjectEditorTile({
    super.key,
    required this.project,
    required this.index,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_ProjectEditorTile> createState() => _ProjectEditorTileState();
}

class _ProjectEditorTileState extends State<_ProjectEditorTile> {
  static const _categories = ['Motion', 'Print', 'Branding', 'Social', 'UX', 'Video', 'Other'];

  late final TextEditingController _title;
  late final TextEditingController _subtitle;
  late final TextEditingController _tags;
  late final TextEditingController _slug;
  late final TextEditingController _intro;
  late final TextEditingController _link;

  String _category = 'Other';
  DateTime? _publishedAt;
  late List<ProjectContentBlock> _content;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.project.title);
    _subtitle = TextEditingController(text: widget.project.subtitle);
    _tags = TextEditingController(text: widget.project.tags.join(', '));
    _slug = TextEditingController(text: widget.project.slug ?? '');
    _intro = TextEditingController(text: widget.project.detailIntro ?? '');
    _link = TextEditingController(text: widget.project.link ?? '');
    _category = _categories.contains(widget.project.category) ? widget.project.category : 'Other';
    _publishedAt = widget.project.publishedAt;
    _content = List<ProjectContentBlock>.from(widget.project.content);
  }

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    _tags.dispose();
    _slug.dispose();
    _intro.dispose();
    _link.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final base = _publishedAt ?? now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: base,
      firstDate: DateTime(2010),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(base),
    );
    if (pickedTime == null) return;
    setState(() {
      _publishedAt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _addBlock(ProjectContentType type) {
    setState(() {
      _content = [
        ..._content,
        ProjectContentBlock(
          type: type,
          title: type == ProjectContentType.text ? 'Section title' : '',
          body: type == ProjectContentType.text ? 'Write your content here.' : '',
          baseMargin: 12,
        ),
      ];
    });
  }

  void _updateBlock(int index, ProjectContentBlock block) {
    setState(() => _content = [..._content]..[index] = block);
  }

  void _deleteBlock(int index) {
    setState(() => _content = [..._content]..removeAt(index));
  }

  void _save() {
    widget.onChanged(
      Project(
        title: _title.text.trim(),
        subtitle: _subtitle.text.trim(),
        category: _category,
        tags: _tags.text
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList(),
        slug: _slug.text.trim().isEmpty ? null : _slug.text.trim(),
        detailIntro: _intro.text.trim().isEmpty ? null : _intro.text.trim(),
        link: _link.text.trim().isEmpty ? null : _link.text.trim(),
        publishedAt: _publishedAt,
        content: _content,
        galleryImages: widget.project.galleryImages,
        videoUrl: widget.project.videoUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text('Project ${widget.index + 1}: ${widget.project.title}'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          _Field(controller: _title, label: 'Title'),
          const SizedBox(height: 10),
          _Field(controller: _subtitle, label: 'Subtitle', maxLines: 2),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
            items: [for (final c in _categories) DropdownMenuItem(value: c, child: Text(c))],
            onChanged: (v) => setState(() => _category = v ?? 'Other'),
          ),
          const SizedBox(height: 10),
          _Field(controller: _tags, label: 'Tags (comma separated)'),
          const SizedBox(height: 10),
          _Field(controller: _slug, label: 'Slug (optional)', requiredField: false),
          const SizedBox(height: 10),
          _Field(controller: _intro, label: 'Project intro', maxLines: 3, requiredField: false),
          const SizedBox(height: 10),
          _Field(controller: _link, label: 'Behance URL', requiredField: false),
          const SizedBox(height: 10),
          InkWell(
            onTap: _pickDateTime,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Published date & time',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_month_outlined),
              ),
              child: Text(_publishedAt == null ? 'Click to set date & time' : _fmtDateTime(_publishedAt!)),
            ),
          ),
          const SizedBox(height: 14),
          _ContentBuilderPanel(
            content: _content,
            onAdd: _addBlock,
            onUpdate: _updateBlock,
            onDelete: _deleteBlock,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(onPressed: widget.onDelete, icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
              const SizedBox(width: 8),
              FilledButton(onPressed: _save, child: const Text('Apply')),
            ],
          ),
        ],
      ),
    );
  }

  static String _fmtDateTime(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${value.year}-${two(value.month)}-${two(value.day)} ${two(value.hour)}:${two(value.minute)}';
  }
}

class _ContentBuilderPanel extends StatelessWidget {
  final List<ProjectContentBlock> content;
  final ValueChanged<ProjectContentType> onAdd;
  final void Function(int index, ProjectContentBlock block) onUpdate;
  final ValueChanged<int> onDelete;

  const _ContentBuilderPanel({
    required this.content,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Content Blocks', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(onPressed: () => onAdd(ProjectContentType.text), icon: const Icon(Icons.text_fields), label: const Text('Text Block')),
            OutlinedButton.icon(onPressed: () => onAdd(ProjectContentType.video), icon: const Icon(Icons.video_library_outlined), label: const Text('Video Block')),
            OutlinedButton.icon(onPressed: () => onAdd(ProjectContentType.carousel), icon: const Icon(Icons.view_carousel_outlined), label: const Text('Carousel Block')),
            OutlinedButton.icon(onPressed: () => onAdd(ProjectContentType.imageStack), icon: const Icon(Icons.layers_outlined), label: const Text('Image Stack')),
            OutlinedButton.icon(onPressed: () => onAdd(ProjectContentType.quote), icon: const Icon(Icons.format_quote_outlined), label: const Text('Quote Block')),
          ],
        ),
        const SizedBox(height: 10),
        if (content.isEmpty)
          const Text('No content blocks yet. Add blocks above to build a Behance-like project flow.'),
        for (int i = 0; i < content.length; i++)
          _ContentBlockEditor(
            key: ValueKey('block-$i-${content[i].type.label}'),
            index: i,
            block: content[i],
            onChanged: (b) => onUpdate(i, b),
            onDelete: () => onDelete(i),
          ),
      ],
    );
  }
}

class _ContentBlockEditor extends StatefulWidget {
  final int index;
  final ProjectContentBlock block;
  final ValueChanged<ProjectContentBlock> onChanged;
  final VoidCallback onDelete;

  const _ContentBlockEditor({
    super.key,
    required this.index,
    required this.block,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_ContentBlockEditor> createState() => _ContentBlockEditorState();
}

class _ContentBlockEditorState extends State<_ContentBlockEditor> {
  late final TextEditingController _title;
  late final TextEditingController _body;
  late final TextEditingController _url;
  late final TextEditingController _images;
  late bool _overlap;
  late double _margin;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.block.title);
    _body = TextEditingController(text: widget.block.body);
    _url = TextEditingController(text: widget.block.url ?? '');
    _images = TextEditingController(text: widget.block.images.join('\n'));
    _overlap = widget.block.overlapImages;
    _margin = widget.block.baseMargin;
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _url.dispose();
    _images.dispose();
    super.dispose();
  }

  void _emit() {
    widget.onChanged(
      ProjectContentBlock(
        type: widget.block.type,
        title: _title.text.trim(),
        body: _body.text.trim(),
        url: _url.text.trim().isEmpty ? null : _url.text.trim(),
        images: _images.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        overlapImages: _overlap,
        baseMargin: _margin,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Block ${widget.index + 1}: ${widget.block.type.label}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: widget.onDelete, icon: const Icon(Icons.delete_outline)),
              ],
            ),
            if (widget.block.type == ProjectContentType.text || widget.block.type == ProjectContentType.quote) ...[
              _Field(controller: _title, label: 'Title/Author'),
              const SizedBox(height: 8),
              _Field(controller: _body, label: 'Text', maxLines: 3),
            ],
            if (widget.block.type == ProjectContentType.video) ...[
              _Field(controller: _title, label: 'Section title'),
              const SizedBox(height: 8),
              _Field(controller: _url, label: 'Video URL'),
            ],
            if (widget.block.type == ProjectContentType.carousel || widget.block.type == ProjectContentType.imageStack) ...[
              _Field(controller: _images, label: 'Image URLs (one per line)', maxLines: 4),
              const SizedBox(height: 8),
              if (widget.block.type == ProjectContentType.imageStack) ...[
                SwitchListTile(
                  value: _overlap,
                  title: const Text('Overlap images (Behance style)'),
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setState(() => _overlap = v),
                ),
                Text('Base margin: ${_margin.toStringAsFixed(0)}'),
                Slider(min: 0, max: 40, value: _margin, onChanged: (v) => setState(() => _margin = v)),
              ],
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(onPressed: _emit, child: const Text('Update Block')),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceEditorTile extends StatefulWidget {
  final Experience item;
  final int index;
  final ValueChanged<Experience> onChanged;
  final VoidCallback onDelete;

  const _ExperienceEditorTile({
    super.key,
    required this.item,
    required this.index,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_ExperienceEditorTile> createState() => _ExperienceEditorTileState();
}

class _ExperienceEditorTileState extends State<_ExperienceEditorTile> {
  late final TextEditingController _role;
  late final TextEditingController _company;
  late final TextEditingController _location;
  late final TextEditingController _period;
  late final TextEditingController _highlights;

  @override
  void initState() {
    super.initState();
    _role = TextEditingController(text: widget.item.role);
    _company = TextEditingController(text: widget.item.company);
    _location = TextEditingController(text: widget.item.location);
    _period = TextEditingController(text: widget.item.period);
    _highlights = TextEditingController(text: widget.item.highlights.join('\n'));
  }

  @override
  void dispose() {
    _role.dispose();
    _company.dispose();
    _location.dispose();
    _period.dispose();
    _highlights.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text('Experience ${widget.index + 1}: ${widget.item.role}'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          _Field(controller: _role, label: 'Role'),
          const SizedBox(height: 10),
          _Field(controller: _company, label: 'Company'),
          const SizedBox(height: 10),
          _Field(controller: _location, label: 'Location'),
          const SizedBox(height: 10),
          _Field(controller: _period, label: 'Period'),
          const SizedBox(height: 10),
          _Field(controller: _highlights, label: 'Highlights (one per line)', maxLines: 4),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(onPressed: widget.onDelete, icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  widget.onChanged(
                    Experience(
                      role: _role.text.trim(),
                      company: _company.text.trim(),
                      location: _location.text.trim(),
                      period: _period.text.trim(),
                      highlights: _highlights.text
                          .split('\n')
                          .map((line) => line.trim())
                          .where((line) => line.isNotEmpty)
                          .toList(),
                    ),
                  );
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
