--========================================================--
--                 SAKI SCRIPTS UI (INFINITE WINS V2)
--          +1 WALL HOP OBBY ESCAPE (DELTA / PC)
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
if TargetParent:FindFirstChild("SakiScriptsWallHopUI") then
    TargetParent:FindFirstChild("SakiScriptsWallHopUI"):Destroy()
end

--========================================================--
-- CONFIGURATION
--========================================================--

local GAME_NAME = "+1 WALL HOP ESCAPE"
local CREDIT = "SAKI SCRIPTS"

local RED = Color3.fromRGB(255, 25, 35)
local DARK = Color3.fromRGB(12, 12, 12)
local DARK2 = Color3.fromRGB(18, 18, 18)
local WHITE = Color3.fromRGB(255, 255, 255)
local GRAY = Color3.fromRGB(30, 30, 30)

-- Global Feature States
local InfiniteWinsState = false
local AutoTrainState = false
local SpeedBoostState = false
local InfiniteJumpState = false
local CurrentWalkSpeed = 16

--========================================================--
-- SCREEN GUI
--========================================================--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SakiScriptsWallHopUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = TargetParent

--========================================================--
-- MAIN FRAME (MINI SIZE: 250 x 255)
--========================================================--

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui

Main.Size = UDim2.fromOffset(250, 255)
Main.Position = UDim2.new(0.5, -125, 0.5, -127)

Main.BackgroundColor3 = DARK
Main.BorderSizePixel = 0
Main.Active = true

-- Rounded corners for all 4 edges
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

-- Red border
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = RED
MainStroke.Thickness = 2
MainStroke.Transparency = 0
MainStroke.Parent = Main

--========================================================--
-- TOP BAR (Transparent for perfect top corners)
--========================================================--

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundTransparency = 1
TopBar.BorderSizePixel = 0

-- Game Name Title
local GameName = Instance.new("TextLabel")
GameName.Name = "GameName"
GameName.Parent = TopBar
GameName.BackgroundTransparency = 1
GameName.Position = UDim2.fromOffset(12, 0)
GameName.Size = UDim2.new(1, -75, 1, 0)
GameName.Text = GAME_NAME
GameName.TextColor3 = RED
GameName.TextSize = 16
GameName.Font = Enum.Font.Bangers
GameName.TextXAlignment = Enum.TextXAlignment.Left
GameName.TextYAlignment = Enum.TextYAlignment.Center

-- Minimize Button
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

-- Close Button
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

-- Top Divider
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
    Feature.Size = UDim2.new(1, -20, 0, 34)
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
    Toggle.Size = UDim2.fromOffset(34, 25)
    Toggle.Position = UDim2.new(1, -42, 0.5, -12.5)
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
-- FEATURES & IMPLEMENTATION LOGIC
--========================================================--

