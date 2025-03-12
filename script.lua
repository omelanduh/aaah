-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local isESPEnabled = false  -- ESP toggle status
local isSkeletonESPEnabled = false  -- Skeleton ESP toggle status
local isCamLockEnabled = false  -- Camlock toggle status
local isSpeedEnabled = false  -- Speed toggle status
local isSpeedActive = false  -- Speed active status
local guiVisible = true  -- GUI visibility
local maxLockDistance = 50  -- Maximum lock distance
local lockedTarget = nil  -- Locked player
local lockBodyPart = "HumanoidRootPart"  -- Default lock body part
local speedValue = 16  -- Default speed value
local isHealthBarEnabled = false  -- Health Bar toggle status
local predictionValue = 0.1  -- Prediction value for camlock
local isDistanceESPEnabled = false  -- Distance ESP toggle status
local isTraceESPEnabled = false  -- Trace ESP toggle status

-- ESP için Drawing objelerini saklamak için tablo
local ESPTable = {}

-- Keybinds
local camlockKey = Enum.KeyCode.T  -- Default camlock key
local speedKey = Enum.KeyCode.C  -- Default speed key
local espKey = Enum.KeyCode.E  -- Default ESP key

-- Ayarları saklamak için tablo
local SavedSettings = {
    ESPEnabled = false,
    SkeletonESPEnabled = false,
    CamLockEnabled = false,
    SpeedEnabled = false,
    SpeedValue = 16,
    MaxLockDistance = 50,
    LockBodyPart = "HumanoidRootPart",
    GUIVisible = true,
    HealthBarEnabled = false,
    CamlockKey = "T",  -- Default camlock key
    SpeedKey = "C",  -- Default speed key,
    ESPKey = "E",  -- Default ESP key,
    PredictionValue = 0.1,  -- Default prediction value
    DistanceESPEnabled = false,  -- Distance ESP toggle status
    TraceESPEnabled = false,  -- Trace ESP toggle status
    ESPColor = Color3.fromRGB(255, 0, 255),  -- Default ESP color
    SkeletonESPColor = Color3.fromRGB(255, 0, 255),  -- Default Skeleton ESP color
    HealthBarColor = Color3.fromRGB(0, 255, 0),  -- Default Health Bar color
    DistanceESPColor = Color3.fromRGB(255, 0, 255),  -- Default Distance ESP color
    TraceESPColor = Color3.fromRGB(255, 0, 255),  -- Default Trace ESP color
    CamlockHighlightColor = Color3.fromRGB(128, 0, 128)  -- Default Camlock highlight color
}

-- Highlight Effect
local highlight = Instance.new("Highlight")
highlight.FillColor = SavedSettings.CamlockHighlightColor  -- Mor renk
highlight.FillTransparency = 0.5  -- Saydamlık
highlight.OutlineColor = Color3.fromRGB(255, 255, 255)  -- Beyaz dış çizgi
highlight.OutlineTransparency = 0  -- Dış çizgi saydamlığı
highlight.Parent = nil  -- Başlangıçta hiçbir şeye bağlı değil

-- ESP Settings
local Settings = {
    Box_Color = SavedSettings.ESPColor,  -- Box color
    Box_Thickness = 1,  -- Box thickness
    HealthBar = false  -- Health bar visibility
}

-- GUI Creation
local ScreenGui, MainFrame, Tabs, AimbotTab, PlayerTab, VisualTab


