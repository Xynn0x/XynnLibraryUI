Example

```lua
local Library = loadstring(game:HttpGet("YOUR_LIBRARY_LINK"))()

-- Ubah accent color global (opsional)
Library:SetAccentColor(Color3.fromRGB(0, 170, 255))

-- Create Window
local Window = Library:CreateWindow({
    Title = "Xynn Hub",
    AccentColor = Color3.fromRGB(0, 170, 255)
})

-- Notification
Library:Notify({
    Title = "Xynn Hub",
    Description = "Library Loaded Successfully",
    Duration = 5
})

--------------------------------------------------
-- MAIN TAB
--------------------------------------------------

local Main = Window:AddTab("Main")

Main:AddSection("Automation")

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

Main:AddSlider({
    Name = "Farm Speed",
    Min = 1,
    Max = 100,
    Default = 25,
    Callback = function(Value)
        print("Farm Speed:", Value)
    end
})

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

Main:AddButton({
    Name = "Open Selected Egg",
    Callback = function()
        print("Opening:", Library.Flags["Selected Egg"])
    end
})

Main:AddDivider()

Main:AddButton({
    Name = "Show Notification",
    Callback = function()
        Library:Notify({
            Title = "Hello!",
            Description = "This is a test notification.",
            Duration = 4
        })
    end
})

--------------------------------------------------
-- PLAYER TAB
--------------------------------------------------

local Player = Window:AddTab("Player")

Player:AddSection("Character")

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

Player:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(State)
        print("Infinite Jump:", State)
    end
})

--------------------------------------------------
-- TELEPORT TAB
--------------------------------------------------

local Teleport = Window:AddTab("Teleport")

Teleport:AddSection("Locations")

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

Teleport:AddButton({
    Name = "Teleport",
    Callback = function()
        local Location = Library.Flags["Destination"]

        print("Teleporting To:", Location)

        -- Contoh teleport
        local HRP = game.Players.LocalPlayer.Character and
                    game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if HRP then
            if Location == "Spawn" then
                HRP.CFrame = CFrame.new(0,5,0)

            elseif Location == "Shop" then
                HRP.CFrame = CFrame.new(100,5,0)

            elseif Location == "Forest" then
                HRP.CFrame = CFrame.new(200,5,0)

            elseif Location == "Desert" then
                HRP.CFrame = CFrame.new(300,5,0)

            elseif Location == "Boss Area" then
                HRP.CFrame = CFrame.new(400,5,0)
            end
        end
    end
})

--------------------------------------------------
-- MISC TAB
--------------------------------------------------

local Misc = Window:AddTab("Misc")

Misc:AddSection("Utilities")

Misc:AddButton({
    Name = "Print All Flags",
    Callback = function()

        print("===== FLAGS =====")

        for Name, Value in pairs(Library.Flags) do
            print(Name, Value)
        end

    end
})

Misc:AddButton({
    Name = "Copy Discord",
    Callback = function()

        if setclipboard then
            setclipboard("https://discord.gg/example")
        end

        Library:Notify({
            Title = "Copied",
            Description = "Discord Invite Copied",
            Duration = 3
        })
    end
})

Misc:AddDivider("Danger Zone")

Misc:AddButton({
    Name = "Destroy UI",
    Callback = function()

        if Library.Destroy then
            Library:Destroy()
        end

    end
})

--------------------------------------------------
-- ACCESS FLAGS ANYWHERE
--------------------------------------------------

task.spawn(function()

    while task.wait(5) do

        print("Auto Farm:",
            Library.Flags["Auto Farm"]
        )

        print("Farm Speed:",
            Library.Flags["Farm Speed"]
        )

        print("Selected Egg:",
            Library.Flags["Selected Egg"]
        )

    end

end)
```
