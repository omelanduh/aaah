-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local isESPEnabled = false  -- ESP toggle status
local isCamLockEnabled = false  -- Camlock toggle status
local isSpeedEnabled = false  -- Speed toggle status
local isSpeedActive = false  -- Speed active status (C tuşu ile kontrol edilir)
local guiVisible = true  -- GUI visibility (başlangıçta açık)
local maxLockDistance = 50  -- Maximum lock distance
local lockedTarget = nil  -- Locked player
local lockBodyPart = "HumanoidRootPart"  -- Default lock body part (Gövde)
local speedValue = 16  -- Default speed value

-- Ayarları saklamak için tablo
local SavedSettings = {
    ESPEnabled = false,
    CamLockEnabled = false,
    SpeedEnabled = false,
    SpeedValue = 16,
    MaxLockDistance = 50,
    LockBodyPart = "HumanoidRootPart",
    GUIVisible = true
}

-- Highlight Effect
local highlight = Instance.new("Highlight")
highlight.FillColor = Color3.fromRGB(128, 0, 128)  -- Mor renk
highlight.FillTransparency = 0.5  -- Saydamlık (0 = tam opak, 1 = tam saydam)
highlight.OutlineColor = Color3.fromRGB(255, 255, 255)  -- Beyaz dış çizgi
highlight.OutlineTransparency = 0  -- Dış çizgi saydamlığı (0 = tam opak)
highlight.Parent = nil  -- Başlangıçta hiçbir şeye bağlı değil

-- ESP Settings
local Settings = {
    Box_Color = Color3.fromRGB(255, 0, 0),  -- Box color
    Box_Thickness = 1,  -- Box thickness
    HealthBar = true  -- Health bar visibility
}

-- GUI Creation
local ScreenGui, Frame, ESPCheckBox, CamlockCheckBox, DistanceTextBox, BodyPartDropdown, SpeedCheckBox, SpeedSlider

