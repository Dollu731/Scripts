-- CHAD.EXE V1
-- Roblox Studio LocalScript
-- Place in StarterPlayer > StarterPlayerScripts
-- Local powers for your own Roblox experience.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local old = playerGui:FindFirstChild("CHAD_EXE")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "CHAD_EXE"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local C = {
    bg = Color3.fromRGB(5, 7, 15),
    panel = Color3.fromRGB(12, 16, 29),
    purple = Color3.fromRGB(158, 65, 255),
    green = Color3.fromRGB(72, 255, 168),
    white = Color3.fromRGB(235, 238, 255),
    muted = Color3.fromRGB(110, 120, 150)
}

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function stroke(obj, color)
    create("UIStroke", {
        Color = color,
        Thickness = 1.5,
        Transparency = 0.25
    }, obj)
end

local function label(parent, text, size, pos, dims, color)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or C.white,
        Font = Enum.Font.Arcade,
        TextScaled = true,
        TextWrapped = true,
        Position = pos,
        Size = dims
    }, parent)
end

local function tween(obj, duration, props)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(duration, Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out),
        props
    )
    t:Play()
    return t
end

local character, humanoid, root
local originalSpeed = 16

local function refreshCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    root = character:WaitForChild("HumanoidRootPart")
    originalSpeed = humanoid.WalkSpeed
end

refreshCharacter()

-- OPENING CUTSCENE

local intro = create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0)
}, gui)

local avatar = create("ImageLabel", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.45),
    Size = UDim2.fromOffset(230, 230),
    BackgroundTransparency = 1,
    ImageTransparency = 1
}, intro)

local success, thumbnail = pcall(function()
    return Players:GetUserThumbnailAsync(
        player.UserId,
        Enum.ThumbnailType.AvatarBust,
        Enum.ThumbnailSize.Size420x420
    )
end)

if success then
    avatar.Image = thumbnail
end

local slash = create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.45),
    Size = UDim2.fromOffset(0, 5),
    Rotation = -35,
    BackgroundColor3 = C.purple,
    BorderSizePixel = 0
}, intro)

local introText = label(
    intro,
    "HELLO BACK CHAD",
    28,
    UDim2.fromScale(0.1, 0.73),
    UDim2.fromScale(0.8, 0.1),
    C.green
)
introText.TextTransparency = 1

-- MAIN INTERFACE

local main = create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.88, 0.78),
    BackgroundColor3 = C.bg,
    Visible = false
}, gui)
corner(main, 12)
stroke(main, C.purple)

local scale = create("UIScale", {
    Scale = 1
}, main)

local header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 54),
    BackgroundColor3 = C.panel
}, main)
corner(header, 10)

label(
    header,
    "CHAD.EXE // SYSTEM ONLINE",
    18,
    UDim2.fromScale(0.03, 0.1),
    UDim2.fromScale(0.76, 0.8),
    C.green
)

local close = create("TextButton", {
    Text = "X",
    Font = Enum.Font.Arcade,
    TextColor3 = C.white,
    TextScaled = true,
    BackgroundColor3 = C.purple,
    Position = UDim2.new(1, -45, 0, 10),
    Size = UDim2.fromOffset(32, 32)
}, header)
corner(close, 6)

local terminal = create("Frame", {
    Position = UDim2.new(0.025, 0, 0, 70),
    Size = UDim2.new(0.57, 0, 1, -90),
    BackgroundColor3 = C.panel
}, main)
corner(terminal, 8)
stroke(terminal, C.purple)

local console = create("TextLabel", {
    Position = UDim2.fromScale(0.04, 0.04),
    Size = UDim2.fromScale(0.92, 0.92),
    BackgroundTransparency = 1,
    TextColor3 = C.green,
    Font = Enum.Font.Code,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    Text = table.concat({
        "> CHAD.EXE BOOT COMPLETE",
        "> USER: " .. player.Name,
        "> TERMINAL CONNECTED",
        "> POWERS INITIALIZED",
        "> AWAITING COMMAND..."
    }, "\n")
}, terminal)

