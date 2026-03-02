CREATE TABLE IF NOT EXISTS decks (
    id BIGSERIAL PRIMARY KEY,
    folder_id BIGINT NOT NULL REFERENCES folders(id),
    name VARCHAR(120) NOT NULL,
    description VARCHAR(400) NOT NULL DEFAULT '',
    flashcard_count INTEGER NOT NULL DEFAULT 0,
    deleted_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    version BIGINT NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_decks_folder_id ON decks(folder_id);
CREATE INDEX IF NOT EXISTS idx_decks_deleted_at ON decks(deleted_at);
CREATE UNIQUE INDEX IF NOT EXISTS uq_decks_folder_name_active ON decks(folder_id, LOWER(name))
WHERE deleted_at IS NULL;
