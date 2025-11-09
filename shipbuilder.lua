-- Вставь этот код ВМЕСТО текущего в shipbuilder.lua:

print("🚢 SILVER SHIP BUILDER STARTED!")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Простой GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SHIP_BUILDER"
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Frame.Parent = ScreenGui

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 1, 0)
Label.Text = "SHIP BUILDER\nНажми F9 для консоли"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.BackgroundTransparency = 1
Label.Parent = Frame

print("✅ GUI создан! Проверь F9")

-- Функция постройки корабля
local function BuildShip()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local ship = Instance.new("Model")
    ship.Name = "TestShip"
    
    local position = humanoidRootPart.Position + Vector3.new(0, 10, 0)
    
    local part = Instance.new("Part")
    part.Size = Vector3.new(10, 10, 10)
    part.Position = position
    part.Anchored = true
    part.BrickColor = BrickColor.new("Bright red")
    part.Parent = ship
    
    ship.Parent = workspace
    print("✅ Простой корабль создан!")
end

BuildShip()
