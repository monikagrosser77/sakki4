-- =========================================================================
-- ⚽ JUMP TO STEAL SOCCER PLAYERS (ROBLOX) - DELTA EXECUTOR HUB ⚽
-- 100% WORKING UNIVERSAL EDITION (Fly | WalkSpeed | Noclip | InfJump)
-- =========================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Parent ScreenGui safely in PlayerGui / CoreGui
local TargetParent = LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
    if game:GetService("CoreGui") then
        TargetParent = game:GetService("CoreGui")
    end
end)

-- Clean up old instance
if TargetParent:FindFirstChild("JumpToStealDeltaHub") then
    TargetParent:FindFirstChild("JumpToStealDeltaHub"):Destroy()
end

-- Feature States
local FlyState = false
local FlySpeed = 50
local FlyUp = false
local FlyDown = false

local CurrentWalkSpeed = 16
local WalkSpeedEnabled = false

local NoclipState = false
local InfJumpState = false

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JumpToStealDeltaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

-- Floating Mobile Button
local MobileButton = Instance.new("TextButton")
MobileButton.Name = "MobileToggle"
MobileButton.Size = UDim2.new(0, 48, 0, 48)
MobileButton.Position = UDim2.new(0, 15, 0.4, 0)
MobileButton.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MobileButton.Text = "⚽"
MobileButton.TextSize = 22
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

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 320)
MainFrame.Position = UDim2.new(0.5, -120, 0.35, -160)
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

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
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

local ToggleArrow = Instance.new("TextButton")
ToggleArrow.Name = "ToggleArrow"
ToggleArrow.Size = UDim2.new(0, 30, 0, 30)
ToggleArrow.Position = UDim2.new(1, -34, 0, 5)
ToggleArrow.BackgroundTransparency = 1
ToggleArrow.Text = "V"
ToggleArrow.TextColor3 = Color3.fromRGB(180, 180, 190)
ToggleArrow.TextSize = 14
ToggleArrow.Font = Enum.Font.SourceSansBold
ToggleArrow.Parent = Header

-- Content Layout
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -16, 1, -50)
ContentFrame.Position = UDim2.new(0, 8, 0, 44)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ContentFrame

-- Checkbox Component
local function CreateCheckbox(labelText, order, defaultState, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Btn_" .. labelText
    Button.Size = UDim2.new(1, 0, 0, 36)
    Button.BackgroundColor3 = defaultState and Color3.fromRGB(0, 150, 90) or Color3.fromRGB(26, 26, 34)
    Button.Text = labelText .. (defaultState and " [ON]" or " [OFF]")
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 13
    Button.LayoutOrder = order
    Button.Parent = ContentFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(45, 45, 60)
    Stroke.Thickness = 1
    Stroke.Parent = Button

    local isChecked = defaultState
    Button.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        Button.BackgroundColor3 = isChecked and Color3.fromRGB(0, 150, 90) or Color3.fromRGB(26, 26, 34)
        Button.Text = labelText .. (isChecked and " [ON]" or " [OFF]")
        callback(isChecked)
    end)
    return Button
end

