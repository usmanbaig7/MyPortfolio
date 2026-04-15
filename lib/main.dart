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
      short: 'A full-featured shopping app with cart and payment.',
      full:
          'A comprehensive e-commerce application built with Flutter featuring '
              'product browsing, cart management, Stripe payment integration, and '
              'real-time order tracking.  Supports iOS, Android, and Web from a '
              'single codebase with over 10 000 monthly active users.',
      stack: ['Flutter', 'Dart', 'Azure', 'Stripe', 'Hive'],
      live: 'https://example.com/ecommerce',
      github: 'https://github.com/johndoe/ecommerce',
    ),
    (
      id: '2',
      title: 'Lincsell POS Lite',
      short: 'Productivity app with drag-and-drop Kanban boards.',
      full:
          'A productivity-focused task manager featuring Kanban boards with '
              'drag-and-drop support, deadline reminders, team collaboration spaces, '
              'and an analytics dashboard.  Built with Flutter and a Node.js REST '
              'API, with real-time sync via WebSockets.',
      stack: ['Flutter', 'Dart', 'Azure', 'Stripe', 'Hive'],
      live: 'https://example.com/taskmanager',
      github: 'https://github.com/johndoe/taskmanager',
    ),
    (
      id: '3',
      title: 'Customers App',
      short: 'Real-time weather forecasting with beautiful animations.',
      full:
          'A weather dashboard that provides real-time forecasts, hourly and '
              'weekly breakdowns, air-quality index, and severe-weather alerts.  '
              'Powered by the OpenWeatherMap API with a clean, animated UI built '
              'entirely in Flutter using Riverpod and Hive for offline caching.',
      stack: ['Flutter', 'Dart','Azure', 'Provider', 'Hive'],
      live: 'https://example.com/weather',
      github: 'https://github.com/johndoe/weather',
    ),
    (
      id: '4',
      title: 'Managers App',
      short: 'Instagram-style social media app for content creators.',
      full:
          'A social media application for creators to share photos, short videos, '
              'and stories.  Features an algorithmic feed powered by Algolia, '
              'real-time notifications, direct messaging, and detailed creator '
              'analytics — all backed by Firebase.',
      stack: ['Flutter', 'Dart', 'Azure', 'Hive'],
      live: 'https://example.com/socialfeed',
      github: 'https://github.com/johndoe/socialfeed',
    ),
  ];

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

