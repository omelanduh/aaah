-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variables
local isLocked = false  -- Kamera kilit durumu
local lockedTarget = nil  -- Kilitlenen oyuncu
local isCheckBoxEnabled = false  -- Camlock tik durumu
local guiVisible = true -- GUI Açık mı?
local maxLockDistance = 50 -- Maksimum kilitlenme mesafesi (başlangıç değeri)

-- ESP Ayarları
local ESPBoxEnabled = false
local ESPBoxFilledEnabled = false
local NameESPEnabled = false

-- GUI Oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200) -- Yükseklik artırıldı
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(128, 0, 128)
Frame.Parent = ScreenGui

-- Camlock CheckBox ve Yazısı
local CheckBox = Instance.new("TextButton")
CheckBox.Size = UDim2.new(0, 30, 0, 30)
CheckBox.Position = UDim2.new(0, 10, 0, 10)
CheckBox.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
CheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckBox.Text = "☐"
CheckBox.TextSize = 24
CheckBox.Font = Enum.Font.SourceSansBold
CheckBox.Parent = Frame

local CamlockLabel = Instance.new("TextLabel")
CamlockLabel.Size = UDim2.new(0, 100, 0, 30)
CamlockLabel.Position = UDim2.new(0, 50, 0, 10)
CamlockLabel.BackgroundTransparency = 1
CamlockLabel.Text = "Camlock"
CamlockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CamlockLabel.TextSize = 18
CamlockLabel.Font = Enum.Font.SourceSansBold
CamlockLabel.Parent = Frame