-- Renk seçici için fonksiyon
-- Renk seçici için fonksiyon
local function CreateColorPicker(parent, position, defaultColor, callback)
    local colorPickerButton = Instance.new("TextButton")
    colorPickerButton.Size = UDim2.new(0, 30, 0, 30)
    colorPickerButton.Position = position
    colorPickerButton.BackgroundColor3 = defaultColor
    colorPickerButton.Text = ""
    colorPickerButton.Parent = parent

    -- UICorner ekleyerek kenarları oval yap
    local colorPickerCorner = Instance.new("UICorner")
    colorPickerCorner.CornerRadius = UDim.new(0, 8)
    colorPickerCorner.Parent = colorPickerButton

    -- Renk seçici açıkken GUI'nin hareket etmesini engellemek için bir bayrak
    local isColorPickerOpen = false

    colorPickerButton.MouseButton1Click:Connect(function()
        if isColorPickerOpen then return end  -- Renk seçici zaten açıksa tekrar açma
        isColorPickerOpen = true

        -- Renk seçici penceresi (GUI'nin sağ tarafında aç)
        local colorPicker = Instance.new("Frame")
        colorPicker.Size = UDim2.new(0, 200, 0, 200)
        colorPicker.Position = UDim2.new(1, 10, 0, 0)  -- GUI'nin sağ tarafında aç
        colorPicker.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        colorPicker.Parent = parent  -- GUI'nin içinde aç

        -- UICorner ekleyerek kenarları oval yap
        local colorPickerUICorner = Instance.new("UICorner")
        colorPickerUICorner.CornerRadius = UDim.new(0, 12)
        colorPickerUICorner.Parent = colorPicker

        -- Kapatma butonu
        local colorPickerCloseButton = Instance.new("TextButton")
        colorPickerCloseButton.Size = UDim2.new(0, 30, 0, 30)
        colorPickerCloseButton.Position = UDim2.new(1, -35, 0, 5)
        colorPickerCloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        colorPickerCloseButton.Text = "X"
        colorPickerCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        colorPickerCloseButton.TextSize = 18
        colorPickerCloseButton.Font = Enum.Font.SourceSansBold
        colorPickerCloseButton.Parent = colorPicker

        -- UICorner ekleyerek kenarları oval yap
        local closeButtonCorner = Instance.new("UICorner")
        closeButtonCorner.CornerRadius = UDim.new(0, 8)
        closeButtonCorner.Parent = colorPickerCloseButton

        colorPickerCloseButton.MouseButton1Click:Connect(function()
            colorPicker:Destroy()
            isColorPickerOpen = false
        end)

        -- Renk seçici canvas'ı (yuvarlak renk çarkı)
        local colorPickerCanvas = Instance.new("Frame")
        colorPickerCanvas.Size = UDim2.new(0, 180, 0, 180)
        colorPickerCanvas.Position = UDim2.new(0, 10, 0, 10)
        colorPickerCanvas.BackgroundTransparency = 1
        colorPickerCanvas.Parent = colorPicker

        -- Yuvarlak renk çarkını çiz
        local function DrawColorWheel()
            local center = Vector2.new(90, 90)  -- Canvas'ın merkezi
            local radius = 90  -- Yuvarlak çarkın yarıçapı

            for x = 0, 180, 2 do  -- 2 piksel aralıklarla çiz (performans için)
                for y = 0, 180, 2 do
                    local dx = x - center.X
                    local dy = y - center.Y
                    local distance = math.sqrt(dx * dx + dy * dy)

                    if distance <= radius then  -- Yuvarlak alan içinde kal
                        local angle = math.atan2(dy, dx)
                        local hue = (angle + math.pi) / (2 * math.pi)  -- HSV'de hue (0-1 arası)
                        local saturation = distance / radius  -- HSV'de saturation (0-1 arası)
                        local color = Color3.fromHSV(hue, saturation, 1)  -- HSV'den RGB'ye dönüşüm

                        local pixel = Instance.new("Frame")
                        pixel.Size = UDim2.new(0, 2, 0, 2)  -- 2x2 piksellik kareler
                        pixel.Position = UDim2.new(0, x, 0, y)
                        pixel.BackgroundColor3 = color
                        pixel.BorderSizePixel = 0
                        pixel.Parent = colorPickerCanvas
                    end
                end
            end
        end

        DrawColorWheel()

        -- Renk seçici göstergesi
        local colorPickerIndicator = Instance.new("Frame")
        colorPickerIndicator.Size = UDim2.new(0, 10, 0, 10)
        colorPickerIndicator.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        colorPickerIndicator.BorderSizePixel = 2
        colorPickerIndicator.BorderColor3 = Color3.fromRGB(255, 255, 255)
        colorPickerIndicator.Parent = colorPickerCanvas

        -- UICorner ekleyerek kenarları oval yap
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0, 5)
        indicatorCorner.Parent = colorPickerIndicator

        -- Renk seçiciye tıklama ve sürükleme işlevselliği
        local isDragging = false

        colorPickerCanvas.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true
                -- Renk seçiciye tıklandığında renk seçimi yap
                local mousePosition = Vector2.new(input.Position.X, input.Position.Y)
                local canvasPosition = colorPickerCanvas.AbsolutePosition
                local canvasSize = colorPickerCanvas.AbsoluteSize

                local relativePosition = Vector2.new(
                    (mousePosition.X - canvasPosition.X) / canvasSize.X,
                    (mousePosition.Y - canvasPosition.Y) / canvasSize.Y
                )

                relativePosition = Vector2.new(
                    math.clamp(relativePosition.X, 0, 1),
                    math.clamp(relativePosition.Y, 0, 1)
                )

                -- Yuvarlak alan içinde kal
                local dx = relativePosition.X * 180 - 90
                local dy = relativePosition.Y * 180 - 90
                local distance = math.sqrt(dx * dx + dy * dy)

                if distance <= 90 then
                    local angle = math.atan2(dy, dx)
                    local hue = (angle + math.pi) / (2 * math.pi)
                    local saturation = distance / 90
                    local color = Color3.fromHSV(hue, saturation, 1)
                    colorPickerButton.BackgroundColor3 = color
                    callback(color)
                    colorPickerIndicator.Position = UDim2.new(relativePosition.X, -5, relativePosition.Y, -5)
                end
            end
        end)

        colorPickerCanvas.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)

        colorPickerCanvas.InputChanged:Connect(function(input)
            if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePosition = Vector2.new(input.Position.X, input.Position.Y)
                local canvasPosition = colorPickerCanvas.AbsolutePosition
                local canvasSize = colorPickerCanvas.AbsoluteSize

                local relativePosition = Vector2.new(
                    (mousePosition.X - canvasPosition.X) / canvasSize.X,
                    (mousePosition.Y - canvasPosition.Y) / canvasSize.Y
                )

                relativePosition = Vector2.new(
                    math.clamp(relativePosition.X, 0, 1),
                    math.clamp(relativePosition.Y, 0, 1)
                )

                -- Yuvarlak alan içinde kal
                local dx = relativePosition.X * 180 - 90
                local dy = relativePosition.Y * 180 - 90
                local distance = math.sqrt(dx * dx + dy * dy)

                if distance <= 90 then
                    local angle = math.atan2(dy, dx)
                    local hue = (angle + math.pi) / (2 * math.pi)
                    local saturation = distance / 90
                    local color = Color3.fromHSV(hue, saturation, 1)
                    colorPickerButton.BackgroundColor3 = color
                    callback(color)
                    colorPickerIndicator.Position = UDim2.new(relativePosition.X, -5, relativePosition.Y, -5)
                end
            end
        end)
    end)
end

-- ESP renklerini güncelleme fonksiyonu
local function UpdateESPColors()
    for plr, library in pairs(ESPTable) do
        if library.name then
            library.name.Color = SavedSettings.ESPColor
        end
        if library.healthbar then
            library.healthbar.Color = SavedSettings.HealthBarColor
        end
        if library.greenhealth then
            library.greenhealth.Color = SavedSettings.HealthBarColor
        end
        if library.distance then
            library.distance.Color = SavedSettings.DistanceESPColor
        end
        if library.trace then
            library.trace.Color = SavedSettings.TraceESPColor
        end
    end
end

