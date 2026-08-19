-- =========================================================================
-- ⚽ JUMP TO STEAL SOCCER PLAYERS (ROBLOX) - DELTA EXECUTOR HUB ⚽
-- Clean Version: Fly Mode | WalkSpeed Slider | Noclip | Infinite Jump
-- =========================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Safe CoreGui / PlayerGui Parent for Mobile/PC Executors
local TargetParent = LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
    if game:GetService("CoreGui") then
        TargetParent = game:GetService("CoreGui")
    end
end)

-- Cleanup existing instance if re-executed
if TargetParent:FindFirstChild("JumpToStealDeltaHub") then
    TargetParent:FindFirstChild("JumpToStealDeltaHub"):Destroy()
end

-- Feature State Flags
local States = {
    Fly = false,
    FlySpeed = 50,
    WalkSpeed = 16,
    Noclip = false,
    InfJump = false
}

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JumpToStealDeltaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

-- Floating Mobile Toggle Button
local MobileButton = Instance.new("TextButton")
MobileButton.Name = "MobileToggle"
MobileButton.Size = UDim2.new(0, 45, 0, 45)
MobileButton.Position = UDim2.new(0, 15, 0.5, -22)
MobileButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MobileButton.Text = "⚽"
MobileButton.TextSize = 22
MobileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileButton.Active = true
MobileButton.Draggable = true
MobileButton.Parent = ScreenGui

local MobileCorner = Instance.new("UICorner")
MobileCorner.CornerRadius = UDim.new(1, 0)
MobileCorner.Parent = MobileButton

local MobileStroke = Instance.new("UIStroke")
MobileStroke.Color = Color3.fromRGB(0, 170, 255)
MobileStroke.Thickness = 2
MobileStroke.Parent = MobileButton

-- Main Container Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 310)
MainFrame.Position = UDim2.new(0.5, -120, 0.4, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 150, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Header Title Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚽ STEAL SOCCER HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Minimize Arrow Button
local ToggleArrow = Instance.new("TextButton")
ToggleArrow.Name = "ToggleArrow"
ToggleArrow.Size = UDim2.new(0, 30, 0, 30)
ToggleArrow.Position = UDim2.new(1, -34, 0, 6)
ToggleArrow.BackgroundTransparency = 1
ToggleArrow.Text = "V"
ToggleArrow.TextColor3 = Color3.fromRGB(180, 180, 190)
ToggleArrow.TextSize = 14
ToggleArrow.Font = Enum.Font.SourceSansBold
ToggleArrow.Parent = Header

-- Scrolling Content Frame
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Name = "ContentScroll"
ContentScroll.Size = UDim2.new(1, -16, 1, -52)
ContentScroll.Position = UDim2.new(0, 8, 0, 46)
ContentScroll.BackgroundTransparency = 1
ContentScroll.ScrollBarThickness = 4
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 240)
ContentScroll.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ContentScroll

-- Helper Function to Create Toggle Buttons
local function CreateToggle(name, labelText, defaultState, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, -4, 0, 36)
    Button.BackgroundColor3 = defaultState and Color3.fromRGB(0, 140, 90) or Color3.fromRGB(28, 28, 36)
    Button.Text = labelText .. (defaultState and " [ON]" or " [OFF]")
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 13
    Button.Parent = ContentScroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(45, 45, 60)
    Stroke.Thickness = 1
    Stroke.Parent = Button

    Button.MouseButton1Click:Connect(function()
        States[name] = not States[name]
        Button.BackgroundColor3 = States[name] and Color3.fromRGB(0, 140, 90) or Color3.fromRGB(28, 28, 36)
        Button.Text = labelText .. (States[name] and " [ON]" or " [OFF]")
        if callback then
            callback(States[name])
        end
    end)
    return Button
end

-- 1. Fly Mode Toggle
local bodyGyro, bodyVel
CreateToggle("Fly", "🕊️ Fly Mode", false, function(state)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if state then
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.cframe = root.CFrame
        bodyGyro.Parent = root

        bodyVel = Instance.new("BodyVelocity")
        bodyVel.velocity = Vector3.new(0, 0, 0)
        bodyVel.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVel.Parent = root

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = true end
    else
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVel then bodyVel:Destroy() end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end)

