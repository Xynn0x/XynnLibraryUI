-- =============================================
--          XynnHub UI Library v2.0
--    Modern UI Library for Roblox Scripts
--    Features: Themes, ColorPicker, Keybind,
--    TextBox, MultiDropdown, Loading, Watermark
-- =============================================

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer

local Library = {}
Library.Flags       = {}
Library.Connections = {}
Library.AccentColor = Color3.fromRGB(0, 170, 255)
Library.ScreenGui   = nil

-- ==================== THEMES ====================
Library.Themes = {
    Dark = {
        Background    = Color3.fromRGB(20,  20,  20 ),
        Secondary     = Color3.fromRGB(28,  28,  28 ),
        Tertiary      = Color3.fromRGB(32,  32,  32 ),
        Stroke        = Color3.fromRGB(50,  50,  50 ),
        TextPrimary   = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(190, 190, 190),
        TextMuted     = Color3.fromRGB(140, 140, 140),
    },
    Midnight = {
        Background    = Color3.fromRGB(10,  10,  18 ),
        Secondary     = Color3.fromRGB(18,  18,  30 ),
        Tertiary      = Color3.fromRGB(24,  24,  38 ),
        Stroke        = Color3.fromRGB(45,  45,  70 ),
        TextPrimary   = Color3.fromRGB(220, 220, 255),
        TextSecondary = Color3.fromRGB(170, 170, 210),
        TextMuted     = Color3.fromRGB(120, 120, 160),
    },
    Light = {
        Background    = Color3.fromRGB(235, 235, 235),
        Secondary     = Color3.fromRGB(218, 218, 218),
        Tertiary      = Color3.fromRGB(202, 202, 202),
        Stroke        = Color3.fromRGB(168, 168, 168),
        TextPrimary   = Color3.fromRGB(25,  25,  25 ),
        TextSecondary = Color3.fromRGB(75,  75,  75 ),
        TextMuted     = Color3.fromRGB(115, 115, 115),
    },
    Ocean = {
        Background    = Color3.fromRGB(8,   20,  35 ),
        Secondary     = Color3.fromRGB(14,  30,  50 ),
        Tertiary      = Color3.fromRGB(18,  38,  62 ),
        Stroke        = Color3.fromRGB(30,  65,  100),
        TextPrimary   = Color3.fromRGB(200, 230, 255),
        TextSecondary = Color3.fromRGB(150, 190, 230),
        TextMuted     = Color3.fromRGB(100, 145, 185),
    },
    Rose = {
        Background    = Color3.fromRGB(22,  12,  18 ),
        Secondary     = Color3.fromRGB(32,  18,  26 ),
        Tertiary      = Color3.fromRGB(40,  22,  32 ),
        Stroke        = Color3.fromRGB(75,  35,  55 ),
        TextPrimary   = Color3.fromRGB(255, 220, 235),
        TextSecondary = Color3.fromRGB(210, 165, 185),
        TextMuted     = Color3.fromRGB(160, 115, 135),
    },
}
Library.T = Library.Themes.Dark  -- active theme alias

