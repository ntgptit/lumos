CREATE TABLE IF NOT EXISTS flashcards (
    id BIGSERIAL PRIMARY KEY,
    deck_id BIGINT NOT NULL REFERENCES decks(id),
    front_text VARCHAR(300) NOT NULL,
    back_text VARCHAR(2000) NOT NULL,
    front_lang_code VARCHAR(16) NULL,
    back_lang_code VARCHAR(16) NULL,
    pronunciation VARCHAR(400) NOT NULL DEFAULT '',
    note VARCHAR(1000) NOT NULL DEFAULT '',
    is_bookmarked BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    version BIGINT NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_flashcards_deck_id ON flashcards(deck_id);
CREATE INDEX IF NOT EXISTS idx_flashcards_deleted_at ON flashcards(deleted_at);
CREATE INDEX IF NOT EXISTS idx_flashcards_front_text_lower ON flashcards(LOWER(front_text));
