
--[[
  СКРИПТЕР ULTRA v1.0
  320 FEATURE BLUE HACKER HUB
  16 CATEGORIES x 20 FEATURES
  UNIVERSAL CLIENT-SIDE LOCALSCRIPT

  WORKING = implemented local handler
  PLACEHOLDER = no gameplay effect

  Fling requires server support and consent.
  This client script does not install server code.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Tween = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("SCRIPTER_ULTRA")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(3,9,22),
    panel = Color3.fromRGB(8,22,43),
    card = Color3.fromRGB(12,32,58),
    blue = Color3.fromRGB(0,165,255),
    cyan = Color3.fromRGB(65,225,255),
    text = Color3.fromRGB(218,240,255),
    muted = Color3.fromRGB(110,145,180),
    green = Color3.fromRGB(50,235,150),
    red = Color3.fromRGB(255,95,110)
}

local function new(class,props,parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(obj,r)
    new("UICorner",{
        CornerRadius=UDim.new(0,r or 7)
    },obj)
end

local function stroke(obj,color)
    new("UIStroke",{
        Color=color or C.blue,
        Thickness=1
    },obj)
end

local function label(parent,text,size,pos,color,font)
    return new("TextLabel",{
        BackgroundTransparency=1,
        Size=size,
        Position=pos or UDim2.new(),
        Text=text,
        TextColor3=color or C.text,
        Font=font or Enum.Font.Code,
        TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left
    },parent)
end

local gui = new("ScreenGui",{
    Name="SCRIPTER_ULTRA",
    ResetOnSpawn=false,
    IgnoreGuiInset=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling
},playerGui)

local main = new("Frame",{
    Size=UDim2.fromOffset(790,500),
    Position=UDim2.new(.5,-395,.5,-250),
    BackgroundColor3=C.bg,
    BorderSizePixel=0,
    Active=true
},gui)
corner(main,11)
stroke(main)

local uiScale = new("UIScale",{Scale=1},main)

local top = new("Frame",{
    Size=UDim2.new(1,0,0,70),
    BackgroundColor3=C.panel,
    BorderSizePixel=0,
    Active=true
},main)
corner(top,10)

label(top,"◈ СКРИПТЕР ULTRA",
    UDim2.new(1,-130,0,32),
    UDim2.fromOffset(17,6),
    C.cyan,Enum.Font.Code).TextSize=23

label(top,"BLUE CYBER SYSTEM // 320 MODULES",
    UDim2.new(1,-130,0,22),
    UDim2.fromOffset(18,39),
    C.muted).TextSize=13

local function topButton(txt,x)
    local b = new("TextButton",{
        Size=UDim2.fromOffset(37,35),
        Position=UDim2.new(1,x,0,17),
        BackgroundColor3=C.bg,
        Text=txt,
        TextColor3=C.cyan,
        TextSize=23,
        Font=Enum.Font.Code
    },top)
    corner(b,5)
    stroke(b)
    return b
end

local minimize = topButton("−",-88)
local close = topButton("×",-44)

local restore = new("TextButton",{
    Size=UDim2.fromOffset(132,44),
    Position=UDim2.fromOffset(15,150),
    BackgroundColor3=C.bg,
    Text="◈ СКРИПТЕР",
    TextColor3=C.cyan,
    Font=Enum.Font.Code,
    TextSize=17,
    Visible=false,
    Active=true
},gui)
corner(restore,8)
stroke(restore)

local function show(v)
    main.Visible=v
    restore.Visible=not v
end

minimize.MouseButton1Click:Connect(function()
    show(false)
end)

restore.MouseButton1Click:Connect(function()
    show(true)
end)

local function drag(handle,target)
    local active=false
    local start,original

    handle.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch
        or input.UserInputType==Enum.UserInputType.MouseButton1 then
            active=true
            start=input.Position
            original=target.Position

            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then
                    active=false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not active then return end
        if input.UserInputType~=Enum.UserInputType.Touch
        and input.UserInputType~=Enum.UserInputType.MouseMovement then
            return
        end

        local delta=input.Position-start
        target.Position=UDim2.new(
            original.X.Scale,
            original.X.Offset+delta.X,
            original.Y.Scale,
            original.Y.Offset+delta.Y
        )
    end)
end

drag(top,main)
drag(restore,restore)

local side = new("ScrollingFrame",{
    Position=UDim2.fromOffset(10,80),
    Size=UDim2.new(0,165,1,-123),
    BackgroundColor3=C.panel,
    BorderSizePixel=0,
    ScrollBarThickness=3,
    ScrollBarImageColor3=C.blue,
    CanvasSize=UDim2.new()
},main)
corner(side)

local sideLayout = new("UIListLayout",{
    Padding=UDim.new(0,5)
},side)

local search = new("TextBox",{
    Position=UDim2.fromOffset(185,80),
    Size=UDim2.new(1,-198,0,37),
    BackgroundColor3=C.panel,
    TextColor3=C.text,
    PlaceholderColor3=C.muted,
    PlaceholderText="⌕ SEARCH 320 FEATURES...",
    Text="",
    ClearTextOnFocus=false,
    Font=Enum.Font.Code,
    TextSize=15
},main)
corner(search)
stroke(search,C.card)

local content = new("ScrollingFrame",{
    Position=UDim2.fromOffset(185,125),
    Size=UDim2.new(1,-198,1,-169),
    BackgroundColor3=C.panel,
    BorderSizePixel=0,
    ScrollBarThickness=4,
    ScrollBarImageColor3=C.blue,
    CanvasSize=UDim2.new()
},main)
corner(content)

local contentLayout = new("UIListLayout",{
    Padding=UDim.new(0,5)
},content)

local status = label(main,
    "● SYSTEM ONLINE // READY",
    UDim2.new(1,-24,0,25),
    UDim2.new(0,13,1,-31),
    C.green)
status.TextSize=13

local function log(message)
    status.Text="● "..message
end

local function character()
    return player.Character
end

local function humanoid()
    local c=character()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function root()
    local c=character()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local defaults={
    gravity=workspace.Gravity,
    clock=Lighting.ClockTime,
    fog=Lighting.FogEnd,
    brightness=Lighting.Brightness,
    exposure=Lighting.ExposureCompensation,
    shadows=Lighting.GlobalShadows
}

local connections={}
local enabled={}
local effects={}
local savedPosition=nil
local selectedPlayer=nil
local flingConsent=false

local function disconnect(key)
    if connections[key] then
        connections[key]:Disconnect()
        connections[key]=nil
    end
end

local function getEffect(class,name)
    local obj=Lighting:FindFirstChild(name)
    if not obj then
        obj=Instance.new(class)
        obj.Name=name
        obj.Parent=Lighting
    end
    return obj
end

local function toggleFeature(name,state)
    enabled[name]=state

    if name=="Infinite Jump" then
        disconnect(name)
        if state then
            connections[name]=UIS.JumpRequest:Connect(function()
                local h=humanoid()
                if h then
                    h:ChangeState(
                        Enum.HumanoidStateType.Jumping
                    )
                end
            end)
        end

    elseif name=="Noclip" then
        disconnect(name)
        if state then
            connections[name]=Run.Stepped:Connect(function()
                local c=character()
                if not c then return end
                for _,part in ipairs(c:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if effects[part]==nil then
                            effects[part]=part.CanCollide
                        end
                        part.CanCollide=false
                    end
                end
            end)
        else
            for part,value in pairs(effects) do
                if typeof(part)=="Instance" and part.Parent then
                    part.CanCollide=value
                end
                effects[part]=nil
            end
        end

    elseif name=="Crosshair" then
        local existing=gui:FindFirstChild("Crosshair")
        if existing then existing:Destroy() end

        if state then
            label(gui,"+",
                UDim2.fromOffset(40,40),
                UDim2.new(.5,-20,.5,-20),
                C.cyan).Name="Crosshair"
        end

    elseif name=="FPS Counter" then
        disconnect(name)
        local old=gui:FindFirstChild("FPSCounter")
        if old then old:Destroy() end

        if state then
            local display=label(gui,"FPS: --",
                UDim2.fromOffset(130,26),
                UDim2.fromOffset(12,12),
                C.green)
            display.Name="FPSCounter"

            connections[name]=Run.RenderStepped:Connect(
                function(dt)
                    display.Text="FPS: "..math.floor(
                        1/math.max(dt,.001)
                    )
                end
            )
        end

    elseif name=="Blue Tint" then
        local e=getEffect(
            "ColorCorrectionEffect","ScripterTint"
        )
        e.Enabled=state
        e.TintColor=Color3.fromRGB(115,180,255)

    elseif name=="Bloom" then
        local e=getEffect("BloomEffect","ScripterBloom")
        e.Enabled=state
        e.Intensity=.7
        e.Size=25

    elseif name=="Blur" then
        local e=getEffect("BlurEffect","ScripterBlur")
        e.Enabled=state
        e.Size=8

    else
        enabled[name]=false
        log(name.." // PLACEHOLDER")
        return false
    end

    log(name.." // "..(state and "ON" or "OFF"))
    return true
end

local function runFeature(name)
    local h=humanoid()
    local cam=workspace.CurrentCamera

    local speed=tonumber(name:match("^Speed (%d+)$"))
    local jump=tonumber(name:match("^Jump (%d+)$"))
    local fov=tonumber(name:match("^FOV (%d+)$"))

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
        h.UseJumpPower=true
        h.JumpPower=50

    elseif name=="Sit" and h then
        h.Sit=true

    elseif name=="Stand" and h then
        h.Sit=false

    elseif name=="Low Gravity" then
        workspace.Gravity=75

    elseif name=="Normal Gravity" then
        workspace.Gravity=defaults.gravity

    elseif name=="High Gravity" then
        workspace.Gravity=300

    elseif name=="Fullbright" then
        Lighting.Brightness=5
        Lighting.ClockTime=12

    elseif name=="No Fog" then
        Lighting.FogEnd=100000

    elseif name=="Day" then
        Lighting.ClockTime=12

    elseif name=="Night" then
        Lighting.ClockTime=0

    elseif name=="Sunset" then
        Lighting.ClockTime=18

    elseif name=="Remove Shadows" then
        Lighting.GlobalShadows=false

    elseif name=="Reset Lighting" then
        Lighting.ClockTime=defaults.clock
        Lighting.FogEnd=defaults.fog
        Lighting.Brightness=defaults.brightness
        Lighting.ExposureCompensation=defaults.exposure
        Lighting.GlobalShadows=defaults.shadows

    elseif name=="First Person" then
        player.CameraMode=Enum.CameraMode.LockFirstPerson

    elseif name=="Third Person" then
        player.CameraMode=Enum.CameraMode.Classic

    elseif name=="Reset Camera" then
        player.CameraMode=Enum.CameraMode.Classic
        if cam then cam.FieldOfView=70 end

    elseif name=="Show Coordinates" then
        local r=root()
        if r then log(tostring(r.Position)) end
        return

    elseif name=="Show Health" and h then
        log(math.floor(h.Health).."/"..
            math.floor(h.MaxHealth))
        return

    elseif name=="Player Count" then
        log("PLAYERS: "..#Players:GetPlayers())
        return

    elseif name=="Place ID" then
        log("PLACE ID: "..game.PlaceId)
        return

    elseif name=="User ID" then
        log("USER ID: "..player.UserId)
        return

    elseif name=="Save Position" then
        local r=root()
        if r then savedPosition=r.CFrame end

    elseif name=="Load Position" then
        local r=root()
        if r and savedPosition then
            r.CFrame=savedPosition
        end

    elseif name=="Minimize" then
        show(false)

    elseif name=="UI Pulse" then
        Tween:Create(main,TweenInfo.new(
            .25,Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,2,true
        ),{
            BackgroundColor3=Color3.fromRGB(0,45,85)
        }):Play()

    elseif name=="Credits" then
        log("СКРИПТЕР // HELLO BACK CHAD")
        return

    elseif name=="Show Selected Player" then
        log(selectedPlayer and selectedPlayer.Name
            or "NO PLAYER SELECTED")
        return

    elseif name=="Enable Fling Consent" then
        flingConsent=true
        log("FLING CONSENT // ENABLED")
        return

    elseif name=="Disable Fling Consent" then
        flingConsent=false
        log("FLING CONSENT // DISABLED")
        return

    elseif name=="Fling Selected Player" then
        local event=RS:FindFirstChild("FlingRequest")
        if not event or not event:IsA("RemoteEvent") then
            log("FLING // SERVER SUPPORT REQUIRED")
            return
        end
        if not selectedPlayer then
            log("FLING // SELECT A PLAYER")
            return
        end
        -- Requires a server handler that independently
        -- verifies admin access and target consent.
        event:FireServer(selectedPlayer.UserId)
        log("FLING REQUEST SENT")
        return

    else
        log(name.." // PLACEHOLDER")
        return
    end

    log(name.." // EXECUTED")
end

local categories={
    ["01 MOVEMENT"]={
        "Speed 24","Speed 32","Speed 50","Speed 75",
        "Speed 100","Reset Speed","Jump 65","Jump 90",
        "Jump 120","Reset Jump","Infinite Jump",
        "Noclip","Fly","Fly Speed","Super Jump",
        "Air Walk","Water Walk","Sit","Stand","Dash"
    },

    ["02 VISUALS"]={
        "Fullbright","No Fog","Day","Night","Sunset",
        "Reset Lighting","Remove Shadows","Blue Tint",
        "Bloom","Blur","Crosshair","Player ESP",
        "Item ESP","Tracers","Chams","X-Ray",
        "Night Vision","Thermal Vision",
        "Rainbow World","Visual Reset"
    },

    ["03 CAMERA"]={
        "FOV 60","FOV 70","FOV 90","FOV 110",
        "First Person","Third Person","Reset Camera",
        "Freecam","Spectate","Camera Lock",
        "Camera Spin","Camera Shake","Zoom In",
        "Zoom Out","Camera Tilt","Wide Camera",
        "Cinematic Camera","Smooth Camera",
        "Camera Follow","Camera Reset All"
    },

    ["04 PLAYER"]={
        "Show Coordinates","Show Health","Player Count",
        "Place ID","User ID","Invisibility",
        "Godmode","Anti Ragdoll","No Fall Damage",
        "Auto Heal","Rainbow Avatar","Blue Aura",
        "Avatar Glow","Spin Avatar","Big Head",
        "Tiny Avatar","Giant Avatar","Trail",
        "Sparkles","Reset Avatar"
    },

    ["05 TELEPORT"]={
        "Save Position","Load Position","TP Forward",
        "TP Backward","TP Up","TP Down",
        "TP Spawn","TP Random","TP Player",
        "TP Waypoint","TP Vehicle","TP Safe Zone",
        "TP Home","TP Lobby","TP Checkpoint",
        "TP Last Position","TP Cursor","TP Nearest",
        "TP Spectate","TP Reset"
    },

    ["06 FLING SYSTEM"]={
        "Select Player","Show Selected Player",
        "Enable Fling Consent","Disable Fling Consent",
        "Fling Selected Player","Fling Self",
        "Fling Nearest","Fling All","Fling Aura",
        "Fling Strength","Fling Radius","Fling Cooldown",
        "Fling Protection","Anti Fling","Fling Spin",
        "Fling Launch","Fling Preview","Fling Status",
        "Fling Config","Fling Reset"
    },

    ["07 COMBAT"]={
        "Aimbot","Silent Aim","Aim Assist",
        "Target Lock","Hitbox Extender",
        "Triggerbot","Auto Attack","Rapid Fire",
        "No Recoil","No Spread","Combat ESP",
        "Enemy Highlight","Auto Block","Auto Dodge",
        "Combat Range","Critical Hit","Damage Boost",
        "Weapon Reach","Combat HUD","Combat Reset"
    },

    ["08 WORLD"]={
        "Low Gravity","Normal Gravity","High Gravity",
        "Remove Fog","Sky Blue","Sky Night",
        "World Glow","World Blur","World Bloom",
        "World Neon","Water Color","Terrain View",
        "Weather Clear","Weather Rain","Weather Snow",
        "Cloud Toggle","World Wireframe",
        "World Grid","World Scan","World Reset"
    },

    ["09 VEHICLES"]={
        "Vehicle Speed","Vehicle Fly","Vehicle Jump",
        "Vehicle Flip","Vehicle Repair",
        "Vehicle Boost","Vehicle Hover",
        "Vehicle Drift","Vehicle Gravity",
        "Vehicle Noclip","Vehicle ESP",
        "Vehicle Teleport","Vehicle Spin",
        "Vehicle Brake","Vehicle Horn",
        "Vehicle Lock","Vehicle Unlock",
        "Vehicle Radar","Vehicle Camera",
        "Vehicle Reset"
    },

    ["10 ANIMATIONS"]={
        "Dance 1","Dance 2","Dance 3","Wave",
        "Cheer","Laugh","Point","Sit Animation",
        "Sleep Animation","Float Animation",
        "Spin Animation","Robot Animation",
        "Zombie Animation","Ninja Animation",
        "Run Animation","Walk Animation",
        "Idle Animation","Jump Animation",
        "Animation Speed","Animation Reset"
    },

    ["11 UTILITIES"]={
        "FPS Counter","Ping Monitor","Server Time",
        "Server Hop","Rejoin","Anti AFK",
        "Auto Click","Auto Farm","Auto Collect",
        "Auto Equip","Auto Interact","Auto Sprint",
        "Auto Jump","Clipboard Position",
        "Console","Script Loader","Settings",
        "Minimize","UI Pulse","Credits"
    },

    ["12 FUN"]={
        "Confetti","Fireworks","Disco","Rainbow Sky",
        "Blue Lightning","Hacker Glitch",
        "Matrix Rain","Soundboard","Emote Wheel",
        "Party Mode","Ghost Effect","Cyber Pulse",
        "Neon Trail","Laser Eyes","Blue Flames",
        "Pixel Rain","Glitch Avatar","Cyber Dance",
        "Music Player","Hello Chad"
    },

    ["13 SERVER"]={
        "Server Info","Server Region","Server Age",
        "Server Players","Server Ping","Server FPS",
        "Server ID","Job ID","Private Server",
        "Server Browser","Server Search",
        "Server Refresh","Server History",
        "Server Bookmark","Server Join",
        "Server Leave","Server Reconnect",
        "Server Statistics","Server Logs",
        "Server Status"
    },

    ["14 TARGET"]={
        "Target Select","Target Search","Target Info",
        "Target Health","Target Distance",
        "Target Highlight","Target Tracer",
        "Target Spectate","Target Follow",
        "Target Camera","Target Marker",
        "Target Waypoint","Target Save",
        "Target Load","Target Clear",
        "Target Nearest","Target Furthest",
        "Target Random","Target List",
        "Target Reset"
    },

    ["15 CYBER"]={
        "Cyber Dashboard","Cyber Terminal",
        "Cyber Clock","Cyber Map","Cyber Radar",
        "Cyber Scanner","Cyber Logs",
        "Cyber Notifications","Cyber Theme",
        "Cyber Glow","Cyber Pulse FX",
        "Cyber Grid","Cyber Matrix",
        "Cyber Rain","Cyber Blue",
        "Cyber Red","Cyber Green",
        "Cyber Sound","Cyber Intro",
        "Cyber Outro"
    },

    ["16 CONFIG"]={
        "Save Config","Load Config","Reset Config",
        "Export Config","Import Config",
        "Save Theme","Load Theme",
        "Toggle Sounds","Toggle Animations",
        "Toggle Notifications","Toggle Tooltips",
        "Compact Mode","Large Mode",
        "Mobile Mode","Desktop Mode",
        "UI Transparency","UI Scale",
        "UI Position","Reset UI",
        "About Scripter"
    }
}

local implementedToggles={
    ["Infinite Jump"]=true,
    ["Noclip"]=true,
    ["Crosshair"]=true,
    ["FPS Counter"]=true,
    ["Blue Tint"]=true,
    ["Bloom"]=true,
    ["Blur"]=true
}

local implementedActions={
    ["Reset Speed"]=true,
    ["Reset Jump"]=true,
    ["Sit"]=true,
    ["Stand"]=true,
    ["Low Gravity"]=true,
    ["Normal Gravity"]=true,
    ["High Gravity"]=true,
    ["Fullbright"]=true,
    ["No Fog"]=true,
    ["Day"]=true,
    ["Night"]=true,
    ["Sunset"]=true,
    ["Remove Shadows"]=true,
    ["Reset Lighting"]=true,
    ["First Person"]=true,
    ["Third Person"]=true,
    ["Reset Camera"]=true,
    ["Show Coordinates"]=true,
    ["Show Health"]=true,
    ["Player Count"]=true,
    ["Place ID"]=true,
    ["User ID"]=true,
    ["Save Position"]=true,
    ["Load Position"]=true,
    ["Minimize"]=true,
    ["UI Pulse"]=true,
    ["Credits"]=true,
    ["Show Selected Player"]=true,
    ["Enable Fling Consent"]=true,
    ["Disable Fling Consent"]=true,
    ["Fling Selected Player"]=true
}

local function isImplemented(name)
    return implementedToggles[name]
        or implementedActions[name]
        or name:match("^Speed %d+$")
        or name:match("^Jump %d+$")
        or name:match("^FOV %d+$")
end

local current="01 MOVEMENT"
local featureButtons={}

local function clearButtons()
    for _,obj in ipairs(featureButtons) do
        obj:Destroy()
    end
    table.clear(featureButtons)
end

local function refresh()
    clearButtons()

    local query=search.Text:lower()
    local list=categories[current]

    for _,name in ipairs(list) do
        if query=="" or name:lower():find(query,1,true) then
            local working=isImplemented(name)

            local b=new("TextButton",{
                Size=UDim2.new(1,-10,0,38),
                BackgroundColor3=C.card,
                BorderSizePixel=0,
                Text="",
                AutoButtonColor=true
            },content)
            corner(b,5)

            local title=label(b,name,
                UDim2.new(1,-145,1,0),
                UDim2.fromOffset(10,0),
                C.text)
            title.TextSize=14

            local stateLabel=label(b,
                working and "WORKING" or "PLACEHOLDER",
                UDim2.fromOffset(112,26),
                UDim2.new(1,-120,.5,-13),
                working and C.green or C.muted)
            stateLabel.TextSize=11
            stateLabel.TextXAlignment=Enum.TextXAlignment.Center

            b.MouseButton1Click:Connect(function()
                if not working then
                    log(name.." // PLACEHOLDER")
                    return
                end

                if implementedToggles[name] then
                    local desired=not enabled[name]
                    local success=toggleFeature(name,desired)
                    if success then
                        stateLabel.Text=desired and "ON" or "OFF"
                    end
                else
                    runFeature(name)
                end
            end)

            table.insert(featureButtons,b)
        end
    end

    task.defer(function()
        content.CanvasSize=UDim2.fromOffset(
            0,contentLayout.AbsoluteContentSize.Y+12
        )
    end)
end

local order={
    "01 MOVEMENT","02 VISUALS","03 CAMERA",
    "04 PLAYER","05 TELEPORT","06 FLING SYSTEM",
    "07 COMBAT","08 WORLD","09 VEHICLES",
    "10 ANIMATIONS","11 UTILITIES","12 FUN",
    "13 SERVER","14 TARGET","15 CYBER",
    "16 CONFIG"
}

for _,category in ipairs(order) do
    local button=new("TextButton",{
        Size=UDim2.new(1,-7,0,38),
        BackgroundColor3=C.card,
        Text="▸ "..category,
        TextColor3=C.cyan,
        Font=Enum.Font.Code,
        TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left
    },side)
    corner(button,5)

    button.MouseButton1Click:Connect(function()
        current=category
        refresh()
        log(category.." // 20 MODULES")
    end)
end

side.CanvasSize=UDim2.fromOffset(
    0,#order*43
)

-- Fling player selector panel.
-- The screenshot is used as a design reference.
-- This is not the complete screenshot's server code.

local selector=new("Frame",{
    Size=UDim2.fromOffset(285,320),
    Position=UDim2.new(.5,-142,.5,-160),
    BackgroundColor3=C.bg,
    Visible=false,
    ZIndex=10
},gui)
corner(selector,9)
stroke(selector)

local selectorTitle=label(selector,
    "SELECT FLING TARGET",
    UDim2.new(1,-20,0,36),
    UDim2.fromOffset(10,5),
    C.cyan)
selectorTitle.ZIndex=11

local selectorList=new("ScrollingFrame",{
    Position=UDim2.fromOffset(10,45),
    Size=UDim2.new(1,-20,1,-95),
    BackgroundColor3=C.panel,
    BorderSizePixel=0,
    ScrollBarThickness=4,
    CanvasSize=UDim2.new(),
    ZIndex=11
},selector)

local selectLayout=new("UIListLayout",{
    Padding=UDim.new(0,4)
},selectorList)

local selectClose=new("TextButton",{
    Size=UDim2.new(1,-20,0,36),
    Position=UDim2.new(0,10,1,-42),
    BackgroundColor3=C.card,
    Text="CLOSE",
    TextColor3=C.cyan,
    Font=Enum.Font.Code,
    TextSize=15,
    ZIndex=11
},selector)
corner(selectClose)

selectClose.MouseButton1Click:Connect(function()
    selector.Visible=false
end)

local function populatePlayers()
    for _,child in ipairs(selectorList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _,p in ipairs(Players:GetPlayers()) do
        if p~=player then
            local b=new("TextButton",{
                Size=UDim2.new(1,-5,0,35),
                BackgroundColor3=C.card,
                Text=p.DisplayName.." (@"..p.Name..")",
                TextColor3=C.text,
                Font=Enum.Font.Code,
                TextSize=13,
                ZIndex=12
            },selectorList)
            corner(b,4)

            b.MouseButton1Click:Connect(function()
                selectedPlayer=p
                selector.Visible=false
                log("TARGET: "..p.Name)
            end)
        end
    end

    selectorList.CanvasSize=UDim2.fromOffset(
        0,selectLayout.AbsoluteContentSize.Y+10
    )
end

-- Add a working selector override
implementedActions["Select Player"]=true

local previousRun=runFeature
runFeature=function(name)
    if name=="Select Player" then
        populatePlayers()
        selector.Visible=true
    else
        previousRun(name)
    end
end

-- Responsive layout
local viewportConnection
local function attachViewport()
    if viewportConnection then
        viewportConnection:Disconnect()
    end

    local cam=workspace.CurrentCamera
    if not cam then return end

    local function fit()
        local size=cam.ViewportSize
        uiScale.Scale=math.min(
            1,
            size.X/820,
            size.Y/530
        )
    end

    fit()
    viewportConnection=cam:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(fit)
end

attachViewport()

workspace:GetPropertyChangedSignal(
    "CurrentCamera"
):Connect(attachViewport)

close.MouseButton1Click:Connect(function()
    for key in pairs(connections) do
        disconnect(key)
    end

    if enabled["Noclip"] then
        toggleFeature("Noclip",false)
    end

    gui:Destroy()
end)

refresh()

local total=0
local workingCount=0

for _,list in pairs(categories) do
    for _,name in ipairs(list) do
        total=total+1
        if isImplemented(name) then
            workingCount=workingCount+1
        end
    end
end

log("СКРИПТЕР ONLINE // "..total..
    " SLOTS // "..workingCount.." HANDLERS")
