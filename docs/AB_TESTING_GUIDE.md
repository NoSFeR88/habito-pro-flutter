# 🔬 A/B TESTING FRAMEWORK - GUÍA COMPLETA

**Versión**: 1.0.0
**Fecha**: 2025-10-08
**Estado**: ✅ OPERACIONAL

---

## 🎯 OBJETIVO

Sistema completo de A/B testing para optimizar el proceso de desarrollo basado en datos estadísticos rigurosos, permitiendo:

- ✅ Comparar diferentes enfoques de desarrollo (templates vs manual, caching vs no-cache)
- ✅ Medir impacto real en tokens, tiempo y calidad
- ✅ Tomar decisiones basadas en evidencia estadística
- ✅ Auto-adoptar mejores prácticas cuando hay significancia

---

## 📊 ARQUITECTURA DEL SISTEMA

### **Componentes**

```
┌─────────────────────────────────────────────────────────┐
│           A/B TESTING FRAMEWORK                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. CONFIGURATION (experiments.json)                   │
│     - Define experiment                                │
│     - Specify variants                                 │
│     - Set metrics to track                             │
│                                                         │
│  2. EXECUTION (run-experiment.py)                      │
│     - Assign variant randomly                          │
│     - Log constraints to follow                        │
│     - Start execution tracking                         │
│                                                         │
│  3. COMPLETION (complete-experiment.py)                │
│     - Record metrics                                   │
│     - Save results                                     │
│     - Update execution log                             │
│                                                         │
│  4. ANALYSIS (analyze-experiment.py)                   │
│     - Statistical tests (t-test)                       │
│     - Effect size (Cohen's d)                          │
│     - Determine winner                                 │
│     - Generate recommendations                         │
│                                                         │
│  5. ADOPTION (auto-adopt-winner.py)                    │
│     - Auto-adopt if significant                        │
│     - Create documentation                             │
│     - Update defaults                                  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🚀 WORKFLOW PASO A PASO

### **PASO 1: Configurar Experimento**

**Archivo**: `telemetry/experiments/experiments.json`

Los experimentos están pre-configurados. Revisa con:

```bash
python scripts/run-experiment.py --list-experiments
```

**Ejemplo de experimento**:
```json
{
  "experiment_id": "exp-001-workflow-templates",
  "name": "Workflow Templates vs Manual Development",
  "variants": [
    {
      "id": "template",
      "name": "Using Workflow Template",
      "constraints": {
        "must_read_template": true,
        "follow_structure": true
      }
    },
    {
      "id": "manual",
      "name": "Manual Development",
      "constraints": {
        "no_template": true,
        "organic_approach": true
      }
    }
  ],
  "metrics": [
    {"name": "tokens_used", "target": "minimize"},
    {"name": "duration_minutes", "target": "minimize"},
    {"name": "quality_score", "target": "maximize"}
  ],
  "sample_size": 10
}
```

---

### **PASO 2: Ejecutar Experimento**

Cuando tengas una tarea, ejecuta:

```bash
python scripts/run-experiment.py --experiment exp-001-workflow-templates --task "Fix bug in habit provider"
```

**Output**:
```
================================================================
EXPERIMENT EXECUTION STARTED
================================================================

Execution ID: exec-20251008-230000-1234
Experiment: Workflow Templates vs Manual Development
Variant Assigned: Using Workflow Template (template)
Task: Fix bug in habit provider

================================================================
CONSTRAINTS TO FOLLOW:
================================================================

  - Must Read Template: True
  - Follow Structure: True
  - Use Optimized Bootstrap: True

================================================================
METRICS TO TRACK:
================================================================

  - tokens_used (tokens) - minimize
  - duration_minutes (minutes) - minimize
  - quality_score (0-10) - maximize

================================================================
NEXT STEPS:
================================================================

1. Execute task following variant constraints
2. Record metrics during execution
3. Run: python scripts/complete-experiment.py --execution exec-20251008-230000-1234
```

---

### **PASO 3: Ejecutar Tarea Siguiendo Constraints**

**Si variant = "template"**:
1. ✅ Leer `docs/WORKFLOW_TEMPLATES.md`
2. ✅ Seguir estructura exacta del template
3. ✅ Usar `optimized-bootstrap.ps1` para cargar contexto
4. ✅ Seguir best practices del template

**Si variant = "manual"**:
1. ✅ NO leer template
2. ✅ Desarrollar orgánicamente según experiencia
3. ✅ Usar enfoque intuitivo

---

### **PASO 4: Completar y Registrar Métricas**

Al terminar la tarea:

```bash
python scripts/complete-experiment.py --execution exec-20251008-230000-1234 --tokens 5000 --duration 30 --quality 9 --bugs 0
```

**Output**:
```
================================================================
EXECUTION COMPLETED
================================================================

Execution ID: exec-20251008-230000-1234
Experiment: exp-001-workflow-templates
Variant: Using Workflow Template (template)

Recorded Metrics:
  - Tokens Used: 5000
  - Duration Minutes: 30
  - Quality Score: 9
  - Bugs Introduced: 0

================================================================
NEXT STEPS:
================================================================

