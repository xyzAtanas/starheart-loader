local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local LocalPlayer = game:GetService("Players").LocalPlayer

local Window = WindUI:CreateWindow({
    Title = "Starheart - +1 Jump Mace Escape",
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

Window:OnClose(function()
    WindUI:Notify({
    	Title = "Want to open the UI again?",
    	Content = "Press K on your keyboard!",
    	Duration = 3,
    	Icon = "door-open",
	})
end)

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local Settings = {
    SpeedEnabled = false,
    Velocity = 50,
    JumpEnabled = false,
    JumpPower = 100,
}

local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(function()
    pcall(function()
        local character = LocalPlayer.Character
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

local function setupJump(character)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    humanoid.Jumping:Connect(function()
        if Settings.JumpEnabled then
            rootPart.AssemblyLinearVelocity = Vector3.new(
                rootPart.AssemblyLinearVelocity.X,
                Settings.JumpPower,
                rootPart.AssemblyLinearVelocity.Z
            )
        end
    end)
end

if LocalPlayer.Character then
    setupJump(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(setupJump)

Window:SetToggleKey(Enum.KeyCode.K)

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "shield",
})

MainTab:Toggle({
    Title = "Enable Speed Bypass",
    Value = false,
    Callback = function(state)
        Settings.SpeedEnabled = state
    end,
})

MainTab:Slider({
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

MainTab:Toggle({
    Title = "Enable Jump Bypass",
    Value = false,
    Callback = function(state)
        Settings.JumpEnabled = state
    end,
})

MainTab:Slider({
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

local FarmingTab = Window:Tab({
    Title = "Farming",
    Icon = "repeat",
})

local MaceEscapeEnabled = false
local MaceEscapeLoopRunning = false

FarmingTab:Toggle({
    Title = "Toggle Jump Farm",
    Value = false,
    Callback = function(state)
        MaceEscapeEnabled = state

        if state and not MaceEscapeLoopRunning then
            MaceEscapeLoopRunning = true
            task.spawn(function()
                local Event = game:GetService("ReplicatedStorage").Events.MaceAttack

                while MaceEscapeEnabled do
                    local target = workspace.Target:GetChildren()[49]
                    if target then
                        Event:FireServer(
                            target,
                            true,
                            -176.43022155762
                        )
                    end
                    task.wait(1)
                end

                MaceEscapeLoopRunning = false
            end)
        end
    end,
})

local Button13Enabled = false
local Button13LoopRunning = false

FarmingTab:Toggle({
    Title = "Toggle Farm Wins",
    Value = false,
    Callback = function(state)
        Button13Enabled = state

        if state and not Button13LoopRunning then
            Button13LoopRunning = true
            task.spawn(function()
                while Button13Enabled do
                    local giveWins = workspace:FindFirstChild("GiveWins")
                    local button13 = giveWins and giveWins:FindFirstChild("Button13")
                    local touchPart = button13 and button13:FindFirstChild("Touch")
                    local touchInterest = touchPart and touchPart:FindFirstChild("TouchInterest")
                    local character = LocalPlayer.Character
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

                    if touchInterest and rootPart and firetouchinterest then
                        firetouchinterest(rootPart, touchPart, 0)
                        firetouchinterest(rootPart, touchPart, 1)
                    end

                    task.wait(1)
                end

                Button13LoopRunning = false
            end)
        end
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

OtherTab:Button({
    Title = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))()
    end,
})
