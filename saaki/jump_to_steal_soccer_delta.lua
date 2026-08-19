-- =========================================================================
-- ⚽ JUMP TO STEAL SOCCER PLAYERS (ROBLOX) - DELTA EXECUTOR HUB ⚽
-- Features: Auto Steal Blocks | Auto Open | Auto Collect Cash | Auto Upgrades 
--           Guard Bypass | Block ESP | Infinite Jump | Speed Slider
-- =========================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
    AutoSteal = false,
    AutoOpen = false,
    AutoCash = false,
    AutoUpgrade = false,
    AutoRebirth = false,
    BypassGuards = false,
    BlockESP = false,
    InfJump = false,
    Noclip = false,
    WalkSpeed = 16,
    JumpPower = 50
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
MainFrame.Size = UDim2.new(0, 250, 0, 380)
MainFrame.Position = UDim2.new(0.5, -125, 0.35, -190)
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
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 520)
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

-- 1. Auto Steal Blocks Toggle
CreateToggle("AutoSteal", "📦 Auto Steal Blocks", false, function(state) end)

-- 2. Auto Open / Hatch Blocks Toggle
CreateToggle("AutoOpen", "🔓 Auto Open Blocks (Base)", false, function(state) end)

-- 3. Auto Collect Cash Toggle
CreateToggle("AutoCash", "💰 Auto Collect Cash", false, function(state) end)

-- 4. Auto Upgrade Stats Toggle
CreateToggle("AutoUpgrade", "⬆️ Auto Upgrade (Jump/Carry)", false, function(state) end)

-- 5. Bypass / Disable Guards Toggle
CreateToggle("BypassGuards", "🛡️ Bypass / Freeze Guards", false, function(state)
    if state then
        pcall(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and (v.Name:lower():find("guard") or v.Name:lower():find("soccer")) then
                    for _, part in pairs(v:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanTouch = false
                        end
                    end
                end
            end
        end)
    end
end)

-- 6. Block ESP Toggle
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "BlockESPFolder"
ESPFolder.Parent = ScreenGui

CreateToggle("BlockESP", "👁️ Block ESP (Highlight)", false, function(state)
    if not state then
        ESPFolder:ClearAllChildren()
    end
end)

-- 7. Infinite Jump Toggle
CreateToggle("InfJump", "🦘 Infinite Jump", false, function(state) end)

-- 8. Noclip Toggle
CreateToggle("Noclip", "🧱 Noclip (Walk Through Walls)", false, function(state) end)

-- 9. WalkSpeed Slider Bar
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
-- BACKGROUND AUTOMATION LOOPS
-- =========================================================================

-- 1. Character & Speed/Noclip Loop
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if States.WalkSpeed > 16 then
                hum.WalkSpeed = States.WalkSpeed
            end
        end
        if States.Noclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- 2. Infinite Jump Handler
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

-- 3. Helper: Get Player Base / Plot
local function GetPlayerBase()
    local plots = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("Towers")
    if plots then
        for _, plot in pairs(plots:GetChildren()) do
            local owner = plot:FindFirstChild("Owner") or plot:FindFirstChild("Player")
            if owner and (owner.Value == LocalPlayer or owner.Value == LocalPlayer.Name) then
                return plot
            end
        end
    end
    return nil
end

-- 4. Main Auto-Farm Loop (Every 0.5s)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            -- AUTO STEAL BLOCKS
            if States.AutoSteal and root then
                local blocksFolder = Workspace:FindFirstChild("Blocks") or Workspace:FindFirstChild("LuckyBlocks") or Workspace:FindFirstChild("Tower")
                if blocksFolder then
                    for _, block in pairs(blocksFolder:GetDescendants()) do
                        if block:IsA("BasePart") or block:IsA("Model") then
                            local prompt = block:FindFirstChildOfClass("ProximityPrompt")
                            local touch = block:FindFirstChildOfClass("TouchTransmitter") or block:FindFirstChild("TouchInterest")
                            
                            if prompt and prompt.Enabled then
                                root.CFrame = (block:IsA("Model") and block:GetPivot() or block.CFrame) + Vector3.new(0, 3, 0)
                                task.wait(0.2)
                                fireproximityprompt(prompt)
                                break
                            elseif touch then
                                root.CFrame = (block:IsA("Model") and block:GetPivot() or block.CFrame)
                                break
                            end
                        end
                    end
                end
            end
            
            -- AUTO OPEN BLOCKS AT BASE
            if States.AutoOpen then
                local base = GetPlayerBase()
                if base then
                    for _, prompt in pairs(base:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end

            -- AUTO COLLECT CASH
            if States.AutoCash then
                local base = GetPlayerBase() or Workspace
                for _, part in pairs(base:GetDescendants()) do
                    if part:IsA("BasePart") and (part.Name:lower():find("cash") or part.Name:lower():find("coin") or part.Name:lower():find("collector")) then
                        if root and part:FindFirstChildOfClass("TouchTransmitter") then
                            firetouchinterest(root, part, 0)
                            firetouchinterest(root, part, 1)
                        end
                    end
                end
            end
            
            -- AUTO UPGRADES
            if States.AutoUpgrade then
                local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events")
                if remotes then
                    for _, remote in pairs(remotes:GetChildren()) do
                        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                            if remote.Name:lower():find("upgrade") or remote.Name:lower():find("jump") or remote.Name:lower():find("carry") then
                                pcall(function()
                                    if remote:IsA("RemoteEvent") then
                                        remote:FireServer()
                                    end
                                end)
                            end
                        end
                    end
                end
            end
            
            -- BLOCK ESP LOOP
            if States.BlockESP then
                ESPFolder:ClearAllChildren()
                local blocksFolder = Workspace:FindFirstChild("Blocks") or Workspace:FindFirstChild("LuckyBlocks")
                if blocksFolder then
                    for _, block in pairs(blocksFolder:GetChildren()) do
                        local part = block:IsA("Model") and block.PrimaryPart or (block:IsA("BasePart") and block)
                        if part then
                            local bgui = Instance.new("BillboardGui")
                            bgui.Name = "ESP"
                            bgui.Adornee = part
                            bgui.Size = UDim2.new(0, 100, 0, 30)
                            bgui.AlwaysOnTop = true
                            bgui.Parent = ESPFolder
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Text = "📦 " .. block.Name
                            label.TextColor3 = Color3.fromRGB(0, 255, 150)
                            label.TextSize = 12
                            label.Font = Enum.Font.SourceSansBold
                            label.Parent = bgui
                        end
                    end
                end
            end

        end)
    end
end)

-- 5. Anti-AFK Handler (20 Mins Kick Prevention)
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

print("⚽ Jump To Steal Soccer Players Delta Hub Loaded Successfully!")
