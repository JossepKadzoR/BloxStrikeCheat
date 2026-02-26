-- KONFIGURACJA GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local CodeInput = Instance.new("TextBox")
local LoginBtn = Instance.new("TextButton")

-- Ustawienia wyglądu (Zaokrąglone rogi i kolory)
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

Title.Parent = MainFrame
Title.Text = "Weryfikacja"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

CodeInput.Parent = MainFrame
CodeInput.PlaceholderText = "Wpisz kod..."
CodeInput.Size = UDim2.new(0.8, 0, 0, 30)
CodeInput.Position = UDim2.new(0.1, 0, 0.4, 0)
CodeInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CodeInput.TextColor3 = Color3.fromRGB(255, 255, 255)

LoginBtn.Parent = MainFrame
LoginBtn.Text = "Zaloguj"
LoginBtn.Size = UDim2.new(0.8, 0, 0, 30)
LoginBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- FUNKCJA AIMBOTA (Uproszczona)
local function StartAimbot()
    local Player = game.Players.LocalPlayer
    local Mouse = Player:GetMouse()
    local RunService = game:GetService("RunService")

    RunService.RenderStepped:Connect(function()
        local closestPlayer = nil
        local shortestDistance = math.huge

        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local pos = v.Character.Head.Position
                local screenPos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(pos)
                if onScreen then
                    local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if distance < shortestDistance then
                        closestPlayer = v
                        shortestDistance = distance
                    end
                end
            end
        end

        if closestPlayer then
            game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.Head.Position)
        end
    end)
end

-- LOGIKA LOGOWANIA
LoginBtn.MouseButton1Click:Connect(function()
    if CodeInput.Text == "123" then
        -- Usuwamy panel logowania i tworzymy panel skryptu
        Title.Text = "Menu Skryptu"
        CodeInput:Destroy()
        LoginBtn.Text = "Włącz AimBot"
        
        LoginBtn.MouseButton1Click:Connect(function()
            LoginBtn.Text = "AimBot AKTYWNY"
            LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            StartAimbot()
        end)
    else
        CodeInput.Text = ""
        CodeInput.PlaceholderText = "BŁĘDNY KOD!"
    end
end)
