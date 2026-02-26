local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

local Polaris = Instance.new("ScreenGui")
Polaris.Name = "PolarisV1"
Polaris.Parent = game.CoreGui
Polaris.ResetOnSpawn = false

-- Funkcja do przesuwania okna
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

-- GŁÓWNY PANEL
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.BorderSizePixel = 0
Main.Parent = Polaris
makeDraggable(Main)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

-- BOCZNY PASEK (SIDEBAR)
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 160, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
SideBar.BorderSizePixel = 0
SideBar.Parent = Main

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 10)
SideCorner.Parent = SideBar

local Logo = Instance.new("TextLabel")
Logo.Text = "POLARIS V1"
Logo.Size = UDim2.new(1, 0, 0, 60)
Logo.TextColor3 = Color3.fromRGB(0, 162, 255)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 24
Logo.BackgroundTransparency = 1
Logo.Parent = SideBar

-- KONTENER NA ZAKŁADKI
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -170, 1, -20)
Container.Position = UDim2.new(0, 165, 0, 10)
Container.BackgroundTransparency = 1
Container.Parent = Main

local function createTab(name, pos)
    local Tab = Instance.new("ScrollingFrame")
    Tab.Size = UDim2.new(1, 0, 1, 0)
    Tab.BackgroundTransparency = 1
    Tab.Visible = false
    Tab.ScrollBarThickness = 0
    Tab.Parent = Container
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.Position = UDim2.new(0.05, 0, 0, 70 + (pos * 50))
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamMedium
    Button.Text = name
    Button.Parent = SideBar
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        Tab.Visible = true
        for _, v in pairs(SideBar:GetChildren()) do 
            if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(30, 30, 35) end 
        end
        Button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end)
    
    return Tab
end

local AimTab = createTab("Aim", 0)
local MoveTab = createTab("Movement", 1)
local VisTab = createTab("Visuals", 2)

-- FUNKCJA TWORZENIA PRZEŁĄCZNIKÓW (Jak na foto)
local function createToggle(name, parent, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.Parent = parent
    
    local UIC = Instance.new("UICorner")
    UIC.CornerRadius = UDim.new(0, 8)
    UIC.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = "  " .. name
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local TglBtn = Instance.new("TextButton")
    TglBtn.Size = UDim2.new(0, 45, 0, 24)
    TglBtn.Position = UDim2.new(1, -55, 0.5, -12)
    TglBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    TglBtn.Text = ""
    TglBtn.Parent = Frame
    
    local TglCorner = Instance.new("UICorner")
    TglCorner.CornerRadius = UDim.new(1, 0)
    TglCorner.Parent = TglBtn

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = UDim2.new(0, 3, 0.5, -9)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = TglBtn
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local enabled = false
    TglBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Circle:TweenPosition(enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), "Out", "Quart", 0.3)
        TglBtn.BackgroundColor3 = enabled and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 50)
        callback(enabled)
    end)
end

-- AIMBOT LOGIC
local aimActive = false
createToggle("Aimbot (Head)", AimTab, function(state)
    aimActive = state
end)

RunService.RenderStepped:Connect(function()
    if aimActive then
        local target = nil
        local shortestDist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local dist = (Vector2.new(Player:GetMouse().X, Player:GetMouse().Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < shortestDist then
                        target = v; shortestDist = dist
                    end
                end
            end
        end
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- SPEEDHACK LOGIC (Suwak tekstowy jak na foto)
local speedValue = 16
createToggle("Speed Hack", MoveTab, function(state)
    _G.SpeedEnabled = state
    if not state then Player.Character.Humanoid.WalkSpeed = 16 end
end)

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, -10, 0, 40)
SpeedBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SpeedBox.Text = "Szybkość: 50"
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Parent = MoveTab
Instance.new("UICorner", SpeedBox)

SpeedBox.FocusLost:Connect(function()
    speedValue = tonumber(SpeedBox.Text) or 16
    SpeedBox.Text = "Szybkość: " .. speedValue
end)

RunService.Stepped:Connect(function()
    if _G.SpeedEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = speedValue
    end
end)

-- ODPALENIE PIERWSZEJ ZAKŁADKI
AimTab.Visible = true
