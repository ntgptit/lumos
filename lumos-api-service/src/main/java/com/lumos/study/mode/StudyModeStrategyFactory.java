package com.lumos.study.mode;

import java.util.EnumMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.lumos.study.enums.StudyMode;

@Component
public class StudyModeStrategyFactory {

    private final Map<StudyMode, StudyModeStrategy> strategiesByMode;

    public StudyModeStrategyFactory(List<StudyModeStrategy> strategies) {
        final Map<StudyMode, StudyModeStrategy> nextStrategiesByMode = new EnumMap<>(StudyMode.class);
        // Register each injected strategy under the mode it owns so lookup stays O(1) at runtime.
        for (StudyModeStrategy strategy : strategies) {
            nextStrategiesByMode.put(strategy.getStudyMode(), strategy);
        }
        this.strategiesByMode = Map.copyOf(nextStrategiesByMode);
    }

    public StudyModeStrategy getStrategy(StudyMode studyMode) {
        final StudyModeStrategy strategy = this.strategiesByMode.get(studyMode);
        // Return the registered strategy immediately when the mode has a mapped implementation.
        if (strategy != null) {
            // Return the mode strategy that owns the behavior for the requested study mode.
            return strategy;
        }
        // Fail fast because the session cannot execute a mode that has no registered strategy.
        throw new IllegalStateException("Missing StudyModeStrategy for mode: " + studyMode);
    }
}
