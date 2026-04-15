import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/portfolio_provider.dart';
import '../widgets/hero_section.dart';
import '../widgets/projects_section.dart';

/// The single home page of the portfolio.
///
/// Renders a full-height [HeroSection] followed by the [ProjectsSection]
/// inside a [SingleChildScrollView].  A [ScrollController] is used to
/// smoothly scroll to the projects section when the CTA button is tapped.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _projectsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Trigger the data fetch after the first frame so the Provider tree is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PortfolioProvider>().fetchProjects();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToProjects() {
    final ctx = _projectsKey.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeroSection(onViewProjects: _scrollToProjects),
            ProjectsSection(key: _projectsKey),
            // Footer breathing room
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