-- 2. WalkSpeed Slider Bar
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Size = UDim2.new(1, -4, 0, 48)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
SpeedFrame.Parent = ContentScroll

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = SpeedFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, -10, 0, 20)
SpeedLabel.Position = UDim2.new(0, 8, 0, 3)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "⚡ WalkSpeed: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedFrame

local SpeedBarBg = Instance.new("Frame")
SpeedBarBg.Name = "SpeedBarBg"
SpeedBarBg.Size = UDim2.new(1, -16, 0, 10)
SpeedBarBg.Position = UDim2.new(0, 8, 0, 28)
SpeedBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
SpeedBarBg.Parent = SpeedFrame

local SpeedBarFill = Instance.new("Frame")
SpeedBarFill.Name = "SpeedBarFill"
SpeedBarFill.Size = UDim2.new(0, 0, 1, 0)
SpeedBarFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SpeedBarFill.BorderSizePixel = 0
SpeedBarFill.Parent = SpeedBarBg

local SpeedTouchBtn = Instance.new("TextButton")
SpeedTouchBtn.Name = "SpeedTouchBtn"
SpeedTouchBtn.Size = UDim2.new(1, 0, 1, 0)
SpeedTouchBtn.BackgroundTransparency = 1
SpeedTouchBtn.Text = ""
SpeedTouchBtn.Parent = SpeedBarBg

local function UpdateSpeed(inputPos)
    local barAbsPos = SpeedBarBg.AbsolutePosition.X
    local barAbsSize = SpeedBarBg.AbsoluteSize.X
    local relativeX = math.clamp(inputPos.X - barAbsPos, 0, barAbsSize)
    local percentage = relativeX / barAbsSize
    local newSpeed = math.floor(16 + (percentage * (120 - 16)))
    
    States.WalkSpeed = newSpeed
    SpeedBarFill.Size = UDim2.new(percentage, 0, 1, 0)
    SpeedLabel.Text = "⚡ WalkSpeed: " .. tostring(newSpeed)
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = newSpeed
    end
end

local draggingSpeed = false
SpeedTouchBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSpeed = true
        UpdateSpeed(input.Position)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSpeed and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSpeed(input.Position)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSpeed = false
    end
end)

-- 3. Noclip Toggle
CreateToggle("Noclip", "🧱 Noclip (Walk Through Walls)", false, function(state) end)

-- 4. Infinite Jump Toggle
CreateToggle("InfJump", "🦘 Infinite Jump", false, function(state) end)

-- Minimize / Mobile UI Toggle Connections
local isMinimized = false
local function ToggleUIVisibility()
    isMinimized = not isMinimized
    MainFrame.Visible = not isMinimized
    ToggleArrow.Text = isMinimized and "^" or "V"
end

ToggleArrow.MouseButton1Click:Connect(ToggleUIVisibility)
MobileButton.MouseButton1Click:Connect(ToggleUIVisibility)

-- =========================================================================
-- RENDERSTEPPED / LOOP MECHANICS
-- =========================================================================

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- WalkSpeed Enforcement
    if hum and States.WalkSpeed > 16 then
        hum.WalkSpeed = States.WalkSpeed
    end

    -- Noclip Loop
    if States.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- Fly Loop
    if States.Fly and root and bodyGyro and bodyVel then
        bodyGyro.cframe = Camera.CFrame
        local moveDir = hum and hum.MoveDirection or Vector3.new(0, 0, 0)
        
        if moveDir.Magnitude > 0 then
            bodyVel.velocity = Camera.CFrame:VectorToWorldSpace(Camera.CFrame:VectorToObjectSpace(moveDir * States.FlySpeed))
        else
            bodyVel.velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- Infinite Jump Request
UserInputService.JumpRequest:Connect(function()
    if States.InfJump then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- Anti-AFK Kick Prevention
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
end)

print("⚽ Jump To Steal Soccer Hub (4 Features Clean Edition) Loaded!")
