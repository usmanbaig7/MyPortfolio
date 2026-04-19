import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/portfolio/data/datasources/portfolio_local_datasource.dart';
import 'features/portfolio/data/models/project_model.dart';
import 'features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'features/portfolio/domain/entities/project_entity.dart';
import 'features/portfolio/domain/usecases/get_projects_usecase.dart';
import 'features/portfolio/presentation/providers/portfolio_provider.dart';
import 'features/portfolio/presentation/screens/home_screen.dart';
import 'features/portfolio/presentation/screens/project_detail_screen.dart';

// ── Entry point ───────────────────────────────────────────────────────────────

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive — uses IndexedDB on web, file-system on native.
  await Hive.initFlutter();

  // Register the generated TypeAdapter before opening any box.
  Hive.registerAdapter(ProjectModelAdapter());

  // Open the projects box.
  final projectsBox = await Hive.openBox<ProjectModel>(
    PortfolioLocalDatasource.boxName,
  );

  // Seed 5 dummy projects on first launch.
  if (projectsBox.isEmpty) {
    await _seedDummyData(projectsBox);
  }

  runApp(const PortfolioApp());
}

/// Seeds 5 representative dummy projects into the Hive box on first run.
Future<void> _seedDummyData(Box<ProjectModel> box) async {
  const projects = [
    (
      id: '1',
      title: 'Lincsell POS',
      short: 'A modern POS system designed to help small businesses manage sales efficiently and seamlessly. It streamlines transactions, inventory, and payments in one intuitive platform.',
      full:
          'Lincsell POS is a modern point-of-sale solution built to help small '
              'and medium-sized businesses manage their daily sales operations '
              'efficiently. It provides a seamless checkout experience while '
              'handling inventory, payments, and transaction tracking in a single '
              'platform. The app is designed with performance, scalability, and '
              'ease of use in mind, making it suitable for real-world retail '
              'environments.\n\n'
              'Key Development Strategies & Technologies:\n\n'
              '• State Management: Implemented using Provider for efficient and '
              'scalable state handling across the app.\n'
              '• API Integration: Integrated REST APIs to manage dynamic data '
              'such as products, sales, and user information.\n'
              '• Third-Party Integrations: Connected external SDKs including '
              'Stripe for secure payments and printing services for receipts.\n'
              '• Clean Architecture: Structured the project using clean '
              'architecture principles to ensure maintainability, scalability, '
              'and separation of concerns.\n'
              '• Backend Integration: Developed and integrated Azure APIs to '
              'securely fetch and manage data from the server.',
      stack: ['Flutter', 'Dart', 'Azure', 'Stripe', 'Hive'],
      live: 'https://example.com/ecommerce',
      github: 'https://github.com/johndoe/ecommerce',
    ),
    (
      id: '2',
      title: 'Lincsell POS Lite',
      short: 'A lightweight POS solution that enables business owners to manage and complete sales from anywhere. Designed for flexibility, it removes the need for a fixed physical store.',
      full:
          'Lincsell POS Lite is a lightweight and flexible point-of-sale solution '
              'designed for business owners who need to manage sales beyond a fixed '
              'location. It enables seamless transactions on the go, making it ideal '
              'for small businesses, mobile vendors, and startups. With a simplified '
              'feature set, the app focuses on speed, usability, and accessibility '
              'while maintaining reliable performance.\n\n'
              'Key Development Strategies & Technologies:\n\n'
              '• State Management: Utilized Provider for efficient and responsive '
              'state handling across the application.\n'
              '• API Integration: Connected REST APIs to manage core functionalities '
              'such as sales and basic product data.\n'
              '• Third-Party Integrations: Integrated essential SDKs including '
              'Stripe for secure payment processing.\n'
              '• Clean Architecture: Followed clean architecture principles to keep '
              'the codebase modular and easy to maintain.\n'
              '• Backend Integration: Implemented Azure APIs for secure and scalable '
              'data communication with the server.',
      stack: ['Flutter', 'Dart', 'Azure', 'Stripe', 'Hive'],
      live: 'https://example.com/taskmanager',
      github: 'https://github.com/johndoe/taskmanager',
    ),
    (
      id: '3',
      title: 'Customers App',
      short: 'A customer-focused app that helps users discover nearby stores and explore the latest offers. It also includes a loyalty system where users earn and redeem points on purchases.',
      full:
          'The customer app is designed to enhance the shopping experience by '
              'helping users discover nearby stores and explore ongoing offers with '
              'ease. It provides a seamless way to stay connected with local '
              'businesses while benefiting from exclusive deals. With an integrated '
              'loyalty system, users can earn reward points on purchases and redeem '
              'them for future benefits, encouraging long-term engagement.\n\n'
              'Key Development Strategies & Technologies:\n\n'
              '• State Management: Implemented using Provider for smooth and '
              'efficient UI updates.\n'
              '• API Integration: Integrated REST APIs to fetch store data, offers, '
              'and user-related information dynamically.\n'
              '• Map & Location Services: Integrated map services to display nearby '
              'stores and enable users to view locations visually on the map.\n'
              '• Loyalty System: Developed a reward points mechanism to track and '
              'redeem customer benefits.\n'
              '• Clean Architecture: Structured the app with clean architecture for '
              'scalability and maintainability.\n'
              '• Backend Integration: Connected with Azure APIs to securely manage '
              'user data and transactions.',
      stack: ['Flutter', 'Dart','Azure', 'Provider', 'Hive'],
      live: 'https://example.com/weather',
      github: 'https://github.com/johndoe/weather',
    ),
    (
      id: '4',
      title: 'Managers App',
      short: 'A manager-focused app for capturing, scanning, and uploading receipts to the server. It provides a secure and organized way to store and access transaction records.',
      full:
          'The Managers App for Family Thrift Store is designed to make receipt '
              'management more accurate, organized, and fully digital. It allows '
              'managers to capture receipt images and upload them directly to the '
              'server for secure backup. The app also ensures better document '
              'quality by using a built-in scanning system that guides users to '
              'properly align receipts within a defined boundary before capturing '
              'the image. This helps avoid unclear or improperly taken photos. In '
              'addition, managers can easily view, manage, and access all uploaded '
              'receipts anytime, improving record keeping and operational '
              'efficiency.\n\n'
              'Key Development Strategies & Technologies:\n\n'
              '• State Management: Implemented using Provider for smooth and '
              'responsive UI updates across camera, scanning, upload, and receipt '
              'viewing modules.\n'
              '• API Integration: Integrated REST APIs to upload receipt images, '
              'fetch stored documents, and manage categorized receipt data.\n'
              '• Camera Integration: Enabled direct receipt capture using the '
              'device camera for quick and easy digital submission.\n'
              '• Guided Scanning System: Implemented a boundary-based scanner that '
              'only allows image capture when the receipt is properly aligned within '
              'the frame, ensuring high-quality uploads.\n'
              '• Cloud Storage: All receipts are securely uploaded and stored on '
              'the server for backup and long-term access.\n'
              '• Receipt Management Module: Provides functionality to view, search, '
              'and organize all uploaded receipts in a structured system.\n'
              '• Clean Architecture: Built with scalable clean architecture to '
              'ensure maintainability and future feature expansion.\n'
              '• Backend Integration: Connected with secure Azure-based APIs for '
              'reliable data handling and centralized storage.',
      stack: ['Flutter', 'Dart', 'Azure', 'Hive'],
      live: 'https://example.com/socialfeed',
      github: 'https://github.com/johndoe/socialfeed',
    ),
  ];

  // YouTube video IDs for projects that have demo videos.
  // Only pass the ID from the URL (the part after ?v=).
  // e.g. https://www.youtube.com/watch?v=usYvBFd0Kqc  →  'usYvBFd0Kqc'
  const youtubeVideoIds = <String, String>{
    '1': 'bwLbVmHPdM4', // Lincsell POS
    '2': 'usYvBFd0Kqc', // Lincsell POS Lite
    '4': '9Oc1LDQPMu8', // Managers App
  };

  for (final p in projects) {
    await box.put(
      p.id,
      ProjectModel(
        id: p.id,
        title: p.title,
        shortDescription: p.short,
        fullDescription: p.full,
        techStack: List<String>.from(p.stack),
        imageUrl: 'https://picsum.photos/seed/${p.id}/600/400',
        liveUrl: p.live,
        githubUrl: p.github,
        youtubeVideoId: youtubeVideoIds[p.id],
      ),
    );
  }
}

// ── Router ────────────────────────────────────────────────────────────────────

/// GoRouter configuration.
///
/// Two routes:
///   /              → [HomeScreen]
///   /project/:id   → [ProjectDetailScreen] (receives [ProjectEntity] as extra)
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/project/:id',
      builder: (context, state) {
        final project = state.extra as ProjectEntity;
        return ProjectDetailScreen(project: project);
      },
    ),
  ],
);

// ── Root widget ───────────────────────────────────────────────────────────────

/// Root application widget.
///
/// Wires up [MultiProvider] with all required providers before handing
/// control to [MaterialApp.router].  Dependencies are created inside
/// [ChangeNotifierProvider.create] so they are lazily instantiated once
/// and never recreated on rebuilds.
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PortfolioProvider>(
          create: (_) {
            final datasource = PortfolioLocalDatasource();
            final repository = PortfolioRepositoryImpl(datasource);
            final usecase = GetProjectsUsecase(repository);
            return PortfolioProvider(usecase);
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Usman Baig | Flutter Developer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: _router,
      ),
    );
  }
}

