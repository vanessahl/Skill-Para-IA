# Test 04

## Input

```sql
SELECT id, email
FROM users
WHERE email = 'test@example.com';
```

Contexto: no se proporcionan esquema, índices, cardinalidad, frecuencia ni plan.

## Expected behavior

No afirmar que falta un índice. Si se comenta el filtro, emitir como máximo PERF-004 `INFO` con `INSUFFICIENT_CONTEXT`, solicitando índices existentes, cardinalidad, frecuencia y plan. `INFO` por sí solo mantiene `ACCEPTABLE`.

## Actual behavior

Not executed in an independent skill runtime.
Expected behavior documented for manual/Red Team validation.

## Pass / Fail

NOT EXECUTED — expected result defined.

## Problem detected

No se puede determinar con la información disponible si un índice existe, es necesario o sería beneficioso.

## Modification made to the skill

Se incorporó la política `INSUFFICIENT_CONTEXT` y se limitó PERF-004 a una observación condicionada.
