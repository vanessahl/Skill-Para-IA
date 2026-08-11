# Test 01

## Input

```sql
SELECT id, username
FROM users
WHERE id = :user_id
LIMIT 1;
```

## Expected behavior

No producir problemas confirmados ni advertencias artificiales. Resumen en cero y `ACCEPTABLE`. No afirmar que existe o falta un índice.

## Actual behavior

Not executed in an independent skill runtime.
Expected behavior documented for manual/Red Team validation.

## Pass / Fail

NOT EXECUTED — expected result defined.

## Problem detected

Ninguno esperado con la información disponible.

## Modification made to the skill

Se explicitó que `INFO` de índice no debe emitirse indiscriminadamente y que una consulta acotada no requiere problemas artificiales.
