-- Im not doing world 1 until it releases
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Starheart - A Block's Journey",
    Icon = 105195470942547,
    LoadingTitle = "French fry loader",
    LoadingSubtitle = "by Atanas",
    ShowText = "Hub",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Starheart",
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true,
    },
    KeySystem = false,
})

local Tab = Window:CreateTab("Main", "pin")

local Settings = {
    SpeedEnabled = false,
    Velocity = 50,
    JumpEnabled = false,
    JumpPower = 100
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
        
 local lp = game.Players.LocalPlayer

local runService = game:GetService("RunService")


-- Main Logic Loop

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
        if part:IsA("BasePart") and (part.BrickColor == BrickColor.new("Royal purple") or part.Color == Color3.fromRGB(98, 37, 209)) then
            table.insert(purpleParts, part)
        end
    end
    currentIndex = 0
end

local Paragraph = Tab:CreateParagraph({Title = "20/2/2026", Content = "A Block's Journey support"})

Tab:CreateSection("Movement")

local SpeedToggle = Tab:CreateToggle({
   Name = "Enable Speed Bypass",
   CurrentValue = false,
   Flag = "SpeedT",
   Callback = function(Value)
      Settings.SpeedEnabled = Value
   end,
})
local SpeedInput = Tab:CreateInput({
   Name = "Walk Velocity",
   PlaceholderText = "Default: 50",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then
          Settings.Velocity = num
      end
   end,
})

local JumpToggle = Tab:CreateToggle({
   Name = "Enable Jump Bypass",
   CurrentValue = false,
   Flag = "JumpT",
   Callback = function(Value)
      Settings.JumpEnabled = Value
   end,
})

-- Replaced Slider with Input (TextBox)
local JumpInput = Tab:CreateInput({
   Name = "Jump Force",
   PlaceholderText = "Default: 100",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then
          Settings.JumpPower = num
      end
   end,
})

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

Tab:CreateSection("Power Orbs Ink Forest")


local Button = Tab:CreateButton({
    Name = "Teleport to Defeat the King Beetle",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(240, 108, 2412))
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to Catching Tokens in Ink Forest",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(335, 7, 2117))
	Rayfield:Notify({
   		Title = "Power Orb collector",
   		Content = "Collect the tokens",
   		Duration = 6.5,
   		Image = 4483362458,
	})
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to Inside a Tree Stump",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(849, 76, 2488))
	Rayfield:Notify({
   		Title = "Power Orb collector",
   		Content = "Groundpound here",
   		Duration = 6.5,
   		Image = 4483362458,
	})
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to Hidden in an Alcove",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(613, 21, 2099))
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to Locked In a Cage",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(218, -9, 1783))
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to On the lone thin trunk",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(392, 83, 2461))
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to Ink Forest Timer Challenge",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(663, -3, 2294))
	Rayfield:Notify({
   		Title = "Power Orb collector",
   		Content = "Press the button first",
   		Duration = 6.5,
   		Image = 4483362458,
	})
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to Climbing the Trunk",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(7, 359, -54))
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to Secret Cave just outside the Trunk",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(36, 286, 242))
	Rayfield:Notify({
   		Title = "Power Orb collector",
   		Content = "Collect the tokens",
   		Duration = 6.5,
   		Image = 4483362458,
	})
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to Locked in a cage inside the Rocks",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(75, 125, 2095))
    end,
})

local Section = Tab:CreateSection("Sparks farmer & Token collector")

Tab:CreateButton({
    Name = "Sparks farmer",
    Callback = function()
        run("rbxassetid://103739592450049")
    end,
})

Tab:CreateButton({
    Name = "Token collector",
    Callback = function()
        run("rbxassetid://127960998871180") 
    end,
})

local Section = Tab:CreateSection("Fun stuff")


local Button = Tab:CreateButton({
    Name = "Building Tools (client-sided)",
    Callback = function()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
	wait(0.5)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/refs/heads/main/f3x.lua"))()
    end,
})

local MainTab = Window:CreateTab("Places", 4483362458)

local Section = MainTab:CreateSection("Detected Subplaces")

local AssetService = game:GetService("AssetService")

local TeleportService = game:GetService("TeleportService")

local Debris = game:GetService("Debris")


local isTeleporting = false

local function AttemptTeleport(placeId, placeName)
    if isTeleporting then 
        Rayfield:Notify({
            Title = "Please Wait",
            Content = "Teleport is already in progress.",
            Duration = 3,
            Image = 4483362458,
        })
        return 
    end

    isTeleporting = true
    
    Rayfield:Notify({
        Title = "Teleporting...",
        Content = "Traveling to: " .. placeName,
        Duration = 5,
        Image = 4483362458,
    })

    TeleportService:Teleport(placeId)

    local connection
    connection = game.Players.LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed then
            isTeleporting = false
            Rayfield:Notify({
                Title = "Failed",
                Content = "Teleport failed. Please try again.",
                Duration = 5,
                Image = 4483362458,
            })

            if connection then connection:Disconnect() end
        end
    end)

    task.delay(10, function()
        if isTeleporting then
            isTeleporting = false
        end
    end)
end

task.spawn(function()
    local success, pages = pcall(function()
        return AssetService:GetGamePlacesAsync()
    end)

    if not success then
        Rayfield:Notify({
            Title = "Error",
            Content = "Could not fetch game places. API might be blocked.",
            Duration = 5,
            Image = 4483362458,
        })
        return
    end

    while true do
        for _, place in next, pages:GetCurrentPage() do
            MainTab:CreateButton({
                Name = place.Name .. " [" .. tostring(place.PlaceId) .. "]",
                Callback = function()
                    AttemptTeleport(place.PlaceId, place.Name)
                end,
            })
        end

        if pages.IsFinished then
            break
        end

        pages:AdvanceToNextPageAsync()
    end

    

    Rayfield:Notify({
        Title = "Scan Complete",
        Content = "All subplaces loaded into the list.",
        Duration = 3,
        Image = 4483362458,
    })
end) 
