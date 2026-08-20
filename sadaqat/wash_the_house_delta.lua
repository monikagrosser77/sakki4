-- =========================================================================
-- WASH THE HOUSE (ROBLOX) - DELTA EXECUTOR HUB (TELEPORT AUTO-CLEAN)
-- Features: 1. Auto Clean House | 2. WalkSpeed Slider | 3. Infinite Jump
-- =========================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Safe Parent Selection for CoreGui / PlayerGui
local TargetParent = LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
    if game:GetService("CoreGui") then
        TargetParent = game:GetService("CoreGui")
    end
end)

-- Cleanup existing GUI if re-executed
if TargetParent:FindFirstChild("WashTheHouseDeltaHub") then
    TargetParent:FindFirstChild("WashTheHouseDeltaHub"):Destroy()
end

-- Global States
local AutoCleanState = false
local CurrentWalkSpeed = 16
local WalkSpeedEnabled = false
local InfJumpState = false

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WashTheHouseDeltaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

-- Floating Mobile Button
local MobileButton = Instance.new("TextButton")
MobileButton.Name = "MobileToggle"
MobileButton.Size = UDim2.new(0, 45, 0, 45)
MobileButton.Position = UDim2.new(0, 15, 0.4, 0)
MobileButton.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MobileButton.Text = "🧼"
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

-- Main Container Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 280)
MainFrame.Position = UDim2.new(0.5, -115, 0.4, -140)
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

-- Window Header Bar
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
TitleLabel.Text = "🧼 WASH THE HOUSE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

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

-- Content Layout Frame
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

-- Helper Function: Checkbox Component (Green Tick "✓" UI)
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
            CheckBox.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Green accent
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
    local maxVal = 150
    local dragging = false

    local function updateSlider(input)
        local posX = math.clamp(input.Position.X - Track.AbsolutePosition.X, 0, Track.AbsoluteSize.X)
        local percentage = posX / math.max(Track.AbsoluteSize.X, 1)
        local val = math.floor(minVal + (maxVal - minVal) * percentage)
        
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        Knob.Position = UDim2.new(percentage, -9, 0.5, -9)
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
-- FEATURE 1: AUTO CLEAN HOUSE (SUPERCHARGED 4-IN-1 CLEAN ENGINE)
-- =========================================================================

