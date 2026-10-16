--// Temiz ve Sıfırdan Yazılmış Neon Hub
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Önceki pencereleri tamamen temizle
if CoreGui:FindFirstChild("CleanNeonGui") then
    CoreGui.CleanNeonGui:Destroy()
end

-- Ana Ekran Katmanı
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CleanNeonGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Ana Çerçeve (Pencere)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 140)
frame.Position = UDim2.new(0.5, -120, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Köşe Yuvarlama
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim2.new(0, 8)
corner.Parent = frame

-- Neon Çizgi Efekti
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 255, 150)
stroke.Thickness = 2
stroke.Parent = frame

-- Başlık Metni
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 35)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "BLOX STRIKE HUB"
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Kapatma Butonu (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim2.new(0, 5)
closeCorner.Parent = closeBtn

-- Uçma Modu Butonu
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.9, 0, 0, 45)
flyBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
flyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
flyBtn.Text = "UÇMA MODU: KAPALI"
flyBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
flyBtn.TextSize = 13
flyBtn.Font = Enum.Font.GothamBold
flyBtn.Parent = frame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim2.new(0, 6)
flyCorner.Parent = flyBtn

local flyStroke = Instance.new("UIStroke")
flyStroke.Color = Color3.fromRGB(255, 80, 80)
flyStroke.Thickness = 1
flyStroke.Parent = flyBtn

-- Buton İşlevleri
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local flying = false
local bodyVel, bodyGyro

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    if flying then
        flyBtn.Text = "UÇMA MODU: AÇIK"
        flyBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
        flyStroke.Color = Color3.fromRGB(80, 255, 80)

        bodyVel = Instance.new("BodyVelocity")
        bodyVel.Velocity = Vector3.zero
        bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVel.Parent = hrp

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp

        if hum then hum.PlatformStand = true end
    else
        flyBtn.Text = "UÇMA MODU: KAPALI"
        flyBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        flyStroke.Color = Color3.fromRGB(255, 80, 80)

        if bodyVel then bodyVel:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        if hum then hum.PlatformStand = false end
    end
end)
