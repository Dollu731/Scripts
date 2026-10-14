
-- KRYPT0X V4 | 100,000 virtual module slots
-- Client-side utilities; use where permitted.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local parent = player:WaitForChild("PlayerGui")

local old = parent:FindFirstChild("KRYPT0X_V4")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "KRYPT0X_V4"
gui.ResetOnSpawn = false
gui.Parent = parent

local function make(class, properties, into)
    local o = Instance.new(class)
    for k, v in pairs(properties) do
        o[k] = v
    end
    o.Parent = into
    return o
end

local BLUE = Color3.fromRGB(30, 185, 255)
local BG = Color3.fromRGB(7, 12, 24)
local PANEL = Color3.fromRGB(15, 29, 48)
local WHITE = Color3.fromRGB(228, 244, 255)
local MUTED = Color3.fromRGB(130, 160, 185)

local function round(o)
    make("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, o)
end

local main = make("Frame", {
    Size = UDim2.fromOffset(690, 450),
    Position = UDim2.new(.5, -345, .5, -225),
    BackgroundColor3 = BG,
    BorderSizePixel = 0
}, gui)

round(main)
make("UIStroke", {
    Color = BLUE,
    Thickness = 1
}, main)

local scale = make("UIScale", {Scale = 1}, main)

local function resize()
    local cam = workspace.CurrentCamera
    if cam then
        local s = cam.ViewportSize
        scale.Scale = math.min(
            1,
            (s.X - 20) / 690,
            (s.Y - 30) / 450
        )
    end
end

resize()

local top = make("Frame", {
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, main)

make("TextLabel", {
    Size = UDim2.new(1, -110, 1, 0),
    Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1,
    Text = "KRYPT0X // V4 // 100,000 SLOTS",
    Font = Enum.Font.Code,
    TextSize = 20,
    TextColor3 = BLUE,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

local function button(txt, pos, size, container)
    local b = make("TextButton", {
        Text = txt,
        Position = pos,
        Size = size,
        BackgroundColor3 = PANEL,
        TextColor3 = WHITE,
        Font = Enum.Font.Code,
        TextSize = 15,
        BorderSizePixel = 0
    }, container)
    round(b)
    return b
end

local mini = button(
    "_",
    UDim2.new(1, -82, 0, 10),
    UDim2.fromOffset(32, 30),
    top
)

local close = button(
    "X",
    UDim2.new(1, -42, 0, 10),
    UDim2.fromOffset(32, 30),
    top
)

local reopen = button(
    "KRYPT0X",
    UDim2.fromOffset(12, 90),
    UDim2.fromOffset(105, 40),
    gui
)

reopen.Visible = false

mini.MouseButton1Click:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Draggable window
local dragging = false
local dragStart, frameStart, dragInput

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        frameStart = main.Position
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input == dragInput
        or (
            dragInput
            and dragInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement
        )
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            frameStart.X.Scale,
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input == dragInput then
        dragging = false
    end
end)

-- Search interface
local search = make("TextBox", {
    Position = UDim2.fromOffset(180, 59),
    Size = UDim2.new(1, -190, 0, 35),
    BackgroundColor3 = PANEL,
    Text = "",
    PlaceholderText = "SEARCH NAME OR ID (1-100000)",
    TextColor3 = WHITE,
    PlaceholderColor3 = MUTED,
    Font = Enum.Font.Code,
    TextSize = 14,
    ClearTextOnFocus = false
}, main)

round(search)

local sidebar = make("ScrollingFrame", {
    Position = UDim2.fromOffset(10, 59),
    Size = UDim2.new(0, 160, 1, -101),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    CanvasSize = UDim2.fromOffset(0, 730)
}, main)

round(sidebar)

local viewport = make("ScrollingFrame", {
    Position = UDim2.fromOffset(180, 104),
    Size = UDim2.new(1, -190, 1, -150),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    CanvasSize = UDim2.new()
}, main)

round(viewport)

local status = make("TextLabel", {
    Position = UDim2.new(0, 12, 1, -34),
    Size = UDim2.new(1, -24, 0, 28),
    BackgroundTransparency = 1,
    Text = "> 100000 MODULE SLOTS INITIALIZED",
    TextColor3 = BLUE,
    Font = Enum.Font.Code,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left
}, main)

-- 20 categories, 5000 slots each
local names = {
    "PLAYER",
    "MOVEMENT",
    "CAMERA",
    "VISUALS",
    "AUDIO",
    "INTERFACE",
    "UTILITY",
    "ANIMATION",
    "WORLD",
    "LIGHTING",
    "INVENTORY",
    "CHAT",
    "SOCIAL",
    "TOOLS",
    "NAVIGATION",
    "EFFECTS",
    "CONTROLS",
    "DEBUG",
    "SETTINGS",
    "EXPERIMENTAL"
}

local selected = 1
local ROW = 43
local POOL = 10
local rows = {}
local features = {}

local function register(id, name, fn)
    features[id] = {
        name = name,
        run = fn
    }
end

local function hum()
    local c = player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- Working client-side utilities
local fast = false

register(5001, "TOGGLE LOCAL WALK SPEED", function()
    local h = hum()
    if not h then return "NO HUMANOID" end

    fast = not fast
    h.WalkSpeed = fast and 24 or 16
    return "SPEED " .. h.WalkSpeed
end)

register(10001, "CAMERA FOV +10", function()
    local c = workspace.CurrentCamera
    if not c then return "NO CAMERA" end

    c.FieldOfView = c.FieldOfView >= 100
        and 70 or c.FieldOfView + 10

    return "FOV " .. math.floor(c.FieldOfView)
end)

register(15001, "SHOW CAMERA POSITION", function()
    local c = workspace.CurrentCamera
    if not c then return "NO CAMERA" end

    local p = c.CFrame.Position
    return string.format(
        "CAM %.0f %.0f %.0f",
        p.X, p.Y, p.Z
    )
end)

register(30001, "COUNT PLAYERS", function()
    return "PLAYERS " .. #Players:GetPlayers()
end)

local originalBrightness = Lighting.Brightness
local bright = false

register(45001, "TOGGLE LOCAL BRIGHTNESS", function()
    bright = not bright
    Lighting.Brightness = bright and 4 or originalBrightness
    return bright and "BRIGHTNESS ON" or "BRIGHTNESS OFF"
end)

register(85001, "SHOW PLACE ID", function()
    return "PLACE " .. game.PlaceId
end)

register(90001, "SHOW SESSION TIME", function()
    return "SESSION " .. math.floor(time()) .. "s"
end)

-- Virtualized feature index
local visibleIds = {}

local function buildIndex()
    table.clear(visibleIds)

    local q = string.lower(search.Text)
        :gsub("^%s+", "")
        :gsub("%s+$", "")

    local start = (selected - 1) * 5000 + 1
    local exact = tonumber(q)

    if exact
        and exact >= start
        and exact < start + 5000
        and exact == math.floor(exact) then

        visibleIds[1] = exact

    elseif q == "" then
        for i = 0, 4999 do
            visibleIds[i + 1] = start + i
        end
    else
        for i = 0, 4999 do
            local id = start + i
            local entry = features[id]

            local name = entry and entry.name
                or ("RESERVED MODULE " .. string.format("%06d", id))

            if string.find(string.lower(name), q, 1, true)
            or string.find(tostring(id), q, 1, true) then
                visibleIds[#visibleIds + 1] = id
            end
        end
    end

    viewport.CanvasSize = UDim2.fromOffset(
        0,
        #visibleIds * ROW
    )

    viewport.CanvasPosition = Vector2.zero
end

-- Reusable buttons: only 10 created
for i = 1, POOL do
    local b = button(
        "",
        UDim2.fromOffset(6, 0),
        UDim2.new(1, -18, 0, 38),
        viewport
    )

    b.TextXAlignment = Enum.TextXAlignment.Left
    b.TextSize = 13
    rows[i] = b
end

local function render()
    local offset = viewport.CanvasPosition.Y
    local first = math.floor(offset / ROW) + 1

    for i, b in ipairs(rows) do
        local index = first + i - 1
        local id = visibleIds[index]

        b.Visible = id ~= nil

        if id then
            b.Position = UDim2.fromOffset(
                6,
                (index - 1) * ROW + 2
            )

            local f = features[id]

            b.Text = string.format(
                "  [%06d] %s %s",
                id,
                f and f.name or "RESERVED MODULE",
                f and " [RUN]" or " [SLOT]"
            )

            b.TextColor3 = f and BLUE or MUTED
            b:SetAttribute("ModuleId", id)
        end
    end
end

for _, b in ipairs(rows) do
    b.MouseButton1Click:Connect(function()
        local id = b:GetAttribute("ModuleId")
        local f = id and features[id]

        if not f then
            status.Text = "> RESERVED SLOT "
                .. tostring(id)
                .. " // NOT IMPLEMENTED"
            return
        end

        local ok, msg = pcall(f.run)

        status.Text = "> " .. (
            ok and tostring(msg) or "MODULE ERROR"
        )
    end)
end

-- Category navigation
for i, name in ipairs(names) do
    local b = button(
        string.format("%02d %s", i, name),
        UDim2.fromOffset(5, (i - 1) * 35 + 4),
        UDim2.new(1, -12, 0, 31),
        sidebar
    )

    b.TextSize = 12

    b.MouseButton1Click:Connect(function()
        selected = i
        buildIndex()
        render()

        status.Text = "> " .. name .. " // 5000 SLOTS"
    end)
end

viewport:GetPropertyChangedSignal("CanvasPosition"):Connect(render)

search:GetPropertyChangedSignal("Text"):Connect(function()
    buildIndex()
    render()
end)

buildIndex()
render()

print("[KRYPT0X V4] 100,000 virtual slots, 7 working local utilities.")
