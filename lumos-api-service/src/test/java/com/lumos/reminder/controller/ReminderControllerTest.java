package com.lumos.reminder.controller;

import static com.lumos.testkit.StudyTestFixtures.studyReminderSummaryResponse;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.lumos.reminder.service.ReminderService;

@ExtendWith(MockitoExtension.class)
class ReminderControllerTest {

    @Mock
    private ReminderService reminderService;

    @InjectMocks
    private ReminderController reminderController;

    @Test
    void getReminderSummary_returnsOkResponse() {
        final var response = studyReminderSummaryResponse();
        when(this.reminderService.getReminderSummary()).thenReturn(response);

        final var entity = this.reminderController.getReminderSummary();

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }
}
