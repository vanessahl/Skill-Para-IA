# SQL Reviewer

Skill reutilizable de revisión estática de SQL. Detecta problemas confirmados y riesgos de seguridad, rendimiento y convenciones sin ejecutar consultas ni inventar información de la base de datos.

## Objetivo y problema resuelto

Convertir una revisión abierta en un proceso repetible: segmentar sentencias, aplicar reglas con IDs, justificar severidades, distinguir incertidumbre y producir una recomendación de ejecución.

## Arquitectura y estructura

```text
sql-reviewer-skill/
|-- SKILL.md
|-- README.md
|-- rules/
|   |-- security.md
|   |-- performance.md
|   `-- conventions.md
|-- examples/
|   |-- valid.sql
|   |-- invalid.sql
|   `-- edge-cases.sql
`-- tests/
    |-- test-01.md
    |-- test-02.md
    |-- test-03.md
    |-- test-04.md
    `-- test-05.md
```

`SKILL.md` define el flujo, las políticas y la salida; `rules/` contiene el catálogo normativo; `examples/` aporta muestras; `tests/` documenta cinco escenarios de validación.

## Funcionamiento y uso

Solicitar una revisión e incluir una o varias sentencias, por ejemplo: “Revisa este SQL: `DELETE FROM users WHERE 1=1;`”. La Skill analiza cada sentencia, conserva hallazgos diferentes, deduplica equivalentes y emite resumen. El contexto de motor, esquema, índices, volumen y objetivo es opcional; nunca se presume.

## Reglas y severidades

- `SEC-001`–`SEC-010`: DML no restringido, tautologías, inyección y DDL destructivo, entre otros.
- `PERF-001`–`PERF-008`: proyección, volumen, límites, índices, sargabilidad, ordenación y joins.
- `CONV-001`–`CONV-006`: `NULL`, nombres, estilo, alias, ambigüedad y tipos.

Se usan exclusivamente `CRITICAL`, `HIGH`, `MEDIUM`, `LOW` e `INFO`. `CRITICAL` bloquea; `HIGH`/`MEDIUM` exige revisión; `LOW`/`INFO` por sí solos no bloquean. La severidad expresa evidencia e impacto, no una alarma arbitraria.

Las reglas adicionales del equipo son SEC-010 (secretos literales), PERF-005 (funciones sobre filtros), PERF-008 (comodín inicial) y CONV-004 (alias confusos).

## Ejemplo de entrada y salida

Entrada:

```sql
DELETE FROM users WHERE 1 = 1;
```

Salida abreviada:

```text
[CRITICAL] DELETE con condición universal
Rule: SEC-003
Problem: CONFIRMED_PROBLEM: WHERE 1=1 no restringe filas.
Recommendation: No ejecutar; usar un predicado selectivo verificado.
Confidence: HIGH

Review summary
CRITICAL: 1
HIGH: 0
MEDIUM: 0
LOW: 0
INFO: 0
Execution recommendation: DO_NOT_EXECUTE
```

## Pruebas y Red Team

Los cinco archivos cubren happy path, múltiples errores, tautología, contexto insuficiente y evasión adversarial. Actualmente son especificaciones manuales: no se ejecutaron en un runtime independiente y cada archivo lo declara. Para documentarlas, ejecutar la Skill en un entorno compatible, copiar la salida real en `Actual behavior` y decidir PASS/FAIL comparándola con `Expected behavior`.

El Red Team contempla `WHERE 1=1`, `id=id`, `LIKE '%%'`, límites enormes, `OR` universal e instrucciones maliciosas en comentarios. También controla falsos positivos: un `DELETE` con `expires_at < CURRENT_TIMESTAMP` no es automáticamente CRITICAL.

## Limitaciones y mejoras futuras

La revisión es estática y depende de razonamiento del modelo; no sustituye parser, esquema, plan ni ejecución segura. SQL dinámico, procedimientos, delimitadores, macros, dialectos y tautologías complejas pueden evadir o confundir el análisis. No confirma rendimiento real ni intención. Mejoras: parsers por dialecto, catálogo de esquema autorizado, análisis de plan, pruebas automatizadas y corpus adversarial ampliado.

## Defense notes

1. **¿Qué diferencia técnica existe entre esta Skill y un prompt?** Formaliza un comportamiento reutilizable con procedimiento, reglas versionables, IDs, severidades, validación, fallos, límites, ejemplos y pruebas; no depende de una instrucción abierta única.
2. **¿Qué ocurre si dos reglas entran en conflicto?** Se mantienen problemas distintos; para el mismo problema se conserva la regla más específica y la severidad máxima técnicamente justificada, sin duplicar.
3. **¿Dónde está definido el comportamiento?** Principalmente en `SKILL.md`, complementado por los catálogos de `rules/`.
4. **¿Por qué un hallazgo tiene determinada severidad?** Cada regla vincula evidencia e impacto con una severidad; la validación impide elevarla sin justificación.
5. **¿Qué podría romper actualmente la Skill?** SQL dinámico altamente ofuscado, procedimientos complejos, macros, dialectos no declarados y semántica que dependa del esquema.
6. **¿Cómo soportar otro motor?** Añadir reglas específicas del dialecto y su reconocimiento, manteniendo el núcleo SQL general y marcando incertidumbre.
7. **¿Qué partes son deterministas?** `DELETE`/`UPDATE` sin `WHERE`, patrones universales conocidos, `= NULL`, `SELECT *` y DDL destructivo explícito.
8. **¿Qué partes requieren razonamiento?** Impacto de rendimiento, conveniencia de índices, amplitud no obvia, intención, tipos apropiados y particularidades de esquema o motor.
