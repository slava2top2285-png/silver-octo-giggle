-- Содержимое файла loader.lua:

return function()
    print("🔥 SILVER MOD loaded!")
    
    -- Создаем простой GUI
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SILVER_MOD"
    ScreenGui.Parent = PlayerGui
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 350, 0, 400)
    Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "SILVER MOD v1.0"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = Frame
    
    local Status = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 40)
    Title.Text = "Status: ✅ Activated"
    Title.TextColor3 = Color3.fromRGB(0, 255, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.Gotham
    Title.TextSize = 14
    Title.Parent = Frame
    
    print("✅ SILVER MOD successfully loaded!")
end
