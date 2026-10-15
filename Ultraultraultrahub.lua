
--[[
  KRYPT0X 3.0 | MEGA FEATURE PACK
  Roblox Studio LocalScript
  1,200,000 virtual feature slots
  20+ interactive local controls
  Place in StarterPlayer > StarterPlayerScripts
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local guiParent = player:WaitForChild("PlayerGui")

local previous = guiParent:FindFirstChild("KRYPT0X_3")
if previous then previous:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "KRYPT0X_3"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = guiParent

local totalSlots = 1200000
local pageSize = 14
local currentPage = 1
local category = "All"
local active = {}
local connections = {}

local theme = {
    background = Color3.fromRGB(4, 9, 22),
    panel = Color3.fromRGB(9, 19, 39),
    button = Color3.fromRGB(15, 36, 66),
    accent = Color3.fromRGB(0, 165, 255),
    text = Color3.fromRGB(230, 245, 255),
    muted = Color3.fromRGB(130, 165, 195)
}

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function decorate(obj, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0, radius or 9)
    }, obj)
    make("UIStroke", {
        Color = theme.accent,
        Thickness = 1,
        Transparency = 0.45
    }, obj)
end

local function text(parent, value, position, size, fontSize, color)
    return make("TextLabel", {
        BackgroundTransparency = 1,
        Position = position,
        Size = size,
        Text = value,
        TextColor3 = color or theme.text,
        TextSize = fontSize or 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, parent)
end

local function button(parent, value, position, size)
    local obj = make("TextButton", {
        Position = position,
        Size = size,
        BackgroundColor3 = theme.button,
        Text = value,
        TextColor3 = theme.text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = true
    }, parent)
    decorate(obj)
    return obj
end

local main = make("Frame", {
    Size = UDim2.fromOffset(850, 550),
    Position = UDim2.new(0.5, -425, 0.5, -275),
    BackgroundColor3 = theme.background,
    BorderSizePixel = 0
}, gui)
decorate(main, 13)

local scale = make("UIScale", {}, main)

local function updateScale()
    local cam = workspace.CurrentCamera
    local viewport = cam and cam.ViewportSize or Vector2.new(1280, 720)
    scale.Scale = math.clamp(
        math.min(viewport.X / 900, viewport.Y / 600),
        0.45, 1
    )
end
updateScale()

local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 75),
    BackgroundColor3 = Color3.fromRGB(7, 27, 55),
    BorderSizePixel = 0
}, main)
decorate(header, 13)

text(header, "KRYPT0X 3.0", UDim2.fromOffset(20, 7),
    UDim2.fromOffset(470, 40), 31, theme.accent)

text(header, "1,200,000 VIRTUAL SLOTS | MEGA FEATURE PACK",
    UDim2.fromOffset(22, 48),
    UDim2.fromOffset(580, 20), 11, theme.muted)

local minimize = button(header, "—",
    UDim2.new(1, -83, 0, 16), UDim2.fromOffset(31, 31))

local close = button(header, "X",
    UDim2.new(1, -45, 0, 16), UDim2.fromOffset(31, 31))

local sidebar = make("Frame", {
    Position = UDim2.fromOffset(12, 87),
    Size = UDim2.new(0, 155, 1, -100),
    BackgroundColor3 = theme.panel
}, main)
decorate(sidebar)

local body = make("Frame", {
    Position = UDim2.fromOffset(179, 87),
    Size = UDim2.new(1, -192, 1, -100),
    BackgroundColor3 = theme.panel
}, main)
decorate(body)

local status = text(body, "SYSTEM READY",
    UDim2.fromOffset(15, 9),
    UDim2.new(1, -30, 0, 24), 13, theme.accent)

local search = make("TextBox", {
    Position = UDim2.fromOffset(14, 39),
    Size = UDim2.new(1, -28, 0, 36),
    BackgroundColor3 = theme.background,
    Text = "",
    PlaceholderText = "Search features or slot number...",
    TextColor3 = theme.text,
    PlaceholderColor3 = theme.muted,
    ClearTextOnFocus = false,
    TextSize = 13,
    Font = Enum.Font.Gotham
}, body)
decorate(search)

local list = make("ScrollingFrame", {
    Position = UDim2.fromOffset(14, 85),
    Size = UDim2.new(1, -28, 1, -135),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.fromOffset(0, 0)
}, body)

