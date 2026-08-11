# Test 03

## Input

```sql
DELETE FROM users WHERE 1 = 1;
```

## Expected behavior

Detectar SEC-003 (CRITICAL) aunque exista `WHERE`; clasificar como `CONFIRMED_PROBLEM` y recomendar `DO_NOT_EXECUTE`. No duplicar como SEC-001.

## Actual behavior

Not executed in an independent skill runtime.
Expected behavior documented for manual/Red Team validation.

## Pass / Fail

NOT EXECUTED — expected result defined.

## Problem detected

Predicado universal que evade una comprobación superficial de presencia de `WHERE`.

## Modification made to the skill

Se formalizó SEC-003 y la prioridad de la regla específica frente a la ausencia efectiva de restricción.
