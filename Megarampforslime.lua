local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
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

Window:EditOpenButton({
    Title = "Open Starheart",
    Icon = "star",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("C9E3FF")
    ),
    OnlyMobile = false,
    Enabled = true,
	Draggable = false
})

Window:SetToggleKey(Enum.KeyCode.K)

Window:OnClose(function()
    WindUI:Notify({
    	Title = "Want to open the UI again?",
    	Content = "Press K on your keyboard!",
    	Duration = 3,
    	Icon = "door-open",
	})
end)

Window:Tag({
    Title = "v1.3",
    Color = Color3.fromHex("#30ff6a"),
})

local TweenService = game:GetService("TweenService")
local part = workspace:WaitForChild("Progetto"):WaitForChild("Checkpoints"):WaitForChild("82")
local targetPosition = Vector3.new(-5, 201, -1250)
local moveTime = 0
local tweenInfo = TweenInfo.new(
    moveTime,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

local goal = { Position = targetPosition }

local tween = TweenService:Create(part, tweenInfo, goal)

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

local function getParkourFolder()
    local folderName = "LOCAL_MINI_PARKOUR_" .. LocalPlayer.Name
    local mainFolder = Workspace:FindFirstChild(folderName)
    if not mainFolder then return nil end

    return mainFolder:FindFirstChild("Checkpoints")
end

local function unseatPlayer()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Sit = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

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

local function runAutoAdvanceOnce()
    autoRunning = true
    unseatPlayer()

    while autoRunning do
        local success = teleportToNumber(currentCheckpoint)

        if success then
            unseatPlayer()

            WindUI:Notify({
                Title = "Auto TP",
                Content = "Checkpoint " .. currentCheckpoint,
                Duration = 1,
            })
            currentCheckpoint += 1

            if currentCheckpoint > 35 then
                autoRunning = false
                WindUI:Notify({
                    Title = "Auto TP",
                    Content = "Finished all checkpoints",
                    Duration = 3,
                })
                break
            end
        else
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
end

local function startAutoAdvance()
    task.spawn(runAutoAdvanceOnce)
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
    Title = "Auto Advance Checkpoints",
    Default = false,
    Callback = function(state)
        if state then
            currentCheckpoint = 1
            startAutoAdvance()
        else
            stopAutoAdvance()
        end
    end
})

local function getStartPrompt()
    local progetto = Workspace:FindFirstChild("Progetto")
    if not progetto then return nil end

    local enter = progetto:FindFirstChild("MiniParkourEnter")
    if not enter then return nil end

    local prompt = enter:FindFirstChild("MiniParkourPrompt", true)
    if prompt then
        prompt.MaxActivationDistance = math.huge
        prompt.RequiresLineOfSight = false
    end

    return prompt
end

local function fireStartPrompt()
    local prompt = getStartPrompt()
    if not prompt then
        WindUI:Notify({
            Title = "Auto Farm",
            Content = "MiniParkourPrompt not found",
            Duration = 3,
        })
        return false
    end

    local promptPart = prompt.Parent
    if promptPart and not promptPart:IsA("BasePart") then
        promptPart = promptPart:FindFirstAncestorWhichIsA("BasePart")
    end
    if promptPart and promptPart:IsA("BasePart") then
        teleportTo(promptPart)
        task.wait(0.2)
    end

    pcall(function()
        prompt.Enabled = true
    end)

    local usedExploit = typeof(fireproximityprompt) == "function"

    WindUI:Notify({
        Title = "Auto Farm",
        Content = usedExploit and "Firing prompt (fireproximityprompt)" or "Firing prompt (hold simulation)",
        Duration = 2,
    })

    if usedExploit then
        for i = 1, 3 do
            local ok = pcall(function()
                fireproximityprompt(prompt)
            end)
            if not ok then
                usedExploit = false
                break
            end
            task.wait(0.15)
        end
    end

    if not usedExploit then
        for i = 1, 2 do
            pcall(function()
                prompt.Enabled = true
                prompt:InputHoldBegin()
                task.wait(prompt.HoldDuration + 0.1)
                prompt:InputHoldEnd()
            end)
            task.wait(0.2)
        end
    end

    return true
end

local farmRunning = false

local function startAutoFarm()
    farmRunning = true

    task.spawn(function()
        while farmRunning do
            fireStartPrompt()
            task.wait(1)

            if not farmRunning then break end

            currentCheckpoint = 1
            teleportToNumber(1)
            unseatPlayer()

            WindUI:Notify({
                Title = "Auto Farm",
                Content = "Waiting 2s before auto complete...",
                Duration = 3,
                task.wait(2)
            })

            if not farmRunning then break end

            runAutoAdvanceOnce()

            if not farmRunning then break end

            task.wait(1)
        end
    end)
end

local function stopAutoFarm()
    farmRunning = false
    autoRunning = false
end

Tab:Toggle({
    Title = "Auto Farm (Repeat)",
    Default = false,
    Callback = function(state)
        if state then
            startAutoFarm()
        else
            stopAutoFarm()
        end
    end
})

Tab:Button({
    Title = "Debug: List Checkpoints",
    Callback = function()
        local folder = getParkourFolder()
        if not folder then
            WindUI:Notify({ Title = "Error", Content = "Checkpoints folder not found", Duration = 3 })
            return
        end

        print("✦ Contents of " .. folder:GetFullName() .. " ✦")
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

        LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = value
            end
        end)
    end
})

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

MainTab:Button({
    Title = "x500,000 luck every time",
    Callback = function()
        tween:Play()
    end
})

local Minigame1Tab = Window:Tab({
    Title = "Memory Slime",
    Icon = "brain",
})

Minigame1Tab:Button({
    Title = "Reveal Slime",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local gui = player:WaitForChild("PlayerGui"):FindFirstChild("MiniGame1MemoryGui")

        if not gui then return end

        local function shouldReveal(obj)
            return obj:IsA("TextLabel") and obj.Text ~= "✓"
        end

        for _, obj in ipairs(gui:GetDescendants()) do
            if shouldReveal(obj) then
                obj.Visible = true
            end
        end

        if not gui:FindFirstChild("RevealConnectionSet") then
            local tag = Instance.new("BoolValue")
            tag.Name = "RevealConnectionSet"
            tag.Parent = gui

            gui.DescendantAdded:Connect(function(obj)
                if shouldReveal(obj) then
                    obj.Visible = true
                end
            end)
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
