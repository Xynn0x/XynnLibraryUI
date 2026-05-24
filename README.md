# XynnHub UI Library v2.0

<div align="center">

![Version](https://img.shields.io/badge/version-2.0-blue?style=for-the-badge)
![Platform](https://img.shields.io/badge/platform-Roblox-red?style=for-the-badge)
![Mobile](https://img.shields.io/badge/mobile-supported-green?style=for-the-badge)

**A modern, feature-rich UI library for Roblox exploit scripts.**  
Supports dark/light themes, mobile scaling, ColorPicker, Keybind, MultiDropdown, and more.

</div>

---

## Table of Contents

- [Quick Start](#quick-start)
- [Library Configuration](#library-configuration)
  - [SetTheme](#settheme)
  - [SetAccentColor](#setaccentcolor)
- [CreateWindow](#createwindow)
- [Window Methods](#window-methods)
  - [SetToggleKey](#settogglekey)
  - [AddTab](#addtab)
- [Tab Elements](#tab-elements)
  - [AddSection](#addsection)
  - [AddDivider](#adddivider)
  - [AddLabel](#addlabel)
  - [AddParagraph](#addparagraph)
  - [AddButton](#addbutton)
  - [AddToggle](#addtoggle)
  - [AddSlider](#addslider)
  - [AddDropdown](#adddropdown)
  - [AddMultiDropdown](#addmultidropdown)
  - [AddTextBox](#addtextbox)
  - [AddKeybind](#addkeybind)
  - [AddColorPicker](#addcolorpicker)
  - [AddProgressBar](#addprogressbar)
- [Utilities](#utilities)
  - [Notify](#notify)
  - [Watermark](#watermark)
  - [LoadingScreen](#loadingscreen)
  - [Destroy](#destroy)
- [Library.Flags](#libraryflagss)
- [Themes Reference](#themes-reference)

---

## Quick Start

```lua
local Library = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()

-- Optional: set theme before creating window
Library:SetTheme("Midnight")
Library:SetAccentColor(Color3.fromRGB(130, 80, 255))

local Window = Library:CreateWindow({
    Title       = "My Hub",
    Subtitle    = "v1.0",
    Theme       = "Dark",
    AccentColor = Color3.fromRGB(0, 170, 255),
})

local Tab = Window:AddTab("Main", "⚙")

Tab:AddToggle({
    Name     = "God Mode",
    Default  = false,
    Callback = function(state)
        print("God Mode:", state)
    end,
})
```

---

## Library Configuration

### `SetTheme`

Sets the global color theme **before** or **after** creating the window.

```lua
Library:SetTheme("Dark")
```

| Parameter | Type   | Description                                      |
|-----------|--------|--------------------------------------------------|
| Name      | string | Theme name: `"Dark"`, `"Midnight"`, `"Light"`, `"Ocean"`, `"Rose"` |

---

### `SetAccentColor`

Changes the library's accent color (used on toggles, sliders, active tabs, etc.).

```lua
Library:SetAccentColor(Color3.fromRGB(130, 80, 255))
```

---

## CreateWindow

Creates the main UI window. Returns a `Window` object.

```lua
local Window = Library:CreateWindow({
    Title       = "Xynn Hub",     -- Window title
    Subtitle    = "v2.0",         -- Small subtitle below title (optional)
    Theme       = "Dark",         -- Theme preset (optional, can use SetTheme instead)
    AccentColor = Color3.fromRGB(0, 170, 255),  -- Accent color override (optional)
})
```

| Option      | Type         | Default             | Description              |
|-------------|--------------|---------------------|--------------------------|
| Title       | string       | `"Xynn Hub"`        | Window title text        |
| Subtitle    | string       | `""`                | Subtitle under title     |
| Theme       | string       | `"Dark"`            | Initial theme preset     |
| AccentColor | Color3       | `RGB(0, 170, 255)`  | Accent highlight color   |

---

## Window Methods

### `SetToggleKey`

Binds a keyboard key to toggle the window's visibility.

```lua
Window:SetToggleKey(Enum.KeyCode.RightShift)
```

| Parameter | Type          | Description                  |
|-----------|---------------|------------------------------|
| Key       | Enum.KeyCode  | Key to toggle the window     |

---

### `AddTab`

Adds a tab to the sidebar. Returns a `Tab` object.

```lua
local MainTab     = Window:AddTab("Main", "⚙")
local CombatTab   = Window:AddTab("Combat", "⚔")
local VisualTab   = Window:AddTab("Visuals", "👁")
local SettingsTab = Window:AddTab("Settings")  -- no icon is fine too
```

| Parameter | Type   | Description                          |
|-----------|--------|--------------------------------------|
| Name      | string | Tab label shown in sidebar           |
| Icon      | string | Optional emoji/icon prefix           |

> **Tip:** The sidebar has a built-in search box that filters tabs by name in real-time.

---

## Tab Elements

All tab elements are added in order (top to bottom, with automatic scrolling).

---

### `AddSection`

A styled section header with an accent-colored underline. Used to visually group elements.

```lua
Tab:AddSection("Combat Settings")
```

---

### `AddDivider`

A thin horizontal line. Optionally displays a muted label above it.

```lua
Tab:AddDivider()           -- plain line
Tab:AddDivider("Advanced") -- line with label
```

---

### `AddLabel`

A simple read-only text display. Returns an object with a `Set` method for dynamic updates.

```lua
local StatusLabel = Tab:AddLabel({
    Text = "Status: Waiting...",
})

-- Update later
StatusLabel.Set("Status: Active!")
```

| Option | Type   | Description          |
|--------|--------|----------------------|
| Text   | string | Initial label text   |

**Returned object:**

| Method       | Description               |
|--------------|---------------------------|
| `Set(text)`  | Updates the label text    |
| `Get()`      | Returns current text      |

---

### `AddParagraph`

A block with a bold title and a wrapped body text. Good for info panels or descriptions.

```lua
local Para = Tab:AddParagraph({
    Title = "How to Use",
    Body  = "Enable the toggles below to activate features. Use the slider to adjust speed.",
})

-- Update dynamically
Para.SetTitle("Updated Title")
Para.SetBody("New body content here.")
```

| Option | Type   | Description           |
|--------|--------|-----------------------|
| Title  | string | Bold header text      |
| Body   | string | Wrapped body text     |

---

### `AddButton`

A clickable button with an optional description line.

```lua
Tab:AddButton({
    Name        = "Teleport to Spawn",
    Description = "Moves your character to the spawn point",  -- optional
    Callback    = function()
        game.Players.LocalPlayer.Character:MoveTo(Vector3.new(0, 5, 0))
    end,
})
```

| Option      | Type     | Description                   |
|-------------|----------|-------------------------------|
| Name        | string   | Button label                  |
| Description | string   | Small subtitle text (optional)|
| Callback    | function | Called on click               |

---

### `AddToggle`

An on/off switch with a smooth pill animation.

```lua
local SpeedToggle = Tab:AddToggle({
    Name        = "Speed Hack",
    Description = "Increases walk speed",  -- optional
    Default     = false,
    Callback    = function(state)
        -- state is true or false
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = state and 50 or 16
    end,
})

-- Control programmatically
SpeedToggle.Set(true)
print(SpeedToggle.Get())  -- true
```

| Option      | Type     | Description                         |
|-------------|----------|-------------------------------------|
| Name        | string   | Toggle label                        |
| Description | string   | Subtitle text (optional)            |
| Default     | boolean  | Initial state (default: `false`)    |
| Callback    | function | `function(state: boolean)`          |

**Returned object:**

| Method      | Description                  |
|-------------|------------------------------|
| `Set(bool)` | Sets toggle state            |
| `Get()`     | Returns current state        |

> Value is also stored in `Library.Flags["Name"]`.

---

### `AddSlider`

A draggable slider for numeric values. Supports integer and decimal modes.

```lua
local SpeedSlider = Tab:AddSlider({
    Name     = "Walk Speed",
    Min      = 16,
    Max      = 200,
    Default  = 16,
    Suffix   = " studs",    -- optional unit label
    Integer  = true,        -- true = whole numbers, false = decimals
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end,
})

-- Control programmatically
SpeedSlider.Set(50)
print(SpeedSlider.Get())  -- 50
```

| Option   | Type     | Description                              |
|----------|----------|------------------------------------------|
| Name     | string   | Slider label                             |
| Min      | number   | Minimum value                            |
| Max      | number   | Maximum value                            |
| Default  | number   | Starting value (default: Min)            |
| Suffix   | string   | Unit text shown after value (optional)   |
| Integer  | boolean  | `true` for whole numbers (default: true) |
| Callback | function | `function(value: number)`                |

---

### `AddDropdown`

A single-select dropdown menu.

```lua
local TeamDrop = Tab:AddDropdown({
    Name    = "Team",
    Options = { "Red", "Blue", "Green", "Yellow" },
    Default = "Red",
    Callback = function(selected)
        print("Selected team:", selected)
    end,
})

-- Control programmatically
TeamDrop.Set("Blue")
print(TeamDrop.Get())  -- "Blue"
```

| Option   | Type     | Description                          |
|----------|----------|--------------------------------------|
| Name     | string   | Dropdown label                       |
| Options  | table    | Array of option strings              |
| Default  | string   | Initially selected value (optional)  |
| Callback | function | `function(selected: string)`         |

---

### `AddMultiDropdown`

A multi-select dropdown. Returns a dictionary of selected values.

```lua
local Features = Tab:AddMultiDropdown({
    Name    = "Active Features",
    Options = { "ESP", "Aimbot", "Speedhack", "Noclip" },
    Default = { "ESP" },  -- pre-selected options (optional)
    Callback = function(selected)
        -- selected is a dict: { ESP = true, Speedhack = true }
        for feature, _ in pairs(selected) do
            print("Active:", feature)
        end
    end,
})

-- Get all selected
local sel = Features.Get()
print(sel["ESP"])  -- true or nil

-- Set selected (replaces current selection)
Features.Set({ "ESP", "Noclip" })
```

| Option   | Type     | Description                                    |
|----------|----------|------------------------------------------------|
| Name     | string   | Dropdown label                                 |
| Options  | table    | Array of option strings                        |
| Default  | table    | Array of pre-selected option strings           |
| Callback | function | `function(selected: {[string]: true})`         |

---

### `AddTextBox`

A text input field with placeholder support.

```lua
local PlayerInput = Tab:AddTextBox({
    Name          = "Target Player",
    Placeholder   = "Enter username...",
    Default       = "",
    ClearOnFocus  = true,  -- clears text when clicked (default: true)
    Callback      = function(text, pressedEnter)
        -- text: current value
        -- pressedEnter: true if user pressed Enter
        if pressedEnter then
            print("Searching for:", text)
        end
    end,
})

PlayerInput.Set("xynn")
print(PlayerInput.Get())  -- "xynn"
```

| Option       | Type     | Description                               |
|--------------|----------|-------------------------------------------|
| Name         | string   | Label above the input                     |
| Placeholder  | string   | Grayed placeholder text                   |
| Default      | string   | Initial text value (optional)             |
| ClearOnFocus | boolean  | Clear text on focus (default: `true`)     |
| Callback     | function | `function(text: string, enter: boolean)`  |

---

### `AddKeybind`

A keyboard binding widget. Click to listen, press any key to bind it. The callback fires every time the bound key is pressed in-game.

```lua
local MenuBind = Tab:AddKeybind({
    Name    = "Open Menu",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        -- fires every time the bound key is pressed
        print("Menu key pressed!")
    end,
})

-- Change key programmatically
MenuBind.Set(Enum.KeyCode.F4)
print(MenuBind.Get().Name)  -- "F4"
```

| Option   | Type          | Description                                     |
|----------|---------------|-------------------------------------------------|
| Name     | string        | Label for the keybind row                       |
| Default  | Enum.KeyCode  | Initially bound key (default: Unknown = "None") |
| Callback | function      | Called every time the bound key is pressed      |

---

### `AddColorPicker`

An HSV color picker with saturation/value square, hue slider, and hex input.

```lua
local EspColor = Tab:AddColorPicker({
    Name    = "ESP Color",
    Default = Color3.fromRGB(255, 80, 80),
    Callback = function(color)
        -- color is a Color3
        print("R:", math.floor(color.R * 255))
    end,
})

-- Control programmatically
EspColor.Set(Color3.fromRGB(0, 200, 100))
local current = EspColor.Get()  -- Color3
```

| Option   | Type     | Description                      |
|----------|----------|----------------------------------|
| Name     | string   | Label for the picker row         |
| Default  | Color3   | Initial color (default: red)     |
| Callback | function | `function(color: Color3)`        |

**How to use the picker:**
1. Click the colored swatch to open the picker panel.
2. Drag inside the **square** to adjust Saturation (X) and Value (Y).
3. Drag the **rainbow bar** to change Hue.
4. Type a **hex code** (e.g. `#FF5050`) and press Enter to jump to that color.
5. Click anywhere outside to close.

---

### `AddProgressBar`

A read-only progress bar display. Useful for showing loading, health, cooldowns, etc.

```lua
local HealthBar = Tab:AddProgressBar({
    Name    = "Player Health",
    Default = 100,  -- starting percent (0–100)
})

-- Update over time
game:GetService("RunService").Heartbeat:Connect(function()
    local hp  = game.Players.LocalPlayer.Character.Humanoid.Health
    local max = game.Players.LocalPlayer.Character.Humanoid.MaxHealth
    HealthBar.Set((hp / max) * 100)
end)

print(HealthBar.Get())  -- current percent value
```

| Option  | Type   | Description                         |
|---------|--------|-------------------------------------|
| Name    | string | Label above the bar                 |
| Default | number | Starting percent value (0–100)      |

---

## Utilities

### `Notify`

Sends a toast notification in the bottom-right corner with a progress timer.

```lua
Library:Notify({
    Title       = "Success",
    Description = "Speed hack has been enabled.",
    Type        = "Success",   -- "Default" | "Success" | "Error" | "Warning" | "Info"
    Duration    = 4.5,         -- seconds before auto-dismiss (default: 4.5)
})
```

| Option      | Type   | Default     | Description                            |
|-------------|--------|-------------|----------------------------------------|
| Title       | string | `"Notification"` | Bold notification title           |
| Description | string | `""`        | Body text (supports wrapping)          |
| Type        | string | `"Default"` | Controls icon + accent color           |
| Duration    | number | `4.5`       | Auto-dismiss time in seconds           |

**Notification Types:**

| Type      | Icon | Color        |
|-----------|------|--------------|
| `Default` | ●    | Accent blue  |
| `Success` | ✓    | Green        |
| `Error`   | ✕    | Red          |
| `Warning` | !    | Yellow       |
| `Info`    | i    | Light blue   |

---

### `Watermark`

Adds a persistent watermark label in the top-left corner.

```lua
local WM = Library:Watermark({
    Name = "XynnHub",    -- shown in accent color
    Info = "v2.0",       -- shown in muted color after separator
})

-- Update the info text (e.g. fps counter)
game:GetService("RunService").Heartbeat:Connect(function()
    WM.SetInfo(math.floor(1 / game:GetService("RunService").Heartbeat:Wait()) .. " FPS")
end)

WM.SetVisible(false)  -- hide watermark
WM.SetName("MyHub")   -- change name text
```

| Option | Type   | Description                        |
|--------|--------|------------------------------------|
| Name   | string | Accent-colored left text           |
| Info   | string | Muted right text after `" | "`     |

**Returned object:**

| Method           | Description               |
|------------------|---------------------------|
| `SetInfo(text)`  | Updates the right text    |
| `SetName(text)`  | Updates the left text     |
| `SetVisible(bool)` | Shows/hides watermark   |

---

### `LoadingScreen`

Shows a full-screen loading overlay before the main UI. Call **before** `CreateWindow` or immediately after.

```lua
local Loader = Library:LoadingScreen({
    Title    = "XynnHub",
    Subtitle = "Loading scripts...",
    Duration = 3,   -- used when no Steps provided
})

-- Or use custom steps:
Library:LoadingScreen({
    Title = "XynnHub",
    Steps = {
        { Text = "Initializing...",      Duration = 0.8 },
        { Text = "Loading modules...",   Duration = 0.8 },
        { Text = "Applying patches...",  Duration = 0.8 },
        { Text = "Ready!",               Duration = 0.4 },
    },
})

-- Manually dismiss early:
Loader.Finish()
```

| Option   | Type   | Description                                    |
|----------|--------|------------------------------------------------|
| Title    | string | Large title text                               |
| Subtitle | string | Subtitle / status line                         |
| Duration | number | Auto-complete time (when no Steps)             |
| Steps    | table  | Array of `{Text, Duration}` for stepped loading|

---

### `Destroy`

Fully destroys the UI, disconnects all connections, and removes the ScreenGui.

```lua
Library:Destroy()
```

> The **Close button (✕)** on the window calls this automatically.

---

## Library.Flags

Every interactive element writes its current value to `Library.Flags[Name]`. Use this for polling values from anywhere in your script without needing to store return objects.

```lua
-- After the user changes a toggle:
print(Library.Flags["Speed Hack"])   -- true or false

-- After slider change:
print(Library.Flags["Walk Speed"])   -- 50

-- After dropdown change:
print(Library.Flags["Team"])         -- "Blue"

-- After multi-dropdown change:
print(Library.Flags["Active Features"]["ESP"])  -- true or nil

-- After color picker change:
print(Library.Flags["ESP Color"])    -- Color3

-- After keybind change:
print(Library.Flags["Open Menu"])    -- Enum.KeyCode.RightShift
```

---

## Themes Reference

Five built-in themes. Pass the name to `SetTheme` or `CreateWindow { Theme = ... }`.

| Theme      | Background    | Vibe                            |
|------------|---------------|---------------------------------|
| `Dark`     | `#141414`     | Classic dark, neutral grays     |
| `Midnight` | `#0A0A12`     | Deep dark blue-purple           |
| `Light`    | `#EBEBEB`     | Clean light mode                |
| `Ocean`    | `#08141F`     | Deep sea blue-teal              |
| `Rose`     | `#160C12`     | Dark rose/burgundy              |

---

## Full Example

```lua
local Library = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()

-- Loading screen
Library:LoadingScreen({
    Title = "MyHub",
    Steps = {
        { Text = "Loading modules...",  Duration = 0.7 },
        { Text = "Fetching scripts...", Duration = 0.7 },
        { Text = "All done!",           Duration = 0.4 },
    },
})

-- Configure
Library:SetTheme("Midnight")
Library:SetAccentColor(Color3.fromRGB(130, 80, 255))

-- Create window
local Window = Library:CreateWindow({
    Title    = "MyHub",
    Subtitle = "v2.0 | Undetected",
})

-- Toggle key
Window:SetToggleKey(Enum.KeyCode.RightShift)

-- Watermark
local WM = Library:Watermark({ Name = "MyHub", Info = "v2.0" })

-- Tab: Main
local Main = Window:AddTab("Main", "⚙")

Main:AddSection("Player")

Main:AddToggle({
    Name    = "Infinite Jump",
    Default = false,
    Callback = function(state)
        Library:Notify({ Title = state and "Enabled" or "Disabled", Description = "Infinite Jump", Type = state and "Success" or "Warning" })
    end,
})

Main:AddSlider({
    Name     = "Walk Speed",
    Min      = 16,
    Max      = 200,
    Default  = 16,
    Suffix   = " stud/s",
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
})

Main:AddColorPicker({
    Name    = "Chat Color",
    Default = Color3.fromRGB(0, 170, 255),
    Callback = function(color)
        print("Chat color changed to", color)
    end,
})

-- Tab: ESP
local ESP = Window:AddTab("ESP", "👁")

ESP:AddToggle({ Name = "ESP Enabled", Default = false, Callback = function(s) print("ESP:", s) end })
ESP:AddMultiDropdown({
    Name    = "Show",
    Options = { "Name", "Health", "Distance", "Box" },
    Default = { "Name", "Health" },
    Callback = function(sel) print("ESP options updated") end,
})

-- Tab: Settings
local Settings = Window:AddTab("Settings", "⚙")
Settings:AddDropdown({
    Name    = "Theme",
    Options = { "Dark", "Midnight", "Light", "Ocean", "Rose" },
    Default = "Midnight",
    Callback = function(theme) Library:SetTheme(theme) end,
})
Settings:AddKeybind({
    Name    = "Toggle Menu",
    Default = Enum.KeyCode.RightShift,
    Callback = function() print("Toggle!") end,
})
Settings:AddTextBox({
    Name        = "Custom Title",
    Placeholder = "Enter new title...",
    Callback    = function(text, enter) if enter then print("Title set to:", text) end end,
})
```

---

<div align="center">

Made with ❤️ by **XynnHub**  
*Feel free to fork, modify, and use in your own projects.*

</div>