make("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
}, list)

local previousPage = button(body, "PREV",
    UDim2.new(0, 14, 1, -39), UDim2.fromOffset(80, 29))

local nextPage = button(body, "NEXT",
    UDim2.new(1, -94, 1, -39), UDim2.fromOffset(80, 29))

local pageLabel = text(body, "PAGE 1",
    UDim2.new(0.5, -90, 1, -37),
    UDim2.fromOffset(180, 25), 12)

pageLabel.TextXAlignment = Enum.TextXAlignment.Center

local function humanoid()
    local character = player.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function root()
    local character = player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function notify(message)
    status.Text = message
end

local defaults = {
    brightness = Lighting.Brightness,
    clockTime = Lighting.ClockTime,
    fogEnd = Lighting.FogEnd,
    ambient = Lighting.Ambient,
    exposure = Lighting.ExposureCompensation,
    fieldOfView = camera.FieldOfView
}

local features = {}
local function add(name, group, callback)
    table.insert(features, {
        name = name,
        group = group,
        run = callback
    })
end

local function toggle(name, on, off)
    active[name] = not active[name]
    if active[name] then
        on()
    elseif off then
        off()
    end
    notify(name .. ": " .. (active[name] and "ON" or "OFF"))
end

add("Speed Boost", "Player", function()
    toggle("Speed Boost", function()
        local h = humanoid()
        if h then h.WalkSpeed = 30 end
    end, function()
        local h = humanoid()
        if h then h.WalkSpeed = 16 end
    end)
end)

add("Super Speed", "Player", function()
    toggle("Super Speed", function()
        local h = humanoid()
        if h then h.WalkSpeed = 55 end
    end, function()
        local h = humanoid()
        if h then h.WalkSpeed = 16 end
    end)
end)

add("Jump Boost", "Player", function()
    toggle("Jump Boost", function()
        local h = humanoid()
        if h then
            h.UseJumpPower = true
            h.JumpPower = 85
        end
    end, function()
        local h = humanoid()
        if h then h.JumpPower = 50 end
    end)
end)

add("Sit", "Player", function()
    local h = humanoid()
    if h then h.Sit = true end
    notify("Sit activated")
end)

add("Stand", "Player", function()
    local h = humanoid()
    if h then h.Sit = false end
    notify("Stand activated")
end)

add("Reset Movement", "Player", function()
    local h = humanoid()
    if h then
        h.WalkSpeed = 16
        h.UseJumpPower = true
        h.JumpPower = 50
    end
    active["Speed Boost"] = false
    active["Super Speed"] = false
    active["Jump Boost"] = false
    notify("Movement reset")
end)

add("Wide FOV", "Visuals", function()
    toggle("Wide FOV", function()
        camera.FieldOfView = 100
    end, function()
        camera.FieldOfView = defaults.fieldOfView
    end)
end)

add("Cinematic FOV", "Visuals", function()
    toggle("Cinematic FOV", function()
        camera.FieldOfView = 45
    end, function()
        camera.FieldOfView = defaults.fieldOfView
    end)
end)

add("Fullbright", "Visuals", function()
    toggle("Fullbright", function()
        Lighting.Brightness = 5
        Lighting.Ambient = Color3.new(1, 1, 1)
    end, function()
        Lighting.Brightness = defaults.brightness
        Lighting.Ambient = defaults.ambient
    end)
end)

add("No Fog", "Visuals", function()
    toggle("No Fog", function()
        Lighting.FogEnd = 100000
    end, function()
        Lighting.FogEnd = defaults.fogEnd
    end)
end)

add("Day Mode", "World", function()
    Lighting.ClockTime = 12
    notify("Day mode")
end)

add("Night Mode", "World", function()
    Lighting.ClockTime = 0
    notify("Night mode")
end)

add("Sunset Mode", "World", function()
    Lighting.ClockTime = 18
    notify("Sunset mode")
end)

add("Morning Mode", "World", function()
    Lighting.ClockTime = 7
    notify("Morning mode")
end)

add("Bright Exposure", "Visuals", function()
    toggle("Bright Exposure", function()
        Lighting.ExposureCompensation = 1
    end, function()
        Lighting.ExposureCompensation = defaults.exposure
    end)
end)

