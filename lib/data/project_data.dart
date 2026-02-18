import '../models/project.dart';

/// Replace these with real projects (Behance links, case studies, etc.)
const projects = <Project>[
  Project(
    slug: 'broadcast-motion-pack',
    title: 'Broadcast Motion Pack',
    subtitle: 'Lower-thirds, stingers, transitions, and typography system.',
    category: 'Motion',
    tags: ['After Effects', 'Typography', 'Broadcast'],
    link: 'https://www.behance.net/',
    publishedAt: DateTime(2025, 2, 12, 14, 30),
    detailIntro:
        'A complete broadcast graphics toolkit built for speed, consistency, and high visual impact across daily news segments.',
    galleryImages: [
      'https://images.unsplash.com/photo-1460925895917-afdab827c52f',
      'https://images.unsplash.com/photo-1518770660439-4636190af475',
      'https://images.unsplash.com/photo-1498050108023-c5249f4df085',
    ],
    videoUrl: 'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
    content: [
      ProjectContentBlock(
        type: ProjectContentType.text,
        title: 'Project Context',
        body: 'We needed a motion system that could be reused by multiple editors without losing visual quality.',
      ),
      ProjectContentBlock(
        type: ProjectContentType.imageStack,
        images: [
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f',
          'https://images.unsplash.com/photo-1518770660439-4636190af475',
        ],
        overlapImages: true,
        baseMargin: 0,
      ),
      ProjectContentBlock(
        type: ProjectContentType.video,
        title: 'Motion Preview',
        url: 'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
      ),
    ],
  ),
  Project(
    slug: 'magazine-editorial-system',
    title: 'Magazine Editorial System',
    subtitle: 'Grid, hierarchy, master pages and print-ready workflow.',
    category: 'Print',
    tags: ['InDesign', 'Layout', 'Pre-Press'],
    link: 'https://www.behance.net/',
    publishedAt: DateTime(2024, 11, 4, 10, 0),
    detailIntro:
        'An editorial framework for long-form magazine production including cover system, article templates, and ad-safe layout zones.',
    galleryImages: [
      'https://images.unsplash.com/photo-1455390582262-044cdead277a',
      'https://images.unsplash.com/photo-1481627834876-b7833e8f5570',
      'https://images.unsplash.com/photo-1507842217343-583bb7270b66',
    ],
    content: [
      ProjectContentBlock(
        type: ProjectContentType.text,
        title: 'Editorial Goal',
        body: 'Define a readable and premium layout language that scales across 50+ pages per issue.',
      ),
      ProjectContentBlock(
        type: ProjectContentType.carousel,
        images: [
          'https://images.unsplash.com/photo-1455390582262-044cdead277a',
          'https://images.unsplash.com/photo-1481627834876-b7833e8f5570',
          'https://images.unsplash.com/photo-1507842217343-583bb7270b66',
        ],
      ),
      ProjectContentBlock(
        type: ProjectContentType.quote,
        body: 'A strong grid gives creative freedom because the system already solves consistency.',
        title: 'Design Principle',
      ),
    ],
  ),
  Project(
    slug: 'brand-kit-for-startup',
    title: 'Brand Kit for Startup',
    subtitle: 'Logo, color system, social templates, and guidelines.',
    category: 'Branding',
    tags: ['Illustrator', 'Identity', 'Guidelines'],
    link: 'https://www.behance.net/',
    publishedAt: DateTime(2024, 7, 18, 16, 45),
    detailIntro:
        'A brand identity system designed to keep marketing teams visually aligned across web, social, and print touchpoints.',
    galleryImages: [
      'https://images.unsplash.com/photo-1561070791-2526d30994b5',
      'https://images.unsplash.com/photo-1558655146-9f40138edfeb',
      'https://images.unsplash.com/photo-1545239351-1141bd82e8a6',
    ],
  ),
  Project(
    slug: 'social-media-campaign',
    title: 'Social Media Campaign',
    subtitle: 'A modular template system for fast content production.',
    category: 'Social',
    tags: ['Photoshop', 'Templates', 'Content'],
    link: 'https://www.behance.net/',
    publishedAt: DateTime(2024, 3, 22, 9, 15),
    detailIntro:
        'A fast-turnaround campaign template suite built for daily publishing and strong brand recognition on social feeds.',
    galleryImages: [
      'https://images.unsplash.com/photo-1460925895917-afdab827c52f',
      'https://images.unsplash.com/photo-1510511459019-5dda7724fd87',
      'https://images.unsplash.com/photo-1461749280684-dccba630e2f6',
    ],
  ),
  Project(
    slug: 'ux-micro-case-study',
    title: 'UX Micro-case Study',
    subtitle: 'Wireframes + usability notes for a small product screen.',
    category: 'UX',
    tags: ['Figma', 'UX', 'Wireframes'],
    link: 'https://www.behance.net/',
    publishedAt: DateTime(2023, 12, 9, 13, 0),
    detailIntro:
        'A compact UX case study showing research assumptions, low-fidelity flow, and usability improvements after iteration.',
    galleryImages: [
      'https://images.unsplash.com/photo-1559028012-481c04fa702d',
      'https://images.unsplash.com/photo-1545239351-1141bd82e8a6',
      'https://images.unsplash.com/photo-1518773553398-650c184e0bb3',
    ],
  ),
];
