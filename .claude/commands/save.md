Ejecuta el script Python de sesión save para guardar el estado actual:

```bash
python "C:\Users\shill\AppData\Local\Android\Sdk\Proyectos\.claude-ide\commands\save.py" ide
```

Esto guardará un snapshot completo de la sesión IDE actual incluyendo:
- Archivos abiertos y posiciones
- Tareas pendientes y decisiones
- Estado git actual
- Versiones de principios

El snapshot se guardará en: `.claude-ide/sessions/ide/`

Usa `/remember` después de `/clear` para restaurar este estado.
