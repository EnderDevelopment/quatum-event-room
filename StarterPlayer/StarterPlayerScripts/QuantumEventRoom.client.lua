-- QUATUM: EVENT ROOM client UI and controls
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Tween=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local remote=RS:WaitForChild("QuantumEvent")
local C={bg=Color3.fromRGB(11,13,29),panel=Color3.fromRGB(24,27,53),cyan=Color3.fromRGB(72,248,226),pink=Color3.fromRGB(245,87,214),violet=Color3.fromRGB(172,159,255),white=Color3.fromRGB(239,241,255),muted=Color3.fromRGB(155,162,194)}
local gui=Instance.new("ScreenGui",player:WaitForChild("PlayerGui"));gui.Name="QuantumEventUI";gui.ResetOnSpawn=false
local function make(class,parent,props)local x=Instance.new(class,parent);for k,v in pairs(props)do x[k]=v end;return x end
local function corner(x,r)make("UICorner",x,{CornerRadius=UDim.new(0,r)})end
local function stroke(x,c)make("UIStroke",x,{Color=c,Thickness=1.3,Transparency=.2})end
local function text(parent,s,size,color,font)return make("TextLabel",parent,{BackgroundTransparency=1,Text=s,TextSize=size,TextColor3=color or C.white,Font=font or Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true})end
local root=make("Frame",gui,{Size=UDim2.fromScale(1,1),BackgroundTransparency=1})
local header=make("Frame",root,{Position=UDim2.new(0,20,0,18),Size=UDim2.new(0,390,0,78),BackgroundColor3=C.bg,BackgroundTransparency=.06});corner(header,14);stroke(header,C.cyan)
local title=text(header,"QUATUM",25,C.cyan,Enum.Font.GothamBlack);title.Position=UDim2.new(0,16,0,8);title.Size=UDim2.new(1,-30,0,30)
local sub=text(header,"EVENT ROOM  •  SOCIAL CONCERT HANGOUT",11,C.muted,Enum.Font.GothamBold);sub.Position=UDim2.new(0,17,0,43);sub.Size=UDim2.new(1,-30,0,22)
local stats=make("Frame",root,{Position=UDim2.new(1,-250,0,18),Size=UDim2.new(0,230,0,78),BackgroundColor3=C.bg,BackgroundTransparency=.06});corner(stats,14);stroke(stats,C.pink)
local tokens=text(stats,"◈  50 TOKENS",16,C.white,Enum.Font.GothamBold);tokens.Position=UDim2.new(0,14,0,8);tokens.Size=UDim2.new(1,-20,0,25)
local energy=text(stats,"ENERGY  100 / 100",12,C.cyan,Enum.Font.GothamBold);energy.Position=UDim2.new(0,15,0,40);energy.Size=UDim2.new(1,-20,0,20)
local status=text(root,"Explore the venue • Dance • Join activities • Unlock powers",13,C.white,Enum.Font.GothamBold);status.AnchorPoint=Vector2.new(.5,0);status.Position=UDim2.new(.5,0,0,108);status.Size=UDim2.new(0,600,0,30);status.TextXAlignment=Enum.TextXAlignment.Center
local toast=text(root,"",16,C.white,Enum.Font.GothamBold);toast.AnchorPoint=Vector2.new(.5,0);toast.Position=UDim2.new(.5,0,0,145);toast.Size=UDim2.new(0,530,0,44);toast.TextXAlignment=Enum.TextXAlignment.Center;toast.BackgroundColor3=C.panel;toast.Visible=false;corner(toast,10)
local function button(parent,label,pos,size,color)local b=make("TextButton",parent,{Position=pos,Size=size,BackgroundColor3=color,Text=label,TextColor3=C.bg,TextSize=14,Font=Enum.Font.GothamBold});corner(b,10);return b end
local dock=make("Frame",root,{AnchorPoint=Vector2.new(.5,1),Position=UDim2.new(.5,0,1,-20),Size=UDim2.new(0,570,0,62),BackgroundColor3=C.bg,BackgroundTransparency=.04});corner(dock,16);stroke(dock,C.cyan)
local dance=button(dock,"♪  DANCE",UDim2.new(0,8,0,8),UDim2.new(0,125,0,46),C.cyan)
local contest=button(dock,"★  CONTEST",UDim2.new(0,141,0,8),UDim2.new(0,135,0,46),C.pink)
local rhythm=button(dock,"◉  RHYTHM",UDim2.new(0,284,0,8),UDim2.new(0,130,0,46),C.violet)
local inventory=button(dock,"▣  INVENTORY",UDim2.new(0,422,0,8),UDim2.new(0,140,0,46),C.cyan)
local panel=make("Frame",root,{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-20,.5,0),Size=UDim2.new(0,330,0,430),BackgroundColor3=C.bg,Visible=false});corner(panel,16);stroke(panel,C.pink)
local ptitle=text(panel,"INVENTORY + POWERS",18,C.pink,Enum.Font.GothamBlack);ptitle.Position=UDim2.new(0,16,0,14);ptitle.Size=UDim2.new(1,-60,0,28)
local close=button(panel,"×",UDim2.new(1,-44,0,10),UDim2.new(0,32,0,30),C.pink)
local hint=text(panel,"Q toggles panel • Buy, equip, and activate items",11,C.muted);hint.Position=UDim2.new(0,16,0,48);hint.Size=UDim2.new(1,-28,0,30)
local list=make("Frame",panel,{Position=UDim2.new(0,12,0,88),Size=UDim2.new(1,-24,1,-100),BackgroundTransparency=1});make("UIListLayout",list,{Padding=UDim.new(0,7)})
local items={"Prism Trail","Pulse Burst","Spotlight Aura","Confetti Cannon"};local owned={};local equipped=nil
local function notice(s)toast.Text=s;toast.Visible=true;toast.TextTransparency=0;toast.BackgroundTransparency=.08;task.delay(3,function()if toast.Parent then Tween:Create(toast,TweenInfo.new(.3),{TextTransparency=1,BackgroundTransparency=1}):Play();task.delay(.35,function()toast.Visible=false end)end end)end
local function refresh()
 for _,x in ipairs(list:GetChildren())do if x:IsA("GuiObject")then x:Destroy()end end
 for _,item in ipairs(items)do local has=owned[item]==true;local row=make("Frame",list,{Size=UDim2.new(1,0,0,70),BackgroundColor3=C.panel});corner(row,10)
  local n=text(row,item,14,C.white,Enum.Font.GothamBold);n.Position=UDim2.new(0,10,0,7);n.Size=UDim2.new(1,-125,0,22)
  local d=text(row,has and (equipped==item and "EQUIPPED" or "OWNED") or "SHOP  •  BUY",10,has and C.cyan or C.muted);d.Position=UDim2.new(0,10,0,37);d.Size=UDim2.new(1,-125,0,18)
  local b=button(row,has and (equipped==item and "USE" or "EQUIP") or "BUY",UDim2.new(1,-92,0,18),UDim2.new(0,82,0,34),has and C.cyan or C.pink)
  b.Activated:Connect(function()if has then if equipped==item then remote:FireServer("Power",item) else remote:FireServer("Equip",item) end else remote:FireServer("Buy",item)end end)
 end
