-- =========================================================================
-- CLEAN ALL THE LEAVES! (ROBLOX) - DELTA EXECUTOR HUB
-- Game ID: 92637789841354
-- Features: Auto Clean Leaves | WalkSpeed Slider Bar | Infinite Jump
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

-- Cleanup existing instance if script re-executed
if TargetParent:FindFirstChild("CleanAllLeavesDeltaHub") then
    TargetParent:FindFirstChild("CleanAllLeavesDeltaHub"):Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CleanAllLeavesDeltaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

-- Main Container Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 320)
MainFrame.Position = UDim2.new(0.5, -115, 0.4, -160)
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
TitleLabel.Text = "🍃 CLEAN ALL LEAVES"
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
ToggleArrow.TextColor3 = Color3.fromRGB(180, 180, 190)
ToggleArrow.TextSize = 14
ToggleArrow.Font = Enum.Font.SourceSansBold
ToggleArrow.Parent = Header

-- Content Layout
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -65)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.Parent = ContentFrame

-- Feature States
local AutoCleanState = false
local InfiniteJumpState = false
local CurrentWalkSpeed = 16

-- Helper Function: Checkbox Component
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
            CheckBox.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Green accent when active
            CheckBox.Text = "✓"
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

-- Helper Function: WalkSpeed Slider Bar Component
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
    ValueDisplay.TextColor3 = Color3.fromRGB(46, 204, 113)
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
    Fill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
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

-- =========================================================================
-- FEATURE 1: AUTO CLEAN LEAVES
-- =========================================================================
CreateCheckbox("Auto Clean Leaves", 1, false, function(state)
    AutoCleanState = state
    if AutoCleanState then
        task.spawn(function()
            while AutoCleanState do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        local root = char:FindFirstChildOfClass("HumanoidRootPart")

                        -- Equip tool if in Backpack
                        local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                        if tool and tool.Parent ~= char and humanoid then
                            humanoid:EquipTool(tool)
                        end

                        -- Activate current tool
                        local currentTool = char:FindFirstChildOfClass("Tool")
                        if currentTool then
                            currentTool:Activate()
                        end

                        -- Search Workspace for Leaf objects & touch interest
                        for _, v in pairs(Workspace:GetDescendants()) do
                            if not AutoCleanState then break end
                            if v:IsA("BasePart") or v:IsA("Model") then
                                local nameLower = v.Name:lower()
                                if nameLower:find("leaf") or nameLower:find("leaves") or nameLower:find("clean") or nameLower:find("dirt") or nameLower:find("patta") then
                                    local targetPart = v:IsA("BasePart") and v or v:FindFirstChildOfClass("BasePart")
                                    if targetPart and root then
                                        if (root.Position - targetPart.Position).Magnitude < 45 then
                                            if typeof(firetouchinterest) == "function" then
                                                firetouchinterest(root, targetPart, 0)
                                                firetouchinterest(root, targetPart, 1)
                                            else
                                                -- Fallback teleport touch simulation if firetouchinterest is restricted
                                                targetPart.CFrame = root.CFrame
                                            end
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

-- =========================================================================
-- FEATURE 2: WALKSPEED SLIDER
-- =========================================================================
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

-- =========================================================================
-- FEATURE 3: INFINITE JUMP
-- =========================================================================
CreateCheckbox("Infinite Jump", 3, false, function(state)
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

-- Footer Attribution
local Footer = Instance.new("TextLabel")
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -22)
Footer.BackgroundTransparency = 1
Footer.Text = "Delta Hub | Clean All The Leaves"
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
        MainFrame.Size = UDim2.new(0, 230, 0, 40)
        ToggleArrow.Text = "^"
    else
        MainFrame.Size = UDim2.new(0, 230, 0, 320)
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
OpenBtn.Text = "CTL"
OpenBtn.TextColor3 = Color3.fromRGB(46, 204, 113)
OpenBtn.TextSize = 14
OpenBtn.Font = Enum.Font.FredokaOne
OpenBtn.Draggable = true
OpenBtn.Active = true
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(46, 204, 113)
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenBtn

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
