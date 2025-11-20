--[[
    Tokyo UI Library - Повний приклад використання
    
    Цей файл демонструє всі можливості бібліотеки
]]

-- Завантажити бібліотеку
local Library = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()

print("Tokyo UI Library завантажено!")

-- ============================================
-- СТВОРЕННЯ ВІКНА
-- ============================================

local Window = Library:NewWindow({
    title = "Tokyo UI - Демонстрація",
    size = UDim2.new(0, 525, 0, 650),
    position = UDim2.new(0, 250, 0, 150)
})

-- ============================================
-- ТАБ 1: ОСНОВНІ КОМПОНЕНТИ
-- ============================================

local ComponentsTab = Window:AddTab("Компоненти", 1)

-- Ліва колонка
local ToggleSection = ComponentsTab:AddSection("Toggles & Colors", 1, 1)

-- Простий Toggle
local SimpleToggle = ToggleSection:AddToggle({
    text = "Простий Toggle",
    flag = "simpleToggle",
    state = false,
    callback = function(state)
        print("Simple Toggle:", state)
    end
})

-- Toggle з Color Picker
local ColorToggle = ToggleSection:AddToggle({
    text = "Toggle з кольором",
    flag = "colorToggle",
    state = true,
    callback = function(state)
        print("Color Toggle:", state)
    end
})

local MyColor = ColorToggle:AddColor({
    flag = "myColor",
    color = Color3.fromRGB(150, 100, 255),
    trans = 0,
    callback = function(color, trans)
        print("Колір змінено:", color, "Прозорість:", trans)
    end
})

-- Toggle з Keybind
local BindToggle = ToggleSection:AddToggle({
    text = "Toggle з клавішею",
    flag = "bindToggle",
    state = false,
    callback = function(state)
        print("Bind Toggle:", state)
    end
})

local MyBind = BindToggle:AddBind({
    flag = "myBind",
    bind = Enum.KeyCode.E,
    mode = "toggle",
    callback = function(state)
        print("Клавішу натиснуто! Стан:", state)
    end,
    keycallback = function(key)
        print("Нова клавіша встановлена:", key)
    end
})

-- Toggle зі Slider
local SliderToggle = ToggleSection:AddToggle({
    text = "Toggle зі slider",
    flag = "sliderToggle",
    state = false,
    callback = function(state)
        print("Slider Toggle:", state)
    end
})

SliderToggle:AddSlider({
    flag = "embeddedSlider",
    min = 0,
    max = 100,
    value = 50,
    increment = 5,
    suffix = "%",
    callback = function(value)
        print("Embedded Slider:", value)
    end
})

-- Toggle зі списком
local ListToggle = ToggleSection:AddToggle({
    text = "Toggle зі списком",
    flag = "listToggle",
    state = false,
    callback = function(state)
        print("List Toggle:", state)
    end
})

ListToggle:AddList({
    flag = "embeddedList",
    values = {"Швидко", "Середньо", "Повільно"},
    selected = "Середньо",
    multi = false,
    callback = function(selected)
        print("Вибрано:", selected)
    end
})

-- Risky Toggle
local RiskyToggle = ToggleSection:AddToggle({
    text = "Небезпечна функція",
    flag = "riskyToggle",
    risky = true,
    state = false,
    callback = function(state)
        print("Risky Toggle:", state)
    end
})

-- Права колонка
local SliderSection = ComponentsTab:AddSection("Sliders & Inputs", 2, 1)

-- Звичайний Slider
local NormalSlider = SliderSection:AddSlider({
    text = "Швидкість",
    flag = "speedSlider",
    min = 0,
    max = 200,
    value = 16,
    increment = 1,
    suffix = " studs/s",
    callback = function(value)
        print("Швидкість:", value)
    end
})

-- Slider з від'ємними значеннями
local NegativeSlider = SliderSection:AddSlider({
    text = "Баланс",
    flag = "balanceSlider",
    min = -100,
    max = 100,
    value = 0,
    increment = 10,
    callback = function(value)
        print("Баланс:", value)
    end
})

-- Risky Slider
local DangerSlider = SliderSection:AddSlider({
    text = "Критична потужність",
    flag = "dangerSlider",
    min = 0,
    max = 1000,
    value = 100,
    increment = 50,
    risky = true,
    callback = function(value)
        print("Критична потужність:", value)
    end
})

