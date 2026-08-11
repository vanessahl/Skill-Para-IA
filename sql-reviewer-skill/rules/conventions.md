# Convention rules

Aplicar convenciones sin imponer un estilo de dialecto inexistente.

| ID | Descripción | Condición | Severidad | Justificación y recomendación | Límites |
|---|---|---|---|---|---|
| CONV-001 | Comparación incorrecta con `NULL` | `= NULL`, `<> NULL` o `!= NULL` | HIGH | En SQL produce `UNKNOWN`, no la prueba esperada. Usar `IS NULL` o `IS NOT NULL`. | Operadores específicos del motor deben evaluarse con dialecto conocido. |
| CONV-002 | Nombre poco descriptivo | Identificador genérico como `data`, `value`, `temp` sin contexto suficiente | LOW | Reduce legibilidad. Elegir nombre orientado al dominio. | No juzgar nombres heredados sin contexto; usar INFO si la ambigüedad no es clara. |
| CONV-003 | Convenciones inconsistentes | Mezcla evidente de estilos para objetos equivalentes dentro del mismo fragmento | LOW | Dificulta mantenimiento. Adoptar el estándar del proyecto. | No imponer `snake_case`, mayúsculas u otro estilo sin estándar proporcionado. |
| CONV-004 | Alias confuso *(regla adicional del equipo)* | Alias de una letra en consulta compleja, duplicado o semánticamente engañoso | LOW | Aumenta riesgo de referenciar la fuente equivocada. Usar alias breves pero descriptivos. | Alias `u` en una consulta simple puede ser suficientemente claro. |
| CONV-005 | Nombre ambiguo | Columna no calificada que existe conceptualmente en varias tablas de una unión | MEDIUM | Puede ser ambigua o referir una fuente inesperada. Calificar con alias. | Solo confirmar cuando el texto/esquema demuestra la ambigüedad; de otro modo usar INFO. |
| CONV-006 | Tipo de datos cuestionable | DDL demuestra incompatibilidad, pérdida de precisión o longitud insuficiente para un valor/uso declarado | MEDIUM | Puede truncar o representar mal datos. Elegir tipo según dominio y motor. | Sin dominio, motor o valores, usar `INFO`/`INSUFFICIENT_CONTEXT`; no afirmar error. |

Ejemplos deterministas:

```sql
-- Incorrecto
WHERE deleted_at = NULL
-- Correcto
WHERE deleted_at IS NULL

-- Incorrecto
WHERE deleted_at <> NULL
-- Correcto
WHERE deleted_at IS NOT NULL
```
