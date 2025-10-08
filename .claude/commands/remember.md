Ejecuta el script Python para restaurar el estado de la última sesión guardada:

```bash
python "C:\Users\shill\AppData\Local\Android\Sdk\Proyectos\.claude-ide\commands\remember.py" ide latest
```

Esto restaurará:
- Contexto completo de archivos
- Tareas pendientes
- Decisiones previas
- Validará versiones de documentos de principios

**Opciones**:
- `ide` - Restaura sesión IDE (default)
- `ritmo` - Restaura sesión RITMO
- `list` - Lista todas las sesiones disponibles

Usa este comando después de `/clear` para continuar exactamente donde quedaste.
