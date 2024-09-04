-- Определение основных сервисов
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService") -- Для обновления данных каждую отрисовку кадра
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Создание ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NotificationGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Создание главного фрейма для уведомления
local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0, 300, 0, 50) -- Начальный размер
notificationFrame.Position = UDim2.new(1, 0, 0, 20) -- Начальная позиция за границей экрана
notificationFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Черный цвет фона
notificationFrame.BackgroundTransparency = 0.5 -- Прозрачность фона 0.5
notificationFrame.BorderSizePixel = 0 -- Без границы
notificationFrame.Visible = false
notificationFrame.Parent = screenGui

-- Создание значка уведомления
local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(0, 40, 0, 40) -- Размер значка
iconText.Position = UDim2.new(0, 10, 0, 5) -- Отступы для центрирования по высоте
iconText.BackgroundTransparency = 1 -- Прозрачный фон
iconText.Text = "!" -- Символ восклицательного знака
iconText.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый цвет текста
iconText.TextScaled = true -- Автоматическое масштабирование текста
iconText.Font = Enum.Font.SourceSansBold -- Жирный шрифт
iconText.TextXAlignment = Enum.TextXAlignment.Center -- Центрирование текста
iconText.TextYAlignment = Enum.TextYAlignment.Center -- Центрирование текста по вертикали
iconText.Parent = notificationFrame

-- Создание основного текста уведомления
local mainText = Instance.new("TextLabel")
mainText.Size = UDim2.new(0, 230, 0, 20) -- Начальный размер текстового поля
mainText.Position = UDim2.new(0, 60, 0, 5)
mainText.BackgroundTransparency = 1
mainText.Text = "Flashback: Entity detected!"
mainText.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый цвет текста
mainText.TextSize = 14
mainText.Font = Enum.Font.GothamSemibold -- Более стильный, не вытянутый шрифт
mainText.TextXAlignment = Enum.TextXAlignment.Left
mainText.Parent = notificationFrame

-- Создание дополнительного текста под основным
local subText = Instance.new("TextLabel")
subText.Size = UDim2.new(0, 220, 0, 20) -- Уменьшена ширина текстового поля, чтобы добавить отступ справа
subText.Position = UDim2.new(0, 60, 0, 25) -- Нижний текст с отступом слева 60 пикселей
subText.BackgroundTransparency = 1
subText.Text = "Find a hiding spot!"
subText.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый цвет текста
subText.TextSize = 14
subText.Font = Enum.Font.SourceSans
subText.TextXAlignment = Enum.TextXAlignment.Left
subText.TextTruncate = Enum.TextTruncate.AtEnd -- Убираем текст в конце при нехватке места
subText.Parent = notificationFrame

-- Создание маленькой белой полоски заполнения
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 0, 3) -- Полоска очень маленькая по высоте
progressBar.Position = UDim2.new(0, 0, 1, -3) -- Полоска внизу фрейма
progressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Белый цвет полоски
progressBar.BorderSizePixel = 0
progressBar.Parent = notificationFrame

-- Добавление звука уведомления
local notificationSound = Instance.new("Sound")
notificationSound.SoundId = "rbxassetid://4590657391" -- ID звука
notificationSound.Volume = 1
notificationSound.Parent = screenGui

-- Текстовая метка для отображения версии Flashback
local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(0, 150, 0, 20)
versionText.Position = UDim2.new(1, -160, 1, -30) -- Позиция в правом нижнем углу
versionText.BackgroundTransparency = 1
versionText.Text = "Flashback - 1.0"
versionText.TextColor3 = Color3.fromRGB(169, 169, 169) -- Серый цвет текста
versionText.TextSize = 12
versionText.Font = Enum.Font.SourceSans
versionText.TextXAlignment = Enum.TextXAlignment.Right
versionText.Parent = screenGui

-- Переменные для отслеживания состояния
local isNotificationOpen = false
local progressTime = 0
local progressDuration = 5 -- Продолжительность таймера для закрытия уведомления
local timerStarted = false

-- Функция отображения уведомления
local function openNotification(entityName)
    if not isNotificationOpen then
        isNotificationOpen = true
        mainText.Text = "Flashback: " .. entityName .. " detected!" -- Устанавливаем текст уведомления
        notificationFrame.Visible = true
        notificationSound:Play() -- Воспроизведение звука

        -- Анимация появления
        local targetPosition = UDim2.new(1, -notificationFrame.Size.X.Offset, 0, 20)
        local tween = TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPosition})
        tween:Play()

        -- Запуск таймера
        progressTime = 0
        timerStarted = true
    end
end

-- Функция закрытия уведомления
local function closeNotification()
    if isNotificationOpen then
        isNotificationOpen = false
        timerStarted = false -- Останавливаем таймер
        local targetPosition = UDim2.new(1, 0, 0, 20)
        local tween = TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPosition})
        tween:Play()

        -- Сброс полоски заполнения
        progressBar.Size = UDim2.new(0, 0, 0, 3)
    end
end

-- Функция обновления таймера и полоски
local function updateTimer(deltaTime)
    if timerStarted then
        progressTime = progressTime + deltaTime
        local progressRatio = progressTime / progressDuration
        progressBar.Size = UDim2.new(progressRatio, 0, 0, 3)

        if progressTime >= progressDuration then
            closeNotification() -- Закрываем уведомление, когда таймер истечет
        end
    end
end

-- Подключаем функцию обновления таймера к событию RenderStepped
RunService.RenderStepped:Connect(updateTimer)

-- Обработчик появления объектов в Workspace
Workspace.ChildAdded:Connect(function(child)
    local childName = child.Name:lower() -- Приводим к нижнему регистру для удобства
    if childName == "rush" then
        openNotification("Rush")
    elseif childName == "ambush" then
        openNotification("Ambush")
    elseif childName == "figure" then
        openNotification("Figure")
    end
end)

-- Показать уведомление "LOADED" при запуске скрипта
openNotification("LOADED")