-- TextBox
local NameBox = SliderSection:AddBox({
    text = "Ваше ім'я",
    flag = "nameBox",
    input = "Player123",
    callback = function(text)
        print("Ім'я змінено на:", text)
    end
})

-- Risky TextBox
local CommandBox = SliderSection:AddBox({
    text = "Команда",
    flag = "commandBox",
    input = "",
    risky = true,
    callback = function(text)
        print("Команда:", text)
    end
})

-- ============================================
-- ТАБ 2: КНОПКИ ТА СПИСКИ
-- ============================================

local ButtonsTab = Window:AddTab("Кнопки", 2)

-- Ліва колонка - Кнопки
local ButtonSection = ButtonsTab:AddSection("Різні кнопки", 1, 1)

-- Звичайна кнопка
local NormalButton = ButtonSection:AddButton({
    text = "Натисни мене",
    flag = "normalButton",
    callback = function()
        print("Кнопку натиснуто!")
    end
})

-- Кнопка з підтвердженням
local ConfirmButton = ButtonSection:AddButton({
    text = "Очистити все",
    flag = "confirmButton",
    confirm = true,
    callback = function()
        print("Підтверджено очищення!")
    end
})

-- Risky кнопка
local DangerButton = ButtonSection:AddButton({
    text = "Видалити дані",
    flag = "dangerButton",
    risky = true,
    confirm = true,
    callback = function()
        print("ВИДАЛЕННЯ ДАНИХ!")
    end
})

-- Кнопка з під-кнопками
local MainButton = ButtonSection:AddButton({
    text = "Головна дія",
    callback = function()
        print("Головна дія виконана!")
    end
})

MainButton:AddButton({
    text = "Під-дія 1",
    callback = function()
        print("Під-дія 1")
    end
})

MainButton:AddButton({
    text = "Під-дія 2",
    callback = function()
        print("Під-дія 2")
    end
})

MainButton:AddButton({
    text = "Під-дія 3",
    callback = function()
        print("Під-дія 3")
    end
})

-- Права колонка - Списки та Keybinds
local ListSection = ButtonsTab:AddSection("Списки та Клавіші", 2, 1)

-- Звичайний список
local WeaponList = ListSection:AddList({
    text = "Вибрати зброю",
    flag = "weaponList",
    values = {"Пістолет", "Рушниця", "Снайперка", "Меч", "Лук"},
    selected = "Пістолет",
    multi = false,
    callback = function(selected)
        print("Вибрано зброю:", selected)
    end
})

-- Мульти-список
local SkillsList = ListSection:AddList({
    text = "Вибрати навички",
    flag = "skillsList",
    values = {"Швидкість", "Сила", "Захист", "Витривалість", "Спритність"},
    selected = {},
    multi = true,
    callback = function(selected)
        print("Вибрані навички:", table.concat(selected, ", "))
    end
})

-- Keybind
local ToggleBind = ListSection:AddBind({
    text = "Перемикач режиму",
    flag = "toggleBind",
    bind = Enum.KeyCode.V,
    mode = "toggle",
    callback = function(state)
        print("Режим перемкнуто:", state)
    end
})

-- Hold Keybind
local HoldBind = ListSection:AddBind({
    text = "Тримати для прискорення",
    flag = "holdBind",
    bind = Enum.KeyCode.LeftShift,
    mode = "hold",
    callback = function(state)
        if state then
            print("Прискорення активне!")
        else
            print("Прискорення деактивовано")
        end
    end
})

-- Risky Keybind
local DangerBind = ListSection:AddBind({
    text = "Критичний режим",
    flag = "dangerBind",
    bind = Enum.KeyCode.X,
    mode = "toggle",
    risky = true,
    callback = function(state)
        print("КРИТИЧНИЙ РЕЖИМ:", state)
    end
})

-- Color Picker
local MainColor = ListSection:AddColor({
    text = "Колір UI",
    flag = "mainColor",
    color = Color3.fromRGB(150, 100, 255),
    trans = 0,
    callback = function(color, trans)
        print("UI Колір:", color)
    end
})

-- ============================================
-- ТАБ 3: ДЕМО ФУНКЦІЙ
-- ============================================

local DemoTab = Window:AddTab("Демо", 3)

-- Ліва колонка - Character
local CharacterSection = DemoTab:AddSection("Персонаж", 1, 1)

local WalkspeedToggle = CharacterSection:AddToggle({
    text = "Змінити швидкість",
    flag = "walkspeedToggle",
    state = false,
    callback = function(state)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if state then
                player.Character.Humanoid.WalkSpeed = Library.flags.walkspeedValue
            else
                player.Character.Humanoid.WalkSpeed = 16
            end
        end
    end
})