local function CreateGUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 300)  -- Width and height
    Frame.Position = UDim2.new(0.1, 0, 0.1, 0)  -- Position on screen
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)  -- Background color
    Frame.BorderSizePixel = 0  -- Border size
    Frame.BorderColor3 = Color3.fromRGB(128, 0, 128)  -- Border color
    Frame.Visible = SavedSettings.GUIVisible  -- GUI durumunu kaydedilen ayardan al
    Frame.Parent = ScreenGui
    Frame.BackgroundTransparency = 0.1

    -- UICorner ekleyerek kenarları oval yap
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)  -- Köşelerin yuvarlaklık derecesi (0-1 arası)
    UICorner.Parent = Frame

    -- Sol alt köşeye "ACNE" yazısı ekle
    local CreditLabel = Instance.new("TextLabel")
    CreditLabel.Size = UDim2.new(0, 100, 0, 20)
    CreditLabel.Position = UDim2.new(0, 10, 1, -30)  -- Sol alt köşe
    CreditLabel.BackgroundTransparency = 1  -- Arka planı şeffaf yap
    CreditLabel.Text = "ACNE"
    CreditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Beyaz renk
    CreditLabel.TextTransparency = 0.5  -- Saydamlık (0 = tam opak, 1 = tam saydam)
    CreditLabel.TextSize = 14  -- Yazı boyutu
    CreditLabel.Font = Enum.Font.SourceSans  -- Yazı fontu
    CreditLabel.TextXAlignment = Enum.TextXAlignment.Left  -- Yazıyı sola hizala
    CreditLabel.Parent = Frame

    -- GUI'yi tutma ve kaydırma fonksiyonları
    local dragging = false
    local dragInput, dragStart, startPos

    local function UpdateInput(input)
        local delta = input.Position - dragStart
        local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        
        -- Smooth hareket için TweenService kullan
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(Frame, tweenInfo, {Position = newPosition})
        tween:Play()
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            UpdateInput(input)
        end
    end)

    local function ToggleCheckmark(button, isChecked)
        local targetColor = isChecked and Color3.fromRGB(50, 0, 50) or Color3.fromRGB(80, 0, 80)  -- Koyu mor veya normal mor
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = targetColor})
        tween:Play()
    end

    -- ESP CheckBox and Label
    ESPCheckBox = Instance.new("TextButton")
    ESPCheckBox.Size = UDim2.new(0, 30, 0, 30)
    ESPCheckBox.Position = UDim2.new(0, 10, 0, 10)
    ESPCheckBox.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
    ESPCheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPCheckBox.Text = SavedSettings.ESPEnabled and "☑" or "☐"
    ESPCheckBox.TextSize = 24
    ESPCheckBox.Font = Enum.Font.SourceSansBold
    ESPCheckBox.Parent = Frame

    -- ESPCheckBox için UICorner ekle
    local ESPCheckBoxCorner = Instance.new("UICorner")
    ESPCheckBoxCorner.CornerRadius = UDim.new(0, 8)
    ESPCheckBoxCorner.Parent = ESPCheckBox

    local ESPLabel = Instance.new("TextLabel")
    ESPLabel.Size = UDim2.new(0, 100, 0, 30)
    ESPLabel.Position = UDim2.new(0, 50, 0, 10)
    ESPLabel.BackgroundTransparency = 1
    ESPLabel.Text = "ESP"
    ESPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPLabel.TextSize = 18
    ESPLabel.Font = Enum.Font.SourceSansBold
    ESPLabel.Parent = Frame

    -- Camlock CheckBox and Label
    CamlockCheckBox = Instance.new("TextButton")
    CamlockCheckBox.Size = UDim2.new(0, 30, 0, 30)
    CamlockCheckBox.Position = UDim2.new(0, 10, 0, 50)
    CamlockCheckBox.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
    CamlockCheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    CamlockCheckBox.Text = SavedSettings.CamLockEnabled and "☑" or "☐"
    CamlockCheckBox.TextSize = 24
    CamlockCheckBox.Font = Enum.Font.SourceSansBold
    CamlockCheckBox.Parent = Frame

    -- CamlockCheckBox için UICorner ekle
    local CamlockCheckBoxCorner = Instance.new("UICorner")
    CamlockCheckBoxCorner.CornerRadius = UDim.new(0, 8)
    CamlockCheckBoxCorner.Parent = CamlockCheckBox

    local CamlockLabel = Instance.new("TextLabel")
    CamlockLabel.Size = UDim2.new(0, 100, 0, 30)
    CamlockLabel.Position = UDim2.new(0, 50, 0, 50)
    CamlockLabel.BackgroundTransparency = 1
    CamlockLabel.Text = "Camlock-T"
    CamlockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CamlockLabel.TextSize = 18
    CamlockLabel.Font = Enum.Font.SourceSansBold
    CamlockLabel.Parent = Frame

    -- Camlock Distance TextBox
    DistanceTextBox = Instance.new("TextBox")
    DistanceTextBox.Size = UDim2.new(0, 150, 0, 30)
    DistanceTextBox.Position = UDim2.new(0, 10, 0, 90)
    DistanceTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    DistanceTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    DistanceTextBox.Text = tostring(SavedSettings.MaxLockDistance)
    DistanceTextBox.TextSize = 18
    DistanceTextBox.Font = Enum.Font.SourceSansBold
    DistanceTextBox.PlaceholderText = "Max Distance (50-500)"
    DistanceTextBox.Parent = Frame

    -- DistanceTextBox için UICorner ekle
    local DistanceTextBoxCorner = Instance.new("UICorner")
    DistanceTextBoxCorner.CornerRadius = UDim.new(0, 8)
    DistanceTextBoxCorner.Parent = DistanceTextBox

    -- BodyPart Dropdown
    BodyPartDropdown = Instance.new("TextButton")
    BodyPartDropdown.Size = UDim2.new(0, 150, 0, 30)
    BodyPartDropdown.Position = UDim2.new(0, 10, 0, 130)
    BodyPartDropdown.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
    BodyPartDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    BodyPartDropdown.Text = "BodyPart: " .. (SavedSettings.LockBodyPart == "HumanoidRootPart" and "Torso" or "Head")
    BodyPartDropdown.TextSize = 18
    BodyPartDropdown.Font = Enum.Font.SourceSansBold
    BodyPartDropdown.Parent = Frame

    -- BodyPartDropdown için UICorner ekle
    local BodyPartDropdownCorner = Instance.new("UICorner")
    BodyPartDropdownCorner.CornerRadius = UDim.new(0, 8)
    BodyPartDropdownCorner.Parent = BodyPartDropdown

    -- Speed CheckBox and Label (En alta taşındı)
    SpeedCheckBox = Instance.new("TextButton")
    SpeedCheckBox.Size = UDim2.new(0, 30, 0, 30)
    SpeedCheckBox.Position = UDim2.new(0, 10, 0, 170)
    SpeedCheckBox.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
    SpeedCheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedCheckBox.Text = SavedSettings.SpeedEnabled and "☑" or "☐"
    SpeedCheckBox.TextSize = 24
    SpeedCheckBox.Font = Enum.Font.SourceSansBold
    SpeedCheckBox.Parent = Frame

    -- SpeedCheckBox için UICorner ekle
    local SpeedCheckBoxCorner = Instance.new("UICorner")
    SpeedCheckBoxCorner.CornerRadius = UDim.new(0, 8)
    SpeedCheckBoxCorner.Parent = SpeedCheckBox

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0, 100, 0, 30)
    SpeedLabel.Position = UDim2.new(0, 50, 0, 170)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Text = "Speed-C"
    SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedLabel.TextSize = 18
    SpeedLabel.Font = Enum.Font.SourceSansBold
    SpeedLabel.Parent = Frame

    -- Speed Slider (En alta taşındı)
    SpeedSlider = Instance.new("TextBox")
    SpeedSlider.Size = UDim2.new(0, 150, 0, 30)
    SpeedSlider.Position = UDim2.new(0, 10, 0, 210)
    SpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedSlider.Text = tostring(SavedSettings.SpeedValue)
    SpeedSlider.TextSize = 18
    SpeedSlider.Font = Enum.Font.SourceSansBold
    SpeedSlider.PlaceholderText = "Speed (16-100)"
    SpeedSlider.Parent = Frame

    -- SpeedSlider için UICorner ekle
    local SpeedSliderCorner = Instance.new("UICorner")
    SpeedSliderCorner.CornerRadius = UDim.new(0, 8)
    SpeedSliderCorner.Parent = SpeedSlider

    -- ESP CheckBox Functionality
    ESPCheckBox.MouseButton1Click:Connect(function()
        isESPEnabled = not isESPEnabled
        SavedSettings.ESPEnabled = isESPEnabled
        ToggleCheckmark(ESPCheckBox, isESPEnabled)  -- Renk değişimi animasyonu
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                -- Reapply ESP for all players
                coroutine.wrap(ESP)(player)
            end
        end
    end)

    -- Camlock CheckBox Functionality
    CamlockCheckBox.MouseButton1Click:Connect(function()
        isCamLockEnabled = not isCamLockEnabled
        SavedSettings.CamLockEnabled = isCamLockEnabled
        ToggleCheckmark(CamlockCheckBox, isCamLockEnabled)  -- Renk değişimi animasyonu
    end)

    -- Speed CheckBox Functionality
    SpeedCheckBox.MouseButton1Click:Connect(function()
        isSpeedEnabled = not isSpeedEnabled
        SavedSettings.SpeedEnabled = isSpeedEnabled
        ToggleCheckmark(SpeedCheckBox, isSpeedEnabled)  -- Renk değişimi animasyonu
    end)

    -- BodyPart Dropdown Functionality
    BodyPartDropdown.MouseButton1Click:Connect(function()
        if lockBodyPart == "HumanoidRootPart" then
            lockBodyPart = "Head"
            BodyPartDropdown.Text = "BodyPart: Head"
        else
            lockBodyPart = "HumanoidRootPart"
            BodyPartDropdown.Text = "BodyPart: Torso"
        end
        SavedSettings.LockBodyPart = lockBodyPart
    end)

    -- Update Max Distance
    DistanceTextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newDistance = tonumber(DistanceTextBox.Text)
            if newDistance and newDistance >= 50 and newDistance <= 500 then
                maxLockDistance = newDistance
                SavedSettings.MaxLockDistance = maxLockDistance
            else
                DistanceTextBox.Text = tostring(maxLockDistance)  -- Restore old value if invalid
            end
        end
    end)

    -- Update Speed Value
    SpeedSlider.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newSpeed = tonumber(SpeedSlider.Text)
            if newSpeed and newSpeed >= 16 and newSpeed <= 100 then
                speedValue = newSpeed
                SavedSettings.SpeedValue = speedValue
            else
                SpeedSlider.Text = tostring(speedValue)  -- Restore old value if invalid
            end
        end
    end)
