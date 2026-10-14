
-- EDEX ULTRA BLUE | 120 FEATURES
-- HELLO BACK CHAD
-- Universal client-side Roblox GUI

local P = game:GetService("Players")
local U = game:GetService("UserInputService")
local R = game:GetService("RunService")
local L = game:GetService("Lighting")
local T = game:GetService("TweenService")

local me = P.LocalPlayer
local pg = me:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("EDEX_ULTRA")
if old then old:Destroy() end

local blue = Color3.fromRGB(0,170,255)
local dark = Color3.fromRGB(3,11,25)
local panel = Color3.fromRGB(9,28,48)
local white = Color3.fromRGB(205,235,255)

local function make(class, props, parent)
    local o = Instance.new(class)
    for k,v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end

local gui = make("ScreenGui", {
    Name="EDEX_ULTRA",
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling
}, pg)

local main = make("Frame", {
    Size=UDim2.fromOffset(760,460),
    Position=UDim2.new(.5,-380,.5,-230),
    BackgroundColor3=dark,
    BorderSizePixel=0,
    Active=true
},gui)

make("UICorner",{CornerRadius=UDim.new(0,10)},main)
make("UIStroke",{Color=blue,Thickness=2},main)

local scale = make("UIScale",{Scale=1},main)

local top = make("Frame",{
    Size=UDim2.new(1,0,0,65),
    BackgroundColor3=panel,
    BorderSizePixel=0
},main)

make("TextLabel",{
    Size=UDim2.new(1,-120,0,32),
    Position=UDim2.fromOffset(14,4),
    BackgroundTransparency=1,
    Text="◈ EDEX ULTRA // BLUE EDITION",
    TextColor3=blue,
    TextSize=21,
    Font=Enum.Font.Code,
    TextXAlignment=Enum.TextXAlignment.Left
},top)

make("TextLabel",{
    Size=UDim2.new(1,-120,0,22),
    Position=UDim2.fromOffset(14,35),
    BackgroundTransparency=1,
    Text="HELLO BACK CHAD | 120 FEATURES",
    TextColor3=white,
    TextSize=13,
    Font=Enum.Font.Code,
    TextXAlignment=Enum.TextXAlignment.Left
},top)

local function smallButton(txt,x)
    return make("TextButton",{
        Size=UDim2.fromOffset(37,34),
        Position=UDim2.new(1,x,0,14),
        Text=txt,
        TextSize=22,
        Font=Enum.Font.Code,
        TextColor3=blue,
        BackgroundColor3=dark
    },top)
end

local mini=smallButton("−",-86)
local exit=smallButton("×",-43)

local restore=make("TextButton",{
    Size=UDim2.fromOffset(105,43),
    Position=UDim2.new(0,15,.45,0),
    BackgroundColor3=dark,
    TextColor3=blue,
    Text="◈ EDEX",
    Font=Enum.Font.Code,
    TextSize=20,
    Visible=false
},gui)

make("UIStroke",{Color=blue,Thickness=2},restore)

local function show(v)
    main.Visible=v
    restore.Visible=not v
end

mini.MouseButton1Click:Connect(function()
    show(false)
end)

restore.MouseButton1Click:Connect(function()
    show(true)
end)

exit.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Mouse and touch dragging
local function drag(handle,target)
    local dragging=false
    local start,origin

    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch
        or i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            start=i.Position
            origin=target.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then
                    dragging=false
                end
            end)
        end
    end)

    U.InputChanged:Connect(function(i)
        if dragging and (
            i.UserInputType==Enum.UserInputType.Touch
            or i.UserInputType==Enum.UserInputType.MouseMovement
        ) then
            local d=i.Position-start
            target.Position=UDim2.new(
                origin.X.Scale,origin.X.Offset+d.X,
                origin.Y.Scale,origin.Y.Offset+d.Y
            )
        end
    end)
end

drag(top,main)
drag(restore,restore)

