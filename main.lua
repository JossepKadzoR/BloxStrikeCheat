local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

-- Czyszczenie starych wersji
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

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.Parent = Polaris
makeDraggable(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- NAGŁÓWEK Z NAPISEM POLARIS
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1
Header.Text = "POLARIS V1"
Header.TextColor3 = Color3.fromRGB(0, 162, 255)
Header.Font = Enum.Font.GothamBlack
Header.TextSize = 20
Header.Parent = Main

-- Boczny pasek
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 140, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
SideBar.Parent = Main
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -150, 1, -50)
Container.Position = UDim2.new(0, 145, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = Main

-- Tab System
local function createTab(name, pos)
    local Tab = Instance.new("ScrollingFrame")
    Tab.Size = UDim2.new(1, 0, 1, 0)
    Tab.BackgroundTransparency = 1
    Tab.Visible = (pos == 0)
    Tab.ScrollBarThickness = 0
    Tab.Parent = Container
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.Position = UDim2.new(0.05, 0, 0, 10 + (pos * 40))
    Button.BackgroundColor3 = (pos == 0) and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(30, 30, 35)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.Parent = SideBar
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

    Button.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        for _, v in pairs(SideBar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(30, 30, 35) end end
        Tab.Visible = true
        Button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end)
    return Tab
end

local AimTab = createTab("Aim", 0)
local MoveTab = createTab("Movement", 1)

-- UI Elementy (Toggle & Slider)
local function createToggle(name, parent, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Frame.Parent = parent
    Instance.new("UICorner", Frame)
    local Label = Instance.new("TextLabel")
    Label.Text = "  " .. name; Label.Size = UDim2.new(1, 0, 1, 0); Label.TextColor3 = Color3.fromRGB(200, 200, 200); Label.BackgroundTransparency = 1; Label.TextXAlignment = "Left"; Label.Parent = Frame
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 40, 0, 20); Btn.Position = UDim2.new(1, -50, 0.5, -10); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Btn.Text = ""; Btn.Parent = Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16); Circle.Position = UDim2.new(0, 2, 0.5, -8); Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Circle.Parent = Btn
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    local on = false
    Btn.MouseButton1Click:Connect(function()
        on = not on
        Circle:TweenPosition(on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quart", 0.2)
        Btn.BackgroundColor3 = on and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 50)
        callback(on)
    end)
end

local function createSlider(name, parent, min, max, default, callback)
    local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, -10, 0, 55); Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Frame.Parent = parent
    Instance.new("UICorner", Frame)
    local Label = Instance.new("TextLabel"); Label.Text = "  " .. name .. ": " .. default; Label.Size = UDim2.new(1, 0, 0, 25); Label.TextColor3 = Color3.fromRGB(200, 200, 200); Label.BackgroundTransparency = 1; Label.TextXAlignment = "Left"; Label.Parent = Frame
    local SliderBack = Instance.new("Frame"); SliderBack.Size = UDim2.new(0.9, 0, 0, 4); SliderBack.Position = UDim2.new(0.05, 0, 0.7, 0); SliderBack.BackgroundColor3 = Color3.fromRGB(45, 45, 50); SliderBack.Parent = Frame
    local Fill = Instance.new("Frame"); Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 162, 255); Fill.Parent = SliderBack
    local dragging = false
    local function update()
        local mX = UserInputService:GetMouseLocation().X
        local per = math.clamp((mX - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(per, 0, 1, 0)
        local val = math.floor(min + (max-min)*per)
        Label.Text = "  " .. name .. ": " .. val; callback(val)
    end
    SliderBack.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update() end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

-- ZMIENNE I PĘTLA DZIAŁANIA
local speedOn = false
local speedVal = 16
local jumpOn = false

createToggle("Włącz SpeedHack", MoveTab, function(s) speedOn = s end)
createSlider("Szybkość", MoveTab, 16, 150, 16, function(v) speedVal = v end)
createToggle("FlyJump (1 metr)", MoveTab, function(s) jumpOn = s end)

-- GŁÓWNA PĘTLA - WYMUSZANIE
task.spawn(function()
    while task.wait() do
        pcall(function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                -- Obsługa Speed
                if speedOn then
                    char.Humanoid.WalkSpeed = speedVal
                else
                    char.Humanoid.WalkSpeed = 16
                end
                
                -- Obsługa Skoku (10 to bardzo mało, ok 1 metr)
                if jumpOn then
                    char.Humanoid.JumpPower = 10
                    if char.Humanoid.FloorMaterial ~= Enum.Material.Air then
                        char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                else
                    char.Humanoid.JumpPower = 50 -- Standard
                end
            end
        end)
    end
end)