end
local track
local function animateDance()local c=player.Character;local h=c and c:FindFirstChildOfClass("Humanoid");if not h then return end;local a=h:FindFirstChildOfClass("Animator")or Instance.new("Animator",h);local anim=Instance.new("Animation");anim.AnimationId="rbxassetid://507771019";local ok,t=pcall(function()return a:LoadAnimation(anim)end);if ok and t then track=t;t:Play(.1);task.delay(3,function()if t.IsPlaying then t:Stop(.2)end end)end end
local function danceNow()animateDance();remote:FireServer("Dance")end
dance.Activated:Connect(danceNow);contest.Activated:Connect(function()remote:FireServer("Contest")end);rhythm.Activated:Connect(function()remote:FireServer("Rhythm")end);inventory.Activated:Connect(function()panel.Visible=not panel.Visible end);close.Activated:Connect(function()panel.Visible=false end)
UIS.InputBegan:Connect(function(input,processed)if processed then return end;if input.KeyCode==Enum.KeyCode.Q then panel.Visible=not panel.Visible elseif input.KeyCode==Enum.KeyCode.Space then danceNow()end end)
remote.OnClientEvent:Connect(function(kind,v)if kind=="State" then tokens.Text="◈  "..v.tokens.." TOKENS";energy.Text="ENERGY  "..v.energy.." / 100";owned=v.owned or {};equipped=v.equipped;refresh();contest.Text=v.contest and "★ LIVE "..math.max(0,v.contestEnds-os.time()).."s" or "★ CONTEST";rhythm.Text=v.rhythm and "◉ LIVE "..math.max(0,v.rhythmEnds-os.time()).."s" or "◉ RHYTHM";status.Text=v.contest and "Dance Contest active • Score: "..v.contestScore or v.rhythm and "Rhythm Station active • Score: "..v.rhythmScore or "Explore the venue • Dance • Join activities • Unlock powers" elseif kind=="Notice" then notice(tostring(v))elseif kind=="DanceFX" then local s=dance.Size;Tween:Create(dance,TweenInfo.new(.1),{Size=UDim2.new(0,132,0,49)}):Play();task.delay(.12,function()if dance.Parent then Tween:Create(dance,TweenInfo.new(.1),{Size=s}):Play()end end)end end)
refresh();player.CharacterAdded:Connect(function()track=nil end)