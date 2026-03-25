import 'package:workjournel/models/log_entry.dart';

class LogsViewModel {
  LogEntry? _selectedLog;

  LogEntry? get selectedLog => _selectedLog;
  bool get hasSelection => _selectedLog != null;

  final List<LogEntry> logs = const [
    LogEntry(
      id: '1',
      title: 'Completed MVP Sprint Review',
      subtitle: 'Reviewed all tasks and closed 12 tickets with the team.',
      date: 'Today, 10:32 AM',
      body:
          'We had an outstanding sprint review session today. The team walked through every ticket in the sprint and we successfully closed 12 out of 14 items. The remaining 2 are being carried over due to a third-party API dependency that was delayed.\n\nKey wins:\n• Auth flow is fully polished and tested\n• Onboarding screens are approved by design\n• CI/CD pipeline is now green on all branches\n\nNext sprint kicks off Monday. Going to focus on the AI journaling core and the export feature.',
      tags: ['work', 'sprint', 'mvp'],
    ),
    LogEntry(
      id: '2',
      title: 'Deep focus session — AI feature brainstorming',
      subtitle: 'Spent 3 hours mapping out the AI summary engine architecture.',
      date: 'Today, 8:15 AM',
      body:
          'Blocked off the morning for deep work. No meetings, no Slack. Just me, a coffee, and a whiteboard session on the AI summary engine.\n\nExplored two approaches:\n1. Real-time streaming summaries after each log entry\n2. Batch summarization at end-of-day\n\nLanding on a hybrid — immediate lightweight summary on save, with a richer daily digest generated overnight. This balances perceived speed with API cost.\n\nAlso prototyped a tagging model using a few-shot GPT prompt. Results are surprisingly accurate on test entries.',
      tags: ['ai', 'architecture', 'focus'],
    ),
    LogEntry(
      id: '3',
      title: 'Design sync — Figma handoff done',
      subtitle: 'All screens approved. Dev handoff notes added to each frame.',
      date: 'Yesterday, 3:45 PM',
      body:
          'Had a productive 45-minute design sync with the designer. All 14 screens have been approved and the Figma file is now in dev handoff mode.\n\nEvery frame has:\n• Annotated spacing tokens\n• Component states (default, hover, active, disabled)\n• Dark mode only confirmed — no light mode for now\n\nStarting implementation of the remaining screens tomorrow. The home dashboard will be the most complex due to the card grid and animated streak counter.',
      tags: ['design', 'handoff', 'figma'],
    ),
    LogEntry(
      id: '4',
      title: 'Fixed critical auth bug in prod',
      subtitle: 'Token refresh loop was causing silent logouts after 1 hour.',
      date: 'Yesterday, 11:20 AM',
      body:
          'Got a report from a beta tester that they were being logged out randomly. Dug into the logs and found a token refresh race condition — when two requests fired simultaneously near token expiry, both tried to refresh, one succeeded and the other got a 401, which triggered a logout.\n\nFix: Added a mutex lock around the refresh logic so only one request can refresh at a time. All others queue behind it.\n\nDeployed to prod at 11:05 AM. Monitoring error rates for the next 2 hours.',
      tags: ['bug', 'auth', 'prod'],
    ),
    LogEntry(
      id: '5',
      title: 'Weekly retrospective with co-founder',
      subtitle: 'Aligned on priorities for Q2 and shipped goals for April.',
      date: 'Mon, Mar 17, 9:00 AM',
      body:
          'Weekly 1-on-1 with co-founder. We spent an hour reviewing where we are against Q1 targets and planning Q2.\n\nQ1 recap:\n• MVP shipped ✓\n• 50 beta users onboarded ✓\n• Revenue: \$0 (expected at this stage)\n\nQ2 priorities:\n1. Reach 500 active users by end of April\n2. Launch Pro tier with AI features\n3. First paying customer milestone\n\nFeeling motivated. Clear direction, aligned team.',
      tags: ['strategy', 'retro', 'q2'],
    ),
    LogEntry(
      id: '6',
      title: 'Onboarding flow UX improvements',
      subtitle: 'Reduced steps from 7 to 4 based on user feedback.',
      date: 'Mon, Mar 17, 2:30 PM',
      body:
          'Analysed session recordings from the first 30 beta users. Drop-off was highest at step 4 (permissions screen) and step 6 (profile setup).\n\nChanges made:\n• Merged permission request into context of first log entry\n• Removed mandatory profile photo (optional now)\n• Simplified goal-setting to a single dropdown instead of multi-select\n• Added progress indicator so users know how far they are\n\nNew flow: Welcome → Privacy → First Log → Home. Down from 7 steps to 4. Going to A/B test this next week.',
      tags: ['ux', 'onboarding', 'improvement'],
    ),
    LogEntry(
      id: '7',
      title: 'Infrastructure cost audit',
      subtitle:
          'Identified 40% savings by optimising Supabase and storage tiers.',
      date: 'Fri, Mar 14, 4:00 PM',
      body:
          'Did a full infrastructure cost audit. Current monthly spend is around \$180 at our current scale.\n\nFindings:\n• Supabase: Overspending on realtime subscriptions that aren\'t being used — disabled them, saving ~\$30/mo\n• Storage: Profile photos being stored in full resolution — added resize on upload, reduces storage 60%\n• Functions: Cold start times causing timeout retries — migrated hot paths to edge functions\n\nProjected new monthly cost: ~\$108. 40% reduction. Will revisit when we hit 1000 users.',
      tags: ['infrastructure', 'cost', 'optimisation'],
    ),
    LogEntry(
      id: '8',
      title: 'Shipped streak feature',
      subtitle:
          'Users can now see their daily logging streak with a visual tracker.',
      date: 'Thu, Mar 13, 6:15 PM',
      body:
          'Shipped the streak feature to beta today. Users can now see how many consecutive days they\'ve logged.\n\nImplementation details:\n• Streak is calculated server-side at log creation time\n• Stored in user profile as streak_count + last_log_date\n• Reset logic: if last_log_date < today - 1 day, streak resets to 0 on next log\n• UI: Flame icon with animated counter on the home dashboard\n\nEarly feedback is very positive. Users are already talking about maintaining streaks in the beta community.',
      tags: ['feature', 'gamification', 'shipped'],
    ),
  ];

  void selectLog(LogEntry log) => _selectedLog = log;
  void clearSelection() => _selectedLog = null;
}
