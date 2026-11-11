-- QUATUM: EVENT ROOM server systems
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Lighting=game:GetService("Lighting")
local SoundService=game:GetService("SoundService")
local Debris=game:GetService("Debris")
local remote=RS:FindFirstChild("QuantumEvent") or Instance.new("RemoteEvent")
remote.Name="QuantumEvent";remote.Parent=RS
local PRODUCTS={
 ["Prism Trail"]={cost=75},["Pulse Burst"]={cost=100},["Spotlight Aura"]={cost=125},["Confetti Cannon"]={cost=150},
}
local data,contest,rhythm={}, {active=false,ends=0,scores={}}, {active=false,ends=0,scores={},hits={}}
local cooldowns={}
local function part(parent,name,size,cf,color,material,collide)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cf;p.Color=color;p.Material=material or Enum.Material.SmoothPlastic;p.Anchored=true;p.CanCollide=collide~=false;p.Parent=parent;return p
end
local function sign(parent,name,value,cf)
 local p=part(parent,name,Vector3.new(24,5,.4),cf,Color3.fromRGB(10,12,28),Enum.Material.Neon,false)
 local g=Instance.new("SurfaceGui",p);g.Face=Enum.NormalId.Front;g.CanvasSize=Vector2.new(800,180)
 local t=Instance.new("TextLabel",g);t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=value;t.TextColor3=Color3.fromRGB(78,255,231);t.TextScaled=true;t.Font=Enum.Font.GothamBlack
end
local function buildVenue()
 local old=workspace:FindFirstChild("QuantumVenue");if old then old:Destroy()end
 local v=Instance.new("Folder",workspace);v.Name="QuantumVenue"
 Lighting.ClockTime=0;Lighting.Brightness=2;Lighting.Ambient=Color3.fromRGB(62,65,120);Lighting.EnvironmentDiffuseScale=.4;Lighting.EnvironmentSpecularScale=.8
 part(v,"DanceFloor",Vector3.new(150,2,130),CFrame.new(0,-1,0),Color3.fromRGB(17,19,42),Enum.Material.Metal)
 part(v,"Stage",Vector3.new(52,3,20),CFrame.new(0,1.5,-42),Color3.fromRGB(45,24,76),Enum.Material.Neon)
 for i=-5,5 do local c=Color3.fromHSV((i+5)/11,.85,1);local q=part(v,"StageBeam",Vector3.new(.35,18,.35),CFrame.new(i*4.5,11,-52),c,Enum.Material.Neon,false);local l=Instance.new("PointLight",q);l.Color=c;l.Range=25;l.Brightness=2 end
 for i=1,10 do local a=i*math.pi/5;local c=Color3.fromHSV(i/10,.8,1);local q=part(v,"LightPillar",Vector3.new(2,20,2),CFrame.new(math.cos(a)*58,9,math.sin(a)*48),c,Enum.Material.Neon);local l=Instance.new("PointLight",q);l.Color=c;l.Range=25;l.Brightness=2 end
 for _,z in ipairs({-65,65})do part(v,"Wall",Vector3.new(150,25,2),CFrame.new(0,11,z),Color3.fromRGB(10,12,28),Enum.Material.Metal)end
 for _,x in ipairs({-75,75})do part(v,"Wall",Vector3.new(2,25,130),CFrame.new(x,11,0),Color3.fromRGB(10,12,28),Enum.Material.Metal)end
 sign(v,"MainSign","QUATUM: EVENT ROOM",CFrame.new(0,15,-53));sign(v,"ContestSign","DANCE CONTEST",CFrame.new(-39,8,15)*CFrame.Angles(0,math.rad(90),0));sign(v,"RhythmSign","RHYTHM STATION",CFrame.new(39,8,15)*CFrame.Angles(0,math.rad(-90),0))
 for _,z in ipairs({-8,20})do part(v,"ZoneStrip",Vector3.new(50,.15,1),CFrame.new(0,.1,z),Color3.fromRGB(245,87,214),Enum.Material.Neon,false)end
 local sound=SoundService:FindFirstChild("QuantumConcertMusic")or Instance.new("Sound",SoundService);sound.Name="QuantumConcertMusic";sound.SoundId="rbxassetid://1843529600";sound.Volume=.25;sound.Looped=true;pcall(function()sound:Play()end)
 return v
end
buildVenue()
local function stat(p,n)local ls=p:FindFirstChild("leaderstats");return ls and ls:FindFirstChild(n)end
local function packet(p)
 local t,e=stat(p,"Tokens"),stat(p,"Energy");if not t or not e then return end
 local d=data[p]or{owned={},equipped=nil}
 remote:FireClient(p,"State",{tokens=t.Value,energy=e.Value,owned=d.owned,equipped=d.equipped,contest=contest.active,contestEnds=contest.ends,contestScore=contest.scores[p.UserId]or 0,rhythm=rhythm.active,rhythmEnds=rhythm.ends,rhythmScore=rhythm.scores[p.UserId]or 0})
