-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variables
local isESPEnabled = false  -- ESP toggle status
local isCamLockEnabled = false  -- Camlock toggle status
local guiVisible = true  -- GUI visibility (başlangıçta açık)
local maxLockDistance = 50  -- Maximum lock distance
local lockedTarget = nil  -- Locked player
local lockBodyPart = "HumanoidRootPart"  -- Default lock body part (Gövde)

-- Ayarları saklamak için tablo
local SavedSettings = {
    ESPEnabled = false,
    CamLockEnabled = false,
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
local ScreenGui, Frame, ESPCheckBox, CamlockCheckBox, DistanceTextBox, BodyPartDropdown

local function CreateGUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 250)  -- Width and height
    Frame.Position = UDim2.new(0.1, 0, 0.1, 0)  -- Position on screen
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)  -- Background color
    Frame.BorderSizePixel = 2  -- Border size
    Frame.BorderColor3 = Color3.fromRGB(128, 0, 128)  -- Border color
    Frame.Visible = SavedSettings.GUIVisible  -- GUI durumunu kaydedilen ayardan al
    Frame.Parent = ScreenGui

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

    local CamlockLabel = Instance.new("TextLabel")
    CamlockLabel.Size = UDim2.new(0, 100, 0, 30)
    CamlockLabel.Position = UDim2.new(0, 50, 0, 50)
    CamlockLabel.BackgroundTransparency = 1
    CamlockLabel.Text = "Camlock"
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

    -- BodyPart Dropdown
    BodyPartDropdown = Instance.new("TextButton")
    BodyPartDropdown.Size = UDim2.new(0, 150, 0, 30)
    BodyPartDropdown.Position = UDim2.new(0, 10, 0, 130)
    BodyPartDropdown.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
    BodyPartDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    BodyPartDropdown.Text = "BodyPart: " .. (SavedSettings.LockBodyPart == "HumanoidRootPart" and "Gövde" or "Kafa")
    BodyPartDropdown.TextSize = 18
    BodyPartDropdown.Font = Enum.Font.SourceSansBold
    BodyPartDropdown.Parent = Frame

    -- ESP CheckBox Functionality
    ESPCheckBox.MouseButton1Click:Connect(function()
        isESPEnabled = not isESPEnabled
        ESPCheckBox.Text = isESPEnabled and "☑" or "☐"
        SavedSettings.ESPEnabled = isESPEnabled
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
        CamlockCheckBox.Text = isCamLockEnabled and "☑" or "☐"
        SavedSettings.CamLockEnabled = isCamLockEnabled
    end)

    -- BodyPart Dropdown Functionality
    BodyPartDropdown.MouseButton1Click:Connect(function()
        if lockBodyPart == "HumanoidRootPart" then
            lockBodyPart = "Head"
            BodyPartDropdown.Text = "BodyPart: Kafa"
        else
            lockBodyPart = "HumanoidRootPart"
            BodyPartDropdown.Text = "BodyPart: Gövde"
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
end

-- Toggle GUI with Home Key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Home then
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
        box = Drawing.new("Quad"),
        healthbar = Drawing.new("Line"),
        greenhealth = Drawing.new("Line")
    }

    -- Initialize ESP elements
    for _, element in pairs(library) do
        element.Visible = false
        element.Color = Settings.Box_Color
        element.Thickness = Settings.Box_Thickness
        element.Filled = false
        element.Transparency = 1
    end

    -- Update ESP
    local function Updater()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") then
                local rootPart = plr.Character.HumanoidRootPart
                local head = plr.Character.Head
                local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                local headPos = Camera:WorldToViewportPoint(head.Position)

                if onScreen then
                    local distanceY = math.clamp((Vector2.new(headPos.X, headPos.Y) - Vector2.new(rootPos.X, rootPos.Y)).magnitude, 2, math.huge)

                    -- Box
                    library.box.PointA = Vector2.new(rootPos.X + distanceY, rootPos.Y - distanceY * 2)
                    library.box.PointB = Vector2.new(rootPos.X - distanceY, rootPos.Y - distanceY * 2)
                    library.box.PointC = Vector2.new(rootPos.X - distanceY, rootPos.Y + distanceY * 2)
                    library.box.PointD = Vector2.new(rootPos.X + distanceY, rootPos.Y + distanceY * 2)
                    library.box.Visible = isESPEnabled

                    -- Health Bar
                    if Settings.HealthBar then
                        local health = plr.Character.Humanoid.Health
                        local maxHealth = plr.Character.Humanoid.MaxHealth
                        local healthOffset = (health / maxHealth) * (distanceY * 4)

                        library.healthbar.From = Vector2.new(rootPos.X - distanceY - 4, rootPos.Y + distanceY * 2)
                        library.healthbar.To = Vector2.new(rootPos.X - distanceY - 4, rootPos.Y - distanceY * 2)
                        library.healthbar.Color = Color3.fromRGB(255, 0, 0)
                        library.healthbar.Visible = isESPEnabled

                        library.greenhealth.From = Vector2.new(rootPos.X - distanceY - 4, rootPos.Y + distanceY * 2)
                        library.greenhealth.To = Vector2.new(rootPos.X - distanceY - 4, rootPos.Y + distanceY * 2 - healthOffset)
                        library.greenhealth.Color = Color3.fromRGB(0, 255, 0)
                        library.greenhealth.Visible = isESPEnabled
                    end
                else
                    for _, element in pairs(library) do
                        element.Visible = false
                    end
                end
            else
                for _, element in pairs(library) do
                    element.Visible = false
                end
                if not Players:FindFirstChild(plr.Name) then
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

-- Set Up ESP for Existing Players
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

-- Toggle Camlock on G Key Press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.C and isCamLockEnabled then
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
