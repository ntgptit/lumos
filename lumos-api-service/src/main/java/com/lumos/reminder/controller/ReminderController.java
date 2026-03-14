package com.lumos.reminder.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lumos.reminder.dto.response.ReminderSummaryResponse;
import com.lumos.reminder.service.ReminderService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

/**
 * Reminder endpoints for due and overdue study prompts.
 */
@Validated
@RestController
@RequiredArgsConstructor
@Tag(name = "Reminder", description = "Reminder APIs")
public class ReminderController {

    private final ReminderService reminderService;

    /**
     * Return the reminder summary for the current user.
     *
     * @return reminder summary response
     */
    @Operation(summary = "Get reminder summary")
    @GetMapping("/api/v1/study/reminders/summary")
    public ResponseEntity<ReminderSummaryResponse> getReminderSummary() {
        final var response = this.reminderService.getReminderSummary();
        // Return the reminder summary so the client can show due and overdue study prompts.
        return ResponseEntity.ok(response);
    }
}
