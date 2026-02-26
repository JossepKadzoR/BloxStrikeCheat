
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Usuwanie starych wersji
if game.CoreGui:FindFirstChild("PolarisV1") then game.CoreGui.PolarisV1:Destroy() end

local Polaris = Instance.new("ScreenGui")
Polaris.Name = "PolarisV1"
Polaris.Parent = game.CoreGui

-- Draggable
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- MAIN GUI (JEDNA LISTA)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 450)
Main.Position = UDim2.new(0.5, -200, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.Parent = Polaris
makeDraggable(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TopBar.Parent = Main
Instance.new("UICorner", TopBar)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Text = "POLARIS V1.9"; Title.TextColor3 = Color3.fromRGB(0, 162, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 20; Title.Parent = TopBar

-- SCROLL LIST (Tu jest wszystko)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 55)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.Parent = Main
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8); Layout.HorizontalAlignment = "Center"

-- ZMIENNE
_G.AimOn = false
_G.EspOn = false
_G.HitBoxOn = false
_G.SpeedOn = false
_G.TeamCheck = false

-- UI TOGGLE FUNCTION
local function createToggle(name, callback)
    local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 27); Frame.Parent = Scroll; Instance.new("UICorner", Frame)
    local Label = Instance.new("TextLabel"); Label.Text = "  " .. name; Label.Size = UDim2.new(1, 0, 1, 0); Label.TextColor3 = Color3.fromRGB(200, 200, 200); Label.BackgroundTransparency = 1; Label.TextXAlignment = "Left"; Label.Parent = Frame
    local Btn = Instance.new("TextButton"); Btn.Size = UDim2.new(0, 45, 0, 22); Btn.Position = UDim2.new(1, -55, 0.5, -11); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Btn.Text = ""; Btn.Parent = Frame; Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
    local Circle = Instance.new("Frame"); Circle.Size = UDim2.new(0, 18, 0, 18); Circle.Position = UDim2.new(0, 2, 0.5, -9); Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Circle.Parent = Btn; Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    local on = false
    Btn.MouseButton1Click:Connect(function()
        on = not on; Circle:TweenPosition(on and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9), "Out", "Quart", 0.2); Btn.BackgroundColor3 = on and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 50); callback(on)
    end)
end

-- DODAWANIE FUNKCJI
createToggle("AIMBOT (Head Lock)", function(s) _G.AimOn = s end)
createToggle("ESP (Wallhack)", function(s) _G.EspOn = s end)
createToggle("HITBOX EXPANDER (Big Head)", function(s) _G.HitBoxOn = s end)
createToggle("STEALTH SPEED (MoveBoost)", function(s) _G.SpeedOn = s end)
createToggle("TEAM CHECK (Ignore Friends)", function(s) _G.TeamCheck = s end)

-- SILNIK CHEATA
RunService.RenderStepped:Connect(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character then
            local char = v.Character
            local isEnemy = not (_G.TeamCheck and v.Team == Player.Team)

            -- HitBox Logic
            if _G.HitBoxOn and isEnemy and char:FindFirstChild("Head") then
                char.Head.Size = Vector3.new(4, 4, 4)
                char.Head.Transparency = 0.5
                char.Head.CanCollide = false
            elseif char:FindFirstChild("Head") then
                char.Head.Size = Vector3.new(1, 1, 1)
                char.Head.Transparency = 0
            end

            -- ESP Logic (Highlight)
            if _G.EspOn and isEnemy then
                if not char:FindFirstChild("PolHighlight") then
                    local h = Instance.new("Highlight", char); h.Name = "PolHighlight"; h.FillColor = Color3.fromRGB(255, 0, 0); h.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            else
                if char:FindFirstChild("PolHighlight") then char.PolHighlight:Destroy() end
            end
        end
    end

    -- AimBot Logic
    if _G.AimOn then
        local target = nil
        local dist = 500 -- Zasięg AimBota
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("Head") then
                if _G.TeamCheck and p.Team == Player.Team then continue end
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local mDist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mDist < dist then target = p; dist = mDist end
                end
            end
        end
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end

    -- Speed Logic
    if _G.SpeedOn and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        if hum.MoveDirection.Magnitude > 0 then
            Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * 0.3)
        end
    end
end)
