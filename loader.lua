-- Редактируй loader.lua (нажми на файл → Edit this file)
-- Добавь этот расширенный код:

return function()
    print("🔥 SILVER MOD loaded!")
    
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    local TweenService = game:GetService("TweenService")
    
    -- Удаляем старый GUI
    if PlayerGui:FindFirstChild("SILVER_MOD") then
        PlayerGui.SILVER_MOD:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SILVER_MOD"
    ScreenGui.Parent = PlayerGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 400)
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "SILVER MOD v1.0"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
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
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = ButtonContainer
    
    -- Функция создания кнопки
    local function CreateButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.Text = text
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 14
        Button.Parent = ButtonContainer
        
        Button.MouseButton1Click:Connect(callback)
        return Button
    end
    
    -- Добавляем кнопки
    CreateButton("💰 Авто-Фарм", function()
        print("Авто-фарм активирован!")
    end)
    
    CreateButton("👻 NoClip", function()
        print("NoClip переключен!")
    end)
    
    CreateButton("⚡ ESP", function()
        print("ESP активирован!")
    end)
    
    CreateButton("🚀 Fly", function()
        print("Полёт активирован!")
    end)
    
    print("✅ SILVER MOD successfully loaded!")
end
