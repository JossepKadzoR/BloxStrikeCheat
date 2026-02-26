local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

-- Usunięcie starego GUI jeśli istnieje
if game.CoreGui:FindFirstChild("PolarisV1") then
    game.CoreGui.PolarisV1:Destroy()
end

local Polaris = Instance.new("ScreenGui")
Polaris.Name = "PolarisV1"
Polaris.Parent = game.CoreGui
Polaris.ResetOnSpawn = false

-- Funkcja Draggable (Przesuwanie okna)
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

-- GUI Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.BorderSizePixel = 0
Main.Parent = Polaris
makeDraggable(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Sidebar
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 160, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
SideBar.Parent = Main
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)

local Logo = Instance.new("TextLabel")
Logo.Text = "POLARIS V1"
Logo.Size = UDim2.new(1, 0, 0, 60)
Logo.TextColor3 = Color3.fromRGB(0, 162, 255)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 22
Logo.BackgroundTransparency = 1
Logo.Parent = SideBar

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -170, 1, -20)
Container.Position = UDim2.new(0, 165, 0, 10)
Container.BackgroundTransparency = 1
Container.Parent = Main

-- Tab System
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
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamMedium
    Button.Parent = SideBar
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

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

-- Toggle Function
local function createToggle(name, parent, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.Parent = parent
    Instance.new("UIListLayout", Frame).Padding = UDim.new(0, 5) -- Aby elementy pod sobą nie nachodziły
    Instance.new("UICorner", Frame)

    local Inner = Instance.new("Frame")
    Inner.Size = UDim2.new(1, 0, 0, 50)
    Inner.BackgroundTransparency = 1
    Inner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = "  " .. name
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = "Left"
    Label.Parent = Inner

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 45, 0, 24)
    Btn.Position = UDim2.new(1, -55, 0.5, -12)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Btn.Text = ""
    Btn.Parent = Inner
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = UDim2.new(0, 3, 0.5, -9)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = Btn
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local on = false
    Btn.MouseButton1Click:Connect(function()
        on = not on
        Circle:TweenPosition(on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), "Out", "Quart", 0.2)
        Btn.BackgroundColor3 = on and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 50)
        callback(on)
    end)
end

-- Slider Function
local function createSlider(name, parent, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 65)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    SliderFrame.Parent = parent
    Instance.new("UICorner", SliderFrame)

    local Label = Instance.new("TextLabel")
    Label.Text = "  " .. name .. ": " .. default
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = "Left"
    Label.Parent = SliderFrame

    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(0.9, 0, 0, 6)
    SliderBack.Position = UDim2.new(0.05, 0, 0.7, 0)
    SliderBack.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    SliderBack.Parent = SliderFrame
    Instance.new("UICorner", SliderBack)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    Fill.Parent = SliderBack
    Instance.new("UICorner", Fill)

    local function update()
        local mousePos = UserInputService:GetMouseLocation().X
        local framePos = SliderBack.AbsolutePosition.X
        local frameSize = SliderBack.AbsoluteSize.X
        local percentage = math.clamp((mousePos - framePos) / frameSize, 0, 1)
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        local val = math.floor(min + (max - min) * percentage)
        Label.Text = "  " .. name .. ": " .. val
        callback(val)
    end

    local dragging = false
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update() end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update() end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- LOGIKA MOVEMENT
local speedActive = false
local walkSpeedValue = 50

createToggle("Speed Hack", MoveTab, function(state)
    speedActive = state
end)

createSlider("Moc Szybkości", MoveTab, 16, 300, 50, function(val)
    walkSpeedValue = val
end)

-- Pętla "Brute Force" na szybkość - działa nawet jeśli gra próbuje nas spowolnić
RunService.Stepped:Connect(function()
    if speedActive and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = walkSpeedValue
    end
end)

-- Startowa zakładka
AimTab.Visible = true