-- Camlock Distance Metin Kutusu (Camlock CheckBox'ının altına)
local DistanceTextBox = Instance.new("TextBox")
DistanceTextBox.Size = UDim2.new(0, 150, 0, 30)
DistanceTextBox.Position = UDim2.new(0, 10, 0, 50)
DistanceTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DistanceTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DistanceTextBox.Text = tostring(maxLockDistance)
DistanceTextBox.TextSize = 18
DistanceTextBox.Font = Enum.Font.SourceSansBold
DistanceTextBox.PlaceholderText = "Camlock Distance"
DistanceTextBox.Parent = Frame

-- ESP CheckBox ve Yazısı
local ESPCheckBox = Instance.new("TextButton")
ESPCheckBox.Size = UDim2.new(0, 30, 0, 30)
ESPCheckBox.Position = UDim2.new(0, 10, 0, 90)
ESPCheckBox.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
ESPCheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPCheckBox.Text = "☐"
ESPCheckBox.TextSize = 24
ESPCheckBox.Font = Enum.Font.SourceSansBold
ESPCheckBox.Parent = Frame

local ESPLabel = Instance.new("TextLabel")
ESPLabel.Size = UDim2.new(0, 100, 0, 30)
ESPLabel.Position = UDim2.new(0, 50, 0, 90)
ESPLabel.BackgroundTransparency = 1
ESPLabel.Text = "ESP"
ESPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPLabel.TextSize = 18
ESPLabel.Font = Enum.Font.SourceSansBold
ESPLabel.Parent = Frame

local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(0, 100, 0, 20)
Credit.Position = UDim2.new(0, 10, 0, 170)
Credit.BackgroundTransparency = 1
Credit.Text = "acne"
Credit.TextColor3 = Color3.fromRGB(100, 100, 100)
Credit.TextSize = 14
Credit.Font = Enum.Font.SourceSansItalic
Credit.Parent = Frame

-- En Yakın Oyuncuyu Bulan Fonksiyon
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mouse = LocalPlayer:GetMouse()
    local mousePosition = Vector2.new(mouse.X, mouse.Y)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
            
            if distance <= maxLockDistance then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
                if onScreen then
                    local screenPosition = Vector2.new(screenPoint.X, screenPoint.Y)
                    local mouseDistance = (mousePosition - screenPosition).Magnitude
                    
                    if mouseDistance < shortestDistance then
                        shortestDistance = mouseDistance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Glow Efekti Ekleme Fonksiyonu (Camlock için)
local function ApplyGlowEffect(character, enabled)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local highlight = part:FindFirstChild("Highlight")
            if enabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "Highlight"
                    highlight.FillColor = Color3.fromRGB(128, 0, 128) -- Mor iç kısım
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Beyaz dış hat
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = part
                end
            else
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

-- ESP Ekleme Fonksiyonu (Box, Filled Box, Name ESP)
local function ApplyESP(player, enabled)
    if not player.Character then return end
    local character = player.Character
    local head = character:FindFirstChild("Head")
    if head then
        -- ESP Box
        if ESPBoxEnabled then
            local box = character:FindFirstChild("ESPBox")
            if not box then
                box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Size = Vector3.new(4, 6, 4)
                box.Adornee = character.PrimaryPart
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Transparency = 0.5
                box.Color3 = Color3.fromRGB(128, 0, 128)
                box.Parent = character
            end
            box.Visible = enabled
        else
            local box = character:FindFirstChild("ESPBox")
            if box then
                box:Destroy()
            end
        end

        -- ESP Box Filled
        if ESPBoxFilledEnabled then
            local boxFilled = character:FindFirstChild("ESPBoxFilled")
            if not boxFilled then
                boxFilled = Instance.new("BoxHandleAdornment")
                boxFilled.Name = "ESPBoxFilled"
                boxFilled.Size = Vector3.new(4, 6, 4)
                boxFilled.Adornee = character.PrimaryPart
                boxFilled.AlwaysOnTop = true
                boxFilled.ZIndex = 5
                boxFilled.Transparency = 0.7
                boxFilled.Color3 = Color3.fromRGB(128, 0, 128)
                boxFilled.Parent = character
            end
            boxFilled.Visible = enabled
        else
            local boxFilled = character:FindFirstChild("ESPBoxFilled")
            if boxFilled then
                boxFilled:Destroy()
            end
        end

        -- Name ESP
        if NameESPEnabled then
            local billboardGui = head:FindFirstChild("BillboardGui")
            if not billboardGui then
                billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "BillboardGui"
                billboardGui.Adornee = head
                billboardGui.Size = UDim2.new(0, 200, 0, 50)
                billboardGui.StudsOffset = Vector3.new(0, 2, 0)
                billboardGui.AlwaysOnTop = true

                local textLabel = Instance.new("TextLabel")
                textLabel.Text = player.Name
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.TextColor3 = Color3.fromRGB(128, 0, 128) -- Mor renk
                textLabel.BackgroundTransparency = 1
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.TextSize = 18
                textLabel.Parent = billboardGui

                billboardGui.Parent = head
            end
            billboardGui.Enabled = enabled
        else
            local billboardGui = head:FindFirstChild("BillboardGui")
            if billboardGui then
                billboardGui:Destroy()
            end
        end
    end
end

-- Oyuncu Yeniden Doğduğunda ESP'yi Güncelle
local function OnCharacterAdded(player, character)
    ApplyESP(player, true)
end

-- Oyuncuların Karakterleri İçin ESP'yi Ayarla
local function SetupESPForPlayer(player)
    if player ~= LocalPlayer then
        if player.Character then
            ApplyESP(player, true)
        end
        player.CharacterAdded:Connect(function(character)
            OnCharacterAdded(player, character)
        end)
    end
end

-- Mevcut Oyuncular İçin ESP'yi Ayarla
for _, player in pairs(Players:GetPlayers()) do
    SetupESPForPlayer(player)
end

-- Yeni Oyuncular İçin ESP'yi Ayarla
Players.PlayerAdded:Connect(function(player)
    SetupESPForPlayer(player)
end)

-- Kamera Güncelleme (Smooth olmadan direkt kilitlenme)
RunService.RenderStepped:Connect(function()
    if isLocked and lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = lockedTarget.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            local targetPosition = lockedTarget.Character.HumanoidRootPart.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
        else
            -- Karakter öldüyse camlock'u devre dışı bırak
            isLocked = false
            lockedTarget = nil
            ApplyGlowEffect(lockedTarget.Character, false)
        end
    end
end)

-- Kamera Kilitleme / Açma İşlevi
local function ToggleCameraLock()
    if not isCheckBoxEnabled then return end -- Eğer tik işaretlenmemişse çalıştırma
    
    if isLocked then
        isLocked = false
        if lockedTarget and lockedTarget.Character then
            ApplyGlowEffect(lockedTarget.Character, false)
        end
        lockedTarget = nil
    else
        local targetPlayer = GetClosestPlayer()
        if targetPlayer then
            isLocked = true
            lockedTarget = targetPlayer
            ApplyGlowEffect(targetPlayer.Character, true)
        end
    end
end

-- CheckBox Butonuna İşlev Ekle
CheckBox.MouseButton1Click:Connect(function()
    isCheckBoxEnabled = not isCheckBoxEnabled
    CheckBox.Text = isCheckBoxEnabled and "☑" or "☐"
    if not isCheckBoxEnabled then
        isLocked = false  -- Eğer tik kaldırıldıysa, camlock sıfırlansın
        if lockedTarget and lockedTarget.Character then
            ApplyGlowEffect(lockedTarget.Character, false)
        end
        lockedTarget = nil
    end
end)

-- ESP CheckBox Butonuna İşlev Ekle
ESPCheckBox.MouseButton1Click:Connect(function()
    ESPBoxEnabled = not ESPBoxEnabled
    ESPCheckBox.Text = ESPBoxEnabled and "☑" or "☐"
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ApplyESP(player, ESPBoxEnabled)
        end
    end
end)

-- Camlock Distance Metin Kutusu İşlevi
DistanceTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newDistance = tonumber(DistanceTextBox.Text)
        if newDistance and newDistance >= 10 and newDistance <= 500 then
            maxLockDistance = newDistance
        else
            DistanceTextBox.Text = tostring(maxLockDistance) -- Geçersiz değer girilirse eski değeri geri yükle
        end
    end
end)

-- "G" Tuşuna Basılınca Kamera Kilitleme (Eğer tik işaretliyse çalışır)
UserInputService.InputBened:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G and isCheckBoxEnabled then
        ToggleCameraLock()
    end
    if input.KeyCode == Enum.KeyCode.Home then
        guiVisible = not guiVisible
        Frame.Visible = guiVisible
    end
end)
