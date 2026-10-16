--// Blox Strike Basit Aimbot Test Scripti
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// 1. ARAYÜZ (GUI) OLUŞTURMA
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DenemeAimbotGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Fareyle sürüklenebilir
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Blox Strike - Test"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 160, 0, 40)
toggleButton.Position = UDim2.new(0.5, -80, 0.5, -5)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = "Deneme: KAPALI"
toggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleButton

--// 2. FOV ÇEMBERİ (Crosshair Etrafındaki Yuvarlak Çerçeve)
local fovRadius = 120 -- Çemberin büyüklüğü
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = fovRadius
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1.5
fovCircle.Filled = false
fovCircle.Transparency = 0.7

local aimbotEnabled = false

toggleButton.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	if aimbotEnabled then
		toggleButton.Text = "Deneme: AÇIK"
		toggleButton.TextColor3 = Color3.fromRGB(100, 255, 100)
		fovCircle.Visible = true
	else
		toggleButton.Text = "Deneme: KAPALI"
		toggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
		fovCircle.Visible = false
	end
end)

-- Ekranın tam orta noktasını (crosshair) bulma ve çemberi sabitleme
RunService.RenderStepped:Connect(function()
	local viewportSize = camera.ViewportSize
	local centerPosition = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
	
	fovCircle.Position = centerPosition

	if not aimbotEnabled then return end

	-- En yakın kafayı bulma mantığı
	local closestPlayer = nil
	local shortestDistance = fovRadius

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
			-- Takım kontrolü (Blox Strike'da kendi takımındakilere nişan almamak için - takım mantığına göre değişebilir)
			if player.Team ~= localPlayer.Team then
				local head = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
				if head then
					local screenPoint, onScreen = camera:WorldToViewportPoint(head.Position)
					if onScreen then
						local screenVector = Vector2.new(screenPoint.X, screenPoint.Y)
						local distance = (screenVector - centerPosition).Magnitude
						
						if distance < shortestDistance then
							shortestDistance = distance
							closestPlayer = head
						end
					end
				end
			end
		end
	end

	-- Eğer çember içine giren bir adam varsa kamerayı onun kafasına kilitle
	if closestPlayer then
		camera.CFrame = CFrame.new(camera.CFrame.Position, closestPlayer.Position)
	end
end)