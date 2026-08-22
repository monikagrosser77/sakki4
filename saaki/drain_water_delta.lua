--========================================================--
--              SAKI SCRIPTS UI (ULTRA COMPACT)
--         +1 DRAIN WATER PER CLICK (DELTA / PC)
--========================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Safe Parent Selection for CoreGui / PlayerGui
local TargetParent = Player:WaitForChild("PlayerGui")
pcall(function()
    if game:GetService("CoreGui") then
        TargetParent = game:GetService("CoreGui")
    end
end)

-- Cleanup existing UI instance
if TargetParent:FindFirstChild("SakiScriptsUI") then
    TargetParent:FindFirstChild("SakiScriptsUI"):Destroy()
end

--========================================================--
-- CONFIGURATION
--========================================================--

local GAME_NAME = "+1 DRAIN WATER"
local CREDIT = "SAKI SCRIPTS"

local RED = Color3.fromRGB(255, 25, 35)
local DARK = Color3.fromRGB(12, 12, 12)
local DARK2 = Color3.fromRGB(18, 18, 18)
local WHITE = Color3.fromRGB(255, 255, 255)
local GRAY = Color3.fromRGB(30, 30, 30)

-- Global Feature States
local AutoWaterState = false
local AutoRebirthState = false
local InfiniteJumpState = false

--========================================================--
-- SCREEN GUI
--========================================================--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SakiScriptsUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = TargetParent

--========================================================--
-- MAIN FRAME (MINI SIZE: 245 x 220)
--========================================================--

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui

Main.Size = UDim2.fromOffset(245, 220)
Main.Position = UDim2.new(0.5, -122, 0.5, -110)

Main.BackgroundColor3 = DARK
Main.BorderSizePixel = 0
Main.Active = true

-- Rounded corners
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

-- Red border
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = RED
MainStroke.Thickness = 2
MainStroke.Transparency = 0
MainStroke.Parent = Main

--========================================================--
-- TOP BAR
--========================================================--

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Main

TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = DARK
TopBar.BorderSizePixel = 0

--========================================================--
-- GAME NAME
--========================================================--

local GameName = Instance.new("TextLabel")
GameName.Name = "GameName"
GameName.Parent = TopBar
GameName.BackgroundTransparency = 1
GameName.Position = UDim2.fromOffset(10, 0)
GameName.Size = UDim2.new(1, -75, 1, 0)
GameName.Text = GAME_NAME
GameName.TextColor3 = RED
GameName.TextSize = 16
GameName.Font = Enum.Font.Bangers
GameName.TextXAlignment = Enum.TextXAlignment.Left
GameName.TextYAlignment = Enum.TextYAlignment.Center

--========================================================--
-- MINIMIZE BUTTON
--========================================================--

local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.Parent = TopBar
Minimize.Size = UDim2.fromOffset(26, 24)
Minimize.Position = UDim2.new(1, -60, 0.5, -12)
Minimize.BackgroundColor3 = DARK2
Minimize.BorderSizePixel = 0
Minimize.Text = "−"
Minimize.TextColor3 = WHITE
Minimize.TextSize = 16
Minimize.Font = Enum.Font.GothamBold
Minimize.AutoButtonColor = false

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = Minimize

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = RED
MinStroke.Thickness = 1.2
MinStroke.Parent = Minimize

--========================================================--
-- CLOSE BUTTON
--========================================================--

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Parent = TopBar
Close.Size = UDim2.fromOffset(26, 24)
Close.Position = UDim2.new(1, -30, 0.5, -12)
Close.BackgroundColor3 = DARK2
Close.BorderSizePixel = 0
Close.Text = "X"
Close.TextColor3 = RED
Close.TextSize = 13
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = Close

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = RED
CloseStroke.Thickness = 1.2
CloseStroke.Parent = Close

--========================================================--
-- TOP DIVIDER
--========================================================--

local TopDivider = Instance.new("Frame")
TopDivider.Name = "TopDivider"
TopDivider.Parent = Main
TopDivider.Position = UDim2.fromOffset(0, 38)
TopDivider.Size = UDim2.new(1, 0, 0, 1.5)
TopDivider.BackgroundColor3 = RED
TopDivider.BorderSizePixel = 0

