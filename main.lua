
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Sprzątanie
if game.CoreGui:FindFirstChild("PolarisV1") then game.CoreGui.PolarisV1:Destroy() end

local Polaris = Instance.new("ScreenGui")
Polaris.Name = "PolarisV1"
Polaris.Parent = game.CoreGui

-- Draggable Function
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

-- MAIN GUI
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 400)
Main.Position = UDim2.new(0.5, -260, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.Parent = Polaris
makeDraggable(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Text = "POLARIS V1.8.5"; Title.TextColor3 = Color3.fromRGB(0, 162, 255); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 22; Title.Parent = TopBar

-- SIDEBAR (Z automatycznym układem)
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 130, 1, -50); SideBar.Position = UDim2.new(0, 0, 0, 50); SideBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22); SideBar.Parent = Main
local SideLayout = Instance.new("UIListLayout", SideBar)
SideLayout.Padding = UDim.new(0, 5); SideLayout.HorizontalAlignment = "Center"; SideLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- CONTAINER
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -145, 1, -65); Container.Position = UDim2.new(0, 140, 0, 55); Container.BackgroundTransparency = 1; Container.Parent = Main

-- ZMIENNE
_G.AimOn = false
_G.EspOn = false
_G.HitBoxOn = false
_G.TeamCheck = false
_G.SpeedOn = false

-- TAB SYSTEM
local function createTab(name, order)
    local Tab = Instance.new("ScrollingFrame")
    Tab.Size = UDim2.new(1, 0, 1, 0); Tab.BackgroundTransparency = 1; Tab.Visible = (order == 1); Tab.ScrollBarThickness = 0; Tab.Parent = Container
    Instance.new("UIListLayout", Tab).Padding = UDim.new(0, 10)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 35); Button.LayoutOrder = order; Button.BackgroundColor3 = (order == 1) and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(25, 25, 30); Button.Text = name; Button.TextColor3 = Color3.fromRGB(255, 255, 255); Button.Font = Enum.Font.GothamBold; Button.Parent = SideBar
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

    Button.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(SideBar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(25, 25, 30) end end
        Tab.Visible = true; Button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end)
    return Tab
end

local AimTab = createTab("Aim", 1)
local VisTab = createTab("Visuals", 2)
local MoveTab = createTab("Movement", 3)
local OthersTab = createTab("Others", 4)

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

-- CONFIGURATION
createToggle("AimBot (Auto Lock)", AimTab, function(s) _G.AimOn = s end)
createToggle("ESP Highlight (Enemy)", VisTab, function(s) _G.EspOn = s end)
createToggle("HitBox Expander", VisTab, function(s) _G.HitBoxOn = s end)
createToggle("Stealth Speed", MoveTab, function(s) _G.SpeedOn = s end)
createToggle("Team Check", OthersTab, function(s) _G.TeamCheck = s end)

-- MAIN LOGIC
RunService.RenderStepped:Connect(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character then
            local char = v.Character
            local isEnemy = not (_G.TeamCheck and v.Team == Player.Team)

            -- HitBox
            if _G.HitBoxOn and isEnemy and char:FindFirstChild("Head") then
                char.Head.Size = Vector3.new(3.5, 3.5, 3.5)
                char.Head.Transparency = 0.6
                char.Head.CanCollide = false
            elseif char:FindFirstChild("Head") then
                char.Head.Size = Vector3.new(1, 1, 1)
                char.Head.Transparency = 0
            end

            -- ESP Highlight
            if _G.EspOn and isEnemy then
                if not char:FindFirstChild("PolarisHighlight") then
                    local h = Instance.new("Highlight", char)
                    h.Name = "PolarisHighlight"; h.FillColor = Color3.fromRGB(255, 0, 0); h.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            else
                if char:FindFirstChild("PolarisHighlight") then char.PolarisHighlight:Destroy() end
            end
        end
    end

    -- AimBot
    if _G.AimOn then
        local target = nil
        local dist = math.huge
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

    -- Speed
    if _G.SpeedOn and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        if hum.MoveDirection.Magnitude > 0 then
            Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * 0.35)
        end
    end
end)
