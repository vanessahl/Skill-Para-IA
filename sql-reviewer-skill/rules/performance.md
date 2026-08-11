# Performance rules

No afirmar tamaños, índices ni planes inexistentes. Expresar impacto condicionado cuando falte contexto.

| ID | Descripción | Condición | Severidad | Justificación y recomendación | Límites |
|---|---|---|---|---|---|
| PERF-001 | `SELECT *` | Proyección `*` o `alias.*` | MEDIUM | Transfiere columnas innecesarias y acopla al esquema. Enumerar solo columnas requeridas. | Puede ser aceptable en exploración; no inventar costo concreto. |
| PERF-002 | Consulta potencialmente masiva sin límite | `SELECT` sin `LIMIT`/equivalente y sin evidencia suficiente de resultado acotado | INFO | Podría devolver muchas filas. Confirmar cardinalidad/objetivo y paginar si corresponde. | Agregados sin agrupación, búsquedas por clave conocida o procesos batch pueden no necesitar límite. |
| PERF-003 | Límite excesivamente grande | Límite tan grande que no proporciona una cota operativa significativa, p. ej. `1000000000` | MEDIUM | Puede comportarse como consulta masiva. Elegir límite según caso de uso y volumen. | No existe umbral universal; justificar por magnitud/contexto y usar INFO si es ambiguo. |
| PERF-004 | Índice potencialmente relevante | Columna frecuente de filtro, unión u orden sin información de índices | INFO | `INSUFFICIENT_CONTEXT`: podría beneficiarse de índice, pero no puede confirmarse sin índices, cardinalidad, frecuencia y plan. Revisar esos datos. | Nunca afirmar “falta un índice” sin evidencia del esquema. |
| PERF-005 | Función sobre columna filtrada *(regla adicional del equipo)* | Función/transformación sobre columna en `WHERE`, p. ej. `LOWER(email)=...` | MEDIUM | Puede impedir un índice ordinario. Considerar normalización previa, comparación sargable o índice funcional compatible. | Depende de motor e índices; degradar a INFO si no puede confirmarse. |
| PERF-006 | Ordenación potencialmente costosa | `ORDER BY` sobre conjunto potencialmente grande sin evidencia de soporte | INFO | Puede requerir ordenación y memoria. Revisar cardinalidad, índices y plan. | No asumir costo alto solo por existir `ORDER BY`. |
| PERF-007 | Unión potencialmente costosa | `JOIN` sin condición (`CROSS JOIN` implícito) o con condición ausente/evidentemente universal | HIGH | Puede producir producto cartesiano. Agregar condición correcta o confirmar intención. | Un `CROSS JOIN` explícito e intencional sigue mereciendo revisión; un JOIN normal no activa por sí solo. |
| PERF-008 | Predicado no sargable por comodín inicial *(regla adicional del equipo)* | `LIKE '%texto'` o `LIKE '%texto%'` | INFO | Un índice convencional puede no ayudar. Revisar requisito, motor, índice y plan. | No es incorrecto si la búsqueda contiene es requerida. |

`SELECT * FROM TA_USERS LIMIT 1000000000` activa PERF-001 y PERF-003; puede activar PERF-002 solo si la regla se expresa como riesgo masivo general sin duplicar PERF-003. Conservar problemas distintos y evitar dos hallazgos sobre la misma falta de cota efectiva.
