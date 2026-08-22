--========================================================--
--            AUTO WIN SERVER & CLIENT SCRIPT
--                 +1 WALL HOP OBBY ESCAPE
--========================================================--

--========================================================--
-- 1. SERVER SCRIPT (Put in ServerScriptService)
--========================================================--

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AutoWinEvent = ReplicatedStorage:FindFirstChild("AutoWinEvent")

if not AutoWinEvent then
    AutoWinEvent = Instance.new("RemoteEvent")
    AutoWinEvent.Name = "AutoWinEvent"
    AutoWinEvent.Parent = ReplicatedStorage
end

local autoWinPlayers = {}

AutoWinEvent.OnServerEvent:Connect(function(player, enabled)
    autoWinPlayers[player] = enabled == true
end)

local function giveWin(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local trophy = leaderstats:FindFirstChild("Trophy")
        or leaderstats:FindFirstChild("Trophies")
        or leaderstats:FindFirstChild("Wins")

    if trophy and trophy:IsA("IntValue") then
        trophy.Value += 1
    end
end

task.spawn(function()
    while true do
        task.wait(1)

        for player, enabled in pairs(autoWinPlayers) do
            if enabled and player.Parent then
                giveWin(player)
            end
        end
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    autoWinPlayers[player] = nil
end)


--========================================================--
-- 2. CLIENT UI BUTTON SCRIPT (Put in ScreenGui / Button)
--========================================================--

local AutoWinButton = script.Parent -- or define your button here
local AutoWinEventClient = ReplicatedStorage:WaitForChild("AutoWinEvent", 5)

local autoWinEnabled = false

if AutoWinButton and AutoWinButton:IsA("TextButton") then
    AutoWinButton.MouseButton1Click:Connect(function()
        autoWinEnabled = not autoWinEnabled

        if AutoWinEventClient then
            AutoWinEventClient:FireServer(autoWinEnabled)
        end

        if autoWinEnabled then
            AutoWinButton.Text = "ON"
        else
            AutoWinButton.Text = "OFF"
        end
    end)
end
