import 'package:flutter/widgets.dart';

import '../data/experience_data.dart';
import '../data/project_data.dart';
import '../models/experience.dart';
import '../models/project.dart';

class PortfolioState extends ChangeNotifier {
  String homePill = 'Graphic Design • Motion • Video';
  String homeHeadline = 'Design that feels cinematic\n— and works like a system.';
  String homeDescription =
      'I build clean, high-impact visuals for broadcast, print, and social media — with strong typography, clear hierarchy, and motion that supports the story.';
  String homeCalloutTitle = 'Want a quick portfolio view?';
  String homeCalloutDescription =
      'Open Projects to see curated work buckets. You can replace placeholders with your Behance case studies anytime.';

  String contactEmail = 'elian445ka@gmail.com';
  String contactPhone = '+963951371814';
  String contactLinkedin = 'https://www.linkedin.com/in/eliankadar';
  String contactBehance = 'https://www.behance.net/eliankadar/';

  List<Project> projectItems = List<Project>.from(projects);
  List<Experience> experienceItems = List<Experience>.from(experiences);

  void updateHome({
    required String pill,
    required String headline,
    required String description,
    required String calloutTitle,
    required String calloutDescription,
  }) {
    homePill = pill;
    homeHeadline = headline;
    homeDescription = description;
    homeCalloutTitle = calloutTitle;
    homeCalloutDescription = calloutDescription;
    notifyListeners();
  }

  void updateContact({
    required String email,
    required String phone,
    required String linkedin,
    required String behance,
  }) {
    contactEmail = email;
    contactPhone = phone;
    contactLinkedin = linkedin;
    contactBehance = behance;
    notifyListeners();
  }

  void updateProjects(List<Project> updated) {
    projectItems = updated;
    notifyListeners();
  }

  void updateExperiences(List<Experience> updated) {
    experienceItems = updated;
    notifyListeners();
  }
}

class PortfolioStateScope extends InheritedNotifier<PortfolioState> {
  const PortfolioStateScope({
    super.key,
    required PortfolioState state,
    required super.child,
  }) : super(notifier: state);

  static PortfolioState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PortfolioStateScope>();
    assert(scope != null, 'PortfolioStateScope is missing in widget tree.');
    return scope!.notifier!;
  }
}