add("Reset Lighting", "World", function()
    Lighting.ClockTime = defaults.clockTime
    Lighting.Brightness = defaults.brightness
    Lighting.FogEnd = defaults.fogEnd
    Lighting.Ambient = defaults.ambient
    Lighting.ExposureCompensation = defaults.exposure
    notify("Lighting reset")
end)

add("Camera Reset", "Camera", function()
    local h = humanoid()
    if h then
        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = h
    end
    camera.FieldOfView = defaults.fieldOfView
    notify("Camera reset")
end)

add("Zoom In", "Camera", function()
    camera.FieldOfView = math.max(25, camera.FieldOfView - 10)
    notify("FOV: " .. math.floor(camera.FieldOfView))
end)

add("Zoom Out", "Camera", function()
    camera.FieldOfView = math.min(120, camera.FieldOfView + 10)
    notify("FOV: " .. math.floor(camera.FieldOfView))
end)

add("Show Coordinates", "Utilities", function()
    local r = root()
    if r then
        local p = r.Position
        notify(string.format("X %.1f | Y %.1f | Z %.1f", p.X, p.Y, p.Z))
    end
end)

add("Show Health", "Utilities", function()
    local h = humanoid()
    if h then
        notify(string.format("Health: %.0f / %.0f", h.Health, h.MaxHealth))
    end
end)