local function log(message)
    console.Text = console.Text .. "\n> " .. message
    local lines = string.split(console.Text, "\n")
    while #lines > 14 do
        table.remove(lines, 1)
    end
    console.Text = table.concat(lines, "\n")
end

local panel = create("ScrollingFrame", {
    Position = UDim2.fromScale(0.62, 0.12),
    Size = UDim2.fromScale(0.35, 0.84),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.fromScale(0, 0)
}, main)
corner(panel, 8)

create("UIListLayout", {
    Padding = UDim.new(0, 8),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
}, panel)

create("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingBottom = UDim.new(0, 12)
}, panel)

local states = {
    Noclip = false,
    ESP = false,
    Fly = false,
    Invis = false,
    Godmode = false,
    Speed = false
}

local history = {}
local teleportPosition = nil
local buttons = {}
local flyVelocity
local flyAttachment

local function button(name, callback)
    local b = create("TextButton", {
        Name = name,
        Size = UDim2.new(0.9, 0, 0, 44),
        BackgroundColor3 = C.bg,
        TextColor3 = C.white,
        Font = Enum.Font.Arcade,
        TextScaled = true,
        Text = name,
        AutoButtonColor = true
    }, panel)

    corner(b, 7)
    stroke(b, C.purple)

    b.MouseButton1Click:Connect(function()
        callback()
        log(name .. " EXECUTED")
    end)

    buttons[name] = b
    return b
end

local function updateButton(name, active)
    local b = buttons[name]
    if b then
        b.BackgroundColor3 = active and C.purple or C.bg
    end
end

-- NOCLIP
-- Local collision modification.

local collisionCache = {}

RunService.Stepped:Connect(function()
    if not states.Noclip or not character then return end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if collisionCache[part] == nil then
                collisionCache[part] = part.CanCollide
            end
            part.CanCollide = false
        end
    end
end)

button("NOCLIP", function()
    states.Noclip = not states.Noclip

    if not states.Noclip then
        for part, original in pairs(collisionCache) do
            if part and part.Parent then
                part.CanCollide = original
            end
        end
        table.clear(collisionCache)
    end

    updateButton("NOCLIP", states.Noclip)
end)

-- ESP
-- Local highlights for other players.

local highlights = {}

local function removeESP()
    for _, h in pairs(highlights) do
        h:Destroy()
    end
    table.clear(highlights)
end

local function addESP(target)
    if target == player or not states.ESP then return end
    local model = target.Character
    if not model then return end

    if highlights[target] then
        highlights[target]:Destroy()
    end

    highlights[target] = create("Highlight", {
        FillColor = C.purple,
        OutlineColor = C.green,
        FillTransparency = 0.7,
        DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
        Adornee = model
    }, gui)
end

button("ESP", function()
    states.ESP = not states.ESP

    removeESP()

    if states.ESP then
        for _, target in ipairs(Players:GetPlayers()) do
            addESP(target)
        end
    end

    updateButton("ESP", states.ESP)
end)

Players.PlayerAdded:Connect(function(target)
    target.CharacterAdded:Connect(function()
        task.wait(0.5)
        addESP(target)
    end)
end)

for _, target in ipairs(Players:GetPlayers()) do
    if target ~= player then
        target.CharacterAdded:Connect(function()
            task.wait(0.5)
            addESP(target)
        end)
    end
end

-- FLY
-- Uses camera-relative movement.
-- Desktop: WASD, Space, LeftControl.
-- Touch: humanoid movement plus on-screen UP/DOWN controls.

local ascend = false
local descend = false

local flyControls = create("Frame", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.fromScale(0.98, 0.5),
    Size = UDim2.fromOffset(80, 160),
    BackgroundTransparency = 1,
    Visible = false
}, gui)

