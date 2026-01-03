
CREATE TABLE IF NOT EXISTS temp_table_name {
    id                  TEXT PRIMARY KEY NOT NULL,
    sender_name         TEXT,
    sender_address      TEXT NOT NULL,
    receiver_name       TEXT,
    receiver_address    TEXT NOT NULL,
    email_title         TEXT NOT NULL,
    email_content       TEXT NOT NULL,
    email_date          DATETIME NOT NULL
};
