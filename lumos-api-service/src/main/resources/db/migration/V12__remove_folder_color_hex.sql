ALTER TABLE folders
    DROP CONSTRAINT IF EXISTS chk_folders_color_hex;

ALTER TABLE folders
    DROP COLUMN IF EXISTS color_hex;
