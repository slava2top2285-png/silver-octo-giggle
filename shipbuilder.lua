local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Удаляем старый GUI
if PlayerGui:FindFirstChild("ShipBuilderGUI") then
    PlayerGui.ShipBuilderGUI:Destroy()
end

-- Переменные для управления
local currentShip = nil
local shipVelocity = nil
local moveConnection = nil
local noclipping = false
local guiVisible = true

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShipBuilderGUI"
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Заголовок с кнопкой закрытия
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "XENO SHIP BUILDER"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Кнопка скрытия/показа
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -35, 0, 5)
ToggleButton.Text = "−"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ToggleButton.BorderSizePixel = 0
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.Parent = TitleBar

local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Size = UDim2.new(1, -20, 1, -60)
ButtonContainer.Position = UDim2.new(0, 10, 0, 50)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.ScrollBarThickness = 3
ButtonContainer.Visible = true
ButtonContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ButtonContainer

-- Функция скрытия/показа GUI
local function toggleGUI()
    guiVisible = not guiVisible
    if guiVisible then
        TweenService:Create(ButtonContainer, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 1, -60)}):Play()
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 400, 0, 500)}):Play()
        ToggleButton.Text = "−"
    else
        TweenService:Create(ButtonContainer, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, 0)}):Play()
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 400, 0, 40)}):Play()
        ToggleButton.Text = "+"
    end
end

ToggleButton.MouseButton1Click:Connect(toggleGUI)

-- Функция создания кнопки
local function CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.Text = text
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.Parent = ButtonContainer
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- Функции для ноуклипа
local function enableNoclip(ship)
    if not ship then return end
    for _, part in pairs(ship:GetChildren()) do
        if part:IsA("Part") then
            part.CanCollide = false
            part.Massless = true
        end
    end
    noclipping = true
end

local function disableNoclip(ship)
    if not ship then return end
    for _, part in pairs(ship:GetChildren()) do
        if part:IsA("Part") then
            part.CanCollide = true
            part.Massless = false
        end
    end
    noclipping = false
end

-- Функции для движения корабля
local function enableShipMovement(ship)
    if not ship then return end
    
    local mainPart = ship:FindFirstChild("Hull")
    if not mainPart then return end
    
    -- Отключаем анкор чтобы корабль не был статичным
    mainPart.Anchored = false
    
    -- Создаем BodyVelocity для движения
    shipVelocity = Instance.new("BodyVelocity")
    shipVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    shipVelocity.Velocity = Vector3.new(0, 0, 0)
    shipVelocity.Parent = mainPart
    
    -- Включаем ноуклип
    enableNoclip(ship)
    
    -- Управление движением
    if moveConnection then
        moveConnection:Disconnect()
    end
    
    moveConnection = RunService.Heartbeat:Connect(function()
        if not ship.Parent or not mainPart.Parent then
            disableMovement()
            return
        end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- Управление WASD + Space/Shift
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + mainPart.CFrame.lookVector * 30
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - mainPart.CFrame.lookVector * 30
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - mainPart.CFrame.rightVector * 30
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + mainPart.CFrame.rightVector * 30
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 30, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 30, 0)
        end
        
        shipVelocity.Velocity = moveDirection
    end)
end

local function disableMovement()
    if moveConnection then
        moveConnection:Disconnect()
        moveConnection = nil
    end
    if shipVelocity then
        shipVelocity:Destroy()
        shipVelocity = nil
    end
    if currentShip then
        disableNoclip(currentShip)
    end
end

-- Функции строительства
local function buildBasicShip()
    disableMovement()
    if currentShip then
        currentShip:Destroy()
    end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    currentShip = Instance.new("Model")
    currentShip.Name = "PlayerShip"
    
    -- Позиция перед игроком
    local offset = humanoidRootPart.CFrame.lookVector * 15
    local position = humanoidRootPart.Position + offset + Vector3.new(0, 5, 0)
    
    -- Корпус (НЕ анкоренный изначально)
    local hull = Instance.new("Part")
    hull.Name = "Hull"
    hull.Size = Vector3.new(25, 6, 12)
    hull.Position = position
    hull.Anchored = false  -- НЕ статичный!
    hull.BrickColor = BrickColor.new("Dark stone grey")
    hull.Material = Enum.Material.Neon
    hull.CanCollide = true
    hull.Parent = currentShip
    
    -- Кабина
    local cockpit = Instance.new("Part")
    cockpit.Name = "Cockpit" 
    cockpit.Size = Vector3.new(8, 5, 6)
    cockpit.Position = hull.Position + Vector3.new(0, 6, 6)
    cockpit.Anchored = false  -- НЕ статичный!
    cockpit.BrickColor = BrickColor.new("Bright blue")
    cockpit.Transparency = 0.3
    cockpit.Material = Enum.Material.Glass
    cockpit.CanCollide = true
    cockpit.Parent = currentShip
    
    -- Двигатели
    for i = -1, 1, 2 do
        local engine = Instance.new("Part")
        engine.Name = "Engine_" .. i
        engine.Size = Vector3.new(5, 5, 10)
        engine.Position = hull.Position + Vector3.new(i * 10, 0, -14)
        engine.Anchored = false  -- НЕ статичный!
        engine.BrickColor = BrickColor.new("Really red")
        engine.Material = Enum.Material.Neon
        engine.CanCollide = true
        engine.Parent = currentShip
        
        local fire = Instance.new("Fire")
        fire.Size = 10
        fire.Heat = 20
        fire.Color = Color3.new(1, 0, 0)
        fire.SecondaryColor = Color3.new(1, 1, 0)
        fire.Parent = engine
    end
    
    currentShip.Parent = workspace
    autoWeld() -- Автоматически свариваем детали
end

local function autoWeld()
    if not currentShip then return end
    
    local mainPart = currentShip:FindFirstChild("Hull")
    if mainPart then
        for _, part in pairs(currentShip:GetChildren()) do
            if part:IsA("Part") and part ~= mainPart then
                local weld = Instance.new("Weld")
                weld.Part0 = mainPart
                weld.Part1 = part
                weld.C0 = mainPart.CFrame:ToObjectSpace(part.CFrame)
                weld.Parent = mainPart
            end
        end
    end
end

local function clearShip()
    disableMovement()
    if currentShip then
        currentShip:Destroy()
        currentShip = nil
    end
end

-- Создаем кнопки
CreateButton("🚢 Построить базовый корабль", buildBasicShip)
CreateButton("🔗 Пересварить детали", autoWeld)
CreateButton("🚀 Включить движение (WASD+Space+Shift)", function()
    if currentShip then
        enableShipMovement(currentShip)
    end
end)
CreateButton("🛑 Выключить движение", disableMovement)
CreateButton("👻 Вкл/Выкл NoClip", function()
    if currentShip then
        if noclipping then
            disableNoclip(currentShip)
        else
            enableNoclip(currentShip)
        end
    end
end)
CreateButton("🎨 Случайный цвет", function()
    if currentShip then
        for _, part in pairs(currentShip:GetChildren()) do
            if part:IsA("Part") then
                part.BrickColor = BrickColor.random()
            end
        end
    end
end)
CreateButton("🗑️ Удалить корабль", clearShip)
CreateButton("📁 Скрыть/Показать меню", toggleGUI)

print("✅ XENO SHIP BUILDER загружен!")
