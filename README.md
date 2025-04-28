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

https://github.com/user-attachments/assets/34f9d4b9-6f9d-49f8-bfd4-9cb64b9e504a

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
      open   = "<leader>td",
      toggle = "<leader>tm",
      close  = "q",
    }
}
```
### Comportamiento por defecto
Si no se especifica path, el plugin usará:
~/toDo.md (en tu directorio home)

### Uso básico
| comando                      | Acción                              |
| :----------------------------| :---------------------------------- |
| `<leader>td`                | Abrir/crear archivo de tareas       |
| `<leader>tm`                | Alternar checkbox ([ ] ↔ [x])       |
| `q`                          | Cerrar el buffer                    |

También podés abrir el archivo usando el comando :ToDo desde la línea de comandos de Neovim.
