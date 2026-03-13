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
        allowedActions ?? const <String>['MARK_REMEMBERED', 'RETRY_ITEM'],
    progress: const StudyProgressSummary(
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
      speech: const SpeechCapability(
        enabled: true,
        autoPlay: false,
        available: true,
        locale: 'ko-KR',
        voice: 'ko-KR-neutral',
        speed: 1,
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
  }) : _session = session ?? sampleStudySession(),
       _reminder = reminder ?? sampleReminderSummary(),
       _analytics = analytics ?? sampleAnalyticsOverview(),
       _preference = preference ?? sampleSpeechPreference();

  StudySessionData _session;
  final StudyReminderSummary _reminder;
  final StudyAnalyticsOverview _analytics;
  SpeechPreference _preference;

  int? lastDeckId;
  int? lastSessionId;
  String? lastAnswer;
  SpeechPreference? lastPreference;

  @override
  Future<StudySessionData> startSession({required int deckId}) async {
    lastDeckId = deckId;
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
  Future<StudySessionData> revealAnswer({required int sessionId}) async {
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
    lastSessionId = sessionId;
    return _session = sampleStudySession(
      sessionId: sessionId,
      activeMode: _session.activeMode,
      modeState: 'RETRY_PENDING',
      allowedActions: const <String>['GO_NEXT'],
    );
  }

  @override
  Future<StudySessionData> goNext({required int sessionId}) async {
    lastSessionId = sessionId;
    return _session = sampleStudySession(
      sessionId: sessionId,
      activeMode: 'MATCH',
      modeState: 'IN_PROGRESS',
      allowedActions: const <String>['SUBMIT_ANSWER'],
    );
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
}
