# Example

```lua
-- Load the UI Library
local Library = loadstring(game:HttpGet("YOUR_LIBRARY_LINK"))()

--------------------------------------------------
-- Create Main Window
--------------------------------------------------

local Window = Library:CreateWindow({
    Title = "Xynn Hub",

    -- Main accent color used throughout the UI
    AccentColor = Color3.fromRGB(0, 170, 255)
})

--------------------------------------------------
-- Display a startup notification
--------------------------------------------------

Library:Notify({
    Title = "Xynn Hub",
    Description = "Library loaded successfully!",
    Duration = 5
})

--------------------------------------------------
-- Main Tab
--------------------------------------------------

local Main = Window:AddTab("Main")

Main:AddSection("Automation")

--------------------------------------------------
-- Toggle Example
-- Returns true when enabled and false when disabled
--------------------------------------------------

Main:AddToggle({
    Name = "Auto Farm",
    Default = false,

    Callback = function(State)
        print("Auto Farm:", State)
    end
})

Main:AddToggle({
    Name = "Auto Rebirth",
    Default = false,

    Callback = function(State)
        print("Auto Rebirth:", State)
    end
})

--------------------------------------------------
-- Slider Example
-- Allows the user to select a value within a range
--------------------------------------------------

Main:AddSlider({
    Name = "Farm Speed",
    Min = 1,
    Max = 100,
    Default = 25,

    Callback = function(Value)
        print("Farm Speed:", Value)
    end
})

--------------------------------------------------
-- Dropdown Example
-- Allows the user to choose one option
--------------------------------------------------

Main:AddDropdown({
    Name = "Selected Egg",

    Options = {
        "Basic Egg",
        "Rare Egg",
        "Epic Egg",
        "Legendary Egg"
    },

    Default = "Basic Egg",

    Callback = function(Value)
        print("Selected Egg:", Value)
    end
})

--------------------------------------------------
-- Button Example
-- Executes code when clicked
--------------------------------------------------

Main:AddButton({
    Name = "Open Selected Egg",

    Callback = function()
        print(
            "Opening:",
            Library.Flags["Selected Egg"]
        )
    end
})

--------------------------------------------------
-- Divider Example
--------------------------------------------------

Main:AddDivider("Utilities")

--------------------------------------------------
-- Notification Example
--------------------------------------------------

Main:AddButton({
    Name = "Show Notification",

    Callback = function()
        Library:Notify({
            Title = "Notification",
            Description = "This is a test notification.",
            Duration = 4
        })
    end
})

--------------------------------------------------
-- Player Tab
--------------------------------------------------

local Player = Window:AddTab("Player")

Player:AddSection("Character Settings")

--------------------------------------------------
-- WalkSpeed Slider
--------------------------------------------------

Player:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,

    Callback = function(Value)

        local Character = game.Players.LocalPlayer.Character

        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = Value
        end

    end
})

--------------------------------------------------
-- JumpPower Slider
--------------------------------------------------

Player:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 300,
    Default = 50,

    Callback = function(Value)

        local Character = game.Players.LocalPlayer.Character

        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.JumpPower = Value
        end

    end
})

--------------------------------------------------
-- Toggle Example
--------------------------------------------------

Player:AddToggle({
    Name = "Infinite Jump",
    Default = false,

    Callback = function(State)
        print("Infinite Jump:", State)
    end
})

--------------------------------------------------
-- Teleport Tab
--------------------------------------------------

local Teleport = Window:AddTab("Teleport")

Teleport:AddSection("Locations")

--------------------------------------------------
-- Destination Selector
--------------------------------------------------

Teleport:AddDropdown({
    Name = "Destination",

    Options = {
        "Spawn",
        "Shop",
        "Forest",
        "Desert",
        "Boss Area"
    },

    Default = "Spawn",

    Callback = function(Value)
        print("Destination:", Value)
    end
})

--------------------------------------------------
-- Teleport Button
--------------------------------------------------

Teleport:AddButton({
    Name = "Teleport",

    Callback = function()

        local Destination =
            Library.Flags["Destination"]

        print(
            "Teleporting to:",
            Destination
        )

        -- Replace this section with your own teleport logic

    end
})

--------------------------------------------------
-- Miscellaneous Tab
--------------------------------------------------

local Misc = Window:AddTab("Misc")

Misc:AddSection("Utilities")

--------------------------------------------------
-- Print all stored flag values
--------------------------------------------------

Misc:AddButton({
    Name = "Print All Flags",

    Callback = function()

        print("===== FLAGS =====")

        for Name, Value in pairs(Library.Flags) do
            print(Name, Value)
        end

    end
})

--------------------------------------------------
-- Clipboard Example
--------------------------------------------------

Misc:AddButton({
    Name = "Copy Discord Invite",

    Callback = function()

        if setclipboard then
            setclipboard(
                "https://discord.gg/example"
            )
        end

        Library:Notify({
            Title = "Copied",
            Description = "Discord invite copied to clipboard.",
            Duration = 3
        })

    end
})

--------------------------------------------------
-- Danger Zone
--------------------------------------------------

Misc:AddDivider("Danger Zone")

--------------------------------------------------
-- Completely remove the UI
--------------------------------------------------

Misc:AddButton({
    Name = "Destroy UI",

    Callback = function()

        if Library.Destroy then
            Library:Destroy()
        end

    end
})

--------------------------------------------------
-- Access component values anywhere in your script
--
-- Toggle values return true or false
-- Slider values return numbers
-- Dropdown values return selected strings
--------------------------------------------------

task.spawn(function()

    while task.wait(5) do

        print(
            "Auto Farm:",
            Library.Flags["Auto Farm"]
        )

        print(
            "Farm Speed:",
            Library.Flags["Farm Speed"]
        )

        print(
            "Selected Egg:",
            Library.Flags["Selected Egg"]
        )

    end

end)
```
