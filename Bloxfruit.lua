--// PLAYER
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

--------------------------------------------------
-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "PVP_TOOL"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,200)
frame.Position = UDim2.new(0.5,-110,0.4,-100)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local function btn(txt,y)
    local b = Instance.new("TextButton",frame)
    b.Size = UDim2.new(0.8,0,0,35)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = txt
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(0,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",b)
    return b
end

local aimBtn = btn("AUTO AIM OFF 🎯",20)
local unwalkBtn = btn("UNWALK ❌",70)
local runBtn = btn("TELE AWAY 🏃",120)

--------------------------------------------------
-- AIM (GIỮ CHUỘT)
local aimEnabled = false
local holding = false

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.UserInputType == Enum.UserInputType.MouseButton1 then
        holding = true
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        holding = false
    end
end)

local function getClosest()
    local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    local closest, dist = nil, math.huge

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (myHRP.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = hrp
                end
            end
        end
    end

    return closest
end

task.spawn(function()
    while true do
        if aimEnabled and holding then
            local target = getClosest()
            if target then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
            end
        end
        task.wait(0.02)
    end
end)

aimBtn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimBtn.Text = aimEnabled and "AUTO AIM ON 🎯" or "AUTO AIM OFF 🎯"
end)

--------------------------------------------------
-- UNWALK (KHÓA DI CHUYỂN)
local unwalk = false

unwalkBtn.MouseButton1Click:Connect(function()
    unwalk = not unwalk

    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if unwalk then
            hum.WalkSpeed = 0
            hum.JumpPower = 0
            unwalkBtn.Text = "UNWALK ON 🧱"
        else
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            unwalkBtn.Text = "UNWALK ❌"
        end
    end
end)

--------------------------------------------------
-- TELE AWAY (CHẠY KHỎI COMBO)
runBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- dịch ngẫu nhiên 50-60m
    local offset = Vector3.new(
        math.random(-60,60),
        0,
        math.random(-60,60)
    )

    hrp.CFrame = hrp.CFrame + offset
end)

--------------------------------------------------
-- TOGGLE UI (K)
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.K then
        gui.Enabled = not gui.Enabled
    end
end)