--========================================================--
-- CONTENT
--========================================================--

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = Main
Content.Position = UDim2.fromOffset(0, 42)
Content.Size = UDim2.new(1, 0, 1, -70)
Content.BackgroundTransparency = 1

--========================================================--
-- FEATURE CREATOR
--========================================================--

local function CreateFeature(name, position, callback)
    local Feature = Instance.new("Frame")
    Feature.Name = name
    Feature.Parent = Content
    Feature.Position = position
    Feature.Size = UDim2.new(1, -20, 0, 36)
    Feature.BackgroundColor3 = DARK2
    Feature.BorderSizePixel = 0

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Feature

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(40, 40, 40)
    Stroke.Thickness = 1.2
    Stroke.Parent = Feature

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Parent = Feature
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.fromOffset(10, 0)
    Label.Size = UDim2.new(1, -55, 1, 0)
    Label.Text = name
    Label.TextColor3 = WHITE
    Label.TextSize = 14
    Label.Font = Enum.Font.Bangers
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center

    local Toggle = Instance.new("TextButton")
    Toggle.Name = "Toggle"
    Toggle.Parent = Feature
    Toggle.Size = UDim2.fromOffset(34, 26)
    Toggle.Position = UDim2.new(1, -42, 0.5, -13)
    Toggle.BackgroundColor3 = RED
    Toggle.BorderSizePixel = 0
    Toggle.Text = ""
    Toggle.AutoButtonColor = false

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = Toggle

    local Enabled = false

    Toggle.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        if Enabled then
            TweenService:Create(Toggle, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(80, 255, 100)
            }):Play()
        else
            TweenService:Create(Toggle, TweenInfo.new(0.15), {
                BackgroundColor3 = RED
            }):Play()
        end

        if callback then
            callback(Enabled)
        end
    end)

    Feature.MouseEnter:Connect(function()
        TweenService:Create(Feature, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        }):Play()
    end)

    Feature.MouseLeave:Connect(function()
        TweenService:Create(Feature, TweenInfo.new(0.15), {
            BackgroundColor3 = DARK2
        }):Play()
    end)

    return Feature
end

--========================================================--
-- FEATURES & GAME FUNCTIONALITY
--========================================================--

-- 1. AUTO COLLECT WATER / CLICK
CreateFeature(
    "AUTO COLLECT WATER",
    UDim2.new(0, 10, 0, 4),
    function(state)
        AutoWaterState = state
        if AutoWaterState then
            task.spawn(function()
                while AutoWaterState do
                    pcall(function()
                        local char = Player.Character
                        if char then
                            local currentTool = char:FindFirstChildOfClass("Tool")
                            if currentTool then
                                currentTool:Activate()
                            end

                            VirtualUser:CaptureController()
                            VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
                            VirtualUser:Button1Up(Vector2.new(0, 0), Camera.CFrame)

                            for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                                if obj:IsA("RemoteEvent") then
                                    local lowerName = obj.Name:lower()
                                    if lowerName:find("water") or lowerName:find("drain") or lowerName:find("click") or lowerName:find("collect") or lowerName:find("addwater") then
                                        obj:FireServer()
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.05)
                end
            end)
        end
    end
)

