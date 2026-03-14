package com.lumos.study.mode;

import java.util.EnumMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.lumos.study.enums.StudyMode;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class StudyModeStrategyFactory {

    private final List<StudyModeStrategy> strategies;

    private Map<StudyMode, StudyModeStrategy> strategiesByMode;

    @PostConstruct
    void initializeStrategiesByMode() {
        final Map<StudyMode, StudyModeStrategy> nextStrategiesByMode = new EnumMap<>(StudyMode.class);
        // Register each injected strategy under the mode it owns so lookup stays O(1) at runtime.
        for (StudyModeStrategy strategy : strategies) {
            nextStrategiesByMode.put(strategy.getStudyMode(), strategy);
        }
        this.strategiesByMode = Map.copyOf(nextStrategiesByMode);
    }

    public StudyModeStrategy getStrategy(StudyMode studyMode) {
        // Rebuild the lookup lazily when the factory is instantiated directly in unit tests outside Spring.
        if (this.strategiesByMode == null) {
            // Initialize the strategy lookup so direct constructor usage still behaves like the managed bean.
            initializeStrategiesByMode();
        }
        final StudyModeStrategy strategy = this.strategiesByMode.get(studyMode);
        // Return the registered strategy immediately when the mode has a mapped implementation.
        if (strategy != null) {
            // Return the mode strategy that owns the behavior for the requested study mode.
            return strategy;
        }
        // backend-guard: allow-technical-literal
        // Fail fast with a technical invariant message because this factory error is for operator debugging, not client payload localization.
        throw new IllegalStateException("Missing StudyModeStrategy for mode: " + studyMode);
    }
}