1. Continue with more samples or
2. Run analysis: python scripts/analyze-experiment.py --experiment exp-001-workflow-templates
```

---

### **PASO 5: Analizar Resultados** (después de 10+ samples)

```bash
python scripts/analyze-experiment.py --experiment exp-001-workflow-templates --export-report
```

**Output**:
```
================================================================================
A/B TESTING STATISTICAL ANALYSIS
================================================================================

Experiment: Workflow Templates vs Manual Development
ID: exp-001-workflow-templates
Total Samples: 10

Variant A: template (n=5)
Variant B: manual (n=5)

================================================================================
METRIC ANALYSIS
================================================================================

Metric: tokens_used (tokens) - Target: minimize
  Variant A (template): mean=5200.00, std=450.00
  Variant B (manual): mean=12000.00, std=1200.00
  t-statistic: -5.234, p-value: 0.01
  Cohen's d: -2.150 (large)
  Winner: template (56.7% improvement)
  Significant: YES (p < 0.05)

Metric: duration_minutes (minutes) - Target: minimize
  Variant A (template): mean=28.00, std=4.00
  Variant B (manual): mean=45.00, std=8.00
  t-statistic: -4.567, p-value: 0.01
  Cohen's d: -1.890 (large)
  Winner: template (37.8% improvement)
  Significant: YES (p < 0.05)

================================================================================
RECOMMENDATION
================================================================================

AUTO-ADOPTION RECOMMENDED
  - Found significant results (p < 0.01)
  - Large effect size (d >= 0.5)
  - Sample size: 10/10

Action: Adopt winning variant as default
```

---

### **PASO 6: Auto-Adoptar Ganador** (si recomendado)

**Dry run primero**:
```bash
python scripts/auto-adopt-winner.py --experiment exp-001-workflow-templates --dry-run
```

**Ejecutar adopción**:
```bash
python scripts/auto-adopt-winner.py --experiment exp-001-workflow-templates --execute
```

**Output**:
```
================================================================================
AUTO-ADOPTION PROCESS
================================================================================

Experiment: Workflow Templates vs Manual Development
Winner: template
Sample Size: 10

Winning Variant Details:
  Name: Using Workflow Template
  Description: Seguir template de WORKFLOW_TEMPLATES.md exactamente

Constraints to adopt:
  - Must Read Template: True
  - Follow Structure: True
  - Use Optimized Bootstrap: True

Statistical Evidence:
  - tokens_used: 56.7% improvement (p=0.01)
  - duration_minutes: 37.8% improvement (p=0.01)

================================================================================
EXECUTING ADOPTION
================================================================================

1. Documentation created: docs/adoptions/exp-001-workflow-templates_adoption.md
2. Experiment status updated to 'adopted'
3. Adoption logged to: telemetry/experiments/adoptions.json

================================================================================
ADOPTION COMPLETE
================================================================================

