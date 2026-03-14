ALTER TABLE learning_card_states
    ALTER COLUMN last_result DROP NOT NULL;

ALTER TABLE study_session_items
    ALTER COLUMN last_outcome DROP NOT NULL;