CreateCheckbox("Auto Clean House", 1, false, function(state)
    AutoCleanState = state
    if AutoCleanState then
        task.spawn(function()
            while AutoCleanState do
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")

                    if char and root and hum then
                        -- 1. Auto Equip Washer / Cleaning Tool
                        local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                        if tool and tool.Parent ~= char then
                            hum:EquipTool(tool)
                        end

                        local currentTool = char:FindFirstChildOfClass("Tool")
                        if currentTool then
                            currentTool:Activate()
                            pcall(function()
                                VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
                            end)
                            for _, child in pairs(currentTool:GetChildren()) do
                                if child:IsA("RemoteEvent") then
                                    pcall(function() child:FireServer() end)
                                elseif child:IsA("RemoteFunction") then
                                    pcall(function() child:InvokeServer() end)
                                end
                            end
                        end

                        -- 2. Fire Cleaning Remotes in ReplicatedStorage / Workspace
                        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                            if v:IsA("RemoteEvent") then
                                local rName = v.Name:lower()
                                if rName:find("clean") or rName:find("wash") or rName:find("spray") or rName:find("water") or rName:find("dirt") or rName:find("hit") or rName:find("use") then
                                    pcall(function() v:FireServer() end)
                                end
                            end
                        end

                        -- Helper to ignore GUI, CoreGui, and Player Characters
                        local function isIgnored(obj)
                            if not obj then return true end
                            if obj:IsDescendantOf(TargetParent) or obj:IsDescendantOf(ScreenGui) then return true end
                            for _, plr in pairs(Players:GetPlayers()) do
                                if plr.Character and obj:IsDescendantOf(plr.Character) then
                                    return true
                                end
                            end
                            return false
                        end

                        -- 3. Target Dirt, Prompts & Cleanables
                        local foundDirty = false
                        local descendants = Workspace:GetDescendants()
                        
                        for _, v in pairs(descendants) do
                            if not AutoCleanState then break end

                            if not isIgnored(v) then
                                -- Trigger ProximityPrompts
                                if v:IsA("ProximityPrompt") and v.Enabled then
                                    if typeof(fireproximityprompt) == "function" then
                                        if v.Parent and v.Parent:IsA("BasePart") then
                                            root.CFrame = CFrame.lookAt(v.Parent.Position + Vector3.new(0, 1, 1.5), v.Parent.Position)
                                        end
                                        fireproximityprompt(v)
                                        task.wait(0.02)
                                    end
                                end

                                -- Trigger ClickDetectors
                                if v:IsA("ClickDetector") then
                                    if typeof(fireclickdetector) == "function" then
                                        fireclickdetector(v)
                                    end
                                end

                                -- Check BaseParts & Models for Dirt / Stains / Mess
                                if v:IsA("BasePart") or v:IsA("Model") then
                                    local nameLower = v.Name:lower()
                                    local parentName = (v.Parent and v.Parent.Name:lower()) or ""
                                    
                                    local isNamedDirt = nameLower:find("dirt") or nameLower:find("stain") or nameLower:find("grime")
                                        or nameLower:find("mess") or nameLower:find("trash") or nameLower:find("dust")
                                        or nameLower:find("rubbish") or nameLower:find("spot") or nameLower:find("soot")
                                        or nameLower:find("cleanable") or nameLower:find("dirty") or nameLower:find("mud")
                                        or nameLower:find("puddle") or nameLower:find("gunk") or nameLower:find("garbage")
                                        or nameLower:find("glass") or nameLower:find("window") or nameLower:find("tile")
                                        or parentName:find("dirt") or parentName:find("stain") or parentName:find("cleanable")
                                        or parentName:find("trash") or parentName:find("mess") or parentName:find("house")
                                        or parentName:find("clean")
                                    
                                    local isTargetablePart = v:IsA("BasePart") and v.Transparency < 0.99 and not v.Locked
                                    local hasDirtChild = v:FindFirstChildWhichIsA("Decal") or v:FindFirstChildWhichIsA("Texture") or v:FindFirstChildWhichIsA("SurfaceAppearance")
                                    
                                    if (isNamedDirt or hasDirtChild) and (v:IsA("BasePart") or v:FindFirstChildOfClass("BasePart")) then
                                        local targetPart = v:IsA("BasePart") and v or v:FindFirstChildOfClass("BasePart")
                                        if targetPart and targetPart.Parent and targetPart:IsDescendantOf(Workspace) and targetPart.Transparency < 0.99 then
                                            foundDirty = true
                                            local targetPos = targetPart.Position
                                            
                                            -- Fast Teleport 1.8 studs facing target
                                            root.CFrame = CFrame.lookAt(targetPos + Vector3.new(0, 0.8, 1.8), targetPos)
                                            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
                                            
                                            if currentTool then
                                                currentTool:Activate()
                                                local toolHandle = currentTool:FindFirstChild("Handle") or currentTool:FindFirstChildOfClass("BasePart")
                                                if toolHandle and typeof(firetouchinterest) == "function" then
                                                    firetouchinterest(toolHandle, targetPart, 0)
                                                    firetouchinterest(toolHandle, targetPart, 1)
                                                end
                                            end

                                            -- Character Touch Interest
                                            if typeof(firetouchinterest) == "function" then
                                                firetouchinterest(root, targetPart, 0)
                                                firetouchinterest(root, targetPart, 1)
                                            end
                                            
                                            task.wait(0.03)
                                        end
                                    end
                                end
                            end
                        end

                        -- Fallback Sweep if no specific dirt parts remain
                        if not foundDirty then
                            if currentTool then
                                currentTool:Activate()
                            end
                        end
                    end
                end)
                task.wait(0.08)
            end
        end)
    end
end)

-- =========================================================================
-- FEATURE 2: WALKSPEED SLIDER
-- =========================================================================
CreateSliderBar(2)

-- =========================================================================
-- FEATURE 3: INFINITE JUMP
-- =========================================================================
CreateCheckbox("Infinite Jump", 3, false, function(state)
    InfJumpState = state
end)

-- =========================================================================
-- ENGINE LOOPS
-- =========================================================================

-- WalkSpeed Engine (Humanoid + CFrame Boost)
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
                
                if hum and root and hum.MoveDirection.Magnitude > 0 then
                    local extraSpeed = (CurrentWalkSpeed - 16)
                    root.CFrame = root.CFrame + (hum.MoveDirection * (extraSpeed * dt))
                end
            end
        end)
    end
end)

-- Infinite Jump Engine
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

-- UI Visibility Toggle
local isHidden = false
local function ToggleUI()
    isHidden = not isHidden
    MainFrame.Visible = not isHidden
    ToggleArrow.Text = isHidden and "^" or "V"
end

ToggleArrow.MouseButton1Click:Connect(ToggleUI)
MobileButton.MouseButton1Click:Connect(ToggleUI)

-- Anti-AFK Handler
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end)

print("🧼 Wash The House Delta Hub (Targeted Teleport Auto-Clean) Loaded!")
