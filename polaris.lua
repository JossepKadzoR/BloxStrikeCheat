
-- [[ POLARIS V2.7 - DIRECT EXECUTION ]]
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CAŁKOWITE CZYSZCZENIE GUI (ZABIJA WSZYSTKO CO BYŁO WCZEŚNIEJ)
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name:find("Polaris") then v:Destroy() end
end

local Polaris = Instance.new("ScreenGui")
Polaris.Name = "Polaris_V27"
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

-- MAIN FRAME
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 380)
Main.Position = UDim2.new(0.5, -260, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.Parent = Polaris
makeDraggable(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50); TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30); TopBar.Parent = Main; Instance.new("UICorner", TopBar)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Text = "POLARIS V2.7 (NUCLEAR FIX)"; Title.TextColor3 = Color3.fromRGB(0, 162, 255); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 22; Title.Parent = TopBar

-- SIDEBAR & CONTAINER
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 130, 1, -50); SideBar.Position = UDim2.new(0, 0, 0, 50); SideBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22); SideBar.Parent = Main
local SideLayout = Instance.new("UIListLayout", SideBar); SideLayout.Padding = UDim.new(0, 5); SideLayout.HorizontalAlignment = "Center"

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -145, 1, -65); Container.Position = UDim2.new(0, 140, 0, 55); Container.BackgroundTransparency = 1; Container.Parent = Main

-- ZMIENNE
_G.AimOn = false
_G.EspOn = false
_G.HitBoxOn = false
_G.TeamCheck = false
_G.InvertLogic = false

-- TAB SYSTEM
local function createTab(name, isFirst)
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Size = UDim2.new(1, 0, 1, 0); TabFrame.BackgroundTransparency = 1; TabFrame.Visible = isFirst; TabFrame.ScrollBarThickness = 0; TabFrame.Parent = Container
    Instance.new("UIListLayout", TabFrame).Padding = UDim.new(0, 8)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.9, 0, 0, 38); TabBtn.BackgroundColor3 = isFirst and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(25, 25, 30); TabBtn.Text = name; TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255); TabBtn.Font = Enum.Font.GothamBold; TabBtn.Parent = SideBar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(SideBar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(25, 25, 30) end end
        TabFrame.Visible = true; TabBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    end)
    return TabFrame
end

local AimTab = createTab("Aim", true)
local VisTab = createTab("Visuals", false)
local OthersTab = createTab("Others", false)

-- TOGGLE
local function createToggle(name, parent, callback)
    local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, -5, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 27); Frame.Parent = parent; Instance.new("UICorner", Frame)
    local Label = Instance.new("TextLabel"); Label.Text = "  " .. name; Label.Size = UDim2.new(1, 0, 1, 0); Label.TextColor3 = Color3.fromRGB(200, 200, 200); Label.BackgroundTransparency = 1; Label.TextXAlignment = "Left"; Label.Parent = Frame
    local Btn = Instance.new("TextButton"); Btn.Size = UDim2.new(0, 40, 0, 20); Btn.Position = UDim2.new(1, -50, 0.5, -10); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Btn.Text = ""; Btn.Parent = Frame; Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
    local Circle = Instance.new("Frame"); Circle.Size = UDim2.new(0, 16, 0, 16); Circle.Position = UDim2.new(0, 2, 0.5, -8); Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Circle.Parent = Btn; Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    local on = false
    Btn.MouseButton1Click:Connect(function()
        on = not on; Circle:TweenPosition(on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quart", 0.2); Btn.BackgroundColor3 = on and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 50); callback(on)
    end)
end

createToggle("AimBot (Auto Lock)", AimTab, function(s) _G.AimOn = s end)
createToggle("ESP Highlight", VisTab, function(s) _G.EspOn = s end)
createToggle("HitBox Expander", VisTab, function(s) _G.HitBoxOn = s end)
createToggle("Team Check", OthersTab, function(s) _G.TeamCheck = s end)

-- FIX BUTTON
local FixBtn = Instance.new("TextButton", OthersTab)
FixBtn.Size = UDim2.new(1, -5, 0, 45); FixBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45); FixBtn.Text = "NAPRAW TEAMY (KLIKNIJ)"; FixBtn.TextColor3 = Color3.fromRGB(255, 255, 255); FixBtn.Font = Enum.Font.GothamBold; FixBtn.TextSize = 13
Instance.new("UICorner", FixBtn)
FixBtn.MouseButton1Click:Connect(function()
    _G.InvertLogic = not _G.InvertLogic
    FixBtn.Text = _G.InvertLogic and "TRYB: ODWRÓCONY" or "TRYB: NORMALNY"
    FixBtn.BackgroundColor3 = _G.InvertLogic and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(40, 40, 45)
end)

-- LOGIKA WROGA
local function isEnemy(v)
    if not _G.TeamCheck then return true end
    local same = (v.Team == Player.Team or v.TeamColor == Player.TeamColor)
    if _G.InvertLogic then return same end -- Jeśli odwrócone, traktuj "takich samych" jako wrogów
    return not same
end

-- LOOP
RunService.RenderStepped:Connect(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character then
            local enemy = isEnemy(v)
            if _G.EspOn and enemy then
                if not v.Character:FindFirstChild("PolH") then
                    local h = Instance.new("Highlight", v.Character); h.Name = "PolH"; h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            else
                if v.Character:FindFirstChild("PolH") then v.Character.PolH:Destroy() end
            end
            if _G.HitBoxOn and enemy and v.Character:FindFirstChild("Head") then
                v.Character.Head.Size = Vector3.new(4,4,4); v.Character.Head.Transparency = 0.5
            elseif v.Character:FindFirstChild("Head") then
                v.Character.Head.Size = Vector3.new(1,1,1); v.Character.Head.Transparency = 0
            end
        end
    end
    if _G.AimOn then
        local t = nil; local d = 600
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("Head") and isEnemy(p) then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if m < d then t = p; d = m end
                end
            end
        end
        if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position) end
    end
end)
