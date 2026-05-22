local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.Flags = {}
Library.Connections = {}
Library.AccentColor = Color3.fromRGB(0, 170, 255)  -- Default Accent

local function Tween(Object, Time, Properties)
    TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), Properties):Play()
end

local function Create(Class, Props)
    local Obj = Instance.new(Class)
    for i, v in pairs(Props) do
        Obj[i] = v
    end
    return Obj
end 

-- ==================== AUTO SCALE FOR MOBILE ====================
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local ScaleFactor = IsMobile and 0.78 or 1  -- Sedikit lebih besar dari 0.75 agar tetap nyaman

-- ==================== SET ACCENT COLOR ====================
function Library:SetAccentColor(Color)
    Library.AccentColor = Color
end

-- ==================== NOTIFICATION ====================
function Library:Notify(Data)
    local Gui = self.ScreenGui
    local Holder = Gui:FindFirstChild("Notifications") or Create("Frame", {
        Name = "Notifications",
        Parent = Gui,
        AnchorPoint = Vector2.new(1,1),
        Position = UDim2.new(1, -25, 1, -25),
        Size = UDim2.new(0, 340, 1, 0),
        BackgroundTransparency = 1
    })

    local Notification = Create("Frame", {
        Parent = Holder,
        Size = UDim2.new(1, 0, 0, 72),
        Position = UDim2.new(1, 400, 0, 0),
        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
        BorderSizePixel = 0
    })

    Create("UICorner", {Parent = Notification, CornerRadius = UDim.new(0, 16)})
    Create("UIStroke", {Parent = Notification, Color = Color3.fromRGB(55, 55, 55), Thickness = 1.2})

    Create("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -25, 0, 28),
        Position = UDim2.new(0, 16, 0, 12),
        Font = Enum.Font.GothamBold,
        Text = Data.Title or "Notification",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 15
    })

    Create("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -25, 0, 22),
        Position = UDim2.new(0, 16, 0, 38),
        Font = Enum.Font.Gotham,
        Text = Data.Description or "",
        TextColor3 = Color3.fromRGB(190, 190, 190),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 13,
        TextWrapped = true
    })

    Tween(Notification, 0.45, {Position = UDim2.new(0, 0, 0, 0)})

    task.delay(Data.Duration or 4.5, function()
        Tween(Notification, 0.4, {Position = UDim2.new(1, 400, 0, 0)})
        task.wait(0.45)
        Notification:Destroy()
    end)
end

