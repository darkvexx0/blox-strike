-- Yusufex Hub (Executor Versiyonu)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Eğer daha önceden açılmış bir YusufexHub varsa önce onu kapatalım (çift açılmayı önler)
if PlayerGui:FindFirstChild("YusufexHub") then
	PlayerGui.YusufexHub:Destroy()
end

-- 1. GUI OLUŞTURMA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YusufexHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame (Ana Pencere)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Pencereyi sürükleyebilme
MainFrame.Parent = ScreenGui

-- Köşe Yuvarlama
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Başlık
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleLabel.Text = "Yusufex Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel

-- Fly Butonu
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyButton"
FlyButton.Size = UDim2.new(0.8, 0, 0, 45)
FlyButton.Position = UDim2.new(0.1, 0, 0.45, 0)
FlyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Başlangıçta Kırmızı
FlyButton.Text = "Fly: KAPALI"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 18
FlyButton.Font = Enum.Font.SourceSansSemibold
FlyButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = FlyButton


-- 2. FLY (UÇMA) MANTIĞI
local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro
local renderSteppedConnection

local function startFlying()
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	
	-- Uçma için fizik nesneleri oluşturma
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = hrp
	
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
	bodyGyro.CFrame = hrp.CFrame
	bodyGyro.Parent = hrp

	-- Kamera yönüne göre hareket etme
	renderSteppedConnection = RunService.RenderStepped:Connect(function()
		if flying and hrp and hrp.Parent then
			local camera = workspace.CurrentCamera
			local moveVector = Vector3.zero
			
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveVector = moveVector + camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveVector = moveVector - camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveVector = moveVector - camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveVector = moveVector + camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveVector = moveVector + Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				moveVector = moveVector - Vector3.new(0, 1, 0)
			end
			
			bodyGyro.CFrame = camera.CFrame
			bodyVelocity.Velocity = moveVector.Magnitude > 0 and (moveVector.Unit * flySpeed) or Vector3.zero
		else
			stopFlying()
		end
	end)
end

function stopFlying()
	flying = false
	FlyButton.Text = "Fly: KAPALI"
	FlyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	if renderSteppedConnection then renderSteppedConnection:Disconnect() end
	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end
end

-- Butona Tıklandığında Tetiklenecek Olay
FlyButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		FlyButton.Text = "Fly: AÇIK"
		FlyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Yeşil
		startFlying()
	else
		stopFlying()
	end
end)
