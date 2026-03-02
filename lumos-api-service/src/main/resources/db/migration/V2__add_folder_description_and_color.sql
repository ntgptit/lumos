ALTER TABLE folders
    ADD COLUMN IF NOT EXISTS description VARCHAR(400) NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS color_hex VARCHAR(9) NOT NULL DEFAULT '#4F46E5';

ALTER TABLE folders
    ADD CONSTRAINT chk_folders_color_hex
    CHECK (color_hex ~* '^#([0-9A-F]{6}|[0-9A-F]{8})$');