-- GUI'yi oluşturma fonksiyonu
local function CreateGUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 400)  -- Width and height
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)  -- Position on screen
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)  -- Background color
    MainFrame.BorderSizePixel = 0  -- Border size
    MainFrame.BorderColor3 = Color3.fromRGB(128, 0, 128)  -- Border color
    MainFrame.Visible = SavedSettings.GUIVisible  -- GUI durumunu kaydedilen ayardan al
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundTransparency = 0.8  -- Saydamlık (daha saydam)

    -- UICorner ekleyerek kenarları oval yap
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)  -- Köşelerin yuvarlaklık derecesi
    UICorner.Parent = MainFrame

    -- Sol alt köşeye "ACNE" yazısı ekle (credit gibi)
    local CreditLabel = Instance.new("TextLabel")
    CreditLabel.Size = UDim2.new(0, 100, 0, 20)
    CreditLabel.Position = UDim2.new(0, 10, 1, -30)  -- Sol alt köşe
    CreditLabel.BackgroundTransparency = 1  -- Arka planı şeffaf yap
    CreditLabel.Text = "made by ACNE"
    CreditLabel.TextColor3 = Color3.fromRGB(255, 131, 239)  -- Beyaz renk
    CreditLabel.TextTransparency = 0  -- Saydamlık (0 = tam opak, 1 = tam saydam)
    CreditLabel.TextSize = 20  -- Yazı boyutu
    CreditLabel.Font = Enum.Font.SourceSansBold  -- Yazı fontu
    CreditLabel.TextXAlignment = Enum.TextXAlignment.Left  -- Yazıyı sola hizala
    CreditLabel.Parent = MainFrame

    -- Tabs
    Tabs = Instance.new("Frame")
    Tabs.Size = UDim2.new(0, 400, 0, 40)
    Tabs.Position = UDim2.new(0, 0, 0, 0)
    Tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Tabs.BorderSizePixel = 0
    Tabs.Parent = MainFrame

    -- UICorner ekleyerek kenarları oval yap
    local TabsCorner = Instance.new("UICorner")
    TabsCorner.CornerRadius = UDim.new(0, 12)
    TabsCorner.Parent = Tabs

    -- Tab Buttons
    local function CreateTabButton(name, position)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 100, 0, 40)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Text = name
        button.TextSize = 14
        button.Font = Enum.Font.SourceSansBold
        button.AutoButtonColor = false
        button.Parent = Tabs

        -- UICorner ekleyerek kenarları oval yap
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button

        return button
    end

    local AimbotTabButton = CreateTabButton("Aimbot", UDim2.new(0, 0, 0, 0))
    local PlayerTabButton = CreateTabButton("Player", UDim2.new(0, 100, 0, 0))
    local VisualTabButton = CreateTabButton("Visual", UDim2.new(0, 200, 0, 0))

    -- Tab Frames
    AimbotTab = Instance.new("Frame")
    AimbotTab.Size = UDim2.new(0, 400, 0, 360)
    AimbotTab.Position = UDim2.new(0, 0, 0, 40)
    AimbotTab.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    AimbotTab.Visible = true
    AimbotTab.Parent = MainFrame
    AimbotTab.BackgroundTransparency = 0.1

    -- AimbotTab için UICorner ekle
    local AimbotTabCorner = Instance.new("UICorner")
    AimbotTabCorner.CornerRadius = UDim.new(0, 12)
    AimbotTabCorner.Parent = AimbotTab

    PlayerTab = Instance.new("Frame")
    PlayerTab.Size = UDim2.new(0, 400, 0, 360)
    PlayerTab.Position = UDim2.new(0, 0, 0, 40)
    PlayerTab.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    PlayerTab.Visible = false
    PlayerTab.Parent = MainFrame
    PlayerTab.BackgroundTransparency = 0.1

    -- PlayerTab için UICorner ekle
    local PlayerTabCorner = Instance.new("UICorner")
    PlayerTabCorner.CornerRadius = UDim.new(0, 12)
    PlayerTabCorner.Parent = PlayerTab

    VisualTab = Instance.new("Frame")
    VisualTab.Size = UDim2.new(0, 400, 0, 360)
    VisualTab.Position = UDim2.new(0, 0, 0, 40)
    VisualTab.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    VisualTab.Visible = false
    VisualTab.Parent = MainFrame
    VisualTab.BackgroundTransparency = 0.1

    -- VisualTab için UICorner ekle
    local VisualTabCorner = Instance.new("UICorner")
    VisualTabCorner.CornerRadius = UDim.new(0, 12)
    VisualTabCorner.Parent = VisualTab

    -- Tab Button Functionality
    local function ToggleTabButton(button, isActive)
        local targetColor = isActive and Color3.fromRGB(80, 0, 80) or Color3.fromRGB(50, 50, 50)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = targetColor})
        tween:Play()
    end

    AimbotTabButton.MouseButton1Click:Connect(function()
        AimbotTab.Visible = true
        PlayerTab.Visible = false
        VisualTab.Visible = false
        ToggleTabButton(AimbotTabButton, true)
        ToggleTabButton(PlayerTabButton, false)
        ToggleTabButton(VisualTabButton, false)
    end)

    PlayerTabButton.MouseButton1Click:Connect(function()
        AimbotTab.Visible = false
        PlayerTab.Visible = true
        VisualTab.Visible = false
        ToggleTabButton(AimbotTabButton, false)
        ToggleTabButton(PlayerTabButton, true)
        ToggleTabButton(VisualTabButton, false)
    end)

    VisualTabButton.MouseButton1Click:Connect(function()
        AimbotTab.Visible = false
        PlayerTab.Visible = false
        VisualTab.Visible = true
        ToggleTabButton(AimbotTabButton, false)
        ToggleTabButton(PlayerTabButton, false)
        ToggleTabButton(VisualTabButton, true)
    end)

    -- Aimbot Tab Content
    local CamlockCheckBox = Instance.new("TextButton")
    CamlockCheckBox.Size = UDim2.new(0, 30, 0, 30)
    CamlockCheckBox.Position = UDim2.new(0, 10, 0, 10)
    CamlockCheckBox.BackgroundColor3 = SavedSettings.CamLockEnabled and Color3.fromRGB(50, 0, 50) or Color3.fromRGB(80, 0, 80)
    CamlockCheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    CamlockCheckBox.Text = ""
    CamlockCheckBox.TextSize = 24
    CamlockCheckBox.Font = Enum.Font.SourceSansBold
    CamlockCheckBox.AutoButtonColor = false
    CamlockCheckBox.Parent = AimbotTab

    -- CamlockCheckBox için UICorner ekle
    local CamlockCheckBoxCorner = Instance.new("UICorner")
    CamlockCheckBoxCorner.CornerRadius = UDim.new(0, 8)
    CamlockCheckBoxCorner.Parent = CamlockCheckBox

    local CamlockLabel = Instance.new("TextLabel")
    CamlockLabel.Size = UDim2.new(0, 100, 0, 30)
    CamlockLabel.Position = UDim2.new(0, 50, 0, 10)
    CamlockLabel.BackgroundTransparency = 1
    CamlockLabel.Text = "Camlock"
    CamlockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CamlockLabel.TextSize = 18
    CamlockLabel.Font = Enum.Font.SourceSansBold
    CamlockLabel.Parent = AimbotTab

    -- Camlock Keybind Button
    local CamlockKeybindButton = Instance.new("TextButton")
    CamlockKeybindButton.Size = UDim2.new(0, 150, 0, 30)
    CamlockKeybindButton.Position = UDim2.new(0, 10, 0, 50)
    CamlockKeybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CamlockKeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CamlockKeybindButton.Text = "Camlock Key: " .. SavedSettings.CamlockKey
    CamlockKeybindButton.TextSize = 18
    CamlockKeybindButton.Font = Enum.Font.SourceSansBold
    CamlockKeybindButton.Parent = AimbotTab

    -- CamlockKeybindButton için UICorner ekle
    local CamlockKeybindButtonCorner = Instance.new("UICorner")
    CamlockKeybindButtonCorner.CornerRadius = UDim.new(0, 8)
    CamlockKeybindButtonCorner.Parent = CamlockKeybindButton

    -- Camlock Distance TextBox
    local DistanceTextBox = Instance.new("TextBox")
    DistanceTextBox.Size = UDim2.new(0, 150, 0, 30)
    DistanceTextBox.Position = UDim2.new(0, 10, 0, 90)
    DistanceTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    DistanceTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    DistanceTextBox.Text = tostring(SavedSettings.MaxLockDistance)
    DistanceTextBox.TextSize = 18
    DistanceTextBox.Font = Enum.Font.SourceSansBold
    DistanceTextBox.PlaceholderText = "Max Distance (50-500)"
    DistanceTextBox.Parent = AimbotTab

    -- DistanceTextBox için UICorner ekle
    local DistanceTextBoxCorner = Instance.new("UICorner")
    DistanceTextBoxCorner.CornerRadius = UDim.new(0, 8)
    DistanceTextBoxCorner.Parent = DistanceTextBox

    -- Prediction TextBox
    local PredictionTextBox = Instance.new("TextBox")
    PredictionTextBox.Size = UDim2.new(0, 150, 0, 30)
    PredictionTextBox.Position = UDim2.new(0, 10, 0, 130)
    PredictionTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    PredictionTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    PredictionTextBox.Text = tostring(SavedSettings.PredictionValue)
    PredictionTextBox.TextSize = 18
    PredictionTextBox.Font = Enum.Font.SourceSansBold
    PredictionTextBox.PlaceholderText = "Prediction (0.1-1.0)"
    PredictionTextBox.Parent = AimbotTab

    -- PredictionTextBox için UICorner ekle
    local PredictionTextBoxCorner = Instance.new("UICorner")
    PredictionTextBoxCorner.CornerRadius = UDim.new(0, 8)
    PredictionTextBoxCorner.Parent = PredictionTextBox

    -- Update Prediction Value
    PredictionTextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newPrediction = tonumber(PredictionTextBox.Text)
            if newPrediction and newPrediction >= 0.1 and newPrediction <= 1.0 then
                predictionValue = newPrediction
                SavedSettings.PredictionValue = predictionValue
            else
                PredictionTextBox.Text = tostring(predictionValue)  -- Geçersiz değer girilirse eski değeri geri yükle
            end
        end
    end)

    -- Player Tab Content
    local SpeedCheckBox = Instance.new("TextButton")
    SpeedCheckBox.Size = UDim2.new(0, 30, 0, 30)
    SpeedCheckBox.Position = UDim2.new(0, 10, 0, 10)
    SpeedCheckBox.BackgroundColor3 = SavedSettings.SpeedEnabled and Color3.fromRGB(50, 0, 50) or Color3.fromRGB(80, 0, 80)
    SpeedCheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedCheckBox.Text = ""
    SpeedCheckBox.TextSize = 24
    SpeedCheckBox.Font = Enum.Font.SourceSansBold
    SpeedCheckBox.AutoButtonColor = false
    SpeedCheckBox.Parent = PlayerTab

    -- SpeedCheckBox için UICorner ekle
    local SpeedCheckBoxCorner = Instance.new("UICorner")
    SpeedCheckBoxCorner.CornerRadius = UDim.new(0, 8)
    SpeedCheckBoxCorner.Parent = SpeedCheckBox

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0, 100, 0, 30)
    SpeedLabel.Position = UDim2.new(0, 50, 0, 10)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Text = "Speed"
    SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedLabel.TextSize = 18
    SpeedLabel.Font = Enum.Font.SourceSansBold
    SpeedLabel.Parent = PlayerTab

    -- Speed Keybind Button
    local SpeedKeybindButton = Instance.new("TextButton")
    SpeedKeybindButton.Size = UDim2.new(0, 150, 0, 30)
    SpeedKeybindButton.Position = UDim2.new(0, 10, 0, 50)
    SpeedKeybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SpeedKeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedKeybindButton.Text = "Speed Key: " .. SavedSettings.SpeedKey
    SpeedKeybindButton.TextSize = 18
    SpeedKeybindButton.Font = Enum.Font.SourceSansBold
    SpeedKeybindButton.Parent = PlayerTab

    -- SpeedKeybindButton için UICorner ekle
    local SpeedKeybindButtonCorner = Instance.new("UICorner")
    SpeedKeybindButtonCorner.CornerRadius = UDim.new(0, 8)
    SpeedKeybindButtonCorner.Parent = SpeedKeybindButton

    -- Speed Value TextBox
    local SpeedTextBox = Instance.new("TextBox")
    SpeedTextBox.Size = UDim2.new(0, 150, 0, 30)
    SpeedTextBox.Position = UDim2.new(0, 10, 0, 90)
    SpeedTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SpeedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedTextBox.Text = tostring(SavedSettings.SpeedValue)
    SpeedTextBox.TextSize = 18
    SpeedTextBox.Font = Enum.Font.SourceSansBold
    SpeedTextBox.PlaceholderText = "Speed (16-1000)"
    SpeedTextBox.Parent = PlayerTab

    -- SpeedTextBox için UICorner ekle
    local SpeedTextBoxCorner = Instance.new("UICorner")
    SpeedTextBoxCorner.CornerRadius = UDim.new(0, 8)
    SpeedTextBoxCorner.Parent = SpeedTextBox

    -- Visual Tab Content
    local ESPCheckBox = Instance.new("TextButton")
    ESPCheckBox.Size = UDim2.new(0, 30, 0, 30)
    ESPCheckBox.Position = UDim2.new(0, 10, 0, 10)
    ESPCheckBox.BackgroundColor3 = SavedSettings.ESPEnabled and Color3.fromRGB(50, 0, 50) or Color3.fromRGB(80, 0, 80)
    ESPCheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPCheckBox.Text = ""
    ESPCheckBox.TextSize = 24
    ESPCheckBox.Font = Enum.Font.SourceSansBold
    ESPCheckBox.AutoButtonColor = false
    ESPCheckBox.Parent = VisualTab

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
    ESPLabel.Parent = VisualTab

    -- ESP Keybind Button
    local ESPKeybindButton = Instance.new("TextButton")
    ESPKeybindButton.Size = UDim2.new(0, 150, 0, 30)
    ESPKeybindButton.Position = UDim2.new(0, 10, 0, 50)
    ESPKeybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ESPKeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPKeybindButton.Text = "ESP Key: " .. SavedSettings.ESPKey
    ESPKeybindButton.TextSize = 18
    ESPKeybindButton.Font = Enum.Font.SourceSansBold
    ESPKeybindButton.Parent = VisualTab

    -- ESPKeybindButton için UICorner ekle
    local ESPKeybindButtonCorner = Instance.new("UICorner")
    ESPKeybindButtonCorner.CornerRadius = UDim.new(0, 8)
    ESPKeybindButtonCorner.Parent = ESPKeybindButton

    -- Skeleton ESP CheckBox
    local SkeletonESPCheckBox = Instance.new("TextButton")
    SkeletonESPCheckBox.Size = UDim2.new(0, 30, 0, 30)
    SkeletonESPCheckBox.Position = UDim2.new(0, 10, 0, 90)
    SkeletonESPCheckBox.BackgroundColor3 = SavedSettings.SkeletonESPEnabled and Color3.fromRGB(50, 0, 50) or Color3.fromRGB(80, 0, 80)
    SkeletonESPCheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SkeletonESPCheckBox.Text = ""
    SkeletonESPCheckBox.TextSize = 24
    SkeletonESPCheckBox.Font = Enum.Font.SourceSansBold
    SkeletonESPCheckBox.AutoButtonColor = false
    SkeletonESPCheckBox.Parent = VisualTab

    -- SkeletonESPCheckBox için UICorner ekle
    local SkeletonESPCheckBoxCorner = Instance.new("UICorner")
    SkeletonESPCheckBoxCorner.CornerRadius = UDim.new(0, 8)
    SkeletonESPCheckBoxCorner.Parent = SkeletonESPCheckBox

    local SkeletonESPLabel = Instance.new("TextLabel")
    SkeletonESPLabel.Size = UDim2.new(0, 100, 0, 30)
    SkeletonESPLabel.Position = UDim2.new(0, 50, 0, 90)
    SkeletonESPLabel.BackgroundTransparency = 1
    SkeletonESPLabel.Text = "Skeleton ESP"
    SkeletonESPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SkeletonESPLabel.TextSize = 18
    SkeletonESPLabel.Font = Enum.Font.SourceSansBold
    SkeletonESPLabel.Parent = VisualTab

    -- Health Bar CheckBox
    local HealthBarCheckBox = Instance.new("TextButton")
    HealthBarCheckBox.Size = UDim2.new(0, 30, 0, 30)
    HealthBarCheckBox.Position = UDim2.new(0, 10, 0, 130)
    HealthBarCheckBox.BackgroundColor3 = SavedSettings.HealthBarEnabled and Color3.fromRGB(50, 0, 50) or Color3.fromRGB(80, 0, 80)
    HealthBarCheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    HealthBarCheckBox.Text = ""
    HealthBarCheckBox.TextSize = 24
    HealthBarCheckBox.Font = Enum.Font.SourceSansBold
    HealthBarCheckBox.AutoButtonColor = false
    HealthBarCheckBox.Parent = VisualTab

    -- HealthBarCheckBox için UICorner ekle
    local HealthBarCheckBoxCorner = Instance.new("UICorner")
    HealthBarCheckBoxCorner.CornerRadius = UDim.new(0, 8)
    HealthBarCheckBoxCorner.Parent = HealthBarCheckBox

    local HealthBarLabel = Instance.new("TextLabel")
    HealthBarLabel.Size = UDim2.new(0, 100, 0, 30)
    HealthBarLabel.Position = UDim2.new(0, 50, 0, 130)
    HealthBarLabel.BackgroundTransparency = 1
    HealthBarLabel.Text = "Health Bar"
    HealthBarLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    HealthBarLabel.TextSize = 18
    HealthBarLabel.Font = Enum.Font.SourceSansBold
    HealthBarLabel.Parent = VisualTab

    -- Distance ESP CheckBox
    local DistanceESPCheckBox = Instance.new("TextButton")
    DistanceESPCheckBox.Size = UDim2.new(0, 30, 0, 30)
    DistanceESPCheckBox.Position = UDim2.new(0, 10, 0, 170)
    DistanceESPCheckBox.BackgroundColor3 = SavedSettings.DistanceESPEnabled and Color3.fromRGB(50, 0, 50) or Color3.fromRGB(80, 0, 80)
    DistanceESPCheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    DistanceESPCheckBox.Text = ""
    DistanceESPCheckBox.TextSize = 24
    DistanceESPCheckBox.Font = Enum.Font.SourceSansBold
    DistanceESPCheckBox.AutoButtonColor = false
    DistanceESPCheckBox.Parent = VisualTab

    -- DistanceESPCheckBox için UICorner ekle
    local DistanceESPCheckBoxCorner = Instance.new("UICorner")
    DistanceESPCheckBoxCorner.CornerRadius = UDim.new(0, 8)
    DistanceESPCheckBoxCorner.Parent = DistanceESPCheckBox

    local DistanceESPLabel = Instance.new("TextLabel")
    DistanceESPLabel.Size = UDim2.new(0, 100, 0, 30)
    DistanceESPLabel.Position = UDim2.new(0, 50, 0, 170)
    DistanceESPLabel.BackgroundTransparency = 1
    DistanceESPLabel.Text = "Distance ESP"
    DistanceESPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DistanceESPLabel.TextSize = 18
    DistanceESPLabel.Font = Enum.Font.SourceSansBold
    DistanceESPLabel.Parent = VisualTab

    -- Trace ESP CheckBox
    local TraceESPCheckBox = Instance.new("TextButton")
    TraceESPCheckBox.Size = UDim2.new(0, 30, 0, 30)
    TraceESPCheckBox.Position = UDim2.new(0, 10, 0, 210)
    TraceESPCheckBox.BackgroundColor3 = SavedSettings.TraceESPEnabled and Color3.fromRGB(50, 0, 50) or Color3.fromRGB(80, 0, 80)
    TraceESPCheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TraceESPCheckBox.Text = ""
    TraceESPCheckBox.TextSize = 24
    TraceESPCheckBox.Font = Enum.Font.SourceSansBold
    TraceESPCheckBox.AutoButtonColor = false
    TraceESPCheckBox.Parent = VisualTab

    -- TraceESPCheckBox için UICorner ekle
    local TraceESPCheckBoxCorner = Instance.new("UICorner")
    TraceESPCheckBoxCorner.CornerRadius = UDim.new(0, 8)
    TraceESPCheckBoxCorner.Parent = TraceESPCheckBox

    local TraceESPLabel = Instance.new("TextLabel")
    TraceESPLabel.Size = UDim2.new(0, 100, 0, 30)
    TraceESPLabel.Position = UDim2.new(0, 50, 0, 210)
    TraceESPLabel.BackgroundTransparency = 1
    TraceESPLabel.Text = "Trace ESP"
    TraceESPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TraceESPLabel.TextSize = 18
    TraceESPLabel.Font = Enum.Font.SourceSansBold
    TraceESPLabel.Parent = VisualTab

    -- Toggle Checkmark Function
    local function ToggleCheckmark(button, isChecked)
        local targetColor = isChecked and Color3.fromRGB(50, 0, 50) or Color3.fromRGB(80, 0, 80)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = targetColor})
        tween:Play()
    end

    -- ESP CheckBox Functionality
    ESPCheckBox.MouseButton1Click:Connect(function()
        isESPEnabled = not isESPEnabled
        SavedSettings.ESPEnabled = isESPEnabled
        ToggleCheckmark(ESPCheckBox, isESPEnabled)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                coroutine.wrap(ESP)(player)
            end
        end
    end)

    -- Skeleton ESP CheckBox Functionality
    SkeletonESPCheckBox.MouseButton1Click:Connect(function()
        isSkeletonESPEnabled = not isSkeletonESPEnabled
        SavedSettings.SkeletonESPEnabled = isSkeletonESPEnabled
        ToggleCheckmark(SkeletonESPCheckBox, isSkeletonESPEnabled)
    end)

    -- Health Bar CheckBox Functionality
    HealthBarCheckBox.MouseButton1Click:Connect(function()
        isHealthBarEnabled = not isHealthBarEnabled
        SavedSettings.HealthBarEnabled = isHealthBarEnabled
        ToggleCheckmark(HealthBarCheckBox, isHealthBarEnabled)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                coroutine.wrap(ESP)(player)
            end
        end
    end)

    -- Distance ESP CheckBox Functionality
    DistanceESPCheckBox.MouseButton1Click:Connect(function()
        isDistanceESPEnabled = not isDistanceESPEnabled
        SavedSettings.DistanceESPEnabled = isDistanceESPEnabled
        ToggleCheckmark(DistanceESPCheckBox, isDistanceESPEnabled)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                coroutine.wrap(ESP)(player)
            end
        end
    end)

    -- Trace ESP CheckBox Functionality
    TraceESPCheckBox.MouseButton1Click:Connect(function()
        isTraceESPEnabled = not isTraceESPEnabled
        SavedSettings.TraceESPEnabled = isTraceESPEnabled
        ToggleCheckmark(TraceESPCheckBox, isTraceESPEnabled)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                coroutine.wrap(ESP)(player)
            end
        end
    end)

    -- Camlock CheckBox Functionality
    CamlockCheckBox.MouseButton1Click:Connect(function()
        isCamLockEnabled = not isCamLockEnabled
        SavedSettings.CamLockEnabled = isCamLockEnabled
        ToggleCheckmark(CamlockCheckBox, isCamLockEnabled)
    end)

    -- Speed CheckBox Functionality
    SpeedCheckBox.MouseButton1Click:Connect(function()
        isSpeedEnabled = not isSpeedEnabled
        SavedSettings.SpeedEnabled = isSpeedEnabled
        ToggleCheckmark(SpeedCheckBox, isSpeedEnabled)
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
    SpeedTextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newSpeed = tonumber(SpeedTextBox.Text)
            if newSpeed and newSpeed >= 16 and newSpeed <= 1000 then
                speedValue = newSpeed
                SavedSettings.SpeedValue = speedValue
            else
                SpeedTextBox.Text = tostring(speedValue)  -- Restore old value if invalid
            end
        end
    end)

    -- Keybind Assignment Functionality
    local function AssignKeybind(button, keybindType)
        button.Text = "Press any key..."
        local inputConnection
        inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed then
                local key = input.KeyCode.Name
                if keybindType == "Camlock" then
                    camlockKey = input.KeyCode
                    SavedSettings.CamlockKey = key
                    button.Text = "Camlock Key: " .. key
                elseif keybindType == "Speed" then
                    speedKey = input.KeyCode
                    SavedSettings.SpeedKey = key
                    button.Text = "Speed Key: " .. key
                elseif keybindType == "ESP" then
                    espKey = input.KeyCode
                    SavedSettings.ESPKey = key
                    button.Text = "ESP Key: " .. key
                end
                inputConnection:Disconnect()
            end
        end)
    end

    -- Camlock Keybind Button Functionality
    CamlockKeybindButton.MouseButton1Click:Connect(function()
        AssignKeybind(CamlockKeybindButton, "Camlock")
    end)

    -- Speed Keybind Button Functionality
    SpeedKeybindButton.MouseButton1Click:Connect(function()
        AssignKeybind(SpeedKeybindButton, "Speed")
    end)

    -- ESP Keybind Button Functionality
    ESPKeybindButton.MouseButton1Click:Connect(function()
        AssignKeybind(ESPKeybindButton, "ESP")
    end)

    -- GUI'yi tutma ve kaydırma fonksiyonları
    local dragging = false
    local dragInput, dragStart, startPos

    local function UpdateInput(input)
        local delta = input.Position - dragStart
        local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        
        -- Smooth hareket için TweenService kullan
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(MainFrame, tweenInfo, {Position = newPosition})
        tween:Play()
    end

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            UpdateInput(input)
        end
    end)

    -- Renk seçici butonlarını ekle
    local ESPColorPickerButton = Instance.new("TextButton")
    ESPColorPickerButton.Size = UDim2.new(0, 30, 0, 30)
    ESPColorPickerButton.Position = UDim2.new(0, 160, 0, 10)
    ESPColorPickerButton.BackgroundColor3 = SavedSettings.ESPColor
    ESPColorPickerButton.Text = ""
    ESPColorPickerButton.Parent = VisualTab

    -- UICorner ekleyerek kenarları oval yap
    local ESPColorPickerCorner = Instance.new("UICorner")
    ESPColorPickerCorner.CornerRadius = UDim.new(0, 8)
    ESPColorPickerCorner.Parent = ESPColorPickerButton

    CreateColorPicker(VisualTab, UDim2.new(0, 160, 0, 10), SavedSettings.ESPColor, function(color)
        SavedSettings.ESPColor = color
        UpdateESPColors()  -- Tüm ESP çizimlerini güncelle
    end)

    local SkeletonESPColorPickerButton = Instance.new("TextButton")
    SkeletonESPColorPickerButton.Size = UDim2.new(0, 30, 0, 30)
    SkeletonESPColorPickerButton.Position = UDim2.new(0, 160, 0, 90)
    SkeletonESPColorPickerButton.BackgroundColor3 = SavedSettings.SkeletonESPColor
    SkeletonESPColorPickerButton.Text = ""
    SkeletonESPColorPickerButton.Parent = VisualTab

    -- UICorner ekleyerek kenarları oval yap
    local SkeletonESPColorPickerCorner = Instance.new("UICorner")
    SkeletonESPColorPickerCorner.CornerRadius = UDim.new(0, 8)
    SkeletonESPColorPickerCorner.Parent = SkeletonESPColorPickerButton

    CreateColorPicker(VisualTab, UDim2.new(0, 160, 0, 90), SavedSettings.SkeletonESPColor, function(color)
        SavedSettings.SkeletonESPColor = color
    end)

    local HealthBarColorPickerButton = Instance.new("TextButton")
    HealthBarColorPickerButton.Size = UDim2.new(0, 30, 0, 30)
    HealthBarColorPickerButton.Position = UDim2.new(0, 160, 0, 130)
    HealthBarColorPickerButton.BackgroundColor3 = SavedSettings.HealthBarColor
    HealthBarColorPickerButton.Text = ""
    HealthBarColorPickerButton.Parent = VisualTab

    -- UICorner ekleyerek kenarları oval yap
    local HealthBarColorPickerCorner = Instance.new("UICorner")
    HealthBarColorPickerCorner.CornerRadius = UDim.new(0, 8)
    HealthBarColorPickerCorner.Parent = HealthBarColorPickerButton

    CreateColorPicker(VisualTab, UDim2.new(0, 160, 0, 130), SavedSettings.HealthBarColor, function(color)
        SavedSettings.HealthBarColor = color
        UpdateESPColors()  -- Tüm ESP çizimlerini güncelle
    end)

    local DistanceESPColorPickerButton = Instance.new("TextButton")
    DistanceESPColorPickerButton.Size = UDim2.new(0, 30, 0, 30)
    DistanceESPColorPickerButton.Position = UDim2.new(0, 160, 0, 170)
    DistanceESPColorPickerButton.BackgroundColor3 = SavedSettings.DistanceESPColor
    DistanceESPColorPickerButton.Text = ""
    DistanceESPColorPickerButton.Parent = VisualTab

    -- UICorner ekleyerek kenarları oval yap
    local DistanceESPColorPickerCorner = Instance.new("UICorner")
    DistanceESPColorPickerCorner.CornerRadius = UDim.new(0, 8)
    DistanceESPColorPickerCorner.Parent = DistanceESPColorPickerButton

    CreateColorPicker(VisualTab, UDim2.new(0, 160, 0, 170), SavedSettings.DistanceESPColor, function(color)
        SavedSettings.DistanceESPColor = color
        UpdateESPColors()  -- Tüm ESP çizimlerini güncelle
    end)

    local TraceESPColorPickerButton = Instance.new("TextButton")
    TraceESPColorPickerButton.Size = UDim2.new(0, 30, 0, 30)
    TraceESPColorPickerButton.Position = UDim2.new(0, 160, 0, 210)
    TraceESPColorPickerButton.BackgroundColor3 = SavedSettings.TraceESPColor
    TraceESPColorPickerButton.Text = ""
    TraceESPColorPickerButton.Parent = VisualTab

    -- UICorner ekleyerek kenarları oval yap
    local TraceESPColorPickerCorner = Instance.new("UICorner")
    TraceESPColorPickerCorner.CornerRadius = UDim.new(0, 8)
    TraceESPColorPickerCorner.Parent = TraceESPColorPickerButton

    CreateColorPicker(VisualTab, UDim2.new(0, 160, 0, 210), SavedSettings.TraceESPColor, function(color)
        SavedSettings.TraceESPColor = color
        UpdateESPColors()  -- Tüm ESP çizimlerini güncelle
    end)

    -- Camlock Highlight Color Picker
    local CamlockHighlightColorPickerButton = Instance.new("TextButton")
    CamlockHighlightColorPickerButton.Size = UDim2.new(0, 30, 0, 30)
    CamlockHighlightColorPickerButton.Position = UDim2.new(0, 160, 0, 10)
    CamlockHighlightColorPickerButton.BackgroundColor3 = SavedSettings.CamlockHighlightColor
    CamlockHighlightColorPickerButton.Text = ""
    CamlockHighlightColorPickerButton.Parent = AimbotTab

    -- UICorner ekleyerek kenarları oval yap
    local CamlockHighlightColorPickerCorner = Instance.new("UICorner")
    CamlockHighlightColorPickerCorner.CornerRadius = UDim.new(0, 8)
    CamlockHighlightColorPickerCorner.Parent = CamlockHighlightColorPickerButton

    CreateColorPicker(AimbotTab, UDim2.new(0, 160, 0, 10), SavedSettings.CamlockHighlightColor, function(color)
        SavedSettings.CamlockHighlightColor = color
        highlight.FillColor = color
    end)
