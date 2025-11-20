# Tokyo UI Library - Повна Документація

Потужна та красива UI бібліотека для Roblox з підтримкою великої кількості компонентів та кастомізацією тем.

## 📦 Встановлення

\`\`\`lua
local Library = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()
\`\`\`

## 🚀 Швидкий Старт

\`\`\`lua
-- Створити головне вікно
local Window = Library:NewWindow({
    title = "Моя UI Бібліотека",
    size = UDim2.new(0, 525, 0, 650),
    position = UDim2.new(0, 250, 0, 150)
})

-- Створити таб
local Tab = Window:AddTab("Головна", 1)

-- Створити секцію
local Section = Tab:AddSection("Налаштування", 1, 1)

-- Додати toggle
local Toggle = Section:AddToggle({
    text = "Увімкнути функцію",
    flag = "myToggle",
    state = false,
    callback = function(state)
        print("Toggle стан:", state)
    end
})
\`\`\`

## 📖 Компоненти

### 🪟 Window (Вікно)

Створює головне вікно для UI

\`\`\`lua
local Window = Library:NewWindow({
    title = "Назва Вікна",
    size = UDim2.new(0, 525, 0, 650),
    position = UDim2.new(0, 250, 0, 150)
})
\`\`\`

**API:**
- `Window:SetTitle(string)` - Змінити заголовок вікна

---

### 📑 Tab (Таб)

Створює таб в вікні

\`\`\`lua
local Tab = Window:AddTab("Назва Табу", order)
\`\`\`

**Параметри:**
- `text` - Назва табу
- `order` - Порядок відображення (необов'язково)

**API:**
- `Tab:Select()` - Вибрати цей таб

---

### 📦 Section (Секція)

Створює секцію всередині табу

\`\`\`lua
local Section = Tab:AddSection("Назва Секції", side, order)
\`\`\`

**Параметри:**
- `text` - Назва секції
- `side` - Сторона (1 = ліва, 2 = права)
- `order` - Порядок відображення

**API:**
- `Section:SetText(string)` - Змінити текст секції

---

### 🔘 Toggle (Перемикач)

Простий перемикач увімкнено/вимкнено

\`\`\`lua
local Toggle = Section:AddToggle({
    text = "Назва Toggle",
    flag = "myToggle",
    state = false,
    risky = false,
    callback = function(state)
        print("Стан:", state)
    end
})
\`\`\`

**Параметри:**
- `text` - Текст toggle
- `flag` - Унікальний ідентифікатор
- `state` - Початковий стан (true/false)
- `risky` - Червоний колір для небезпечних функцій
- `callback` - Функція при зміні стану

**API:**
- `Toggle:SetState(bool, nocallback)` - Встановити стан
- `Toggle:SetText(string)` - Змінити текст

**Додаткові компоненти Toggle:**

#### Color Picker
\`\`\`lua
local Color = Toggle:AddColor({
    flag = "myColor",
    color = Color3.new(1, 1, 1),
    trans = 0,
    callback = function(color, transparency)
        print("Колір:", color, "Прозорість:", transparency)
    end
})
\`\`\`

**API:**
- `Color:SetColor(Color3, nocallback)` - Встановити колір
- `Color:SetTrans(number, nocallback)` - Встановити прозорість
- `Color:SetOpen(bool)` - Відкрити/закрити picker

#### Keybind
\`\`\`lua
local Bind = Toggle:AddBind({
    flag = "myBind",
    bind = Enum.KeyCode.E,
    mode = "toggle", -- "toggle" або "hold"
    nomouse = false,
    callback = function(state)
        print("Клавіша натиснута:", state)
    end,
    keycallback = function(key)
        print("Нова клавіша:", key)
    end
})
\`\`\`

**API:**
- `Bind:SetBind(KeyCode)` - Встановити клавішу

#### Slider (для Toggle)
\`\`\`lua
local Slider = Toggle:AddSlider({
    flag = "mySlider",
    min = 0,
    max = 100,
    increment = 1,
    suffix = "%",
    callback = function(value)
        print("Значення:", value)
    end
})
\`\`\`

#### List (для Toggle)
\`\`\`lua
local List = Toggle:AddList({
    flag = "myList",
    values = {"Опція 1", "Опція 2", "Опція 3"},
    multi = false,
    callback = function(selected)
        print("Вибрано:", selected)
    end
})
\`\`\`

---

### 🎚️ Slider (Повзунок)

Повзунок для вибору числового значення

\`\`\`lua
local Slider = Section:AddSlider({
    text = "Швидкість",
    flag = "speedSlider",
    min = 0,
    max = 100,
    value = 50,
    increment = 1,
    suffix = "%",
    risky = false,
    callback = function(value)
        print("Значення:", value)
    end
})
\`\`\`

**Параметри:**
- `text` - Назва слайдера
- `flag` - Унікальний ідентифікатор
- `min` - Мінімальне значення
- `max` - Максимальне значення
- `value` - Початкове значення
- `increment` - Крок зміни
- `suffix` - Суфікс (наприклад, "%", "px")
- `risky` - Червоний колір
- `callback` - Функція при зміні

**API:**
- `Slider:SetValue(number, nocallback)` - Встановити значення

**Спеціальні функції:**
- Тримайте **LeftControl** + клік для введення точного числа

---

### 🔳 Button (Кнопка)

Кнопка для виконання дій

\`\`\`lua
local Button = Section:AddButton({
    text = "Виконати дію",
    flag = "myButton",
    suffix = "",
    risky = false,
    confirm = false,
    callback = function()
        print("Кнопку натиснуто!")
    end
})
\`\`\`

**Параметри:**
- `text` - Текст кнопки
- `flag` - Унікальний ідентифікатор
- `risky` - Червоний колір
- `confirm` - Потрібне підтвердження (3 секунди)
- `callback` - Функція при натисканні

**API:**
- `Button:SetText(string)` - Змінити текст

**Під-кнопки:**
\`\`\`lua
local SubButton = Button:AddButton({
    text = "Під-кнопка",
    callback = function()
        print("Під-кнопку натиснуто!")
    end
})
\`\`\`

---

### 🎨 Color Picker (Вибір кольору)

Вибір кольору з прозорістю

\`\`\`lua
local Color = Section:AddColor({
    text = "Колір UI",
    flag = "uiColor",
    color = Color3.new(1, 0, 0),
    trans = 0,
    risky = false,
    callback = function(color, transparency)
        print("Новий колір:", color)
    end
})
\`\`\`

**API:**
- `Color:SetColor(Color3, nocallback)` - Встановити колір
- `Color:SetTrans(number, nocallback)` - Встановити прозорість
- `Color:SetText(string)` - Змінити текст
- `Color:SetOpen(bool)` - Відкрити/закрити picker

---

### 📝 TextBox (Текстове поле)

Поле для введення тексту

\`\`\`lua
local Box = Section:AddBox({
    text = "Введіть текст",
    flag = "myBox",
    input = "",
    risky = false,
    callback = function(text)
        print("Введено:", text)
    end
})
\`\`\`

**API:**
- `Box:SetText(string)` - Змінити label
- `Box:SetInput(string, nocallback)` - Встановити значення

---

### ⌨️ Keybind (Прив'язка клавіш)

Прив'язка клавіш для функцій

\`\`\`lua
local Bind = Section:AddBind({
    text = "Клавіша активації",
    flag = "myBind",
    bind = Enum.KeyCode.E,
    mode = "toggle", -- "toggle" або "hold"
    nomouse = false,
    risky = false,
    callback = function(state)
        print("Клавішу активовано:", state)
    end,
    keycallback = function(key)
        print("Змінено клавішу на:", key)
    end
})
\`\`\`

**Параметри:**
- `mode`:
  - `"toggle"` - Перемикач (натиснув - увімкнено, знову натиснув - вимкнено)
  - `"hold"` - Утримання (працює поки тримаєш)
- `nomouse` - Заборонити кнопки миші
- `bind` - Початкова клавіша (або "none" для завжди активного)

**API:**
- `Bind:SetBind(KeyCode)` - Встановити клавішу
- `Bind:SetText(string)` - Змінити текст

**Спеціальні клавіші:**
- `Backspace` - Скинути клавішу (зробити "none")

---

### 📋 List (Список)

Випадаючий список з опціями

\`\`\`lua
local List = Section:AddList({
    text = "Виберіть опцію",
    flag = "myList",
    values = {"Опція 1", "Опція 2", "Опція 3"},
    selected = "Опція 1",
    multi = false,
    risky = false,
    callback = function(selected)
        print("Вибрано:", selected)
    end
})
\`\`\`

**Параметри:**
- `multi` - Дозволити вибір кількох опцій
- `values` - Список опцій
- `selected` - Початково вибрана опція

**API:**
- `List:Select(option, nocallback)` - Вибрати опцію
- `List:AddValue(string)` - Додати опцію
- `List:RemoveValue(string)` - Видалити опцію
- `List:ClearValues()` - Очистити всі опції
- `List:SetText(string)` - Змінити текст

---

## 🎨 Теми

### Змінити колір акценту

\`\`\`lua
Library:ChangeAccent(Color3.fromRGB(255, 100, 100))
\`\`\`

### Доступні теми

\`\`\`lua
-- Tokyo Night (за замовчуванням)
-- Темна елегантна тема з фіолетовим акцентом

-- Можна змінити будь-який колір теми:
Library.theme['Background'] = Color3.fromRGB(20, 20, 20)
Library.theme['Accent'] = Color3.fromRGB(150, 100, 255)
\`\`\`

---

## 🚩 Flags (Прапорці)

Flags - це спосіб швидко отримувати значення компонентів

\`\`\`lua
-- Створити компонент з flag
local Toggle = Section:AddToggle({
    flag = "myFeature",
    state = false
})

-- Отримати значення
if Library.flags.myFeature then
    print("Функція увімкнена!")
end

-- Отримати сам компонент
Library.options.myFeature:SetState(true)
\`\`\`

---

## 🎯 Приклад Повного Скрипту

\`\`\`lua
local Library = loadstring(game:HttpGet("YOUR_URL"))()

-- Створити вікно
local Window = Library:NewWindow({
    title = "Мій Чит Меню",
    size = UDim2.new(0, 525, 0, 650)
})

-- Головний таб
local MainTab = Window:AddTab("Головна", 1)
local MainSection = MainTab:AddSection("Основні функції", 1, 1)

-- WalkSpeed
local SpeedEnabled = MainSection:AddToggle({
    text = "Швидкість",
    flag = "walkspeedEnabled",
    state = false
})

local SpeedValue = SpeedEnabled:AddSlider({
    flag = "walkspeedValue",
    min = 16,
    max = 200,
    value = 16,
    suffix = " studs/s",
    callback = function(value)
        if Library.flags.walkspeedEnabled then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

SpeedEnabled.callback = function(state)
    if state then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Library.flags.walkspeedValue
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end

-- JumpPower
local JumpToggle = MainSection:AddToggle({
    text = "Висота стрибка",
    flag = "jumpEnabled",
    state = false
})

JumpToggle:AddSlider({
    flag = "jumpValue",
    min = 50,
    max = 300,
    value = 50,
    callback = function(value)
        if Library.flags.jumpEnabled then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end
})

-- ESP таб
local VisualTab = Window:AddTab("Візуали", 2)
local ESPSection = VisualTab:AddSection("ESP", 1, 1)

local ESPToggle = ESPSection:AddToggle({
    text = "Увімкнути ESP",
    flag = "espEnabled",
    state = false,
    callback = function(state)
        print("ESP:", state)
    end
})

local ESPColor = ESPToggle:AddColor({
    flag = "espColor",
    color = Color3.fromRGB(255, 0, 0),
    callback = function(color)
        print("Колір ESP:", color)
    end
})

-- Налаштування
local SettingsTab = Window:AddTab("Налаштування", 3)
local UISection = SettingsTab:AddSection("Інтерфейс", 1, 1)

local ThemeButton = UISection:AddButton({
    text = "Змінити колір",
    callback = function()
        Library:ChangeAccent(Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)))
    end
})

-- Кнопка збереження
local SaveSection = SettingsTab:AddSection("Дії", 1, 2)

SaveSection:AddButton({
    text = "Зберегти конфіг",
    callback = function()
        print("Збереження конфігу...")
        -- Ваш код збереження
    end
})

SaveSection:AddButton({
    text = "Завантажити конфіг",
    callback = function()
        print("Завантаження конфігу...")
        -- Ваш код завантаження
    end
})

SaveSection:AddButton({
    text = "Знищити UI",
    risky = true,
    confirm = true,
    callback = function()
        Library:Destroy()
    end
})

-- Відкрити перший таб
MainTab:Select()
\`\`\`

---

## 💡 Поради та Трюки

### 1. Використання Flags

Замість збереження змінних для кожного компонента, використовуйте flags:

\`\`\`lua
-- Погано
local myToggle = Section:AddToggle({...})
if myToggle.state then ... end

-- Добре
Section:AddToggle({
    flag = "myToggle",
    ...
})
if Library.flags.myToggle then ... end
\`\`\`

### 2. Risky компоненти

Використовуйте `risky = true` для небезпечних функцій:

\`\`\`lua
Section:AddButton({
    text = "Видалити все",
    risky = true,
    confirm = true, -- Потрібне підтвердження
    callback = function()
        -- Небезпечний код
    end
})
\`\`\`

### 3. Організація UI

\`\`\`lua
-- Використовуйте order для організації
local Tab1 = Window:AddTab("Перший", 1)
local Tab2 = Window:AddTab("Другий", 2)

-- Ліва та права колонки
local LeftSection = Tab:AddSection("Ліва", 1, 1)
local RightSection = Tab:AddSection("Права", 2, 1)
\`\`\`

### 4. Callback без виклику

\`\`\`lua
-- Встановити значення без виклику callback
Toggle:SetState(true, true) -- другий параметр = nocallback
Slider:SetValue(50, true)
Color:SetColor(Color3.new(1,0,0), true)
\`\`\`

### 5. Швидке введення в Slider

Тримайте **LeftControl** + клік на slider для точного введення числа

---

## 🔧 API Референс

### Library

- `Library:NewWindow(data)` - Створити нове вікно
- `Library:ChangeAccent(Color3)` - Змінити акцентний колір
- `Library:Destroy()` - Знищити всі вікна

### Window

- `Window:AddTab(text, order)` - Додати таб
- `Window:SetTitle(text)` - Змінити заголовок

### Tab

- `Tab:AddSection(text, side, order)` - Додати секцію
- `Tab:Select()` - Вибрати таб

### Section

- `Section:AddToggle(data)` - Додати toggle
- `Section:AddSlider(data)` - Додати slider
- `Section:AddButton(data)` - Додати кнопку
- `Section:AddColor(data)` - Додати color picker
- `Section:AddBox(data)` - Додати текстове поле
- `Section:AddBind(data)` - Додати keybind
- `Section:AddList(data)` - Додати список
- `Section:SetText(text)` - Змінити текст секції

---

## 📄 Ліцензія

Ця бібліотека вільна для використання у ваших проектах.

---

## 🤝 Підтримка

Якщо у вас є питання або проблеми, створіть issue на GitHub!

---

**Створено з ❤️ для спільноти Roblox**
