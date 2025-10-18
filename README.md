# nvim-todo-md
Este es mi primer plugin para Neovim. Lo desarrollé para aprender el ecosistema de plugins y solucionar mi propia necesidad de gestión de tareas.

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

https://github.com/user-attachments/assets/8fcdbcfe-9dea-49fb-b715-ac3257273938

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
    template = {},               -- Contenido inicial (opcional)
    float = {
        enable = true,           -- Ventana flotante o buffer
        width  = 80,
        height = 20,
        border = "rounded",      -- Opciones: "none", "single", "double", "solid"
        center = true,
    },
    keys = {                     -- Atajos personalizables (opcional)
        add          = "<leader>ta",
        convert      = "<leader>tc",
        open         = "<leader>td",
        toggle_check = "<leader>tm",
        close        = "q",
    }
}
```
### Comportamiento por defecto
Si no se especifica path, el plugin usará:
~/toDo.md (en tu directorio home)

## Comandos

- `:ToDo` → Abre el gestor de tareas.
- `:ToDoCheck` → Alterna el estado de la tarea (✓ / ☐).
- `:ToDoAdd` → Agrega una nueva tarea.
- `:ToDoMake` → Convierte el texto en una tarea.

### Uso básico
| Atajo                      | Acción                              |
| :----------------------------| :---------------------------------- |
| `<leader>td`                | Abrir/crear archivo de tareas       |
| `<leader>tm`                | Alternar checkbox ([ ] ↔ [x])       |
| `<leader>ta`                          | Agregar tarea                    |
| `<leader>tc`                          | Transformar en tarea                   |
| `q`                          | Cerrar el buffer                    |