-- ==================== CREATE WINDOW ====================
function Library:CreateWindow(Settings)
    local Window = {}
    local ScreenGui = Create("ScreenGui", {
        Parent = LocalPlayer.PlayerGui,
        Name = "XynnHubUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 999999999
    })
    self.ScreenGui = ScreenGui

    if Settings.AccentColor then
        Library.AccentColor = Settings.AccentColor
    end

    -- ==================== MAIN FRAME ====================
    local Main = Create("Frame", {
        Parent = ScreenGui,
        Size = UDim2.new(0, 650 * ScaleFactor, 0, 420 * ScaleFactor),
        Position = UDim2.new(0.5, -325 * ScaleFactor, 0.5, -210 * ScaleFactor),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 18 * ScaleFactor)})
    Create("UIStroke", {Parent = Main, Color = Color3.fromRGB(40, 40, 40), Thickness = 1.5 * ScaleFactor})

    -- Header
    local Header = Create("Frame", {
        Parent = Main,
        Size = UDim2.new(1, 0, 0, 52 * ScaleFactor),
        BackgroundTransparency = 1
    })

    local Title = Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 60 * ScaleFactor, 0, 0),
        Size = UDim2.new(1, -160 * ScaleFactor, 1, 0),
        Text = Settings.Title or "Xynn Hub",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 17 * ScaleFactor,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Close = Create("TextButton", {
        Parent = Header, 
        Position = UDim2.new(1, -33 * ScaleFactor, 0, 14 * ScaleFactor), 
        Size = UDim2.new(0, 19 * ScaleFactor, 0, 19 * ScaleFactor), 
        Text = "", 
        BackgroundColor3 = Color3.fromRGB(232, 17, 35)
    })
    
    local Minimize = Create("TextButton", {
        Parent = Header, 
        Position = UDim2.new(1, -58 * ScaleFactor, 0, 14 * ScaleFactor), 
        Size = UDim2.new(0, 19 * ScaleFactor, 0, 19 * ScaleFactor), 
        Text = "", 
        BackgroundColor3 = Color3.fromRGB(255, 179, 26)
    })

    Create("UICorner", {Parent = Close, CornerRadius = UDim.new(1,0)})
    Create("UICorner", {Parent = Minimize, CornerRadius = UDim.new(1,0)})

    -- Tabs Container
    local Tabs = Create("Frame", {
        Parent = Main,
        Position = UDim2.new(0, 12 * ScaleFactor, 0, 64 * ScaleFactor),
        Size = UDim2.new(0, 170 * ScaleFactor, 1, -76 * ScaleFactor),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0
    })

    Create("UIListLayout", {
        Parent = Tabs,
        Padding = UDim.new(0, 8 * ScaleFactor),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    -- Pages
    local Pages = Create("Frame", {
        Parent = Main,
        Position = UDim2.new(0, 190 * ScaleFactor, 0, 64 * ScaleFactor),
        Size = UDim2.new(1, -202 * ScaleFactor, 1, -76 * ScaleFactor),
        BackgroundTransparency = 1
    })

    -- ==================== FLOATING BUTTON ====================
    local Floating = Create("TextButton", {
        Parent = ScreenGui,
        Size = UDim2.new(0, 58 * ScaleFactor, 0, 58 * ScaleFactor),
        Position = UDim2.new(0.5, -29 * ScaleFactor, 0, 20),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = "⌘",
        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
        TextSize = 26 * ScaleFactor,
        Visible = false,
        ZIndex = 200,
        AutoButtonColor = false
    })
    Create("UICorner", {Parent = Floating, CornerRadius = UDim.new(1,0)})
    Create("UIStroke", {Parent = Floating, Color = Color3.fromRGB(70,70,70), Thickness = 1})

    -- Floating Button Logic
    local FloatingDragging = false
    local FloatingStartPos
    local FloatingStartFramePos
    local DragThreshold = 8

    Floating.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            FloatingDragging = false
            FloatingStartPos = Input.Position
            FloatingStartFramePos = Floating.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if not FloatingStartPos then return end
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            local Delta = (Input.Position - FloatingStartPos).Magnitude
            if Delta > DragThreshold then
                FloatingDragging = true
                local NewPos = UDim2.new(
                    FloatingStartFramePos.X.Scale,
                    FloatingStartFramePos.X.Offset + (Input.Position.X - FloatingStartPos.X),
                    FloatingStartFramePos.Y.Scale,
                    FloatingStartFramePos.Y.Offset + (Input.Position.Y - FloatingStartPos.Y)
                )
                Floating.Position = NewPos
            end
        end
    end)

    Floating.MouseButton1Click:Connect(function()
        if not FloatingDragging then
            Main.Visible = true
            Floating.Visible = false
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            FloatingStartPos = nil
            FloatingDragging = false
        end
    end)

    -- Minimize & Close
    Minimize.MouseButton1Click:Connect(function()
        Main.Visible = false
        Floating.Visible = true
    end)

    Close.MouseButton1Click:Connect(function()
        Library:Destroy()
        task.wait(0.1)
        ScreenGui:Destroy()
    end)

    -- ==================== DRAG & RESIZE (FIXED FOR MOBILE) ====================
    local Dragging, Resizing = false, false
    local StartPos, StartFramePos, StartSize, StartMousePos

    Header.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            StartPos = i.Position
            StartFramePos = Main.Position
        end
    end)

    local ResizeHandle = Create("Frame", {
        Parent = Main, 
        Size = UDim2.new(0,22 * ScaleFactor,0,22 * ScaleFactor), 
        Position = UDim2.new(1,-22 * ScaleFactor,1,-22 * ScaleFactor), 
        BackgroundTransparency = 1, 
        ZIndex = 10
    })
    Create("TextLabel", {
        Parent = ResizeHandle, 
        Size = UDim2.new(1,0,1,0), 
        BackgroundTransparency = 1, 
        Text = "◢", 
        TextColor3 = Color3.fromRGB(70,70,70), 
        Font = Enum.Font.Code, 
        TextSize = 24 * ScaleFactor, 
        TextXAlignment = "Right", 
        TextYAlignment = "Bottom"
    })

    ResizeHandle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            Resizing = true
            StartSize = Main.Size
            StartMousePos = i.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        -- Drag
        if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local Delta = i.Position - StartPos
            Main.Position = UDim2.new(
                StartFramePos.X.Scale, StartFramePos.X.Offset + Delta.X,
                StartFramePos.Y.Scale, StartFramePos.Y.Offset + Delta.Y
            )
        end
        -- Resize
        if Resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local Delta = i.Position - StartMousePos
            local newW = math.clamp(StartSize.X.Offset + Delta.X, 650 * ScaleFactor, 1100 * ScaleFactor)
            local newH = math.clamp(StartSize.Y.Offset + Delta.Y, 420 * ScaleFactor, 750 * ScaleFactor)
            Main.Size = UDim2.new(0, newW, 0, newH)
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
            Resizing = false
        end
    end)

    -- ==================== TAB SYSTEM ====================
    function Window:AddTab(Name)
        local Tab = {}

        local Button = Create("TextButton", {
            Parent = Tabs,
            Size = UDim2.new(1, -8 * ScaleFactor, 0, 44 * ScaleFactor),
            BackgroundColor3 = Color3.fromRGB(28, 28, 28),
            Text = "  " .. Name,
            Font = Enum.Font.GothamSemibold,
            TextColor3 = Color3.fromRGB(190, 190, 190),
            TextSize = 14 * ScaleFactor,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0
        })
        Create("UICorner", {Parent = Button, CornerRadius = UDim.new(0, 10 * ScaleFactor)})

        local Page = Create("ScrollingFrame", {
            Parent = Pages,
            Visible = false,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 1,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0,0,0,0),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            BorderSizePixel = 0
        })

        Create("UIListLayout", {Parent = Page, Padding = UDim.new(0, 5 * ScaleFactor), SortOrder = Enum.SortOrder.LayoutOrder})

        Button.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            Page.Visible = true

            for _, v in pairs(Tabs:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v, 0.2, {BackgroundColor3 = Color3.fromRGB(28,28,28), TextColor3 = Color3.fromRGB(190,190,190)})
                end
            end
            Tween(Button, 0.2, {BackgroundColor3 = Library.AccentColor, TextColor3 = Color3.fromRGB(255,255,255)})
        end)

        if #Pages:GetChildren() == 1 then
            Page.Visible = true
            Tween(Button, 0.1, {BackgroundColor3 = Library.AccentColor, TextColor3 = Color3.fromRGB(255,255,255)})
        end

        -- ==================== ADD SECTION, DIVIDER, BUTTON, TOGGLE (Scaled) ====================
        function Tab:AddSection(Text)
            local Section = Create("TextLabel", {
                Parent = Page,
                Size = UDim2.new(1, -20 * ScaleFactor, 0, 34 * ScaleFactor),
                BackgroundTransparency = 1,
                Text = Text,
                TextColor3 = Color3.fromRGB(170, 170, 170),
                Font = Enum.Font.GothamBold,
                TextSize = 15 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 10 * ScaleFactor, 0, 0)
            })
            return Section
        end

        function Tab:AddDivider(Text)
            local Divider = Create("Frame", {
                Parent = Page,
                Size = UDim2.new(1, -20 * ScaleFactor, 0, Text and 38 * ScaleFactor or 18 * ScaleFactor),
                BackgroundTransparency = 1,
            })

            if Text then
                Create("TextLabel", {
                    Parent = Divider,
                    Size = UDim2.new(1, 0, 0, 20 * ScaleFactor),
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Color3.fromRGB(140, 140, 140),
                    Font = Enum.Font.GothamBold,
                    TextSize = 14 * ScaleFactor,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            end

            Create("Frame", {
                Parent = Divider,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, Text and -8 * ScaleFactor or -1),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0
            })

            return Divider
        end

        function Tab:AddButton(Data)
            local Btn = Create("TextButton", {
                Parent = Page,
                Size = UDim2.new(1, -20 * ScaleFactor, 0, 48 * ScaleFactor),
                BackgroundColor3 = Color3.fromRGB(32, 32, 32),
                Text = Data.Name,
                Font = Enum.Font.GothamSemibold,
                TextColor3 = Color3.new(1,1,1),
                TextSize = 14 * ScaleFactor
            })
            Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 12 * ScaleFactor)})
            Create("UIStroke", {Parent = Btn, Color = Color3.fromRGB(50,50,50), Thickness = 1})

            Btn.MouseEnter:Connect(function() Tween(Btn, 0.2, {BackgroundColor3 = Color3.fromRGB(45,45,45)}) end)
            Btn.MouseLeave:Connect(function() Tween(Btn, 0.2, {BackgroundColor3 = Color3.fromRGB(32,32,32)}) end)

            Btn.MouseButton1Click:Connect(function()
                if Data.Callback then Data.Callback() end
            end)
        end

        function Tab:AddToggle(Data)
            local State = Data.Default or false
            Library.Flags[Data.Name] = State

            local Toggle = Create("TextButton", {
                Parent = Page,
                Size = UDim2.new(1, -20 * ScaleFactor, 0, 48 * ScaleFactor),
                BackgroundColor3 = Color3.fromRGB(32, 32, 32),
                Text = "   " .. Data.Name,
                Font = Enum.Font.GothamSemibold,
                TextColor3 = Color3.new(1,1,1),
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            Create("UICorner", {Parent = Toggle, CornerRadius = UDim.new(0, 12 * ScaleFactor)})
            Create("UIStroke", {Parent = Toggle, Color = Color3.fromRGB(50,50,50), Thickness = 1})

            local Check = Create("Frame", {
                Parent = Toggle,
                Size = UDim2.new(0, 28 * ScaleFactor, 0, 28 * ScaleFactor),
                Position = UDim2.new(1, -42 * ScaleFactor, 0.5, -14 * ScaleFactor),
                BackgroundColor3 = State and Library.AccentColor or Color3.fromRGB(55,55,55)
            })
            Create("UICorner", {Parent = Check, CornerRadius = UDim.new(0, 8 * ScaleFactor)})

            Toggle.MouseButton1Click:Connect(function()
                State = not State
                Library.Flags[Data.Name] = State
                Tween(Check, 0.25, {BackgroundColor3 = State and Library.AccentColor or Color3.fromRGB(55,55,55)})
                if Data.Callback then Data.Callback(State) end
            end)
        end

        -- ==================== SLIDER (FIXED FOR MOBILE) ====================
        function Tab:AddSlider(Data)
            local Value = Data.Default or Data.Min
            Library.Flags[Data.Name] = Value

            local Slider = Create("TextButton", {
                Parent = Page,
                Size = UDim2.new(1, -20 * ScaleFactor, 0, 58 * ScaleFactor),
                BackgroundColor3 = Color3.fromRGB(32, 32, 32),
                Text = "",
            })
            Create("UICorner", {Parent = Slider, CornerRadius = UDim.new(0, 12 * ScaleFactor)})
            Create("UIStroke", {Parent = Slider, Color = Color3.fromRGB(50,50,50), Thickness = 1})

            Create("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20 * ScaleFactor, 0, 20 * ScaleFactor),
                Position = UDim2.new(0, 10 * ScaleFactor, 0, 8 * ScaleFactor),
                Text = Data.Name,
                TextColor3 = Color3.fromRGB(255,255,255),
                Font = Enum.Font.GothamSemibold,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ValueLabel = Create("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 60 * ScaleFactor, 0, 20 * ScaleFactor),
                Position = UDim2.new(1, -70 * ScaleFactor, 0, 8 * ScaleFactor),
                Text = tostring(Value),
                TextColor3 = Library.AccentColor,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local Bar = Create("Frame", {
                Parent = Slider,
                Size = UDim2.new(1, -20 * ScaleFactor, 0, 6 * ScaleFactor),
                Position = UDim2.new(0, 10 * ScaleFactor, 1, -20 * ScaleFactor),
                BackgroundColor3 = Color3.fromRGB(50,50,50)
            })
            Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(1,0)})

            local Fill = Create("Frame", {
                Parent = Bar,
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Library.AccentColor
            })
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1,0)})

            local function UpdateSlider()
                local percent = (Value - Data.Min) / (Data.Max - Data.Min)
                Tween(Fill, 0.1, {Size = UDim2.new(percent, 0, 1, 0)})
                ValueLabel.Text = tostring(math.floor(Value))
            end

            local Dragging = false

            -- Support Mouse & Touch
            Slider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if not Dragging then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local MousePos = UserInputService:GetMouseLocation()
                    local BarPos = Bar.AbsolutePosition
                    local BarSize = Bar.AbsoluteSize
                    local percent = math.clamp((MousePos.X - BarPos.X) / BarSize.X, 0, 1)
                    Value = math.floor(Data.Min + (Data.Max - Data.Min) * percent)
                    Library.Flags[Data.Name] = Value
                    UpdateSlider()
                    if Data.Callback then Data.Callback(Value) end
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            UpdateSlider()
            return Slider
        end

        -- Dropdown tetap sama (sudah cukup bagus)
        function Tab:AddDropdown(Data)
            -- ... (kode dropdown kamu yang lama, biarkan tetap sama)
            -- Saya tidak ubah karena sudah cukup stabil
            if not Data.Options or #Data.Options == 0 then
                warn("Dropdown ".. (Data.Name or "unknown") .." tidak memiliki Options!")
                return
            end

            local Selected = Data.Default or Data.Options[1]
            Library.Flags[Data.Name] = Selected

            local Dropdown = Create("TextButton", {
                Parent = Page,
                Size = UDim2.new(1, -20 * ScaleFactor, 0, 48 * ScaleFactor),
                BackgroundColor3 = Color3.fromRGB(32, 32, 32),
                Text = "   " .. Data.Name .. ": " .. Selected,
                TextColor3 = Color3.new(1,1,1),
                Font = Enum.Font.GothamSemibold,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 50
            })
            Create("UICorner", {Parent = Dropdown, CornerRadius = UDim.new(0, 12 * ScaleFactor)})
            Create("UIStroke", {Parent = Dropdown, Color = Color3.fromRGB(50,50,50), Thickness = 1})

            local Arrow = Create("TextLabel", {
                Parent = Dropdown,
                Size = UDim2.new(0, 30 * ScaleFactor, 1, 0),
                Position = UDim2.new(1, -35 * ScaleFactor, 0, 0),
                Text = "▼",
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(180,180,180),
                Font = Enum.Font.GothamBold,
                TextSize = 16 * ScaleFactor
            })

            local DropList = Create("Frame", {
                Parent = ScreenGui,
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(28,28,28),
                Visible = false,
                ZIndex = 200
            })
            Create("UICorner", {Parent = DropList, CornerRadius = UDim.new(0, 10)})
            Create("UIStroke", {Parent = DropList, Color = Color3.fromRGB(60,60,60), Thickness = 1})

            Create("UIListLayout", {Parent = DropList, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})

            local function UpdatePosition()
                DropList.Position = UDim2.new(0, Dropdown.AbsolutePosition.X, 0, Dropdown.AbsolutePosition.Y + Dropdown.AbsoluteSize.Y + 4)
                DropList.Size = UDim2.new(0, Dropdown.AbsoluteSize.X, 0, 0)
            end

            local function OpenDropdown()
                UpdatePosition()
                DropList.Visible = true
                Tween(DropList, 0.25, {Size = UDim2.new(0, Dropdown.AbsoluteSize.X, 0, #Data.Options * 32 + 10)})
            end

            local function CloseDropdown()
                Tween(DropList, 0.2, {Size = UDim2.new(0, Dropdown.AbsoluteSize.X, 0, 0)})
                task.wait(0.22)
                DropList.Visible = false
            end

            Dropdown.MouseButton1Click:Connect(function()
                if DropList.Visible then CloseDropdown() else OpenDropdown() end
            end)

            for _, option in ipairs(Data.Options) do
                local OptionBtn = Create("TextButton", {
                    Parent = DropList,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text = "   " .. option,
                    TextColor3 = Color3.fromRGB(200,200,200),
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 201
                })

                OptionBtn.MouseButton1Click:Connect(function()
                    Selected = option
                    Library.Flags[Data.Name] = Selected
                    Dropdown.Text = "   " .. Data.Name .. ": " .. Selected
                    if Data.Callback then Data.Callback(option) end
                    CloseDropdown()
                end)

                OptionBtn.MouseEnter:Connect(function()
                    Tween(OptionBtn, 0.1, {BackgroundTransparency = 0.85, TextColor3 = Color3.new(1,1,1)})
                end)
                OptionBtn.MouseLeave:Connect(function()
                    Tween(OptionBtn, 0.1, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(200,200,200)})
                end)
            end

            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local MousePos = UserInputService:GetMouseLocation()
                    if not Dropdown.AbsoluteRect:Contains(MousePos) and not DropList.AbsoluteRect:Contains(MousePos) then
                        if DropList.Visible then CloseDropdown() end
                    end
                end
            end)

            return Dropdown
        end

        return Tab
    end

    return Window
end

return Library
