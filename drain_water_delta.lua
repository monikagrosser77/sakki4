-- =========================================================================
-- +1 DRAIN WATER PER CLICK (ROBLOX) - DELTA EXECUTOR HUB
-- Features: 1. Auto Water Collect / Click | 2. Auto Pool Drain | 3. WalkSpeed Slider | 4. Infinite Jump
-- =========================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Safe Parent Selection for CoreGui / PlayerGui (Mobile Delta Friendly)
local TargetParent = LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
    if game:GetService("CoreGui") then
        TargetParent = game:GetService("CoreGui")
    end
end)

-- Cleanup existing hub instance if re-executed
if TargetParent:FindFirstChild("DrainWaterDeltaHub") then
    TargetParent:FindFirstChild("DrainWaterDeltaHub"):Destroy()
end

-- Global Toggle & Variable States
local AutoWaterState = false
local AutoPoolDrainState = false
local CurrentWalkSpeed = 16
local WalkSpeedEnabled = false
local InfiniteJumpState = false

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DrainWaterDeltaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

-- Main Container Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 360)
MainFrame.Position = UDim2.new(0.5, -120, 0.4, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 150, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Header Title Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(10, 14, 22)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -35, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "💧 +1 DRAIN WATER HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Minimize Arrow Button
local ToggleArrow = Instance.new("TextButton")
ToggleArrow.Name = "ToggleArrow"
ToggleArrow.Size = UDim2.new(0, 30, 0, 30)
ToggleArrow.Position = UDim2.new(1, -32, 0, 5)
ToggleArrow.BackgroundTransparency = 1
ToggleArrow.Text = "V"
ToggleArrow.TextColor3 = Color3.fromRGB(180, 200, 220)
ToggleArrow.TextSize = 14
ToggleArrow.Font = Enum.Font.SourceSansBold
ToggleArrow.Parent = Header

-- Content Layout Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -65)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ContentFrame

-- Helper Function: Checkbox Component (Green Tick "✓" UI)
local function CreateCheckbox(name, layoutOrder, defaultChecked, callback)
    local Row = Instance.new("Frame")
    Row.Name = name .. "_Row"
    Row.Size = UDim2.new(1, 0, 0, 30)
    Row.BackgroundTransparency = 1
    Row.LayoutOrder = layoutOrder
    Row.Parent = ContentFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(240, 240, 245)
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local CheckBox = Instance.new("TextButton")
    CheckBox.Size = UDim2.new(0, 24, 0, 24)
    CheckBox.Position = UDim2.new(1, -26, 0.5, -12)
    CheckBox.BackgroundColor3 = defaultChecked and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 38, 48)
    CheckBox.BorderSizePixel = 0
    CheckBox.Text = defaultChecked and "✓" or ""
    CheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    CheckBox.TextSize = 16
    CheckBox.Font = Enum.Font.SourceSansBold
    CheckBox.Parent = Row

    local CheckCorner = Instance.new("UICorner")
    CheckCorner.CornerRadius = UDim.new(0, 5)
    CheckCorner.Parent = CheckBox

    local isChecked = defaultChecked

    CheckBox.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        CheckBox.BackgroundColor3 = isChecked and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 38, 48)
        CheckBox.Text = isChecked and "✓" or ""
        callback(isChecked)
    end)
end

-- Helper Function: Slider Component
local function CreateSlider(layoutOrder)
    local Row = Instance.new("Frame")
    Row.Name = "WalkSpeed_Row"
    Row.Size = UDim2.new(1, 0, 0, 50)
    Row.BackgroundTransparency = 1
    Row.LayoutOrder = layoutOrder
    Row.Parent = ContentFrame

    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Size = UDim2.new(1, 0, 0, 20)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Parent = Row

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(0.6, 0, 1, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "WalkSpeed"
    TitleText.TextColor3 = Color3.fromRGB(240, 240, 245)
    TitleText.TextSize = 14
    TitleText.Font = Enum.Font.SourceSansBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = HeaderFrame

    local ValueText = Instance.new("TextLabel")
    ValueText.Size = UDim2.new(0.4, 0, 1, 0)
    ValueText.Position = UDim2.new(0.6, 0, 0, 0)
    ValueText.BackgroundTransparency = 1
    ValueText.Text = "16"
    ValueText.TextColor3 = Color3.fromRGB(0, 180, 255)
    ValueText.TextSize = 14
    ValueText.Font = Enum.Font.SourceSansBold
    ValueText.TextXAlignment = Enum.TextXAlignment.Right
    ValueText.Parent = HeaderFrame

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, 0, 0, 8)
    Track.Position = UDim2.new(0, 0, 0, 30)
    Track.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
    Track.BorderSizePixel = 0
    Track.Parent = Row

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Track

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Handle = Instance.new("TextButton")
    Handle.Size = UDim2.new(0, 16, 0, 16)
    Handle.Position = UDim2.new(0, -8, 0.5, -8)
    Handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Handle.BorderSizePixel = 0
    Handle.Text = ""
    Handle.Parent = Track

    local HandleCorner = Instance.new("UICorner")
    HandleCorner.CornerRadius = UDim.new(1, 0)
    HandleCorner.Parent = Handle

    local minVal, maxVal = 16, 150
    local isDragging = false

    local function updateSlider(input)
        local posX = math.clamp(input.Position.X - Track.AbsolutePosition.X, 0, Track.AbsoluteSize.X)
        local percentage = posX / Track.AbsoluteSize.X
        local val = math.floor(minVal + (percentage * (maxVal - minVal)))
        CurrentWalkSpeed = val
        ValueText.Text = tostring(val)
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        Handle.Position = UDim2.new(percentage, -8, 0.5, -8)
    end

    Handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
