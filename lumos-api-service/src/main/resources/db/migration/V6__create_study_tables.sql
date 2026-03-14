CREATE TABLE learning_card_states (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES user_accounts (id),
    flashcard_id BIGINT NOT NULL REFERENCES flashcards (id),
    box_index INTEGER NOT NULL,
    last_reviewed_at TIMESTAMP WITH TIME ZONE NULL,
    next_review_at TIMESTAMP WITH TIME ZONE NOT NULL,
    last_result VARCHAR(32) NOT NULL,
    consecutive_success_count INTEGER NOT NULL DEFAULT 0,
    lapse_count INTEGER NOT NULL DEFAULT 0,
    deleted_at TIMESTAMP WITH TIME ZONE NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uk_learning_card_state_user_flashcard UNIQUE (user_id, flashcard_id)
);

CREATE TABLE user_speech_preferences (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES user_accounts (id) UNIQUE,
    enabled BOOLEAN NOT NULL,
    auto_play BOOLEAN NOT NULL,
    voice VARCHAR(120) NOT NULL,
    speed DOUBLE PRECISION NOT NULL,
    locale VARCHAR(20) NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE study_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES user_accounts (id),
    deck_id BIGINT NOT NULL REFERENCES decks (id),
    session_type VARCHAR(32) NOT NULL,
    mode_plan VARCHAR(120) NOT NULL,
    current_mode_index INTEGER NOT NULL,
    active_mode VARCHAR(32) NOT NULL,
    mode_state VARCHAR(32) NOT NULL,
    current_item_index INTEGER NOT NULL,
    session_completed BOOLEAN NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    version BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE study_session_items (
    id BIGSERIAL PRIMARY KEY,
    study_session_id BIGINT NOT NULL REFERENCES study_sessions (id),
    flashcard_id BIGINT NOT NULL REFERENCES flashcards (id),
    sequence_index INTEGER NOT NULL,
    front_text_snapshot VARCHAR(255) NOT NULL,
    back_text_snapshot VARCHAR(255) NOT NULL,
    note_snapshot VARCHAR(255) NOT NULL,
    pronunciation_snapshot VARCHAR(255) NOT NULL,
    last_outcome VARCHAR(32) NOT NULL,
    current_mode_completed BOOLEAN NOT NULL,
    retry_pending BOOLEAN NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    version BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT uk_study_session_items_session_sequence UNIQUE (study_session_id, sequence_index)
);

CREATE TABLE study_attempts (
    id BIGSERIAL PRIMARY KEY,
    study_session_id BIGINT NOT NULL REFERENCES study_sessions (id),
    flashcard_id BIGINT NOT NULL REFERENCES flashcards (id),
    study_mode VARCHAR(32) NOT NULL,
    review_outcome VARCHAR(32) NOT NULL,
    submitted_answer VARCHAR(255) NULL,
    deleted_at TIMESTAMP WITH TIME ZONE NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    version BIGINT NOT NULL DEFAULT 0
);
