local LPH_NO_VIRTUALIZE = function(...) return ... end

local Polaris = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local SideBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ContentFrame = Instance.new("Frame")
local TabButtons = Instance.new("Frame")

-- System Przesuwania (Dragging)
local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

-- GUI Setup
Polaris.Name = "PolarisCheat"
Polaris.Parent = game.CoreGui
Polaris.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = Polaris
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.ClipsDescendants = true
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

makeDraggable(MainFrame)

-- Panel Logowania (Widoczny na początku)
local LoginFrame = Instance.new("Frame")
LoginFrame.Size = UDim2.new(1, 0, 1, 0)
LoginFrame.BackgroundTransparency = 1
LoginFrame.Parent = MainFrame

local LoginTitle = Instance.new("TextLabel")
LoginTitle.Text = "Polaris - Zaloguj się"
LoginTitle.Size = UDim2.new(1, 0, 0, 50)
LoginTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginTitle.Font = Enum.Font.GothamBold
LoginTitle.BackgroundTransparency = 1
LoginTitle.Parent = LoginFrame

local CodeInput = Instance.new("TextBox")
CodeInput.PlaceholderText = "KOD: 123"
CodeInput.Size = UDim2.new(0, 200, 0, 40)
CodeInput.Position = UDim2.new(0.5, -100, 0.4, 0)
CodeInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CodeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CodeInput.Parent = LoginFrame

local LoginBtn = Instance.new("TextButton")
LoginBtn.Text = "WEJDŹ"
LoginBtn.Size = UDim2.new(0, 200, 0, 40)
LoginBtn.Position = UDim2.new(0.5, -100, 0.6, 0)
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginBtn.Parent = LoginFrame

-- Główne Menu (Ukryte na start)
local MainContent = Instance.new("Frame")
MainContent.Size = UDim2.new(1, 0, 1, 0)
MainContent.BackgroundTransparency = 1
MainContent.Visible = false
MainContent.Parent = MainFrame

SideBar.Size = UDim2.new(0, 120, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SideBar.Parent = MainContent

Title.Text = "POLARIS"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(0, 120, 255)
Title.Font = Enum.Font.GothamBlack
Title.BackgroundTransparency = 1
Title.Parent = SideBar

-- Funkcje nawigacji
local Pages = {
	Aim = Instance.new("Frame"),
	Movement = Instance.new("Frame"),
	Visuals = Instance.new("Frame")
}

for name, frame in pairs(Pages) do
	frame.Size = UDim2.new(0, 380, 1, 0)
	frame.Position = UDim2.new(0, 120, 0, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Parent = MainContent
	
	local btn = Instance.new("TextButton")
	btn.Text = name
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, 50 + (table.find({"Aim", "Movement", "Visuals"}, name)-1)*45)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.Parent = SideBar
	
	btn.MouseButton1Click:Connect(function()
		for _, p in pairs(Pages) do p.Visible = false end
		frame.Visible = true
	end)
end

-- ELEMENTY ZAKŁADEK
-- Aim:
local AimBtn = Instance.new("TextButton")
AimBtn.Text = "Włącz AimBot (Głowa)"
AimBtn.Size = UDim2.new(0, 200, 0, 40)
AimBtn.Position = UDim2.new(0.5, -100, 0.2, 0)
AimBtn.Parent = Pages.Aim

-- Movement (SpeedHack Slider):
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Text = "Speed: 16"
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Parent = Pages.Movement

local SpeedSlider = Instance.new("TextBox")
SpeedSlider.PlaceholderText = "Wpisz szybkość (np. 50)"
SpeedSlider.Size = UDim2.new(0, 200, 0, 30)
SpeedSlider.Position = UDim2.new(0.5, -100, 0.4, 0)
SpeedSlider.Parent = Pages.Movement

-- LOGIKA DZIAŁANIA
LoginBtn.MouseButton1Click:Connect(function()
	if CodeInput.Text == "123" then
		LoginFrame.Visible = false
		MainContent.Visible = true
		Pages.Aim.Visible = true
	end
end)

-- Funkcja SpeedHacka
SpeedSlider.FocusLost:Connect(function()
	local val = tonumber(SpeedSlider.Text)
	if val then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
		SpeedLabel.Text = "Speed: " .. val
	end
end)

-- Funkcja AimBota
local aimOn = false
AimBtn.MouseButton1Click:Connect(function()
	aimOn = not aimOn
	AimBtn.Text = aimOn and "AimBot: ON" or "AimBot: OFF"
	AimBtn.BackgroundColor3 = aimOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if aimOn then
		local target = nil
		local dist = math.huge
		for _, v in pairs(game.Players:GetPlayers()) do
			if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
				local pos, vis = game.Workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
				if vis then
					local mDist = (Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y) - Vector2.new(pos.X, pos.Y)).Magnitude
					if mDist < dist then
						target = v
						dist = mDist
					end
				end
			end
		end
		if target then
			game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
		end
	end
end)