local function flyControl(text, y, setter)
    local b = create("TextButton", {
        Text = text,
        Font = Enum.Font.Arcade,
        TextScaled = true,
        TextColor3 = C.white,
        BackgroundColor3 = C.purple,
        Size = UDim2.fromOffset(70, 65),
        Position = UDim2.fromOffset(0, y)
    }, flyControls)

    corner(b, 10)

    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            setter(true)
        end
    end)

    b.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            setter(false)
        end
    end)
end

flyControl("UP", 0, function(v) ascend = v end)
flyControl("DOWN", 80, function(v) descend = v end)

local function stopFly()
    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
    end
    if flyAttachment then
        flyAttachment:Destroy()
        flyAttachment = nil
    end

    flyControls.Visible = false
    ascend = false
    descend = false

    if humanoid then
        humanoid.PlatformStand = false
    end
end

button("FLY", function()
    states.Fly = not states.Fly

    if states.Fly then
        flyAttachment = create("Attachment", {}, root)

        flyVelocity = create("LinearVelocity", {
            Attachment0 = flyAttachment,
            MaxForce = math.huge,
            VectorVelocity = Vector3.zero,
            RelativeTo = Enum.ActuatorRelativeTo.World
        }, root)

        flyControls.Visible = true
    else
        stopFly()
    end

    updateButton("FLY", states.Fly)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        ascend = true
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        descend = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        ascend = false
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        descend = false
    end
end)

RunService.Heartbeat:Connect(function()
    if states.Fly and flyVelocity and humanoid then
        local direction = humanoid.MoveDirection * 65

        local vertical = 0
        if ascend then vertical += 65 end
        if descend then vertical -= 65 end

        flyVelocity.VectorVelocity =
            direction + Vector3.new(0, vertical, 0)
    end
end)

-- INVISIBILITY
-- Local visual invisibility.

