
print("Polaris V1.7: Optymalizacja pod Anty-Cheat...")

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

-- UI MAIN
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 380)
Main.Position = UDim2.new(0.5, -260, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.Parent = Polaris
makeDraggable(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Text = "POLARIS V1.7 STEALTH"; Title.TextColor3 = Color3.fromRGB(0, 162, 255); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 22; Title.Parent = TopBar

-- SIDEBAR & CONTAINER
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 130, 1, -50); SideBar.Position = UDim2.new(0, 0, 0, 50); SideBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22); SideBar.Parent = Main

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -145, 1, -65); Container.Position = UDim2.new(0, 140, 0, 55); Container.BackgroundTransparency = 1; Container.Parent = Main

-- ZMIENNE
local aimOn = false
local teamCheckOn = false
local speedBoostOn = false
local speedMult = 1.2 -- Mnożnik (bezpieczny)
local flyJumpOn = false

-- TAB SYSTEM
local function createTab(name, pos)
    local Tab = Instance.new("ScrollingFrame")
    Tab.Size = UDim2.new(1, 0, 1, 0); Tab.BackgroundTransparency = 1; Tab.Visible = (pos == 0); Tab.ScrollBarThickness = 0; Tab.Parent = Container
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 38); Button.Position = UDim2.new(0.05, 0, 0, 15 + (pos * 45)); Button.BackgroundColor3 = (pos == 0) and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(25, 25, 30); Button.Text = name; Button.TextColor3 = Color3.fromRGB(255, 255, 255); Button.Font = Enum.Font.GothamBold; Button.Parent = SideBar
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    Button.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        for _, v in pairs(SideBar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(25, 25, 30) end end
        Tab.Visible = true; Button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end)
    Instance.new("UIListLayout", Tab).Padding = UDim.new(0, 10)
    return Tab
end

local AimTab = createTab("Aim", 0)
local MoveTab = createTab("Movement", 1)
local OthersTab = createTab("Others", 2)

-- UI HELPERS
local function createToggle(name, parent, callback)
    local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, -10, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 27); Frame.Parent = parent; Instance.new("UICorner", Frame)
    local Label = Instance.new("TextLabel"); Label.Text = "  " .. name; Label.Size = UDim2.new(1, 0, 1, 0); Label.TextColor3 = Color3.fromRGB(200, 200, 200); Label.BackgroundTransparency = 1; Label.TextXAlignment = "Left"; Label.Parent = Frame
    local Btn = Instance.new("TextButton"); Btn.Size = UDim2.new(0, 40, 0, 20); Btn.Position = UDim2.new(1, -50, 0.5, -10); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Btn.Text = ""; Btn.Parent = Frame; Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
    local Circle = Instance.new("Frame"); Circle.Size = UDim2.new(0, 16, 0, 16); Circle.Position = UDim2.new(0, 2, 0.5, -8); Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Circle.Parent = Btn; Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    local on = false
    Btn.MouseButton1Click:Connect(function()
        on = not on; Circle:TweenPosition(on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quart", 0.2); Btn.BackgroundColor3 = on and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 50); callback(on)
    end)
end

-- SETUP
createToggle("AimBot (Smooth Head)", AimTab, function(s) aimOn = s end)
createToggle("Stealth Speed (Popychanie)", MoveTab, function(s) speedBoostOn = s end)
createToggle("Small FlyJump (1m)", MoveTab, function(s) flyJumpOn = s end)
createToggle("Team Check", OthersTab, function(s) teamCheckOn = s end)

-- AIMBOT (SMOOTH - trudniejszy do wykrycia)
local function getClosestPlayer()
    local target, dist = nil, math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
            if teamCheckOn and v.Team == Player.Team then continue end
            local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Player:GetMouse().X, Player:GetMouse().Y)).Magnitude
                if mDist < dist then target = v; dist = mDist end
            end
        end
    end
    return target
end

-- ENGINE
RunService.RenderStepped:Connect(function()
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
    
    -- Smooth Aim
    if aimOn then
        local t = getClosestPlayer()
        if t then
            local targetPos = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetPos, 0.1) -- 0.1 to wygładzenie celowania
        end
    end
    
    -- Stealth Speed (Nie zmienia WalkSpeed, więc Anty-Cheat rzadziej widzi)
    if speedBoostOn and root and hum and hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + (hum.MoveDirection * 0.25)
    end
    
    -- FlyJump (Bardzo niski skok)
    if flyJumpOn and hum then
        if hum.FloorMaterial ~= Enum.Material.Air then
            root.Velocity = Vector3.new(root.Velocity.X, 25, root.Velocity.Z) -- Skok przez velocity jest bezpieczniejszy
        end
    end
end)
