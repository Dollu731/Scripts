
-- KRYPT0X ULTRA HUB V2 | 1020 modular slots
-- Client-side Roblox Luau UI. Use only where permitted.
local Players = game:GetService('Players')
local TweenService = game:GetService('TweenService')
local UIS = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local player = Players.LocalPlayer
local guiParent = (gethui and gethui()) or player:WaitForChild('PlayerGui')
local old = guiParent:FindFirstChild('KRYPT0X_UltraHub')
if old then old:Destroy() end
local gui = Instance.new('ScreenGui')
gui.Name = 'KRYPT0X_UltraHub'; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
pcall(function() gui.Parent = guiParent end)
if not gui.Parent then gui.Parent = player:WaitForChild('PlayerGui') end
local C = {bg=Color3.fromRGB(7,13,25),panel=Color3.fromRGB(13,27,46),panel2=Color3.fromRGB(19,39,63),blue=Color3.fromRGB(35,186,255),white=Color3.fromRGB(225,243,255),muted=Color3.fromRGB(124,160,190),green=Color3.fromRGB(77,230,164)}
local function new(class,props,parent)
 local o=Instance.new(class)
 for k,v in pairs(props or {}) do o[k]=v end
 o.Parent=parent; return o
end
local function round(o,r) new('UICorner',{CornerRadius=UDim.new(0,r or 9)},o) end
local function stroke(o,color) new('UIStroke',{Color=color or C.blue,Thickness=1,Transparency=.45},o) end
local main=new('Frame',{Name='Main',Size=UDim2.fromOffset(740,470),Position=UDim2.new(.5,-370,.5,-235),BackgroundColor3=C.bg,BorderSizePixel=0,ClipsDescendants=true},gui)
round(main,12);stroke(main)
local scale=new('UIScale',{Scale=1},main)
local function rescale()
 local view=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(900,600)
 scale.Scale=math.min(1,math.max(.46,math.min((view.X-18)/740,(view.Y-40)/470)))
end
rescale()
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(rescale) end
local top=new('Frame',{Size=UDim2.new(1,0,0,55),BackgroundColor3=C.panel,BorderSizePixel=0},main)
new('TextLabel',{Size=UDim2.new(1,-155,0,30),Position=UDim2.fromOffset(18,5),BackgroundTransparency=1,Text='KRYPT0X  //  ULTRA HUB',TextColor3=C.blue,TextSize=22,Font=Enum.Font.Code,TextXAlignment=Enum.TextXAlignment.Left},top)
new('TextLabel',{Size=UDim2.new(1,-155,0,17),Position=UDim2.fromOffset(19,32),BackgroundTransparency=1,Text='SYSTEM ONLINE  •  1020 MODULE SLOTS',TextColor3=C.muted,TextSize=12,Font=Enum.Font.Code,TextXAlignment=Enum.TextXAlignment.Left},top)
local function btn(text,x,w,parent)
 local b=new('TextButton',{Size=UDim2.fromOffset(w,29),Position=UDim2.new(1,x,0,12),BackgroundColor3=C.panel2,Text=text,TextColor3=C.white,TextSize=17,Font=Enum.Font.Code,AutoButtonColor=true},parent)
 round(b,6);return b