button("INVIS", function()
    states.Invis = not states.Invis

    for _, obj in ipairs(character:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.LocalTransparencyModifier =
                states.Invis and 1 or 0
        elseif obj:IsA("Decal") then
            obj.Transparency = states.Invis and 1 or 0
        end
    end

    updateButton("INVIS", states.Invis)
end)

-- TELEPORT
-- First press saves location.
-- Second press returns to it.

button("TELEPORT", function()
    if not teleportPosition then
        teleportPosition = root.CFrame
        log("LOCATION SAVED")
    else
        root.CFrame = teleportPosition
        teleportPosition = nil
        log("TELEPORT COMPLETE")
    end
end)

-- FLASHBACK
-- Return to an earlier recorded position.

local historyClock = 0

RunService.Heartbeat:Connect(function(dt)
    historyClock += dt

    if historyClock >= 0.2 then
        historyClock = 0

        if root and root.Parent then
            table.insert(history, root.CFrame)
            if #history > 100 then
                table.remove(history, 1)
            end
        end
    end
end)

button("FLASHBACK", function()
    if #history > 5 then
        local destination = history[1]
        root.CFrame = destination
        root.AssemblyLinearVelocity = Vector3.zero
        table.clear(history)
        log("RETURNED TO PREVIOUS POSITION")
    end
end)

-- GODMODE
-- Local health protection.
-- Server-authoritative damage requires server code.

button("GODMODE", function()
    states.Godmode = not states.Godmode
    updateButton("GODMODE", states.Godmode)
end)

RunService.Heartbeat:Connect(function()
    if states.Godmode and humanoid and humanoid.Health > 0 then
        humanoid.Health = humanoid.MaxHealth
    end
end)

-- SUPER SPEED

button("SUPER SPEED", function()
    states.Speed = not states.Speed

    if humanoid then
        humanoid.WalkSpeed =
            states.Speed and 65 or originalSpeed
    end

    updateButton("SUPER SPEED", states.Speed)
end)

-- CHARACTER RESPAWN HANDLING

player.CharacterAdded:Connect(function()
    stopFly()
    refreshCharacter()
    table.clear(history)
    table.clear(collisionCache)

    for name in pairs(states) do
        states[name] = false
        updateButton(
            name == "Invis" and "INVIS"
            or name == "Speed" and "SUPER SPEED"
            or string.upper(name),
            false
        )
    end

    removeESP()
    log("CHARACTER REINITIALIZED")
end)

-- CLOSE / REOPEN

local launcher = create("TextButton", {
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.fromScale(0.01, 0.5),
    Size = UDim2.fromOffset(55, 55),
    Text = "C",
    Font = Enum.Font.Arcade,
    TextScaled = true,
    TextColor3 = C.green,
    BackgroundColor3 = C.panel,
    Visible = false
}, gui)
corner(launcher, 12)
stroke(launcher, C.purple)

close.MouseButton1Click:Connect(function()
    main.Visible = false
    launcher.Visible = true
end)

launcher.MouseButton1Click:Connect(function()
    launcher.Visible = false
    main.Visible = true
    scale.Scale = 0.85
    tween(scale, 0.3, {Scale = 1})
end)

-- PLAY INTRO ANIMATION

task.spawn(function()
    tween(avatar, 0.6, {ImageTransparency = 0})
    task.wait(0.8)

    -- Purple energy slash
    tween(slash, 0.18, {
        Size = UDim2.fromOffset(470, 7)
    })

    task.wait(0.2)

    -- Flash and avatar split illusion
    local left = create("Frame", {
        BackgroundColor3 = C.purple,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(0.5, 1)
    }, intro)

    local right = create("Frame", {
        BackgroundColor3 = C.purple,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.fromScale(0.5, 1)
    }, intro)

    avatar.Visible = false
    slash.Visible = false

    tween(left, 0.65, {
        Position = UDim2.fromScale(-0.55, 0)
    })

    tween(right, 0.65, {
        Position = UDim2.fromScale(1.05, 0)
    })

    tween(introText, 0.35, {
        TextTransparency = 0
    })

    task.wait(1.1)

    intro:Destroy()
    main.Visible = true
    scale.Scale = 0.7
    tween(scale, 0.5, {Scale = 1})
end)-- CHAD.EXE V1
-- Roblox Studio LocalScript
-- Place in StarterPlayer > StarterPlayerScripts
-- Local powers for your own Roblox experience.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local old = playerGui:FindFirstChild("CHAD_EXE")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "CHAD_EXE"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local C = {
    bg = Color3.fromRGB(5, 7, 15),
    panel = Color3.fromRGB(12, 16, 29),
    purple = Color3.fromRGB(158, 65, 255),
    green = Color3.fromRGB(72, 255, 168),
    white = Color3.fromRGB(235, 238, 255),
    muted = Color3.fromRGB(110, 120, 150)
}

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function stroke(obj, color)
    create("UIStroke", {
        Color = color,
        Thickness = 1.5,
        Transparency = 0.25
    }, obj)
end

local function label(parent, text, size, pos, dims, color)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or C.white,
        Font = Enum.Font.Arcade,
        TextScaled = true,
        TextWrapped = true,
        Position = pos,
        Size = dims
    }, parent)
end

local function tween(obj, duration, props)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(duration, Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out),
        props
    )
    t:Play()
    return t
end

local character, humanoid, root
local originalSpeed = 16

local function refreshCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    root = character:WaitForChild("HumanoidRootPart")
    originalSpeed = humanoid.WalkSpeed
end

refreshCharacter()

-- OPENING CUTSCENE

local intro = create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0)
}, gui)

local avatar = create("ImageLabel", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.45),
    Size = UDim2.fromOffset(230, 230),
    BackgroundTransparency = 1,
    ImageTransparency = 1
}, intro)

local success, thumbnail = pcall(function()
    return Players:GetUserThumbnailAsync(
        player.UserId,
        Enum.ThumbnailType.AvatarBust,
        Enum.ThumbnailSize.Size420x420
    )
end)

if success then
    avatar.Image = thumbnail
end

local slash = create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.45),
    Size = UDim2.fromOffset(0, 5),
    Rotation = -35,
    BackgroundColor3 = C.purple,
    BorderSizePixel = 0
}, intro)