end

-- Toggle GUI with Home Key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        SavedSettings.GUIVisible = not SavedSettings.GUIVisible
        Frame.Visible = SavedSettings.GUIVisible
    end
end)

-- Recreate GUI on Respawn
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)  -- Wait for character to fully load
    if ScreenGui then
        ScreenGui:Destroy()  -- Destroy old GUI
    end
    CreateGUI()  -- Recreate GUI with saved settings
end)

-- Initial GUI Creation
CreateGUI()

-- ESP Function
local function ESP(plr)
    local library = {
        name = Drawing.new("Text"),  -- İsim için
        healthbar = Drawing.new("Line"),  -- Health bar için
        greenhealth = Drawing.new("Line")  -- Health bar doluluk çubuğu için
    }

    -- Initialize ESP elements
    library.name.Visible = isESPEnabled  -- İsim görünürlüğü
    library.name.Color = Settings.Box_Color  -- İsim rengi
    library.name.Size = 18  -- İsim boyutu
    library.name.Center = true  -- Metni merkezle
    library.name.Outline = true  -- İsime dış çizgi ekle
    library.name.OutlineColor = Color3.new(0, 0, 0)  -- Dış çizgi rengi (siyah)
    library.name.Text = plr.Name  -- Oyuncunun ismi

    library.healthbar.Visible = isESPEnabled  -- Health bar görünürlüğü
    library.healthbar.Color = Color3.fromRGB(255, 0, 0)  -- Health bar rengi (kırmızı)
    library.healthbar.Thickness = 2  -- Health bar kalınlığı

    library.greenhealth.Visible = isESPEnabled  -- Health bar doluluk çubuğu görünürlüğü
    library.greenhealth.Color = Color3.fromRGB(0, 255, 0)  -- Doluluk rengi (yeşil)
    library.greenhealth.Thickness = 2  -- Doluluk çubuğu kalınlığı

    -- Update ESP
    local function Updater()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = plr.Character.HumanoidRootPart
                local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

                if onScreen then
                    -- İsim pozisyonunu güncelle
                    library.name.Position = Vector2.new(rootPos.X, rootPos.Y - 30)  -- İsim, karakterin üstünde gözükecek
                    library.name.Visible = isESPEnabled  -- isESPEnabled'e göre görünürlük ayarla

                    -- Health bar pozisyonunu güncelle
                    local health = plr.Character.Humanoid.Health
                    local maxHealth = plr.Character.Humanoid.MaxHealth
                    local healthPercentage = health / maxHealth
                    local barLength = 50  -- Health bar uzunluğu
                    local barOffset = Vector2.new(rootPos.X - barLength / 2, rootPos.Y + 20)  -- Health bar pozisyonu

                    -- Health bar (kırmızı arka plan)
                    library.healthbar.From = barOffset
                    library.healthbar.To = Vector2.new(barOffset.X + barLength, barOffset.Y)
                    library.healthbar.Visible = isESPEnabled

                    -- Health bar doluluk çubuğu (yeşil)
                    library.greenhealth.From = barOffset
                    library.greenhealth.To = Vector2.new(barOffset.X + barLength * healthPercentage, barOffset.Y)
                    library.greenhealth.Visible = isESPEnabled
                else
                    -- Ekranda değilse gizle
                    library.name.Visible = false
                    library.healthbar.Visible = false
                    library.greenhealth.Visible = false
                end
            else
                -- Karakter yoksa gizle
                library.name.Visible = false
                library.healthbar.Visible = false
                library.greenhealth.Visible = false
                if not Players:FindFirstChild(plr.Name) then
                    connection:Disconnect()  -- Oyuncu oyundan ayrıldıysa bağlantıyı kes
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        coroutine.wrap(ESP)(player)
    end
