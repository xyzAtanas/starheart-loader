-- NOT TESTED
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Starheart - A Block's Journey",
    Icon = "star",
    Author = "by Atanas",
    Folder = "Starheart",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "Open Starheart",
    Icon = "star",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("C9E3FF")
    ),
    OnlyMobile = false,
    Enabled = true,
	Draggable = false
})

Window:SetToggleKey(Enum.KeyCode.K)

Window:Tag({
    Title = "v4.1",
    Color = Color3.fromHex("#30ff6a"),
})

Window:OnClose(function()
    WindUI:Notify({
    	Title = "Want to open the UI again?",
    	Content = "Press K on your keyboard!",
    	Duration = 3,
    	Icon = "door-open",
	})
end)

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
local function run(id)
    local p = game.Players.LocalPlayer
    local char = p.Character or p.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local startPos = root.CFrame
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("MeshPart") and v.MeshId == id) or (v:IsA("SpecialMesh") and v.MeshId == id) then
            local target = v:IsA("MeshPart") and v.CFrame or v.Parent.CFrame
            root.CFrame = target + Vector3.new(0, 3, 0)
            task.wait(0.1)
        end
    end
    root.CFrame = startPos
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
local PowerOrbsTab = Window:Tab({
    Title = "Power Orbs",
    Icon = "zap",
})
PowerOrbsTab:Button({
    Title = "Teleport to Defeat the King Beetle",
    Callback = function()
        lp.Character:MoveTo(Vector3.new(240, 108, 2412))
    end,
})
PowerOrbsTab:Button({
    Title = "Teleport to Catching Tokens in Ink Forest",
    Callback = function()
        lp.Character:MoveTo(Vector3.new(335, 7, 2117))
        WindUI:Notify({
            Title = "Power Orb Collector",
            Content = "Collect the tokens",
            Duration = 6.5,
            Icon = "circle-dot",
        })
    end,
})
PowerOrbsTab:Button({
    Title = "Teleport to Inside a Tree Stump",
    Callback = function()
        lp.Character:MoveTo(Vector3.new(849, 76, 2488))
        WindUI:Notify({
            Title = "Power Orb Collector",
            Content = "Groundpound here",
            Duration = 6.5,
            Icon = "circle-dot",
        })
    end,
})
PowerOrbsTab:Button({
    Title = "Teleport to Hidden in an Alcove",
    Callback = function()
        lp.Character:MoveTo(Vector3.new(613, 21, 2099))
    end,
})
PowerOrbsTab:Button({
    Title = "Teleport to Locked In a Cage",
    Callback = function()
        lp.Character:MoveTo(Vector3.new(218, -9, 1783))
    end,
})
PowerOrbsTab:Button({
    Title = "Teleport to On the lone thin trunk",
    Callback = function()
        lp.Character:MoveTo(Vector3.new(392, 83, 2461))
    end,
})
PowerOrbsTab:Button({
    Title = "Teleport to Ink Forest Timer Challenge",
    Callback = function()
        lp.Character:MoveTo(Vector3.new(663, -3, 2294))
        WindUI:Notify({
            Title = "Power Orb Collector",
            Content = "Press the button first",
            Duration = 6.5,
            Icon = "circle-dot",
        })
    end,
})
PowerOrbsTab:Button({
    Title = "Teleport to Climbing the Trunk",
    Callback = function()
        lp.Character:MoveTo(Vector3.new(7, 359, -54))
    end,
})
PowerOrbsTab:Button({
    Title = "Teleport to Secret Cave just outside the Trunk",
    Callback = function()
        lp.Character:MoveTo(Vector3.new(36, 286, 242))
        WindUI:Notify({
            Title = "Power Orb Collector",
            Content = "Collect the tokens",
            Duration = 6.5,
            Icon = "circle-dot",
        })
    end,
})
PowerOrbsTab:Button({
    Title = "Teleport to Locked in a cage inside the Rocks",
    Callback = function()
        lp.Character:MoveTo(Vector3.new(75, 125, 2095))
    end,
})
local FarmTab = Window:Tab({
    Title = "Farmers",
    Icon = "sprout",
})
FarmTab:Button({
    Title = "Sparks Farmer",
    Callback = function()
        run("rbxassetid://103739592450049")
    end,
})
FarmTab:Button({
    Title = "Token Collector",
    Callback = function()
        run("rbxassetid://127960998871180")
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
