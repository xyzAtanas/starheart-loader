local scripts = {
    [15837460390] = "https://raw.githubusercontent.com/xyzAtanas/starheart-loader-test/refs/heads/main/enginedemo.lua",
    [101133806907079] = "https://raw.githubusercontent.com/xyzAtanas/starheart-loader-test/refs/heads/main/ticktockgardens.lua",
    [126574530776259] = "https://raw.githubusercontent.com/xyzAtanas/starheart-loader-test/refs/heads/main/twilightterminal.lua",
    [110541442509291] = "https://raw.githubusercontent.com/xyzAtanas/starheart-loader-test/refs/heads/main/abj.lua",
    [92700582787930] = "https://raw.githubusercontent.com/xyzAtanas/starheart-loader-test/refs/heads/main/Megarampforslime.lua"
}

local fallbackUrl = "https://raw.githubusercontent.com/xyzAtanas/starheart-loader-test/refs/heads/main/others.lua"

local currentScript = scripts[game.PlaceId]
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Starheart",
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

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

Window:SetToggleKey(Enum.KeyCode.K)

Window:OnClose(function()
    WindUI:Notify({
    	Title = "Want to open the UI again?",
    	Content = "Press K on your keyboard!",
    	Duration = 3,
    	Icon = "door-open",
	})
end)

if currentScript then
    loadstring(game:HttpGet(currentScript))()
else
    loadstring(game:HttpGet(fallbackUrl))()
end
