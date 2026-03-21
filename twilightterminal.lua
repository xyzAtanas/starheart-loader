local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Starheart - Twilight Terminal",
    Icon = "star",
    Author = "by Atanas",
    Folder = "Starheart",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
})
game.Players.LocalPlayer.PlayerGui.UI.Main.objective.Text = "Thank you for using Starheart! ⭐💖"
local Settings = {
    SpeedEnabled = false,
    Velocity = 50,
    JumpEnabled = false,
    JumpPower = 100,
}
local lp = game.Players.LocalPlayer
local runService = game:GetService("RunService")
runService.Heartbeat:Connect(function()
    pcall(function()
        local character = lp.Character
        if not character then return end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not rootPart or not humanoid then return end
        if Settings.SpeedEnabled then
            if humanoid.MoveDirection.Magnitude > 0 then
                rootPart.AssemblyLinearVelocity = Vector3.new(
                    humanoid.MoveDirection.X * Settings.Velocity,
                    rootPart.AssemblyLinearVelocity.Y,
                    humanoid.MoveDirection.Z * Settings.Velocity
                )
            else
                rootPart.AssemblyLinearVelocity = Vector3.new(
                    0,
                    rootPart.AssemblyLinearVelocity.Y,
                    0
                )
            end
        end
    end)
end)
local function setupJump(char)
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    hum.Jumping:Connect(function()
        if Settings.JumpEnabled then
            root.AssemblyLinearVelocity = Vector3.new(
                root.AssemblyLinearVelocity.X,
                Settings.JumpPower,
                root.AssemblyLinearVelocity.Z
            )
        end
    end)
end
if lp.Character then setupJump(lp.Character) end
lp.CharacterAdded:Connect(setupJump)
local purpleParts = {}
local currentIndex = 0
local AutoTeleportEnabled = false
local function refreshParts()
    purpleParts = {}
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (
            part.BrickColor == BrickColor.new("Royal purple") or
            part.Color == Color3.fromRGB(98, 37, 209)
        ) then
            table.insert(purpleParts, part)
        end
    end
    currentIndex = 0
end
local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user",
})
PlayerTab:Toggle({
    Title = "Enable Speed Bypass",
    Value = false,
    Callback = function(state)
        Settings.SpeedEnabled = state
    end,
})
PlayerTab:Slider({
    Title = "Walk Velocity",
    Step = 1,
    Value = {
        Min = 16,
        Max = 300,
        Default = 50,
    },
    Callback = function(value)
        Settings.Velocity = value
    end,
})
PlayerTab:Toggle({
    Title = "Enable Jump Bypass",
    Value = false,
    Callback = function(state)
        Settings.JumpEnabled = state
    end,
})
PlayerTab:Slider({
    Title = "Jump Power",
    Step = 1,
    Value = {
        Min = 0,
        Max = 500,
        Default = 100,
    },
    Callback = function(value)
        Settings.JumpPower = value
    end,
})
local StarsTab = Window:Tab({
    Title = "Stars",
    Icon = "star",
})
StarsTab:Button({
    Title = "Teleport to Star 1",
    Callback = function()
        lp.Character:MoveTo(Vector3.new(476, 392, 663))
    end,
})
StarsTab:Button({
    Title = "Teleport to Star 2 & 3",
    Callback = function()
        lp.Character:MoveTo(Vector3.new(-1415, 2, 105))
    end,
})
local TearsTab = Window:Tab({
    Title = "Tears",
    Icon = "droplet",
})
TearsTab:Toggle({
    Title = "Auto-Collect Missing Tears",
    Value = false,
    Callback = function(state)
        AutoTeleportEnabled = state
        if AutoTeleportEnabled then
            refreshParts()
            if #purpleParts == 0 then
                WindUI:Notify({
                    Title = "Error",
                    Content = "No missing tears found!",
                    Duration = 3,
                    Icon = "alert-circle",
                })
                return
            end
            task.spawn(function()
                while AutoTeleportEnabled and currentIndex < #purpleParts do
                    currentIndex = currentIndex + 1
                    local targetPart = purpleParts[currentIndex]
                    local character = lp.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
                        WindUI:Notify({
                            Title = "Tear Finder",
                            Content = "Part " .. currentIndex .. " of " .. #purpleParts,
                            Duration = 0.8,
                            Icon = "droplets",
                        })
                    end
                    task.wait(1.5)
                end
                if currentIndex >= #purpleParts then
                    WindUI:Notify({
                        Title = "Finished",
                        Content = "All tears collected!",
                        Duration = 5,
                        Icon = "check-circle",
                    })
                    AutoTeleportEnabled = false
                end
            end)
        end
    end,
})
TearsTab:Button({
    Title = "Reset & Re-Scan",
    Callback = function()
        refreshParts()
        WindUI:Notify({
            Title = "Tear Finder",
            Content = "List reset. Found " .. #purpleParts .. " missing tears.",
            Duration = 2,
            Icon = "refresh-cw",
        })
    end,
})
local OtherTab = Window:Tab({
    Title = "Other Things",
    Icon = "wand",
})
OtherTab:Button({
    Title = "Building Tools (client-sided)",
    Callback = function()
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
        wait(0.5)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/refs/heads/main/f3x.lua"))()
    end,
})
local PlacesTab = Window:Tab({
    Title = "Places",
    Icon = "map",
})
local AssetService = game:GetService("AssetService")
local TeleportService = game:GetService("TeleportService")
local isTeleporting = false
local function AttemptTeleport(placeId, placeName)
    if isTeleporting then
        WindUI:Notify({
            Title = "Please Wait",
            Content = "A teleport is already in progress.",
            Duration = 3,
            Icon = "clock",
        })
        return
    end
    isTeleporting = true
    WindUI:Notify({
        Title = "Teleporting...",
        Content = "Traveling to: " .. placeName,
        Duration = 5,
        Icon = "map-pin",
    })
    TeleportService:Teleport(placeId)
    local connection
    connection = lp.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed then
            isTeleporting = false
            WindUI:Notify({
                Title = "Teleport Failed",
                Content = "Could not travel to " .. placeName .. ". Please try again.",
                Duration = 5,
                Icon = "x-circle",
            })
            if connection then connection:Disconnect() end
        end
    end)
    task.delay(10, function()
        if isTeleporting then isTeleporting = false end
    end)
end
task.spawn(function()
    local success, pages = pcall(function()
        return AssetService:GetGamePlacesAsync()
    end)
    if not success then
        WindUI:Notify({
            Title = "Error",
            Content = "Could not fetch game places. API may be blocked.",
            Duration = 5,
            Icon = "alert-circle",
        })
        return
    end
    while true do
        for _, place in next, pages:GetCurrentPage() do
            PlacesTab:Button({
                Title = place.Name .. " [" .. tostring(place.PlaceId) .. "]",
                Callback = function()
                    AttemptTeleport(place.PlaceId, place.Name)
                end,
            })
        end
        if pages.IsFinished then break end
        pages:AdvanceToNextPageAsync()
    end
    WindUI:Notify({
        Title = "Scan Complete",
        Content = "All subplaces have been loaded.",
        Duration = 3,
        Icon = "check",
    })
end)