local introText = label(
    intro,
    "HELLO BACK CHAD",
    28,
    UDim2.fromScale(0.1, 0.73),
    UDim2.fromScale(0.8, 0.1),
    C.green
)
introText.TextTransparency = 1

-- MAIN INTERFACE

local main = create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.88, 0.78),
    BackgroundColor3 = C.bg,
    Visible = false
}, gui)
corner(main, 12)
stroke(main, C.purple)

local scale = create("UIScale", {
    Scale = 1
}, main)

local header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 54),
    BackgroundColor3 = C.panel
}, main)
corner(header, 10)

label(
    header,
    "CHAD.EXE // SYSTEM ONLINE",
    18,
    UDim2.fromScale(0.03, 0.1),
    UDim2.fromScale(0.76, 0.8),
    C.green
)

local close = create("TextButton", {
    Text = "X",
    Font = Enum.Font.Arcade,
    TextColor3 = C.white,
    TextScaled = true,
    BackgroundColor3 = C.purple,
    Position = UDim2.new(1, -45, 0, 10),
    Size = UDim2.fromOffset(32, 32)
}, header)
corner(close, 6)

local terminal = create("Frame", {
    Position = UDim2.new(0.025, 0, 0, 70),
    Size = UDim2.new(0.57, 0, 1, -90),
    BackgroundColor3 = C.panel
}, main)
corner(terminal, 8)
stroke(terminal, C.purple)

local console = create("TextLabel", {
    Position = UDim2.fromScale(0.04, 0.04),
    Size = UDim2.fromScale(0.92, 0.92),
    BackgroundTransparency = 1,
    TextColor3 = C.green,
    Font = Enum.Font.Code,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    Text = table.concat({
        "> CHAD.EXE BOOT COMPLETE",
        "> USER: " .. player.Name,
        "> TERMINAL CONNECTED",
        "> POWERS INITIALIZED",
        "> AWAITING COMMAND..."
    }, "\n")
}, terminal)

local function log(message)
    console.Text = console.Text .. "\n> " .. message
    local lines = string.split(console.Text, "\n")
    while #lines > 14 do
        table.remove(lines, 1)
    end
    console.Text = table.concat(lines, "\n")
end

local panel = create("ScrollingFrame", {
    Position = UDim2.fromScale(0.62, 0.12),
    Size = UDim2.fromScale(0.35, 0.84),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.fromScale(0, 0)
}, main)
corner(panel, 8)

create("UIListLayout", {
    Padding = UDim.new(0, 8),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
}, panel)

create("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingBottom = UDim.new(0, 12)
}, panel)

local states = {
    Noclip = false,
    ESP = false,
    Fly = false,
    Invis = false,
    Godmode = false,
    Speed = false
}

local history = {}
local teleportPosition = nil
local buttons = {}
local flyVelocity
local flyAttachment

local function button(name, callback)
    local b = create("TextButton", {
        Name = name,
        Size = UDim2.new(0.9, 0, 0, 44),
        BackgroundColor3 = C.bg,
        TextColor3 = C.white,
        Font = Enum.Font.Arcade,
        TextScaled = true,
        Text = name,
        AutoButtonColor = true
    }, panel)

    corner(b, 7)
    stroke(b, C.purple)

    b.MouseButton1Click:Connect(function()
        callback()
        log(name .. " EXECUTED")
    end)

    buttons[name] = b
    return b
end

local function updateButton(name, active)
    local b = buttons[name]
    if b then
        b.BackgroundColor3 = active and C.purple or C.bg
    end
end

-- NOCLIP
-- Local collision modification.

local collisionCache = {}

RunService.Stepped:Connect(function()
    if not states.Noclip or not character then return end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if collisionCache[part] == nil then
                collisionCache[part] = part.CanCollide
            end
            part.CanCollide = false
        end
    end
end)

