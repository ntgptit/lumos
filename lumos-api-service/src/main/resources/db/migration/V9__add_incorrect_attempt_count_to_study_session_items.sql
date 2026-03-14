ALTER TABLE study_session_items
    ADD COLUMN incorrect_attempt_count INTEGER NOT NULL DEFAULT 0;