end

-- Toggle GUI with Home Key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        SavedSettings.GUIVisible = not SavedSettings.GUIVisible
        MainFrame.Visible = SavedSettings.GUIVisible
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

local function ESP(plr)
    if ESPTable[plr] then
        return
    end

    local library = {
        name = Drawing.new("Text"),
        healthbar = Drawing.new("Line"),
        greenhealth = Drawing.new("Line"),
        distance = Drawing.new("Text"),  -- Distance ESP için
        trace = Drawing.new("Line")  -- Trace ESP için
    }

    ESPTable[plr] = library

    -- ESP ismi sadece ESP checkbox işaretliyse gösterilsin
    library.name.Visible = isESPEnabled and SavedSettings.ESPEnabled
    library.name.Color = SavedSettings.ESPColor  -- Kullanıcının seçtiği renk
    library.name.Size = 18
    library.name.Center = true
    library.name.Outline = true
    library.name.OutlineColor = Color3.new(0, 0, 0)
    library.name.Text = plr.Name

    -- Health Bar sadece Health Bar checkbox işaretliyse gösterilsin
    library.healthbar.Visible = isHealthBarEnabled and SavedSettings.HealthBarEnabled
    library.healthbar.Color = SavedSettings.HealthBarColor
    library.healthbar.Thickness = 2

    library.greenhealth.Visible = isHealthBarEnabled and SavedSettings.HealthBarEnabled
    library.greenhealth.Color = SavedSettings.HealthBarColor
    library.greenhealth.Thickness = 2

    -- Distance ESP sadece Distance ESP checkbox işaretliyse gösterilsin
    library.distance.Visible = isDistanceESPEnabled and SavedSettings.DistanceESPEnabled
    library.distance.Color = SavedSettings.DistanceESPColor
    library.distance.Size = 18
    library.distance.Center = true
    library.distance.Outline = true
    library.distance.OutlineColor = Color3.new(0, 0, 0)

    -- Trace ESP sadece Trace ESP checkbox işaretliyse gösterilsin
    library.trace.Visible = isTraceESPEnabled and SavedSettings.TraceESPEnabled
    library.trace.Color = SavedSettings.TraceESPColor
    library.trace.Thickness = 1

    local function Updater()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = plr.Character.HumanoidRootPart
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude

                -- Sadece 500 metre içindeki oyuncular için ESP çiz
                if distance <= 500 then
                    local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

                    if onScreen then
                        -- ESP ismi sadece ESP checkbox işaretliyse gösterilsin
                        library.name.Position = Vector2.new(rootPos.X, rootPos.Y - 30)
                        library.name.Visible = isESPEnabled and SavedSettings.ESPEnabled

                        -- Health Bar sadece Health Bar checkbox işaretliyse gösterilsin
                        if isHealthBarEnabled and SavedSettings.HealthBarEnabled then
                            local health = plr.Character.Humanoid.Health
                            local maxHealth = plr.Character.Humanoid.MaxHealth
                            local healthPercentage = health / maxHealth
                            local barHeight = 50
                            local barWidth = 4
                            local barOffset = Vector2.new(rootPos.X - 30, rootPos.Y - barHeight / 2)

                            -- Kırmızı arka plan
                            library.healthbar.From = barOffset
                            library.healthbar.To = Vector2.new(barOffset.X, barOffset.Y + barHeight)
                            library.healthbar.Visible = true

                            -- Yeşil sağlık çubuğu
                            library.greenhealth.From = barOffset
                            library.greenhealth.To = Vector2.new(barOffset.X, barOffset.Y + barHeight * healthPercentage)
                            library.greenhealth.Visible = true
                        else
                            library.healthbar.Visible = false
                            library.greenhealth.Visible = false
                        end

                        -- Distance ESP sadece Distance ESP checkbox işaretliyse gösterilsin
                        if isDistanceESPEnabled and SavedSettings.DistanceESPEnabled then
                            library.distance.Text = tostring(math.floor(distance)) .. "m"
                            library.distance.Position = Vector2.new(rootPos.X, rootPos.Y + 20)
                            library.distance.Visible = true
                        else
                            library.distance.Visible = false
                        end

                        -- Trace ESP sadece Trace ESP checkbox işaretliyse gösterilsin
                        if isTraceESPEnabled and SavedSettings.TraceESPEnabled then
                            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            library.trace.From = screenCenter
                            library.trace.To = Vector2.new(rootPos.X, rootPos.Y)
                            library.trace.Visible = true
                        else
                            library.trace.Visible = false
                        end
                    else
                        library.name.Visible = false
                        library.healthbar.Visible = false
                        library.greenhealth.Visible = false
                        library.distance.Visible = false
                        library.trace.Visible = false
                    end
                else
                    library.name.Visible = false
                    library.healthbar.Visible = false
                    library.greenhealth.Visible = false
                    library.distance.Visible = false
                    library.trace.Visible = false
                end
            else
                library.name.Visible = false
                library.healthbar.Visible = false
                library.greenhealth.Visible = false
                library.distance.Visible = false
                library.trace.Visible = false
                if not Players:FindFirstChild(plr.Name) then
                    connection:Disconnect()
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