button("NOCLIP", function()
    states.Noclip = not states.Noclip

    if not states.Noclip then
        for part, original in pairs(collisionCache) do
            if part and part.Parent then
                part.CanCollide = original
            end
        end
        table.clear(collisionCache)
    end

    updateButton("NOCLIP", states.Noclip)
end)

-- ESP
-- Local highlights for other players.

local highlights = {}

local function removeESP()
    for _, h in pairs(highlights) do
        h:Destroy()
    end
    table.clear(highlights)
end

local function addESP(target)
    if target == player or not states.ESP then return end
    local model = target.Character
    if not model then return end

    if highlights[target] then
        highlights[target]:Destroy()
    end

    highlights[target] = create("Highlight", {
        FillColor = C.purple,
        OutlineColor = C.green,
        FillTransparency = 0.7,
        DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
        Adornee = model
    }, gui)
end

button("ESP", function()
    states.ESP = not states.ESP

    removeESP()

    if states.ESP then
        for _, target in ipairs(Players:GetPlayers()) do
            addESP(target)
        end
    end

    updateButton("ESP", states.ESP)
end)

Players.PlayerAdded:Connect(function(target)
    target.CharacterAdded:Connect(function()
        task.wait(0.5)
        addESP(target)
    end)
end)

for _, target in ipairs(Players:GetPlayers()) do
    if target ~= player then
        target.CharacterAdded:Connect(function()
            task.wait(0.5)
            addESP(target)
        end)
    end
end

-- FLY
-- Uses camera-relative movement.
-- Desktop: WASD, Space, LeftControl.
-- Touch: humanoid movement plus on-screen UP/DOWN controls.

local ascend = false
local descend = false

local flyControls = create("Frame", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.fromScale(0.98, 0.5),
    Size = UDim2.fromOffset(80, 160),
    BackgroundTransparency = 1,
    Visible = false
}, gui)

local function flyControl(text, y, setter)
    local b = create("TextButton", {
        Text = text,
        Font = Enum.Font.Arcade,
        TextScaled = true,
        TextColor3 = C.white,
        BackgroundColor3 = C.purple,
        Size = UDim2.fromOffset(70, 65),
        Position = UDim2.fromOffset(0, y)
    }, flyControls)

    corner(b, 10)

    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            setter(true)
        end
    end)

    b.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            setter(false)
        end
    end)
end

flyControl("UP", 0, function(v) ascend = v end)
flyControl("DOWN", 80, function(v) descend = v end)

local function stopFly()
    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
    end
    if flyAttachment then
        flyAttachment:Destroy()
        flyAttachment = nil
    end

    flyControls.Visible = false
    ascend = false
    descend = false

    if humanoid then
        humanoid.PlatformStand = false
    end
end

button("FLY", function()
    states.Fly = not states.Fly

    if states.Fly then
        flyAttachment = create("Attachment", {}, root)

        flyVelocity = create("LinearVelocity", {
            Attachment0 = flyAttachment,
            MaxForce = math.huge,
            VectorVelocity = Vector3.zero,
            RelativeTo = Enum.ActuatorRelativeTo.World
        }, root)

        flyControls.Visible = true
    else
        stopFly()
    end

    updateButton("FLY", states.Fly)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        ascend = true
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        descend = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        ascend = false
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        descend = false
    end
end)

RunService.Heartbeat:Connect(function()
    if states.Fly and flyVelocity and humanoid then
        local direction = humanoid.MoveDirection * 65

        local vertical = 0
        if ascend then vertical += 65 end
        if descend then vertical -= 65 end

        flyVelocity.VectorVelocity =
            direction + Vector3.new(0, vertical, 0)
    end
end)

-- INVISIBILITY
-- Local visual invisibility.

