--========================================================--
--            ROBLOX LUA: AUTO-WIN TELEPORT SCRIPT
--              (For Jump / Step / Obby Games)
--========================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local AutoWinEnabled = true -- Set to true to start, false to stop
local TeleportDelay = 1.0   -- Safe delay in seconds to prevent kicks / crashes

-- Function to find the Win Pad / Finish Line part dynamically
local function getWinPad()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local name = part.Name:lower()
            local parentName = (part.Parent and part.Parent.Name:lower()) or ""

            if name:find("win") or name:find("finish") or name:find("goal") 
               or name:find("end") or name:find("trophy") or name:find("reward")
               or parentName:find("win") or parentName:find("finish") then
                return part
            end
        end
    end
    return nil
end

-- Main Auto-Win Loop
task.spawn(function()
    while true do
        if AutoWinEnabled then
            pcall(function()
                local character = LocalPlayer.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                    if humanoidRootPart and humanoid and humanoid.Health > 0 then
                        local winPad = getWinPad()
                        if winPad then
                            -- Teleport character directly on top of the Win Pad
                            humanoidRootPart.CFrame = winPad.CFrame + Vector3.new(0, 3, 0)
                            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)

                            -- Trigger touch interest simulation
                            firetouchinterest(humanoidRootPart, winPad, 0)
                            task.wait(0.05)
                            firetouchinterest(humanoidRootPart, winPad, 1)
                        end
                    end
                end
            end)
        end
        
        -- Safe delay to avoid kicking or crashing
        task.wait(TeleportDelay)
    end
end)

print("[Auto-Win] Script loaded successfully!")
