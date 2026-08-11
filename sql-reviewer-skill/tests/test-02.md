# Test 02

## Input

```sql
SELECT * FROM users;
DELETE FROM users;
UPDATE users SET role = 'ADMIN';
SELECT id FROM users WHERE deleted_at = NULL;
```

## Expected behavior

Emitir PERF-001 (MEDIUM), PERF-002 (INFO cuando proceda), SEC-001 (CRITICAL), SEC-002 (CRITICAL) y CONV-001 (HIGH), sin fusionar problemas diferentes. Recomendar `DO_NOT_EXECUTE`.

## Actual behavior

Not executed in an independent skill runtime.
Expected behavior documented for manual/Red Team validation.

## Pass / Fail

NOT EXECUTED — expected result defined.

## Problem detected

Múltiples infracciones de rendimiento, seguridad y semántica de `NULL`.

## Modification made to the skill

Se definieron análisis por sentencia, coexistencia de reglas y conteo sin duplicados.
