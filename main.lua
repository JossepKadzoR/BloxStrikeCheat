local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

-- Usuwanie starego GUI
if game.CoreGui:FindFirstChild("PolarisV1") then
    game.CoreGui.PolarisV1:Destroy()
end

local Polaris = Instance.new("ScreenGui")
Polaris.Name = "PolarisV1"
Polaris.Parent = game.CoreGui

-- Funkcja Draggable
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
Main.Size = UDim2.new(0, 550, 0, 380) -- Trochę wyższy żeby wszystko weszło
Main.Position = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.Parent = Polaris
makeDraggable(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Sidebar & Logo
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
    Tab.CanvasSize = UDim2.new(0, 0, 1.5, 0)
    Tab.ScrollBarThickness = 2
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
    end)
    return Tab
end

local AimTab = createTab("Aim", 0)
local MoveTab = createTab("Movement", 1)

-- Layout w zakładkach
local MoveLayout = Instance.new("UIListLayout", MoveTab)
MoveLayout.Padding = UDim.new(0, 10)

-- Toggle & Slider Builder
local function createToggle(name, parent, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.Parent = parent
    Instance.new("UICorner", Frame)

    local Label = Instance.new("TextLabel")
    Label.Text = "  " .. name
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = "Left"
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 45, 0, 24)
    Btn.Position = UDim2.new(1, -55, 0.5, -12)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Btn.Text = ""
    Btn.Parent = Frame
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

local function createSlider(name, parent, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 60)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.Parent = parent
    Instance.new("UICorner", Frame)

    local Label = Instance.new("TextLabel")
    Label.Text = "  " .. name .. ": " .. default
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = "Left"
    Label.Parent = Frame

    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(0.9, 0, 0, 6)
    SliderBack.Position = UDim2.new(0.05, 0, 0.7, 0)
    SliderBack.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    SliderBack.Parent = Frame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    Fill.Parent = SliderBack

    local dragging = false
    local function update()
        local mX = UserInputService:GetMouseLocation().X
        local per = math.clamp((mX - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(per, 0, 1, 0)
        local val = math.floor(min + (max-min)*per)
        Label.Text = "  " .. name .. ": " .. val
        callback(val)
    end
    SliderBack.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update() end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

-- LOGIKA MOVEMENT
local speedActive = false
local flyJumpActive = false
local walkSpeedValue = 50

createToggle("Speed Hack", MoveTab, function(s) speedActive = s end)
createSlider("Moc Szybkości", MoveTab, 16, 300, 50, function(v) walkSpeedValue = v end)

createToggle("FlyJump (Mega Jump)", MoveTab, function(s) 
    flyJumpActive = s 
end)

-- Pętla obsługująca Speed i FlyJump
RunService.Stepped:Connect(function()
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then
        -- Speed Logic
        if speedActive or flyJumpActive then
            char.Humanoid.WalkSpeed = flyJumpActive and 150 or walkSpeedValue
        end
        
        -- FlyJump Logic
        if flyJumpActive then
            char.Humanoid.JumpPower = 100 -- Wysokość skoku
            if char.Humanoid.FloorMaterial ~= Enum.Material.Air then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

AimTab.Visible = true
