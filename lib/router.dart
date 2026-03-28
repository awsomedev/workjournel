import 'package:go_router/go_router.dart';
import 'package:workjournel/screens/splash_screen.dart';
import 'package:workjournel/screens/welcome_screen.dart';
import 'package:workjournel/screens/privacy_screen.dart';
import 'package:workjournel/screens/logs_screen.dart';
import 'package:workjournel/screens/brag_doc_screen.dart';
import 'package:workjournel/screens/chat_screen.dart';
import 'package:workjournel/screens/settings_screen.dart';
import 'package:workjournel/screens/model_selection_screen.dart';
import 'package:workjournel/screens/main_shell.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => const PrivacyScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/chat',
              builder: (context, state) => const ChatScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/logs',
              builder: (context, state) => const LogsScreen(),
              routes: [
                GoRoute(
                  path: 'brag',
                  builder: (context, state) => const BragDocScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: 'models',
                  builder: (context, state) => const ModelSelectionScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
