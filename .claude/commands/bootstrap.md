Ejecuta bootstrap completo del contexto desde documentos fuente:

```bash
python "C:\Users\shill\AppData\Local\Android\Sdk\Proyectos\.claude-ide\commands\bootstrap.py" ide
```

Esto cargará TODOS los documentos obligatorios desde cero:
- CLAUDE_GLOBAL_DEVELOPMENT_PRINCIPLES.md
- INTELLIGENT_IDE_VISION.md
- IMPLEMENTATION_GUIDE.md
- ROADMAP_26_WEEKS.md
- COST_ANALYSIS.md
- RITMO_USE_CASES.md
- Flutter knowledge base

**Cuándo usar**:
- Primera sesión del día (sin snapshot previo)
- Después de actualizar documentos de principios
- Cuando quieres contexto completamente fresco

**Opciones**:
- `ide` - Bootstrap sesión IDE (default)
- `ritmo` - Bootstrap sesión RITMO

Diferencia con /remember: Bootstrap carga desde archivos originales, /remember restaura desde snapshot guardado.