end

-- =========================================================================
-- FEATURE 1: WATER COLLECT (AUTO COLLECT WATER / AUTO CLICK)
-- =========================================================================
CreateCheckbox("Auto Collect Water", 1, false, function(state)
    AutoWaterState = state
    if AutoWaterState then
        task.spawn(function()
            while AutoWaterState do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        -- 1. Activate Equipped Tools (e.g. Pump, Vacuum, Bucket)
                        local currentTool = char:FindFirstChildOfClass("Tool")
                        if currentTool then
                            currentTool:Activate()
                        end

                        -- 2. Simulate Virtual User Click (For Clicker Mechanics)
                        VirtualUser:CaptureController()
                        VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
                        VirtualUser:Button1Up(Vector2.new(0, 0), Camera.CFrame)

                        -- 3. Fire Game RemoteEvents related to Water Drain/Click if present
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
                task.wait(0.05) -- Fast Loop Execution (20 Clicks per second)
            end
        end)
    end
end)

-- =========================================================================
-- FEATURE 2: AUTO POOL DRAIN
-- =========================================================================
CreateCheckbox("Auto Pool Drain", 2, false, function(state)
    AutoPoolDrainState = state
    if AutoPoolDrainState then
        task.spawn(function()
            while AutoPoolDrainState do
                pcall(function()
                    -- Interacting with Pool Drain prompts & remotes in Workspace
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if not AutoPoolDrainState then break end
                        if v:IsA("ProximityPrompt") then
                            local nameLower = v.Parent.Name:lower()
                            if nameLower:find("drain") or nameLower:find("pool") or nameLower:find("water") or nameLower:find("valve") then
                                fireproximityprompt(v)
                            end
                        end
                    end
                end)
                task.wait(0.3)
            end
        end)
    end
end)

-- =========================================================================
-- FEATURE 3: WALKSPEED SLIDER
-- =========================================================================
CreateSlider(3)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = CurrentWalkSpeed
            end
        end)
    end
end)

-- =========================================================================
-- FEATURE 4: INFINITE JUMP
-- =========================================================================
CreateCheckbox("Infinite Jump", 4, false, function(state)
    InfiniteJumpState = state
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpState then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end)

-- Footer Info Label
local Footer = Instance.new("TextLabel")
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -22)
Footer.BackgroundTransparency = 1
Footer.Text = "Delta Hub | +1 Drain Water Per Click"
Footer.TextColor3 = Color3.fromRGB(150, 170, 190)
Footer.TextSize = 13
Footer.Font = Enum.Font.SourceSansBold
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.Parent = MainFrame

-- Minimize Window Toggle
local isMinimized = false
ToggleArrow.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContentFrame.Visible = not isMinimized
    Footer.Visible = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 240, 0, 40)
        ToggleArrow.Text = "^"
    else
        MainFrame.Size = UDim2.new(0, 240, 0, 360)
        ToggleArrow.Text = "V"
    end
end)

-- Floating Mobile Open Button
local MobileBtn = Instance.new("TextButton")
MobileBtn.Name = "MobileBtn"
MobileBtn.Size = UDim2.new(0, 50, 0, 50)
MobileBtn.Position = UDim2.new(0, 15, 0.5, -25)
MobileBtn.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
MobileBtn.BorderSizePixel = 0
MobileBtn.Text = "💧"
MobileBtn.TextSize = 22
MobileBtn.Draggable = true
MobileBtn.Active = true
MobileBtn.Parent = ScreenGui

local MobileBtnCorner = Instance.new("UICorner")
MobileBtnCorner.CornerRadius = UDim.new(1, 0)
MobileBtnCorner.Parent = MobileBtn

local MobileBtnStroke = Instance.new("UIStroke")
MobileBtnStroke.Color = Color3.fromRGB(0, 150, 255)
MobileBtnStroke.Thickness = 2
MobileBtnStroke.Parent = MobileBtn

MobileBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