local sidebar=make("ScrollingFrame",{
    Position=UDim2.fromOffset(10,72),
    Size=UDim2.new(0,155,1,-112),
    BackgroundColor3=panel,
    BorderSizePixel=0,
    ScrollBarThickness=3,
    CanvasSize=UDim2.new()
},main)

make("UIListLayout",{
    Padding=UDim.new(0,5)
},sidebar)

local search=make("TextBox",{
    Position=UDim2.fromOffset(175,74),
    Size=UDim2.new(1,-187,0,35),
    BackgroundColor3=panel,
    TextColor3=white,
    PlaceholderText="⌕ Search features...",
    Text="",
    Font=Enum.Font.Code,
    TextSize=16,
    ClearTextOnFocus=false
},main)

local content=make("ScrollingFrame",{
    Position=UDim2.fromOffset(175,117),
    Size=UDim2.new(1,-187,1,-160),
    BackgroundColor3=panel,
    BorderSizePixel=0,
    ScrollBarThickness=4,
    CanvasSize=UDim2.new()
},main)

local layout=make("UIListLayout",{
    Padding=UDim.new(0,5)
},content)

local status=make("TextLabel",{
    Position=UDim2.new(0,12,1,-30),
    Size=UDim2.new(1,-24,0,25),
    BackgroundTransparency=1,
    Text="● SYSTEM ONLINE | 120 MODULES",
    TextColor3=blue,
    TextSize=13,
    Font=Enum.Font.Code,
    TextXAlignment=Enum.TextXAlignment.Left
},main)

local function log(s)
    status.Text="● "..s
end

local function humanoid()
    local c=me.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function root()
    local c=me.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local connections={}
local toggles={}

local function stop(key)
    if connections[key] then
        connections[key]:Disconnect()
        connections[key]=nil
    end
end

local original={
    Clock=L.ClockTime,
    Fog=L.FogEnd,
    Brightness=L.Brightness,
    Gravity=workspace.Gravity
}