button("INVIS", function()
    states.Invis = not states.Invis

    for _, obj in ipairs(character:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.LocalTransparencyModifier =
                states.Invis and 1 or 0
        elseif obj:IsA("Decal") then
            obj.Transparency = states.Invis and 1 or 0
        end
    end

    updateButton("INVIS", states.Invis)
end)

-- TELEPORT
-- First press saves location.
-- Second press returns to it.

button("TELEPORT", function()
    if not teleportPosition then
        teleportPosition = root.CFrame
        log("LOCATION SAVED")
    else
        root.CFrame = teleportPosition
        teleportPosition = nil
        log("TELEPORT COMPLETE")
    end
end)

-- FLASHBACK
-- Return to an earlier recorded position.

local historyClock = 0

RunService.Heartbeat:Connect(function(dt)
    historyClock += dt

    if historyClock >= 0.2 then
        historyClock = 0

        if root and root.Parent then
            table.insert(history, root.CFrame)
            if #history > 100 then
                table.remove(history, 1)
            end
        end
    end
end)

button("FLASHBACK", function()
    if #history > 5 then
        local destination = history[1]
        root.CFrame = destination
        root.AssemblyLinearVelocity = Vector3.zero
        table.clear(history)
        log("RETURNED TO PREVIOUS POSITION")
    end
end)

-- GODMODE
-- Local health protection.
-- Server-authoritative damage requires server code.

button("GODMODE", function()
    states.Godmode = not states.Godmode
    updateButton("GODMODE", states.Godmode)
end)

RunService.Heartbeat:Connect(function()
    if states.Godmode and humanoid and humanoid.Health > 0 then
        humanoid.Health = humanoid.MaxHealth
    end
end)

-- SUPER SPEED

button("SUPER SPEED", function()
    states.Speed = not states.Speed

    if humanoid then
        humanoid.WalkSpeed =
            states.Speed and 65 or originalSpeed
    end

    updateButton("SUPER SPEED", states.Speed)
end)

-- CHARACTER RESPAWN HANDLING

player.CharacterAdded:Connect(function()
    stopFly()
    refreshCharacter()
    table.clear(history)
    table.clear(collisionCache)

    for name in pairs(states) do
        states[name] = false
        updateButton(
            name == "Invis" and "INVIS"
            or name == "Speed" and "SUPER SPEED"
            or string.upper(name),
            false
        )
    end

    removeESP()
    log("CHARACTER REINITIALIZED")
end)

-- CLOSE / REOPEN

local launcher = create("TextButton", {
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.fromScale(0.01, 0.5),
    Size = UDim2.fromOffset(55, 55),
    Text = "C",
    Font = Enum.Font.Arcade,
    TextScaled = true,
    TextColor3 = C.green,
    BackgroundColor3 = C.panel,
    Visible = false
}, gui)
corner(launcher, 12)
stroke(launcher, C.purple)

close.MouseButton1Click:Connect(function()
    main.Visible = false
    launcher.Visible = true
end)

launcher.MouseButton1Click:Connect(function()
    launcher.Visible = false
    main.Visible = true
    scale.Scale = 0.85
    tween(scale, 0.3, {Scale = 1})
end)

-- PLAY INTRO ANIMATION

task.spawn(function()
    tween(avatar, 0.6, {ImageTransparency = 0})
    task.wait(0.8)

    -- Purple energy slash
    tween(slash, 0.18, {
        Size = UDim2.fromOffset(470, 7)
    })

    task.wait(0.2)

    -- Flash and avatar split illusion
    local left = create("Frame", {
        BackgroundColor3 = C.purple,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(0.5, 1)
    }, intro)

    local right = create("Frame", {
        BackgroundColor3 = C.purple,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.fromScale(0.5, 1)
    }, intro)

    avatar.Visible = false
    slash.Visible = false

    tween(left, 0.65, {
        Position = UDim2.fromScale(-0.55, 0)
    })

    tween(right, 0.65, {
        Position = UDim2.fromScale(1.05, 0)
    })

    tween(introText, 0.35, {
        TextTransparency = 0
    })

    task.wait(1.1)

    intro:Destroy()
    main.Visible = true
    scale.Scale = 0.7
    tween(scale, 0.5, {Scale = 1})
end)