Next Steps:
1. Review documentation: docs/adoptions/exp-001-workflow-templates_adoption.md
2. Update workflow templates with winning approach
3. Communicate changes to team
4. Monitor continued performance
```

---

## 📋 COMANDOS ÚTILES

### Listar experimentos
```bash
python scripts/run-experiment.py --list-experiments
```

### Ver estado de experimento
```bash
python scripts/run-experiment.py --experiment exp-001-workflow-templates --status
```

### Listar ejecuciones pendientes
```bash
python scripts/complete-experiment.py --list-pending
```

### Analizar y exportar reporte
```bash
python scripts/analyze-experiment.py --experiment exp-001-workflow-templates --export-report
```

---

## 📊 EXPERIMENTOS PRE-CONFIGURADOS

### **1. exp-001-workflow-templates**
- **Objetivo**: Comparar templates vs desarrollo manual
- **Variantes**: template, manual
- **Métricas**: tokens, duration, quality, bugs
- **Sample size**: 10
- **Estado**: active

### **2. exp-002-context-caching**
- **Objetivo**: Comparar cache warming vs full reload
- **Variantes**: cache, no_cache
- **Métricas**: tokens, startup_time, context_quality
- **Sample size**: 10
- **Estado**: planned

### **3. exp-003-agent-specialization**
- **Objetivo**: Comparar agentes especializados vs general
- **Variantes**: specialized, general
- **Métricas**: success_rate, tokens_per_task, completion_time
- **Sample size**: 15
- **Estado**: planned

---

## 📈 INTERPRETACIÓN DE RESULTADOS

### **P-Value (Significancia)**
- **p < 0.01**: Altamente significativo ⭐⭐⭐
- **p < 0.05**: Significativo ⭐⭐
- **p < 0.10**: Marginalmente significativo ⭐
- **p >= 0.10**: No significativo ❌

### **Cohen's d (Effect Size)**
- **|d| >= 0.8**: Large effect (grande) 🟢
- **|d| >= 0.5**: Medium effect (mediano) 🟡
- **|d| >= 0.2**: Small effect (pequeño) 🟠
- **|d| < 0.2**: Negligible effect (negligible) ⚪

### **Auto-Adoption Criteria**
Para auto-adoptar automáticamente:
- ✅ p-value < 0.01 (highly significant)
- ✅ |Cohen's d| >= 0.5 (medium/large effect)
- ✅ Sample size alcanzado

---

## 🔧 CUSTOMIZACIÓN

### Crear Nuevo Experimento

Editar `telemetry/experiments/experiments.json`:

```json
{
  "experiment_id": "exp-004-my-experiment",
  "name": "My Custom Experiment",
  "description": "Testing X vs Y approach",
  "status": "active",
  "variants": [
    {
      "id": "variant_a",
      "name": "Approach A",
      "constraints": { "use_x": true }
    },
    {
      "id": "variant_b",
      "name": "Approach B",
      "constraints": { "use_y": true }
    }
  ],
  "metrics": [
    {
      "name": "my_metric",
      "type": "numeric",
      "unit": "units",
      "target": "minimize"
    }
  ],
  "sample_size": 10,
  "current_samples": 0,
  "allocation": "random_50_50"
}
```

---

## ⚠️ MEJORES PRÁCTICAS

### Durante Experimento
1. ✅ **Seguir constraints estrictamente** - La validez estadística depende de adherencia
2. ✅ **Registrar métricas precisas** - No estimar, usar valores reales
3. ✅ **Una tarea = una ejecución** - No agrupar múltiples tareas
4. ✅ **Completar inmediatamente** - Registrar métricas al terminar

### Análisis
1. ✅ **Esperar sample size completo** - 10+ samples por variante
2. ✅ **Verificar distribution** - Asegurar balance 50/50
3. ✅ **Considerar context** - Factores externos pueden influir
4. ✅ **Documentar assumptions** - Explicar limitaciones

### Adopción
1. ✅ **Dry-run primero** - Verificar antes de ejecutar
2. ✅ **Comunicar cambios** - Informar al equipo
3. ✅ **Monitorear post-adoption** - Validar que mejora se mantiene
4. ✅ **Documentar learnings** - Actualizar best practices

---

## 📁 ESTRUCTURA DE ARCHIVOS

```
telemetry/experiments/
├── experiments.json              # Configuración de experimentos
├── execution_log.json            # Log de todas las ejecuciones
├── adoptions.json                # Log de adopciones
├── results/
│   ├── exp-001_results.json     # Resultados individuales
│   └── exp-002_results.json
└── reports/
    ├── exp-001_analysis_20251008.json  # Reportes de análisis
    └── exp-002_analysis_20251008.json

docs/adoptions/
├── exp-001_adoption.md          # Documentación de adopción
└── exp-002_adoption.md
```

---

## 🎯 CASOS DE USO

### Caso 1: Optimizar Workflow
**Pregunta**: ¿Templates mejoran eficiencia?
**Experimento**: exp-001-workflow-templates
**Resultado esperado**: Template reduce tokens 40-60%

### Caso 2: Validar Caching
**Pregunta**: ¿Cache warming ahorra tokens?
**Experimento**: exp-002-context-caching
**Resultado esperado**: Cache reduce 60-70% lecturas

### Caso 3: Agent Specialization
**Pregunta**: ¿Agentes especializados son mejores?
**Experimento**: exp-003-agent-specialization
**Resultado esperado**: Specialized agent 20-30% más rápido

---

## 🔮 ROADMAP

### Fase Actual (Milestone 3)
- ✅ Configuration framework
- ✅ Execution tracking
- ✅ Statistical analysis
- ✅ Auto-adoption

### Próximas Mejoras
- 🔄 Multi-armed bandit allocation
- 🔄 Bayesian analysis
- 🔄 Continuous monitoring post-adoption
- 🔄 Real-time dashboards

---

## 📞 TROUBLESHOOTING

### Error: "Experiment not found"
```bash
# Verificar experimentos disponibles
python scripts/run-experiment.py --list-experiments
```

### Error: "Not enough samples"
```bash
# Verificar progreso
python scripts/run-experiment.py --experiment exp-001 --status

# Continuar ejecutando hasta sample_size
```

### Error: "No significant difference"
```bash
# Opciones:
# 1. Aumentar sample size
# 2. Refinir variantes (hacer diferencia más clara)
# 3. Aceptar que variantes son equivalentes
```

---

## ✅ CHECKLIST DE EXPERIMENTO

Antes de iniciar:
- [ ] Experimento configurado en `experiments.json`
- [ ] Status = "active"
- [ ] Variantes bien definidas
- [ ] Métricas claras y medibles

Durante ejecución:
- [ ] Seguir constraints de variante asignada
- [ ] Medir métricas con precisión
- [ ] Completar execution inmediatamente

Antes de analizar:
- [ ] Alcanzar sample size (10+ por variante)
- [ ] Verificar balance 50/50
- [ ] Exportar reporte

Antes de adoptar:
- [ ] p-value < 0.05 (mínimo)
- [ ] Effect size >= 0.5 (preferible)
- [ ] Dry-run primero
- [ ] Documentar decisión

---

**FIN DE AB_TESTING_GUIDE.md**

> 📌 **Sistema operacional**: Framework completo de A/B testing con análisis estadístico riguroso y auto-adopción inteligente.