-- 2. AUTO REBIRTH
CreateFeature(
    "AUTO REBIRTH",
    UDim2.new(0, 10, 0, 46),
    function(state)
        AutoRebirthState = state
        if AutoRebirthState then
            task.spawn(function()
                while AutoRebirthState do
                    pcall(function()
                        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                            if not AutoRebirthState then break end
                            if obj:IsA("RemoteEvent") then
                                local lowerName = obj.Name:lower()
                                if lowerName:find("rebirth") or lowerName:find("prestige") or lowerName:find("ascend") then
                                    obj:FireServer(1)
                                    obj:FireServer()
                                end
                            elseif obj:IsA("RemoteFunction") then
                                local lowerName = obj.Name:lower()
                                if lowerName:find("rebirth") or lowerName:find("prestige") or lowerName:find("ascend") then
                                    pcall(function() obj:InvokeServer(1) end)
                                    pcall(function() obj:InvokeServer() end)
                                end
                            end
                        end

                        for _, v in pairs(Workspace:GetDescendants()) do
                            if not AutoRebirthState then break end
                            if v:IsA("ProximityPrompt") then
                                local nameLower = v.Parent.Name:lower()
                                if nameLower:find("rebirth") or nameLower:find("prestige") then
                                    fireproximityprompt(v)
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
)

-- 3. INFINITE JUMP
CreateFeature(
    "INFINITE JUMP",
    UDim2.new(0, 10, 0, 88),
    function(state)
        InfiniteJumpState = state
    end
)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpState then
        pcall(function()
            local char = Player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

--========================================================--
-- FOOTER
--========================================================--

local FooterDivider = Instance.new("Frame")
FooterDivider.Name = "FooterDivider"
FooterDivider.Parent = Main
FooterDivider.Position = UDim2.new(0, 0, 1, -28)
FooterDivider.Size = UDim2.new(1, 0, 0, 1.5)
FooterDivider.BackgroundColor3 = RED
FooterDivider.BorderSizePixel = 0

local MadeBy = Instance.new("TextLabel")
MadeBy.Name = "MadeBy"
MadeBy.Parent = Main
MadeBy.BackgroundTransparency = 1
MadeBy.Position = UDim2.new(0, 0, 1, -26)
MadeBy.Size = UDim2.new(1, 0, 0, 24)
MadeBy.RichText = true
MadeBy.Text = 'MADE BY: <font color="rgb(255,25,35)">' .. CREDIT .. '</font>'
MadeBy.TextColor3 = WHITE
MadeBy.TextSize = 13
MadeBy.Font = Enum.Font.Bangers
MadeBy.TextXAlignment = Enum.TextXAlignment.Center
MadeBy.TextYAlignment = Enum.TextYAlignment.Center

--========================================================--
-- MINIMIZE FUNCTION
--========================================================--

local Minimized = false

Minimize.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        Content.Visible = false
        FooterDivider.Visible = false
        MadeBy.Visible = false
        TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(245, 38)
        }):Play()
    else
        TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(245, 220)
        }):Play()
        task.wait(0.18)
        Content.Visible = true
        FooterDivider.Visible = true
        MadeBy.Visible = true
    end
end)

--========================================================--
-- CLOSE FUNCTION
--========================================================--

Close.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

--========================================================--
-- BUTTON HOVER
--========================================================--

Minimize.MouseEnter:Connect(function()
    TweenService:Create(Minimize, TweenInfo.new(0.15), {
        BackgroundColor3 = RED,
        TextColor3 = WHITE
    }):Play()
end)

Minimize.MouseLeave:Connect(function()
    TweenService:Create(Minimize, TweenInfo.new(0.15), {
        BackgroundColor3 = DARK2,
        TextColor3 = WHITE
    }):Play()
end)

Close.MouseEnter:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.15), {
        BackgroundColor3 = RED,
        TextColor3 = WHITE
    }):Play()
end)

Close.MouseLeave:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.15), {
        BackgroundColor3 = DARK2,
        TextColor3 = RED
    }):Play()
end)

--========================================================--
-- DRAG SYSTEM (PC & Mobile Touch)
--========================================================--

local Dragging = false
local DragStart
local StartPosition

TopBar.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
    end
end)

TopBar.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        local Delta = Input.Position - DragStart
        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

--========================================================--
-- FLOATING MOBILE TOGGLE BUTTON (Open / Reopen UI)
--========================================================--

local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingBtn"
FloatingBtn.Size = UDim2.fromOffset(40, 40)
FloatingBtn.Position = UDim2.new(0, 15, 0.5, -20)
FloatingBtn.BackgroundColor3 = DARK
FloatingBtn.Text = "💧"
FloatingBtn.TextColor3 = RED
FloatingBtn.TextSize = 18
FloatingBtn.Font = Enum.Font.Bangers
FloatingBtn.Parent = ScreenGui
FloatingBtn.Active = true
FloatingBtn.Draggable = true

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatingBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = RED
FloatStroke.Thickness = 1.8
FloatStroke.Parent = FloatingBtn

FloatingBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = true
    Main.Visible = not Main.Visible
end)

print("Saki Scripts UI (Ultra Compact) Loaded!")
