import 'package:lumos/domain/entities/auth/auth_models.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/domain/repositories/auth/auth_repository.dart';
import 'package:lumos/domain/repositories/study/study_repository.dart';

AuthSession sampleAuthSession({
  int userId = 7,
  String username = 'tester',
  String email = 'tester@mail.com',
}) {
  return AuthSession(
    user: AuthUser(
      id: userId,
      username: username,
      email: email,
      accountStatus: 'ACTIVE',
    ),
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    expiresIn: 900,
    authenticated: true,
  );
}

StudySessionData sampleStudySession({
  int sessionId = 33,
  int deckId = 10,
  String deckName = 'Korean Basics',
  String activeMode = 'REVIEW',
  String modeState = 'IN_PROGRESS',
  List<String>? allowedActions,
  StudyProgressSummary? progress,
}) {
  return StudySessionData(
    sessionId: sessionId,
    deckId: deckId,
    deckName: deckName,
    sessionType: 'FIRST_LEARNING',
    activeMode: activeMode,
    modeState: modeState,
    modePlan: const <String>['REVIEW', 'MATCH', 'GUESS', 'RECALL', 'FILL'],
    allowedActions:
        allowedActions ??
        const <String>['MARK_REMEMBERED', 'RETRY_ITEM', 'RESET_CURRENT_MODE'],
    progress:
        progress ??
        const StudyProgressSummary(
          completedItems: 1,
          totalItems: 2,
          completedModes: 0,
          totalModes: 5,
          itemProgress: 0.5,
          modeProgress: 0,
          sessionProgress: 0.1,
        ),
    currentItem: StudySessionItemData(
      flashcardId: 101,
      prompt: '안녕하세요',
      answer: 'xin chao',
      note: 'note',
      pronunciation: 'annyeonghaseyo',
      instruction: 'Reveal the answer, then confirm if you remembered it.',
      inputPlaceholder: '',
      choices: const <StudyChoice>[
        StudyChoice(id: 'choice-0', label: 'xin chao'),
      ],
      matchPairs: const <StudyMatchPair>[
        StudyMatchPair(
          leftId: 'left-101',
          leftLabel: '안녕하세요',
          rightId: 'right-101',
          rightLabel: 'xin chao',
        ),
      ],
      speech: const SpeechCapability(
        enabled: true,
        autoPlay: false,
        available: true,
        locale: 'ko-KR',
        voice: 'ko-KR-neutral',
        speed: 1,
        fieldName: 'prompt',
        sourceType: 'text',
        audioUrl: '',
        allowedActions: <String>['play_speech', 'replay_speech'],
        speechText: '안녕하세요',
      ),
    ),
    sessionCompleted: false,
  );
}

StudyReminderSummary sampleReminderSummary() {
  return const StudyReminderSummary(
    dueCount: 4,
    overdueCount: 2,
    escalationLevel: 'LEVEL_1',
    reminderTypes: <String>[
      'IN_APP_BADGE_DUE_LIST',
      'DUE_BASED_SESSION_RECOMMENDATION',
    ],
    recommendation: ReminderRecommendation(
      deckId: 10,
      deckName: 'Korean Basics',
      dueCount: 4,
      overdueCount: 2,
      estimatedSessionMinutes: 1,
      recommendedSessionType: 'REVIEW',
    ),
  );
}

StudyAnalyticsOverview sampleAnalyticsOverview() {
  return const StudyAnalyticsOverview(
    totalLearnedItems: 12,
    dueCount: 4,
    overdueCount: 2,
    passedAttempts: 9,
    failedAttempts: 3,
    boxDistribution: <int, int>{1: 3, 2: 4, 3: 5},
  );
}

SpeechPreference sampleSpeechPreference() {
  return const SpeechPreference(
    enabled: true,
    autoPlay: false,
    voice: 'ko-KR-neutral',
    speed: 1,
    locale: 'ko-KR',
  );
}

StudyPreference sampleStudyPreference({int firstLearningCardLimit = 20}) {
  return StudyPreference(firstLearningCardLimit: firstLearningCardLimit);
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.bootstrapResult,
    AuthSession? loginResult,
    AuthSession? registerResult,
    this.loginError,
    this.registerError,
    this.logoutError,
  }) : _loginResult = loginResult ?? sampleAuthSession(),
       _registerResult = registerResult ?? sampleAuthSession();

  AuthSession? bootstrapResult;
  final AuthSession _loginResult;
  final AuthSession _registerResult;
  Object? loginError;
  Object? registerError;
  Object? logoutError;

  int logoutCallCount = 0;
  String? lastIdentifier;
  String? lastPassword;
  String? lastUsername;
  String? lastEmail;

  @override
  Future<AuthSession?> bootstrapSession() async {
    return bootstrapResult;
  }

  @override
  Future<AuthSession> login({
    required String identifier,
    required String password,
  }) async {
    lastIdentifier = identifier;
    lastPassword = password;
    if (loginError != null) {
      throw loginError!;
    }
    return _loginResult;
  }

  @override
  Future<AuthSession> register({
    required String username,
    required String email,
    required String password,
  }) async {
    lastUsername = username;
    lastEmail = email;
    lastPassword = password;
    if (registerError != null) {
      throw registerError!;
    }
    return _registerResult;
  }

  @override
  Future<void> logout() async {
    logoutCallCount += 1;
    if (logoutError != null) {
      throw logoutError!;
    }
  }
}

class FakeStudyRepository implements StudyRepository {
  FakeStudyRepository({
    StudySessionData? session,
    StudyReminderSummary? reminder,
    StudyAnalyticsOverview? analytics,
    SpeechPreference? preference,
    StudyPreference? studyPreference,
    this.actionDelay = Duration.zero,
  }) : _session = session ?? sampleStudySession(),
       _reminder = reminder ?? sampleReminderSummary(),
       _analytics = analytics ?? sampleAnalyticsOverview(),
       _preference = preference ?? sampleSpeechPreference(),
       _studyPreference = studyPreference ?? sampleStudyPreference();