end
local minimize=btn('—',-89,35,top)
local close=btn('×',-47,35,top)
local restore=new('TextButton',{Visible=false,Size=UDim2.fromOffset(145,43),Position=UDim2.fromOffset(18,110),BackgroundColor3=C.panel,Text='⌘ KRYPT0X',TextColor3=C.blue,TextSize=17,Font=Enum.Font.Code},gui)
round(restore,9);stroke(restore)
minimize.MouseButton1Click:Connect(function() main.Visible=false;restore.Visible=true end)
restore.MouseButton1Click:Connect(function() main.Visible=true;restore.Visible=false end)
close.MouseButton1Click:Connect(function() gui:Destroy() end)
-- Drag from the title bar (mouse and touch).
local dragging,startPos,original
local function dragStart(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
  dragging=true;startPos=input.Position;original=main.Position
 end
end
top.InputBegan:Connect(dragStart)
UIS.InputChanged:Connect(function(input)
 if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
  local d=input.Position-startPos
  main.Position=UDim2.new(original.X.Scale,original.X.Offset+d.X,original.Y.Scale,original.Y.Offset+d.Y)
 end
end)
UIS.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
local side=new('ScrollingFrame',{Size=UDim2.new(0,177,1,-101),Position=UDim2.fromOffset(10,65),BackgroundColor3=C.panel,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=UDim2.new()},main)
round(side,8)
local sideLayout=new('UIListLayout',{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},side)
sideLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function() side.CanvasSize=UDim2.fromOffset(0,sideLayout.AbsoluteContentSize.Y+10) end)
local search=new('TextBox',{Size=UDim2.new(1,-210,0,36),Position=UDim2.fromOffset(197,65),BackgroundColor3=C.panel2,PlaceholderText='> SEARCH MODULES...',Text='',TextColor3=C.white,PlaceholderColor3=C.muted,TextSize=15,Font=Enum.Font.Code,ClearTextOnFocus=false},main)
round(search,7)
local content=new('ScrollingFrame',{Size=UDim2.new(1,-210,1,-166),Position=UDim2.fromOffset(197,109),BackgroundColor3=C.panel,BorderSizePixel=0,ScrollBarThickness=4,CanvasSize=UDim2.new()},main)
round(content,8)
local layout=new('UIListLayout',{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},content)
layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function() content.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+12) end)
local status=new('TextLabel',{Size=UDim2.new(1,-25,0,26),Position=UDim2.new(0,14,1,-30),BackgroundTransparency=1,Text='> READY // SELECT A MODULE',TextColor3=C.green,TextSize=12,Font=Enum.Font.Code,TextXAlignment=Enum.TextXAlignment.Left},main)
local function log(s) status.Text='> '..s end
local categories={'PLAYER','MOVEMENT','VISUALS','TELEPORT','WORLD','ANIMATIONS','UTILITIES','CUSTOMIZATION','CAMERA','AUDIO','INTERFACE','EXPERIMENTAL'}
local selected=categories[1]
local modules={}
for ci,cat in ipairs(categories) do
 modules[cat]={}
 for i=1,85 do
  local id=(ci-1)*85+i
  modules[cat][i]={id=id,name=string.format('%s MODULE %03d',cat,id),description='Reserved extension slot',run=nil}
 end
end
local function implement(cat,index,name,description,fn)
 local m=modules[cat][index];m.name=name;m.description=description;m.run=fn
end
local function characterHumanoid()
 local c=player.Character or player.CharacterAdded:Wait()
 return c:FindFirstChildOfClass('Humanoid')
