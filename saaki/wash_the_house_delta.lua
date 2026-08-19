-- =========================================================================
-- WASH THE HOUSE (ROBLOX) - ERROR-FREE DELTA EXECUTOR HUB
-- Features: Auto Clean House | WalkSpeed Slider Bar | Fly Mode
-- =========================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Safe CoreGui / PlayerGui Parent
local TargetParent = LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
    if game:GetService("CoreGui") then
        TargetParent = game:GetService("CoreGui")
    end
end)

-- Cleanup existing instance
if TargetParent:FindFirstChild("WashTheHouseSampleHub") then
    TargetParent:FindFirstChild("WashTheHouseSampleHub"):Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WashTheHouseSampleHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

-- Main Container Frame (Sample UI Style)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 310)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Header Title Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
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
TitleLabel.Text = "+WASH THE HOUSE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
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
ToggleArrow.TextColor3 = Color3.fromRGB(180, 180, 190)
ToggleArrow.TextSize = 14
ToggleArrow.Font = Enum.Font.SourceSansBold
ToggleArrow.Parent = Header

-- Content Layout
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -55)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.Parent = ContentFrame

-- States
local AutoCleanState = false
local FlyState = false
local CurrentWalkSpeed = 16

-- Helper Function: Red Checkbox
local function CreateCheckbox(name, layoutOrder, defaultChecked, callback)
    local Row = Instance.new("Frame")
    Row.Name = name .. "_Row"
    Row.Size = UDim2.new(1, 0, 0, 32)
    Row.BackgroundTransparency = 1
    Row.LayoutOrder = layoutOrder
    Row.Parent = ContentFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 15
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local CheckBox = Instance.new("TextButton")
    CheckBox.Size = UDim2.new(0, 24, 0, 24)
    CheckBox.Position = UDim2.new(1, -26, 0, 4)
    CheckBox.BorderSizePixel = 0
    CheckBox.AutoButtonColor = false
    CheckBox.Font = Enum.Font.SourceSansBold
    CheckBox.TextSize = 16
    CheckBox.Parent = Row

    local CheckCorner = Instance.new("UICorner")
    CheckCorner.CornerRadius = UDim.new(0, 4)
    CheckCorner.Parent = CheckBox

    local isChecked = defaultChecked

    local function updateVisual()
        if isChecked then
            CheckBox.BackgroundColor3 = Color3.fromRGB(235, 55, 55)
            CheckBox.Text = "X"
            CheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            CheckBox.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
            CheckBox.Text = ""
            CheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
        end
    end

    updateVisual()

    CheckBox.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        updateVisual()
        pcall(callback, isChecked)
    end)

    return CheckBox
end

-- Helper Function: WalkSpeed Slider Bar
local function CreateSliderBar(layoutOrder)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "WalkSpeed_Slider"
    SliderFrame.Size = UDim2.new(1, 0, 0, 52)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.LayoutOrder = layoutOrder
    SliderFrame.Parent = ContentFrame

    local HeaderRow = Instance.new("Frame")
    HeaderRow.Size = UDim2.new(1, 0, 0, 20)
    HeaderRow.BackgroundTransparency = 1
    HeaderRow.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "WalkSpeed"
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 15
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = HeaderRow

    local ValueDisplay = Instance.new("TextLabel")
    ValueDisplay.Size = UDim2.new(0.4, 0, 1, 0)
    ValueDisplay.Position = UDim2.new(0.6, 0, 0, 0)
    ValueDisplay.BackgroundTransparency = 1
    ValueDisplay.Text = "16"
    ValueDisplay.TextColor3 = Color3.fromRGB(235, 55, 55)
    ValueDisplay.TextSize = 15
    ValueDisplay.Font = Enum.Font.SourceSansBold
    ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    ValueDisplay.Parent = HeaderRow

    local Track = Instance.new("Frame")
    Track.Name = "Track"
    Track.Size = UDim2.new(1, 0, 0, 14)
    Track.Position = UDim2.new(0, 0, 0, 26)
    Track.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Track.BorderSizePixel = 0
    Track.Parent = SliderFrame

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(0, 7)
    TrackCorner.Parent = Track

    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(235, 55, 55)
    Fill.BorderSizePixel = 0
    Fill.Parent = Track

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 7)
    FillCorner.Parent = Fill

    local Knob = Instance.new("TextButton")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, -9, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Text = ""
    Knob.Parent = Track

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local minVal = 16
    local maxVal = 200
    local dragging = false

    local function updateSlider(input)
        local posX = math.clamp(input.Position.X - Track.AbsolutePosition.X, 0, Track.AbsoluteSize.X)
        local percentage = posX / math.max(Track.AbsoluteSize.X, 1)
        local val = math.floor(minVal + (maxVal - minVal) * percentage)
        
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        Knob.Position = UDim2.new(percentage, -9, 0.5, -9)
        ValueDisplay.Text = tostring(val)
        CurrentWalkSpeed = val
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

