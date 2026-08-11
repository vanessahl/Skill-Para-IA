SELECT id, username, email
FROM users
WHERE active = TRUE
ORDER BY username
LIMIT 50;

UPDATE users
SET last_login_at = CURRENT_TIMESTAMP
WHERE id = :user_id;

DELETE FROM sessions
WHERE expires_at < CURRENT_TIMESTAMP;

SELECT id, email
FROM users
WHERE deleted_at IS NULL
  AND id = :user_id;