-- Slider Component
local function CreateSliderBar(order)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "SliderFrame"
    SliderFrame.Size = UDim2.new(1, 0, 0, 46)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    SliderFrame.LayoutOrder = order
    SliderFrame.Parent = ContentFrame

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.65, 0, 0, 20)
    Label.Position = UDim2.new(0, 8, 0, 3)
    Label.BackgroundTransparency = 1
    Label.Text = "⚡ WalkSpeed"
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local ValueDisplay = Instance.new("TextLabel")
    ValueDisplay.Name = "ValueDisplay"
    ValueDisplay.Size = UDim2.new(0.3, 0, 0, 20)
    ValueDisplay.Position = UDim2.new(0.68, 0, 0, 3)
    ValueDisplay.BackgroundTransparency = 1
    ValueDisplay.Text = "16"
    ValueDisplay.TextColor3 = Color3.fromRGB(0, 170, 255)
    ValueDisplay.Font = Enum.Font.SourceSansBold
    ValueDisplay.TextSize = 13
    ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    ValueDisplay.Parent = SliderFrame

    local Track = Instance.new("Frame")
    Track.Name = "Track"
    Track.Size = UDim2.new(1, -16, 0, 12)
    Track.Position = UDim2.new(0, 8, 0, 25)
    Track.BackgroundColor3 = Color3.fromRGB(36, 36, 48)
    Track.BorderSizePixel = 0
    Track.Parent = SliderFrame

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(0, 6)
    TrackCorner.Parent = Track

    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Track

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 6)
    FillCorner.Parent = Fill

    local Knob = Instance.new("TextButton")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, -8, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Text = ""
    Knob.Parent = Track

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local minVal = 16
    local maxVal = 150
    local dragging = false

    local function updateSlider(input)
        local posX = math.clamp(input.Position.X - Track.AbsolutePosition.X, 0, Track.AbsoluteSize.X)
        local percentage = posX / math.max(Track.AbsoluteSize.X, 1)
        local val = math.floor(minVal + (maxVal - minVal) * percentage)
        
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        Knob.Position = UDim2.new(percentage, -8, 0.5, -8)
        ValueDisplay.Text = tostring(val)
        
        CurrentWalkSpeed = val
        WalkSpeedEnabled = (val > 16)
    end

    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

-- =========================================================================
-- FEATURE IMPLEMENTATIONS
-- =========================================================================

-- 1. Fly Mode Toggle
CreateCheckbox("🕊️ Fly Mode", 1, false, function(state)
    FlyState = state
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = state
        end
    end
end)

-- 2. WalkSpeed Slider
CreateSliderBar(2)

-- 3. Noclip Toggle
CreateCheckbox("🧱 Noclip (Walk Walls)", 3, false, function(state)
    NoclipState = state
end)

-- 4. Infinite Jump Toggle
CreateCheckbox("🦘 Infinite Jump", 4, false, function(state)
    InfJumpState = state
end)

-- =========================================================================
-- UNIVERSAL ENGINE LOOPS
-- =========================================================================

-- A. WALK SPEED LOOP (Hybrid Humanoid + CFrame Position Boost)
RunService.Heartbeat:Connect(function(dt)
    if WalkSpeedEnabled and CurrentWalkSpeed > 16 then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                
                if hum then
                    hum.WalkSpeed = CurrentWalkSpeed
                end
                
                -- Extra movement boost if game locks WalkSpeed
                if hum and root and hum.MoveDirection.Magnitude > 0 and not FlyState then
                    local extraSpeed = (CurrentWalkSpeed - 16)
                    root.CFrame = root.CFrame + (hum.MoveDirection * (extraSpeed * dt))
                end
            end
        end)
    end
end)

-- B. UNIVERSAL CFRAME FLY LOOP
RunService.RenderStepped:Connect(function(dt)
    if FlyState then
        pcall(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if root and hum then
                hum.PlatformStand = true
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero

                local camCF = Workspace.CurrentCamera.CFrame
                local moveDir = hum.MoveDirection

                local flyVector = Vector3.zero
                if moveDir.Magnitude > 0 then
                    flyVector = (camCF.LookVector * -moveDir.Z + camCF.RightVector * moveDir.X)
                end

                if flyVector.Magnitude > 0 then
                    root.CFrame = root.CFrame + (flyVector.Unit * (FlySpeed * dt * 2.5))
                end
            end
        end)
    end
end)

-- C. NOCLIP LOOP (Stepped event + State Change)
RunService.Stepped:Connect(function()
    if NoclipState then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.NoPhysics)
                end
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- D. INFINITE JUMP HANDLER
UserInputService.JumpRequest:Connect(function()
    if InfJumpState then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end)

-- Toggle UI visibility
local isHidden = false
local function ToggleUI()
    isHidden = not isHidden
    MainFrame.Visible = not isHidden
    ToggleArrow.Text = isHidden and "^" or "V"
end

ToggleArrow.MouseButton1Click:Connect(ToggleUI)
MobileButton.MouseButton1Click:Connect(ToggleUI)

-- Anti-AFK Kick Prevention
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end)

print("⚽ Universal Steal Soccer Hub Ready!")
