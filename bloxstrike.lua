--// Modern Neon UI & Basic Fly Template
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer

-- Frame Saydamlaştırma / Animasyon Yardımcısı
local function createNeonUI()
    -- Ana ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NeonHubGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui

    -- Ana Pencere
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 260, 0, 180)
    mainFrame.Position = UDim2.new(0.5, -130, 0.4, -90)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    -- Neon Parlama Efekti (UIStroke)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 200) -- Neon Camgöbeği
    stroke.Thickness = 2
    stroke.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim2.new(0, 10)
    corner.Parent = mainFrame

    -- Başlık
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -70, 0, 35)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "NEON HUB"
    title.TextColor3 = Color3.fromRGB(0, 255, 200)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = mainFrame

    -- Küçültme (Minimize) Butonu
    local minButton = Instance.new("TextButton")
    minButton.Size = UDim2.new(0, 25, 0, 25)
    minButton.Position = UDim2.new(1, -55, 0, 5)
    minButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    minButton.Text = "-"
    minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minButton.TextSize = 16
    minButton.Font = Enum.Font.GothamBold
    minButton.Parent = mainFrame

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim2.new(0, 6)
    minCorner.Parent = minButton

    -- Kapatma Butonu
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -28, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 12
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim2.new(0, 6)
    closeCorner.Parent = closeButton

    -- İçerik Konteynırı (Küçülünce gizlenecek kısım)
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -35)
    contentFrame.Position = UDim2.new(0, 0, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- Uçma (Fly) Toggle Butonu
    local flyButton = Instance.new("TextButton")
    flyButton.Size = UDim2.new(0.9, 0, 0, 40)
    flyButton.Position = UDim2.new(0.05, 0, 0.1, 0)
    flyButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    flyButton.Text = "Uçma Modu: KAPALI"
    flyButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    flyButton.TextSize = 14
    flyButton.Font = Enum.Font.GothamMedium
    flyButton.Parent = contentFrame

    local flyCorner = Instance.new("UICorner")
    flyCorner.CornerRadius = UDim2.new(0, 8)
    flyCorner.Parent = flyButton

    local flyStroke = Instance.new("UIStroke")
    flyStroke.Color = Color3.fromRGB(255, 100, 100)
    flyStroke.Thickness = 1
    flyStroke.Parent = flyButton

    -- Mantıksal Değişkenler
    local minimized = false
    local flying = false
    local bodyVel, bodyGyro

    -- Küçültme Fonksiyonu
    minButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            contentFrame.Visible = false
            mainFrame:TweenSize(UDim2.new(0, 260, 0, 35), "Out", "Quad", 0.2, true)
            minButton.Text = "+"
        else
            mainFrame:TweenSize(UDim2.new(0, 260, 0, 180), "Out", "Quad", 0.2, true)
            task.wait(0.1)
            contentFrame.Visible = true
            minButton.Text = "-"
        end
    end)

    -- Kapatma Fonksiyonu
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Temel Uçma Mantığı
    flyButton.MouseButton1Click:Connect(function()
        flying = not flying
        local character = localPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = character.HumanoidRootPart
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if flying then
            flyButton.Text = "Uçma Modu: AÇIK"
            flyButton.TextColor3 = Color3.fromRGB(100, 255, 100)
            flyStroke.Color = Color3.fromRGB(100, 255, 100)

            -- Karakterin fiziksel düşüşünü engelleme
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.Velocity = Vector3.zero
            bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bodyVel.Parent = hrp

            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            bodyGyro.CFrame = hrp.CFrame
            bodyGyro.Parent = hrp

            if humanoid then
                humanoid.PlatformStand = true -- Hareketsiz duruş efekti
            end
        else
            flyButton.Text = "Uçma Modu: KAPALI"
            flyButton.TextColor3 = Color3.fromRGB(255, 100, 100)
            flyStroke.Color = Color3.fromRGB(255, 100, 100)

            if bodyVel then bodyVel:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end)
end

createNeonUI()
