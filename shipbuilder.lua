-- Файл: shipbuilder.lua
return function()
    print("🚢 SILVER SHIP BUILDER loaded!")
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local TweenService = game:GetService("TweenService")
    
    -- Удаляем старый GUI
    if PlayerGui:FindFirstChild("SHIP_BUILDER") then
        PlayerGui.SHIP_BUILDER:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SHIP_BUILDER"
    ScreenGui.Parent = PlayerGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "🚢 SILVER SHIP BUILDER"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = MainFrame
    
    local ButtonContainer = Instance.new("ScrollingFrame")
    ButtonContainer.Size = UDim2.new(1, -20, 1, -60)
    ButtonContainer.Position = UDim2.new(0, 10, 0, 50)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.ScrollBarThickness = 3
    ButtonContainer.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ButtonContainer
    
    local currentShip = nil
    
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
    
    -- Функция постройки корабля
    local function BuildBasicShip()
        if currentShip then
            currentShip:Destroy()
        end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        currentShip = Instance.new("Model")
        currentShip.Name = "SilverShip"
        
        -- Позиция перед игроком
        local offset = humanoidRootPart.CFrame.lookVector * 20
        local position = humanoidRootPart.Position + offset + Vector3.new(0, 5, 0)
        
        -- Корпус
        local hull = Instance.new("Part")
        hull.Name = "Hull"
        hull.Size = Vector3.new(25, 8, 12)
        hull.Position = position
        hull.Anchored = true
        hull.BrickColor = BrickColor.new("Dark stone grey")
        hull.Material = Enum.Material.Neon
        hull.Parent = currentShip
        
        -- Кабина
        local cockpit = Instance.new("Part")
        cockpit.Name = "Cockpit" 
        cockpit.Size = Vector3.new(10, 6, 8)
        cockpit.Position = hull.Position + Vector3.new(0, 8, 6)
        cockpit.Anchored = true
        cockpit.BrickColor = BrickColor.new("Bright blue")
        cockpit.Transparency = 0.4
        cockpit.Material = Enum.Material.Glass
        cockpit.Parent = currentShip
        
        -- Двигатели
        for i = -1, 1, 2 do
            local engine = Instance.new("Part")
            engine.Name = "Engine_" .. i
            engine.Size = Vector3.new(6, 6, 12)
            engine.Position = hull.Position + Vector3.new(i * 12, 0, -16)
            engine.Anchored = true
            engine.BrickColor = BrickColor.new("Really red")
            engine.Material = Enum.Material.Neon
            engine.Parent = currentShip
            
            local fire = Instance.new("Fire")
            fire.Size = 12
            fire.Heat = 25
            fire.Color = Color3.new(1, 0, 0)
            fire.SecondaryColor = Color3.new(1, 1, 0)
            fire.Parent = engine
        end
        
        -- Крылья
        for i = -1, 1, 2 do
            local wing = Instance.new("Part")
            wing.Name = "Wing_" .. i
            wing.Size = Vector3.new(18, 3, 10)
            wing.Position = hull.Position + Vector3.new(i * 20, 0, 0)
            wing.Anchored = true
            wing.BrickColor = BrickColor.new("Medium stone grey")
            wing.Material = Enum.Material.Neon
            wing.Parent = currentShip
        end
        
        currentShip.Parent = workspace
        print("✅ Корабль построен!")
    end
    
    -- Функция сварки деталей
    local function WeldShip()
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
            mainPart.Anchored = false
            print("✅ Детали сварены!")
        end
    end
    
    -- Функция удаления корабля
    local function ClearShip()
        if currentShip then
            currentShip:Destroy()
            currentShip = nil
            print("🗑️ Корабль удален!")
        end
    end
    
    -- Создаем кнопки
    CreateButton("🚢 Построить базовый корабль", BuildBasicShip)
    CreateButton("🔗 Сварить детали", WeldShip)
    CreateButton("👻 Включить NoClip", function()
        if currentShip then
            for _, part in pairs(currentShip:GetChildren()) do
                if part:IsA("Part") then
                    part.CanCollide = false
                end
            end
            print("👻 NoClip включен!")
        end
    end)
    CreateButton("🗑️ Удалить корабль", ClearShip)
    CreateButton("🎨 Случайный цвет", function()
        if currentShip then
            for _, part in pairs(currentShip:GetChildren()) do
                if part:IsA("Part") then
                    part.BrickColor = BrickColor.random()
                end
            end
        end
    end)
    
    print("✅ SILVER SHIP BUILDER готов к работе!")
end
