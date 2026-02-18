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
                    const Project(title: 'New Project', subtitle: 'Project summary', category: 'General', tags: ['Tag']),
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

  const _Field({required this.controller, required this.label, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
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
  late final TextEditingController _title;
  late final TextEditingController _subtitle;
  late final TextEditingController _category;
  late final TextEditingController _tags;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.project.title);
    _subtitle = TextEditingController(text: widget.project.subtitle);
    _category = TextEditingController(text: widget.project.category);
    _tags = TextEditingController(text: widget.project.tags.join(', '));
  }

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    _category.dispose();
    _tags.dispose();
    super.dispose();
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
          _Field(controller: _category, label: 'Category'),
          const SizedBox(height: 10),
          _Field(controller: _tags, label: 'Tags (comma separated)'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(onPressed: widget.onDelete, icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  widget.onChanged(
                    Project(
                      title: _title.text.trim(),
                      subtitle: _subtitle.text.trim(),
                      category: _category.text.trim(),
                      tags: _tags.text
                          .split(',')
                          .map((tag) => tag.trim())
                          .where((tag) => tag.isNotEmpty)
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