end

-- Set Up ESP for New Players
Players.PlayerAdded:Connect(function(newPlayer)
    if newPlayer ~= LocalPlayer then
        coroutine.wrap(ESP)(newPlayer)
    end
end)

-- Yeni oyuncular için ESP ekle
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        OnCharacterAdded(player)
    end
end)

-- Camlock Functionality
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mouse = LocalPlayer:GetMouse()
    local mousePosition = Vector2.new(mouse.X, mouse.Y)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(lockBodyPart) then
            local character = player.Character
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
            
            if distance <= maxLockDistance then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(character[lockBodyPart].Position)
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

-- Toggle Camlock on T Key Press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.T and isCamLockEnabled then
        if lockedTarget then
            -- Camlock kapatıldı, highlight'ı kaldır
            highlight.Parent = nil
            lockedTarget = nil
        else
            -- Camlock açıldı, en yakın oyuncuyu bul ve highlight ekle
            lockedTarget = GetClosestPlayer()
            if lockedTarget and lockedTarget.Character then
                highlight.Parent = lockedTarget.Character
            end
        end
    end
end)

-- Update Camlock
RunService.RenderStepped:Connect(function()
    if isCamLockEnabled and lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild(lockBodyPart) then
        local humanoid = lockedTarget.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            local targetPosition = lockedTarget.Character[lockBodyPart].Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
        else
            -- Karakter öldüyse camlock'u devre dışı bırak ve highlight'ı kaldır
            highlight.Parent = nil
            lockedTarget = nil
        end
    end
end)

-- Speed Functionality
local function ApplySpeed()
    if isSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if isSpeedActive then
            LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = 16  -- Default speed
        end
    end
end

-- Toggle Speed on C Key Press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.C and isSpeedEnabled then
        isSpeedActive = not isSpeedActive
        ApplySpeed()
    end
end)

-- Update Speed
RunService.RenderStepped:Connect(function()
    if isSpeedEnabled then
        ApplySpeed()
    end
end)
