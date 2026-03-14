package com.lumos.study.constant;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.time.Duration;

import org.junit.jupiter.api.Test;

class StudyConstantsTest {

    @Test
    void intervalForBox_returnsConfiguredIntervals() {
        assertEquals(Duration.ofHours(12), StudyConstants.intervalForBox(1));
        assertEquals(Duration.ofDays(1), StudyConstants.intervalForBox(2));
        assertEquals(Duration.ofDays(3), StudyConstants.intervalForBox(3));
        assertEquals(Duration.ofDays(7), StudyConstants.intervalForBox(4));
        assertEquals(Duration.ofDays(14), StudyConstants.intervalForBox(5));
        assertEquals(Duration.ofDays(30), StudyConstants.intervalForBox(6));
        assertEquals(Duration.ofDays(60), StudyConstants.intervalForBox(7));
    }
}
