# XynnHub UI Library v2.0

<div align="center">

![Version](https://img.shields.io/badge/version-2.0-blue?style=for-the-badge)
![Platform](https://img.shields.io/badge/platform-Roblox-red?style=for-the-badge)
![Mobile](https://img.shields.io/badge/mobile-supported-green?style=for-the-badge)

</div>

---

# 🌟 Xynn Hub UI Library — Documentation

> A modern, mobile-friendly Roblox UI Library with support for tabs, toggles, sliders, dropdowns, and more.

---

## 📦 Installation

Paste the library loader at the top of your script:

```lua
local Library = loadstring(game:HttpGet("YOUR_RAW_SCRIPT_URL"))()
```

---

## 🪟 CreateWindow

Creates the main GUI window.

```lua
local Window = Library:CreateWindow({
    Title = "My Hub",
    AccentColor = Color3.fromRGB(0, 170, 255) -- optional
})
```

| Parameter     | Type          | Description                          |
|---------------|---------------|--------------------------------------|
| `Title`       | `string`      | Title shown on the window header     |
| `AccentColor` | `Color3`      | Accent color for tabs, toggles, etc. |

---

## 🎨 SetAccentColor

Changes the global accent color at any time.

```lua
Library:SetAccentColor(Color3.fromRGB(255, 100, 0))
```

---

## 📁 AddTab

Adds a new tab to the sidebar.

```lua
local Tab = Window:AddTab("Combat")
```

> The **first tab added** is automatically selected and visible.

---

## 📂 AddSection

Adds a section label inside a tab to group elements visually.

```lua
Tab:AddSection("Aimbot Settings")
```

---

## ➖ AddDivider

Adds a horizontal divider line, optionally with a label.

```lua
-- Simple divider
Tab:AddDivider()

-- Divider with label
Tab:AddDivider("Visual Options")
```

---

## 🔘 AddButton

Adds a clickable button.

```lua
Tab:AddButton({
    Name = "Teleport to Spawn",
    Callback = function()
        -- your code here
        print("Button clicked!")
    end
})
```

| Parameter  | Type       | Description                        |
|------------|------------|------------------------------------|
| `Name`     | `string`   | Label shown on the button          |
| `Callback` | `function` | Function called when button is clicked |

---

## ✅ AddToggle

Adds an on/off toggle switch.

```lua
Tab:AddToggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(State)
        print("Silent Aim:", State)
    end
})
```

| Parameter  | Type       | Description                          |
|------------|------------|--------------------------------------|
| `Name`     | `string`   | Label shown on the toggle            |
| `Default`  | `boolean`  | Initial state (`true` = on)          |
| `Callback` | `function` | Called with `true`/`false` on change |

> **Access value anytime:**
> ```lua
> print(Library.Flags["Silent Aim"]) -- true or false
> ```

---

## 🎚️ AddSlider

Adds a draggable slider for numeric values. Supports **mouse and touch (mobile)**.

```lua
Tab:AddSlider({
    Name = "Walk Speed",
    Min = 0,
    Max = 100,
    Default = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})
```

| Parameter  | Type       | Description                          |
|------------|------------|--------------------------------------|
| `Name`     | `string`   | Label shown above the slider         |
| `Min`      | `number`   | Minimum value                        |
| `Max`      | `number`   | Maximum value                        |
| `Default`  | `number`   | Starting value                       |
| `Callback` | `function` | Called with current value on drag    |

> **Access value anytime:**
> ```lua
> print(Library.Flags["Walk Speed"]) -- number
> ```

---

## 🔽 AddDropdown

Adds a single-select dropdown menu.

```lua
Tab:AddDropdown({
    Name = "Team",
    Options = {"Red", "Blue", "Green"},
    Default = "Blue",
    Callback = function(Selected)
        print("Selected team:", Selected)
    end
})
```

| Parameter  | Type       | Description                            |
|------------|------------|----------------------------------------|
| `Name`     | `string`   | Label shown on the dropdown button     |
| `Options`  | `table`    | List of selectable options             |
| `Default`  | `string`   | Pre-selected option (optional)         |
| `Callback` | `function` | Called with selected option string     |

> **Access value anytime:**
> ```lua
> print(Library.Flags["Team"]) -- "Red" / "Blue" / "Green"
> ```

---

## 🔽🔽 AddMultiDropdown

Adds a multi-select dropdown (select multiple options at once).

```lua
Tab:AddMultiDropdown({
    Name = "Effects",
    Options = {"Blur", "Bloom", "Vignette"},
    Default = {"Blur", "Bloom"},
    Callback = function(Selected)
        -- Selected is a table of chosen options
        for _, v in ipairs(Selected) do
            print("Active:", v)
        end
    end
})
```

| Parameter  | Type       | Description                               |
|------------|------------|-------------------------------------------|
| `Name`     | `string`   | Label shown on the dropdown button        |
| `Options`  | `table`    | List of selectable options                |
| `Default`  | `table`    | Pre-selected options (optional)           |
| `Callback` | `function` | Called with table of all selected options |

> **Access value anytime:**
> ```lua
> print(Library.Flags["Effects"]) -- {"Blur", "Bloom"}
> ```

---

## 🔔 Notify

Shows a pop-up notification in the bottom-right corner.

```lua
Library:Notify({
    Title = "Script Loaded",
    Description = "Xynn Hub has been injected successfully!",
    Duration = 4.5
})
```

| Parameter     | Type     | Description                          |
|---------------|----------|--------------------------------------|
| `Title`       | `string` | Bold title of the notification       |
| `Description` | `string` | Subtitle / body text                 |
| `Duration`    | `number` | How long (seconds) before it fades   |

---

## 🗑️ Destroy

Destroys all connections and removes the GUI.

```lua
Library:Destroy()
```

---

## 📱 Mobile Support

Xynn Hub automatically detects mobile devices and applies a **scale factor of `0.78`** to all UI elements. Sliders, floating button dragging, and all controls are fully **touch-compatible**.

---

## 🏁 Full Example

```lua
local Library = loadstring(game:HttpGet("YOUR_RAW_URL"))()

local Window = Library:CreateWindow({
    Title = "Xynn Hub",
    AccentColor = Color3.fromRGB(0, 170, 255)
})

local Tab = Window:AddTab("Main")

Tab:AddSection("Player")

Tab:AddToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(State)
        print("God Mode:", State)
    end
})

Tab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 250,
    Default = 16,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

Tab:AddDivider("Visuals")

Tab:AddDropdown({
    Name = "ESP Color",
    Options = {"Red", "White", "Green"},
    Default = "White",
    Callback = function(v)
        print("ESP Color:", v)
    end
})

Tab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})

Library:Notify({
    Title = "Xynn Hub",
    Description = "Loaded successfully!",
    Duration = 4
})
```

---

## 📌 Library.Flags

All toggle, slider, and dropdown values are stored globally in `Library.Flags` by their `Name`.

```lua
-- Access anywhere in your script:
Library.Flags["Silent Aim"]   -- boolean
Library.Flags["Walk Speed"]   -- number
Library.Flags["Team"]         -- string
Library.Flags["Effects"]      -- table
```

---

*Made with ❤️ — Xynn Hub UI Library*