-- ==================== UTILITIES ====================
local function Tween(Object, Time, Props)
    TweenService:Create(
        Object,
        TweenInfo.new(Time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        Props
    ):Play()
end

local function Create(Class, Props)
    local Obj = Instance.new(Class)
    for k, v in pairs(Props) do
        Obj[k] = v
    end
    return Obj
end

local IsMobile    = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local ScaleFactor = IsMobile and 0.78 or 1

local function S(n) return n * ScaleFactor end  -- shorthand scale

-- ==================== THEME / ACCENT ====================
function Library:SetTheme(Name)
    if Library.Themes[Name] then
        Library.T = Library.Themes[Name]
    end
end

function Library:SetAccentColor(Color)
    Library.AccentColor = Color
end

-- ==================== DESTROY ====================
function Library:Destroy()
    for _, conn in pairs(Library.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            pcall(function() conn:Disconnect() end)
        end
    end
    Library.Connections = {}
    if Library.ScreenGui then
        Library.ScreenGui:Destroy()
        Library.ScreenGui = nil
    end
end

-- ==================== NOTIFICATIONS ====================
local NotifTypes = {
    Default = { Icon = "●", Color = Color3.fromRGB(0,   170, 255) },
    Success = { Icon = "✓", Color = Color3.fromRGB(50,  210, 110) },
    Error   = { Icon = "✕", Color = Color3.fromRGB(230, 55,  55 ) },
    Warning = { Icon = "!", Color = Color3.fromRGB(255, 190, 30 ) },
    Info    = { Icon = "i", Color = Color3.fromRGB(90,  160, 255) },
}

function Library:Notify(Data)
    local Gui = self.ScreenGui
    if not Gui then return end
    local T    = Library.T
    local NType = NotifTypes[Data.Type or "Default"] or NotifTypes.Default

    local Holder = Gui:FindFirstChild("NotifHolder") or Create("Frame", {
        Name              = "NotifHolder",
        Parent            = Gui,
        AnchorPoint       = Vector2.new(1, 1),
        Position          = UDim2.new(1, -12, 1, -12),
        Size              = UDim2.new(0, S(310), 1, 0),
        BackgroundTransparency = 1,
    })

    Create("UIListLayout", {
        Parent           = Holder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding          = UDim.new(0, S(6)),
        SortOrder        = Enum.SortOrder.LayoutOrder,
    })

    local Notif = Create("Frame", {
        Parent           = Holder,
        Size             = UDim2.new(1, 0, 0, S(78)),
        Position         = UDim2.new(1, 400, 0, 0),
        BackgroundColor3 = T.Secondary,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
    })
    Create("UICorner", { Parent = Notif, CornerRadius = UDim.new(0, S(14)) })
    Create("UIStroke",  { Parent = Notif, Color = T.Stroke, Thickness = 1.2 })

    -- Colored left accent bar
    local AccBar = Create("Frame", {
        Parent          = Notif,
        Size            = UDim2.new(0, S(4), 1, 0),
        BackgroundColor3 = NType.Color,
        BorderSizePixel = 0,
    })
    Create("UICorner", { Parent = AccBar, CornerRadius = UDim.new(0, S(4)) })

    -- Icon
    Create("TextLabel", {
        Parent               = Notif,
        BackgroundTransparency = 1,
        Position             = UDim2.new(0, S(14), 0.5, S(-11)),
        Size                 = UDim2.new(0, S(22), 0, S(22)),
        Text                 = NType.Icon,
        TextColor3           = NType.Color,
        Font                 = Enum.Font.GothamBold,
        TextSize             = S(15),
    })

    -- Title
    Create("TextLabel", {
        Parent               = Notif,
        BackgroundTransparency = 1,
        Position             = UDim2.new(0, S(44), 0, S(12)),
        Size                 = UDim2.new(1, S(-52), 0, S(22)),
        Text                 = Data.Title or "Notification",
        TextColor3           = T.TextPrimary,
        Font                 = Enum.Font.GothamBold,
        TextSize             = S(13),
        TextXAlignment       = Enum.TextXAlignment.Left,
    })

    -- Description
    Create("TextLabel", {
        Parent               = Notif,
        BackgroundTransparency = 1,
        Position             = UDim2.new(0, S(44), 0, S(36)),
        Size                 = UDim2.new(1, S(-52), 0, S(30)),
        Text                 = Data.Description or "",
        TextColor3           = T.TextSecondary,
        Font                 = Enum.Font.Gotham,
        TextSize             = S(12),
        TextXAlignment       = Enum.TextXAlignment.Left,
        TextWrapped          = true,
    })

    -- Progress bar
    local ProgTrack = Create("Frame", {
        Parent          = Notif,
        AnchorPoint     = Vector2.new(0, 1),
        Position        = UDim2.new(0, 0, 1, 0),
        Size            = UDim2.new(1, 0, 0, S(2)),
        BackgroundColor3 = T.Stroke,
        BorderSizePixel = 0,
    })
    local ProgFill = Create("Frame", {
        Parent          = ProgTrack,
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = NType.Color,
        BorderSizePixel = 0,
    })

    local duration = Data.Duration or 4.5
    Tween(Notif, 0.4, { Position = UDim2.new(0, 0, 0, 0) })
    Tween(ProgFill, duration, { Size = UDim2.new(0, 0, 1, 0) })

    task.delay(duration, function()
        Tween(Notif, 0.35, { Position = UDim2.new(1, 400, 0, 0) })
        task.wait(0.4)
        Notif:Destroy()
    end)
end

-- ==================== WATERMARK ====================
function Library:Watermark(Data)
    local Gui = self.ScreenGui
    if not Gui then return end
    local T = Library.T

    local Frame = Create("Frame", {
        Parent          = Gui,
        AnchorPoint     = Vector2.new(0, 0),
        Position        = UDim2.new(0, S(10), 0, S(10)),
        Size            = UDim2.new(0, S(10), 0, S(28)),
        AutomaticSize   = Enum.AutomaticSize.X,
        BackgroundColor3 = T.Secondary,
        BorderSizePixel = 0,
        ZIndex          = 100,
    })
    Create("UICorner",  { Parent = Frame, CornerRadius = UDim.new(0, S(8)) })
    Create("UIStroke",  { Parent = Frame, Color = T.Stroke, Thickness = 1 })
    Create("UIPadding", {
        Parent       = Frame,
        PaddingLeft  = UDim.new(0, S(10)),
        PaddingRight = UDim.new(0, S(10)),
    })
    Create("UIListLayout", {
        Parent            = Frame,
        FillDirection     = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder         = Enum.SortOrder.LayoutOrder,
    })

    local AccentPart = Create("TextLabel", {
        Parent             = Frame,
        BackgroundTransparency = 1,
        Size               = UDim2.new(0, 0, 1, 0),
        AutomaticSize      = Enum.AutomaticSize.X,
        Text               = Data.Name or "XynnHub",
        TextColor3         = Library.AccentColor,
        Font               = Enum.Font.GothamBold,
        TextSize           = S(13),
        ZIndex             = 101,
        LayoutOrder        = 1,
    })

    local InfoPart = Create("TextLabel", {
        Parent             = Frame,
        BackgroundTransparency = 1,
        Size               = UDim2.new(0, 0, 1, 0),
        AutomaticSize      = Enum.AutomaticSize.X,
        Text               = "  |  " .. (Data.Info or "v2.0"),
        TextColor3         = T.TextMuted,
        Font               = Enum.Font.Gotham,
        TextSize           = S(13),
        ZIndex             = 101,
        LayoutOrder        = 2,
    })

    return {
        SetInfo    = function(text) InfoPart.Text = "  |  " .. text end,
        SetVisible = function(vis)  Frame.Visible  = vis end,
        SetName    = function(text) AccentPart.Text = text end,
    }
end

-- ==================== LOADING SCREEN ====================
function Library:LoadingScreen(Data)
    local Gui = self.ScreenGui
    if not Gui then return end

    local Overlay = Create("Frame", {
        Parent          = Gui,
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        ZIndex          = 9999,
    })

    local Box = Create("Frame", {
        Parent          = Overlay,
        AnchorPoint     = Vector2.new(0.5, 0.5),
        Position        = UDim2.new(0.5, 0, 0.5, 0),
        Size            = UDim2.new(0, S(360), 0, S(175)),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        ZIndex          = 10000,
    })
    Create("UICorner", { Parent = Box, CornerRadius = UDim.new(0, S(18)) })
    Create("UIStroke",  { Parent = Box, Color = Color3.fromRGB(45, 45, 45), Thickness = 1.5 })

    Create("TextLabel", {
        Parent             = Box,
        Position           = UDim2.new(0, 0, 0, S(30)),
        Size               = UDim2.new(1, 0, 0, S(30)),
        BackgroundTransparency = 1,
        Text               = Data.Title or "XynnHub",
        TextColor3         = Color3.new(1, 1, 1),
        Font               = Enum.Font.GothamBold,
        TextSize           = S(22),
        ZIndex             = 10001,
    })

    local SubLabel = Create("TextLabel", {
        Parent             = Box,
        Position           = UDim2.new(0, S(20), 0, S(72)),
        Size               = UDim2.new(1, S(-40), 0, S(20)),
        BackgroundTransparency = 1,
        Text               = Data.Subtitle or "Loading...",
        TextColor3         = Color3.fromRGB(155, 155, 155),
        Font               = Enum.Font.Gotham,
        TextSize           = S(13),
        TextXAlignment     = Enum.TextXAlignment.Left,
        ZIndex             = 10001,
    })

    local Track = Create("Frame", {
        Parent          = Box,
        Position        = UDim2.new(0, S(20), 1, S(-28)),
        Size            = UDim2.new(1, S(-40), 0, S(5)),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        ZIndex          = 10001,
    })
    Create("UICorner", { Parent = Track, CornerRadius = UDim.new(1, 0) })

    local Fill = Create("Frame", {
        Parent          = Track,
        Size            = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Library.AccentColor,
        ZIndex          = 10002,
    })
    Create("UICorner", { Parent = Fill, CornerRadius = UDim.new(1, 0) })

    local Steps = Data.Steps or {}
    local finished = false

    local function Finish()
        if finished then return end
        finished = true
        Tween(Fill, 0.3, { Size = UDim2.new(1, 0, 1, 0) })
        task.wait(0.55)
        Tween(Overlay, 0.5, { BackgroundTransparency = 1 })
        for _, v in pairs(Box:GetDescendants()) do
            if v:IsA("GuiObject") then Tween(v, 0.4, { BackgroundTransparency = 1 }) end
        end
        task.wait(0.6)
        Overlay:Destroy()
    end

    task.spawn(function()
        if #Steps > 0 then
            for i, step in ipairs(Steps) do
                SubLabel.Text = step.Text or ("Step " .. i)
                Tween(Fill, 0.4, { Size = UDim2.new(i / #Steps, 0, 1, 0) })
                task.wait(step.Duration or 0.6)
            end
        else
            Tween(Fill, Data.Duration or 2, { Size = UDim2.new(1, 0, 1, 0) })
            task.wait(Data.Duration or 2)
        end
        Finish()
    end)

    return { Finish = Finish }
end

-- ==================== CREATE WINDOW ====================
function Library:CreateWindow(Settings)
    local Window = {}
    local T = Library.T

    local ScreenGui = Create("ScreenGui", {
        Parent           = LocalPlayer.PlayerGui,
        Name             = "XynnHubUI",
        ResetOnSpawn     = false,
        ZIndexBehavior   = Enum.ZIndexBehavior.Global,
        DisplayOrder     = 999999999,
    })
    Library.ScreenGui = ScreenGui

    if Settings.Theme      then Library:SetTheme(Settings.Theme) T = Library.T end
    if Settings.AccentColor then Library.AccentColor = Settings.AccentColor end

    -- ==================== MAIN FRAME ====================
    local Main = Create("Frame", {
        Parent           = ScreenGui,
        Size             = UDim2.new(0, S(670), 0, S(440)),
        Position         = UDim2.new(0.5, S(-335), 0.5, S(-220)),
        BackgroundColor3 = T.Background,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
    })
    Create("UICorner", { Parent = Main, CornerRadius = UDim.new(0, S(18)) })
    Create("UIStroke",  { Parent = Main, Color = T.Stroke, Thickness = 1.5 })

    -- ==================== HEADER ====================
    local Header = Create("Frame", {
        Parent             = Main,
        Size               = UDim2.new(1, 0, 0, S(52)),
        BackgroundColor3   = T.Secondary,
        BorderSizePixel    = 0,
    })
    Create("UICorner", { Parent = Header, CornerRadius = UDim.new(0, S(18)) })

    -- Patch bottom corners of header
    Create("Frame", {
        Parent          = Header,
        Position        = UDim2.new(0, 0, 1, S(-10)),
        Size            = UDim2.new(1, 0, 0, S(10)),
        BackgroundColor3 = T.Secondary,
        BorderSizePixel = 0,
    })

    -- Logo dot accent
    Create("Frame", {
        Parent          = Header,
        Position        = UDim2.new(0, S(16), 0.5, S(-6)),
        Size            = UDim2.new(0, S(12), 0, S(12)),
        BackgroundColor3 = Library.AccentColor,
        BorderSizePixel = 0,
    })
    Create("UICorner", { Parent = Header:FindFirstChildOfClass("Frame"), CornerRadius = UDim.new(1, 0) })

    local Title = Create("TextLabel", {
        Parent             = Header,
        BackgroundTransparency = 1,
        Position           = UDim2.new(0, S(36), 0, 0),
        Size               = UDim2.new(1, S(-150), 1, 0),
        Text               = Settings.Title or "Xynn Hub",
        Font               = Enum.Font.GothamBold,
        TextColor3         = T.TextPrimary,
        TextSize           = S(16),
        TextXAlignment     = Enum.TextXAlignment.Left,
    })

    local Subtitle = Create("TextLabel", {
        Parent             = Header,
        BackgroundTransparency = 1,
        Position           = UDim2.new(0, S(36), 0.5, 0),
        Size               = UDim2.new(1, S(-150), 0.5, 0),
        Text               = Settings.Subtitle or "",
        Font               = Enum.Font.Gotham,
        TextColor3         = T.TextMuted,
        TextSize           = S(11),
        TextXAlignment     = Enum.TextXAlignment.Left,
    })

    -- Window buttons
    local function MakeWinBtn(xOffset, color)
        local Btn = Create("TextButton", {
            Parent          = Header,
            Position        = UDim2.new(1, S(xOffset), 0.5, S(-9)),
            Size            = UDim2.new(0, S(18), 0, S(18)),
            Text            = "",
            BackgroundColor3 = color,
            AutoButtonColor = false,
        })
        Create("UICorner", { Parent = Btn, CornerRadius = UDim.new(1, 0) })
        return Btn
    end

    local CloseBtn    = MakeWinBtn(-28, Color3.fromRGB(232, 17, 35))
    local MinimizeBtn = MakeWinBtn(-52, Color3.fromRGB(255, 179, 26))

    -- ==================== TAB SIDEBAR ====================
    local Sidebar = Create("Frame", {
        Parent          = Main,
        Position        = UDim2.new(0, S(10), 0, S(60)),
        Size            = UDim2.new(0, S(175), 1, S(-72)),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    })

    Create("UIListLayout", {
        Parent    = Sidebar,
        Padding   = UDim.new(0, S(5)),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    -- Tab search box
    local SearchBox = Create("TextBox", {
        Parent           = Sidebar,
        Size             = UDim2.new(1, S(-8), 0, S(34)),
        BackgroundColor3 = T.Tertiary,
        BorderSizePixel  = 0,
        PlaceholderText  = "  🔍  Search tabs...",
        PlaceholderColor3 = T.TextMuted,
        Text             = "",
        TextColor3       = T.TextSecondary,
        Font             = Enum.Font.Gotham,
        TextSize         = S(12),
        ClearTextOnFocus = false,
    })
    Create("UICorner", { Parent = SearchBox, CornerRadius = UDim.new(0, S(10)) })
    Create("UIStroke",  { Parent = SearchBox, Color = T.Stroke, Thickness = 1 })

    -- ==================== PAGES AREA ====================
    local Pages = Create("Frame", {
        Parent             = Main,
        Position           = UDim2.new(0, S(196), 0, S(60)),
        Size               = UDim2.new(1, S(-208), 1, S(-72)),
        BackgroundTransparency = 1,
    })

    -- ==================== FLOATING BUTTON ====================
    local Floating = Create("TextButton", {
        Parent          = ScreenGui,
        Size            = UDim2.new(0, S(54), 0, S(54)),
        Position        = UDim2.new(0.5, S(-27), 0, S(18)),
        Text            = "⌘",
        TextColor3      = T.TextPrimary,
        TextSize        = S(24),
        BackgroundColor3 = T.Secondary,
        Visible         = false,
        ZIndex          = 200,
        AutoButtonColor = false,
    })
    Create("UICorner", { Parent = Floating, CornerRadius = UDim.new(1, 0) })
    Create("UIStroke",  { Parent = Floating, Color = T.Stroke, Thickness = 1.2 })

    -- Floating drag logic
    local FDragging, FStart, FFrameStart = false, nil, nil
    Floating.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            FDragging   = false
            FStart      = i.Position
            FFrameStart = Floating.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not FStart then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            if (i.Position - FStart).Magnitude > 6 then
                FDragging = true
                Floating.Position = UDim2.new(
                    FFrameStart.X.Scale, FFrameStart.X.Offset + (i.Position.X - FStart.X),
                    FFrameStart.Y.Scale, FFrameStart.Y.Offset + (i.Position.Y - FStart.Y)
                )
            end
        end
    end)
    Floating.MouseButton1Click:Connect(function()
        if not FDragging then Main.Visible = true Floating.Visible = false end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            FStart = nil FDragging = false
        end
    end)

    MinimizeBtn.MouseButton1Click:Connect(function()
        Main.Visible = false Floating.Visible = true
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        Library:Destroy()
    end)

    -- ==================== DRAG & RESIZE ====================
    local Dragging, Resizing = false, false
    local DragStart, DragFramePos, ResStart, ResStartSize

    Header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            Dragging      = true
            DragStart     = i.Position
            DragFramePos  = Main.Position
        end
    end)

    local ResizeHandle = Create("Frame", {
        Parent             = Main,
        Size               = UDim2.new(0, S(24), 0, S(24)),
        Position           = UDim2.new(1, S(-24), 1, S(-24)),
        BackgroundTransparency = 1,
        ZIndex             = 10,
    })
    Create("TextLabel", {
        Parent             = ResizeHandle,
        Size               = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text               = "◢",
        TextColor3         = T.Stroke,
        Font               = Enum.Font.Code,
        TextSize           = S(22),
        TextXAlignment     = Enum.TextXAlignment.Right,
        TextYAlignment     = Enum.TextYAlignment.Bottom,
    })
    ResizeHandle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            Resizing       = true
            ResStart       = i.Position
            ResStartSize   = Main.Size
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
        if Dragging then
            local Delta = i.Position - DragStart
            Main.Position = UDim2.new(DragFramePos.X.Scale, DragFramePos.X.Offset + Delta.X, DragFramePos.Y.Scale, DragFramePos.Y.Offset + Delta.Y)
        end
        if Resizing then
            local Delta = i.Position - ResStart
            Main.Size = UDim2.new(0, math.clamp(ResStartSize.X.Offset + Delta.X, S(520), S(1100)), 0, math.clamp(ResStartSize.Y.Offset + Delta.Y, S(380), S(780)))
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            Dragging = false Resizing = false
        end
    end)

    -- ==================== TOGGLE KEY ====================
    function Window:SetToggleKey(Key)
        local conn = UserInputService.InputBegan:Connect(function(i, g)
            if g then return end
            if i.KeyCode == Key then
                Main.Visible = not Main.Visible
                Floating.Visible = not Main.Visible
            end
        end)
        table.insert(Library.Connections, conn)
    end

    -- ==================== TAB SYSTEM ====================
    local TabButtons = {}

    -- Search filter
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBox.Text:lower()
        for _, btn in pairs(TabButtons) do
            if btn and btn.Parent then
                local name = btn.Text:lower():gsub("^%s+", "")
                btn.Visible = (query == "" or name:find(query, 1, true) ~= nil)
            end
        end
    end)

    function Window:AddTab(Name, Icon)
        local Tab = {}
        local T = Library.T

        local Btn = Create("TextButton", {
            Parent           = Sidebar,
            Size             = UDim2.new(1, S(-8), 0, S(40)),
            BackgroundColor3 = T.Secondary,
            Text             = (Icon and (Icon .. "  ") or "  ") .. Name,
            Font             = Enum.Font.GothamSemibold,
            TextColor3       = T.TextSecondary,
            TextSize         = S(13),
            TextXAlignment   = Enum.TextXAlignment.Left,
            BorderSizePixel  = 0,
            AutoButtonColor  = false,
        })
        Create("UICorner", { Parent = Btn, CornerRadius = UDim.new(0, S(10)) })
        table.insert(TabButtons, Btn)

        local Page = Create("ScrollingFrame", {
            Parent                = Pages,
            Visible               = false,
            Size                  = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness    = S(2),
            ScrollBarImageColor3  = Library.AccentColor,
            AutomaticCanvasSize   = Enum.AutomaticSize.Y,
            CanvasSize            = UDim2.new(0, 0, 0, 0),
            ScrollingDirection    = Enum.ScrollingDirection.Y,
            BorderSizePixel       = 0,
        })
        Create("UIListLayout", {
            Parent    = Page,
            Padding   = UDim.new(0, S(5)),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
        Create("UIPadding", {
            Parent       = Page,
            PaddingTop   = UDim.new(0, S(4)),
            PaddingBottom = UDim.new(0, S(8)),
        })

        Btn.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            Page.Visible = true
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v, 0.18, { BackgroundColor3 = T.Secondary, TextColor3 = T.TextSecondary })
                end
            end
            Tween(Btn, 0.18, { BackgroundColor3 = Library.AccentColor, TextColor3 = Color3.new(1,1,1) })
        end)

        Btn.MouseEnter:Connect(function()
            if not Page.Visible then
                Tween(Btn, 0.15, { BackgroundColor3 = T.Tertiary })
            end
        end)
        Btn.MouseLeave:Connect(function()
            if not Page.Visible then
                Tween(Btn, 0.15, { BackgroundColor3 = T.Secondary })
            end
        end)

        -- Auto-activate first tab
        if #Pages:GetChildren() == 1 then
            Page.Visible = true
            Btn.BackgroundColor3 = Library.AccentColor
            Btn.TextColor3 = Color3.new(1, 1, 1)
        end

        -- ===== HELPER: CONTAINER =====
        local function MakeContainer(height)
            local C = Create("Frame", {
                Parent          = Page,
                Size            = UDim2.new(1, S(-12), 0, S(height)),
                BackgroundColor3 = T.Tertiary,
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = C, CornerRadius = UDim.new(0, S(12)) })
            Create("UIStroke",  { Parent = C, Color = T.Stroke, Thickness = 1 })
            return C
        end

        -- ===== ADD SECTION =====
        function Tab:AddSection(Text)
            local Sec = Create("Frame", {
                Parent          = Page,
                Size            = UDim2.new(1, S(-12), 0, S(28)),
                BackgroundTransparency = 1,
            })
            Create("TextLabel", {
                Parent             = Sec,
                BackgroundTransparency = 1,
                Size               = UDim2.new(1, 0, 1, 0),
                Position           = UDim2.new(0, S(4), 0, 0),
                Text               = Text,
                TextColor3         = Library.AccentColor,
                Font               = Enum.Font.GothamBold,
                TextSize           = S(12),
                TextXAlignment     = Enum.TextXAlignment.Left,
            })
            Create("Frame", {
                Parent          = Sec,
                AnchorPoint     = Vector2.new(0, 1),
                Position        = UDim2.new(0, 0, 1, 0),
                Size            = UDim2.new(1, 0, 0, S(1)),
                BackgroundColor3 = T.Stroke,
                BorderSizePixel = 0,
            })
            return Sec
        end

        -- ===== ADD DIVIDER =====
        function Tab:AddDivider(Text)
            local H = Text and S(34) or S(14)
            local Div = Create("Frame", {
                Parent          = Page,
                Size            = UDim2.new(1, S(-12), 0, H),
                BackgroundTransparency = 1,
            })
            if Text then
                Create("TextLabel", {
                    Parent             = Div,
                    BackgroundTransparency = 1,
                    Size               = UDim2.new(1, 0, 0, S(18)),
                    Text               = Text,
                    TextColor3         = T.TextMuted,
                    Font               = Enum.Font.GothamBold,
                    TextSize           = S(11),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                })
            end
            Create("Frame", {
                Parent          = Div,
                AnchorPoint     = Vector2.new(0, 1),
                Position        = UDim2.new(0, 0, 1, 0),
                Size            = UDim2.new(1, 0, 0, S(1)),
                BackgroundColor3 = T.Stroke,
                BorderSizePixel = 0,
            })
            return Div
        end

        -- ===== ADD LABEL =====
        function Tab:AddLabel(Data)
            local C = MakeContainer(38)
            local Lbl = Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Size               = UDim2.new(1, S(-16), 1, 0),
                Position           = UDim2.new(0, S(12), 0, 0),
                Text               = Data.Text or "",
                TextColor3         = T.TextSecondary,
                Font               = Enum.Font.Gotham,
                TextSize           = S(13),
                TextXAlignment     = Enum.TextXAlignment.Left,
                TextWrapped        = true,
            })
            return {
                Set = function(text) Lbl.Text = text end,
                Get = function() return Lbl.Text end,
            }
        end

        -- ===== ADD PARAGRAPH =====
        function Tab:AddParagraph(Data)
            local C = Create("Frame", {
                Parent          = Page,
                Size            = UDim2.new(1, S(-12), 0, 0),
                AutomaticSize   = Enum.AutomaticSize.Y,
                BackgroundColor3 = T.Tertiary,
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = C, CornerRadius = UDim.new(0, S(12)) })
            Create("UIStroke",  { Parent = C, Color = T.Stroke, Thickness = 1 })
            Create("UIPadding", {
                Parent        = C,
                PaddingLeft   = UDim.new(0, S(12)),
                PaddingRight  = UDim.new(0, S(12)),
                PaddingTop    = UDim.new(0, S(10)),
                PaddingBottom = UDim.new(0, S(10)),
            })
            Create("UIListLayout", {
                Parent    = C,
                Padding   = UDim.new(0, S(4)),
                SortOrder = Enum.SortOrder.LayoutOrder,
            })

            local TitleLbl = Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Size               = UDim2.new(1, 0, 0, S(20)),
                AutomaticSize      = Enum.AutomaticSize.Y,
                Text               = Data.Title or "",
                TextColor3         = T.TextPrimary,
                Font               = Enum.Font.GothamBold,
                TextSize           = S(13),
                TextXAlignment     = Enum.TextXAlignment.Left,
                TextWrapped        = true,
                LayoutOrder        = 1,
            })

            local BodyLbl = Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Size               = UDim2.new(1, 0, 0, S(14)),
                AutomaticSize      = Enum.AutomaticSize.Y,
                Text               = Data.Body or "",
                TextColor3         = T.TextSecondary,
                Font               = Enum.Font.Gotham,
                TextSize           = S(12),
                TextXAlignment     = Enum.TextXAlignment.Left,
                TextWrapped        = true,
                LayoutOrder        = 2,
            })

            return {
                SetTitle = function(text) TitleLbl.Text = text end,
                SetBody  = function(text) BodyLbl.Text = text end,
            }
        end

        -- ===== ADD BUTTON =====
        function Tab:AddButton(Data)
            local C = MakeContainer(46)
            C.BackgroundColor3 = T.Secondary

            local Lbl = Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, S(14), 0, 0),
                Size               = UDim2.new(1, S(-60), 1, 0),
                Text               = Data.Name or "Button",
                TextColor3         = T.TextPrimary,
                Font               = Enum.Font.GothamSemibold,
                TextSize           = S(13),
                TextXAlignment     = Enum.TextXAlignment.Left,
            })

            local Desc = Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, S(14), 0.5, 0),
                Size               = UDim2.new(1, S(-60), 0.5, 0),
                Text               = Data.Description or "",
                TextColor3         = T.TextMuted,
                Font               = Enum.Font.Gotham,
                TextSize           = S(11),
                TextXAlignment     = Enum.TextXAlignment.Left,
            })

            if Data.Description and Data.Description ~= "" then
                Lbl.Position = UDim2.new(0, S(14), 0, S(5))
                Lbl.Size     = UDim2.new(1, S(-60), 0, S(20))
            end

            -- Arrow icon
            Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(1, S(-30), 0.5, S(-10)),
                Size               = UDim2.new(0, S(20), 0, S(20)),
                Text               = "›",
                TextColor3         = T.TextMuted,
                Font               = Enum.Font.GothamBold,
                TextSize           = S(18),
            })

            local Btn = Create("TextButton", {
                Parent             = C,
                Size               = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text               = "",
                ZIndex             = C.ZIndex + 1,
            })
            Btn.MouseEnter:Connect(function() Tween(C, 0.15, { BackgroundColor3 = T.Tertiary }) end)
            Btn.MouseLeave:Connect(function() Tween(C, 0.15, { BackgroundColor3 = T.Secondary }) end)
            Btn.MouseButton1Click:Connect(function()
                Tween(C, 0.08, { BackgroundColor3 = Library.AccentColor })
                task.wait(0.08)
                Tween(C, 0.25, { BackgroundColor3 = T.Secondary })
                if Data.Callback then task.spawn(Data.Callback) end
            end)
        end

        -- ===== ADD TOGGLE =====
        function Tab:AddToggle(Data)
            local State = Data.Default or false
            Library.Flags[Data.Name] = State

            local C = MakeContainer(46)
            C.BackgroundColor3 = T.Secondary

            Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, S(14), 0, S(Data.Description and 5 or 0)),
                Size               = UDim2.new(1, S(-70), 0, S(Data.Description and 20 or 46)),
                Text               = Data.Name or "Toggle",
                TextColor3         = T.TextPrimary,
                Font               = Enum.Font.GothamSemibold,
                TextSize           = S(13),
                TextXAlignment     = Enum.TextXAlignment.Left,
            })

            if Data.Description then
                Create("TextLabel", {
                    Parent             = C,
                    BackgroundTransparency = 1,
                    Position           = UDim2.new(0, S(14), 0.5, 0),
                    Size               = UDim2.new(1, S(-70), 0.5, 0),
                    Text               = Data.Description,
                    TextColor3         = T.TextMuted,
                    Font               = Enum.Font.Gotham,
                    TextSize           = S(11),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                })
            end

            -- Toggle pill
            local Track = Create("Frame", {
                Parent          = C,
                Position        = UDim2.new(1, S(-52), 0.5, S(-11)),
                Size            = UDim2.new(0, S(42), 0, S(22)),
                BackgroundColor3 = State and Library.AccentColor or T.Stroke,
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = Track, CornerRadius = UDim.new(1, 0) })

            local Knob = Create("Frame", {
                Parent          = Track,
                Size            = UDim2.new(0, S(16), 0, S(16)),
                Position        = State and UDim2.new(1, S(-19), 0.5, S(-8)) or UDim2.new(0, S(3), 0.5, S(-8)),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = Knob, CornerRadius = UDim.new(1, 0) })

            local Btn = Create("TextButton", {
                Parent             = C,
                Size               = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text               = "",
                ZIndex             = C.ZIndex + 1,
            })

            local function SetState(val)
                State = val
                Library.Flags[Data.Name] = State
                Tween(Track, 0.2, { BackgroundColor3 = State and Library.AccentColor or T.Stroke })
                Tween(Knob, 0.2, { Position = State and UDim2.new(1, S(-19), 0.5, S(-8)) or UDim2.new(0, S(3), 0.5, S(-8)) })
                if Data.Callback then Data.Callback(State) end
            end

            Btn.MouseButton1Click:Connect(function() SetState(not State) end)

            return {
                Set = function(val) SetState(val) end,
                Get = function() return State end,
            }
        end

        -- ===== ADD SLIDER =====
        function Tab:AddSlider(Data)
            local Value = math.clamp(Data.Default or Data.Min, Data.Min, Data.Max)
            Library.Flags[Data.Name] = Value

            local C = MakeContainer(60)
            C.BackgroundColor3 = T.Secondary

            Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, S(14), 0, S(10)),
                Size               = UDim2.new(1, S(-90), 0, S(20)),
                Text               = Data.Name or "Slider",
                TextColor3         = T.TextPrimary,
                Font               = Enum.Font.GothamSemibold,
                TextSize           = S(13),
                TextXAlignment     = Enum.TextXAlignment.Left,
            })

            local ValLabel = Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(1, S(-80), 0, S(10)),
                Size               = UDim2.new(0, S(68), 0, S(20)),
                Text               = tostring(Value) .. (Data.Suffix or ""),
                TextColor3         = Library.AccentColor,
                Font               = Enum.Font.GothamBold,
                TextSize           = S(13),
                TextXAlignment     = Enum.TextXAlignment.Right,
            })

            local BarTrack = Create("Frame", {
                Parent          = C,
                Position        = UDim2.new(0, S(14), 1, S(-18)),
                Size            = UDim2.new(1, S(-28), 0, S(5)),
                BackgroundColor3 = T.Stroke,
            })
            Create("UICorner", { Parent = BarTrack, CornerRadius = UDim.new(1, 0) })

            local BarFill = Create("Frame", {
                Parent          = BarTrack,
                Size            = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Library.AccentColor,
            })
            Create("UICorner", { Parent = BarFill, CornerRadius = UDim.new(1, 0) })

            -- Knob on bar
            local BarKnob = Create("Frame", {
                Parent          = BarTrack,
                Size            = UDim2.new(0, S(12), 0, S(12)),
                AnchorPoint     = Vector2.new(0.5, 0.5),
                Position        = UDim2.new(0, 0, 0.5, 0),
                BackgroundColor3 = Color3.new(1, 1, 1),
            })
            Create("UICorner", { Parent = BarKnob, CornerRadius = UDim.new(1, 0) })

            local function UpdateSlider(v)
                v = Data.Integer ~= false and math.floor(v) or math.round(v * 100) / 100
                v = math.clamp(v, Data.Min, Data.Max)
                Value = v
                Library.Flags[Data.Name] = v
                local pct = (v - Data.Min) / (Data.Max - Data.Min)
                Tween(BarFill, 0.06, { Size = UDim2.new(pct, 0, 1, 0) })
                Tween(BarKnob, 0.06, { Position = UDim2.new(pct, 0, 0.5, 0) })
                ValLabel.Text = tostring(v) .. (Data.Suffix or "")
                if Data.Callback then Data.Callback(v) end
            end

            local Dragging = false
            local HitBox = Create("TextButton", {
                Parent             = C,
                Size               = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text               = "",
                ZIndex             = C.ZIndex + 1,
            })
            HitBox.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if not Dragging then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    local mp  = UserInputService:GetMouseLocation()
                    local bp  = BarTrack.AbsolutePosition
                    local bs  = BarTrack.AbsoluteSize
                    local pct = math.clamp((mp.X - bp.X) / bs.X, 0, 1)
                    UpdateSlider(Data.Min + (Data.Max - Data.Min) * pct)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
            UpdateSlider(Value)

            return {
                Set = function(v) UpdateSlider(v) end,
                Get = function() return Value end,
            }
        end

        -- ===== ADD DROPDOWN =====
        function Tab:AddDropdown(Data)
            if not Data.Options or #Data.Options == 0 then
                warn("[XynnHub] Dropdown '" .. (Data.Name or "?") .. "' has no Options!")
                return
            end
            local Selected = Data.Default or Data.Options[1]
            Library.Flags[Data.Name] = Selected

            local C = MakeContainer(46)
            C.BackgroundColor3 = T.Secondary

            local MainLabel = Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, S(14), 0, 0),
                Size               = UDim2.new(1, S(-50), 0.5, 0),
                Text               = Data.Name or "Dropdown",
                TextColor3         = T.TextMuted,
                Font               = Enum.Font.GothamSemibold,
                TextSize           = S(11),
                TextXAlignment     = Enum.TextXAlignment.Left,
            })

            local SelLabel = Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, S(14), 0.5, 0),
                Size               = UDim2.new(1, S(-50), 0.5, 0),
                Text               = Selected,
                TextColor3         = T.TextPrimary,
                Font               = Enum.Font.GothamBold,
                TextSize           = S(13),
                TextXAlignment     = Enum.TextXAlignment.Left,
            })

            local Arrow = Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(1, S(-30), 0.5, S(-10)),
                Size               = UDim2.new(0, S(20), 0, S(20)),
                Text               = "▾",
                TextColor3         = T.TextMuted,
                Font               = Enum.Font.GothamBold,
                TextSize           = S(14),
            })

            -- Dropdown list (spawned in ScreenGui to escape clipping)
            local DropList = Create("Frame", {
                Parent          = ScreenGui,
                BackgroundColor3 = T.Secondary,
                Visible         = false,
                ZIndex          = 300,
                Size            = UDim2.new(0, 0, 0, 0),
            })
            Create("UICorner", { Parent = DropList, CornerRadius = UDim.new(0, S(10)) })
            Create("UIStroke",  { Parent = DropList, Color = T.Stroke, Thickness = 1 })
            Create("UIListLayout", { Parent = DropList, Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder })

            local optH = S(32)
            local listH = #Data.Options * optH + S(8)

            local function Reposition()
                local ap = C.AbsolutePosition
                local as = C.AbsoluteSize
                DropList.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + S(4))
                DropList.Size     = UDim2.new(0, as.X, 0, 0)
            end

            local isOpen = false
            local function Open()
                isOpen = true
                Reposition()
                DropList.Visible = true
                Tween(DropList, 0.2, { Size = UDim2.new(0, C.AbsoluteSize.X, 0, listH) })
                Tween(Arrow, 0.15, { Rotation = 180 })
            end
            local function Close()
                isOpen = false
                Tween(DropList, 0.18, { Size = UDim2.new(0, C.AbsoluteSize.X, 0, 0) })
                Tween(Arrow, 0.15, { Rotation = 0 })
                task.wait(0.2)
                DropList.Visible = false
            end

            local Btn = Create("TextButton", {
                Parent             = C,
                Size               = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text               = "",
                ZIndex             = C.ZIndex + 1,
            })
            Btn.MouseButton1Click:Connect(function() if isOpen then Close() else Open() end end)

            for _, opt in ipairs(Data.Options) do
                local OptBtn = Create("TextButton", {
                    Parent             = DropList,
                    Size               = UDim2.new(1, 0, 0, optH),
                    BackgroundTransparency = 1,
                    Text               = "  " .. opt,
                    TextColor3         = T.TextSecondary,
                    Font               = Enum.Font.Gotham,
                    TextSize           = S(13),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                    ZIndex             = 301,
                })
                OptBtn.MouseEnter:Connect(function() Tween(OptBtn, 0.1, { TextColor3 = T.TextPrimary, BackgroundTransparency = 0.85 }) end)
                OptBtn.MouseLeave:Connect(function() Tween(OptBtn, 0.1, { TextColor3 = T.TextSecondary, BackgroundTransparency = 1 }) end)
                OptBtn.MouseButton1Click:Connect(function()
                    Selected = opt
                    Library.Flags[Data.Name] = opt
                    SelLabel.Text = opt
                    if Data.Callback then Data.Callback(opt) end
                    Close()
                end)
            end

            UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
                    local mp = UserInputService:GetMouseLocation()
                    if not C.AbsoluteRect:Contains(mp) and not DropList.AbsoluteRect:Contains(mp) then
                        Close()
                    end
                end
            end)

            return {
                Set     = function(opt) Selected = opt Library.Flags[Data.Name] = opt SelLabel.Text = opt end,
                Get     = function() return Selected end,
                Refresh = function(newOpts)
                    for _, v in pairs(DropList:GetChildren()) do
                        if v:IsA("TextButton") then v:Destroy() end
                    end
                    Data.Options = newOpts
                    for _, opt in ipairs(newOpts) do
                        -- re-create option buttons (same logic as above)
                    end
                end,
            }
        end

        -- ===== ADD MULTI DROPDOWN =====
        function Tab:AddMultiDropdown(Data)
            if not Data.Options or #Data.Options == 0 then return end

            local Selected = {}
            if Data.Default then
                for _, v in ipairs(Data.Default) do Selected[v] = true end
            end
            Library.Flags[Data.Name] = Selected

            local C = MakeContainer(46)
            C.BackgroundColor3 = T.Secondary

            Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, S(14), 0, 0),
                Size               = UDim2.new(1, S(-50), 0.5, 0),
                Text               = Data.Name or "MultiDropdown",
                TextColor3         = T.TextMuted,
                Font               = Enum.Font.GothamSemibold,
                TextSize           = S(11),
                TextXAlignment     = Enum.TextXAlignment.Left,
            })

            local SelLabel = Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, S(14), 0.5, 0),
                Size               = UDim2.new(1, S(-50), 0.5, 0),
                Text               = "None selected",
                TextColor3         = T.TextPrimary,
                Font               = Enum.Font.GothamBold,
                TextSize           = S(13),
                TextXAlignment     = Enum.TextXAlignment.Left,
                TextTruncate       = Enum.TextTruncate.AtEnd,
            })

            Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(1, S(-30), 0.5, S(-10)),
                Size               = UDim2.new(0, S(20), 0, S(20)),
                Text               = "▾",
                TextColor3         = T.TextMuted,
                Font               = Enum.Font.GothamBold,
                TextSize           = S(14),
            })

            local optH = S(36)
            local DropList = Create("Frame", {
                Parent          = ScreenGui,
                BackgroundColor3 = T.Secondary,
                Visible         = false,
                ZIndex          = 300,
                Size            = UDim2.new(0, 0, 0, 0),
            })
            Create("UICorner",   { Parent = DropList, CornerRadius = UDim.new(0, S(10)) })
            Create("UIStroke",   { Parent = DropList, Color = T.Stroke, Thickness = 1 })
            Create("UIListLayout", { Parent = DropList, Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder })

            local function UpdateLabel()
                local keys = {}
                for k in pairs(Selected) do table.insert(keys, k) end
                SelLabel.Text = #keys > 0 and table.concat(keys, ", ") or "None selected"
            end

            local isOpen = false
            local function Open()
                isOpen = true
                local ap = C.AbsolutePosition local as = C.AbsoluteSize
                DropList.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + S(4))
                DropList.Size     = UDim2.new(0, as.X, 0, 0)
                DropList.Visible  = true
                Tween(DropList, 0.2, { Size = UDim2.new(0, as.X, 0, #Data.Options * optH + S(8)) })
            end
            local function Close()
                isOpen = false
                Tween(DropList, 0.18, { Size = UDim2.new(0, C.AbsoluteSize.X, 0, 0) })
                task.wait(0.2) DropList.Visible = false
            end

            local Btn = Create("TextButton", { Parent = C, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = C.ZIndex+1 })
            Btn.MouseButton1Click:Connect(function() if isOpen then Close() else Open() end end)

            for _, opt in ipairs(Data.Options) do
                local Row = Create("Frame", {
                    Parent          = DropList,
                    Size            = UDim2.new(1, 0, 0, optH),
                    BackgroundTransparency = 1,
                    ZIndex          = 301,
                })
                local Check = Create("Frame", {
                    Parent          = Row,
                    Position        = UDim2.new(1, S(-28), 0.5, S(-9)),
                    Size            = UDim2.new(0, S(18), 0, S(18)),
                    BackgroundColor3 = Selected[opt] and Library.AccentColor or T.Stroke,
                    ZIndex          = 302,
                })
                Create("UICorner", { Parent = Check, CornerRadius = UDim.new(0, S(5)) })

                Create("TextLabel", {
                    Parent             = Row,
                    BackgroundTransparency = 1,
                    Position           = UDim2.new(0, S(10), 0, 0),
                    Size               = UDim2.new(1, S(-40), 1, 0),
                    Text               = opt,
                    TextColor3         = T.TextSecondary,
                    Font               = Enum.Font.Gotham,
                    TextSize           = S(13),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                    ZIndex             = 302,
                })

                local OptBtn = Create("TextButton", { Parent = Row, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 303 })
                OptBtn.MouseButton1Click:Connect(function()
                    if Selected[opt] then Selected[opt] = nil else Selected[opt] = true end
                    Library.Flags[Data.Name] = Selected
                    Tween(Check, 0.15, { BackgroundColor3 = Selected[opt] and Library.AccentColor or T.Stroke })
                    UpdateLabel()
                    if Data.Callback then Data.Callback(Selected) end
                end)
            end

            UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
                    local mp = UserInputService:GetMouseLocation()
                    if not C.AbsoluteRect:Contains(mp) and not DropList.AbsoluteRect:Contains(mp) then Close() end
                end
            end)

            UpdateLabel()
            return {
                Get = function() return Selected end,
                Set = function(tbl)
                    Selected = {}
                    for _, v in ipairs(tbl) do Selected[v] = true end
                    Library.Flags[Data.Name] = Selected
                    UpdateLabel()
                end,
            }
        end

        -- ===== ADD TEXTBOX =====
        function Tab:AddTextBox(Data)
            local C = MakeContainer(56)
            C.BackgroundColor3 = T.Secondary

            Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, S(14), 0, S(6)),
                Size               = UDim2.new(1, S(-28), 0, S(16)),
                Text               = Data.Name or "TextBox",
                TextColor3         = T.TextMuted,
                Font               = Enum.Font.GothamSemibold,
                TextSize           = S(11),
                TextXAlignment     = Enum.TextXAlignment.Left,
            })

            local InputFrame = Create("Frame", {
                Parent          = C,
                Position        = UDim2.new(0, S(10), 1, S(-28)),
                Size            = UDim2.new(1, S(-20), 0, S(22)),
                BackgroundColor3 = T.Tertiary,
            })
            Create("UICorner", { Parent = InputFrame, CornerRadius = UDim.new(0, S(7)) })
            Create("UIStroke",  { Parent = InputFrame, Color = T.Stroke, Thickness = 1 })

            local Input = Create("TextBox", {
                Parent             = InputFrame,
                Size               = UDim2.new(1, S(-16), 1, 0),
                Position           = UDim2.new(0, S(8), 0, 0),
                BackgroundTransparency = 1,
                Text               = Data.Default or "",
                PlaceholderText    = Data.Placeholder or "Type here...",
                PlaceholderColor3  = T.TextMuted,
                TextColor3         = T.TextPrimary,
                Font               = Enum.Font.Gotham,
                TextSize           = S(12),
                TextXAlignment     = Enum.TextXAlignment.Left,
                ClearTextOnFocus   = Data.ClearOnFocus ~= false,
            })

            Input.Focused:Connect(function()
                Tween(InputFrame, 0.15, { BackgroundColor3 = T.Secondary })
            end)
            Input.FocusLost:Connect(function(entered)
                Tween(InputFrame, 0.15, { BackgroundColor3 = T.Tertiary })
                Library.Flags[Data.Name] = Input.Text
                if Data.Callback then Data.Callback(Input.Text, entered) end
            end)

            return {
                Set = function(text) Input.Text = text Library.Flags[Data.Name] = text end,
                Get = function() return Input.Text end,
            }
        end

        -- ===== ADD KEYBIND =====
        function Tab:AddKeybind(Data)
            local BoundKey = Data.Default or Enum.KeyCode.Unknown
            local Listening = false
            Library.Flags[Data.Name] = BoundKey

            local C = MakeContainer(46)
            C.BackgroundColor3 = T.Secondary

            Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, S(14), 0, 0),
                Size               = UDim2.new(1, S(-100), 1, 0),
                Text               = Data.Name or "Keybind",
                TextColor3         = T.TextPrimary,
                Font               = Enum.Font.GothamSemibold,
                TextSize           = S(13),
                TextXAlignment     = Enum.TextXAlignment.Left,
            })

            local KeyBtn = Create("TextButton", {
                Parent          = C,
                Position        = UDim2.new(1, S(-84), 0.5, S(-13)),
                Size            = UDim2.new(0, S(74), 0, S(26)),
                BackgroundColor3 = T.Tertiary,
                Text            = BoundKey == Enum.KeyCode.Unknown and "None" or BoundKey.Name,
                TextColor3      = Library.AccentColor,
                Font            = Enum.Font.GothamBold,
                TextSize        = S(11),
                AutoButtonColor = false,
            })
            Create("UICorner", { Parent = KeyBtn, CornerRadius = UDim.new(0, S(7)) })
            Create("UIStroke",  { Parent = KeyBtn, Color = T.Stroke, Thickness = 1 })

            KeyBtn.MouseButton1Click:Connect(function()
                if Listening then return end
                Listening = true
                KeyBtn.Text = "..."
                Tween(KeyBtn, 0.1, { BackgroundColor3 = Library.AccentColor })

                local conn
                conn = UserInputService.InputBegan:Connect(function(i, g)
                    if g then return end
                    if i.UserInputType == Enum.UserInputType.Keyboard then
                        BoundKey = i.KeyCode
                        Library.Flags[Data.Name] = BoundKey
                        KeyBtn.Text = i.KeyCode.Name
                        Tween(KeyBtn, 0.2, { BackgroundColor3 = T.Tertiary })
                        Listening = false
                        conn:Disconnect()
                    end
                end)
            end)

            -- Fire callback when bound key is pressed in-game
            local runConn = UserInputService.InputBegan:Connect(function(i, g)
                if g or Listening then return end
                if i.KeyCode == BoundKey and BoundKey ~= Enum.KeyCode.Unknown then
                    if Data.Callback then Data.Callback() end
                end
            end)
            table.insert(Library.Connections, runConn)

            return {
                Set = function(key) BoundKey = key Library.Flags[Data.Name] = key KeyBtn.Text = key.Name end,
                Get = function() return BoundKey end,
            }
        end

        -- ===== ADD COLOR PICKER =====
        function Tab:AddColorPicker(Data)
            local H, S_val, V = Color3.toHSV(Data.Default or Color3.fromRGB(255, 80, 80))
            local CurrentColor = Data.Default or Color3.fromRGB(255, 80, 80)
            Library.Flags[Data.Name] = CurrentColor

            local C = MakeContainer(46)
            C.BackgroundColor3 = T.Secondary

            Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, S(14), 0, 0),
                Size               = UDim2.new(1, S(-70), 1, 0),
                Text               = Data.Name or "Color",
                TextColor3         = T.TextPrimary,
                Font               = Enum.Font.GothamSemibold,
                TextSize           = S(13),
                TextXAlignment     = Enum.TextXAlignment.Left,
            })

            -- Color swatch button
            local Swatch = Create("TextButton", {
                Parent          = C,
                Position        = UDim2.new(1, S(-48), 0.5, S(-14)),
                Size            = UDim2.new(0, S(38), 0, S(28)),
                BackgroundColor3 = CurrentColor,
                Text            = "",
                AutoButtonColor = false,
            })
            Create("UICorner", { Parent = Swatch, CornerRadius = UDim.new(0, S(8)) })
            Create("UIStroke",  { Parent = Swatch, Color = T.Stroke, Thickness = 1 })

            -- Panel
            local Panel = Create("Frame", {
                Parent          = ScreenGui,
                Size            = UDim2.new(0, 230, 0, 225),
                BackgroundColor3 = T.Secondary,
                Visible         = false,
                ZIndex          = 500,
            })
            Create("UICorner", { Parent = Panel, CornerRadius = UDim.new(0, 12) })
            Create("UIStroke",  { Parent = Panel, Color = T.Stroke, Thickness = 1.2 })

            -- SV square base (hue color)
            local SVBase = Create("Frame", {
                Parent          = Panel,
                Position        = UDim2.new(0, 10, 0, 10),
                Size            = UDim2.new(1, -20, 0, 138),
                BackgroundColor3 = Color3.fromHSV(H, 1, 1),
                ZIndex          = 501,
            })
            Create("UICorner", { Parent = SVBase, CornerRadius = UDim.new(0, 7) })

            -- White→transparent overlay (saturation)
            local SatLayer = Create("Frame", {
                Parent          = SVBase,
                Size            = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex          = 502,
            })
            Create("UICorner", { Parent = SatLayer, CornerRadius = UDim.new(0, 7) })
            Create("UIGradient", {
                Parent       = SatLayer,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }),
            })

            -- Black overlay (value)
            local ValLayer = Create("Frame", {
                Parent          = SVBase,
                Size            = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 1,
                ZIndex          = 503,
            })
            Create("UICorner", { Parent = ValLayer, CornerRadius = UDim.new(0, 7) })
            Create("UIGradient", {
                Parent       = ValLayer,
                Rotation     = 90,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
            })

            -- SV cursor
            local SVCursor = Create("Frame", {
                Parent          = SVBase,
                Size            = UDim2.new(0, 12, 0, 12),
                AnchorPoint     = Vector2.new(0.5, 0.5),
                Position        = UDim2.new(S_val, 0, 1 - V, 0),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex          = 510,
            })
            Create("UICorner", { Parent = SVCursor, CornerRadius = UDim.new(1, 0) })
            Create("UIStroke",  { Parent = SVCursor, Color = Color3.new(0,0,0), Thickness = 1.5 })

            -- Hue slider
            local HueBar = Create("Frame", {
                Parent          = Panel,
                Position        = UDim2.new(0, 10, 0, 156),
                Size            = UDim2.new(1, -20, 0, 14),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex          = 501,
            })
            Create("UICorner", { Parent = HueBar, CornerRadius = UDim.new(1, 0) })
            Create("UIGradient", {
                Parent = HueBar,
                Color  = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,     Color3.fromHSV(0,     1, 1)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
                    ColorSequenceKeypoint.new(0.5,   Color3.fromHSV(0.5,   1, 1)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
                    ColorSequenceKeypoint.new(1,     Color3.fromHSV(1,     1, 1)),
                }),
            })

            local HueCursor = Create("Frame", {
                Parent          = HueBar,
                Size            = UDim2.new(0, 14, 1, 0),
                AnchorPoint     = Vector2.new(0.5, 0.5),
                Position        = UDim2.new(H, 0, 0.5, 0),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex          = 510,
            })
            Create("UICorner", { Parent = HueCursor, CornerRadius = UDim.new(1, 0) })
            Create("UIStroke",  { Parent = HueCursor, Color = Color3.new(0,0,0), Thickness = 1.5 })

            -- Hex input
            local HexBox = Create("TextBox", {
                Parent          = Panel,
                Position        = UDim2.new(0, 10, 0, 180),
                Size            = UDim2.new(1, -20, 0, 32),
                BackgroundColor3 = T.Tertiary,
                Text            = string.format("#%02X%02X%02X", math.floor(CurrentColor.R*255), math.floor(CurrentColor.G*255), math.floor(CurrentColor.B*255)),
                TextColor3      = T.TextPrimary,
                Font            = Enum.Font.Code,
                TextSize        = 13,
                ZIndex          = 505,
                ClearTextOnFocus = false,
            })
            Create("UICorner", { Parent = HexBox, CornerRadius = UDim.new(0, 7) })
            Create("UIStroke",  { Parent = HexBox, Color = T.Stroke, Thickness = 1 })

            local function UpdateColor()
                CurrentColor = Color3.fromHSV(H, S_val, V)
                Library.Flags[Data.Name] = CurrentColor
                Swatch.BackgroundColor3  = CurrentColor
                SVBase.BackgroundColor3  = Color3.fromHSV(H, 1, 1)
                SVCursor.Position        = UDim2.new(S_val, 0, 1 - V, 0)
                HueCursor.Position       = UDim2.new(H, 0, 0.5, 0)
                HexBox.Text = string.format("#%02X%02X%02X", math.floor(CurrentColor.R*255), math.floor(CurrentColor.G*255), math.floor(CurrentColor.B*255))
                if Data.Callback then Data.Callback(CurrentColor) end
            end

            -- SV drag
            local SVDrag, HueDrag = false, false
            local SVBtn = Create("TextButton", { Parent = SVBase, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 511 })
            local HueBtn = Create("TextButton", { Parent = HueBar, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 511 })

            SVBtn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SVDrag = true end
            end)
            HueBtn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then HueDrag = true end
            end)

            UserInputService.InputChanged:Connect(function(i)
                if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
                local mp = UserInputService:GetMouseLocation()
                if SVDrag then
                    local pos = SVBase.AbsolutePosition local sz = SVBase.AbsoluteSize
                    S_val = math.clamp((mp.X - pos.X) / sz.X, 0, 1)
                    V     = 1 - math.clamp((mp.Y - pos.Y) / sz.Y, 0, 1)
                    UpdateColor()
                end
                if HueDrag then
                    local pos = HueBar.AbsolutePosition local sz = HueBar.AbsoluteSize
                    H = math.clamp((mp.X - pos.X) / sz.X, 0, 1)
                    UpdateColor()
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    SVDrag = false HueDrag = false
                end
            end)

            -- Hex input
            HexBox.FocusLost:Connect(function()
                local hex = HexBox.Text:gsub("#", "")
                if #hex == 6 then
                    local r = tonumber(hex:sub(1,2), 16)
                    local g = tonumber(hex:sub(3,4), 16)
                    local b = tonumber(hex:sub(5,6), 16)
                    if r and g and b then
                        local nc = Color3.fromRGB(r, g, b)
                        H, S_val, V = Color3.toHSV(nc)
                        UpdateColor()
                    end
                end
            end)

            -- Toggle panel open/close
            local PanelOpen = false
            Swatch.MouseButton1Click:Connect(function()
                PanelOpen = not PanelOpen
                if PanelOpen then
                    local ap = C.AbsolutePosition local as = C.AbsoluteSize
                    Panel.Position = UDim2.new(0, ap.X + as.X - 230, 0, ap.Y + as.Y + 5)
                    Panel.Visible = true
                else
                    Panel.Visible = false
                end
            end)

            UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 and PanelOpen then
                    local mp = UserInputService:GetMouseLocation()
                    if not Panel.AbsoluteRect:Contains(mp) and not Swatch.AbsoluteRect:Contains(mp) then
                        Panel.Visible = false PanelOpen = false
                    end
                end
            end)

            UpdateColor()
            return {
                Set = function(color)
                    H, S_val, V = Color3.toHSV(color)
                    UpdateColor()
                end,
                Get = function() return CurrentColor end,
            }
        end

        -- ===== ADD PROGRESS BAR =====
        function Tab:AddProgressBar(Data)
            local C = MakeContainer(52)
            C.BackgroundColor3 = T.Secondary

            Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, S(14), 0, S(8)),
                Size               = UDim2.new(1, S(-80), 0, S(18)),
                Text               = Data.Name or "Progress",
                TextColor3         = T.TextPrimary,
                Font               = Enum.Font.GothamSemibold,
                TextSize           = S(13),
                TextXAlignment     = Enum.TextXAlignment.Left,
            })

            local PctLabel = Create("TextLabel", {
                Parent             = C,
                BackgroundTransparency = 1,
                Position           = UDim2.new(1, S(-60), 0, S(8)),
                Size               = UDim2.new(0, S(50), 0, S(18)),
                Text               = "0%",
                TextColor3         = Library.AccentColor,
                Font               = Enum.Font.GothamBold,
                TextSize           = S(13),
                TextXAlignment     = Enum.TextXAlignment.Right,
            })

            local Track = Create("Frame", {
                Parent          = C,
                Position        = UDim2.new(0, S(14), 1, S(-16)),
                Size            = UDim2.new(1, S(-28), 0, S(6)),
                BackgroundColor3 = T.Stroke,
            })
            Create("UICorner", { Parent = Track, CornerRadius = UDim.new(1, 0) })

            local Fill = Create("Frame", {
                Parent          = Track,
                Size            = UDim2.new((Data.Default or 0) / 100, 0, 1, 0),
                BackgroundColor3 = Library.AccentColor,
            })
            Create("UICorner", { Parent = Fill, CornerRadius = UDim.new(1, 0) })

            return {
                Set = function(pct)
                    pct = math.clamp(pct, 0, 100)
                    Tween(Fill, 0.3, { Size = UDim2.new(pct / 100, 0, 1, 0) })
                    PctLabel.Text = math.floor(pct) .. "%"
                end,
                Get = function()
                    return tonumber(PctLabel.Text:gsub("%%", "")) or 0
                end,
            }
        end

        return Tab
    end  -- end AddTab

    return Window
end  -- end CreateWindow

return Library