end
local function notice(s)remote:FireAllClients("Notice",s)end
local function beginActivity(state,duration,label,reward)
 if state.active then return end;state.active=true;state.ends=os.time()+duration;state.scores={}
 for _,p in ipairs(Players:GetPlayers())do state.scores[p.UserId]=0;packet(p)end
 notice(label.." LIVE! Dance to score for "..duration.." seconds!")
 task.delay(duration,function()
  if not state.active then return end;state.active=false;local winner,high=nil,0
  for _,p in ipairs(Players:GetPlayers())do local score=state.scores[p.UserId]or 0;if score>high then winner,high=p,score end end
  if winner then local t=stat(winner,"Tokens");if t then t.Value+=reward end;notice(winner.DisplayName.." won "..label.."! +"..reward.." tokens")else notice(label.." ended with no winner.")end
  for _,p in ipairs(Players:GetPlayers())do packet(p)end
 end)
end
Players.PlayerAdded:Connect(function(p)
 local ls=Instance.new("Folder",p);ls.Name="leaderstats"
 for n,v in pairs({Tokens=50,Energy=100})do local x=Instance.new("IntValue",ls);x.Name=n;x.Value=v end
 data[p]={owned={},equipped=nil};p.CharacterAdded:Connect(function(c)local r=c:WaitForChild("HumanoidRootPart",10);if r then r.CFrame=CFrame.new(math.random(-18,18),4,18)end end);task.delay(1,function()if p.Parent then packet(p)end end)
end)
Players.PlayerRemoving:Connect(function(p)data[p]=nil;contest.scores[p.UserId]=nil;rhythm.scores[p.UserId]=nil;cooldowns[p]=nil end)
remote.OnServerEvent:Connect(function(p,action,value)
 local d=data[p];if not d then return end
 if action=="Dance"then
  local now=os.clock();if cooldowns[p]and now-cooldowns[p]<1.4 then return end;cooldowns[p]=now
  local e=stat(p,"Energy");if not e then return end;e.Value=math.min(100,e.Value+7)
  if contest.active then contest.scores[p.UserId]=(contest.scores[p.UserId]or 0)+10 end
  if rhythm.active then rhythm.scores[p.UserId]=(rhythm.scores[p.UserId]or 0)+15 end
  packet(p);remote:FireClient(p,"DanceFX")
 elseif action=="Contest"then beginActivity(contest,45,"DANCE CONTEST",100)
 elseif action=="Rhythm"then beginActivity(rhythm,30,"RHYTHM STATION",75)
 elseif action=="Buy"and type(value)=="string"and PRODUCTS[value]and not d.owned[value]then
  local t=stat(p,"Tokens");local cost=PRODUCTS[value].cost;if not t or t.Value<cost then remote:FireClient(p,"Notice","You need "..cost.." tokens.");return end;t.Value-=cost;d.owned[value]=true;d.equipped=value;packet(p);remote:FireClient(p,"Notice",value.." unlocked and equipped!")
 elseif action=="Equip"and type(value)=="string"and PRODUCTS[value]and d.owned[value]then d.equipped=value;packet(p);remote:FireClient(p,"Notice",value.." equipped.")
 elseif action=="Power"and type(value)=="string"and PRODUCTS[value]and d.owned[value]then
  local now=os.clock();if cooldowns[p]and now-cooldowns[p]<4 then remote:FireClient(p,"Notice","Power cooling down.");return end
  local c=p.Character;local r=c and c:FindFirstChild("HumanoidRootPart");if not r then return end;cooldowns[p]=now
  if value=="Spotlight Aura"then local l=Instance.new("PointLight",r);l.Color=Color3.fromRGB(255,93,232);l.Range=24;l.Brightness=5;Debris:AddItem(l,8)
  elseif value=="Prism Trail"then local a=Instance.new("Attachment",r);local b=Instance.new("Attachment",r);a.Position=Vector3.new(-1,0,0);b.Position=Vector3.new(1,0,0);local tr=Instance.new("Trail",r);tr.Attachment0=a;tr.Attachment1=b;tr.Lifetime=1;tr.LightEmission=1;tr.Color=ColorSequence.new(Color3.fromRGB(47,255,226),Color3.fromRGB(234,78,255));Debris:AddItem(tr,8);Debris:AddItem(a,8);Debris:AddItem(b,8)
  elseif value=="Pulse Burst"or value=="Confetti Cannon"then local q=Instance.new("Part",workspace);q.Shape=Enum.PartType.Ball;q.Anchored=true;q.CanCollide=false;q.Material=Enum.Material.Neon;q.Color=value=="Pulse Burst"and Color3.fromRGB(78,255,231)or Color3.fromRGB(255,93,232);q.Transparency=.3;q.Position=r.Position;task.spawn(function()for _=1,16 do if not q.Parent then break end;q.Size+=Vector3.new(3,3,3);q.Transparency=math.min(.95,q.Transparency+.04);task.wait(.04)end;q:Destroy()end)end
  remote:FireClient(p,"Notice",value.." activated!")
 end
end)
task.spawn(function()while true do task.wait(1);for _,p in ipairs(Players:GetPlayers())do local e=stat(p,"Energy");if e then e.Value=math.min(100,e.Value+1)end end end end)
task.spawn(function()while true do task.wait(90);if #Players:GetPlayers()>0 and not contest.active and not rhythm.active then if math.random(1,2)==1 then beginActivity(contest,45,"DANCE CONTEST",100)else beginActivity(rhythm,30,"RHYTHM STATION",75)end end end end)
print("QUATUM: EVENT ROOM systems ready")