WalkspeedToggle:AddSlider({
    flag = "walkspeedValue",
    min = 16,
    max = 200,
    value = 16,
    increment = 2,
    suffix = " studs/s",
    callback = function(value)
        if Library.flags.walkspeedToggle then
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = value
            end
        end
    end
})

local JumpToggle = CharacterSection:AddToggle({
    text = "Змінити стрибок",
    flag = "jumpToggle",
    state = false,
    callback = function(state)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if state then
                player.Character.Humanoid.JumpPower = Library.flags.jumpValue
            else
                player.Character.Humanoid.JumpPower = 50
            end
        end
    end
})

JumpToggle:AddSlider({
    flag = "jumpValue",
    min = 50,
    max = 300,
    value = 50,
    increment = 10,
    callback = function(value)
        if Library.flags.jumpToggle then
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = value
            end
        end
    end
})

-- Телепорт
local TeleportSection = DemoTab:AddSection("Телепорт", 2, 1)

local TeleportList = TeleportSection:AddList({
    text = "Локація",
    flag = "teleportList",
    values = {"Spawn", "Центр", "Вежа", "Секретна кімната"},
    selected = "Spawn",
    callback = function(selected)
        print("Вибрано локацію:", selected)
    end
})

TeleportSection:AddButton({
    text = "Телепортуватись",
    callback = function()
        local location = Library.flags.teleportList
        print("Телепорт до:", location)
        -- Тут ваш код телепорту
    end
})

-- ============================================
-- ТАБ 4: НАЛАШТУВАННЯ
-- ============================================

local SettingsTab = Window:AddTab("Налаштування", 4)

-- UI Налаштування
local UISection = SettingsTab:AddSection("Інтерфейс", 1, 1)

local AccentColor = UISection:AddColor({
    text = "Акцентний колір",
    flag = "accentColor",
    color = Color3.fromRGB(150, 100, 255),
    callback = function(color)
        Library:ChangeAccent(color)
        print("Акцент змінено на:", color)
    end
})

UISection:AddButton({
    text = "Випадковий колір",
    callback = function()
        local randomColor = Color3.fromRGB(
            math.random(0, 255),
            math.random(0, 255),
            math.random(0, 255)
        )
        Library:ChangeAccent(randomColor)
        AccentColor:SetColor(randomColor)
    end
})

UISection:AddButton({
    text = "Скинути колір",
    callback = function()
        local defaultColor = Color3.fromRGB(150, 100, 255)
        Library:ChangeAccent(defaultColor)
        AccentColor:SetColor(defaultColor)
    end
})

-- Config Section
local ConfigSection = SettingsTab:AddSection("Конфігурація", 2, 1)

ConfigSection:AddButton({
    text = "Вивести всі Flags",
    callback = function()
        print("=== ПОТОЧНІ FLAGS ===")
        for flag, value in pairs(Library.flags) do
            print(flag, "=", tostring(value))
        end
        print("====================")
    end
})

ConfigSection:AddButton({
    text = "Скинути налаштування",
    confirm = true,
    callback = function()
        print("Скидання налаштувань...")
        -- Скинути всі toggles
        for flag, option in pairs(Library.options) do
            if option.class == "toggle" then
                option:SetState(false)
            end
        end
        print("Налаштування скинуто!")
    end
})

-- Деструктивні дії
local DangerSection = SettingsTab:AddSection("Небезпечна зона", 1, 2)

DangerSection:AddButton({
    text = "Перезавантажити UI",
    risky = true,
    confirm = true,
    callback = function()
        Library:Destroy()
        wait(0.5)
        loadstring(game:HttpGet("YOUR_URL"))()
    end
})

DangerSection:AddButton({
    text = "Закрити UI",
    risky = true,
    confirm = true,
    callback = function()
        Library:Destroy()
        print("UI знищено!")
    end
})

-- ============================================
-- ЗАВЕРШЕННЯ
-- ============================================

-- Вибрати перший таб за замовчуванням
ComponentsTab:Select()

print("=================================")
print("Tokyo UI Demo завантажено!")
print("Всі компоненти створено")
print("=================================")

-- Вивести інформацію
print("\nІнформація:")
print("- Tabs:", #Window.tabs)
print("- Flags:", #Library.flags)
print("\nДля перегляду flags натисніть кнопку в табі 'Налаштування'")