-- ESP'yi kapatma fonksiyonu
local function ClearESP(plr)
    if ESPTable[plr] then
        for _, drawing in pairs(ESPTable[plr]) do
            drawing:Remove()  -- Drawing objelerini temizle
        end
        ESPTable[plr] = nil  -- Tablodan kaldır
    end
end

-- Tüm ESP'leri temizleme fonksiyonu
local function ClearAllESP()
    for plr, _ in pairs(ESPTable) do
        ClearESP(plr)
    end
end

-- Skeleton ESP Functionality
local function DrawSkeleton(character)
    local boneConnections = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"RightLowerLeg", "RightFoot"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"RightLowerArm", "RightHand"}
    }

    local lines = {}
    for _, bone in pairs(boneConnections) do
        local part1 = character:FindFirstChild(bone[1])
        local part2 = character:FindFirstChild(bone[2])
        if part1 and part2 then
            local line = Drawing.new("Line")
            line.Visible = isSkeletonESPEnabled and SavedSettings.SkeletonESPEnabled
            line.Color = SavedSettings.SkeletonESPColor
            line.Thickness = 2
            table.insert(lines, {line = line, part1 = part1, part2 = part2})
        end
    end

    local function UpdateSkeleton()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if isSkeletonESPEnabled and SavedSettings.SkeletonESPEnabled then
                for _, data in pairs(lines) do
                    local part1 = data.part1
                    local part2 = data.part2
                    local line = data.line

                    if part1 and part2 and part1.Parent and part2.Parent then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - part1.Position).Magnitude

                        -- Sadece 500 metre içindeki oyuncular için Skeleton ESP çiz
                        if distance <= 500 then
                            local screenPoint1, onScreen1 = Camera:WorldToViewportPoint(part1.Position)
                            local screenPoint2, onScreen2 = Camera:WorldToViewportPoint(part2.Position)
                            if onScreen1 and onScreen2 then
                                line.From = Vector2.new(screenPoint1.X, screenPoint1.Y)
                                line.To = Vector2.new(screenPoint2.X, screenPoint2.Y)
                                line.Visible = true
                            else
                                line.Visible = false
                            end
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                end
            else
                for _, data in pairs(lines) do
                    data.line.Visible = false
                end
            end
        end)
    end

    coroutine.wrap(UpdateSkeleton)()