-- 1. INFINITE WINS (MULTI-ENGINE WIN COLLECTOR)
CreateFeature(
    "INFINITE WINS",
    UDim2.new(0, 10, 0, 2),
    function(state)
        InfiniteWinsState = state
        if InfiniteWinsState then
            task.spawn(function()
                while InfiniteWinsState do
                    pcall(function()
                        local char = Player.Character
                        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))

                        -- METHOD 1: Fire all Win / Trophy Remotes across ReplicatedStorage & Players
                        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                            if not InfiniteWinsState then break end
                            if obj:IsA("RemoteEvent") then
                                local lowerName = obj.Name:lower()
                                if lowerName:find("win") or lowerName:find("trophy") or lowerName:find("finish") or lowerName:find("stage") or lowerName:find("reward") or lowerName:find("escape") or lowerName:find("reach") or lowerName:find("give") or lowerName:find("add") then
                                    obj:FireServer()
                                    obj:FireServer(1)
                                    obj:FireServer("Win")
                                    obj:FireServer("Stage")
                                    obj:FireServer(true)
                                end
                            elseif obj:IsA("RemoteFunction") then
                                local lowerName = obj.Name:lower()
                                if lowerName:find("win") or lowerName:find("finish") or lowerName:find("trophy") or lowerName:find("escape") then
                                    pcall(function() obj:InvokeServer() end)
                                    pcall(function() obj:InvokeServer(1) end)
                                end
                            end
                        end

                        -- METHOD 2: Direct Win Pad / Stage End Touch Simulation + Proximity Prompts
                        if root then
                            for _, v in pairs(Workspace:GetDescendants()) do
                                if not InfiniteWinsState then break end
                                
                                -- Touch Transmitters & Parts
                                if v:IsA("BasePart") then
                                    local lowerName = v.Name:lower()
                                    local parentName = (v.Parent and v.Parent.Name:lower()) or ""
                                    
                                    if lowerName:find("win") or lowerName:find("finish") or lowerName:find("goal") or lowerName:find("end") or lowerName:find("escape") or lowerName:find("stage") or lowerName:find("trophy") or lowerName:find("checkpoint")
                                       or parentName:find("win") or parentName:find("finish") or parentName:find("stages") or parentName:find("obby") or parentName:find("tower") then
                                        
                                        -- Fire touch interest without moving camera
                                        firetouchinterest(root, v, 0)
                                        task.wait(0.01)
                                        firetouchinterest(root, v, 1)
                                    end
                                end
                                
                                -- ProximityPrompts on Win items
                                if v:IsA("ProximityPrompt") then
                                    local pName = (v.Parent and v.Parent.Name:lower()) or ""
                                    if pName:find("win") or pName:find("trophy") or pName:find("claim") or pName:find("reward") or pName:find("stage") then
                                        fireproximityprompt(v)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.08) -- Ultra fast loop (12 times per second)
                end
            end)
        end
    end
)

-- 2. AUTO TRAIN (AUTO HOP / POWER TRAINING)
CreateFeature(
    "AUTO TRAIN",
    UDim2.new(0, 10, 0, 42),
    function(state)
        AutoTrainState = state
        if AutoTrainState then
            task.spawn(function()
                while AutoTrainState do
                    pcall(function()
                        local char = Player.Character
                        if char then
                            -- Equip & Activate Training Tool
                            local tool = char:FindFirstChildOfClass("Tool")
                            if not tool then
                                local bpTool = Player.Backpack:FindFirstChildOfClass("Tool")
                                if bpTool then
                                    bpTool.Parent = char
                                    tool = bpTool
                                end
                            end
                            if tool then
                                tool:Activate()
                            end

                            -- Click simulation
                            VirtualUser:CaptureController()
                            VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
                            VirtualUser:Button1Up(Vector2.new(0, 0), Camera.CFrame)

                            -- Remote events triggering for Training / Hop / Jump Power
                            for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                                if not AutoTrainState then break end
                                if obj:IsA("RemoteEvent") then
                                    local lowerName = obj.Name:lower()
                                    if lowerName:find("train") or lowerName:find("jump") or lowerName:find("hop") or lowerName:find("power") or lowerName:find("click") or lowerName:find("add") then
                                        obj:FireServer()
                                        obj:FireServer(1)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.05) -- Fast 20 CPS loop
                end
            end)
        end
    end
)

-- 3. SPEED BOOST (FAST WALKSPEED)
CreateFeature(
    "SPEED BOOST",
    UDim2.new(0, 10, 0, 82),
    function(state)
        SpeedBoostState = state
        CurrentWalkSpeed = state and 75 or 16
        pcall(function()
            if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = CurrentWalkSpeed
            end
        end)
    end
)

task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if SpeedBoostState and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = CurrentWalkSpeed
            end
        end)
    end
end)

-- 4. INFINITE JUMP
CreateFeature(
    "INFINITE JUMP",
    UDim2.new(0, 10, 0, 122),
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
            Size = UDim2.fromOffset(250, 38)
        }):Play()
    else
        TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(250, 255)
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
FloatingBtn.Text = "🧗"
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

print("Saki Scripts UI (+1 Wall Hop Escape) Infinite Wins V2 Loaded!")
