local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Starheart - Tick Tock Gardens",
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

game.Players.LocalPlayer.PlayerGui.UI.Main.objective.Text = "Thank you for using Starheart! ⭐💖"

local Tab = Window:CreateTab("Stars Align", "pin")

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

local Paragraph = Tab:CreateParagraph({Title = "6/2/2026", Content = "Starheart loader for diffrient places"})

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

local Section = Tab:CreateSection("Stars")

local Button = Tab:CreateButton({
    Name = "Teleport to Fit for a King star",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(124, 334, -2625))
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to No Fun in the Dungeon star",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-41, 215, -1012))
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to Time Ticking Triumph star",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(459, 425, -234))
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to The Land that Time Forgot star",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(143, 164, 2094))
    end,
})

local Button = Tab:CreateButton({
    Name = "Teleport to Around the Garden Wall star",
    Callback = function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(784, 210, -799))
    end,
})

local Section = Tab:CreateSection("Tears")

local Toggle = Tab:CreateToggle({
   Name = "Auto-Collect missing tears",
   CurrentValue = false,
   Flag = "AutoTP",
   Callback = function(Value)
      AutoTeleportEnabled = Value
      if AutoTeleportEnabled then
         refreshParts()
         if #purpleParts == 0 then
            Rayfield:Notify({Title = "Error", Content = "No missing tears found!", Duration = 3})
            return
         end

         task.spawn(function()
            while AutoTeleportEnabled and currentIndex < #purpleParts do
               currentIndex = currentIndex + 1
               local targetPart = purpleParts[currentIndex]
               
               local player = game.Players.LocalPlayer
               local character = player.Character
               
               if character and character:FindFirstChild("HumanoidRootPart") then
                  character.HumanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
                  
                  Rayfield:Notify({
                     Title = "Tear Finder",
                     Content = "Part " .. currentIndex .. " of " .. #purpleParts,
                     Duration = 0.8
                  })
               end
               
               task.wait(1.5)
            end
            
            if currentIndex >= #purpleParts then
               Rayfield:Notify({Title = "Finished", Content = "All tears collected!", Duration = 5})
               AutoTeleportEnabled = false
            end
         end)
      end
   end,
})

local Button = Tab:CreateButton({
   Name = "Reset & Re-Scan",
   Callback = function()
      refreshParts()
      Rayfield:Notify({Title = "Tear Finder", Content = "List reset. Found " .. #purpleParts .. " missing tears.", Duration = 2})
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