end

-- Apply Skeleton ESP to all players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        DrawSkeleton(player.Character)
    end
end

-- Apply Skeleton ESP to new players
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            DrawSkeleton(character)
        end)
    end
end)

-- Camlock Functionality with Prediction
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

-- Toggle Camlock on Key Press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == camlockKey and isCamLockEnabled then
        if lockedTarget then
            highlight.Parent = nil
            lockedTarget = nil
        else
            lockedTarget = GetClosestPlayer()
            if lockedTarget and lockedTarget.Character then
                highlight.Parent = lockedTarget.Character
            end
        end
    end
end)

-- Update Camlock with Prediction
RunService.RenderStepped:Connect(function()
    if isCamLockEnabled and lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild(lockBodyPart) then
        local humanoid = lockedTarget.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            local targetPosition = lockedTarget.Character[lockBodyPart].Position
            
            -- Prediction hesaplaması
            local targetVelocity = lockedTarget.Character[lockBodyPart].Velocity
            local predictedPosition = targetPosition + (targetVelocity * predictionValue)
            
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPosition)
        else
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

-- Toggle Speed on Key Press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == speedKey and isSpeedEnabled then
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

-- Toggle ESP on Key Press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == espKey then
        -- Sadece checkbox işaretliyse ESP'yi aç/kapa
        if SavedSettings.ESPEnabled then
            isESPEnabled = not isESPEnabled
        end

        -- Sadece checkbox işaretliyse Skeleton ESP'yi aç/kapa
        if SavedSettings.SkeletonESPEnabled then
            isSkeletonESPEnabled = not isSkeletonESPEnabled
        end

        -- Sadece checkbox işaretliyse Health Bar'ı aç/kapa
        if SavedSettings.HealthBarEnabled then
            isHealthBarEnabled = not isHealthBarEnabled
        end

        -- Sadece checkbox işaretliyse Distance ESP'yi aç/kapa
        if SavedSettings.DistanceESPEnabled then
            isDistanceESPEnabled = not isDistanceESPEnabled
        end

        -- Sadece checkbox işaretliyse Trace ESP'yi aç/kapa
        if SavedSettings.TraceESPEnabled then
            isTraceESPEnabled = not isTraceESPEnabled
        end

        -- Tüm ESP'leri güncelle
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                coroutine.wrap(ESP)(player)
            end
        end
    end
end)