end
local speedEnabled=false
implement('MOVEMENT',1,'LOCAL WALK SPEED','Toggle client-side walk speed (may be overridden by game)',function()
 local h=characterHumanoid();if not h then return 'NO HUMANOID' end
 speedEnabled=not speedEnabled;h.WalkSpeed=speedEnabled and 24 or 16
 return speedEnabled and 'WALK SPEED: 24' or 'WALK SPEED: 16'
end)
implement('MOVEMENT',2,'LOCAL JUMP HEIGHT','Toggle client-side jump power',function()
 local h=characterHumanoid();if not h then return 'NO HUMANOID' end
 h.UseJumpPower=true;h.JumpPower=h.JumpPower>50 and 50 or 70
 return 'JUMP POWER: '..tostring(h.JumpPower)
end)
local fullbright=false
local Lighting=game:GetService('Lighting')
local originalBrightness=Lighting.Brightness
implement('VISUALS',1,'LOCAL BRIGHTNESS','Toggle local lighting brightness',function()
 fullbright=not fullbright;Lighting.Brightness=fullbright and 4 or originalBrightness
 return fullbright and 'BRIGHTNESS ON' or 'BRIGHTNESS OFF'
end)
implement('CAMERA',1,'CAMERA FOV','Cycle local camera field of view',function()
 local camera=workspace.CurrentCamera;if not camera then return 'NO CAMERA' end
 local f=camera.FieldOfView;camera.FieldOfView=f>=100 and 70 or f+10
 return 'FOV: '..math.floor(camera.FieldOfView)
end)
implement('UTILITIES',1,'SHOW POSITION','Display your character coordinates',function()
 local c=player.Character;local root=c and c:FindFirstChild('HumanoidRootPart')
 if not root then return 'NO ROOT PART' end
 local p=root.Position;return string.format('XYZ: %.0f, %.0f, %.0f',p.X,p.Y,p.Z)
end)
implement('UTILITIES',2,'PLAYER COUNT','Display players in current server',function()
 return 'PLAYERS: '..#Players:GetPlayers()
end)
implement('CUSTOMIZATION',1,'ACCENT COLOR','Switch between blue and purple theme accents',function()
 C.blue=(C.blue==Color3.fromRGB(35,186,255)) and Color3.fromRGB(177,115,255) or Color3.fromRGB(35,186,255)
 log('ACCENT CHANGED');return 'THEME ACCENT UPDATED'
end)
local function render()
 for _,v in ipairs(content:GetChildren()) do if v:IsA('TextButton') then v:Destroy() end end
 local term=string.lower(search.Text)
 local shown=0
 for _,m in ipairs(modules[selected]) do
  if term=='' or string.find(string.lower(m.name),term,1,true) or string.find(tostring(m.id),term,1,true) then
   shown+=1
   local b=new('TextButton',{LayoutOrder=m.id,Size=UDim2.new(1,-13,0,46),BackgroundColor3=C.panel2,Text='',AutoButtonColor=true},content)
   round(b,6)
   new('TextLabel',{Size=UDim2.new(1,-105,0,23),Position=UDim2.fromOffset(10,3),BackgroundTransparency=1,Text=string.format('[%04d] %s',m.id,m.name),TextColor3=m.run and C.white or C.muted,TextSize=13,Font=Enum.Font.Code,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},b)
   new('TextLabel',{Size=UDim2.new(1,-105,0,16),Position=UDim2.fromOffset(11,26),BackgroundTransparency=1,Text=m.description,TextColor3=C.muted,TextSize=10,Font=Enum.Font.Code,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},b)
   new('TextLabel',{Size=UDim2.fromOffset(83,30),Position=UDim2.new(1,-90,0,8),BackgroundTransparency=1,Text=m.run and 'RUN >' or 'SLOT',TextColor3=m.run and C.green or C.muted,TextSize=13,Font=Enum.Font.Code},b)
   b.MouseButton1Click:Connect(function()
    if not m.run then log(string.format('MODULE %04d RESERVED // NOT IMPLEMENTED',m.id));return end
    local ok,result=pcall(m.run)
    log(ok and tostring(result or 'MODULE EXECUTED') or 'MODULE ERROR')
   end)
  end
 end
 log(selected..' // '..shown..' OF 85 SLOTS')
end
for i,cat in ipairs(categories) do
 local b=new('TextButton',{LayoutOrder=i,Size=UDim2.new(1,-7,0,33),BackgroundColor3=C.panel2,Text=string.format('%02d  %s',i,cat),TextColor3=C.white,TextSize=12,Font=Enum.Font.Code,TextXAlignment=Enum.TextXAlignment.Left},side)
 round(b,5)
 new('UIPadding',{PaddingLeft=UDim.new(0,9)},b)
 b.MouseButton1Click:Connect(function() selected=cat;content.CanvasPosition=Vector2.zero;render() end)
end
search:GetPropertyChangedSignal('Text'):Connect(render)
render()
main.BackgroundTransparency=1
TweenService:Create(main,TweenInfo.new(.45,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play()
print('[KRYPT0X] Loaded 1020 slots across 12 categories. 7 demo utilities implemented.')
