-- KRYPT0X LINUX HUB V1
-- Roblox Lua / LocalScript
-- Blue Linux-inspired GUI

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

local old = guiParent:FindFirstChild("KRYPT0X_LINUX")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "KRYPT0X_LINUX"
gui.ResetOnSpawn = false
gui.Parent = guiParent

local BLUE = Color3.fromRGB(0, 135, 255)
local DARK = Color3.fromRGB(7, 12, 28)
local PANEL = Color3.fromRGB(13, 24, 47)
local WHITE = Color3.fromRGB(220, 238, 255)

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 9)
    c.Parent = obj
end

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local main = make("Frame", {
    Size = UDim2.fromOffset(650, 430),
    Position = UDim2.new(.5, -325, .5, -215),
    BackgroundColor3 = DARK,
    BorderSizePixel = 0
}, gui)
corner(main, 13)

make("UIStroke", {
    Color = BLUE,
    Thickness = 2
}, main)

local top = make("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, main)
corner(top, 12)

local title = make("TextLabel", {
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.fromOffset(15, 0),
    BackgroundTransparency = 1,
    Text = "🐧 KRYPT0X  |  LINUX HUB",
    TextColor3 = WHITE,
    TextSize = 19,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

local close = make("TextButton", {
    Size = UDim2.fromOffset(35, 30),
    Position = UDim2.new(1, -43, 0, 9),
    Text = "×",
    TextSize = 25,
    TextColor3 = WHITE,
    BackgroundColor3 = Color3.fromRGB(130, 30, 55)
}, top)
corner(close, 7)

local sidebar = make("Frame", {
    Size = UDim2.fromOffset(145, 365),
    Position = UDim2.fromOffset(10, 55),
    BackgroundColor3 = PANEL
}, main)
corner(sidebar, 10)

local content = make("Frame", {
    Size = UDim2.new(1, -175, 1, -70),
    Position = UDim2.fromOffset(165, 55),
    BackgroundColor3 = PANEL
}, main)
corner(content, 10)

local pages = {}
local buttons = {}

local function newPage(name)
    local page = make("ScrollingFrame", {
        Name = name,
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.fromOffset(10, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    }, content)

    make("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    pages[name] = page
    return page
end

local function label(parent, text, height)
    return make("TextLabel", {
        Size = UDim2.new(1, -8, 0, height or 35),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = WHITE,
        TextSize = 15,
        Font = Enum.Font.Code,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    }, parent)
end

local function button(parent, text, callback)
    local b = make("TextButton", {
        Size = UDim2.new(1, -8, 0, 36),
        BackgroundColor3 = Color3.fromRGB(17, 53, 97),
        TextColor3 = WHITE,
        Text = text,
        TextSize = 14,
        Font = Enum.Font.GothamBold
    }, parent)
    corner(b, 7)

    b.MouseButton1Click:Connect(callback)
    return b
end

local function textbox(parent, placeholder, initial)
    local t = make("TextBox", {
        Size = UDim2.new(1, -8, 0, 38),
        BackgroundColor3 = DARK,
        TextColor3 = WHITE,
        PlaceholderText = placeholder,
        PlaceholderColor3 = Color3.fromRGB(110, 145, 180),
        Text = initial or "",
        TextSize = 15,
        Font = Enum.Font.Code,
        ClearTextOnFocus = false
    }, parent)
    corner(t, 7)
    return t
end

local function addTab(name, order)
    local b = make("TextButton", {
        Size = UDim2.new(1, -12, 0, 43),
        Position = UDim2.fromOffset(6, 7 + (order - 1) * 49),
        BackgroundColor3 = DARK,
        TextColor3 = WHITE,
        Text = name,
        TextSize = 14,
        Font = Enum.Font.GothamBold
    }, sidebar)
    corner(b, 8)
    buttons[name] = b

    b.MouseButton1Click:Connect(function()
        for n, page in pairs(pages) do
            page.Visible = (n == name)
        end
        for n, tab in pairs(buttons) do
            tab.BackgroundColor3 =
                n == name and BLUE or DARK
        end
    end)
end

local home = newPage("Home")
local terminal = newPage("Terminal")
local commands = newPage("Commands")
local movement = newPage("Movement")
local espPage = newPage("ESP")
local settings = newPage("Settings")

addTab("Home", 1)
addTab("Terminal", 2)
addTab("Commands", 3)
addTab("Movement", 4)
addTab("ESP", 5)
addTab("Settings", 6)

-- HOME

label(home, "🐧 KRYPT0X LINUX HUB V1", 45)
label(home, "Blue Linux-inspired Roblox interface", 35)
label(home, "Status: ONLINE", 35)
label(home, "Language: Luau", 35)
label(home, "Terminal: KRYPT0X shell", 35)

-- TERMINAL

label(terminal, "KRYPT0X TERMINAL", 35)

local output = label(
    terminal,
    "krypt0x@linux:~$ Ready",
    115
)
output.TextYAlignment = Enum.TextYAlignment.Top

local commandInput = textbox(
    terminal,
    "Enter command..."
)

local function runCommand(cmd)
    local args = string.split(cmd, " ")
    local action = string.lower(args[1] or "")

    if action == "help" then
        return "help, clear, whoami, date, pwd, ls, echo, speed, jump, fly, unfly, esp, unesp, reset, python3"

    elseif action == "whoami" then
        return player.Name

    elseif action == "date" then
        return os.date("%c")

    elseif action == "pwd" then
        return "/home/krypt0x"

    elseif action == "ls" then
        return "home  terminal  commands  movement  esp"

    elseif action == "echo" then
        return table.concat(args, " ", 2)

    elseif action == "clear" then
        return ""

    elseif action == "python3" then
        return "Python3 requires the real Linux app."

    elseif action == "speed" then
        local n = tonumber(args[2])
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if n and hum then
            hum.WalkSpeed = math.clamp(n, 0, 200)
            return "WalkSpeed updated."
        end
        return "Usage: speed 50"

    elseif action == "jump" then
        local n = tonumber(args[2])
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if n and hum then
            hum.UseJumpPower = true
            hum.JumpPower = math.clamp(n, 0, 200)
            return "JumpPower updated."
        end
        return "Usage: jump 100"

    elseif action == "reset" then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 end
        return "Reset requested."

    else
        return "Unknown command. Type help."
    end
end

button(terminal, "▶ EXECUTE", function()
    local cmd = commandInput.Text
    local result = runCommand(cmd)
    output.Text = "krypt0x@linux:~$ " .. cmd .. "\n" .. result
    commandInput.Text = ""
end)

-- COMMAND LIBRARY

label(commands, "LINUX-STYLE COMMAND LIBRARY", 45)

local library = {
    "help - Show available commands",
    "clear - Clear terminal output",
    "whoami - Current player",
    "date - Current date",
    "pwd - Simulated working directory",
    "ls - List simulated folders",
    "echo TEXT - Print text",
    "speed 50 - Set WalkSpeed",
    "jump 100 - Set JumpPower",
    "reset - Reset character",
    "python3 - Python information",
    "fly - Flight command (reserved)",
    "unfly - Disable flight (reserved)",
    "esp - ESP command (reserved)",
    "unesp - Disable ESP (reserved)",
    "uname - Linux command reference",
    "cat - Linux command reference",
    "mkdir - Linux command reference",
    "touch - Linux command reference",
    "rm - Linux command reference",
    "cp - Linux command reference",
    "mv - Linux command reference",
    "grep - Linux command reference",
    "find - Linux command reference",
    "chmod - Linux command reference",
    "ps - Linux command reference",
    "top - Linux command reference",
    "kill - Linux command reference",
    "git - Linux command reference",
    "pip - Python package manager reference",
    "apt - Debian package manager reference",
    "pacman - Arch package manager reference"
}

local search = textbox(commands, "Search commands...")

local commandLabels = {}

for _, text in ipairs(library) do
    local item = label(commands, " > " .. text, 28)
    table.insert(commandLabels, {
        object = item,
        text = string.lower(text)
    })
end

search:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(search.Text)
    for _, item in ipairs(commandLabels) do
        item.object.Visible =
            string.find(item.text, query, 1, true) ~= nil
    end
end)

-- MOVEMENT

label(movement, "MOVEMENT CONTROLS", 45)

local speedBox = textbox(movement, "WalkSpeed", "50")

button(movement, "SET WALK SPEED", function()
    local hum = player.Character
        and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = math.clamp(
            tonumber(speedBox.Text) or 16, 0, 200
        )
    end
end)

local jumpBox = textbox(movement, "JumpPower", "100")

button(movement, "SET JUMP POWER", function()
    local hum = player.Character
        and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = math.clamp(
            tonumber(jumpBox.Text) or 50, 0, 200
        )
    end
end)

local flying = false
local flyConnection
local flyAttachment
local flyVelocity

local function stopFly()
    flying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
    end
    if flyAttachment then
        flyAttachment:Destroy()
        flyAttachment = nil
    end
end

button(movement, "TOGGLE FLY (F)", function()
    if flying then
        stopFly()
        return
    end

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not root or not hum then return end

    flying = true

    flyAttachment = Instance.new("Attachment")
    flyAttachment.Parent = root

    flyVelocity = Instance.new("LinearVelocity")
    flyVelocity.Attachment0 = flyAttachment
    flyVelocity.MaxForce = math.huge
    flyVelocity.VectorVelocity = Vector3.zero
    flyVelocity.Parent = root

    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying or not root.Parent then
            stopFly()
            return
        end

        local camera = workspace.CurrentCamera
        if not camera then return end

        local direction = hum.MoveDirection * 65
        local vertical = 0

        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            vertical = 65
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            vertical = -65
        end

        flyVelocity.VectorVelocity =
            direction + Vector3.new(0, vertical, 0)
    end)
end)

player.CharacterAdded:Connect(stopFly)

-- ESP

label(espPage, "PLAYER HIGHLIGHT ESP", 45)

local espEnabled = false
local highlights = {}

local function removeESP()
    for _, h in pairs(highlights) do
        if h then h:Destroy() end
    end
    table.clear(highlights)
end

local function updateESP()
    removeESP()
    if not espEnabled then return end

    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player and target.Character then
            local h = Instance.new("Highlight")
            h.Name = "KRYPT0X_ESP"
            h.FillColor = BLUE
            h.OutlineColor = Color3.new(1, 1, 1)
            h.FillTransparency = 0.65
            h.DepthMode = Enum.HighlightDepthMode.Occluded
            h.Adornee = target.Character
            h.Parent = gui
            highlights[target] = h
        end
    end
end

button(espPage, "TOGGLE PLAYER ESP", function()
    espEnabled = not espEnabled
    updateESP()
end)

button(espPage, "REMOVE ESP", function()
    espEnabled = false
    removeESP()
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if espEnabled then updateESP() end
    end)
end)

-- SETTINGS

label(settings, "KRYPT0X SETTINGS", 45)
label(settings, "Theme: Neon Blue / Dark", 35)
label(settings, "Version: 1.0", 35)
label(settings, "Platform: Roblox Luau", 35)

button(settings, "RESET MOVEMENT", function()
    stopFly()
    local hum = player.Character
        and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 16
        hum.UseJumpPower = true
        hum.JumpPower = 50
    end
end)

-- DRAG WINDOW

local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

close.MouseButton1Click:Connect(function()
    stopFly()
    removeESP()
    gui:Destroy()
end)

pages.Home.Visible = true
buttons.Home.BackgroundColor3 = BLUE

print("KRYPT0X LINUX HUB LOADED!")