local function action(name)
    local h=humanoid()
    local cam=workspace.CurrentCamera

    local speed=tonumber(name:match("^Speed (%d+)"))
    local jump=tonumber(name:match("^Jump (%d+)"))
    local fov=tonumber(name:match("^FOV (%d+)"))

    if speed and h then
        h.WalkSpeed=speed

    elseif jump and h then
        h.UseJumpPower=true
        h.JumpPower=jump

    elseif fov and cam then
        cam.FieldOfView=fov

    elseif name=="Reset Speed" and h then
        h.WalkSpeed=16

    elseif name=="Reset Jump" and h then
        h.JumpPower=50

    elseif name=="Fullbright" then
        L.Brightness=5
        L.ClockTime=12

    elseif name=="No Fog" then
        L.FogEnd=100000

    elseif name=="Day" then
        L.ClockTime=12

    elseif name=="Night" then
        L.ClockTime=0

    elseif name=="Sunset" then
        L.ClockTime=18

    elseif name=="Reset Lighting" then
        L.ClockTime=original.Clock
        L.FogEnd=original.Fog
        L.Brightness=original.Brightness

    elseif name=="Low Gravity" then
        workspace.Gravity=75

    elseif name=="Normal Gravity" then
        workspace.Gravity=original.Gravity

    elseif name=="High Gravity" then
        workspace.Gravity=300

    elseif name=="Sit" and h then
        h.Sit=true

    elseif name=="Stand" and h then
        h.Sit=false

    elseif name=="First Person" then
        me.CameraMode=Enum.CameraMode.LockFirstPerson

    elseif name=="Third Person" then
        me.CameraMode=Enum.CameraMode.Classic

    elseif name=="Reset Camera" then
        me.CameraMode=Enum.CameraMode.Classic
        if cam then cam.FieldOfView=70 end

    elseif name=="Show Coordinates" then
        local r=root()
        if r then log(tostring(r.Position)) end
        return

    elseif name=="Show Health" and h then
        log(math.floor(h.Health).."/"..math.floor(h.MaxHealth))
        return

    elseif name=="Player Count" then
        log("PLAYERS: "..#P:GetPlayers())
        return

    elseif name=="Place ID" then
        log("PLACE: "..game.PlaceId)
        return

    elseif name=="User ID" then
        log("USER: "..me.UserId)
        return

    elseif name=="Minimize" then
        show(false)

    elseif name=="Blue Tint" then
        local e=L:FindFirstChild("EDEX_Tint")
        if not e then
            e=Instance.new("ColorCorrectionEffect")
            e.Name="EDEX_Tint"
            e.Parent=L
        end
        e.TintColor=Color3.fromRGB(120,185,255)

    elseif name=="Remove Tint" then
        local e=L:FindFirstChild("EDEX_Tint")
        if e then e:Destroy() end

    elseif name=="UI Pulse" then
        T:Create(main,TweenInfo.new(.25,Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,2,true),{
            BackgroundColor3=Color3.fromRGB(0,50,90)
        }):Play()

    elseif name=="Credits" then
        log("HELLO BACK CHAD // EDEX ULTRA")
        return

    else
        log(name.." // UNAVAILABLE")
        return
    end

    log(name.." // EXECUTED")
end

local function toggle(name,on)
    if name=="Infinite Jump" then
        stop("jump")
        if on then
            connections.jump=U.JumpRequest:Connect(function()
                local h=humanoid()
                if h then
                    h:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end

    elseif name=="Noclip" then
        stop("noclip")
        if on then
            connections.noclip=R.Stepped:Connect(function()
                local c=me.Character
                if not c then return end
                for _,v in ipairs(c:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide=false
                    end
                end
            end)
        end

    elseif name=="Crosshair" then
        local old=gui:FindFirstChild("Crosshair")
        if old then old:Destroy() end
        if on then
            make("TextLabel",{
                Name="Crosshair",
                Position=UDim2.new(.5,-20,.5,-20),
                Size=UDim2.fromOffset(40,40),
                BackgroundTransparency=1,
                Text="+",
                TextSize=36,
                TextColor3=blue
            },gui)
        end

    elseif name=="FPS HUD" then
        stop("fps")
        local old=gui:FindFirstChild("FPS")
        if old then old:Destroy() end
        if on then
            local label=make("TextLabel",{
                Name="FPS",
                Size=UDim2.fromOffset(120,28),
                Position=UDim2.fromOffset(10,10),
                BackgroundColor3=dark,
                TextColor3=blue,
                Font=Enum.Font.Code,
                TextSize=17
            },gui)
            connections.fps=R.RenderStepped:Connect(function(dt)
                label.Text="FPS: "..math.floor(1/math.max(dt,.001))
            end)
        end

    else
        log(name.." // UNAVAILABLE")
        return
    end

    log(name..(on and " // ON" or " // OFF"))
end

-- 6 categories, 20 slots each = 120
local categories={
    Movement={
        "Speed 24","Speed 32","Speed 50","Speed 75",
        "Speed 100","Reset Speed","Jump 65","Jump 90",
        "Jump 120","Reset Jump","Infinite Jump","Noclip",
        "Fly","Fly Speed","Super Jump","Air Walk",
        "Water Walk","Sit","Stand","Dash"
    },
    Visuals={
        "Fullbright","No Fog","Day","Night","Sunset",
        "Reset Lighting","Blue Tint","Remove Tint",
        "Crosshair","FPS HUD","Player ESP","Item ESP",
        "Tracers","Chams","Rainbow World",
        "Remove Shadows","X-Ray","Night Vision",
        "Thermal Vision","Visual Reset"
    },
    Camera={
        "FOV 60","FOV 70","FOV 90","FOV 110",
        "First Person","Third Person","Reset Camera",
        "Freecam","Spectate","Camera Lock",
        "Camera Spin","Camera Shake","Zoom In",
        "Zoom Out","Camera Tilt","Wide Camera",
        "Cinematic Camera","Smooth Camera",
        "Camera Follow","Camera Reset All"
    },
    Player={
        "Show Coordinates","Show Health","Player Count",
        "Place ID","User ID","Invisibility",
        "Godmode","Anti Ragdoll","No Fall Damage",
        "Auto Heal","Rainbow Avatar","Blue Aura",
        "Avatar Glow","Spin Avatar","Big Head",
        "Tiny Avatar","Giant Avatar","Trail",
        "Sparkles","Reset Avatar"
    },
    Utilities={
        "Low Gravity","Normal Gravity","High Gravity",
        "Minimize","UI Pulse","Server Time",
        "Ping Monitor","Server Hop","Rejoin",
        "Teleport Tool","Waypoint Save","Waypoint Load",
        "Anti AFK","Auto Click","Auto Farm",
        "Clipboard Position","Console","Script Loader",
        "Settings","Credits"
    },
    Fun={
        "Dance 1","Dance 2","Dance 3","Wave",
        "Cheer","Laugh","Point","Confetti",
        "Fireworks","Disco","Rainbow Sky",
        "Blue Lightning","Hacker Glitch","Matrix Rain",
        "Soundboard","Emote Wheel","Party Mode",
        "Ghost Effect","Cyber Pulse","Hello Chad"
    }
}

local toggleable={
    ["Infinite Jump"]=true,
    ["Noclip"]=true,
    ["Crosshair"]=true,
    ["FPS HUD"]=true
}

local active="Movement"
local buttons={}

local function refresh()
    for _,b in ipairs(buttons) do
        b:Destroy()
    end
    table.clear(buttons)

    local query=search.Text:lower()

    for _,name in ipairs(categories[active]) do
        if query=="" or name:lower():find(query,1,true) then
            local b=make("TextButton",{
                Size=UDim2.new(1,-8,0,35),
                BackgroundColor3=dark,
                BorderSizePixel=0,
                Text="",
                AutoButtonColor=true
            },content)

            make("UICorner",{
                CornerRadius=UDim.new(0,5)
            },b)

            make("TextLabel",{
                Size=UDim2.new(1,-95,1,0),
                Position=UDim2.fromOffset(10,0),
                BackgroundTransparency=1,
                Text=name,
                Font=Enum.Font.Code,
                TextSize=15,
                TextColor3=white,
                TextXAlignment=Enum.TextXAlignment.Left
            },b)

            local isToggle=toggleable[name]
            local indicator=make("TextLabel",{
                Size=UDim2.fromOffset(68,25),
                Position=UDim2.new(1,-78,.5,-12),
                BackgroundColor3=Color3.fromRGB(0,80,130),
                Text=isToggle and "OFF" or "RUN",
                Font=Enum.Font.Code,
                TextSize=13,
                TextColor3=white
            },b)

            b.MouseButton1Click:Connect(function()
                if isToggle then
                    toggles[name]=not toggles[name]
                    toggle(name,toggles[name])
                    indicator.Text=toggles[name] and "ON" or "OFF"
                    indicator.BackgroundColor3=toggles[name]
                        and blue or Color3.fromRGB(0,80,130)
                else
                    action(name)
                end
            end)

            table.insert(buttons,b)
        end
    end

    task.defer(function()
        content.CanvasSize=UDim2.fromOffset(
            0,layout.AbsoluteContentSize.Y+12
        )
    end)
end

local order={
    "Movement","Visuals","Camera",
    "Player","Utilities","Fun"
}

for _,category in ipairs(order) do
    local b=make("TextButton",{
        Size=UDim2.new(1,-5,0,44),
        BackgroundColor3=dark,
        Text="▸ "..category:upper().." [20]",
        TextColor3=blue,
        Font=Enum.Font.Code,
        TextSize=15
    },sidebar)

    b.MouseButton1Click:Connect(function()
        active=category
        refresh()
    end)
end

sidebar.CanvasSize=UDim2.fromOffset(0,300)
search:GetPropertyChangedSignal("Text"):Connect(refresh)

local function fit()
    local cam=workspace.CurrentCamera
    if cam then
        local v=cam.ViewportSize
        scale.Scale=math.min(1,v.X/790,v.Y/500)
    end
end

fit()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(fit)
end

refresh()
log("EDEX ULTRA ONLINE // 120 FEATURES INDEXED")