-- 1. Auto Clean House
CreateCheckbox("Auto Clean House", 1, false, function(state)
    AutoCleanState = state
    if AutoCleanState then
        task.spawn(function()
            while AutoCleanState do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        local root = char:FindFirstChildOfClass("HumanoidRootPart")

                        local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                        if tool and tool.Parent ~= char and humanoid then
                            humanoid:EquipTool(tool)
                        end

                        local currentTool = char:FindFirstChildOfClass("Tool")
                        if currentTool then
                            currentTool:Activate()
                        end

                        for _, v in pairs(Workspace:GetDescendants()) do
                            if not AutoCleanState then break end
                            if v:IsA("BasePart") then
                                local nameLower = v.Name:lower()
                                if nameLower:find("dirt") or nameLower:find("clean") or nameLower:find("stain") or nameLower:find("grime") or nameLower:find("mess") then
                                    if root and (root.Position - v.Position).Magnitude < 35 then
                                        if typeof(firetouchinterest) == "function" then
                                            firetouchinterest(root, v, 0)
                                            firetouchinterest(root, v, 1)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

-- 2. WalkSpeed Slider Bar
CreateSliderBar(2)

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

-- 3. Fly Mode
local bodyVel, bodyGyro

CreateCheckbox("Fly Mode", 3, false, function(state)
    FlyState = state
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:FindFirstChildOfClass("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if FlyState then
        if not root then return end
        
        pcall(function()
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.Velocity = Vector3.zero
            bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVel.Parent = root

            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.CFrame = root.CFrame
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.P = 9e4
            bodyGyro.Parent = root
        end)

        task.spawn(function()
            while FlyState do
                pcall(function()
                    if humanoid then humanoid.PlatformStand = true end
                    local moveDir = humanoid and humanoid.MoveDirection or Vector3.zero
                    local camCF = Workspace.CurrentCamera.CFrame

                    local velocity = Vector3.zero
                    if moveDir.Magnitude > 0 then
                        velocity = (camCF.LookVector * -moveDir.Z + camCF.RightVector * moveDir.X).Unit * 50
                    end

                    if bodyVel then bodyVel.Velocity = velocity end
                    if bodyGyro then bodyGyro.CFrame = camCF end
                end)
                task.wait()
            end

            pcall(function()
                if bodyVel then bodyVel:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
                if humanoid then humanoid.PlatformStand = false end
            end)
        end)
    else
        pcall(function()
            if bodyVel then bodyVel:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
            if humanoid then humanoid.PlatformStand = false end
        end)
    end
end)

-- Footer Attribution
local Footer = Instance.new("TextLabel")
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -22)
Footer.BackgroundTransparency = 1
Footer.Text = "Delta Hub | Wash The House"
Footer.TextColor3 = Color3.fromRGB(150, 150, 160)
Footer.TextSize = 13
Footer.Font = Enum.Font.SourceSansBold
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.Parent = MainFrame

-- Minimize Toggle
local isMinimized = false
ToggleArrow.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContentFrame.Visible = not isMinimized
    Footer.Visible = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 220, 0, 40)
        ToggleArrow.Text = "^"
    else
        MainFrame.Size = UDim2.new(0, 220, 0, 310)
        ToggleArrow.Text = "V"
    end
end)

-- Floating Mobile Button
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 15, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
OpenBtn.BorderSizePixel = 0
OpenBtn.Text = "WTH"
OpenBtn.TextColor3 = Color3.fromRGB(235, 55, 55)
OpenBtn.TextSize = 14
OpenBtn.Font = Enum.Font.FredokaOne
OpenBtn.Draggable = true
OpenBtn.Active = true
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(235, 55, 55)
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenBtn

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
