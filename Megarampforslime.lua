local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Starheart - Mega Ramp for Slime",
    Icon = "star",
    Author = "By Atanas",
    Folder = "Starheart",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
})


Window:Tag({
    Title = "v1.0",
    Color = Color3.fromHex("#30ff6a"),
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "user",
})

local Tab = Window:Tab({
    Title = "Mini Parkour",
    Icon = "roller-coaster",
})

local autoRunning = false
local currentCheckpoint = 1

-- Finds the player's Checkpoints folder automatically
local function getParkourFolder()
    local folderName = "LOCAL_MINI_PARKOUR_" .. LocalPlayer.Name
    local mainFolder = Workspace:FindFirstChild(folderName)
    if not mainFolder then return nil end

    return mainFolder:FindFirstChild("Checkpoints")
end

-- Unseats the player if currently sitting
local function unseatPlayer()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Sit = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- Teleports character to a given part
local function teleportTo(part)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local cframe
    if part:IsA("BasePart") then
        cframe = part.CFrame
    elseif part:IsA("Model") then
        cframe = part:GetPivot()
    end

    if cframe then
        hrp.CFrame = cframe * CFrame.new(0, 3, 0)
    end
end

-- Teleport by checkpoint number
local function teleportToNumber(num)
    local folder = getParkourFolder()
    if not folder then return false end

    local part = folder:FindFirstChild(tostring(num))
    if part then
        teleportTo(part)
        return true
    end
    return false
end

-- Main auto-advance loop
local function startAutoAdvance()
    autoRunning = true
    unseatPlayer()

    task.spawn(function()
        while autoRunning do
            local success = teleportToNumber(currentCheckpoint)

            if success then
                unseatPlayer() -- unsit after every checkpoint teleport

                WindUI:Notify({
                    Title = "Auto Complete",
                    Content = "Checkpoint " .. currentCheckpoint,
                    Duration = 1,
                })
                currentCheckpoint += 1

                if currentCheckpoint > 35 then
                    autoRunning = false
                    WindUI:Notify({
                        Title = "Auto Complete",
                        Content = "Finished Parkour",
                        Duration = 3,
                    })
                    break
                end
            else
                -- checkpoint not found, stop to avoid spamming
                autoRunning = false
                WindUI:Notify({
                    Title = "Auto TP Stopped",
                    Content = "Checkpoint " .. currentCheckpoint .. " not found",
                    Duration = 3,
                })
                break
            end

            task.wait(0.1)
        end
    end)
end

local function stopAutoAdvance()
    autoRunning = false
end

local Paragraph = Tab:Paragraph({
    Title = "WARNING: Start the parkour before running",
    Desc = "You may need to toggle multiple times because the car physics are glitchy.",
    Color = "Red",
    Image = "triangle-alert",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false
})

Tab:Toggle({
    Title = "Auto Complete Mini Parkour",
    Default = false,
    Callback = function(state)
        if state then
            currentCheckpoint = 1 -- reset to start; remove this line to resume from last position
            startAutoAdvance()
        else
            stopAutoAdvance()
        end
    end
})

-- Debug button: lists everything inside Checkpoints if something's still off
Tab:Button({
    Title = "Debug: List Checkpoints",
    Callback = function()
        local folder = getParkourFolder()
        if not folder then
            WindUI:Notify({ Title = "Error", Content = "Checkpoints folder not found", Duration = 3 })
            return
        end

        print("--- Contents of " .. folder:GetFullName() .. " ---")
        for _, child in ipairs(folder:GetChildren()) do
            print(child.ClassName .. " : " .. child.Name)
        end
        WindUI:Notify({
            Title = "Debug",
            Content = "Check console (F9) for full list",
            Duration = 3,
        })
    end
})

----------------------------------------------------------------
-- Main Tab: Speed Changer + Vehicle Fly
----------------------------------------------------------------

-- ===== Speed Changer =====
local function getHumanoid()
    local character = LocalPlayer.Character
    if not character then return nil end
    return character:FindFirstChildOfClass("Humanoid")
end

MainTab:Slider({
    Title = "Walk Speed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(value)
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.WalkSpeed = value
        end

        -- keep speed applied across respawns
        LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = value
            end
        end)
    end
})

-- ===== Vehicle Fly =====
local vehicleFlying = false
local flyConnection = nil
local flySpeed = 60

local function getSeatVehiclePart()
    local character = LocalPlayer.Character
    if not character then return nil end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end

    local seatPart = humanoid.SeatPart
    if not seatPart then return nil end

    -- try to get the whole vehicle model's primary part, fallback to the seat itself
    local model = seatPart:FindFirstAncestorOfClass("Model")
    if model and model.PrimaryPart then
        return model.PrimaryPart, model
    end

    return seatPart, seatPart
end

local function startVehicleFly()
    local vehiclePart = getSeatVehiclePart()
    if not vehiclePart then
        WindUI:Notify({
            Title = "Vehicle Fly",
            Content = "You must be seated in a vehicle first",
            Duration = 3,
        })
        return
    end

    vehicleFlying = true

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * math.huge
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = vehiclePart

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * math.huge
    bodyGyro.P = 3000
    bodyGyro.CFrame = vehiclePart.CFrame
    bodyGyro.Parent = vehiclePart

    flyConnection = RunService.Heartbeat:Connect(function()
        if not vehicleFlying then return end

        local currentVehiclePart = getSeatVehiclePart()
        if not currentVehiclePart or currentVehiclePart ~= vehiclePart then
            -- player left the seat or vehicle changed; stop flying
            vehicleFlying = false
            return
        end

        local moveVector = Vector3.new(0, 0, 0)
        local camCFrame = Camera.CFrame

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector += camCFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector -= camCFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector -= camCFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector += camCFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector += Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveVector += Vector3.new(0, -1, 0)
        end

        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit * flySpeed
        end

        bodyVelocity.Velocity = moveVector
        bodyGyro.CFrame = CFrame.new(vehiclePart.Position, vehiclePart.Position + camCFrame.LookVector)
    end)
end

local function stopVehicleFly()
    vehicleFlying = false

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    local vehiclePart = getSeatVehiclePart()
    if vehiclePart then
        local bv = vehiclePart:FindFirstChildOfClass("BodyVelocity")
        local bg = vehiclePart:FindFirstChildOfClass("BodyGyro")
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end

MainTab:Slider({
    Title = "Fly Speed",
    Step = 5,
    Value = {
        Min = 10,
        Max = 300,
        Default = 60,
    },
    Callback = function(value)
        flySpeed = value
    end
})

MainTab:Toggle({
    Title = "Vehicle Fly (must be seated)",
    Default = false,
    Callback = function(state)
        if state then
            startVehicleFly()
        else
            stopVehicleFly()
        end
    end
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

OtherTab:Button({
    Title = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))()
    end,
})