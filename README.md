# nvim-todo-md
Este es mi primer plugin para Neovim. Lo desarrollé para aprender el ecosistema de plugins y solucionar mi propia necesidad de gestion de tareas.

## ¿Qué es un toDo en Markdown?
Un **toDo.md** es un archivo en formato Markdown que contiene listas de tareas con checkboxes interactivos. Usa la sintaxis:

```markdown
- [ ] Tarea pendiente
- [x] Tarea completada
```

Características:
- 📂 Crea/abre automáticamente ~/todo.md (ruta configurable)
- ✅ Alterna entre [ ] y [x] con un atajo
- ⚙️ Configuración mínima necesaria



## Instalación 🔧
con lazy.nvim:

```lua
{
    'Facu-Glo/nvim-todo-md',
     opts = {},
}
```
## Configuración
```lua
opts = {
    path = "~/ruta/a/todo.md",   -- Ruta personalizada (opcional)
    template = {},             -- Contenido inicial (opcional)
    keys = {                     -- Atajos personalizables (opcional)
      open = "<leader>td"
      toggle = "<leader>tm"
      close = "q"
    }
}
```
### Comportamiento por defecto
Si no se especifica path, el plugin usará:
~/toDo.md (en tu directorio home)

### Uso basico
| comando                      | Accion                              |
| :----------------------------| :---------------------------------- |
| `\<leader>td`                | Abrir/crear archivo de tareas       |
| `\<leader>tm`                | Alternar checkbox ([ ] ↔ [x])       |
| `q`                          | Cerrar el buffer                    |