add("Show Player Count", "Utilities", function()
    notify("Players: " .. #Players:GetPlayers())
end)

add("Show Place ID", "Utilities", function()
    notify("Place ID: " .. tostring(game.PlaceId))
end)

add("Show User ID", "Utilities", function()
    notify("User ID: " .. tostring(player.UserId))
end)

add("Show Position Magnitude", "Utilities", function()
    local r = root()
    if r then
        notify("Distance from origin: " .. math.floor(r.Position.Magnitude))
    end
end)

local fpsCounter = text(header, "",
    UDim2.new(1, -195, 0, 51),
    UDim2.fromOffset(95, 18), 12, theme.accent)

local fpsEnabled = false
local frameCount = 0
local lastTime = os.clock()

table.insert(connections, RunService.RenderStepped:Connect(function()
    if not fpsEnabled then return end
    frameCount += 1
    local now = os.clock()
    if now - lastTime >= 1 then
        fpsCounter.Text = "FPS: " .. frameCount
        frameCount = 0
        lastTime = now
    end
end))

add("FPS Counter", "Utilities", function()
    fpsEnabled = not fpsEnabled
    if not fpsEnabled then fpsCounter.Text = "" end
    notify("FPS Counter: " .. (fpsEnabled and "ON" or "OFF"))
end)

add("Show Gravity", "World", function()
    notify("Gravity: " .. tostring(workspace.Gravity))
end)

add("UI Glow Pulse", "Themes", function()
    local s = main:FindFirstChildOfClass("UIStroke")
    if s then
        TweenService:Create(s, TweenInfo.new(0.4), {
            Thickness = 4
        }):Play()
        task.delay(0.45, function()
            if s.Parent then
                TweenService:Create(s, TweenInfo.new(0.4), {
                    Thickness = 1
                }):Play()
            end
        end)
    end
    notify("Glow pulse")
end)

add("Random Accent Color", "Themes", function()
    theme.accent = Color3.fromHSV(math.random(), 0.9, 1)
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("UIStroke") then
            obj.Color = theme.accent
        end
    end
    notify("Accent color randomized")
end)

add("Blue Accent", "Themes", function()
    theme.accent = Color3.fromRGB(0, 165, 255)
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("UIStroke") then
            obj.Color = theme.accent
        end
    end
    notify("Blue theme restored")
end)

local categories = {
    "All", "Player", "Visuals", "World",
    "Camera", "Utilities", "Themes", "Virtual Slots"
}

local categoryButtons = {}

for index, name in ipairs(categories) do
    local b = button(sidebar, name,
        UDim2.fromOffset(8, 12 + (index - 1) * 45),
        UDim2.new(1, -16, 0, 36))
    categoryButtons[name] = b
end

local rows = {}

local function clearRows()
    for _, obj in ipairs(rows) do
        obj:Destroy()
    end
    table.clear(rows)
end

local function createRow(titleValue, callback, enabled)
    local row = make("Frame", {
        Size = UDim2.new(1, -5, 0, 43),
        BackgroundColor3 = theme.background,
        BorderSizePixel = 0
    }, list)
    decorate(row)
    table.insert(rows, row)

    text(row, titleValue,
        UDim2.fromOffset(11, 0),
        UDim2.new(1, -115, 1, 0), 12,
        enabled and theme.text or theme.muted)

    local run = button(row, enabled and "RUN" or "EMPTY",
        UDim2.new(1, -100, 0, 5),
        UDim2.fromOffset(90, 32))

    run.MouseButton1Click:Connect(callback)
end

local function render()
    clearRows()
    local q = search.Text:lower()
    local matches = {}

    for index, feature in ipairs(features) do
        if (category == "All" or category == feature.group)
            and (q == "" or feature.name:lower():find(q, 1, true)) then
            table.insert(matches, {index = index, feature = feature})
        end
    end

    local virtualMode = category == "Virtual Slots"
    local numericQuery = tonumber(q:match("^#?(%d+)$"))

    if virtualMode then
        if numericQuery then
            if numericQuery >= 1 and numericQuery <= totalSlots then
                createRow("VIRTUAL SLOT #" .. numericQuery, function()
                    notify("Slot #" .. numericQuery .. " is unassigned")
                end, false)
            end
            pageLabel.Text = "SLOT SEARCH"
        elseif q == "" then
            local maxPage = math.ceil(totalSlots / pageSize)
            currentPage = math.clamp(currentPage, 1, maxPage)
            local first = (currentPage - 1) * pageSize + 1
            for id = first, math.min(first + pageSize - 1, totalSlots) do
                local slotID = id
                createRow("VIRTUAL SLOT #" .. slotID, function()
                    notify("Slot #" .. slotID .. " is unassigned")
                end, false)
            end
            pageLabel.Text = currentPage .. " / " .. maxPage
        else
            pageLabel.Text = "SEARCH BY ID"
        end
    else
        local maxPage = math.max(1, math.ceil(#matches / pageSize))
        currentPage = math.clamp(currentPage, 1, maxPage)

        for i = (currentPage - 1) * pageSize + 1,
            math.min(currentPage * pageSize, #matches) do
            local item = matches[i]
            createRow(item.feature.name, item.feature.run, true)
        end

        pageLabel.Text = currentPage .. " / " .. maxPage
    end

    list.CanvasSize = UDim2.fromOffset(0, #rows * 48)

    for name, b in pairs(categoryButtons) do
        b.BackgroundColor3 = name == category
            and Color3.fromRGB(0, 78, 145)
            or theme.button
    end
end

for name, b in pairs(categoryButtons) do
    b.MouseButton1Click:Connect(function()
        category = name
        currentPage = 1
        search.Text = ""
        render()
        notify("CATEGORY: " .. name:upper())
    end)
end

search:GetPropertyChangedSignal("Text"):Connect(function()
    currentPage = 1
    render()
end)

previousPage.MouseButton1Click:Connect(function()
    currentPage = math.max(1, currentPage - 1)
    render()
end)

nextPage.MouseButton1Click:Connect(function()
    currentPage += 1
    render()
end)

local bubble = button(gui, "K",
    UDim2.new(0, 18, 0.5, -26),
    UDim2.fromOffset(52, 52))
bubble.TextSize = 25
bubble.Visible = false

minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    bubble.Visible = true
end)

bubble.MouseButton1Click:Connect(function()
    main.Visible = true
    bubble.Visible = false
end)

close.MouseButton1Click:Connect(function()
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    gui:Destroy()
end)

local dragging = false
local dragStart
local initialPosition
local dragInput

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        initialPosition = main.Position
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input == dragInput then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            initialPosition.X.Scale,
            initialPosition.X.Offset + delta.X,
            initialPosition.Y.Scale,
            initialPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

player.CharacterAdded:Connect(function(character)
    local h = character:WaitForChild("Humanoid", 10)
    if h then
        if active["Super Speed"] then
            h.WalkSpeed = 55
        elseif active["Speed Boost"] then
            h.WalkSpeed = 30
        end
        if active["Jump Boost"] then
            h.UseJumpPower = true
            h.JumpPower = 85
        end
    end
end)

render()
notify("KRYPT0X 3.0 ONLINE | " .. #features .. " REAL CONTROLS")