  StudySessionData _session;
  final StudyReminderSummary _reminder;
  final StudyAnalyticsOverview _analytics;
  SpeechPreference _preference;
  StudyPreference _studyPreference;
  final Duration actionDelay;

  int? lastDeckId;
  int? lastSessionId;
  String? lastAnswer;
  SpeechPreference? lastPreference;
  StudyPreference? lastStudyPreference;
  int resetCurrentModeCallCount = 0;
  int resetDeckProgressCallCount = 0;
  StudySessionTypeOption? lastPreferredSessionType;

  @override
  Future<StudySessionData> startSession({
    required int deckId,
    StudySessionTypeOption? preferredSessionType,
  }) async {
    lastDeckId = deckId;
    lastPreferredSessionType = preferredSessionType;
    return _session;
  }

  @override
  Future<StudySessionData> resumeSession({required int sessionId}) async {
    lastSessionId = sessionId;
    return _session;
  }

  @override
  Future<StudySessionData> submitAnswer({
    required int sessionId,
    required String answer,
  }) async {
    await _delayAction();
    lastSessionId = sessionId;
    lastAnswer = answer;
    return _session = sampleStudySession(
      sessionId: sessionId,
      activeMode: _session.activeMode,
      modeState: 'WAITING_FEEDBACK',
      allowedActions: const <String>['GO_NEXT'],
    );
  }

  @override
  Future<StudySessionData> submitMatchedPairs({
    required int sessionId,
    required List<StudyMatchSubmission> matchedPairs,
  }) async {
    await _delayAction();
    lastSessionId = sessionId;
    return _session = sampleStudySession(
      sessionId: sessionId,
      activeMode: 'MATCH',
      modeState: 'WAITING_FEEDBACK',
      allowedActions: const <String>['GO_NEXT'],
    );
  }

  @override
  Future<StudySessionData> revealAnswer({required int sessionId}) async {
    await _delayAction();
    lastSessionId = sessionId;
    return _session = sampleStudySession(
      sessionId: sessionId,
      activeMode: _session.activeMode,
      modeState: 'WAITING_FEEDBACK',
      allowedActions: const <String>['MARK_REMEMBERED', 'RETRY_ITEM'],
    );
  }

  @override
  Future<StudySessionData> markRemembered({required int sessionId}) async {
    await _delayAction();
    lastSessionId = sessionId;
    return _session = sampleStudySession(
      sessionId: sessionId,
      activeMode: _session.activeMode,
      modeState: 'WAITING_FEEDBACK',
      allowedActions: const <String>['GO_NEXT'],
    );
  }

  @override
  Future<StudySessionData> retryItem({required int sessionId}) async {
    await _delayAction();
    lastSessionId = sessionId;
    return _session = sampleStudySession(
      sessionId: sessionId,
      activeMode: _session.activeMode,
      modeState: 'WAITING_FEEDBACK',
      allowedActions: const <String>['GO_NEXT'],
    );
  }

  @override
  Future<StudySessionData> goNext({required int sessionId}) async {
    await _delayAction();
    lastSessionId = sessionId;
    final List<String> modePlan = _session.modePlan;
    final int currentModeIndex = modePlan.indexOf(_session.activeMode);
    final bool hasNextMode =
        currentModeIndex >= 0 && currentModeIndex < modePlan.length - 1;
    if (!hasNextMode) {
      return _session = sampleStudySession(
        sessionId: sessionId,
        activeMode: _session.activeMode,
        modeState: 'COMPLETED',
        allowedActions: const <String>[],
      );
    }
    final String nextMode = modePlan[currentModeIndex + 1];
    return _session = sampleStudySession(
      sessionId: sessionId,
      activeMode: nextMode,
      modeState: 'INITIALIZED',
      allowedActions: const <String>['SUBMIT_ANSWER'],
    );
  }

  @override
  Future<StudySessionData> resetCurrentMode({required int sessionId}) async {
    await _delayAction();
    lastSessionId = sessionId;
    resetCurrentModeCallCount += 1;
    return _session = sampleStudySession(
      sessionId: sessionId,
      activeMode: _session.activeMode,
      modeState: 'INITIALIZED',
      allowedActions: const <String>[
        'MARK_REMEMBERED',
        'RETRY_ITEM',
        'RESET_CURRENT_MODE',
      ],
    );
  }

  @override
  Future<void> resetDeckProgress({required int deckId}) async {
    lastDeckId = deckId;
    resetDeckProgressCallCount += 1;
  }

  @override
  Future<StudyReminderSummary> getReminderSummary() async {
    return _reminder;
  }

  @override
  Future<StudyAnalyticsOverview> getAnalyticsOverview() async {
    return _analytics;
  }

  @override
  Future<SpeechPreference> getSpeechPreference() async {
    return _preference;
  }

  @override
  Future<SpeechPreference> updateSpeechPreference({
    required SpeechPreference preference,
  }) async {
    lastPreference = preference;
    _preference = preference;
    return _preference;
  }

  @override
  Future<StudyPreference> getStudyPreference() async {
    return _studyPreference;
  }

  @override
  Future<StudyPreference> updateStudyPreference({
    required StudyPreference preference,
  }) async {
    lastStudyPreference = preference;
    _studyPreference = preference;
    return _studyPreference;
  }

  Future<void> _delayAction() async {
    if (actionDelay <= Duration.zero) {
      return;
    }
    await Future<void>.delayed(actionDelay);
  }
}
