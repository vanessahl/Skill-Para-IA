SELECT * FROM users;

DELETE FROM users;

UPDATE users
SET role = 'ADMIN';

SELECT id
FROM users
WHERE deleted_at = NULL;

SELECT u.id
FROM users u
JOIN orders o ON 1 = 1;

ALTER TABLE customers DROP COLUMN email;

SELECT id
FROM users
WHERE LOWER(email) = LOWER(:email);
