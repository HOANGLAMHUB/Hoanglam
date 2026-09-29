--[[====================================================================================
  HOÀNG LÂM HUB v14.1 — FIXED FULL EDITION
  MADE BY HOÀNG LÂM · ZALO 0363194767 · © 2026
  Blox Fruits · Sea 1/2/3 · Delta X / PC / Mobile
  FIXES: Combat remote format · ESP Adornee · Quest logic · Movement · Bring
  17 TABS · 60+ CHỨC NĂNG
====================================================================================]]

if not game:IsLoaded() then game.Loaded:Wait() end
if not getgenv then getgenv = getfenv end

local AUTHOR = { name="Hoàng Lâm", zalo="0363194767", version="v14.1", brand="HOÀNG LÂM HUB" }
local SERVER_URL = "https://keyserver-hchy.onrender.com"
local KEY_FILE = "HL_key.txt"
local CFG_FILE = "HL_config.json"

--====================================================================================
-- KEY SYSTEM
--====================================================================================
do
    local Http = game:GetService("HttpService")
    local LPk = game:GetService("Players").LocalPlayer
    local SGk = game:GetService("StarterGui")
    local GUIk = (gethui and gethui()) or game:GetService("CoreGui")
    local function notifyk(t,x,d) pcall(function() SGk:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 5}) end) end
    local function enc(s) return (tostring(s):gsub("([^%w%-_%.~])", function(c) return string.format("%%%02X", string.byte(c)) end)) end
    local function httpGet(url)
        local ok, b = pcall(function() return game:HttpGet(url) end)
        if ok and b and b ~= "" then return b end
        local req = request or http_request or (syn and syn.request)
        if req then
            local ok2, res = pcall(req,{Url=url,Method="GET"})
            if ok2 and res then
                if type(res) == "table" and res.Body then return res.Body end
                if type(res) == "string" then return res end
            end
        end
        return nil
    end
    local function hwidf()
        local ok, r = pcall(function() if gethwid then return gethwid() end end)
        if ok and r then
            if type(r) == "table" then r = r[1] or r[2] or "" end
            r = tostring(r):gsub("%s+","")
            if #r >= 3 then return r end
        end
        return "UID_" .. tostring(LPk and LPk.UserId or 0)
    end
    local HWID = hwidf()
    local function api(path)
        local body = httpGet(SERVER_URL .. path)
        if not body then return nil, "Không kết nối server key." end
        local ok, d = pcall(function() return Http:JSONDecode(body) end)
        if not ok or type(d) ~= "table" then return nil, "Server trả sai định dạng." end
        return d
    end
    local REASON = { expired="Key hết hạn.", wrong_hwid="Key thuộc máy khác.", not_found="Key không đúng.", missing="Thiếu key." }
    local function verify(key)
        key = (tostring(key or ""):gsub("%s+","")):upper()
        if key == "" then return false, "Chưa nhập key." end
        local d, err = api("/api/verify?key="..enc(key).."&hwid="..enc(HWID))
        if not d then return false, err end
        if d.status == "success" and d.valid == true then return true end
        return false, REASON[d.reason] or "Key không hợp lệ."
    end
    local function saveK(k) pcall(function() if writefile then writefile(KEY_FILE, tostring(k):gsub("%s+","")) end end) end
    local function clearK() pcall(function() if delfile and isfile and isfile(KEY_FILE) then delfile(KEY_FILE) end end) end
    local PASSED = false
    do
        local s
        pcall(function()
            if isfile and isfile(KEY_FILE) and readfile then s = tostring(readfile(KEY_FILE) or ""):gsub("%s+","") end
        end)
        if s and s ~= "" then
            if verify(s) then PASSED = true notifyk(AUTHOR.brand, "Key còn hạn ✔") else clearK() end
        end
    end
    if not PASSED then
        local Tk = { bg0=Color3.fromRGB(6,8,14), bg1=Color3.fromRGB(12,15,24), bg2=Color3.fromRGB(18,22,34), bg3=Color3.fromRGB(26,32,48), txt=Color3.fromRGB(240,244,255), dim=Color3.fromRGB(150,160,185), fnt=Color3.fromRGB(78,88,112), acc=Color3.fromRGB(255,200,90), hot=Color3.fromRGB(255,230,160), ok=Color3.fromRGB(72,235,168), bad=Color3.fromRGB(255,100,115) }
        local Fk = { black=Enum.Font.GothamBlack, bold=Enum.Font.GothamBold, reg=Enum.Font.Gotham, mono=Enum.Font.Code }
        local function mkk(c,p) local o=Instance.new(c) for k,v in pairs(p) do if k~="Parent" then pcall(function() o[k]=v end) end end o.Parent=p.Parent return o end
        local function cork(o,r) mkk("UICorner",{CornerRadius=UDim.new(0,r or 8),Parent=o}) end
        local function strok(o,c,t,tr) mkk("UIStroke",{Color=c or Tk.acc,Thickness=t or 1,Transparency=tr or 0.4,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=o}) end
        local sgk = mkk("ScreenGui",{Name="HL_KeyUI",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=GUIk})
        local Wk,Hk = 400,540
        local maink = mkk("Frame",{Size=UDim2.new(0,Wk,0,Hk),Position=UDim2.new(0.5,-Wk/2,0.5,-Hk/2),BackgroundColor3=Tk.bg0,BorderSizePixel=0,Active=true,Draggable=true,Parent=sgk})
        cork(maink,18); strok(maink,Tk.acc,1.2,0.5)
        mkk("Frame",{Size=UDim2.new(1,-36,0,2),Position=UDim2.new(0,18,0,0),BackgroundColor3=Tk.acc,BorderSizePixel=0,Parent=maink})
        local logok = mkk("Frame",{Size=UDim2.new(0,58,0,58),Position=UDim2.new(0,28,0,26),BackgroundColor3=Tk.bg3,BorderSizePixel=0,Parent=maink})
        cork(logok,999); strok(logok,Tk.acc,1.5,0.3)
        mkk("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="HL",Font=Fk.black,TextSize=24,TextColor3=Tk.hot,Parent=logok})
        mkk("TextLabel",{Size=UDim2.new(0,280,0,26),Position=UDim2.new(0,100,0,30),BackgroundTransparency=1,Text=AUTHOR.brand.." "..AUTHOR.version,Font=Fk.black,TextSize=20,TextColor3=Tk.txt,TextXAlignment=Enum.TextXAlignment.Left,Parent=maink})
        mkk("TextLabel",{Size=UDim2.new(0,280,0,16),Position=UDim2.new(0,100,0,58),BackgroundTransparency=1,Text="MADE BY "..AUTHOR.name:upper().." · ZALO "..AUTHOR.zalo,Font=Fk.reg,TextSize=10,TextColor3=Tk.fnt,TextXAlignment=Enum.TextXAlignment.Left,Parent=maink})
        local statusk = mkk("TextLabel",{Size=UDim2.new(1,-56,0,44),Position=UDim2.new(0,28,0,100),BackgroundTransparency=1,Text="Dán key để sử dụng.",Font=Fk.reg,TextSize=12,TextColor3=Tk.dim,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,Parent=maink})
        local function setStatk(s,c) statusk.Text=s statusk.TextColor3=c or Tk.dim end
        mkk("TextLabel",{Size=UDim2.new(1,-56,0,14),Position=UDim2.new(0,28,0,148),BackgroundTransparency=1,Text="YOUR KEY",Font=Fk.bold,TextSize=10,TextColor3=Tk.fnt,TextXAlignment=Enum.TextXAlignment.Left,Parent=maink})
        local keyBoxk = mkk("TextBox",{Size=UDim2.new(1,-56,0,46),Position=UDim2.new(0,28,0,166),BackgroundColor3=Tk.bg2,BorderSizePixel=0,PlaceholderText="HL-XXXX-XXXX-XXXX",PlaceholderColor3=Tk.fnt,Text="",Font=Fk.mono,TextSize=14,TextColor3=Tk.hot,ClearTextOnFocus=false,Parent=maink})
        cork(keyBoxk,10); strok(keyBoxk,Tk.acc,1,0.6)
        local function btnk(txt,y,bg)
            local b=mkk("TextButton",{Size=UDim2.new(1,-56,0,46),Position=UDim2.new(0,28,0,y),BackgroundColor3=bg,BorderSizePixel=0,Text=txt,Font=Fk.black,TextSize=14,TextColor3=Color3.new(1,1,1),Parent=maink})
            cork(b,11) return b
        end
        local verifyBtnk = btnk("✔  VERIFY KEY",226,Color3.fromRGB(30,120,88))
        mkk("TextLabel",{Size=UDim2.new(1,-56,0,16),Position=UDim2.new(0,28,0,284),BackgroundTransparency=1,Text="— CHƯA CÓ KEY? —",Font=Fk.bold,TextSize=10,TextColor3=Tk.fnt,Parent=maink})
        local getBtnk = btnk("📋  GET KEY (COPY LINK)",306,Color3.fromRGB(40,92,148))
        local buyBtnk = btnk("💰  MUA KEY (ZALO)",356,Color3.fromRGB(150,100,30))
        local linkBoxk = mkk("TextBox",{Size=UDim2.new(1,-56,0,60),Position=UDim2.new(0,28,0,412),BackgroundColor3=Tk.bg1,BorderSizePixel=0,Text="Link vượt sẽ hiện ở đây.",Font=Fk.mono,TextSize=11,TextColor3=Tk.dim,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,ClearTextOnFocus=false,Parent=maink})
        cork(linkBoxk,10)
        mkk("TextLabel",{Size=UDim2.new(1,-56,0,40),Position=UDim2.new(0,28,0,480),BackgroundTransparency=1,Text="© 2026 "..AUTHOR.name.." · Zalo "..AUTHOR.zalo,Font=Fk.reg,TextSize=10,TextColor3=Tk.fnt,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=maink})
        getBtnk.MouseButton1Click:Connect(function()
            setStatk("Đang tạo link...",Tk.dim)
            local d, err = api("/api/getlink?hwid="..enc(HWID))
            if not d then setStatk("✘ "..tostring(err),Tk.bad) return end
            if d.status == "success" and d.link then
                linkBoxk.Text = d.link
                pcall(function() if setclipboard then setclipboard(d.link) end end)
                setStatk("✔ Đã COPY link.",Tk.ok)
            else setStatk("✘ "..tostring(d.message or "Lỗi."),Tk.bad) end
        end)
        buyBtnk.MouseButton1Click:Connect(function()
            setStatk("Liên hệ Zalo "..AUTHOR.zalo,Tk.hot)
            pcall(function() if setclipboard then setclipboard(AUTHOR.zalo) end end)
        end)
        verifyBtnk.MouseButton1Click:Connect(function()
            setStatk("Đang kiểm tra...",Tk.dim)
            local ok, info = verify(keyBoxk.Text)
            if ok then
                saveK(keyBoxk.Text)
                setStatk("✔ Key hợp lệ!",Tk.ok)
                notifyk(AUTHOR.brand,"Key hợp lệ ✔")
                task.wait(0.6)
                sgk:Destroy()
                PASSED = true
            else setStatk("✘ "..tostring(info),Tk.bad) end
        end)
        while not PASSED do task.wait(0.15) end
    end
end

--====================================================================================
-- CORE
--====================================================================================
local S = {
    Players=game:GetService("Players"), Run=game:GetService("RunService"),
    Tween=game:GetService("TweenService"), UIS=game:GetService("UserInputService"),
    RS=game:GetService("ReplicatedStorage"), WS=game:GetService("Workspace"),
    Light=game:GetService("Lighting"), TP=game:GetService("TeleportService"),
    Http=game:GetService("HttpService"), VU=game:GetService("VirtualUser"),
    SG=game:GetService("StarterGui"), CG=game:GetService("CoreGui"),
}
local LP = S.Players.LocalPlayer
local GUI = (gethui and gethui()) or S.CG
local MOBILE = S.UIS.TouchEnabled and not S.UIS.MouseEnabled
local VP = S.WS.CurrentCamera.ViewportSize

if not firetouchinterest then firetouchinterest = function() end end
if not fireclickdetector then fireclickdetector = function() end end

pcall(function()
    for _, g in ipairs(GUI:GetChildren()) do
        if g.Name == "HL_Hub" or g.Name == "HL_Watermark" or g.Name == "HL_KeyUI" or g.Name == "HL_FOV" then g:Destroy() end
    end
    local old = S.WS:FindFirstChild("HL_MoveBlock")
    if old then old:Destroy() end
end)

local UNPACK = table.unpack or unpack
local function notify(t,x,d) pcall(function() S.SG:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 4}) end) end
local CONN = {}
local function conn(sig, fn) local c = sig:Connect(fn) CONN[#CONN+1] = c return c end

local R = {}
do
    local rm = S.RS:FindFirstChild("Remotes") or S.RS:FindFirstChild("Remote")
    if rm then
        R.CommF = rm:FindFirstChild("CommF_") or rm:FindFirstChild("CommF")
        R.Raids = rm:FindFirstChild("Raids")
        R.Btn = rm:FindFirstChild("ButtonEnabler")
    end
    local md = S.RS:FindFirstChild("Modules")
    if md then
        local net = md:FindFirstChild("Net")
        if net then
            R.Attack = net:FindFirstChild("RE/RegisterAttack")
            R.Hit = net:FindFirstChild("RE/RegisterHit")
        end
    end
end
local function Invoke(...)
    if not R.CommF then return nil end
    local a = {...}
    local ok, r = pcall(function() return R.CommF:InvokeServer(UNPACK(a)) end)
    return ok and r or nil
end

local function getRoot() local c=LP.Character return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso")) end
local function getHum() local c=LP.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function pos() local r=getRoot() return r and r.Position or Vector3.new(0,0,0) end
local function dist(a,b) return (a-b).Magnitude end
local function myLevel()
    local d = LP:FindFirstChild("Data")
    if d and d:FindFirstChild("Level") then return tonumber(d.Level.Value) or 1 end
    local ls = LP:FindFirstChild("leaderstats")
    if ls and ls:FindFirstChild("Level") then return tonumber(ls.Level.Value) or 1 end
    return 1
end
local SEA
do
    local id = game.PlaceId
    if id == 2753915549 or id == 9792993051 then SEA = 1
    elseif id == 4442272183 or id == 79091703265657 then SEA = 2
    elseif id == 7449423635 or id == 100117331123089 then SEA = 3 end
end

--====================================================================================
-- MOVEMENT — CFrame trực tiếp
--====================================================================================
local MOVE = { Active=false, Target=nil, Speed=300 }
local function stopMoving()
    MOVE.Active = false MOVE.Target = nil
    local c = LP.Character
    if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
end
local function moveTo(targetPos, sp)
    if typeof(targetPos) == "CFrame" then targetPos = targetPos.Position end
    MOVE.Target = targetPos MOVE.Speed = sp or MOVE.Speed MOVE.Active = true
end
local function teleportTo(targetPos)
    if typeof(targetPos) == "CFrame" then targetPos = targetPos.Position end
    local hrp = getRoot() if not hrp then return end
    MOVE.Active = false
    hrp.CFrame = CFrame.new(targetPos)
end
conn(S.Run.Heartbeat, function()
    if not MOVE.Active or not MOVE.Target then return end
    local hrp = getRoot() if not hrp then return end
    local cur = hrp.Position
    local dir = MOVE.Target - cur
    local d = dir.Magnitude
    if d < 4 then MOVE.Active = false MOVE.Target = nil return end
    local c = LP.Character
    if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    local step = math.min(MOVE.Speed * (1/60), d)
    local np = cur + dir.Unit * step
    hrp.CFrame = CFrame.new(np, np + dir.Unit)
    hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
end)

--====================================================================================
-- DATA
--====================================================================================
local D = {}
D.CHEAP = {"Rocket-Rocket","Spin-Spin","Blade-Blade","Chop-Chop","Spring-Spring","Bomb-Bomb","Smoke-Smoke","Spike-Spike","Flame-Flame","Ice-Ice","Sand-Sand","Dark-Dark","Diamond-Diamond","Light-Light","Rubber-Rubber","Ghost-Ghost","Revive-Revive","Magma-Magma"}
D.BOSSES = {
    [1]={"The Gorilla King","Bobby","Yeti","Mob Leader","Vice Admiral","Saber Expert"},
    [2]={"Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Ice Admiral","Ghost Captain","Don Swan","Smoke Admiral","Cursed Captain","Darkbeard","Order","Diamond","Jeremy","Fajita","Kilo Admiral","Captain Elephant","Beautiful Pirate","Longma","Hydra Leader","Trial of God"},
    [3]={"Stone","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate","Longma","Trial of God","Cake Queen","Cursed Captain","Soul Reaper","Dough King","Rip_indra","Ope","Cursed Skeleton"},
}
D.MOBS = {
    [1]={"Bandit","Monkey","Gorilla","Pirate","Brute","Desert Bandit","Desert Officer","Snow Bandit","Snowman","Chief Petty Officer","Sky Bandit","Dark Master","Prisoner","Dangerous Prisoner","Toga Warrior","Gladiator","Military Soldier","Military Spy","Fishman Warrior","Fishman Commando","God's Guard","Shanda","Royal Squad","Royal Soldier","Galley Pirate","Galley Captain"},
    [2]={"Raider","Mercenary","Swan Pirate","Factory Staff","Marine Lieutenant","Marine Captain","Zombie","Vampire","Snow Trooper","Winter Warrior","Lab Subordinate","Horned Warrior","Magma Ninja","Lava Pirate","Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter"},
    [3]={"Pirate Millionaire","Pistol Billionaire","Dragon Crew Warrior","Dragon Crew Archer","Hydra Enforcer","Venomous Assailant","Marine Commodore","Marine Rear Admiral","Fishman Raider","Fishman Captain","Forest Pirate","Jungle Pirate","Musketeer Pirate","Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy","Peanut Scout","Peanut President","Ice Cream Chef","Ice Cream Commander","Cookie Crafter","Cake Guard","Baking Staff","Head Baker","Cocoa Warrior","Chocolate Bar Battler","Sweet Thief","Candy Rebel","Candy Pirate","Snow Demon","Isle Outlaw","Island Boy","Isle Champion","Skull Slayer","Reef Bandit","Coral Pirate","Sea Chanter","Ocean Prophet","High Disciple","Grand Devotee"},
}
D.MOB_DISPLAY = { ["God's Guard"] = "Sky Guards" }
local function dn(n) return D.MOB_DISPLAY[n] or n end

do
    local FR = {
        {"Rocket-Rocket",0,5000},{"Spin-Spin",0,7500},{"Blade-Blade",0,30000},{"Spring-Spring",0,60000},
        {"Bomb-Bomb",0,80000},{"Smoke-Smoke",0,100000},{"Spike-Spike",0,180000},{"Flame-Flame",1,250000},
        {"Ice-Ice",1,350000},{"Sand-Sand",1,420000},{"Dark-Dark",1,500000},{"Eagle-Eagle",1,550000},
        {"Diamond-Diamond",1,600000},{"Falcon-Falcon",1,650000},{"Light-Light",2,650000},{"Rubber-Rubber",2,750000},
        {"Ghost-Ghost",2,940000},{"Magma-Magma",2,960000},{"Door-Door",2,950000},{"Chop-Chop",2,1000000},
        {"Quake-Quake",3,1000000},{"Buddha-Buddha",3,1200000},{"Love-Love",3,1300000},{"Creation-Creation",3,1400000},
        {"Spider-Spider",3,1500000},{"Sound-Sound",3,1700000},{"Phoenix-Phoenix",3,1800000},{"Portal-Portal",3,1900000},
        {"Rumble-Rumble",3,2100000},{"Pain-Pain",3,2300000},{"Blizzard-Blizzard",3,2400000},{"Gravity-Gravity",4,2500000},
        {"Mammoth-Mammoth",4,2700000},{"T-Rex-T-Rex",4,2700000},{"Dough-Dough",4,2800000},{"Shadow-Shadow",4,2900000},
        {"Venom-Venom",4,3000000},{"Gas-Gas",4,3200000},{"Spirit-Spirit",4,3400000},{"Control-Control",4,9000000},
        {"Yeti-Yeti",4,5000000},{"Leopard-Leopard",4,5000000},{"Kitsune-Kitsune",4,8000000},{"Dragon-Dragon",4,15000000},
        {"Dragon-West",4,15000000},{"Dragon-East",4,15000000},{"Magnet-Magnet",4,0},
    }
    D.FRUITS = {} D.FRUIT_BY_KEY = {}
    for _, f in ipairs(FR) do
        local e = { name=f[1], rarity=f[2], price=f[3] }
        D.FRUITS[#D.FRUITS+1] = e
        D.FRUIT_BY_KEY[f[1]] = e
        D.FRUIT_BY_KEY[f[1]:match("^([^%-]+)") or f[1]] = e
    end
end
local function fruitInfo(n) if not n then return nil end return D.FRUIT_BY_KEY[n] or D.FRUIT_BY_KEY[tostring(n):match("^([^%-]+)") or ""] end
local function fruitRarity(n) local e = fruitInfo(n) return e and e.rarity or 0 end
local function fruitPrice(n) local e = fruitInfo(n) return e and e.price or 0 end

local Q = {
    {9,"Bandit",1059,15,1550,"BanditQuest1",1},{14,"Monkey",-1598,36,153,"JungleQuest",1},
    {29,"Gorilla",-1598,36,153,"JungleQuest",2},{44,"Pirate",-1141,4,3831,"BuggyQuest1",1},
    {59,"Brute",-1141,4,3831,"BuggyQuest1",2},{74,"Desert Bandit",894,5,4392,"DesertQuest",1},
    {89,"Desert Officer",894,5,4392,"DesertQuest",2},{99,"Snow Bandit",1389,88,-1298,"SnowQuest",1},
    {119,"Snowman",1389,88,-1298,"SnowQuest",2},{149,"Chief Petty Officer",-5039,27,4324,"MarineQuest2",1},
    {174,"Sky Bandit",-4839,716,-2619,"SkyQuest",1},{189,"Dark Master",-4839,716,-2619,"SkyQuest",2},
    {209,"Prisoner",5308,1,475,"PrisonerQuest",1},{249,"Dangerous Prisoner",5308,1,475,"PrisonerQuest",2},
    {274,"Toga Warrior",-1580,6,-2986,"ColosseumQuest",1},{299,"Gladiator",-1580,6,-2986,"ColosseumQuest",2},
    {324,"Military Soldier",-5313,10,8515,"MagmaQuest",1},{374,"Military Spy",-5313,10,8515,"MagmaQuest",2},
    {399,"Fishman Warrior",61122,18,1569,"FishmanQuest",1},{449,"Fishman Commando",61122,18,1569,"FishmanQuest",2},
    {474,"God's Guard",-4721,843,-1949,"SkyExp1Quest",1},{524,"Shanda",-7859,5544,-381,"SkyExp1Quest",2},
    {549,"Royal Squad",-7906,5634,-1411,"SkyExp2Quest",1},{624,"Royal Soldier",-7906,5634,-1411,"SkyExp2Quest",2},
    {649,"Galley Pirate",5259,37,4050,"FountainQuest",1},{699,"Galley Captain",5259,37,4050,"FountainQuest",2},
    {724,"Raider",-429,71,1836,"Area1Quest",1},{774,"Mercenary",-429,71,1836,"Area1Quest",2},
    {799,"Swan Pirate",638,71,918,"Area2Quest",1},{874,"Factory Staff",632,73,918,"Area2Quest",2},
    {899,"Marine Lieutenant",-2440,71,-3216,"MarineQuest3",1},{949,"Marine Captain",-2440,71,-3216,"MarineQuest3",2},
    {974,"Zombie",-5497,47,-795,"ZombieQuest",1},{999,"Vampire",-5497,47,-795,"ZombieQuest",2},
    {1049,"Snow Trooper",609,400,-5372,"SnowMountainQuest",1},{1099,"Winter Warrior",609,400,-5372,"SnowMountainQuest",2},
    {1124,"Lab Subordinate",-6064,15,-4902,"IceSideQuest",1},{1174,"Horned Warrior",-6064,15,-4902,"IceSideQuest",2},
    {1199,"Magma Ninja",-5428,15,-5299,"FireSideQuest",1},{1249,"Lava Pirate",-5428,15,-5299,"FireSideQuest",2},
    {1274,"Ship Deckhand",1037,125,32911,"ShipQuest1",1},{1299,"Ship Engineer",1037,125,32911,"ShipQuest1",2},
    {1324,"Ship Steward",968,125,33244,"ShipQuest2",1},{1349,"Ship Officer",968,125,33244,"ShipQuest2",2},
    {1374,"Arctic Warrior",5667,26,-6486,"FrostQuest",1},{1424,"Snow Lurker",5667,26,-6486,"FrostQuest",2},
    {1449,"Sea Soldier",-3054,235,-10142,"ForgottenQuest",1},{1499,"Water Fighter",-3054,240,-10146,"ForgottenQuest",2},
    {1524,"Pirate Millionaire",-290,42,5581,"PiratePortQuest",1},{1574,"Pistol Billionaire",-290,42,5581,"PiratePortQuest",2},
    {1599,"Dragon Crew Warrior",6738,127,-713,"DragonCrewQuest",1},{1624,"Dragon Crew Archer",6738,127,-713,"DragonCrewQuest",2},
    {1649,"Hydra Enforcer",5213,1004,758,"VenomCrewQuest",1},{1699,"Venomous Assailant",5213,1004,758,"VenomCrewQuest",2},
    {1724,"Marine Commodore",2180,27,-6741,"MarineTreeIsland",1},{1774,"Marine Rear Admiral",2179,28,-6740,"MarineTreeIsland",2},
    {1799,"Fishman Raider",3142,108,7482,"DeepForestIsland3",1},{1824,"Fishman Captain",-10581,330,-8761,"DeepForestIsland3",2},
    {1849,"Forest Pirate",-13234,331,-7625,"DeepForestIsland",1},{1899,"Forest Pirate",-13234,331,-7625,"DeepForestIsland",2},
    {1924,"Jungle Pirate",-12680,389,-9902,"DeepForestIsland2",1},{1974,"Musketeer Pirate",-12680,389,-9902,"DeepForestIsland2",2},
    {1999,"Reborn Skeleton",-9479,141,5566,"HauntedQuest1",1},{2024,"Living Zombie",-9479,141,5566,"HauntedQuest1",2},
    {2049,"Demonic Soul",-9516,172,6078,"HauntedQuest2",1},{2074,"Posessed Mummy",-9516,172,6078,"HauntedQuest2",2},
    {2099,"Peanut Scout",-2104,38,-10194,"NutsIslandQuest",1},{2124,"Peanut President",-2104,38,-10194,"NutsIslandQuest",2},
    {2149,"Ice Cream Chef",-820,65,-10965,"IceCreamIslandQuest",1},{2199,"Ice Cream Commander",-820,65,-10965,"IceCreamIslandQuest",2},
    {2224,"Cookie Crafter",-2021,37,-12028,"CakeQuest1",1},{2249,"Cake Guard",-2021,37,-12028,"CakeQuest1",2},
    {2274,"Baking Staff",-1927,37,-12842,"CakeQuest2",1},{2299,"Head Baker",-1927,37,-12842,"CakeQuest2",2},
    {2324,"Cocoa Warrior",233,29,-12201,"ChocQuest1",1},{2349,"Chocolate Bar Battler",233,29,-12201,"ChocQuest1",2},
    {2374,"Sweet Thief",150,30,-12774,"ChocQuest2",1},{2399,"Candy Rebel",150,30,-12774,"ChocQuest2",2},
    {2424,"Candy Pirate",-1150,20,-14446,"CandyQuest1",1},{2449,"Snow Demon",-1150,20,-14446,"CandyQuest1",2},
    {2474,"Isle Outlaw",-16547,61,-173,"TikiQuest1",1},{2524,"Island Boy",-16547,61,-173,"TikiQuest1",2},
    {2574,"Isle Champion",-16539,55,1051,"TikiQuest2",1},{2599,"Skull Slayer",-16665,104,1579,"TikiQuest3",2},
    {2624,"Reef Bandit",10778,-2087,9265,"SubmergedQuest1",1},{2649,"Coral Pirate",10778,-2087,9265,"SubmergedQuest1",2},
    {2674,"Sea Chanter",10880,-2086,10032,"SubmergedQuest2",1},{2699,"Ocean Prophet",10880,-2086,10032,"SubmergedQuest2",2},
    {2719,"High Disciple",9640,-1992,9613,"SubmergedQuest3",1},{99999,"Grand Devotee",9640,-1992,9613,"SubmergedQuest3",2},
}
local function pickTarget(lv)
    for _, r in ipairs(Q) do if lv <= r[1] then return r end end
    return Q[#Q]
end

--====================================================================================
-- STATE
--====================================================================================
local St = {
    AutoFarm=false, AutoRaid=false, AutoBoss=false, AutoChest=false,
    AutoNearest=false, AutoSpecific=false, AutoDungeon=false, AutoMagnet=false,
    AutoQuest=true, AutoHaki=true, BringMobs=true, BringRange=350, BringRate=0.12,
    AutoEquip=true, EquipType="Melee", AttackRange=70, Hover=22,
    Speed=300, FarTP=false, AtkDelay=0.05, AtkBurst=1, LoopDelay=0.05,
    SafeMode=false, SafeHP=30,
    AutoSkill=true, SkillTime={Z=0,X=0,C=0}, SkillCD={Z=0.7,X=1.2,C=3},
    AutoStats=false, StatType="Melee",
    AntiStuck=true, StuckTime=0, LastPos=Vector3.new(0,0,0), MobTimeout=5,
    AutoBuyHaki=false, AutoBuyChip=false, AutoClearRaid=false, RaidChip="Flame",
    NoClip=false, InfJump=false, Fly=false, FlySpeed=120, LockSpeed=false, WalkSpeed=50,
    FruitSniper=false, FruitMinRarity=2, FruitBring=false, FruitNotify=false,
    AutoStoreFruit=false, StoreMinRarity=2, LastStoreFruit=0,
    LastFruitScan=0, FruitCache={}, NotifiedFruits={}, LastFruit=0, LastChest=0,
    ESPPlayers=false, ESPMobs=false, ESPBoss=false, ESPChests=false, ESPFruits=false, ESPRange=1500,
    HopPingMax=200, HopVisited={},
    Sub="Idle", MyLevel=1, QuestLv=-1,
    CurrentMobName=nil, LastQuestTry=0, QuestCompletedAt=0,
    Attacking=false, LastAttack=0, TargetName=nil, StuckCheck=0,
    HakiTry=0, HakiBuyTry=0, EquipTry=0, BossSeen=nil, BossKillLog={},
    LastChipBuy=0, LastSummonTry=0, RaidAttempts=0,
    Panic=false, Running=false, Orig={}, Destroyed=false,
    Lang="VN", Theme="Gold", Profile="Default",
    AutoBones=false, AutoDough=false, AutoElite=false, AutoEcto=false,
    AutoMastery=false, AutoMaterials=false, RegionFarm=false, RegionName="Sea 1 - Bandit",
    Aimbot=false, AimbotFOV=250, AimbotSmooth=0.25, FastMode="Normal",
    KillAura=false, AuraRange=60,
    AutoBuyGeppo=false, AutoBuySoru=false, AutoBuyKen=false, AutoRedeem=false, Redeemed=false,
    PlayerAlert=false, AlertRange=300, AutoRejoin=false,
    TimerMin=0, TimerStart=0, DiscordURL="",
    FruitSniperName="", AwakenFruit="", AutoAwaken=false, RaceV4=false,
    AutoDarkbeard=false, AutoOrder=false, AutoRipIndra=false,
    AutoSeaBeast=false, AutoSeaEvent=false,
    BossTimers={}, StatKills=0, StatChests=0, StatFruits=0, StatStart=tick(),
    RollMin=2, RollAuto=false, StoreNames={}, AlertedPlayers={},
    LastAura=0, LastRoll=0, LastStoreName=0, LastSniper=0, LastAwake=0,
    _lastEnemyCount=0, _lastBossSeen={},
    AutoFish=false, AutoBuyBait=false, AutoSellFish=false, AutoFishQuest=false, HasBait=false,
    MasteryTarget="Melee",
    AutoSpecialQuest=false, SpecialQuest="Saber", AutoCompleteQuest=false,
    AutoFactoryRaid=false, AutoPirateRaid=false, AutoHakiPad=false,
    AutoRipIndraAttack=false, AutoSoulReaper=false, AutoDoughKing=false,
    AutoGachaMagnet=false, AutoMagnetEvent=false, TryLuckyGrave=false,
    SilentAim=false, SilentAimPlayer=false, Tracer=false, TargetLowestHP=false, FovCircle=false,
    WaterWalk=false, BypassSpeed=false, BypassSpeedMul=1.5,
    AutoBerry=false, AutoCollectHop=false,
    IslandTP=false, IslandName="Starter Island",
    AntiAFK=true,
    _fovCircle=nil, _hlPvP=nil,
    LastGrave=0, LastGacha=0,
}
local GUI_State = { SelectedBoss="The Gorilla King", SelectedMob="Bandit" }

local function anyMode()
    return St.AutoFarm or St.AutoRaid or St.AutoBoss or St.AutoChest or St.AutoNearest
        or St.AutoSpecific or St.AutoDungeon or St.AutoMagnet
        or St.AutoBones or St.AutoDough or St.AutoElite or St.AutoEcto
        or St.AutoMastery or St.AutoMaterials or St.RegionFarm
        or St.AutoDarkbeard or St.AutoOrder or St.AutoRipIndra
        or St.AutoSeaBeast or St.AutoSeaEvent or St.RaceV4
        or St.AutoFish or St.AutoSpecialQuest
        or St.AutoFactoryRaid or St.AutoPirateRaid or St.AutoHakiPad
        or St.AutoRipIndraAttack or St.AutoSoulReaper or St.AutoDoughKing
        or St.AutoGachaMagnet or St.AutoMagnetEvent or St.TryLuckyGrave
        or St.AutoCompleteQuest or St.AutoBerry or St.AutoCollectHop
end

--====================================================================================
-- ENEMIES
--====================================================================================
local EN = { list={}, t=0 }
local function enemies()
    local now = tick()
    if now - EN.t > 0.08 then
        EN.t = now
        local out = {}
        local f = S.WS:FindFirstChild("Enemies")
        if f then
            for _, e in ipairs(f:GetChildren()) do
                local h = e:FindFirstChildOfClass("Humanoid")
                local r = e:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then out[#out+1] = { m=e, h=h, r=r } end
            end
        end
        EN.list = out
    end
    return EN.list
end

--====================================================================================
-- QUEST DETECTION
--====================================================================================
local function getQuestInfo()
    local pg = LP:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local main = pg:FindFirstChild("Main")
    if not main then return nil end
    local quest = main:FindFirstChild("Quest")
    if not quest or not quest.Visible then return nil end
    local container = quest:FindFirstChild("Container")
    if container then
        local qt = container:FindFirstChild("QuestTitle")
        if qt then
            local lbl = qt:FindFirstChild("Title")
            if lbl then
                local text = lbl.Text or ""
                local cur, max = text:match("%((%d+)%s*/%s*(%d+)%)")
                if cur and max then return { cur=tonumber(cur), max=tonumber(max), title=text } end
                local c2, m2 = text:match("(%d+)%s*/%s*(%d+)")
                if c2 and m2 then return { cur=tonumber(c2), max=tonumber(m2), title=text } end
                return { cur=0, max=1, title=text }
            end
        end
    end
    for _, d in ipairs(quest:GetDescendants()) do
        if d:IsA("TextLabel") and d.Text:find("/") then
            local c, m = d.Text:match("(%d+)%s*/%s*(%d+)")
            if c and m then return { cur=tonumber(c), max=tonumber(m), title=d.Text } end
        end
    end
    return nil
end
local function questMatchesMob(qt, mn)
    if not qt or not mn then return false end
    local function norm(s) s=s:lower() s=s:gsub("'",""):gsub("’","") return s end
    local q=norm(qt) local m=norm(mn)
    if q:find(m,1,true) then return true end
    for w in m:gmatch("%S+") do if #w>3 and q:find(w,1,true) then return true end end
    return false
end
local function getQuestRowFromTitle(title)
    if not title then return nil end
    for _, r in ipairs(Q) do if questMatchesMob(title, r[2]) then return r end end
    return nil
end
local function tryAcceptQuest(row)
    local hrp = getRoot() if not hrp then return false end
    local gp = Vector3.new(row[3], row[4], row[5])
    local d = dist(hrp.Position, gp)
    if d > 35 then
        St.Sub = "→ NPC "..row[6]
        if d > 400 then teleportTo(gp + Vector3.new(0,5,3)) task.wait(0.2)
        else moveTo(gp + Vector3.new(0,5,3), 400) end
        return false
    end
    stopMoving()
    St.Sub = "Nhận quest: "..row[6]
    pcall(function() R.CommF:InvokeServer("StartQuest", row[6], row[7]) end)
    St.LastQuestTry = tick()
    task.wait(0.5)
    return true
end

--====================================================================================
-- COMBAT — FIXED FORMAT
--====================================================================================
local function doAttack()
    if not R.Attack or not R.Hit then return end
    local hrp = getRoot() if not hrp then return end
    local range = St.AttackRange + (MOBILE and 15 or 0)
    -- FIX: gửi danh sách các HumanoidRootPart
    local targets_hrp = {}
    local first_head
    for _, e in ipairs(enemies()) do
        if e.r.Parent and e.h.Health > 0 then
            local head = e.m:FindFirstChild("Head")
            local d1 = dist(e.r.Position, hrp.Position)
            local d2 = head and dist(head.Position, hrp.Position) or math.huge
            if d1 <= range or d2 <= range then
                if head and not first_head then first_head = head end
                targets_hrp[#targets_hrp+1] = e.r
            end
        end
    end
    if #targets_hrp == 0 then return end
    St.LastAttack = tick()
    pcall(function()
        R.Attack:FireServer(0)
        -- Format đúng: (targetHead, listOfHRPs, nil, attackId)
        R.Hit:FireServer(first_head or targets_hrp[1], targets_hrp, nil, "")
    end)
end
local function autoSkillTick()
    if not St.AutoSkill then return end
    if tick() - St.LastAttack > 1.5 then return end
    local c = LP.Character if not c then return end
    local tool
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") and t:FindFirstChild("RemoteFunction") then tool = t break end
    end
    if not tool then return end
    local rf = tool.RemoteFunction
    local now = tick()
    for _, k in ipairs({"Z","X","C"}) do
        if now - (St.SkillTime[k] or 0) >= (St.SkillCD[k] or 1) then
            St.SkillTime[k] = now
            task.spawn(function() pcall(function() rf:InvokeServer(k) end) end)
        end
    end
end
local function bringMobs(rangeOverride)
    local hrp = getRoot() if not hrp then return end
    local range = rangeOverride or St.BringRange
    local tgt = Vector3.new(hrp.Position.X, hrp.Position.Y - St.Hover, hrp.Position.Z)
    local mobName = St.CurrentMobName
    for _, e in ipairs(enemies()) do
        if e.h.Health > 0 and e.r.Parent and dist(e.r.Position, hrp.Position) <= range
            and (not mobName or e.m.Name == mobName) then
            local bp = e.r:FindFirstChild("HL_Bring")
            if not bp then
                bp = Instance.new("BodyPosition")
                bp.Name = "HL_Bring"
                bp.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                bp.P = 30000
                bp.D = 800
                bp.Parent = e.r
            end
            bp.Position = tgt
        end
    end
end
local function cleanBring()
    local f = S.WS:FindFirstChild("Enemies")
    if not f then return end
    for _, m in ipairs(f:GetChildren()) do
        local r = m:FindFirstChild("HumanoidRootPart")
        local bp = r and r:FindFirstChild("HL_Bring")
        if bp then bp:Destroy() end
    end
end

--====================================================================================
-- WEAPON
--====================================================================================
local WPN = { Sword={}, Melee={}, Gun={} }
for n in ("cutlass,katana,iron mace,dual katana,triple katana,dark blade,yoru,wando,shisui,saddi,koko,tushita,bisento,pole,trident,true triple katana,cursed dual katana,dark dagger,buddy sword,dragon heart,canvander,rengoku,spikey trident,midnight blade,hallow scythe,yama,fox lamp,longsword,gravity cane"):gmatch("[^,]+") do WPN.Sword[n]=true end
for n in ("combat,black leg,electro,fishman karate,dragon talon,superhuman,death step,sharkman karate,electric claw,godhuman,sanguine art"):gmatch("[^,]+") do WPN.Melee[n]=true end
for n in ("flintlock,musket,slingshot,dual flintlock,refined slingshot,bizarre rifle,kabucha,acidum rifle,serpent bow,soul guitar"):gmatch("[^,]+") do WPN.Gun[n]=true end

local function classify(t)
    if not t or not t:IsA("Tool") then return nil end
    local n = t.Name:lower()
    if WPN.Gun[n] then return "Gun" end
    if WPN.Sword[n] then return "Sword" end
    if WPN.Melee[n] then return "Melee" end
    local it = t:GetAttribute("ItemType")
    if it then
        local x = tostring(it):lower()
        if x == "sword" then return "Sword" end
        if x == "gun" then return "Gun" end
        if x == "melee" or x == "fightingstyle" or x == "fighting_style" then return "Melee" end
        if x == "fruit" or x == "bloxfruit" then return "Fruit" end
    end
    if t:FindFirstChild("GunClient") or t:FindFirstChild("GunType") then return "Gun" end
    if t:FindFirstChild("SwordClient") or t:FindFirstChild("Blade") then return "Sword" end
    if t:FindFirstChild("FruitClient") then return "Fruit" end
    if n:find("sword") or n:find("blade") or n:find("katana") then return "Sword" end
    if n:find("gun") or n:find("pistol") or n:find("rifle") or n:find("bow") then return "Gun" end
    if t:FindFirstChild("Handle") then return "Melee" end
end
local function equipWeapon()
    if not St.AutoEquip then return end
    if tick() - St.EquipTry < 1 then return end
    local c, bp = LP.Character, LP:FindFirstChild("Backpack")
    if not c or not bp then return end
    local want = St.EquipType
    for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") and classify(t) == want then return end end
    for _, t in ipairs(bp:GetChildren()) do
        if t:IsA("Tool") and classify(t) == want then
            St.EquipTry = tick()
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then pcall(function() h:EquipTool(t) end) end
            return
        end
    end
end

--====================================================================================
-- FPS BOOST
--====================================================================================
local FPS = {}
do
    local function sp(i,p) St.Orig[i]=St.Orig[i] or {} if St.Orig[i][p]==nil then pcall(function() St.Orig[i][p]=i[p] end) end end
    local function rp(i,p) if St.Orig[i] and St.Orig[i][p]~=nil then pcall(function() i[p]=St.Orig[i][p] end) end end
    local function isFx(i) return i:IsA("ParticleEmitter") or i:IsA("Fire") or i:IsA("Smoke") or i:IsA("Sparkles") end
    FPS.shadows = function(on) if on then sp(S.Light,"GlobalShadows") pcall(function() S.Light.GlobalShadows=false end) else rp(S.Light,"GlobalShadows") end end
    FPS.postfx = function(on)
        for _, fx in ipairs(S.Light:GetChildren()) do
            if fx:IsA("BloomEffect") or fx:IsA("BlurEffect") or fx:IsA("DepthOfFieldEffect") or fx:IsA("SunRaysEffect") or fx:IsA("ColorCorrectionEffect") then
                if on then sp(fx,"Enabled") pcall(function() fx.Enabled=false end) else rp(fx,"Enabled") end
            end
        end
    end
    FPS.atmosphere = function(on)
        if on then
            sp(S.Light,"FogEnd") sp(S.Light,"FogStart")
            pcall(function() S.Light.FogEnd=0 S.Light.FogStart=0 end)
            for _, at in ipairs(S.Light:GetChildren()) do
                if at:IsA("Atmosphere") then sp(at,"Density") sp(at,"Haze") pcall(function() at.Density=0 at.Haze=0 end) end
            end
        else rp(S.Light,"FogEnd") rp(S.Light,"FogStart")
            for _, at in ipairs(S.Light:GetChildren()) do if at:IsA("Atmosphere") then rp(at,"Density") rp(at,"Haze") end end
        end
    end
    FPS.terrain = function(on)
        local t = S.WS:FindFirstChildOfClass("Terrain") if not t then return end
        if on then
            sp(t,"WaterWaveSize") sp(t,"WaterReflectance") sp(t,"WaterTransparency")
            pcall(function() t.WaterWaveSize=0 t.WaterReflectance=0 t.WaterTransparency=1 end)
        else rp(t,"WaterWaveSize") rp(t,"WaterReflectance") rp(t,"WaterTransparency") end
    end
    FPS.particles = function(on)
        if on then
            for _, d in ipairs(S.WS:GetDescendants()) do if isFx(d) and d.Enabled then sp(d,"Enabled") pcall(function() d.Enabled=false end) end end
        else for i in pairs(St.Orig) do if typeof(i)=="Instance" and isFx(i) then rp(i,"Enabled") end end end
    end
    FPS.decals = function(on)
        if on then
            for _, d in ipairs(S.WS:GetDescendants()) do if (d:IsA("Decal") or d:IsA("Texture")) and d.Transparency<1 then sp(d,"Transparency") pcall(function() d.Transparency=1 end) end end
        else for i in pairs(St.Orig) do if typeof(i)=="Instance" and (i:IsA("Decal") or i:IsA("Texture")) then rp(i,"Transparency") end end end
    end
    FPS.beams = function(on)
        if on then
            for _, d in ipairs(S.WS:GetDescendants()) do if (d:IsA("Beam") or d:IsA("Trail") or d:IsA("SelectionBox")) and d.Enabled then sp(d,"Enabled") pcall(function() d.Enabled=false end) end end
        else for i in pairs(St.Orig) do if typeof(i)=="Instance" and (i:IsA("Beam") or i:IsA("Trail") or i:IsA("SelectionBox")) then rp(i,"Enabled") end end end
    end
    FPS.lighting = function(on)
        if on then
            sp(S.Light,"Brightness") sp(S.Light,"ClockTime") sp(S.Light,"OutdoorAmbient") sp(S.Light,"Ambient")
            pcall(function() S.Light.Brightness=0.5 S.Light.ClockTime=0 S.Light.OutdoorAmbient=Color3.new(0,0,0) S.Light.Ambient=Color3.new(0,0,0) end)
        else rp(S.Light,"Brightness") rp(S.Light,"ClockTime") rp(S.Light,"OutdoorAmbient") rp(S.Light,"Ambient") end
    end
    FPS.restore = function()
        FPS.shadows(false) FPS.postfx(false) FPS.atmosphere(false) FPS.terrain(false)
        FPS.particles(false) FPS.decals(false) FPS.beams(false) FPS.lighting(false)
        St.Orig = {}
    end
end

--====================================================================================
-- HAKI / ANTI-STUCK
--====================================================================================
local function checkHaki()
    if not St.AutoHaki or not R.CommF then return end
    if tick() - St.HakiTry < 3 then return end
    local c = LP.Character if not c or c:FindFirstChild("HasBuso") then return end
    St.HakiTry = tick()
    task.spawn(function() pcall(function() R.CommF:InvokeServer("Buso") end) end)
end
local function autoBuyHakiTick()
    if not St.AutoBuyHaki or not R.CommF then return end
    if tick() - St.HakiBuyTry < 10 then return end
    local c = LP.Character if not c or c:FindFirstChild("HasBuso") then return end
    St.HakiBuyTry = tick()
    task.spawn(function() pcall(function() R.CommF:InvokeServer("BuyHaki", "Buso") end) end)
end
local function antiStuckTick()
    if not St.AntiStuck then return end
    local hrp = getRoot() if not hrp then return end
    local now = tick()
    if now - St.StuckCheck < 0.5 then return end
    St.StuckCheck = now
    if now - St.LastAttack < 2 or MOVE.Active then St.StuckTime = 0 St.LastPos = hrp.Position return end
    if (hrp.Position - St.LastPos).Magnitude < 2 then St.StuckTime = St.StuckTime + 0.5 else St.StuckTime = 0 end
    St.LastPos = hrp.Position
    if St.StuckTime >= (St.MobTimeout or 5) then
        St.StuckTime = 0
        St.Sub = "Anti-stuck"
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 15, 0)
    end
end

--====================================================================================
-- TARGETS
--====================================================================================
local function findMob(name)
    local hrp = getRoot() if not hrp then return nil end
    local best, bd
    for _, e in ipairs(enemies()) do
        if e.m.Name == name and e.h.Health > 0 then
            local d = dist(e.r.Position, hrp.Position)
            if not bd or d < bd then best, bd = e.m, d end
        end
    end
    return best, bd
end
local function findNearest(maxd)
    maxd = maxd or 3000
    local hrp = getRoot() if not hrp then return nil end
    local best, bd
    for _, e in ipairs(enemies()) do
        if e.h.Health > 0 then
            local d = dist(e.r.Position, hrp.Position)
            if d <= maxd and (not bd or d < bd) then best, bd = e.m, d end
        end
    end
    return best, bd
end
local bossMapT = 0
local function findBoss(name)
    for _, e in ipairs(enemies()) do if e.m.Name == name then return e.m end end
    if tick() - bossMapT > 3 then
        bossMapT = tick()
        local map = S.WS:FindFirstChild("Map")
        if map then
            for _, o in ipairs(map:GetDescendants()) do
                if o.Name == name then
                    local h = o:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 then return o end
                end
            end
        end
    end
end
local function hoverAt(p)
    local hrp = getRoot() if not hrp then return end
    local a = p + Vector3.new(0, St.Hover, 0)
    local d = dist(hrp.Position, a)
    if d > 60 then
        if St.FarTP and d > 1500 then teleportTo(CFrame.new(a)) else moveTo(CFrame.new(a)) end
    else
        MOVE.Active = false
        hrp.CFrame = CFrame.new(a)
    end
end
local function targetFarm(mob, label)
    local mrp = mob and mob:FindFirstChild("HumanoidRootPart")
    if not mrp then St.Sub = label.." · không có" return false end
    St.TargetName = mob.Name
    equipWeapon()
    St.Sub = label.." · "..dn(mob.Name)
    hoverAt(mrp.Position)
    return true
end

--====================================================================================
-- CHEST
--====================================================================================
local chestCache, chestScan = {}, 0
local function getChests()
    if tick() - chestScan > 3 then
        chestScan = tick()
        local out = {}
        for _, o in ipairs(S.WS:GetDescendants()) do
            if o.Name == "Chest" or o.Name == "ChestFolderValue" then
                local p = o:IsA("BasePart") and o or o:FindFirstChildWhichIsA("BasePart")
                if p then out[#out+1] = p end
            end
        end
        chestCache = out
    end
    return chestCache
end
local function findNearestChest()
    local hrp = getRoot() if not hrp then return nil end
    local best, bd
    for _, p in ipairs(getChests()) do
        if p.Parent then
            local d = dist(p.Position, hrp.Position)
            if d <= 800 and (not bd or d < bd) then best, bd = p, d end
        end
    end
    return best
end
local function runChestFarm()
    if tick() - St.LastChest < 0.5 then return end
    local c = findNearestChest()
    if c then
        St.LastChest = tick()
        St.Sub = "Chest · tới rương"
        teleportTo(CFrame.new(c.Position + Vector3.new(0,3,0)))
        task.wait(0.12)
    else St.Sub = "Chest · không có" task.wait(0.5) end
end

--====================================================================================
-- FRUIT
--====================================================================================
local FR_EX = {"bloxfruit","meshes","/","fruitdealer","fruitshop","fruitview","fruitnotifier","fruitinventory","fruitremote"}
local function looksLikeFruit(inst)
    if not inst or not inst.Parent then return false end
    local n = inst.Name:lower()
    for _, x in ipairs(FR_EX) do if n:find(x,1,true) then return false end end
    local par = inst.Parent
    if par:IsA("Model") and S.Players:GetPlayerFromCharacter(par) then return false end
    if not (D.FRUIT_BY_KEY[inst.Name] or inst.Name:find("Fruit") or inst.Name:find("^%a+%-%a+$")) then return false end
    if inst:IsA("Tool") or inst:IsA("BasePart") then return true end
    return inst:IsA("Model") and (inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart")) ~= nil
end
local function partPos(inst)
    if not inst then return nil end
    if inst:IsA("BasePart") then return inst.Position end
    local h = inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart")
    if h then return h.Position end
    local ok, pv = pcall(function() return inst:GetPivot().Position end)
    return ok and pv or nil
end
local function scanFruits(force)
    if not force and tick() - St.LastFruitScan < 1.2 and #St.FruitCache > 0 then return St.FruitCache end
    St.LastFruitScan = tick()
    local out = {}
    local function walk(inst, depth)
        if depth > 2 or #out > 40 then return end
        if (inst:IsA("Tool") or inst:IsA("Model")) and looksLikeFruit(inst) then
            local p = partPos(inst)
            if p then out[#out+1] = { inst=inst, name=inst.Name, pos=p, rarity=fruitRarity(inst.Name), price=fruitPrice(inst.Name) } end
        end
        for _, c in ipairs(inst:GetChildren()) do walk(c, depth+1) end
    end
    for _, c in ipairs(S.WS:GetChildren()) do walk(c, 0) end
    St.FruitCache = out
    return out
end
local function tickFruit()
    if not (St.FruitSniper or St.FruitBring or St.FruitNotify or St.AutoStoreFruit) then return end
    local list = scanFruits()
    if St.FruitNotify then
        for _, f in ipairs(list) do
            if not St.NotifiedFruits[f.inst] then
                St.NotifiedFruits[f.inst] = true
                local tag = ({"Common","Uncommon","Rare","Legendary","Mythical"})[f.rarity+1] or "?"
                notify("Fruit: "..f.name, tag.." · $"..tostring(f.price), 5)
            end
        end
    end
    if St.FruitSniper then
        local hrp = getRoot()
        if hrp then
            local best, bd
            for _, f in ipairs(list) do
                if f.rarity >= St.FruitMinRarity then
                    local d = dist(f.pos, hrp.Position)
                    if d < 5000 and (not bd or d < bd) then best, bd = f, d end
                end
            end
            if best and tick() - St.LastFruit >= 1.5 then
                St.LastFruit = tick()
                St.Sub = "Fruit · "..best.name
                teleportTo(CFrame.new(best.pos))
            end
        end
    end
    if St.FruitBring then
        local hrp = getRoot()
        if hrp then
            for _, f in ipairs(list) do
                if dist(f.pos, hrp.Position) < 300 then
                    pcall(function()
                        local h = f.inst:FindFirstChild("Handle") or f.inst:FindFirstChildWhichIsA("BasePart")
                        if h then h.CFrame = CFrame.new(hrp.Position + Vector3.new(0,3,0)) end
                    end)
                end
            end
        end
    end
    if St.AutoStoreFruit and tick() - St.LastStoreFruit > 5 then
        local inv = Invoke("GetFruits")
        if type(inv) == "table" then
            for _, f in ipairs(inv) do
                local nm = type(f) == "table" and (f.Name or f.name) or nil
                local ra = type(f) == "table" and tonumber(f.Rarity or f.rarity) or fruitRarity(nm)
                if nm and (ra or 0) >= St.StoreMinRarity then
                    St.LastStoreFruit = tick()
                    Invoke("StoreFruit", nm)
                    St.Sub = "Kho · "..nm
                    break
                end
            end
        end
    end
end

--====================================================================================
-- ESP — FIXED Adornee
--====================================================================================
local espCache = {}
local function espClear()
    for _, e in pairs(espCache) do
        pcall(function() e.bb:Destroy() end)
        pcall(function() e.hl:Destroy() end)
    end
    espCache = {}
end
local function espTrack(inst, text, color)
    if not inst or not inst.Parent then return end
    local e = espCache[inst]
    if not e then
        local bb = Instance.new("BillboardGui")
        bb.Name = "HL_ESP"
        bb.Size = UDim2.new(0, 180, 0, 30)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = St.ESPRange
        bb.Adornee = inst -- FIX: đặt Adornee ngay từ đầu
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,0,1,0)
        lbl.BackgroundTransparency = 0.35
        lbl.BackgroundColor3 = Color3.fromRGB(0,0,0)
        lbl.TextColor3 = color
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextStrokeTransparency = 0.5
        lbl.Parent = bb
        local hl = Instance.new("Highlight")
        hl.FillColor = color
        hl.FillTransparency = 0.78
        hl.OutlineColor = Color3.fromRGB(255,255,255)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = inst
        hl.Parent = inst
        bb.Parent = inst
        e = { bb=bb, label=lbl, hl=hl }
        espCache[inst] = e
    end
    e.label.Text = text
    e.label.TextColor3 = color
    if e.bb.Adornee ~= inst then e.bb.Adornee = inst end
    return e
end
local function espUpdate()
    local anyOn = St.ESPPlayers or St.ESPMobs or St.ESPBoss or St.ESPChests or St.ESPFruits
    if not anyOn then if next(espCache) then espClear() end return end
    for inst, e in pairs(espCache) do
        if not inst.Parent then
            pcall(function() e.bb:Destroy() end)
            pcall(function() e.hl:Destroy() end)
            espCache[inst] = nil
        end
    end
    local me = pos()
    if St.ESPPlayers then
        for _, pl in ipairs(S.Players:GetPlayers()) do
            if pl ~= LP and pl.Character then
                local h = pl.Character:FindFirstChildOfClass("Humanoid")
                local r = pl.Character:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then
                    local lv = 0
                    local d = pl:FindFirstChild("Data")
                    if d and d:FindFirstChild("Level") then lv = d.Level.Value end
                    espTrack(r, string.format("%s [Lv.%d] %dm", pl.Name, lv, dist(r.Position, me)), Color3.fromRGB(90,255,130))
                end
            end
        end
    end
    if St.ESPMobs or St.ESPBoss then
        for _, e in ipairs(enemies()) do
            local d = dist(e.r.Position, me)
            if d < St.ESPRange then
                local isBoss = e.h.MaxHealth >= 5000
                if (isBoss and St.ESPBoss) or (not isBoss and St.ESPMobs) then
                    espTrack(e.r, string.format("%s%s · %dm", e.m.Name, isBoss and " [BOSS]" or "", math.floor(d)),
                        isBoss and Color3.fromRGB(255,80,80) or Color3.fromRGB(255,175,70))
                end
            end
        end
    end
    if St.ESPFruits then
        for _, f in ipairs(scanFruits()) do
            local d = dist(f.pos, me)
            if d < St.ESPRange then espTrack(f.inst, string.format("%s (r%d) · %dm", f.name, f.rarity, math.floor(d)), Color3.fromRGB(255,110,240)) end
        end
    end
    if St.ESPChests then
        for _, p in ipairs(getChests()) do
            if p.Parent then
                local d = dist(p.Position, me)
                if d < St.ESPRange then espTrack(p, string.format("RƯƠNG · %dm", math.floor(d)), Color3.fromRGB(255,230,90)) end
            end
        end
    end
end

--====================================================================================
-- RAID
--====================================================================================
local RaidFns = {}
do
    local function hasChip()
        local c = LP.Character
        if c and c:FindFirstChild("Special Microchip") then return true end
        local bp = LP:FindFirstChild("Backpack")
        if bp and bp:FindFirstChild("Special Microchip") then return true end
        return false
    end
    local function unequipChip()
        local c = LP.Character if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then pcall(function() h:UnequipTools() end) end
        local chip = c:FindFirstChild("Special Microchip")
        if chip then
            local bp = LP:FindFirstChild("Backpack")
            if bp then pcall(function() chip.Parent = bp end) end
        end
    end
    local function fruitInBag(full)
        if not full then return false end
        local s = full:match("^([^%-]+)") or full
        local function has(c)
            if not c then return false end
            for _, t in ipairs(c:GetChildren()) do
                if t:IsA("Tool") and (t.Name == full or t.Name == s or t.Name == s.."-"..s or t.Name == s.." Fruit") then return true end
            end
            return false
        end
        return has(LP.Character) or has(LP:FindFirstChild("Backpack"))
    end
    local function inRaid()
        local pg = LP:FindFirstChild("PlayerGui") if not pg then return false end
        local m = pg:FindFirstChild("Main") if not m then return false end
        local top = m:FindFirstChild("TopHUDList")
        local t = top and top:FindFirstChild("RaidTimer")
        if t and t.Visible then return true end
        local t2 = m:FindFirstChild("Timer")
        return t2 and t2.Visible or false
    end
    local function buyChip()
        if hasChip() then return end
        if tick() - St.LastChipBuy < 5 then return end
        St.LastChipBuy = tick()
        St.Sub = "Raid · mua chip"
        Invoke("RaidsNpc", "Select", St.RaidChip)
        task.wait(1.2)
        if hasChip() then return end
        Invoke("BuyChip", St.RaidChip)
        task.wait(1)
        if hasChip() then return end
        for _, fn in ipairs(D.CHEAP) do
            local s = fn:match("^([^%-]+)") or fn
            Invoke("LoadFruit", fn)
            local ok = false
            for _ = 1, 8 do task.wait(0.2) if fruitInBag(fn) then ok = true break end end
            if not ok then
                Invoke("LoadFruit", s)
                for _ = 1, 8 do task.wait(0.2) if fruitInBag(s) then ok = true break end end
            end
            if ok then
                Invoke("RaidsNpc", "Select", St.RaidChip)
                for _ = 1, 15 do
                    task.wait(0.25)
                    if hasChip() then St.Sub = "Raid · chip sẵn sàng" St.RaidAttempts = 0 return end
                end
            end
        end
        St.Sub = "Raid · mua thất bại"
        task.wait(2)
    end
    local function startRaid()
        if inRaid() then St.RaidAttempts = 0 return end
        if not hasChip() then St.Sub = "Raid · chờ chip" return end
        if tick() - St.LastSummonTry < 3 then return end
        St.LastSummonTry = tick()
        St.RaidAttempts = St.RaidAttempts + 1
        unequipChip()
        task.wait(0.15)
        local summon
        local map = S.WS:FindFirstChild("Map")
        if map then
            local islName = SEA == 3 and "Boat Castle" or "CircleIsland"
            local isl = map:FindFirstChild(islName)
            if isl then summon = isl:FindFirstChild("RaidSummon2") or isl:FindFirstChild("RaidSummon") or isl:FindFirstChild("RaidSummon1") end
            if not summon then
                for _, d in ipairs(map:GetDescendants()) do
                    if d.Name == "RaidSummon2" or d.Name == "RaidSummon" or d.Name == "RaidSummon1" then summon = d break end
                end
            end
        end
        if summon then
            local buttonPart
            local button = summon:FindFirstChild("Button", true)
            if button then buttonPart = button:FindFirstChild("Main", true) or button:FindFirstChildWhichIsA("BasePart", true) end
            if not buttonPart then
                for _, d in ipairs(summon:GetDescendants()) do
                    if d:IsA("BasePart") and d:FindFirstChildOfClass("ClickDetector") then buttonPart = d break end
                end
            end
            if buttonPart then
                local hrp = getRoot()
                if hrp then
                    hrp.CFrame = CFrame.new(buttonPart.Position + Vector3.new(0,3,30), buttonPart.Position)
                    task.wait(0.15)
                    local click = buttonPart:FindFirstChildOfClass("ClickDetector")
                    if click then
                        pcall(function() fireclickdetector(click, 5) end) task.wait(0.12)
                        pcall(function() fireclickdetector(click, 1) end) task.wait(0.12)
                        pcall(function() fireclickdetector(click) end)
                    end
                    pcall(function() firetouchinterest(hrp, buttonPart, 0) task.wait(0.05) firetouchinterest(hrp, buttonPart, 1) end)
                end
            end
            if R.Raids then pcall(function() R.Raids:FireServer("Start", St.RaidChip) end) pcall(function() R.Raids:FireServer("Start") end) end
            if R.Btn then pcall(function() R.Btn:FireServer("Start", St.RaidChip) end) end
            if R.CommF then
                pcall(function() R.CommF:InvokeServer("Raid", St.RaidChip) end)
                pcall(function() R.CommF:InvokeServer("StartRaid", St.RaidChip) end)
            end
        else
            St.Sub = "Raid · không thấy bàn"
            if R.CommF then pcall(function() R.CommF:InvokeServer("StartRaid", St.RaidChip) end) end
        end
        for _ = 1, 15 do
            task.wait(0.4)
            if inRaid() then St.Sub = "Raid · đã vào" St.RaidAttempts = 0 return end
        end
        if St.RaidAttempts >= 4 then St.RaidAttempts = 0 St.LastChipBuy = 0 end
    end
    local function clearRaid()
        if not inRaid() then St.Sub = "Raid · chờ vào" return end
        if St.RaidChip == "Magma" or St.RaidChip == "Flame" then
            local map = S.WS:FindFirstChild("Map")
            if map then for _, d in ipairs(map:GetDescendants()) do if d.Name == "Lava" and d.Parent then pcall(function() d:Destroy() end) end end end
        end
        local names = {"Island 5","Island 4","Island 3","Island 2","Island 1"}
        local found
        local origin = S.WS:FindFirstChild("_WorldOrigin")
        local locs = origin and origin:FindFirstChild("Locations")
        local hrp = getRoot()
        if locs and hrp then
            for _, n in ipairs(names) do
                local t = locs:FindFirstChild(n)
                if t and dist(t.Position, hrp.Position) <= 3000 then found = t St.Sub = "Raid · "..n break end
            end
        end
        if not found then
            local rm = S.WS:FindFirstChild("RaidMap")
            if rm then
                for _, n in ipairs(names) do
                    local t = rm:FindFirstChild(n)
                    if t then found = t St.Sub = "Raid · "..n break end
                end
            end
        end
        if found and hrp then
            local p = found:IsA("BasePart") and found.Position or found:GetPivot().Position
            if dist(hrp.Position, p) > 100 then teleportTo(CFrame.new(p + Vector3.new(0,120,0))) task.wait(0.3) end
        elseif not found then St.Sub = "Raid · clear" end
        St.TargetName = nil
        bringMobs(5000)
    end
    RaidFns.hasChip, RaidFns.inRaid, RaidFns.buy, RaidFns.start, RaidFns.clear = hasChip, inRaid, buyChip, startRaid, clearRaid
end

--====================================================================================
-- EXTENSIONS v14
--====================================================================================
local X = St

local ISLANDS = {
    ["Sea 1"] = {
        ["Starter Island"]=Vector3.new(0,0,0),["Marine Fort"]=Vector3.new(-5039,27,4324),
        ["Jungle"]=Vector3.new(-1598,36,153),["Pirate Village"]=Vector3.new(-1141,4,3831),
        ["Desert"]=Vector3.new(894,5,4392),["Snow Island"]=Vector3.new(1389,88,-1298),
        ["Skylands"]=Vector3.new(-4839,716,-2619),["Prison"]=Vector3.new(5308,1,475),
        ["Colosseum"]=Vector3.new(-1580,6,-2986),["Magma Village"]=Vector3.new(-5313,10,8515),
        ["Underwater City"]=Vector3.new(61122,18,1569),["Fountain City"]=Vector3.new(5259,37,4050),
    },
    ["Sea 2"] = {
        ["Kingdom of Rose"]=Vector3.new(-429,71,1836),["Swan Mansion"]=Vector3.new(638,71,918),
        ["Green Zone"]=Vector3.new(-2440,71,-3216),["Graveyard"]=Vector3.new(-5497,47,-795),
        ["Snow Mountain"]=Vector3.new(609,400,-5372),["Ice Castle"]=Vector3.new(-6064,15,-4902),
        ["Fire Village"]=Vector3.new(-5428,15,-5299),["Cursed Ship"]=Vector3.new(1037,125,32911),
        ["Forgotten Island"]=Vector3.new(-3054,235,-10142),
    },
    ["Sea 3"] = {
        ["Port Town"]=Vector3.new(-290,42,5581),["Hydra Island"]=Vector3.new(5213,1004,758),
        ["Great Tree"]=Vector3.new(2180,27,-6741),["Castle on the Sea"]=Vector3.new(5259,37,4050),
        ["Haunted Castle"]=Vector3.new(-9479,141,5566),["Cake Land"]=Vector3.new(-2021,37,-12028),
        ["Chocolate Land"]=Vector3.new(233,29,-12201),["Tiki Outpost"]=Vector3.new(-16547,61,-173),
        ["Submerged Island"]=Vector3.new(10778,-2087,9265),
    },
}
local SPECIAL_QUESTS = {
    { name="Saber", npc="Saber Expert", pos=Vector3.new(-1404,30,-3068) },
    { name="Pole", npc="Pole", pos=Vector3.new(-7906,5634,-1411) },
    { name="Saw", npc="Saw", pos=Vector3.new(-9189,301,5480) },
    { name="Trident", npc="Trident", pos=Vector3.new(-1256,7,-2832) },
    { name="Dragon", npc="Dragon", pos=Vector3.new(6738,127,-713) },
    { name="Warden", npc="Warden", pos=Vector3.new(-2440,71,-3216) },
    { name="Chief Warden", npc="Chief Warden", pos=Vector3.new(-2440,71,-3216) },
    { name="Greybeard", npc="Greybeard", pos=Vector3.new(-5039,27,4324) },
    { name="Tree Destroyer", npc="Tree Destroyer", pos=Vector3.new(-2021,37,-12028) },
    { name="Elite Hunter", npc="Elite Hunter", pos=Vector3.new(5259,37,4050) },
    { name="Player Hunter", npc="Player Hunter", pos=Vector3.new(5259,37,4050) },
}
local MATERIALS = {
    [1]={"Leather","Scrap Metal","Angel Wings","Magma Ore","Fish Tail"},
    [2]={"Leather","Scrap Metal","Angel Wings","Magma Ore","Fish Tail","Radioactive Material","Mystic Droplet","Mini Tusk"},
    [3]={"Leather","Scrap Metal","Angel Wings","Magma Ore","Fish Tail","Radioactive Material","Mystic Droplet","Mini Tusk","Vampire Fang","Dragon Scale","Cursed Dual Katana Shard","Conjured Cocoa","Candy Cane","Gunpowder","Bones","Ectoplasm"},
}
local REGIONS = {
    ["Sea 1 - Bandit"]=Vector3.new(1059,15,1550),["Sea 1 - Prisoner"]=Vector3.new(5308,1,475),
    ["Sea 1 - Sky Guards"]=Vector3.new(-4721,843,-1949),["Sea 2 - Zombie"]=Vector3.new(-5497,47,-795),
    ["Sea 2 - Swan Pirate"]=Vector3.new(638,71,918),["Sea 2 - Forgotten"]=Vector3.new(-3054,235,-10142),
    ["Sea 2 - Cursed Ship"]=Vector3.new(1037,125,32911),["Sea 3 - Haunted"]=Vector3.new(-9479,141,5566),
    ["Sea 3 - Tiki"]=Vector3.new(-16547,61,-173),["Sea 3 - Cake Land"]=Vector3.new(-2021,37,-12028),
    ["Sea 3 - Choc"]=Vector3.new(233,29,-12201),["Sea 3 - Submerged"]=Vector3.new(10778,-2087,9265),
    ["Sea 3 - Hydra"]=Vector3.new(5213,1004,758),["Sea 3 - Castle"]=Vector3.new(5259,37,4050),
}
local function findGroundDrop(name)
    local hrp = getRoot() if not hrp then return nil end
    local best, bd
    for _, o in ipairs(S.WS:GetChildren()) do
        if o.Name == name or o:FindFirstChild(name) then
            local p = o:IsA("BasePart") and o or o:FindFirstChildWhichIsA("BasePart", true)
            if p then
                local d = dist(p.Position, hrp.Position)
                if d < 800 and (not bd or d < bd) then best, bd = p, d end
            end
        end
    end
    return best
end
local function autoFishTick()
    if not X.AutoFish then return end
    if SEA == 1 then X.Sub = "Fish · cần Sea 2+" return end
    if X.AutoBuyBait and not X.HasBait then
        pcall(function() Invoke("BuyBait") end)
        task.wait(1)
        X.HasBait = true
        return
    end
    local bp = LP:FindFirstChild("Backpack")
    local rod
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("rod") then rod = t break end
        end
    end
    local c = LP.Character
    if c then
        local eq = c:FindFirstChildWhichIsA("Tool")
        if eq and eq.Name:lower():find("rod") then rod = eq end
    end
    if not rod then X.Sub = "Fish · không có cần" task.wait(1) return end
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if h and rod.Parent ~= c then pcall(function() h:EquipTool(rod) end) end
    if rod:FindFirstChild("RemoteFunction") then
        pcall(function() rod.RemoteFunction:InvokeServer("Cast") end)
    end
    X.Sub = "Fish · đang câu..."
    task.wait(3)
end
local function masteryFarmTick()
    if not X.AutoMastery then return end
    local m = findNearest(2000)
    if m then
        X.TargetName = nil
        X.CurrentMobName = m.Name
        if X.MasteryTarget == "Fruit" then X.EquipType = "Fruit"
        elseif X.MasteryTarget == "Gun" then X.EquipType = "Gun"
        elseif X.MasteryTarget == "Sword" then X.EquipType = "Sword"
        else X.EquipType = "Melee" end
        targetFarm(m, "Mastery")
    else X.Sub = "Mastery · không có mob" end
end
local function specialQuestTick()
    if not X.AutoSpecialQuest then return end
    for _, q in ipairs(SPECIAL_QUESTS) do
        if q.name == X.SpecialQuest then
            local hrp = getRoot() if not hrp then return end
            local d = dist(hrp.Position, q.pos)
            if d > 35 then
                X.Sub = "Quest · tới "..q.npc
                if d > 400 then teleportTo(q.pos + Vector3.new(0,5,3))
                else moveTo(q.pos + Vector3.new(0,5,3), 400) end
                return
            end
            stopMoving()
            X.Sub = "Quest · "..q.name
            pcall(function() Invoke("StartQuest", q.name) end)
            task.wait(1)
            return
        end
    end
end
local function completeQuestTick()
    if not X.AutoCompleteQuest then return end
    if not R.CommF then return end
    pcall(function() R.CommF:InvokeServer("CompleteQuest") end)
    task.wait(2)
end
local function hakiPadTick()
    if not X.AutoHakiPad then return end
    if not R.CommF then return end
    local c = LP.Character
    if c and c:FindFirstChild("HasBuso") then return end
    pcall(function() R.CommF:InvokeServer("BuyHaki", "Buso") end)
    task.wait(3)
end
local function ripIndraAttackTick()
    if not X.AutoRipIndraAttack then return end
    local b = findBoss("Rip_indra") or findBoss("rip_indra")
    if b then targetFarm(b, "Rip Indra")
    else X.Sub = "Rip Indra · chờ" hoverAt(CFrame.new(-16565,104,1579).Position) end
end
local function soulReaperTick()
    if not X.AutoSoulReaper then return end
    local b = findBoss("Soul Reaper")
    if b then targetFarm(b, "Soul Reaper")
    else X.Sub = "Soul Reaper · chờ" hoverAt(CFrame.new(-9479,141,5566).Position) end
end
local function doughKingTick()
    if not X.AutoDoughKing then return end
    local b = findBoss("Dough King")
    if b then targetFarm(b, "Dough King")
    else X.Sub = "Dough King · chờ" hoverAt(CFrame.new(-2021,37,-12028).Position) end
end
local function tryLuckyGraveTick()
    if not X.TryLuckyGrave then return end
    if tick() - X.LastGrave < 5 then return end
    X.LastGrave = tick()
    pcall(function() Invoke("LuckyGrave") end)
    X.Sub = "Lucky Grave · thử"
    task.wait(2)
end
local function factoryRaidTick()
    if not X.AutoFactoryRaid then return end
    if SEA ~= 2 then X.Sub = "Factory · cần Sea 2" return end
    local p = Vector3.new(632, 73, 918)
    local hrp = getRoot() if not hrp then return end
    if dist(hrp.Position, p) > 50 then X.Sub = "Factory · tới" moveTo(p, 400) return end
    stopMoving()
    pcall(function() Invoke("FactoryRaid") end)
    X.Sub = "Factory · raid"
    task.wait(2)
end
local function pirateRaidTick()
    if not X.AutoPirateRaid then return end
    if SEA ~= 3 then X.Sub = "Pirate Raid · cần Sea 3" return end
    local b = findBoss("Pirate Millionaire")
    if b then targetFarm(b, "Pirate Raid")
    else X.Sub = "Pirate Raid · chờ" hoverAt(CFrame.new(-290,42,5581).Position) end
end
local function gachaMagnetTick()
    if not X.AutoGachaMagnet then return end
    if tick() - X.LastGacha < 5 then return end
    X.LastGacha = tick()
    pcall(function() Invoke("Gacha", "Magnet") end)
    X.Sub = "Gacha Magnet · thử"
    task.wait(2)
end
local function magnetEventTick()
    if not X.AutoMagnetEvent then return end
    if SEA ~= 3 then X.Sub = "Magnet Event · cần Sea 3" return end
    local best, bd
    local hrp = getRoot() if not hrp then return end
    for _, e in ipairs(enemies()) do
        if e.m.Name:lower():find("magnet") then
            local d = dist(e.r.Position, hrp.Position)
            if not bd or d < bd then best, bd = e.m, d end
        end
    end
    if best then targetFarm(best, "Magnet")
    else X.Sub = "Magnet Event · chờ" hoverAt(CFrame.new(-13234,331,-7625).Position) end
end
local PvP = { LastHL = nil }
local function silentAimTick()
    if not X.SilentAim then return end
    local cam = S.WS.CurrentCamera
    local sc = Vector2.new(VP.X/2, VP.Y/2)
    local best, bd, bestHP
    if X.SilentAimPlayer then
        for _, pl in ipairs(S.Players:GetPlayers()) do
            if pl ~= LP and pl.Character then
                local head = pl.Character:FindFirstChild("Head")
                local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                if head and hum and hum.Health > 0 then
                    local sp, onScreen = cam:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local d = (Vector2.new(sp.X, sp.Y) - sc).Magnitude
                        if d < X.AimbotFOV then
                            if X.TargetLowestHP then
                                if not bestHP or hum.Health < bestHP then best, bd, bestHP = head, d, hum.Health end
                            else if not bd or d < bd then best, bd = head, d end end
                        end
                    end
                end
            end
        end
    else
        for _, e in ipairs(enemies()) do
            if e.h.Health > 0 then
                local head = e.m:FindFirstChild("Head") or e.r
                local sp, onScreen = cam:WorldToViewportPoint(head.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - sc).Magnitude
                    if d < X.AimbotFOV then
                        if X.TargetLowestHP then
                            if not bestHP or e.h.Health < bestHP then best, bd, bestHP = head, d, e.h.Health end
                        else if not bd or d < bd then best, bd = head, d end end
                    end
                end
            end
        end
    end
    if best then
        cam.CFrame = CFrame.new(cam.CFrame.Position, best.Position)
        if X.Tracer then
            if PvP.LastHL and PvP.LastHL.Parent then
                local old = PvP.LastHL:FindFirstChild("HL_Tracer")
                if old then old:Destroy() end
            end
            if PvP.LastHL ~= best then
                local hl = Instance.new("Highlight")
                hl.Name = "HL_Tracer"
                hl.FillColor = Color3.fromRGB(255,0,0)
                hl.FillTransparency = 0.5
                hl.OutlineColor = Color3.fromRGB(255,255,255)
                hl.Parent = best
                PvP.LastHL = best
            end
        end
    end
end
local function drawFovCircle()
    if not X.FovCircle then
        if X._fovCircle then X._fovCircle:Destroy() X._fovCircle = nil end
        return
    end
    if not X._fovCircle or not X._fovCircle.Parent then
        local sg2 = Instance.new("ScreenGui")
        sg2.Name = "HL_FOV"
        sg2.IgnoreGuiInset = true
        sg2.Parent = GUI
        local c = Instance.new("Frame")
        c.Name = "Circle"
        c.BackgroundTransparency = 1
        c.Size = UDim2.new(0, X.AimbotFOV*2, 0, X.AimbotFOV*2)
        c.Position = UDim2.new(0.5, -X.AimbotFOV, 0.5, -X.AimbotFOV)
        c.Parent = sg2
        local st2 = Instance.new("UIStroke")
        st2.Color = Color3.fromRGB(255,200,90)
        st2.Thickness = 1
        st2.Transparency = 0.5
        st2.Parent = c
        local cc = Instance.new("UICorner")
        cc.CornerRadius = UDim.new(1,0)
        cc.Parent = c
        X._fovCircle = sg2
    end
    pcall(function()
        if X._fovCircle and X._fovCircle:FindFirstChild("Circle") then
            X._fovCircle.Circle.Size = UDim2.new(0, X.AimbotFOV*2, 0, X.AimbotFOV*2)
            X._fovCircle.Circle.Position = UDim2.new(0.5, -X.AimbotFOV, 0.5, -X.AimbotFOV)
        end
    end)
end
local function waterWalkTick()
    if not X.WaterWalk then return end
    local hrp = getRoot() if not hrp then return end
    if hrp.Position.Y < -5 then
        hrp.CFrame = CFrame.new(hrp.Position.X, 1, hrp.Position.Z)
        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
    end
end
local function bypassSpeedTick()
    if not X.BypassSpeed then return end
    local hrp = getRoot()
    local h = getHum()
    if not hrp or not h then return end
    local mv = h.MoveDirection
    if mv.Magnitude > 0 then
        local speed = h.WalkSpeed * X.BypassSpeedMul
        hrp.AssemblyLinearVelocity = Vector3.new(mv.X*speed, hrp.AssemblyLinearVelocity.Y, mv.Z*speed)
    end
end
local function autoBerryTick()
    if not X.AutoBerry then return end
    local hrp = getRoot() if not hrp then return end
    for _, o in ipairs(S.WS:GetChildren()) do
        if o.Name:lower():find("berry") then
            local p = o:IsA("BasePart") and o or o:FindFirstChildWhichIsA("BasePart")
            if p and dist(p.Position, hrp.Position) < 500 then
                teleportTo(CFrame.new(p.Position + Vector3.new(0,3,0)))
                task.wait(0.2)
                return
            end
        end
    end
end
local function collectHopTick()
    if not X.AutoCollectHop then return end
    local hrp = getRoot() if not hrp then return end
    for _, o in ipairs(S.WS:GetDescendants()) do
        if o.Name:lower():find("hop") and o:IsA("BasePart") and dist(o.Position, hrp.Position) < 300 then
            teleportTo(CFrame.new(o.Position + Vector3.new(0,3,0)))
            task.wait(0.2)
            return
        end
    end
end
local function islandTeleportTick()
    if not X.IslandTP then return end
    X.IslandTP = false
    local seaName = SEA == 1 and "Sea 1" or (SEA == 2 and "Sea 2" or "Sea 3")
    local sea = ISLANDS[seaName]
    if not sea then X.Sub = "Island · không rõ Sea" return end
    local p = sea[X.IslandName]
    if not p then X.Sub = "Island · không có "..X.IslandName return end
    teleportTo(CFrame.new(p + Vector3.new(0, 10, 0)))
    X.Sub = "Island · "..X.IslandName
end
local function runRegionFarm()
    if not X.RegionFarm then return end
    local p = REGIONS[X.RegionName]
    if not p then return end
    X.TargetName = nil
    local hrp = getRoot() if not hrp then return end
    local target = CFrame.new(p + Vector3.new(0, X.Hover, 0))
    if dist(hrp.Position, target.Position) > 30 then
        if X.FarTP and dist(hrp.Position, target.Position) > 1500 then teleportTo(target) else moveTo(target) end
    end
    X.Sub = "Region · "..X.RegionName
end
local function runBonesFarm()
    if not X.AutoBones then return end
    if SEA ~= 3 then X.Sub = "Bones · cần Sea 3" return end
    local lv = myLevel()
    local mob, giver, q, qid = "Reborn Skeleton", CFrame.new(-9479,141,5566), "HauntedQuest1", 1
    if X.AutoQuest then
        local qp = getQuestInfo()
        local done = qp and qp.cur >= qp.max
        if X.QuestLv ~= lv or done or not qp then
            local hrp = getRoot()
            if hrp and dist(hrp.Position, giver.Position) > 14 then moveTo(giver + Vector3.new(0,4,3)) return end
            stopMoving() Invoke("StartQuest", q, qid) X.QuestLv = lv task.wait(0.3) return
        end
    end
    local m = findMob(mob)
    if m then targetFarm(m, "Bones") else hoverAt(giver.Position) end
    X.Sub = "Bones · "..mob
end
local function runEctoFarm()
    if not X.AutoEcto then return end
    if SEA ~= 2 then X.Sub = "Ecto · cần Sea 2" return end
    local mob, giver = "Ship Deckhand", CFrame.new(1037,125,32911)
    local m = findMob(mob)
    if m then targetFarm(m, "Ecto") else hoverAt(giver.Position) end
    X.Sub = "Ectoplasm · "..mob
end
local function runDoughFarm()
    if not X.AutoDough then return end
    if SEA ~= 3 then X.Sub = "Dough · cần Sea 3" return end
    local b = findBoss("Cake Prince") or findBoss("Dough King")
    if b then targetFarm(b, "Cake Prince")
    else hoverAt(CFrame.new(-2021,37,-12028).Position) X.Sub = "Dough · chờ spawn" end
end
local function runEliteFarm()
    if not X.AutoElite then return end
    if SEA ~= 3 then X.Sub = "Elite · cần Sea 3" return end
    local m = findMob("Elite Pirate") or findMob("Elite Hunter")
    if m then targetFarm(m, "Elite")
    else X.Sub = "Elite · chờ spawn" hoverAt(CFrame.new(5259,37,4050).Position) end
end
local function collectMaterials()
    if not X.AutoMaterials then return end
    local list = MATERIALS[SEA] or MATERIALS[1]
    local hrp = getRoot() if not hrp then return end
    local found
    for _, n in ipairs(list) do
        local p = findGroundDrop(n)
        if p then found = p X.Sub = "Material · "..n break end
    end
    if found and dist(found.Position, hrp.Position) > 4 then
        teleportTo(CFrame.new(found.Position + Vector3.new(0,3,0)))
        task.wait(0.25)
    end
end
local function runDungeonMode()
    if not X.AutoDungeon then return end
    local npc = CFrame.new(5259, 37, 4050)
    local hrp = getRoot() if not hrp then return end
    if dist(hrp.Position, npc.Position) > 30 then X.Sub = "Dungeon · tới NPC" moveTo(npc + Vector3.new(0,4,3)) return end
    stopMoving()
    pcall(function() Invoke("Dungeon", "Start") end)
    pcall(function() Invoke("StartDungeon") end)
    X.Sub = "Dungeon · đang chạy"
    task.wait(1)
end
local function aimbotTick()
    if not X.Aimbot then return end
    local cam = S.WS.CurrentCamera
    local hrp = getRoot() if not hrp then return end
    local myPos = hrp.Position
    local sc = Vector2.new(VP.X/2, VP.Y/2)
    local best, bd
    for _, e in ipairs(enemies()) do
        if e.h.Health > 0 then
            local head = e.m:FindFirstChild("Head") or e.r
            local sp, onScreen = cam:WorldToViewportPoint(head.Position)
            if onScreen then
                local d = (Vector2.new(sp.X, sp.Y) - sc).Magnitude
                if d < X.AimbotFOV and dist(myPos, head.Position) < 1000 then
                    if not bd or d < bd then best, bd = head, d end
                end
            end
        end
    end
    if best then
        local tgt = CFrame.new(cam.CFrame.Position, best.Position)
        cam.CFrame = cam.CFrame:Lerp(tgt, math.clamp(X.AimbotSmooth, 0.05, 1))
    end
end
local function killAuraTick()
    if not X.KillAura then return end
    if tick() - X.LastAura < 0.05 then return end
    X.LastAura = tick()
    local hrp = getRoot() if not hrp then return end
    if not R.Hit or not R.Attack then return end
    local list = {} local first_head
    for _, e in ipairs(enemies()) do
        if e.h.Health > 0 and dist(e.r.Position, hrp.Position) <= X.AuraRange then
            if not first_head then first_head = e.m:FindFirstChild("Head") or e.r end
            list[#list+1] = e.r
        end
    end
    if #list > 0 then
        pcall(function()
            R.Attack:FireServer(0)
            R.Hit:FireServer(first_head, list, nil, "")
        end)
    end
end
local FAST_PRESETS = {
    Legit={delay=0.060, burst=1}, Safe={delay=0.033, burst=1}, Normal={delay=0.016, burst=1},
    Fast={delay=0.008, burst=2}, Turbo={delay=0.000, burst=3}, Insane={delay=0.000, burst=5},
}
local function tryBuySkills()
    if not R.CommF then return end
    if X.AutoBuyGeppo then local c = LP.Character if c and not c:FindFirstChild("Geppo") then Invoke("BuyHaki","Geppo") end end
    if X.AutoBuySoru then local c = LP.Character if c and not c:FindFirstChild("Soru") then Invoke("BuyHaki","Soru") end end
    if X.AutoBuyKen then local c = LP.Character if c and not c:FindFirstChild("HasKen") then Invoke("BuyHaki","Ken") end end
end
local DEFAULT_CODES = {
    "Sub2CaptainMaui","kittgaming","Sub2Fer999","Enyu_is_Pro","Magicbus","JCWK","Starcodeheo","Bluxxy","fudd10_v2","fudd10","Bignews",
    "THEGREATACE","Sub2NoobMaster123","Sub2UncleKizaru","Sub2Daigrock","Axiore","TantaiGaming","StrawHatMaine","Sub2OfficialNoobie",
    "FountainDrip","Chandler","SECRET_ADMIN","ADMIN_SECRET","KITTGAMING","THEGREATACEBLASTER","GAMER_ROBOT_1M","FUDD10_HAHA",
    "DEVSCOOKING","SUB2GAMERROBOT_EXP1","FountainCity","SkyCity","Kingdom",
}
local function autoRedeem()
    if not X.AutoRedeem or X.Redeemed then return end
    X.Redeemed = true
    for _, c in ipairs(DEFAULT_CODES) do Invoke("Redeem", c) task.wait(0.35) end
    notify("Redeem", "Đã thử ".. #DEFAULT_CODES .." code", 5)
end
local function playerAlertTick()
    if not X.PlayerAlert then X.AlertedPlayers = {} return end
    local hrp = getRoot() if not hrp then return end
    for _, pl in ipairs(S.Players:GetPlayers()) do
        if pl ~= LP and pl.Character then
            local r = pl.Character:FindFirstChild("HumanoidRootPart")
            if r and dist(r.Position, hrp.Position) <= X.AlertRange then
                if not X.AlertedPlayers[pl] then
                    X.AlertedPlayers[pl] = true
                    notify("CẢNH BÁO", pl.Name.." lại gần ("..math.floor(dist(r.Position, hrp.Position)).."m)", 5)
                end
            else X.AlertedPlayers[pl] = nil end
        end
    end
end
local function timerTick()
    if X.TimerMin <= 0 or X.TimerStart <= 0 then return end
    if (tick() - X.TimerStart) / 60 >= X.TimerMin then
        X.TimerMin = 0 X.TimerStart = 0
        notify("Hẹn giờ", "Hết — rejoin.", 5)
        pcall(function() S.TP:Teleport(game.PlaceId, LP) end)
    end
end
local function rollFruitLoop()
    if not X.RollAuto then return end
    if tick() - X.LastRoll < 6 then return end
    X.LastRoll = tick()
    Invoke("Cousin", "Buy") task.wait(0.3)
    local inv = Invoke("GetFruits")
    if type(inv) ~= "table" then return end
    for _, f in ipairs(inv) do
        local nm = type(f) == "table" and (f.Name or f.name) or tostring(f)
        if fruitRarity(nm) >= X.RollMin then
            X.RollAuto = false
            notify("Roll", "Đã ra "..nm, 6)
            break
        end
    end
end
local function storeByNameTick()
    if #X.StoreNames == 0 then return end
    if tick() - X.LastStoreName < 5 then return end
    X.LastStoreName = tick()
    local inv = Invoke("GetFruits")
    if type(inv) ~= "table" then return end
    for _, f in ipairs(inv) do
        local nm = type(f) == "table" and (f.Name or f.name) or tostring(f)
        for _, want in ipairs(X.StoreNames) do
            if nm == want or nm:lower() == want:lower() then
                Invoke("StoreFruit", nm)
                X.Sub = "Kho · "..nm
                return
            end
        end
    end
end
local function sniperByNameTick()
    if X.FruitSniperName == "" or not X.FruitSniper then return end
    for _, f in ipairs(scanFruits()) do
        if f.name == X.FruitSniperName or f.name:lower() == X.FruitSniperName:lower() then
            local hrp = getRoot()
            if hrp and dist(f.pos, hrp.Position) < 6000 and tick() - X.LastSniper > 1.5 then
                X.LastSniper = tick()
                teleportTo(CFrame.new(f.pos))
                X.Sub = "Sniper · "..f.name
                return
            end
        end
    end
end
local AWAKEN_CMDS = {"AwakeFruit","AwakenFruit","Awakening"}
local function awakenTick()
    if not X.AutoAwaken or X.AwakenFruit == "" then return end
    if tick() - X.LastAwake < 8 then return end
    X.LastAwake = tick()
    for _, cmd in ipairs(AWAKEN_CMDS) do pcall(function() Invoke(cmd, X.AwakenFruit) end) end
end
local function raceV4Tick()
    if not X.RaceV4 then return end
    if SEA ~= 3 then X.Sub = "Race V4 · cần Sea 3" return end
    local hrp = getRoot() if not hrp then return end
    local tp = Vector3.new(-21748, 90, 454)
    if dist(hrp.Position, tp) > 50 then moveTo(CFrame.new(tp)) X.Sub = "Race V4 · tới Trial" return end
    stopMoving()
    pcall(function() Invoke("RaceV4") end)
    pcall(function() Invoke("StartRaceV4") end)
    X.Sub = "Race V4 · thử trial"
end
local function runDarkbeard()
    if not X.AutoDarkbeard then return end
    local b = findBoss("Darkbeard")
    if b then targetFarm(b, "Darkbeard")
    else X.Sub = "Darkbeard · chờ spawn" hoverAt(CFrame.new(-13234,331,-7625).Position) end
end
local function runOrder()
    if not X.AutoOrder then return end
    local b = findBoss("Order")
    if b then targetFarm(b, "Order")
    else X.Sub = "Order · chờ spawn" hoverAt(CFrame.new(-14408,340,-7916).Position) end
end
local function runRipIndra()
    if not X.AutoRipIndra then return end
    local b = findBoss("Rip_indra") or findBoss("rip_indra")
    if b then targetFarm(b, "Rip Indra")
    else X.Sub = "Rip Indra · chờ spawn" hoverAt(CFrame.new(-16565,104,1579).Position) end
end
local SEA_BEASTS = {"Terror Shark","Sea Beast","Island Eater","Sea Serpent"}
local SEA_EVENT_BOSSES = {"Stone","Hydra Leader","Beautiful Pirate","Longma","Trial of God","Cake Queen","Cursed Captain","Soul Reaper"}
local function seaBeastTick()
    if not X.AutoSeaBeast then return end
    for _, n in ipairs(SEA_BEASTS) do
        local b = findBoss(n)
        if b then targetFarm(b, "Sea Beast") return end
    end
    X.Sub = "Sea Beast · chờ"
end
local function seaEventTick()
    if not X.AutoSeaEvent then return end
    for _, n in ipairs(SEA_EVENT_BOSSES) do
        local b = findBoss(n)
        if b then targetFarm(b, "Sea Event") return end
    end
    X.Sub = "Sea Event · chờ"
end
local BOSS_RESPAWN = { ["Darkbeard"]=60,["Order"]=60,["Rip_indra"]=60,["Cake Prince"]=90,["Dough King"]=120,["Soul Reaper"]=120,["Cursed Captain"]=60,["Stone"]=30,["Hydra Leader"]=30 }
local function updateBossTimers()
    if X.Destroyed then return end
    local seen = {}
    for _, e in ipairs(enemies()) do
        if e.h.MaxHealth >= 5000 then seen[e.m.Name] = true X._lastBossSeen[e.m.Name] = true end
    end
    for name in pairs(X._lastBossSeen) do
        if not seen[name] then
            X.BossTimers[name] = tick() + (BOSS_RESPAWN[name] or 60)
            X._lastBossSeen[name] = nil
        end
    end
end
local function discord(msg)
    if X.DiscordURL == "" then return end
    task.spawn(function()
        pcall(function()
            local req = request or http_request or (syn and syn.request)
            if req then
                req({ Url=X.DiscordURL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=S.Http:JSONEncode({ content="**HL HUB** "..msg }) })
            end
        end)
    end)
end

--====================================================================================
-- SERVER HOP + CONFIG
--====================================================================================
local function serverHopPing()
    St.Sub = "Hop · tìm server"
    local list, cursor = {}, ""
    for _ = 1, 3 do
        local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100%s"):format(game.PlaceId, cursor ~= "" and ("&cursor="..cursor) or "")
        local ok, d = pcall(function() return S.Http:JSONDecode(game:HttpGet(url)) end)
        if not ok or type(d) ~= "table" or not d.data then break end
        for _, srv in ipairs(d.data) do
            if srv.id ~= game.JobId and not St.HopVisited[srv.id]
                and srv.playing and srv.maxPlayers and srv.playing > 0 and srv.playing < srv.maxPlayers-1
                and (not srv.ping or srv.ping <= St.HopPingMax) then list[#list+1] = srv end
        end
        cursor = d.nextPageCursor or ""
        if cursor == "" or #list >= 10 then break end
    end
    if #list == 0 then notify("Server Hop", "Không tìm thấy server phù hợp", 4) return end
    table.sort(list, function(a,b) return (a.ping or 999) < (b.ping or 999) end)
    local pick = list[math.random(1, math.min(3, #list))]
    St.HopVisited[pick.id] = true
    pcall(function() S.TP:TeleportToPlaceInstance(game.PlaceId, pick.id, LP) end)
end
local CFG_KEYS = {"AutoQuest","AutoHaki","BringMobs","BringRange","BringRate","AutoEquip","EquipType","AttackRange","Hover","Speed","FarTP","WalkSpeed","AtkDelay","AtkBurst","SafeMode","SafeHP","RaidChip","AutoBuyChip","AutoClearRaid","FlySpeed","FruitMinRarity","StoreMinRarity","AntiStuck","MobTimeout","AutoSkill","HopPingMax","AutoBuyHaki","ESPRange","AutoStats","StatType","Lang","Theme","Profile","AutoBones","AutoDough","AutoElite","AutoEcto","AutoMastery","AutoMaterials","RegionFarm","RegionName","Aimbot","AimbotFOV","AimbotSmooth","FastMode","KillAura","AuraRange","AutoBuyGeppo","AutoBuySoru","AutoBuyKen","AutoRedeem","PlayerAlert","AlertRange","AutoRejoin","TimerMin","DiscordURL","FruitSniperName","AwakenFruit","AutoAwaken","RaceV4","AutoDarkbeard","AutoOrder","AutoRipIndra","AutoDungeon","AutoSeaBeast","AutoSeaEvent","RollMin","StoreNames","MasteryTarget","SpecialQuest","AutoFish","AutoBuyBait","SilentAim","SilentAimPlayer","Tracer","TargetLowestHP","FovCircle","WaterWalk","BypassSpeed","BypassSpeedMul","AutoBerry","AutoCollectHop","IslandName","AntiAFK"}
local function saveConfig()
    pcall(function()
        if not writefile then return end
        local t = { SkillCD=St.SkillCD }
        for _, k in ipairs(CFG_KEYS) do t[k] = St[k] end
        writefile(CFG_FILE, S.Http:JSONEncode(t))
    end)
end
local function loadConfig()
    pcall(function()
        if not (readfile and isfile and isfile(CFG_FILE)) then return end
        local t = S.Http:JSONDecode(readfile(CFG_FILE))
        for k, v in pairs(t) do if St[k] ~= nil and type(v) == type(St[k]) then St[k] = v end end
    end)
    MOVE.Speed = St.Speed
end
loadConfig()

--====================================================================================
-- MAIN LOOP
--====================================================================================
local function logBoss(name)
    St.BossKillLog[#St.BossKillLog+1] = { name=name, at=os.date("%H:%M:%S") }
    notify("Boss", name.." đã biến mất", 5)
end
local function doFarmLoop()
    local lv = myLevel()
    St.MyLevel = lv
    local info = getQuestInfo()
    if info then
        local row = getQuestRowFromTitle(info.title) or pickTarget(lv)
        St.CurrentMobName = row[2]
        St.Sub = string.format("%s (%d/%d)", row[2], info.cur, info.max)
        if info.cur < info.max then
            St.QuestCompletedAt = 0
            local mob, mobDist
            local hrp = getRoot()
            if hrp then
                for _, e in ipairs(enemies()) do
                    if e.m.Name == row[2] and e.h.Health > 0 then
                        local d = dist(e.r.Position, hrp.Position)
                        if not mobDist or d < mobDist then mob, mobDist = e.m, d end
                    end
                end
            end
            if mob then
                if not hrp then return end
                local mrp = mob:FindFirstChild("HumanoidRootPart")
                if mrp then
                    local tp = mrp.Position + Vector3.new(0, St.Hover, 0)
                    local md = dist(hrp.Position, tp)
                    if md > 15 then
                        if md > 400 then teleportTo(tp) else moveTo(tp, St.Speed) end
                    else stopMoving() hrp.CFrame = CFrame.new(tp) end
                end
                equipWeapon()
            else
                local gp = Vector3.new(row[3], row[4], row[5])
                if hrp and dist(hrp.Position, gp) > 40 then
                    St.Sub = "→ vùng "..row[2]
                    moveTo(gp + Vector3.new(0, St.Hover, 0), St.Speed)
                else St.Sub = "Chờ mob "..row[2] task.wait(0.3) end
            end
            return
        end
        if St.QuestCompletedAt == 0 then St.QuestCompletedAt = tick() end
        local el = tick() - St.QuestCompletedAt
        if el < 1.5 then
            St.Sub = string.format("✓ Xong (%d/%d) · đánh thêm %.1fs", info.cur, info.max, 1.5-el)
            local mob
            for _, e in ipairs(enemies()) do if e.m.Name == row[2] and e.h.Health > 0 then mob = e.m break end end
            if mob then
                local mrp = mob:FindFirstChild("HumanoidRootPart")
                if mrp then
                    local hrp = getRoot()
                    if hrp and dist(hrp.Position, mrp.Position) > 15 then
                        if dist(hrp.Position, mrp.Position) > 400 then teleportTo(mrp.Position + Vector3.new(0, St.Hover, 0))
                        else moveTo(mrp.Position + Vector3.new(0, St.Hover, 0), St.Speed) end
                    else stopMoving() end
                end
                equipWeapon()
            end
            task.wait(0.1)
            return
        end
        St.QuestCompletedAt = 0
        St.Sub = "Chuẩn bị nhận quest mới..."
        task.wait(0.2)
        return
    end
    St.QuestCompletedAt = 0
    if not St.AutoQuest then St.Sub = "Idle · không có quest" task.wait(0.5) return end
    local row = pickTarget(lv)
    St.CurrentMobName = row[2]
    if tick() - St.LastQuestTry > 2 then
        tryAcceptQuest(row)
    else
        St.Sub = "→ NPC "..row[6]
        local gp = Vector3.new(row[3], row[4], row[5])
        local hrp = getRoot()
        if hrp and dist(hrp.Position, gp) > 35 then
            if dist(hrp.Position, gp) > 400 then teleportTo(gp + Vector3.new(0,5,3))
            else moveTo(gp + Vector3.new(0,5,3), 400) end
        end
    end
end
local function extStep()
    if X.Destroyed then return false end
    if X.AutoFish then autoFishTick() return true end
    if X.AutoFactoryRaid then factoryRaidTick() return true end
    if X.AutoPirateRaid then pirateRaidTick() return true end
    if X.AutoHakiPad then hakiPadTick() return true end
    if X.AutoRipIndraAttack then ripIndraAttackTick() return true end
    if X.AutoSoulReaper then soulReaperTick() return true end
    if X.AutoDoughKing then doughKingTick() return true end
    if X.AutoMagnetEvent then magnetEventTick() return true end
    if X.AutoGachaMagnet then gachaMagnetTick() return true end
    if X.TryLuckyGrave then tryLuckyGraveTick() return true end
    if X.AutoSpecialQuest then specialQuestTick() return true end
    if X.AutoMastery then masteryFarmTick() return true end
    if X.AutoCompleteQuest then completeQuestTick() return true end
    if X.AutoBerry then autoBerryTick() return true end
    if X.AutoCollectHop then collectHopTick() return true end
    if X.IslandTP then islandTeleportTick() return true end
    return false
end
local function step()
    local h = getHum()
    if St.Panic then St.Attacking = false St.Sub = "PANIC" task.wait(0.5) return end
    if not h or h.Health <= 0 then St.Attacking = false St.Sub = "Chết" task.wait(1) return end
    if St.SafeMode and h.MaxHealth > 0 and h.Health / h.MaxHealth * 100 < St.SafeHP then St.Attacking = false St.Sub = "Safe" task.wait(0.5) return end
    St.Attacking = true
    St.MyLevel = myLevel()
    checkHaki() autoBuyHakiTick() antiStuckTick()
    if extStep() then task.wait(St.LoopDelay) return end
    if St.AutoRipIndra then runRipIndra() return end
    if St.AutoOrder then runOrder() return end
    if St.AutoDarkbeard then runDarkbeard() return end
    if St.AutoSeaEvent then seaEventTick() return end
    if St.AutoSeaBeast then seaBeastTick() return end
    if St.AutoDungeon then runDungeonMode() return end
    if St.AutoMagnet then magnetEventTick() return end
    if St.AutoDough then runDoughFarm() return end
    if St.AutoElite then runEliteFarm() return end
    if St.AutoBones then runBonesFarm() return end
    if St.AutoEcto then runEctoFarm() return end
    if St.AutoMaterials then collectMaterials() return end
    if St.RegionFarm then runRegionFarm() return end
    if St.RaceV4 then raceV4Tick() return end
    if St.AutoRaid then
        St.TargetName = nil
        if St.AutoClearRaid and RaidFns.inRaid() then RaidFns.clear()
        elseif RaidFns.hasChip() and not RaidFns.inRaid() then RaidFns.start()
        elseif St.AutoBuyChip and not RaidFns.hasChip() then RaidFns.buy()
        else St.Sub = "Raid · chờ" end
    elseif St.AutoBoss then
        local b = findBoss(GUI_State.SelectedBoss)
        if b then St.BossSeen = GUI_State.SelectedBoss targetFarm(b, "Boss")
        else
            if St.BossSeen then logBoss(St.BossSeen) St.BossSeen = nil end
            St.Sub = "Boss · chờ spawn" task.wait(0.5)
        end
    elseif St.AutoNearest then
        local m = findNearest(3000)
        if m then targetFarm(m, "Gần nhất") else St.Sub = "Gần nhất · không có" St.TargetName = nil task.wait(0.4) end
    elseif St.AutoSpecific then
        local m = findMob(GUI_State.SelectedMob)
        if m then targetFarm(m, "Mob chỉ định") else St.Sub = "Mob chỉ định · không có" task.wait(0.4) end
    elseif St.AutoChest then
        St.TargetName = nil
        runChestFarm()
    elseif St.AutoFarm then
        doFarmLoop()
    end
    task.wait(St.LoopDelay)
end
local function mainLoop()
    while anyMode() and not St.Destroyed do
        local ok, err = pcall(step)
        if not ok then warn("[HL] "..tostring(err)) task.wait(0.5) end
    end
    St.Attacking = false St.Sub = "Idle" St.TargetName = nil
    stopMoving() cleanBring()
end
local UI = {}
UI.upd = function()
    if anyMode() and not St.Running and not St.Destroyed then
        St.Running = true
        task.spawn(function() mainLoop() St.Running = false end)
    end
end

--====================================================================================
-- THREADS
--====================================================================================
do
    local lastAtk = 0
    conn(S.Run.Heartbeat, function()
        if St.Destroyed or St.Panic or not St.Attacking then return end
        local now = tick()
        if now - lastAtk < St.AtkDelay then return end
        lastAtk = now
        for _ = 1, math.max(1, St.AtkBurst) do doAttack() end
    end)
end
task.spawn(function()
    pcall(function() sethiddenproperty(LP, "SimulationRadius", math.huge) end)
    while not St.Destroyed do
        task.wait(math.max(0.05, St.BringRate))
        if St.Attacking and St.BringMobs and not St.Panic and not St.AutoRaid then pcall(bringMobs) end
    end
end)
task.spawn(function()
    while not St.Destroyed do task.wait(0.1) if St.Attacking and not St.Panic then pcall(autoSkillTick) end end
end)
task.spawn(function()
    while not St.Destroyed do
        task.wait(3)
        if St.AutoStats and R.CommF and not St.Panic then task.spawn(function() Invoke("AddPoint", St.StatType, 3) end) end
    end
end)
task.spawn(function()
    while not St.Destroyed do task.wait(0.5) if not St.Panic then pcall(tickFruit) end end
end)
task.spawn(function()
    while not St.Destroyed do task.wait(0.6) if not St.Panic then pcall(espUpdate) end end
end)
task.spawn(function()
    while not St.Destroyed do
        task.wait(0.02)
        if St.Attacking or St.KillAura then pcall(aimbotTick) pcall(killAuraTick) end
        if X.SilentAim then pcall(silentAimTick) end
        if X.WaterWalk then pcall(waterWalkTick) end
        if X.BypassSpeed then pcall(bypassSpeedTick) end
        pcall(drawFovCircle)
    end
end)
task.spawn(function()
    while not St.Destroyed do
        task.wait(0.5)
        pcall(tryBuySkills) pcall(playerAlertTick) pcall(timerTick)
        pcall(storeByNameTick) pcall(sniperByNameTick) pcall(awakenTick)
        pcall(rollFruitLoop) pcall(autoRedeem)
    end
end)
task.spawn(function()
    while not St.Destroyed do task.wait(1) pcall(updateBossTimers) end
end)
task.spawn(function()
    while not St.Destroyed do
        task.wait(60)
        if X.AntiAFK then pcall(function() S.VU:CaptureController() S.VU:ClickButton2(Vector2.new()) end) end
    end
end)
conn(S.Players.PlayerRemoving, function(pl)
    if pl == LP and X.AutoRejoin then
        task.wait(2)
        pcall(function() S.TP:Teleport(game.PlaceId, LP) end)
    end
end)
conn(LP.Idled, function()
    pcall(function() S.VU:CaptureController() S.VU:ClickButton2(Vector2.new()) end)
end)
conn(S.Run.Heartbeat, function()
    if St.Destroyed then return end
    local cnt = #enemies()
    if St._lastEnemyCount and cnt < St._lastEnemyCount then
        St.StatKills = St.StatKills + (St._lastEnemyCount - cnt)
    end
    St._lastEnemyCount = cnt
end)

--====================================================================================
-- UI
--====================================================================================
do
local T = {
    bg0=Color3.fromRGB(6,8,14), bg1=Color3.fromRGB(12,15,22),
    bg2=Color3.fromRGB(18,22,34), bg3=Color3.fromRGB(26,32,48),
    txt=Color3.fromRGB(240,244,255), dim=Color3.fromRGB(150,158,185),
    fnt=Color3.fromRGB(78,88,112),
    acc=Color3.fromRGB(255,200,90), hot=Color3.fromRGB(255,230,160),
    vio=Color3.fromRGB(200,150,255),
    ok=Color3.fromRGB(72,235,168), warn=Color3.fromRGB(255,200,110),
    bad=Color3.fromRGB(255,100,115),
    border=Color3.fromRGB(30,38,54), border2=Color3.fromRGB(56,66,90),
}
local F = { black=Enum.Font.GothamBlack, bold=Enum.Font.GothamBold, med=Enum.Font.GothamMedium, reg=Enum.Font.Gotham, mono=Enum.Font.Code }
local function mk(c, p)
    local o = Instance.new(c)
    for k, v in pairs(p) do if k ~= "Parent" and k ~= "Children" then pcall(function() o[k] = v end) end end
    if p.Children then for _, c2 in ipairs(p.Children) do c2.Parent = o end end
    o.Parent = p.Parent
    return o
end
local function tw(o, t, p, s, d) S.Tween:Create(o, TweenInfo.new(t, s or Enum.EasingStyle.Quint, d or Enum.EasingDirection.Out), p):Play() end
local function corner(o, r) mk("UICorner", { CornerRadius=UDim.new(0, r or 8), Parent=o }) end
local function stroke(o, c, t, tr) return mk("UIStroke", { Color=c or T.acc, Thickness=t or 1, Transparency=tr or 0.4, ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=o }) end
local ORD = {}
local function nx(par) ORD[par] = (ORD[par] or 0) + 1 return ORD[par] end

local sg = mk("ScreenGui", { Name="HL_Hub", ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=GUI, DisplayOrder=60 })
local reopen = mk("TextButton", { Size=UDim2.new(0,110,0,34), Position=UDim2.new(0,14,0,170), BackgroundColor3=T.acc, Text="HOÀNG LÂM", Font=F.black, TextSize=13, TextColor3=T.bg0, Visible=false, Parent=sg })
corner(reopen, 10); stroke(reopen, T.hot, 1.5, 0.3)

local W = MOBILE and math.min(440, VP.X - 20) or 660
local H = MOBILE and math.min(440, VP.Y - 80) or 470

local main = mk("Frame", { Size=UDim2.new(0,W,0,H), Position=UDim2.new(0.5,-W/2,0.5,-H/2), BackgroundColor3=T.bg0, BorderSizePixel=0, Active=true, ClipsDescendants=true, Parent=sg })
corner(main, 20); stroke(main, T.border2, 1, 0.4)
local topGrad = mk("Frame", { Size=UDim2.new(1,-40,0,2), Position=UDim2.new(0,20,0,0), BackgroundColor3=T.acc, BorderSizePixel=0, Parent=main })
mk("UIGradient", { Color=ColorSequence.new({ ColorSequenceKeypoint.new(0,T.bg0), ColorSequenceKeypoint.new(0.35,T.acc), ColorSequenceKeypoint.new(0.7,T.vio), ColorSequenceKeypoint.new(1,T.bg0) }), Parent=topGrad })
local glow = mk("Frame", { Size=UDim2.new(0,340,0,340), Position=UDim2.new(1,-170,0,-170), BackgroundColor3=T.acc, BackgroundTransparency=0.92, BorderSizePixel=0, Parent=main })
corner(glow, 999)

local header = mk("Frame", { Size=UDim2.new(1,0,0,66), BackgroundColor3=T.bg1, BackgroundTransparency=0.15, BorderSizePixel=0, Parent=main })
corner(header, 20)
mk("Frame", { Size=UDim2.new(1,0,0.5,0), Position=UDim2.new(0,0,0.5,0), BackgroundColor3=T.bg1, BackgroundTransparency=0.15, BorderSizePixel=0, Parent=header })
local logo = mk("Frame", { Size=UDim2.new(0,42,0,42), Position=UDim2.new(0,18,0.5,-21), BackgroundColor3=T.bg3, BorderSizePixel=0, Parent=header })
corner(logo, 12); stroke(logo, T.acc, 1, 0.3)
mk("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="HL", Font=F.black, TextSize=18, TextColor3=T.hot, Parent=logo })
mk("TextLabel", { Size=UDim2.new(0,200,0,20), Position=UDim2.new(0,74,0,14), BackgroundTransparency=1, Text=AUTHOR.brand.." "..AUTHOR.version, Font=F.black, TextSize=15, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=header })
mk("TextLabel", { Size=UDim2.new(0,200,0,15), Position=UDim2.new(0,74,0,36), BackgroundTransparency=1, Text="BY "..AUTHOR.name:upper().." · ZALO "..AUTHOR.zalo, Font=F.reg, TextSize=9, TextColor3=T.fnt, TextXAlignment=Enum.TextXAlignment.Left, Parent=header })
local pill = mk("Frame", { Size=UDim2.new(0,90,0,28), Position=UDim2.new(1,-160,0.5,-14), BackgroundColor3=T.bg2, BorderSizePixel=0, Parent=header })
corner(pill, 999)
local pillStroke = stroke(pill, T.border2, 1, 0.4)
local pillDot = mk("Frame", { Size=UDim2.new(0,8,0,8), Position=UDim2.new(0,12,0.5,-4), BackgroundColor3=T.fnt, BorderSizePixel=0, Parent=pill })
corner(pillDot, 999)
local pillText = mk("TextLabel", { Size=UDim2.new(1,-24,1,0), Position=UDim2.new(0,24,0,0), BackgroundTransparency=1, Text="IDLE", Font=F.bold, TextSize=11, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=pill })
local minBtn = mk("TextButton", { Size=UDim2.new(0,32,0,32), Position=UDim2.new(1,-76,0.5,-16), BackgroundColor3=T.bg3, BorderSizePixel=0, Text="—", Font=F.bold, TextSize=16, TextColor3=T.txt, Parent=header })
corner(minBtn, 10)
local closeBtn = mk("TextButton", { Size=UDim2.new(0,32,0,32), Position=UDim2.new(1,-40,0.5,-16), BackgroundColor3=T.bg3, BorderSizePixel=0, Text="✕", Font=F.bold, TextSize=15, TextColor3=T.txt, Parent=header })
corner(closeBtn, 10)

local body = mk("Frame", { Size=UDim2.new(1,0,1,-66), Position=UDim2.new(0,0,0,66), BackgroundTransparency=1, Parent=main })
local sidebar = mk("Frame", { Size=UDim2.new(0,150,1,-24), Position=UDim2.new(0,12,0,12), BackgroundColor3=T.bg1, BackgroundTransparency=0.3, BorderSizePixel=0, Parent=body })
corner(sidebar, 14); stroke(sidebar, T.border, 1, 0.5)
local sidebarScroll = mk("ScrollingFrame", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=3, ScrollBarImageColor3=T.border2, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ElasticBehavior=Enum.ElasticBehavior.Never, Parent=sidebar })
mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder, Parent=sidebarScroll })
mk("UIPadding", { PaddingTop=UDim.new(0,10), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8), PaddingBottom=UDim.new(0,10), Parent=sidebarScroll })
local pageHolder = mk("Frame", { Size=UDim2.new(1,-186,1,-24), Position=UDim2.new(0,174,0,12), BackgroundColor3=T.bg1, BackgroundTransparency=0.3, BorderSizePixel=0, Parent=body })
corner(pageHolder, 14); stroke(pageHolder, T.border, 1, 0.5)

local pages, tabBtns = {}, {}
local function newTab(label, order, key)
    local b = mk("TextButton", { Size=UDim2.new(1,0,0,26), BackgroundColor3=T.bg2, BackgroundTransparency=0.5, BorderSizePixel=0, Text="", AutoButtonColor=false, LayoutOrder=order, Parent=sidebarScroll })
    corner(b, 8)
    local ind = mk("Frame", { Size=UDim2.new(0,3,0,12), Position=UDim2.new(0,5,0.5,-6), BackgroundColor3=T.acc, BorderSizePixel=0, Visible=false, Parent=b })
    corner(ind, 999)
    local dot = mk("Frame", { Size=UDim2.new(0,5,0,5), Position=UDim2.new(0,14,0.5,-2.5), BackgroundColor3=T.fnt, BorderSizePixel=0, Parent=b })
    corner(dot, 999)
    local lbl = mk("TextLabel", { Size=UDim2.new(1,-30,1,0), Position=UDim2.new(0,24,0,0), BackgroundTransparency=1, Text=label, Font=F.med, TextSize=10, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=b })
    tabBtns[key] = { btn=b, ind=ind, dot=dot, lbl=lbl }
end
local function newPage(key)
    local p = mk("Frame", { Name=key, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false, Parent=pageHolder })
    local sc = mk("ScrollingFrame", { Size=UDim2.new(1,-18,1,-18), Position=UDim2.new(0,9,0,9), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=3, ScrollBarImageColor3=T.border2, ScrollBarImageTransparency=0.3, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ElasticBehavior=Enum.ElasticBehavior.Never, Parent=p })
    mk("UIListLayout", { Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder, Parent=sc })
    pages[key] = { root=p, scroll=sc }
    return sc
end
local pageNames = {"Home","Farm","Dungeon","Fruit","Attack","Raid","Misc","FPS","Ext","Event","Utils","Fish","Mastery","Quest","PvP","Island","About"}
local pageRefs = {}
for i, k in ipairs(pageNames) do pageRefs[k] = newPage(k) newTab(k, i, k) end

local function sec(par, txt)
    local w = mk("Frame", { Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, LayoutOrder=nx(par), Parent=par })
    mk("TextLabel", { Size=UDim2.new(1,0,0,14), BackgroundTransparency=1, Text=txt, Font=F.bold, TextSize=10, TextColor3=T.fnt, TextXAlignment=Enum.TextXAlignment.Left, Parent=w })
    mk("Frame", { Size=UDim2.new(0,22,0,2), Position=UDim2.new(0,0,0,16), BackgroundColor3=T.acc, BorderSizePixel=0, Parent=w })
    return w
end
local function glass(par, props, r)
    props.Parent = props.Parent or par
    props.LayoutOrder = props.LayoutOrder or nx(props.Parent)
    local f = mk("Frame", props)
    corner(f, r or 10); stroke(f, T.border2, 1, 0.5)
    return f
end
local function toggle(par, label, desc, def, cb)
    local h = desc and desc ~= ""
    local w = glass(par, { Size=UDim2.new(1,0,0, h and 66 or 50), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
    mk("TextLabel", { Size=UDim2.new(1,-90,0,18), Position=UDim2.new(0,14,0,10), BackgroundTransparency=1, Text=label, Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=w })
    if h then mk("TextLabel", { Size=UDim2.new(1,-90,0,28), Position=UDim2.new(0,14,0,30), BackgroundTransparency=1, Text=desc, Font=F.reg, TextSize=10, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextWrapped=true, Parent=w }) end
    local tr = mk("Frame", { Size=UDim2.new(0,42,0,22), Position=UDim2.new(1,-58,0.5,-11), BackgroundColor3=def and T.ok or T.bg3, BorderSizePixel=0, Parent=w })
    corner(tr, 999)
    local tS = stroke(tr, def and T.ok or T.border2, 1, 0.3)
    local kn = mk("Frame", { Size=UDim2.new(0,16,0,16), Position=def and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, Parent=tr })
    corner(kn, 999)
    local st = def and true or false
    local function paint()
        kn.Position = st and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
        tr.BackgroundColor3 = st and T.ok or T.bg3
        tS.Color = st and T.ok or T.border2
    end
    mk("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", Parent=w }).MouseButton1Click:Connect(function()
        st = not st St.Panic = false paint() if cb then pcall(cb, st) end
    end)
    return { set = function(v) v = v and true or false if st ~= v then st = v paint() if cb then pcall(cb, st) end end end, get = function() return st end }
end
local function slider(par, label, desc, mn, mx, def, un, cb, step)
    step = step or 1
    local h = desc and desc ~= ""
    local w = glass(par, { Size=UDim2.new(1,0,0, h and 82 or 62), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
    mk("TextLabel", { Size=UDim2.new(1,-130,0,18), Position=UDim2.new(0,14,0,10), BackgroundTransparency=1, Text=label, Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=w })
    local vl = mk("TextLabel", { Size=UDim2.new(0,110,0,18), Position=UDim2.new(1,-124,0,10), BackgroundTransparency=1, Text=tostring(def)..(un or ""), Font=F.mono, TextSize=11, TextColor3=T.hot, TextXAlignment=Enum.TextXAlignment.Right, Parent=w })
    if h then mk("TextLabel", { Size=UDim2.new(1,-28,0,26), Position=UDim2.new(0,14,0,30), BackgroundTransparency=1, Text=desc, Font=F.reg, TextSize=10, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextWrapped=true, Parent=w }) end
    local th = mk("Frame", { Size=UDim2.new(1,-28,0,20), Position=UDim2.new(0,14,0, h and 56 or 38), BackgroundTransparency=1, Parent=w })
    local tb = mk("Frame", { Size=UDim2.new(1,0,0,6), Position=UDim2.new(0,0,0.5,-3), BackgroundColor3=T.bg3, BorderSizePixel=0, Parent=th })
    corner(tb, 999)
    local r0 = math.clamp((def-mn)/math.max(1e-9,mx-mn), 0, 1)
    local fl = mk("Frame", { Size=UDim2.new(r0,0,1,0), BackgroundColor3=T.acc, BorderSizePixel=0, Parent=tb })
    corner(fl, 999)
    local kn = mk("Frame", { Size=UDim2.new(0,16,0,16), Position=UDim2.new(r0,0,0.5,0), AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=3, Parent=th })
    corner(kn, 999); stroke(kn, T.acc, 2, 0.2)
    local dragging = false
    local function apply(v)
        v = math.clamp(math.floor(v/step+0.5)*step, mn, mx)
        local r = (v-mn)/math.max(1e-9,mx-mn)
        fl.Size = UDim2.new(r,0,1,0)
        kn.Position = UDim2.new(r,0,0.5,0)
        vl.Text = tostring(math.floor(v*100+0.5)/100)..(un or "")
        if cb then pcall(cb, v) end
    end
    local function upd(ax)
        local tx, tw2 = tb.AbsolutePosition.X, tb.AbsoluteSize.X
        if tw2 <= 0 then return end
        apply(mn + math.clamp((ax-tx)/tw2, 0, 1) * (mx-mn))
    end
    th.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true upd(i.Position.X) end
    end)
    conn(S.UIS.InputChanged, function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then upd(i.Position.X) end
    end)
    conn(S.UIS.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    return { set = apply }
end
local function segments(par, label, opts, def, cb)
    local w = glass(par, { Size=UDim2.new(1,0,0,74), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
    mk("TextLabel", { Size=UDim2.new(1,-28,0,18), Position=UDim2.new(0,14,0,10), BackgroundTransparency=1, Text=label, Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=w })
    local row = mk("Frame", { Size=UDim2.new(1,-28,0,32), Position=UDim2.new(0,14,0,34), BackgroundColor3=T.bg3, BorderSizePixel=0, Parent=w })
    corner(row, 8)
    mk("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder, VerticalAlignment=Enum.VerticalAlignment.Center, Parent=row })
    mk("UIPadding", { PaddingLeft=UDim.new(0,3), PaddingRight=UDim.new(0,3), Parent=row })
    local btns, cur = {}, def
    local function paint()
        for n, b in pairs(btns) do
            local on = n == cur
            b.BackgroundColor3 = on and T.acc or T.bg3
            b.TextColor3 = on and T.bg0 or T.dim
        end
    end
    for i, opt in ipairs(opts) do
        local b = mk("TextButton", { Size=UDim2.new(1/#opts,-3,1,-6), BackgroundColor3=cur==opt and T.acc or T.bg3, BorderSizePixel=0, Text=opt, Font=F.bold, TextSize=11, TextColor3=cur==opt and T.bg0 or T.dim, AutoButtonColor=false, LayoutOrder=i, Parent=row })
        corner(b, 6); btns[opt] = b
        b.MouseButton1Click:Connect(function() cur = opt paint() if cb then pcall(cb, opt) end end)
    end
    paint()
    return { set = function(v) cur = v paint() if cb then pcall(cb, v) end end }
end
local openDropdown = nil
local function dropdown(par, label, opts, def, cb)
    local w = glass(par, { Size=UDim2.new(1,0,0,66), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0, ZIndex=10 })
    w.ClipsDescendants = false
    local function norm(e)
        if type(e) == "table" then return { display=e.display or e.value, value=e.value or e.display } end
        return { display=e, value=e }
    end
    local nd = {}
    for _, e in ipairs(opts) do nd[#nd+1] = norm(e) end
    local dN = norm(def)
    for _, o in ipairs(nd) do if o.value == dN.value then dN = o break end end
    mk("TextLabel", { Size=UDim2.new(1,-140,0,18), Position=UDim2.new(0,14,0,10), BackgroundTransparency=1, Text=label, Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11, Parent=w })
    local curLabel = mk("TextLabel", { Size=UDim2.new(0,130,0,18), Position=UDim2.new(1,-136,0,10), BackgroundTransparency=1, Text=tostring(dN.display), Font=F.mono, TextSize=11, TextColor3=T.hot, TextXAlignment=Enum.TextXAlignment.Right, TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=11, Parent=w })
    local row = mk("Frame", { Size=UDim2.new(1,-28,0,32), Position=UDim2.new(0,14,0,34), BackgroundColor3=T.bg3, BorderSizePixel=0, ZIndex=11, Parent=w })
    corner(row, 8); stroke(row, T.border2, 1, 0.4)
    mk("TextLabel", { Size=UDim2.new(0,20,1,0), Position=UDim2.new(1,-24,0,0), BackgroundTransparency=1, Text="▾", Font=F.bold, TextSize=12, TextColor3=T.dim, ZIndex=12, Parent=row })
    local cur = { display=dN.display, value=dN.value }
    local btn = mk("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=12, Parent=row })
    local function close() if openDropdown and openDropdown.Parent then openDropdown:Destroy() end openDropdown = nil end
    btn.MouseButton1Click:Connect(function()
        if openDropdown and openDropdown.Parent and openDropdown:GetAttribute("Owner") == label then close() return end
        close()
        local listH = math.min(170, VP.Y * 0.35)
        local list = mk("ScrollingFrame", { Name="HL_DropList", Size=UDim2.new(0, row.AbsoluteSize.X, 0, listH), Position=UDim2.new(0, row.AbsolutePosition.X - sg.AbsolutePosition.X, 0, row.AbsolutePosition.Y - sg.AbsolutePosition.Y + row.AbsoluteSize.Y + 4), BackgroundColor3=T.bg1, BorderSizePixel=0, ScrollBarThickness=3, ScrollBarImageColor3=T.border2, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=500, Parent=sg })
        list:SetAttribute("Owner", label)
        corner(list, 8); stroke(list, T.border2, 1, 0.2)
        mk("UIListLayout", { Padding=UDim.new(0,2), SortOrder=Enum.SortOrder.LayoutOrder, Parent=list })
        mk("UIPadding", { PaddingTop=UDim.new(0,6), PaddingBottom=UDim.new(0,6), PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6), Parent=list })
        for i, opt in ipairs(nd) do
            local sel = cur.value == opt.value
            local b = mk("TextButton", { Size=UDim2.new(1,0,0,30), BackgroundColor3=sel and T.acc or T.bg3, BorderSizePixel=0, Text=tostring(opt.display), Font=F.med, TextSize=11, TextColor3=sel and T.bg0 or T.dim, TextXAlignment=Enum.TextXAlignment.Left, AutoButtonColor=false, LayoutOrder=i, ZIndex=501, Parent=list })
            corner(b, 6); mk("UIPadding", { PaddingLeft=UDim.new(0,10), Parent=b })
            b.MouseButton1Click:Connect(function()
                cur = { display=opt.display, value=opt.value }
                curLabel.Text = tostring(opt.display)
                close()
                if cb then pcall(cb, opt.value) end
            end)
        end
        openDropdown = list
    end)
    return {
        set = function(v)
            for _, o in ipairs(nd) do if o.value == v then cur = { display=o.display, value=o.value } curLabel.Text = tostring(o.display) if cb then pcall(cb, o.value) end return end end
        end,
        get = function() return cur.value end,
    }
end
local function actBtn(par, label, cb, variant)
    local bg, fg = T.bg2, T.txt
    if variant == "primary" then bg, fg = T.acc, T.bg0
    elseif variant == "danger" then bg, fg = T.bad, Color3.new(1,1,1)
    elseif variant == "ok" then bg, fg = T.ok, T.bg0 end
    local b = mk("TextButton", { Size=UDim2.new(1,0,0, MOBILE and 42 or 38), BackgroundColor3=bg, BorderSizePixel=0, Text=label, Font=F.bold, TextSize=12, TextColor3=fg, AutoButtonColor=false, LayoutOrder=nx(par), Parent=par })
    corner(b, 10); stroke(b, T.border2, 1, 0.4)
    b.MouseButton1Click:Connect(function() task.spawn(function() pcall(cb) end) end)
    return b
end

local MT = {}
local SL = {}
local RARITY = {"Common","Uncommon","Rare","Legendary","Mythical"}
local RARITY_IDX = { Common=0, Uncommon=1, Rare=2, Legendary=3, Mythical=4 }
local scHome, scFarm, scDungeon = pageRefs.Home, pageRefs.Farm, pageRefs.Dungeon
local scFruit, scAttack, scRaid = pageRefs.Fruit, pageRefs.Attack, pageRefs.Raid
local scMisc, scFPS, scExt = pageRefs.Misc, pageRefs.FPS, pageRefs.Ext
local scEvent, scUtils, scFish = pageRefs.Event, pageRefs.Utils, pageRefs.Fish
local scMastery, scQuest, scPvP, scIsland, scAbout = pageRefs.Mastery, pageRefs.Quest, pageRefs.PvP, pageRefs.Island, pageRefs.About

-- HOME
sec(scHome, "STATUS")
local statRow = mk("Frame", { Size=UDim2.new(1,0,0,80), BackgroundTransparency=1, LayoutOrder=nx(scHome), Parent=scHome })
mk("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder, Parent=statRow })
local function tile(lbl, v, col, order)
    local t = glass(statRow, { Size=UDim2.new(0.32,0,1,0), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0, LayoutOrder=order })
    mk("TextLabel", { Size=UDim2.new(1,-20,0,12), Position=UDim2.new(0,12,0,12), BackgroundTransparency=1, Text=lbl, Font=F.bold, TextSize=9, TextColor3=T.fnt, TextXAlignment=Enum.TextXAlignment.Left, Parent=t })
    local vv = mk("TextLabel", { Size=UDim2.new(1,-20,0,22), Position=UDim2.new(0,12,0,28), BackgroundTransparency=1, Text=v, Font=F.black, TextSize=18, TextColor3=col, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=t })
    local dot = mk("Frame", { Size=UDim2.new(0,6,0,6), Position=UDim2.new(1,-14,1,-14), BackgroundColor3=col, BorderSizePixel=0, Parent=t })
    corner(dot, 999)
    return vv
end
local lvlTile = tile("LEVEL", "1", T.hot, 1)
local modeTile = tile("MODE", "None", T.vio, 2)
local statusTile = tile("STATUS", "Idle", T.ok, 3)
sec(scHome, "THỐNG KÊ")
local stCard = glass(scHome, { Size=UDim2.new(1,0,0,110), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
local kLbl = mk("TextLabel", { Size=UDim2.new(1,-20,0,18), Position=UDim2.new(0,12,0,8), BackgroundTransparency=1, Text="Kills: 0", Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=stCard })
local cLbl = mk("TextLabel", { Size=UDim2.new(1,-20,0,18), Position=UDim2.new(0,12,0,28), BackgroundTransparency=1, Text="Chests: 0", Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=stCard })
local tLbl = mk("TextLabel", { Size=UDim2.new(1,-20,0,18), Position=UDim2.new(0,12,0,48), BackgroundTransparency=1, Text="Time: 00:00", Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=stCard })
local rLbl = mk("TextLabel", { Size=UDim2.new(1,-20,0,18), Position=UDim2.new(0,12,0,68), BackgroundTransparency=1, Text="Kills/phút: 0", Font=F.bold, TextSize=12, TextColor3=T.hot, TextXAlignment=Enum.TextXAlignment.Left, Parent=stCard })

-- FARM
sec(scFarm, "FARM CHÍNH")
MT.AutoFarm = toggle(scFarm, "Auto Farm Level", "Đánh đủ quest → chờ 1.5s → nhận mới.", St.AutoFarm, function(v) St.AutoFarm = v UI.upd() end)
sec(scFarm, "MOB TARGET")
MT.AutoNearest = toggle(scFarm, "Auto Nearest Mob", "Mob gần nhất.", St.AutoNearest, function(v) St.AutoNearest = v UI.upd() end)
MT.AutoSpecific = toggle(scFarm, "Auto Specific Mob", "Mob chọn bên dưới.", St.AutoSpecific, function(v) St.AutoSpecific = v UI.upd() end)
local mobList = {}
for _, n in ipairs(D.MOBS[SEA] or D.MOBS[1]) do mobList[#mobList+1] = { display=dn(n), value=n } end
GUI_State.SelectedMob = mobList[1].value
dropdown(scFarm, "Mob chỉ định", mobList, mobList[1].value, function(v) GUI_State.SelectedMob = v end)
sec(scFarm, "BOSS / RƯƠNG")
MT.AutoBoss = toggle(scFarm, "Auto Boss Farm", "Farm boss chọn.", St.AutoBoss, function(v) St.AutoBoss = v UI.upd() end)
local bossList = D.BOSSES[SEA] or D.BOSSES[1]
GUI_State.SelectedBoss = bossList[1]
dropdown(scFarm, "Boss", bossList, bossList[1], function(v) GUI_State.SelectedBoss = v end)
MT.AutoChest = toggle(scFarm, "Auto Chest", "Bay tới rương gần nhất.", St.AutoChest, function(v) St.AutoChest = v UI.upd() end)
sec(scFarm, "HỖ TRỢ")
toggle(scFarm, "Auto Quest", "Tự nhận quest khi hết.", St.AutoQuest, function(v) St.AutoQuest = v end)
toggle(scFarm, "Auto Haki", "", St.AutoHaki, function(v) St.AutoHaki = v end)
toggle(scFarm, "Auto Buy Haki", "", St.AutoBuyHaki, function(v) St.AutoBuyHaki = v end)
toggle(scFarm, "Bring Mobs", "", St.BringMobs, function(v) St.BringMobs = v end)
toggle(scFarm, "Auto Skill Z/X/C", "", St.AutoSkill, function(v) St.AutoSkill = v end)
toggle(scFarm, "Anti-Stuck", "", St.AntiStuck, function(v) St.AntiStuck = v end)
toggle(scFarm, "Auto Stats", "", St.AutoStats, function(v) St.AutoStats = v end)
dropdown(scFarm, "Chỉ số cộng", { {display="Melee",value="Melee"},{display="Defense",value="Defense"},{display="Sword",value="Sword"},{display="Gun",value="Gun"},{display="Blox Fruit",value="Demon Fruit"} }, St.StatType, function(v) St.StatType = v end)
sec(scFarm, "VŨ KHÍ")
toggle(scFarm, "Auto Equip Weapon", "", St.AutoEquip, function(v) St.AutoEquip = v end)
segments(scFarm, "Loại vũ khí", { "Melee","Sword","Gun" }, St.EquipType, function(v) St.EquipType = v end)
sec(scFarm, "TỐC ĐỘ")
toggle(scFarm, "Teleport xa", "", St.FarTP, function(v) St.FarTP = v end)
SL.speed = slider(scFarm, "Speed", "Tốc độ bay.", 80, 500, St.Speed, " ss", function(v) St.Speed = v MOVE.Speed = v end)
slider(scFarm, "Hover Height", "", 10, 60, St.Hover, " ss", function(v) St.Hover = v end)
slider(scFarm, "Attack Range", "", 30, 200, St.AttackRange, " ss", function(v) St.AttackRange = v end)
SL.bring = slider(scFarm, "Bring Range", "", 100, 800, St.BringRange, " ss", function(v) St.BringRange = v end)
SL.rate = slider(scFarm, "Bring Rate", "", 50, 500, math.floor(St.BringRate*1000), " ms", function(v) St.BringRate = v/1000 end, 10)
toggle(scFarm, "Safe Mode", "", St.SafeMode, function(v) St.SafeMode = v end)
slider(scFarm, "Ngưỡng máu %", "", 5, 95, St.SafeHP, " %", function(v) St.SafeHP = v end)
slider(scFarm, "Mob Timeout", "", 2, 15, St.MobTimeout, " s", function(v) St.MobTimeout = v end)

-- DUNGEON
sec(scDungeon, "DUNGEON MODE")
MT.AutoDungeon = toggle(scDungeon, "Auto Dungeon", "Wave-based combat.", St.AutoDungeon, function(v) St.AutoDungeon = v UI.upd() end)
sec(scDungeon, "MAGNET FARM")
MT.AutoMagnet = toggle(scDungeon, "Auto Magnet Farm", "", St.AutoMagnet, function(v) St.AutoMagnet = v UI.upd() end)

-- FRUIT
sec(scFruit, "FRUIT SNIPER")
toggle(scFruit, "Fruit Sniper", "", St.FruitSniper, function(v) St.FruitSniper = v end)
segments(scFruit, "Rarity tối thiểu", RARITY, RARITY[St.FruitMinRarity+1] or "Rare", function(v) St.FruitMinRarity = RARITY_IDX[v] or 2 end)
sec(scFruit, "BRING / NOTIFY")
toggle(scFruit, "Fruit Bring", "", St.FruitBring, function(v) St.FruitBring = v end)
toggle(scFruit, "Fruit Notifier", "", St.FruitNotify, function(v) St.FruitNotify = v end)
sec(scFruit, "AUTO STORE")
toggle(scFruit, "Auto Store Fruit", "", St.AutoStoreFruit, function(v) St.AutoStoreFruit = v end)
segments(scFruit, "Rarity để cất", RARITY, RARITY[St.StoreMinRarity+1] or "Rare", function(v) St.StoreMinRarity = RARITY_IDX[v] or 2 end)
sec(scFruit, "HÀNH ĐỘNG")
actBtn(scFruit, "Bay tới fruit gần nhất", function()
    local list = scanFruits(true)
    local hrp = getRoot() if not hrp then return end
    local best, bd
    for _, f in ipairs(list) do local d = dist(f.pos, hrp.Position) if not bd or d < bd then best, bd = f, d end end
    if best then teleportTo(CFrame.new(best.pos)) St.Sub = "Fruit · "..best.name end
end, "primary")
sec(scFruit, "DANH SÁCH FRUIT")
for _, f in ipairs(D.FRUITS) do
    local row = glass(scFruit, { Size=UDim2.new(1,0,0,30), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
    mk("TextLabel", { Size=UDim2.new(0.55,-14,1,0), Position=UDim2.new(0,14,0,0), BackgroundTransparency=1, Text=f.name, Font=F.med, TextSize=11, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=row })
    mk("TextLabel", { Size=UDim2.new(0.45,-14,1,0), Position=UDim2.new(0.55,0,0,0), BackgroundTransparency=1, Text=RARITY[f.rarity+1].." · $"..tostring(f.price), Font=F.mono, TextSize=10, TextColor3=({T.fnt,T.dim,T.hot,T.vio,T.bad})[f.rarity+1], TextXAlignment=Enum.TextXAlignment.Right, TextTruncate=Enum.TextTruncate.AtEnd, Parent=row })
end

-- ATTACK
sec(scAttack, "TIMING")
SL.delay = slider(scAttack, "Attack Delay", "", 0, 100, math.floor(St.AtkDelay*1000), " ms", function(v) St.AtkDelay = v/1000 end)
SL.burst = slider(scAttack, "Multi Hit", "", 1, 5, St.AtkBurst, " hits", function(v) St.AtkBurst = math.floor(v) end)
sec(scAttack, "PRESET")
actBtn(scAttack, "An toàn — 33/s", function() SL.delay.set(30) SL.burst.set(1) end)
actBtn(scAttack, "Bình thường — 60/s", function() SL.delay.set(16) SL.burst.set(1) end, "primary")
actBtn(scAttack, "Nhanh — 120/s", function() SL.delay.set(8) SL.burst.set(2) end)
actBtn(scAttack, "TURBO — nhanh nhất", function() SL.delay.set(0) SL.burst.set(2) SL.speed.set(320) SL.bring.set(400) SL.rate.set(100) end, "ok")
actBtn(scAttack, "Cực nhanh — 300/s", function() SL.delay.set(0) SL.burst.set(5) end, "danger")
sec(scAttack, "SKILL CD")
slider(scAttack, "Skill Z CD", "", 0.1, 5, St.SkillCD.Z, " s", function(v) St.SkillCD.Z = v end, 0.1)
slider(scAttack, "Skill X CD", "", 0.1, 5, St.SkillCD.X, " s", function(v) St.SkillCD.X = v end, 0.1)
slider(scAttack, "Skill C CD", "", 0.1, 8, St.SkillCD.C, " s", function(v) St.SkillCD.C = v end, 0.1)
sec(scAttack, "COMBAT NÂNG CAO")
toggle(scAttack, "Aimbot Camera", "", St.Aimbot, function(v) St.Aimbot = v end)
slider(scAttack, "Aimbot FOV", "", 50, 800, St.AimbotFOV, " px", function(v) St.AimbotFOV = v end)
slider(scAttack, "Aimbot Smooth", "", 0.05, 1, St.AimbotSmooth, "", function(v) St.AimbotSmooth = v end, 0.05)
toggle(scAttack, "Kill Aura", "", St.KillAura, function(v) St.KillAura = v end)
slider(scAttack, "Kill Aura Range", "", 20, 200, St.AuraRange, " ss", function(v) St.AuraRange = v end)
segments(scAttack, "Fast Attack Mode", { "Legit","Safe","Normal","Fast","Turbo","Insane" }, St.FastMode, function(v)
    local p = FAST_PRESETS[v] or FAST_PRESETS.Normal
    St.FastMode = v St.AtkDelay = p.delay St.AtkBurst = p.burst
end)

-- RAID
sec(scRaid, "MODE")
MT.AutoRaid = toggle(scRaid, "Auto Raid", "", St.AutoRaid, function(v) St.AutoRaid = v UI.upd() end)
sec(scRaid, "TÙY CHỌN")
toggle(scRaid, "Auto Buy Chip", "", St.AutoBuyChip, function(v) St.AutoBuyChip = v end)
toggle(scRaid, "Auto Clear Raid", "", St.AutoClearRaid, function(v) St.AutoClearRaid = v end)
dropdown(scRaid, "Loại chip", { "Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Door","Rubber","Barrier","Ghost","Revive","Dough","Soul","Chop" }, St.RaidChip, function(v) St.RaidChip = v end)

-- MISC
sec(scMisc, "NHÂN VẬT")
toggle(scMisc, "No Clip", "", St.NoClip, function(v)
    St.NoClip = v
    if not v then
        local c = LP.Character
        if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
    end
end)
toggle(scMisc, "Fly", "", St.Fly, function(v) St.Fly = v end)
slider(scMisc, "Fly Speed", "", 30, 400, St.FlySpeed, "", function(v) St.FlySpeed = v end)
toggle(scMisc, "Infinite Jump", "", St.InfJump, function(v) St.InfJump = v end)
toggle(scMisc, "Lock Speed/Jump", "", St.LockSpeed, function(v) St.LockSpeed = v end)
slider(scMisc, "Walk Speed", "", 16, 200, St.WalkSpeed, "", function(v) St.WalkSpeed = v end)
sec(scMisc, "HÀNH ĐỘNG")
actBtn(scMisc, "Reset nhân vật", function() local h = getHum() if h then h.Health = 0 end end)
actBtn(scMisc, "Xoá sương mù", function()
    pcall(function()
        S.Light.FogEnd = 1e6 S.Light.FogStart = 0
        local at = S.Light:FindFirstChildOfClass("Atmosphere")
        if at then at.Density = 0 at.Haze = 0 end
    end)
end, "primary")
sec(scMisc, "SERVER")
actBtn(scMisc, "Server Hop", function() serverHopPing() end, "primary")
actBtn(scMisc, "Rejoin", function() pcall(function() S.TP:Teleport(game.PlaceId, LP) end) end)
slider(scMisc, "Ping max hop", "", 50, 500, St.HopPingMax, " ms", function(v) St.HopPingMax = v end)
sec(scMisc, "CODE / CONFIG")
actBtn(scMisc, "Nhập tất cả code", function()
    for _, c in ipairs(DEFAULT_CODES) do Invoke("Redeem", c) task.wait(0.3) end
end, "primary")
actBtn(scMisc, "Lưu config", function() saveConfig() notify("Config", "Đã lưu", 3) end, "ok")
actBtn(scMisc, "Tải config", function() loadConfig() notify("Config", "Đã tải", 4) end)

-- FPS
sec(scFPS, "MASTER")
local fS = {}
local fpsMaster = toggle(scFPS, "Bật tất cả FPS Boost", "", false, function(v) for _, t in pairs(fS) do t.set(v) end end)
sec(scFPS, "RENDER")
fS.sh = toggle(scFPS, "Tắt Shadows", "", false, function(v) FPS.shadows(v) end)
fS.pf = toggle(scFPS, "Tắt Post FX", "", false, function(v) FPS.postfx(v) end)
fS.at = toggle(scFPS, "Tắt Atmosphere", "", false, function(v) FPS.atmosphere(v) end)
fS.tr = toggle(scFPS, "Tắt nước Terrain", "", false, function(v) FPS.terrain(v) end)
fS.pa = toggle(scFPS, "Tắt Particles", "", false, function(v) FPS.particles(v) end)
fS.de = toggle(scFPS, "Tắt Decal", "", false, function(v) FPS.decals(v) end)
fS.be = toggle(scFPS, "Tắt Beams", "", false, function(v) FPS.beams(v) end)
fS.li = toggle(scFPS, "Làm tối Lighting", "", false, function(v) FPS.lighting(v) end)
sec(scFPS, "HÀNH ĐỘNG")
actBtn(scFPS, "Bật tất cả", function() fpsMaster.set(true) end, "primary")
actBtn(scFPS, "Khôi phục", function() FPS.restore() for _, t in pairs(fS) do t.set(false) end fpsMaster.set(false) end)

-- EXT
sec(scExt, "FARM ĐẶC BIỆT")
MT.AutoBones = toggle(scExt, "Auto Bones (Sea 3)", "", St.AutoBones, function(v) St.AutoBones = v UI.upd() end)
MT.AutoEcto = toggle(scExt, "Auto Ectoplasm (Sea 2)", "", St.AutoEcto, function(v) St.AutoEcto = v UI.upd() end)
MT.AutoDough = toggle(scExt, "Auto Dough King", "", St.AutoDough, function(v) St.AutoDough = v UI.upd() end)
MT.AutoElite = toggle(scExt, "Auto Elite Hunter", "", St.AutoElite, function(v) St.AutoElite = v UI.upd() end)
MT.AutoMastery = toggle(scExt, "Auto Mastery", "", St.AutoMastery, function(v) St.AutoMastery = v UI.upd() end)
MT.AutoMaterials = toggle(scExt, "Auto Materials", "", St.AutoMaterials, function(v) St.AutoMaterials = v UI.upd() end)
sec(scExt, "REGION FARM")
MT.RegionFarm = toggle(scExt, "Region Farm", "", St.RegionFarm, function(v) St.RegionFarm = v UI.upd() end)
local regionOpts = {}
for k in pairs(REGIONS) do regionOpts[#regionOpts+1] = k end
table.sort(regionOpts)
dropdown(scExt, "Vùng farm", regionOpts, St.RegionName, function(v) St.RegionName = v end)
sec(scExt, "KỸ NĂNG")
toggle(scExt, "Auto Buy Geppo", "", St.AutoBuyGeppo, function(v) St.AutoBuyGeppo = v end)
toggle(scExt, "Auto Buy Soru", "", St.AutoBuySoru, function(v) St.AutoBuySoru = v end)
toggle(scExt, "Auto Buy Ken", "", St.AutoBuyKen, function(v) St.AutoBuyKen = v end)
toggle(scExt, "Auto Redeem Code", "", St.AutoRedeem, function(v) St.AutoRedeem = v if v then St.Redeemed = false end end)
sec(scExt, "FRUIT NÂNG CAO")
toggle(scExt, "Fruit Sniper theo TÊN", "", St.FruitSniper, function(v) St.FruitSniper = v end)
local fruitNames = {}
for _, f in ipairs(D.FRUITS) do fruitNames[#fruitNames+1] = f.name end
dropdown(scExt, "Fruit sniper tên", fruitNames, St.FruitSniperName ~= "" and St.FruitSniperName or fruitNames[1], function(v) St.FruitSniperName = v end)
local snCard = glass(scExt, { Size=UDim2.new(1,0,0,120), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
mk("TextLabel", { Size=UDim2.new(1,-20,0,16), Position=UDim2.new(0,12,0,10), BackgroundTransparency=1, Text="Auto Store theo tên (mỗi dòng 1 fruit)", Font=F.bold, TextSize=11, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=snCard })
local storeBox = mk("TextBox", { Size=UDim2.new(1,-24,0,80), Position=UDim2.new(0,12,0,32), BackgroundColor3=T.bg1, BorderSizePixel=0, Text=table.concat(St.StoreNames, "\n"), PlaceholderText="Dough-Dough\nLeopard-Leopard", Font=F.mono, TextSize=10, TextColor3=T.hot, TextWrapped=true, ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, Parent=snCard })
corner(storeBox, 8)
storeBox.FocusLost:Connect(function()
    St.StoreNames = {}
    for line in storeBox.Text:gmatch("[^\r\n]+") do
        local s = line:gsub("^%s+",""):gsub("%s+$","")
        if s ~= "" then St.StoreNames[#St.StoreNames+1] = s end
    end
    notify("Store", #St.StoreNames.." fruit", 3)
end)
sec(scExt, "ROLL / AWAKEN / RACE")
toggle(scExt, "Auto Roll Fruit", "", St.RollAuto, function(v) St.RollAuto = v end)
segments(scExt, "Roll rarity tối thiểu", RARITY, RARITY[St.RollMin+1] or "Rare", function(v) St.RollMin = RARITY_IDX[v] or 2 end)
toggle(scExt, "Auto Awaken", "", St.AutoAwaken, function(v) St.AutoAwaken = v end)
dropdown(scExt, "Fruit awaken", fruitNames, St.AwakenFruit ~= "" and St.AwakenFruit or fruitNames[1], function(v) St.AwakenFruit = v end)
toggle(scExt, "Auto Race V4 Trial", "", St.RaceV4, function(v) St.RaceV4 = v UI.upd() end)

-- EVENT
sec(scEvent, "BOSS SỰ KIỆN")
toggle(scEvent, "Auto Darkbeard", "", St.AutoDarkbeard, function(v) St.AutoDarkbeard = v UI.upd() end)
toggle(scEvent, "Auto Order", "", St.AutoOrder, function(v) St.AutoOrder = v UI.upd() end)
toggle(scEvent, "Auto Rip Indra", "", St.AutoRipIndra, function(v) St.AutoRipIndra = v UI.upd() end)
toggle(scEvent, "Auto Sea Beast", "", St.AutoSeaBeast, function(v) St.AutoSeaBeast = v UI.upd() end)
toggle(scEvent, "Auto Sea Event Boss", "", St.AutoSeaEvent, function(v) St.AutoSeaEvent = v UI.upd() end)

-- UTILS
sec(scUtils, "CẢNH BÁO")
toggle(scUtils, "Cảnh báo người chơi", "", St.PlayerAlert, function(v) St.PlayerAlert = v end)
slider(scUtils, "Bán kính cảnh báo", "", 50, 2000, St.AlertRange, " ss", function(v) St.AlertRange = v end)
toggle(scUtils, "Auto Rejoin", "", St.AutoRejoin, function(v) St.AutoRejoin = v end)
toggle(scUtils, "Anti-AFK", "", St.AntiAFK, function(v) St.AntiAFK = v end)
sec(scUtils, "HẸN GIỜ")
actBtn(scUtils, "Đặt 15 phút", function() St.TimerMin = 15 St.TimerStart = tick() notify("Timer", "Rejoin sau 15p", 3) end)
actBtn(scUtils, "Đặt 30 phút", function() St.TimerMin = 30 St.TimerStart = tick() notify("Timer", "Rejoin sau 30p", 3) end)
actBtn(scUtils, "Đặt 60 phút", function() St.TimerMin = 60 St.TimerStart = tick() notify("Timer", "Rejoin sau 60p", 3) end)
actBtn(scUtils, "Huỷ hẹn giờ", function() St.TimerMin = 0 St.TimerStart = 0 end, "danger")
sec(scUtils, "GIAO DIỆN")
segments(scUtils, "Ngôn ngữ", { "VN","EN" }, St.Lang, function(v) St.Lang = v end)
segments(scUtils, "Theme màu", { "Gold","Cyan","Pink","Green","Purple","Red" }, St.Theme, function(v)
    local th = { Gold={Color3.fromRGB(255,200,90),Color3.fromRGB(255,230,160)}, Cyan={Color3.fromRGB(80,220,255),Color3.fromRGB(170,240,255)}, Pink={Color3.fromRGB(255,120,200),Color3.fromRGB(255,190,230)}, Green={Color3.fromRGB(90,255,150),Color3.fromRGB(180,255,210)}, Purple={Color3.fromRGB(180,120,255),Color3.fromRGB(220,180,255)}, Red={Color3.fromRGB(255,90,90),Color3.fromRGB(255,160,160)} }
    local t = th[v] or th.Gold
    St.Theme = v T.acc, T.hot = t[1], t[2]
    pcall(function()
        for _, d in ipairs(sg:GetDescendants()) do
            if d:IsA("UIStroke") and d.Color == th.Gold[1] then d.Color = T.acc
            elseif d:IsA("Frame") and d.BackgroundColor3 == th.Gold[1] then d.BackgroundColor3 = T.acc
            elseif d:IsA("TextLabel") and d.TextColor3 == th.Gold[2] then d.TextColor3 = T.hot end
        end
    end)
end)
sec(scUtils, "PROFILES")
actBtn(scUtils, "Lưu Profile", function() St.Profile = "Profile_"..os.date("%Y%m%d_%H%M%S") saveConfig() notify("Profile", "Đã lưu", 4) end, "ok")
actBtn(scUtils, "Tải Profile", function() loadConfig() notify("Profile", "Đã tải", 4) end)
actBtn(scUtils, "Reset config", function() pcall(function() if delfile and isfile and isfile(CFG_FILE) then delfile(CFG_FILE) end end) notify("Config", "Đã xoá", 4) end, "danger")
sec(scUtils, "DISCORD WEBHOOK")
local dcCard = glass(scUtils, { Size=UDim2.new(1,0,0,80), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
mk("TextLabel", { Size=UDim2.new(1,-20,0,16), Position=UDim2.new(0,12,0,10), BackgroundTransparency=1, Text="URL Webhook", Font=F.bold, TextSize=11, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=dcCard })
local dcBox = mk("TextBox", { Size=UDim2.new(1,-24,0,40), Position=UDim2.new(0,12,0,30), BackgroundColor3=T.bg1, BorderSizePixel=0, Text=St.DiscordURL, PlaceholderText="https://discord.com/api/webhooks/...", Font=F.mono, TextSize=10, TextColor3=T.hot, ClearTextOnFocus=false, Parent=dcCard })
corner(dcBox, 8)
dcBox.FocusLost:Connect(function() St.DiscordURL = dcBox.Text if St.DiscordURL ~= "" then discord("Test HL HUB") end end)
actBtn(scUtils, "Test webhook", function() discord("Test thủ công từ HL HUB") end, "primary")

-- FISH
sec(scFish, "FISHING")
toggle(scFish, "Auto Fishing", "", St.AutoFish, function(v) St.AutoFish = v UI.upd() end)
toggle(scFish, "Auto Buy Bait", "", St.AutoBuyBait, function(v) St.AutoBuyBait = v end)
toggle(scFish, "Auto Sell Fish", "", St.AutoSellFish, function(v) St.AutoSellFish = v end)
toggle(scFish, "Auto Quest Fishing", "", St.AutoFishQuest, function(v) St.AutoFishQuest = v end)
sec(scFish, "COLLECT")
toggle(scFish, "Auto Berry", "", St.AutoBerry, function(v) St.AutoBerry = v UI.upd() end)
toggle(scFish, "Auto Collect Hop", "", St.AutoCollectHop, function(v) St.AutoCollectHop = v UI.upd() end)

-- MASTERY
sec(scMastery, "MASTERY FARM")
toggle(scMastery, "Auto Mastery", "", St.AutoMastery, function(v) St.AutoMastery = v UI.upd() end)
segments(scMastery, "Mastery Target", {"Melee","Sword","Gun","Fruit"}, St.MasteryTarget, function(v)
    St.MasteryTarget = v
    if v == "Fruit" then St.EquipType = "Fruit"
    elseif v == "Gun" then St.EquipType = "Gun"
    elseif v == "Sword" then St.EquipType = "Sword"
    else St.EquipType = "Melee" end
end)

-- QUEST
sec(scQuest, "QUEST ĐẶC BIỆT")
toggle(scQuest, "Auto Special Quest", "", St.AutoSpecialQuest, function(v) St.AutoSpecialQuest = v UI.upd() end)
local qNames = {}
for _, q in ipairs(SPECIAL_QUESTS) do qNames[#qNames+1] = q.name end
dropdown(scQuest, "Chọn Quest", qNames, St.SpecialQuest, function(v) St.SpecialQuest = v end)
toggle(scQuest, "Auto Complete Quest", "", St.AutoCompleteQuest, function(v) St.AutoCompleteQuest = v UI.upd() end)
sec(scQuest, "BOSS ĐẶC BIỆT")
toggle(scQuest, "Auto Rip Indra Attack", "", St.AutoRipIndraAttack, function(v) St.AutoRipIndraAttack = v UI.upd() end)
toggle(scQuest, "Auto Soul Reaper", "", St.AutoSoulReaper, function(v) St.AutoSoulReaper = v UI.upd() end)
toggle(scQuest, "Auto Dough King", "", St.AutoDoughKing, function(v) St.AutoDoughKing = v UI.upd() end)
sec(scQuest, "RAID ĐẶC BIỆT")
toggle(scQuest, "Auto Factory Raid", "Sea 2.", St.AutoFactoryRaid, function(v) St.AutoFactoryRaid = v UI.upd() end)
toggle(scQuest, "Auto Pirate Raid", "Sea 3.", St.AutoPirateRaid, function(v) St.AutoPirateRaid = v UI.upd() end)
toggle(scQuest, "Auto Haki Pad", "", St.AutoHakiPad, function(v) St.AutoHakiPad = v UI.upd() end)
sec(scQuest, "GACHA / MAGNET")
toggle(scQuest, "Auto Gacha Magnet", "", St.AutoGachaMagnet, function(v) St.AutoGachaMagnet = v UI.upd() end)
toggle(scQuest, "Auto Magnet Event", "", St.AutoMagnetEvent, function(v) St.AutoMagnetEvent = v UI.upd() end)
toggle(scQuest, "Try Lucky Gravestone", "", St.TryLuckyGrave, function(v) St.TryLuckyGrave = v UI.upd() end)

-- PVP
sec(scPvP, "SILENT AIM")
toggle(scPvP, "Silent Aim", "", St.SilentAim, function(v) St.SilentAim = v end)
toggle(scPvP, "Aim Player (thay NPC)", "", St.SilentAimPlayer, function(v) St.SilentAimPlayer = v end)
toggle(scPvP, "Target Lowest HP", "", St.TargetLowestHP, function(v) St.TargetLowestHP = v end)
toggle(scPvP, "Tracer", "", St.Tracer, function(v) St.Tracer = v end)
toggle(scPvP, "FOV Circle", "", St.FovCircle, function(v) St.FovCircle = v end)
sec(scPvP, "MOVEMENT")
toggle(scPvP, "Water Walk", "", St.WaterWalk, function(v) St.WaterWalk = v end)
toggle(scPvP, "Bypass Speed", "", St.BypassSpeed, function(v) St.BypassSpeed = v end)
slider(scPvP, "Bypass Multiplier", "", 1.1, 3.0, St.BypassSpeedMul, "x", function(v) St.BypassSpeedMul = v end, 0.1)

-- ISLAND
sec(scIsland, "TELEPORT ĐẢO")
toggle(scIsland, "Teleport to Island", "Bật để dịch chuyển.", St.IslandTP, function(v) St.IslandTP = v end)
local seaName = SEA == 1 and "Sea 1" or (SEA == 2 and "Sea 2" or "Sea 3")
local islandOpts = {}
if ISLANDS[seaName] then
    for k in pairs(ISLANDS[seaName]) do islandOpts[#islandOpts+1] = k end
    table.sort(islandOpts)
end
dropdown(scIsland, "Chọn đảo", islandOpts, St.IslandName, function(v) St.IslandName = v end)

-- ABOUT
local function stopAll()
    for _, t in pairs(MT) do t.set(false) end
    St.AutoFarm, St.AutoRaid, St.AutoBoss = false, false, false
    St.AutoChest, St.AutoNearest, St.AutoSpecific = false, false, false
    St.AutoDungeon, St.AutoMagnet = false, false
    St.AutoBones, St.AutoDough, St.AutoElite, St.AutoEcto = false, false, false, false
    St.AutoMastery, St.AutoMaterials, St.RegionFarm = false, false, false
    St.AutoDarkbeard, St.AutoOrder, St.AutoRipIndra = false, false, false
    St.AutoSeaBeast, St.AutoSeaEvent, St.RaceV4 = false, false, false
    St.AutoFish, St.AutoSpecialQuest = false, false
    St.AutoFactoryRaid, St.AutoPirateRaid, St.AutoHakiPad = false, false, false
    St.AutoRipIndraAttack, St.AutoSoulReaper, St.AutoDoughKing = false, false, false
    St.AutoGachaMagnet, St.AutoMagnetEvent, St.TryLuckyGrave = false, false, false
    St.AutoCompleteQuest, St.AutoBerry, St.AutoCollectHop = false, false, false
    St.Panic = true St.Attacking = false
    stopMoving() cleanBring()
    UI.upd()
end
local function unload()
    St.Destroyed = true St.Panic = true St.Attacking = false
    for _, c in ipairs(CONN) do pcall(function() c:Disconnect() end) end
    stopMoving()
    pcall(cleanBring) pcall(espClear) pcall(FPS.restore)
    pcall(function() sg:Destroy() end)
    pcall(function() if St._fovCircle then St._fovCircle:Destroy() end end)
    pcall(function()
        for _, g in ipairs(GUI:GetChildren()) do
            if g.Name == "HL_Watermark" or g.Name == "HL_FOV" then g:Destroy() end
        end
    end)
end
sec(scAbout, "PHÍM TẮT")
local hkCard = glass(scAbout, { Size=UDim2.new(1,0,0,90), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
for i, c in ipairs({ {k="RightShift",d="Panic stop"},{k="RightCtrl",d="Panic stop"},{k="Kéo header",d="Di chuyển"} }) do
    mk("TextLabel", { Size=UDim2.new(0,110,0,20), Position=UDim2.new(0,16,0,14+(i-1)*24), BackgroundTransparency=1, Text=c.k, Font=F.mono, TextSize=11, TextColor3=T.bad, TextXAlignment=Enum.TextXAlignment.Left, Parent=hkCard })
    mk("TextLabel", { Size=UDim2.new(1,-140,0,20), Position=UDim2.new(0,130,0,14+(i-1)*24), BackgroundTransparency=1, Text=c.d, Font=F.reg, TextSize=11, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=hkCard })
end
sec(scAbout, "TÁC GIẢ")
local auCard = glass(scAbout, { Size=UDim2.new(1,0,0,96), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
mk("TextLabel", { Size=UDim2.new(1,-28,0,22), Position=UDim2.new(0,14,0,12), BackgroundTransparency=1, Text=AUTHOR.brand.." "..AUTHOR.version, Font=F.black, TextSize=15, TextColor3=T.hot, TextXAlignment=Enum.TextXAlignment.Left, Parent=auCard })
mk("TextLabel", { Size=UDim2.new(1,-28,0,16), Position=UDim2.new(0,14,0,36), BackgroundTransparency=1, Text="MADE BY "..AUTHOR.name:upper(), Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=auCard })
mk("TextLabel", { Size=UDim2.new(1,-28,0,16), Position=UDim2.new(0,14,0,56), BackgroundTransparency=1, Text="ZALO "..AUTHOR.zalo.." · © 2026 "..AUTHOR.name, Font=F.reg, TextSize=11, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=auCard })
mk("TextLabel", { Size=UDim2.new(1,-28,0,16), Position=UDim2.new(0,14,0,74), BackgroundTransparency=1, Text="Nghiêm cấm bán lại / đổi tên tác giả.", Font=F.reg, TextSize=10, TextColor3=T.bad, TextXAlignment=Enum.TextXAlignment.Left, Parent=auCard })
sec(scAbout, "HÀNH ĐỘNG")
actBtn(scAbout, "Xem log boss", function()
    local n = #St.BossKillLog
    if n == 0 then notify("Log", "Chưa có boss nào bị hạ.", 4) return end
    local lines = {}
    for _, e in ipairs(St.BossKillLog) do lines[#lines+1] = e.at.." · "..e.name end
    print("[HL] Log boss:\n"..table.concat(lines, "\n"))
    local last = St.BossKillLog[n]
    notify("Log boss", n.." boss · gần nhất: "..last.name, 6)
end)
actBtn(scAbout, "Reset Quest Tracker", function() St.QuestLv = -1 St.LastQuestTry = 0 St.QuestCompletedAt = 0 end)
actBtn(scAbout, "Dừng tất cả", stopAll, "danger")
actBtn(scAbout, "Gỡ script", unload, "danger")

-- TAB SWITCH
local busyTab = false
local function setTab(key)
    if busyTab then return end
    busyTab = true
    if openDropdown then pcall(function() openDropdown:Destroy() end) openDropdown = nil end
    for k, p in pairs(pages) do p.root.Visible = (k == key) end
    for k, t in pairs(tabBtns) do
        local on = k == key
        t.ind.Visible = on
        tw(t.btn, 0.22, { BackgroundColor3 = on and T.bg3 or T.bg2, BackgroundTransparency = on and 0 or 0.5 })
        tw(t.dot, 0.22, { BackgroundColor3 = on and T.hot or T.fnt })
        tw(t.lbl, 0.22, { TextColor3 = on and T.txt or T.dim })
    end
    task.wait(0.1)
    busyTab = false
end
for k, t in pairs(tabBtns) do t.btn.MouseButton1Click:Connect(function() setTab(k) end) end
task.spawn(setTab, "Home")

UI.upd = function()
    if anyMode() then
        tw(pill, 0.22, { BackgroundColor3 = T.ok })
        pillStroke.Color = T.ok
        pillText.TextColor3 = T.bg0
        pillDot.BackgroundColor3 = T.bg0
        local mt, mc = "AUTO", T.ok
        if St.AutoRaid then mt, mc = "RAID", T.vio
        elseif St.AutoDungeon then mt, mc = "DUNGEON", T.acc
        elseif St.AutoMagnet then mt, mc = "MAGNET", T.hot
        elseif St.AutoFish then mt, mc = "FISH", T.acc
        elseif St.AutoSpecialQuest then mt, mc = "QUEST", T.vio
        elseif St.AutoBoss then mt, mc = "BOSS", T.bad
        elseif St.AutoNearest then mt, mc = "NEAR", T.hot
        elseif St.AutoSpecific then mt, mc = "MOB", T.vio
        elseif St.AutoChest then mt, mc = "CHEST", T.warn
        elseif St.AutoFarm then mt, mc = "FARM", T.hot end
        pillText.Text = mt modeTile.Text = mt modeTile.TextColor3 = mc
        if not St.Running and not St.Destroyed then
            St.Running = true
            task.spawn(function() mainLoop() St.Running = false end)
        end
    else
        pillText.Text = "IDLE"
        pillText.TextColor3 = T.dim
        pillStroke.Color = T.border2
        pillDot.BackgroundColor3 = T.fnt
        tw(pill, 0.22, { BackgroundColor3 = T.bg2 })
        modeTile.Text = "None"
        modeTile.TextColor3 = T.dim
        St.Sub = "Idle"
    end
end

-- DRAG
local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = i.Position startPos = main.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
conn(S.UIS.InputChanged, function(i)
    if not dragging then return end
    if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
    local d = i.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
end)
conn(S.UIS.InputBegan, function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightControl or i.KeyCode == Enum.KeyCode.RightShift then stopAll() end
end)
local minimized = false
local origSize = UDim2.new(0, W, 0, H)
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tw(main, 0.32, { Size = minimized and UDim2.new(0, W, 0, 66) or origSize })
    body.Visible = not minimized
    minBtn.Text = minimized and "+" or "—"
end)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false reopen.Visible = true end)
reopen.MouseButton1Click:Connect(function() reopen.Visible = false main.Visible = true end)

task.spawn(function()
    while not St.Destroyed and sg.Parent do
        St.MyLevel = myLevel()
        lvlTile.Text = tostring(St.MyLevel)
        local s = St.Sub
        if #s > 16 then s = string.sub(s, 1, 14)..".." end
        statusTile.Text = s
        task.wait(0.3)
    end
end)
task.spawn(function()
    while not St.Destroyed do
        task.wait(1)
        local mins = (tick() - St.StatStart) / 60
        kLbl.Text = "Kills: "..St.StatKills
        cLbl.Text = "Chests: "..St.StatChests
        tLbl.Text = string.format("Time: %02d:%02d", math.floor(mins), math.floor((mins*60)%60))
        rLbl.Text = "Kills/phút: "..(mins > 0 and string.format("%.1f", St.StatKills/mins) or "0")
    end
end)

main.Size = UDim2.new(0, W, 0, 0)
main.BackgroundTransparency = 1
task.wait(0.1)
tw(main, 0.55, { Size = origSize, BackgroundTransparency = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local wm = mk("ScreenGui", { Name="HL_Watermark", ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=999, Parent=GUI })
local wf = mk("Frame", { Size=UDim2.new(0,230,0,22), Position=UDim2.new(1,-238,0,8), BackgroundColor3=Color3.fromRGB(10,12,20), BackgroundTransparency=0.35, BorderSizePixel=0, Parent=wm })
corner(wf, 6); stroke(wf, T.acc, 1, 0.4)
mk("TextLabel", { Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,5,0,0), BackgroundTransparency=1, Text=AUTHOR.brand.." · Zalo "..AUTHOR.zalo, Font=F.bold, TextSize=10, TextColor3=T.hot, Parent=wf })
end -- UI

--====================================================================================
-- PLAYER MODS
--====================================================================================
conn(S.Run.Stepped, function()
    if St.Destroyed then return end
    if St.NoClip then
        local c = LP.Character
        if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end end
    end
    if St.LockSpeed then
        local h = getHum()
        if h then h.WalkSpeed = math.max(16, tonumber(St.WalkSpeed) or 50) h.UseJumpPower = true h.JumpPower = 90 end
    end
end)
do
    local flyBV, flyBG
    local function flyOff()
        if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
        if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
    end
    conn(S.Run.Heartbeat, function()
        if St.Destroyed then return end
        if not St.Fly then if flyBV then flyOff() end return end
        local r = getRoot() if not r then return end
        if not flyBV or flyBV.Parent ~= r then
            flyOff()
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
            flyBV.Velocity = Vector3.new(0,0,0)
            flyBV.P = 1e4
            flyBV.Parent = r
            flyBG = Instance.new("BodyGyro")
            flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
            flyBG.P = 9e4
            flyBG.Parent = r
            return
        end
        local cam = S.WS.CurrentCamera
        local h = getHum()
        local md = h and h.MoveDirection or Vector3.new(0,0,0)
        local dir = Vector3.new(0,0,0)
        if md.Magnitude > 0 then
            local lv = cam.CFrame:VectorToObjectSpace(md)
            dir = cam.CFrame.LookVector * -lv.Z + cam.CFrame.RightVector * lv.X
        end
        if S.UIS:IsKeyDown(Enum.KeyCode.Space) or (h and h.Jump) then dir = dir + Vector3.new(0,1,0) end
        if S.UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then dir = dir.Unit end
        flyBV.Velocity = dir * St.FlySpeed
        flyBG.CFrame = cam.CFrame
    end)
    conn(S.UIS.JumpRequest, function()
        if not St.InfJump or St.Destroyed then return end
        local h = getHum()
        if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

--====================================================================================
-- BOOT
--====================================================================================
notify(AUTHOR.brand.." "..AUTHOR.version, "Đã load — FIXED FULL EDITION", 8)
print("═══════════════════════════════════════════════════")
print("  "..AUTHOR.brand.." "..AUTHOR.version.." — FIXED FULL")
print("  MADE BY "..AUTHOR.name:upper().." · ZALO "..AUTHOR.zalo)
print("  Sea: "..tostring(SEA or "?"))
print("  CommF_: "..tostring(R.CommF ~= nil))
print("  Attack: "..tostring(R.Attack ~= nil).." · Hit: "..tostring(R.Hit ~= nil))
print("  FIXES:")
print("    · Combat: RegisterHit với danh sách HRPs")
print("    · ESP: Adornee đúng cách")
print("    · Movement: CFrame trực tiếp (bỏ MoveBlock)")
print("    · Bring: BodyPosition force 1e6")
print("    · Quest: đánh đủ → chờ 1.5s → nhận mới")
print("  17 tab UI · 60+ chức năng")
print("═══════════════════════════════════════════════════")--[[====================================================================================
  HOÀNG LÂM HUB v14.0 — MEGA FULL EDITION
  MADE BY HOÀNG LÂM · ZALO 0363194767 · © 2026
  Blox Fruits · Sea 1/2/3 · Delta X / PC / Mobile
  17 TABS · 60+ CHỨC NĂNG · QUEST LOGIC ĐÚNG CƠ CHẾ GAME
====================================================================================]]

if not game:IsLoaded() then game.Loaded:Wait() end
if not getgenv then getgenv = getfenv end

local AUTHOR = { name="Hoàng Lâm", zalo="0363194767", version="v14.0", brand="HOÀNG LÂM HUB" }
local SERVER_URL = "https://keyserver-hchy.onrender.com"
local KEY_FILE = "HL_key.txt"
local CFG_FILE = "HL_config.json"

--====================================================================================
-- KEY SYSTEM
--====================================================================================
do
    local Http = game:GetService("HttpService")
    local LPk = game:GetService("Players").LocalPlayer
    local SGk = game:GetService("StarterGui")
    local GUIk = (gethui and gethui()) or game:GetService("CoreGui")
    local function notifyk(t,x,d) pcall(function() SGk:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 5}) end) end
    local function enc(s) return (tostring(s):gsub("([^%w%-_%.~])", function(c) return string.format("%%%02X", string.byte(c)) end)) end
    local function httpGet(url)
        local ok, b = pcall(function() return game:HttpGet(url) end)
        if ok and b and b ~= "" then return b end
        local req = request or http_request or (syn and syn.request)
        if req then
            local ok2, res = pcall(req,{Url=url,Method="GET"})
            if ok2 and res then
                if type(res) == "table" and res.Body then return res.Body end
                if type(res) == "string" then return res end
            end
        end
        return nil
    end
    local function hwidf()
        local ok, r = pcall(function() if gethwid then return gethwid() end end)
        if ok and r then
            if type(r) == "table" then r = r[1] or r[2] or "" end
            r = tostring(r):gsub("%s+","")
            if #r >= 3 then return r end
        end
        return "UID_" .. tostring(LPk and LPk.UserId or 0)
    end
    local HWID = hwidf()
    local function api(path)
        local body = httpGet(SERVER_URL .. path)
        if not body then return nil, "Không kết nối server key." end
        local ok, d = pcall(function() return Http:JSONDecode(body) end)
        if not ok or type(d) ~= "table" then return nil, "Server trả sai định dạng." end
        return d
    end
    local REASON = { expired="Key hết hạn.", wrong_hwid="Key thuộc máy khác.", not_found="Key không đúng.", missing="Thiếu key." }
    local function verify(key)
        key = (tostring(key or ""):gsub("%s+","")):upper()
        if key == "" then return false, "Chưa nhập key." end
        local d, err = api("/api/verify?key="..enc(key).."&hwid="..enc(HWID))
        if not d then return false, err end
        if d.status == "success" and d.valid == true then return true end
        return false, REASON[d.reason] or "Key không hợp lệ."
    end
    local function saveK(k) pcall(function() if writefile then writefile(KEY_FILE, tostring(k):gsub("%s+","")) end end) end
    local function clearK() pcall(function() if delfile and isfile and isfile(KEY_FILE) then delfile(KEY_FILE) end end) end
    local PASSED = false
    do
        local s
        pcall(function()
            if isfile and isfile(KEY_FILE) and readfile then s = tostring(readfile(KEY_FILE) or ""):gsub("%s+","") end
        end)
        if s and s ~= "" then
            if verify(s) then PASSED = true notifyk(AUTHOR.brand, "Key còn hạn ✔") else clearK() end
        end
    end
    if not PASSED then
        local Tk = { bg0=Color3.fromRGB(6,8,14), bg1=Color3.fromRGB(12,15,24), bg2=Color3.fromRGB(18,22,34), bg3=Color3.fromRGB(26,32,48), txt=Color3.fromRGB(240,244,255), dim=Color3.fromRGB(150,160,185), fnt=Color3.fromRGB(78,88,112), acc=Color3.fromRGB(255,200,90), hot=Color3.fromRGB(255,230,160), ok=Color3.fromRGB(72,235,168), bad=Color3.fromRGB(255,100,115) }
        local Fk = { black=Enum.Font.GothamBlack, bold=Enum.Font.GothamBold, reg=Enum.Font.Gotham, mono=Enum.Font.Code }
        local function mkk(c,p) local o=Instance.new(c) for k,v in pairs(p) do if k~="Parent" then pcall(function() o[k]=v end) end end o.Parent=p.Parent return o end
        local function cork(o,r) mkk("UICorner",{CornerRadius=UDim.new(0,r or 8),Parent=o}) end
        local function strok(o,c,t,tr) mkk("UIStroke",{Color=c or Tk.acc,Thickness=t or 1,Transparency=tr or 0.4,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=o}) end
        local sgk = mkk("ScreenGui",{Name="HL_KeyUI",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=GUIk})
        local Wk,Hk = 400,540
        local maink = mkk("Frame",{Size=UDim2.new(0,Wk,0,Hk),Position=UDim2.new(0.5,-Wk/2,0.5,-Hk/2),BackgroundColor3=Tk.bg0,BorderSizePixel=0,Active=true,Draggable=true,Parent=sgk})
        cork(maink,18); strok(maink,Tk.acc,1.2,0.5)
        mkk("Frame",{Size=UDim2.new(1,-36,0,2),Position=UDim2.new(0,18,0,0),BackgroundColor3=Tk.acc,BorderSizePixel=0,Parent=maink})
        local logok = mkk("Frame",{Size=UDim2.new(0,58,0,58),Position=UDim2.new(0,28,0,26),BackgroundColor3=Tk.bg3,BorderSizePixel=0,Parent=maink})
        cork(logok,999); strok(logok,Tk.acc,1.5,0.3)
        mkk("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="HL",Font=Fk.black,TextSize=24,TextColor3=Tk.hot,Parent=logok})
        mkk("TextLabel",{Size=UDim2.new(0,280,0,26),Position=UDim2.new(0,100,0,30),BackgroundTransparency=1,Text=AUTHOR.brand.." "..AUTHOR.version,Font=Fk.black,TextSize=20,TextColor3=Tk.txt,TextXAlignment=Enum.TextXAlignment.Left,Parent=maink})
        mkk("TextLabel",{Size=UDim2.new(0,280,0,16),Position=UDim2.new(0,100,0,58),BackgroundTransparency=1,Text="MADE BY "..AUTHOR.name:upper().." · ZALO "..AUTHOR.zalo,Font=Fk.reg,TextSize=10,TextColor3=Tk.fnt,TextXAlignment=Enum.TextXAlignment.Left,Parent=maink})
        local statusk = mkk("TextLabel",{Size=UDim2.new(1,-56,0,44),Position=UDim2.new(0,28,0,100),BackgroundTransparency=1,Text="Dán key để sử dụng.",Font=Fk.reg,TextSize=12,TextColor3=Tk.dim,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,Parent=maink})
        local function setStatk(s,c) statusk.Text=s statusk.TextColor3=c or Tk.dim end
        mkk("TextLabel",{Size=UDim2.new(1,-56,0,14),Position=UDim2.new(0,28,0,148),BackgroundTransparency=1,Text="YOUR KEY",Font=Fk.bold,TextSize=10,TextColor3=Tk.fnt,TextXAlignment=Enum.TextXAlignment.Left,Parent=maink})
        local keyBoxk = mkk("TextBox",{Size=UDim2.new(1,-56,0,46),Position=UDim2.new(0,28,0,166),BackgroundColor3=Tk.bg2,BorderSizePixel=0,PlaceholderText="HL-XXXX-XXXX-XXXX",PlaceholderColor3=Tk.fnt,Text="",Font=Fk.mono,TextSize=14,TextColor3=Tk.hot,ClearTextOnFocus=false,Parent=maink})
        cork(keyBoxk,10); strok(keyBoxk,Tk.acc,1,0.6)
        local function btnk(txt,y,bg)
            local b=mkk("TextButton",{Size=UDim2.new(1,-56,0,46),Position=UDim2.new(0,28,0,y),BackgroundColor3=bg,BorderSizePixel=0,Text=txt,Font=Fk.black,TextSize=14,TextColor3=Color3.new(1,1,1),Parent=maink})
            cork(b,11) return b
        end
        local verifyBtnk = btnk("✔  VERIFY KEY",226,Color3.fromRGB(30,120,88))
        mkk("TextLabel",{Size=UDim2.new(1,-56,0,16),Position=UDim2.new(0,28,0,284),BackgroundTransparency=1,Text="— CHƯA CÓ KEY? —",Font=Fk.bold,TextSize=10,TextColor3=Tk.fnt,Parent=maink})
        local getBtnk = btnk("📋  GET KEY (COPY LINK)",306,Color3.fromRGB(40,92,148))
        local buyBtnk = btnk("💰  MUA KEY (ZALO)",356,Color3.fromRGB(150,100,30))
        local linkBoxk = mkk("TextBox",{Size=UDim2.new(1,-56,0,60),Position=UDim2.new(0,28,0,412),BackgroundColor3=Tk.bg1,BorderSizePixel=0,Text="Link vượt sẽ hiện ở đây.",Font=Fk.mono,TextSize=11,TextColor3=Tk.dim,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,ClearTextOnFocus=false,Parent=maink})
        cork(linkBoxk,10)
        mkk("TextLabel",{Size=UDim2.new(1,-56,0,40),Position=UDim2.new(0,28,0,480),BackgroundTransparency=1,Text="© 2026 "..AUTHOR.name.." · Zalo "..AUTHOR.zalo,Font=Fk.reg,TextSize=10,TextColor3=Tk.fnt,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=maink})
        getBtnk.MouseButton1Click:Connect(function()
            setStatk("Đang tạo link...",Tk.dim)
            local d, err = api("/api/getlink?hwid="..enc(HWID))
            if not d then setStatk("✘ "..tostring(err),Tk.bad) return end
            if d.status == "success" and d.link then
                linkBoxk.Text = d.link
                pcall(function() if setclipboard then setclipboard(d.link) end end)
                setStatk("✔ Đã COPY link.",Tk.ok)
            else setStatk("✘ "..tostring(d.message or "Lỗi."),Tk.bad) end
        end)
        buyBtnk.MouseButton1Click:Connect(function()
            setStatk("Liên hệ Zalo "..AUTHOR.zalo,Tk.hot)
            pcall(function() if setclipboard then setclipboard(AUTHOR.zalo) end end)
        end)
        verifyBtnk.MouseButton1Click:Connect(function()
            setStatk("Đang kiểm tra...",Tk.dim)
            local ok, info = verify(keyBoxk.Text)
            if ok then
                saveK(keyBoxk.Text)
                setStatk("✔ Key hợp lệ!",Tk.ok)
                notifyk(AUTHOR.brand,"Key hợp lệ ✔")
                task.wait(0.6)
                sgk:Destroy()
                PASSED = true
            else setStatk("✘ "..tostring(info),Tk.bad) end
        end)
        while not PASSED do task.wait(0.15) end
    end
end

--====================================================================================
-- CORE
--====================================================================================
local S = {
    Players=game:GetService("Players"), Run=game:GetService("RunService"),
    Tween=game:GetService("TweenService"), UIS=game:GetService("UserInputService"),
    RS=game:GetService("ReplicatedStorage"), WS=game:GetService("Workspace"),
    Light=game:GetService("Lighting"), TP=game:GetService("TeleportService"),
    Http=game:GetService("HttpService"), VU=game:GetService("VirtualUser"),
    SG=game:GetService("StarterGui"), CG=game:GetService("CoreGui"),
}
local LP = S.Players.LocalPlayer
local GUI = (gethui and gethui()) or S.CG
local MOBILE = S.UIS.TouchEnabled and not S.UIS.MouseEnabled
local VP = S.WS.CurrentCamera.ViewportSize

if not firetouchinterest then firetouchinterest = function() end end
if not fireclickdetector then fireclickdetector = function() end end

pcall(function()
    for _, g in ipairs(GUI:GetChildren()) do
        if g.Name == "HL_Hub" or g.Name == "HL_Watermark" or g.Name == "HL_KeyUI" or g.Name == "HL_FOV" then g:Destroy() end
    end
    local old = S.WS:FindFirstChild("HL_MoveBlock")
    if old then old:Destroy() end
end)

local UNPACK = table.unpack or unpack
local function notify(t,x,d) pcall(function() S.SG:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 4}) end) end
local CONN = {}
local function conn(sig, fn) local c = sig:Connect(fn) CONN[#CONN+1] = c return c end

local R = {}
do
    local rm = S.RS:FindFirstChild("Remotes") or S.RS:FindFirstChild("Remote")
    if rm then
        R.CommF = rm:FindFirstChild("CommF_") or rm:FindFirstChild("CommF")
        R.Raids = rm:FindFirstChild("Raids")
        R.Btn = rm:FindFirstChild("ButtonEnabler")
    end
    local md = S.RS:FindFirstChild("Modules")
    if md then
        local net = md:FindFirstChild("Net")
        if net then
            R.Attack = net:FindFirstChild("RE/RegisterAttack")
            R.Hit = net:FindFirstChild("RE/RegisterHit")
        end
    end
end
local function Invoke(...)
    if not R.CommF then return nil end
    local a = {...}
    local ok, r = pcall(function() return R.CommF:InvokeServer(UNPACK(a)) end)
    return ok and r or nil
end

local function getRoot() local c=LP.Character return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso")) end
local function getHum() local c=LP.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function pos() local r=getRoot() return r and r.Position or Vector3.new(0,0,0) end
local function dist(a,b) return (a-b).Magnitude end
local function myLevel()
    local d = LP:FindFirstChild("Data")
    if d and d:FindFirstChild("Level") then return tonumber(d.Level.Value) or 1 end
    local ls = LP:FindFirstChild("leaderstats")
    if ls and ls:FindFirstChild("Level") then return tonumber(ls.Level.Value) or 1 end
    return 1
end
local SEA
do
    local id = game.PlaceId
    if id == 2753915549 or id == 9792993051 then SEA = 1
    elseif id == 4442272183 or id == 79091703265657 then SEA = 2
    elseif id == 7449423635 or id == 100117331123089 then SEA = 3 end
end

--====================================================================================
-- MOVEMENT
--====================================================================================
local MOVE = { Active=false, Target=nil, Speed=300 }
local function stopMoving()
    MOVE.Active = false MOVE.Target = nil
    local c = LP.Character
    if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
end
local function moveTo(targetPos, sp)
    if typeof(targetPos) == "CFrame" then targetPos = targetPos.Position end
    MOVE.Target = targetPos MOVE.Speed = sp or MOVE.Speed MOVE.Active = true
end
local function teleportTo(targetPos)
    if typeof(targetPos) == "CFrame" then targetPos = targetPos.Position end
    local hrp = getRoot() if not hrp then return end
    MOVE.Active = false
    hrp.CFrame = CFrame.new(targetPos)
end
conn(S.Run.Heartbeat, function()
    if not MOVE.Active or not MOVE.Target then return end
    local hrp = getRoot() if not hrp then return end
    local cur = hrp.Position
    local dir = MOVE.Target - cur
    local d = dir.Magnitude
    if d < 4 then MOVE.Active = false MOVE.Target = nil return end
    local c = LP.Character
    if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    local step = math.min(MOVE.Speed * (1/60), d)
    local np = cur + dir.Unit * step
    hrp.CFrame = CFrame.new(np, np + dir.Unit)
    hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
end)

--====================================================================================
-- DATA
--====================================================================================
local D = {}
D.CHEAP = {"Rocket-Rocket","Spin-Spin","Blade-Blade","Chop-Chop","Spring-Spring","Bomb-Bomb","Smoke-Smoke","Spike-Spike","Flame-Flame","Ice-Ice","Sand-Sand","Dark-Dark","Diamond-Diamond","Light-Light","Rubber-Rubber","Ghost-Ghost","Revive-Revive","Magma-Magma"}
D.BOSSES = {
    [1]={"The Gorilla King","Bobby","Yeti","Mob Leader","Vice Admiral","Saber Expert"},
    [2]={"Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Ice Admiral","Ghost Captain","Don Swan","Smoke Admiral","Cursed Captain","Darkbeard","Order","Diamond","Jeremy","Fajita","Kilo Admiral","Captain Elephant","Beautiful Pirate","Longma","Hydra Leader","Trial of God"},
    [3]={"Stone","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate","Longma","Trial of God","Cake Queen","Cursed Captain","Soul Reaper","Dough King","Rip_indra","Ope","Cursed Skeleton"},
}
D.MOBS = {
    [1]={"Bandit","Monkey","Gorilla","Pirate","Brute","Desert Bandit","Desert Officer","Snow Bandit","Snowman","Chief Petty Officer","Sky Bandit","Dark Master","Prisoner","Dangerous Prisoner","Toga Warrior","Gladiator","Military Soldier","Military Spy","Fishman Warrior","Fishman Commando","God's Guard","Shanda","Royal Squad","Royal Soldier","Galley Pirate","Galley Captain"},
    [2]={"Raider","Mercenary","Swan Pirate","Factory Staff","Marine Lieutenant","Marine Captain","Zombie","Vampire","Snow Trooper","Winter Warrior","Lab Subordinate","Horned Warrior","Magma Ninja","Lava Pirate","Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter"},
    [3]={"Pirate Millionaire","Pistol Billionaire","Dragon Crew Warrior","Dragon Crew Archer","Hydra Enforcer","Venomous Assailant","Marine Commodore","Marine Rear Admiral","Fishman Raider","Fishman Captain","Forest Pirate","Jungle Pirate","Musketeer Pirate","Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy","Peanut Scout","Peanut President","Ice Cream Chef","Ice Cream Commander","Cookie Crafter","Cake Guard","Baking Staff","Head Baker","Cocoa Warrior","Chocolate Bar Battler","Sweet Thief","Candy Rebel","Candy Pirate","Snow Demon","Isle Outlaw","Island Boy","Isle Champion","Skull Slayer","Reef Bandit","Coral Pirate","Sea Chanter","Ocean Prophet","High Disciple","Grand Devotee"},
}
D.MOB_DISPLAY = { ["God's Guard"] = "Sky Guards" }
local function dn(n) return D.MOB_DISPLAY[n] or n end

do
    local FR = {
        {"Rocket-Rocket",0,5000},{"Spin-Spin",0,7500},{"Blade-Blade",0,30000},{"Spring-Spring",0,60000},
        {"Bomb-Bomb",0,80000},{"Smoke-Smoke",0,100000},{"Spike-Spike",0,180000},{"Flame-Flame",1,250000},
        {"Ice-Ice",1,350000},{"Sand-Sand",1,420000},{"Dark-Dark",1,500000},{"Eagle-Eagle",1,550000},
        {"Diamond-Diamond",1,600000},{"Falcon-Falcon",1,650000},{"Light-Light",2,650000},{"Rubber-Rubber",2,750000},
        {"Ghost-Ghost",2,940000},{"Magma-Magma",2,960000},{"Door-Door",2,950000},{"Chop-Chop",2,1000000},
        {"Quake-Quake",3,1000000},{"Buddha-Buddha",3,1200000},{"Love-Love",3,1300000},{"Creation-Creation",3,1400000},
        {"Spider-Spider",3,1500000},{"Sound-Sound",3,1700000},{"Phoenix-Phoenix",3,1800000},{"Portal-Portal",3,1900000},
        {"Rumble-Rumble",3,2100000},{"Pain-Pain",3,2300000},{"Blizzard-Blizzard",3,2400000},{"Gravity-Gravity",4,2500000},
        {"Mammoth-Mammoth",4,2700000},{"T-Rex-T-Rex",4,2700000},{"Dough-Dough",4,2800000},{"Shadow-Shadow",4,2900000},
        {"Venom-Venom",4,3000000},{"Gas-Gas",4,3200000},{"Spirit-Spirit",4,3400000},{"Control-Control",4,9000000},
        {"Yeti-Yeti",4,5000000},{"Leopard-Leopard",4,5000000},{"Kitsune-Kitsune",4,8000000},{"Dragon-Dragon",4,15000000},
        {"Dragon-West",4,15000000},{"Dragon-East",4,15000000},{"Magnet-Magnet",4,0},
    }
    D.FRUITS = {} D.FRUIT_BY_KEY = {}
    for _, f in ipairs(FR) do
        local e = { name=f[1], rarity=f[2], price=f[3] }
        D.FRUITS[#D.FRUITS+1] = e
        D.FRUIT_BY_KEY[f[1]] = e
        D.FRUIT_BY_KEY[f[1]:match("^([^%-]+)") or f[1]] = e
    end
end
local function fruitInfo(n) if not n then return nil end return D.FRUIT_BY_KEY[n] or D.FRUIT_BY_KEY[tostring(n):match("^([^%-]+)") or ""] end
local function fruitRarity(n) local e = fruitInfo(n) return e and e.rarity or 0 end
local function fruitPrice(n) local e = fruitInfo(n) return e and e.price or 0 end

local Q = {
    {9,"Bandit",1059,15,1550,"BanditQuest1",1},{14,"Monkey",-1598,36,153,"JungleQuest",1},
    {29,"Gorilla",-1598,36,153,"JungleQuest",2},{44,"Pirate",-1141,4,3831,"BuggyQuest1",1},
    {59,"Brute",-1141,4,3831,"BuggyQuest1",2},{74,"Desert Bandit",894,5,4392,"DesertQuest",1},
    {89,"Desert Officer",894,5,4392,"DesertQuest",2},{99,"Snow Bandit",1389,88,-1298,"SnowQuest",1},
    {119,"Snowman",1389,88,-1298,"SnowQuest",2},{149,"Chief Petty Officer",-5039,27,4324,"MarineQuest2",1},
    {174,"Sky Bandit",-4839,716,-2619,"SkyQuest",1},{189,"Dark Master",-4839,716,-2619,"SkyQuest",2},
    {209,"Prisoner",5308,1,475,"PrisonerQuest",1},{249,"Dangerous Prisoner",5308,1,475,"PrisonerQuest",2},
    {274,"Toga Warrior",-1580,6,-2986,"ColosseumQuest",1},{299,"Gladiator",-1580,6,-2986,"ColosseumQuest",2},
    {324,"Military Soldier",-5313,10,8515,"MagmaQuest",1},{374,"Military Spy",-5313,10,8515,"MagmaQuest",2},
    {399,"Fishman Warrior",61122,18,1569,"FishmanQuest",1},{449,"Fishman Commando",61122,18,1569,"FishmanQuest",2},
    {474,"God's Guard",-4721,843,-1949,"SkyExp1Quest",1},{524,"Shanda",-7859,5544,-381,"SkyExp1Quest",2},
    {549,"Royal Squad",-7906,5634,-1411,"SkyExp2Quest",1},{624,"Royal Soldier",-7906,5634,-1411,"SkyExp2Quest",2},
    {649,"Galley Pirate",5259,37,4050,"FountainQuest",1},{699,"Galley Captain",5259,37,4050,"FountainQuest",2},
    {724,"Raider",-429,71,1836,"Area1Quest",1},{774,"Mercenary",-429,71,1836,"Area1Quest",2},
    {799,"Swan Pirate",638,71,918,"Area2Quest",1},{874,"Factory Staff",632,73,918,"Area2Quest",2},
    {899,"Marine Lieutenant",-2440,71,-3216,"MarineQuest3",1},{949,"Marine Captain",-2440,71,-3216,"MarineQuest3",2},
    {974,"Zombie",-5497,47,-795,"ZombieQuest",1},{999,"Vampire",-5497,47,-795,"ZombieQuest",2},
    {1049,"Snow Trooper",609,400,-5372,"SnowMountainQuest",1},{1099,"Winter Warrior",609,400,-5372,"SnowMountainQuest",2},
    {1124,"Lab Subordinate",-6064,15,-4902,"IceSideQuest",1},{1174,"Horned Warrior",-6064,15,-4902,"IceSideQuest",2},
    {1199,"Magma Ninja",-5428,15,-5299,"FireSideQuest",1},{1249,"Lava Pirate",-5428,15,-5299,"FireSideQuest",2},
    {1274,"Ship Deckhand",1037,125,32911,"ShipQuest1",1},{1299,"Ship Engineer",1037,125,32911,"ShipQuest1",2},
    {1324,"Ship Steward",968,125,33244,"ShipQuest2",1},{1349,"Ship Officer",968,125,33244,"ShipQuest2",2},
    {1374,"Arctic Warrior",5667,26,-6486,"FrostQuest",1},{1424,"Snow Lurker",5667,26,-6486,"FrostQuest",2},
    {1449,"Sea Soldier",-3054,235,-10142,"ForgottenQuest",1},{1499,"Water Fighter",-3054,240,-10146,"ForgottenQuest",2},
    {1524,"Pirate Millionaire",-290,42,5581,"PiratePortQuest",1},{1574,"Pistol Billionaire",-290,42,5581,"PiratePortQuest",2},
    {1599,"Dragon Crew Warrior",6738,127,-713,"DragonCrewQuest",1},{1624,"Dragon Crew Archer",6738,127,-713,"DragonCrewQuest",2},
    {1649,"Hydra Enforcer",5213,1004,758,"VenomCrewQuest",1},{1699,"Venomous Assailant",5213,1004,758,"VenomCrewQuest",2},
    {1724,"Marine Commodore",2180,27,-6741,"MarineTreeIsland",1},{1774,"Marine Rear Admiral",2179,28,-6740,"MarineTreeIsland",2},
    {1799,"Fishman Raider",3142,108,7482,"DeepForestIsland3",1},{1824,"Fishman Captain",3142,108,7482,"DeepForestIsland3",2},
    {1849,"Forest Pirate",-13234,331,-7625,"DeepForestIsland",1},{1899,"Jungle Pirate",-13234,331,-7625,"DeepForestIsland",2},
    {1924,"Jungle Pirate",-12680,389,-9902,"DeepForestIsland2",1},{1974,"Musketeer Pirate",-12680,389,-9902,"DeepForestIsland2",2},
    {1999,"Reborn Skeleton",-9479,141,5566,"HauntedQuest1",1},{2024,"Living Zombie",-9479,141,5566,"HauntedQuest1",2},
    {2049,"Demonic Soul",-9516,172,6078,"HauntedQuest2",1},{2074,"Posessed Mummy",-9516,172,6078,"HauntedQuest2",2},
    {2099,"Peanut Scout",-2104,38,-10194,"NutsIslandQuest",1},{2124,"Peanut President",-2104,38,-10194,"NutsIslandQuest",2},
    {2149,"Ice Cream Chef",-820,65,-10965,"IceCreamIslandQuest",1},{2199,"Ice Cream Commander",-820,65,-10965,"IceCreamIslandQuest",2},
    {2224,"Cookie Crafter",-2021,37,-12028,"CakeQuest1",1},{2249,"Cake Guard",-2021,37,-12028,"CakeQuest1",2},
    {2274,"Baking Staff",-1927,37,-12842,"CakeQuest2",1},{2299,"Head Baker",-1927,37,-12842,"CakeQuest2",2},
    {2324,"Cocoa Warrior",233,29,-12201,"ChocQuest1",1},{2349,"Chocolate Bar Battler",233,29,-12201,"ChocQuest1",2},
    {2374,"Sweet Thief",150,30,-12774,"ChocQuest2",1},{2399,"Candy Rebel",150,30,-12774,"ChocQuest2",2},
    {2424,"Candy Pirate",-1150,20,-14446,"CandyQuest1",1},{2449,"Snow Demon",-1150,20,-14446,"CandyQuest1",2},
    {2474,"Isle Outlaw",-16547,61,-173,"TikiQuest1",1},{2524,"Island Boy",-16547,61,-173,"TikiQuest1",2},
    {2574,"Isle Champion",-16539,55,1051,"TikiQuest2",1},{2599,"Skull Slayer",-16665,104,1579,"TikiQuest3",2},
    {2624,"Reef Bandit",10778,-2087,9265,"SubmergedQuest1",1},{2649,"Coral Pirate",10778,-2087,9265,"SubmergedQuest1",2},
    {2674,"Sea Chanter",10880,-2086,10032,"SubmergedQuest2",1},{2699,"Ocean Prophet",10880,-2086,10032,"SubmergedQuest2",2},
    {2719,"High Disciple",9640,-1992,9613,"SubmergedQuest3",1},{99999,"Grand Devotee",9640,-1992,9613,"SubmergedQuest3",2},
}
local function pickTarget(lv)
    for _, r in ipairs(Q) do if lv <= r[1] then return r end end
    return Q[#Q]
end

--====================================================================================
-- STATE
--====================================================================================
local St = {
    AutoFarm=false, AutoRaid=false, AutoBoss=false, AutoChest=false,
    AutoNearest=false, AutoSpecific=false, AutoDungeon=false, AutoMagnet=false,
    AutoQuest=true, AutoHaki=true, BringMobs=true, BringRange=350, BringRate=0.12,
    AutoEquip=true, EquipType="Melee", AttackRange=70, Hover=22,
    Speed=300, FarTP=false, AtkDelay=0.05, AtkBurst=1, LoopDelay=0.05,
    SafeMode=false, SafeHP=30,
    AutoSkill=true, SkillTime={Z=0,X=0,C=0}, SkillCD={Z=0.7,X=1.2,C=3},
    AutoStats=false, StatType="Melee",
    AntiStuck=true, StuckTime=0, LastPos=Vector3.new(0,0,0), MobTimeout=5,
    AutoBuyHaki=false, AutoBuyChip=false, AutoClearRaid=false, RaidChip="Flame",
    NoClip=false, InfJump=false, Fly=false, FlySpeed=120, LockSpeed=false, WalkSpeed=50,
    FruitSniper=false, FruitMinRarity=2, FruitBring=false, FruitNotify=false,
    AutoStoreFruit=false, StoreMinRarity=2, LastStoreFruit=0,
    LastFruitScan=0, FruitCache={}, NotifiedFruits={}, LastFruit=0, LastChest=0,
    ESPPlayers=false, ESPMobs=false, ESPBoss=false, ESPChests=false, ESPFruits=false, ESPRange=1500,
    HopPingMax=200, HopVisited={},
    Sub="Idle", MyLevel=1, QuestLv=-1, QuestCur=0, QuestMax=0,
    CurrentMobName=nil, LastQuestTry=0, QuestCompletedAt=0,
    Attacking=false, LastAttack=0, TargetName=nil, StuckCheck=0,
    HakiTry=0, HakiBuyTry=0, EquipTry=0, BossSeen=nil, BossKillLog={},
    LastChipBuy=0, LastSummonTry=0, RaidAttempts=0,
    Panic=false, Running=false, Orig={}, Destroyed=false,
    Lang="VN", Theme="Gold", Profile="Default",
    AutoBones=false, AutoDough=false, AutoElite=false, AutoEcto=false,
    AutoMastery=false, AutoMaterials=false, RegionFarm=false, RegionName="Sea 1 - Bandit",
    Aimbot=false, AimbotFOV=250, AimbotSmooth=0.25, FastMode="Normal",
    KillAura=false, AuraRange=60,
    AutoBuyGeppo=false, AutoBuySoru=false, AutoBuyKen=false, AutoRedeem=false, Redeemed=false,
    PlayerAlert=false, AlertRange=300, AutoRejoin=false,
    TimerMin=0, TimerStart=0, DiscordURL="",
    FruitSniperName="", AwakenFruit="", AutoAwaken=false, RaceV4=false,
    AutoDarkbeard=false, AutoOrder=false, AutoRipIndra=false,
    AutoSeaBeast=false, AutoSeaEvent=false,
    BossTimers={}, StatKills=0, StatChests=0, StatFruits=0, StatStart=tick(),
    RollMin=2, RollAuto=false, StoreNames={}, AlertedPlayers={},
    LastAura=0, LastRoll=0, LastStoreName=0, LastSniper=0, LastAwake=0,
    _lastEnemyCount=0, _lastBossSeen={},
    -- v14 extensions
    AutoFish=false, AutoBuyBait=false, AutoSellFish=false, AutoFishQuest=false, HasBait=false,
    MasteryTarget="Melee",
    AutoSpecialQuest=false, SpecialQuest="Saber", AutoCompleteQuest=false,
    AutoFactoryRaid=false, AutoPirateRaid=false, AutoHakiPad=false,
    AutoRipIndraAttack=false, AutoSoulReaper=false, AutoDoughKing=false,
    AutoGachaMagnet=false, AutoMagnetEvent=false, TryLuckyGrave=false,
    SilentAim=false, SilentAimPlayer=false, Tracer=false, TargetLowestHP=false, FovCircle=false,
    WaterWalk=false, BypassSpeed=false, BypassSpeedMul=1.5,
    AutoBerry=false, AutoCollectHop=false,
    IslandTP=false, IslandName="Starter Island",
    AntiAFK=true,
    _fovCircle=nil, _hlPvP=nil,
    LastGrave=0, LastGacha=0,
}
local GUI_State = { SelectedBoss="The Gorilla King", SelectedMob="Bandit" }

local function anyMode()
    return St.AutoFarm or St.AutoRaid or St.AutoBoss or St.AutoChest or St.AutoNearest
        or St.AutoSpecific or St.AutoDungeon or St.AutoMagnet
        or St.AutoBones or St.AutoDough or St.AutoElite or St.AutoEcto
        or St.AutoMastery or St.AutoMaterials or St.RegionFarm
        or St.AutoDarkbeard or St.AutoOrder or St.AutoRipIndra
        or St.AutoSeaBeast or St.AutoSeaEvent or St.RaceV4
        or St.AutoFish or St.AutoSpecialQuest
        or St.AutoFactoryRaid or St.AutoPirateRaid or St.AutoHakiPad
        or St.AutoRipIndraAttack or St.AutoSoulReaper or St.AutoDoughKing
        or St.AutoGachaMagnet or St.AutoMagnetEvent or St.TryLuckyGrave
        or St.AutoCompleteQuest or St.AutoBerry or St.AutoCollectHop
end

--====================================================================================
-- ENEMIES
--====================================================================================
local EN = { list={}, t=0 }
local function enemies()
    local now = tick()
    if now - EN.t > 0.08 then
        EN.t = now
        local out = {}
        local f = S.WS:FindFirstChild("Enemies")
        if f then
            for _, e in ipairs(f:GetChildren()) do
                local h = e:FindFirstChildOfClass("Humanoid")
                local r = e:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then out[#out+1] = { m=e, h=h, r=r } end
            end
        end
        EN.list = out
    end
    return EN.list
end

--====================================================================================
-- QUEST DETECTION
--====================================================================================
local function getQuestInfo()
    local pg = LP:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local main = pg:FindFirstChild("Main")
    if not main then return nil end
    local quest = main:FindFirstChild("Quest")
    if not quest or not quest.Visible then return nil end
    local container = quest:FindFirstChild("Container")
    if container then
        local qt = container:FindFirstChild("QuestTitle")
        if qt then
            local lbl = qt:FindFirstChild("Title")
            if lbl then
                local text = lbl.Text or ""
                local cur, max = text:match("%((%d+)%s*/%s*(%d+)%)")
                if cur and max then return { cur=tonumber(cur), max=tonumber(max), title=text } end
                local c2, m2 = text:match("(%d+)%s*/%s*(%d+)")
                if c2 and m2 then return { cur=tonumber(c2), max=tonumber(m2), title=text } end
                return { cur=0, max=1, title=text }
            end
        end
    end
    for _, d in ipairs(quest:GetDescendants()) do
        if d:IsA("TextLabel") and d.Text:find("/") then
            local c, m = d.Text:match("(%d+)%s*/%s*(%d+)")
            if c and m then return { cur=tonumber(c), max=tonumber(m), title=d.Text } end
        end
    end
    return nil
end
local function questMatchesMob(qt, mn)
    if not qt or not mn then return false end
    local function norm(s) s=s:lower() s=s:gsub("'",""):gsub("'","") return s end
    local q=norm(qt) local m=norm(mn)
    if q:find(m,1,true) then return true end
    for w in m:gmatch("%S+") do if #w>3 and q:find(w,1,true) then return true end end
    return false
end
local function getQuestRowFromTitle(title)
    if not title then return nil end
    for _, r in ipairs(Q) do if questMatchesMob(title, r[2]) then return r end end
    return nil
end
local function tryAcceptQuest(row)
    local hrp = getRoot() if not hrp then return false end
    local gp = Vector3.new(row[3], row[4], row[5])
    local d = dist(hrp.Position, gp)
    if d > 35 then
        St.Sub = "→ NPC "..row[6]
        if d > 400 then teleportTo(gp + Vector3.new(0,5,3)) task.wait(0.2)
        else moveTo(gp + Vector3.new(0,5,3), 400) end
        return false
    end
    stopMoving()
    St.Sub = "Nhận quest: "..row[6]
    pcall(function() R.CommF:InvokeServer("StartQuest", row[6], row[7]) end)
    St.LastQuestTry = tick()
    task.wait(0.5)
    return true
end

--====================================================================================
-- COMBAT
--====================================================================================
local function doAttack()
    if not R.Attack or not R.Hit then return end
    local hrp = getRoot() if not hrp then return end
    local range = St.AttackRange + (MOBILE and 15 or 0)
    local first
    local list = {}
    for _, e in ipairs(enemies()) do
        if e.r.Parent and e.h.Health > 0 then
            local head = e.m:FindFirstChild("Head")
            local d1 = dist(e.r.Position, hrp.Position)
            local d2 = head and dist(head.Position, hrp.Position) or math.huge
            if d1 <= range or d2 <= range then
                if head and not first then first = head end
                list[#list+1] = { e.m, e.r }
                list[#list+1] = e.m
            end
        end
    end
    if #list == 0 then return end
    St.LastAttack = tick()
    pcall(function()
        R.Attack:FireServer(0)
        R.Hit:FireServer(first, list, nil, "")
    end)
end
local function autoSkillTick()
    if not St.AutoSkill then return end
    if tick() - St.LastAttack > 1.5 then return end
    local c = LP.Character if not c then return end
    local tool
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") and t:FindFirstChild("RemoteFunction") then tool = t break end
    end
    if not tool then return end
    local rf = tool.RemoteFunction
    local now = tick()
    for _, k in ipairs({"Z","X","C"}) do
        if now - (St.SkillTime[k] or 0) >= (St.SkillCD[k] or 1) then
            St.SkillTime[k] = now
            task.spawn(function() pcall(function() rf:InvokeServer(k) end) end)
        end
    end
end
local function bringMobs(rangeOverride)
    local hrp = getRoot() if not hrp then return end
    local range = rangeOverride or St.BringRange
    local tgt = Vector3.new(hrp.Position.X, hrp.Position.Y - St.Hover, hrp.Position.Z)
    local mobName = St.CurrentMobName
    for _, e in ipairs(enemies()) do
        if e.h.Health > 0 and e.r.Parent and dist(e.r.Position, hrp.Position) <= range
            and (not mobName or e.m.Name == mobName) then
            local bp = e.r:FindFirstChild("HL_Bring")
            if not bp then
                bp = Instance.new("BodyPosition")
                bp.Name = "HL_Bring"
                bp.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                bp.P = 30000
                bp.D = 800
                bp.Parent = e.r
            end
            bp.Position = tgt
        end
    end
end
local function cleanBring()
    local f = S.WS:FindFirstChild("Enemies")
    if not f then return end
    for _, m in ipairs(f:GetChildren()) do
        local r = m:FindFirstChild("HumanoidRootPart")
        local bp = r and r:FindFirstChild("HL_Bring")
        if bp then bp:Destroy() end
    end
end

--====================================================================================
-- WEAPON
--====================================================================================
local WPN = { Sword={}, Melee={}, Gun={} }
for n in ("cutlass,katana,iron mace,dual katana,triple katana,dark blade,yoru,wando,shisui,saddi,koko,tushita,bisento,pole,trident,true triple katana,cursed dual katana,dark dagger,buddy sword,dragon heart,canvander,rengoku,spikey trident,midnight blade,hallow scythe,yama,fox lamp,longsword,gravity cane"):gmatch("[^,]+") do WPN.Sword[n]=true end
for n in ("combat,black leg,electro,fishman karate,dragon talon,superhuman,death step,sharkman karate,electric claw,godhuman,sanguine art"):gmatch("[^,]+") do WPN.Melee[n]=true end
for n in ("flintlock,musket,slingshot,dual flintlock,refined slingshot,bizarre rifle,kabucha,acidum rifle,serpent bow,soul guitar"):gmatch("[^,]+") do WPN.Gun[n]=true end

local function classify(t)
    if not t or not t:IsA("Tool") then return nil end
    local n = t.Name:lower()
    if WPN.Gun[n] then return "Gun" end
    if WPN.Sword[n] then return "Sword" end
    if WPN.Melee[n] then return "Melee" end
    local it = t:GetAttribute("ItemType")
    if it then
        local x = tostring(it):lower()
        if x == "sword" then return "Sword" end
        if x == "gun" then return "Gun" end
        if x == "melee" or x == "fightingstyle" or x == "fighting_style" then return "Melee" end
        if x == "fruit" or x == "bloxfruit" then return "Fruit" end
    end
    if t:FindFirstChild("GunClient") or t:FindFirstChild("GunType") then return "Gun" end
    if t:FindFirstChild("SwordClient") or t:FindFirstChild("Blade") then return "Sword" end
    if t:FindFirstChild("FruitClient") then return "Fruit" end
    if n:find("sword") or n:find("blade") or n:find("katana") then return "Sword" end
    if n:find("gun") or n:find("pistol") or n:find("rifle") or n:find("bow") then return "Gun" end
    if t:FindFirstChild("Handle") then return "Melee" end
end
local function equipWeapon()
    if not St.AutoEquip then return end
    if tick() - St.EquipTry < 1 then return end
    local c, bp = LP.Character, LP:FindFirstChild("Backpack")
    if not c or not bp then return end
    local want = St.EquipType
    if want == "Fruit" then want = "Fruit" end
    for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") and classify(t) == want then return end end
    for _, t in ipairs(bp:GetChildren()) do
        if t:IsA("Tool") and classify(t) == want then
            St.EquipTry = tick()
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then pcall(function() h:EquipTool(t) end) end
            return
        end
    end
end

--====================================================================================
-- FPS BOOST
--====================================================================================
local FPS = {}
do
    local function sp(i,p) St.Orig[i]=St.Orig[i] or {} if St.Orig[i][p]==nil then pcall(function() St.Orig[i][p]=i[p] end) end end
    local function rp(i,p) if St.Orig[i] and St.Orig[i][p]~=nil then pcall(function() i[p]=St.Orig[i][p] end) end end
    local function isFx(i) return i:IsA("ParticleEmitter") or i:IsA("Fire") or i:IsA("Smoke") or i:IsA("Sparkles") end
    FPS.shadows = function(on) if on then sp(S.Light,"GlobalShadows") pcall(function() S.Light.GlobalShadows=false end) else rp(S.Light,"GlobalShadows") end end
    FPS.postfx = function(on)
        for _, fx in ipairs(S.Light:GetChildren()) do
            if fx:IsA("BloomEffect") or fx:IsA("BlurEffect") or fx:IsA("DepthOfFieldEffect") or fx:IsA("SunRaysEffect") or fx:IsA("ColorCorrectionEffect") then
                if on then sp(fx,"Enabled") pcall(function() fx.Enabled=false end) else rp(fx,"Enabled") end
            end
        end
    end
    FPS.atmosphere = function(on)
        if on then
            sp(S.Light,"FogEnd") sp(S.Light,"FogStart")
            pcall(function() S.Light.FogEnd=0 S.Light.FogStart=0 end)
            for _, at in ipairs(S.Light:GetChildren()) do
                if at:IsA("Atmosphere") then sp(at,"Density") sp(at,"Haze") pcall(function() at.Density=0 at.Haze=0 end) end
            end
        else rp(S.Light,"FogEnd") rp(S.Light,"FogStart")
            for _, at in ipairs(S.Light:GetChildren()) do if at:IsA("Atmosphere") then rp(at,"Density") rp(at,"Haze") end end
        end
    end
    FPS.terrain = function(on)
        local t = S.WS:FindFirstChildOfClass("Terrain") if not t then return end
        if on then
            sp(t,"WaterWaveSize") sp(t,"WaterReflectance") sp(t,"WaterTransparency")
            pcall(function() t.WaterWaveSize=0 t.WaterReflectance=0 t.WaterTransparency=1 end)
        else rp(t,"WaterWaveSize") rp(t,"WaterReflectance") rp(t,"WaterTransparency") end
    end
    FPS.particles = function(on)
        if on then
            for _, d in ipairs(S.WS:GetDescendants()) do if isFx(d) and d.Enabled then sp(d,"Enabled") pcall(function() d.Enabled=false end) end end
        else for i in pairs(St.Orig) do if typeof(i)=="Instance" and isFx(i) then rp(i,"Enabled") end end end
    end
    FPS.decals = function(on)
        if on then
            for _, d in ipairs(S.WS:GetDescendants()) do if (d:IsA("Decal") or d:IsA("Texture")) and d.Transparency<1 then sp(d,"Transparency") pcall(function() d.Transparency=1 end) end end
        else for i in pairs(St.Orig) do if typeof(i)=="Instance" and (i:IsA("Decal") or i:IsA("Texture")) then rp(i,"Transparency") end end end
    end
    FPS.beams = function(on)
        if on then
            for _, d in ipairs(S.WS:GetDescendants()) do if (d:IsA("Beam") or d:IsA("Trail") or d:IsA("SelectionBox")) and d.Enabled then sp(d,"Enabled") pcall(function() d.Enabled=false end) end end
        else for i in pairs(St.Orig) do if typeof(i)=="Instance" and (i:IsA("Beam") or i:IsA("Trail") or i:IsA("SelectionBox")) then rp(i,"Enabled") end end end
    end
    FPS.lighting = function(on)
        if on then
            sp(S.Light,"Brightness") sp(S.Light,"ClockTime") sp(S.Light,"OutdoorAmbient") sp(S.Light,"Ambient")
            pcall(function() S.Light.Brightness=0.5 S.Light.ClockTime=0 S.Light.OutdoorAmbient=Color3.new(0,0,0) S.Light.Ambient=Color3.new(0,0,0) end)
        else rp(S.Light,"Brightness") rp(S.Light,"ClockTime") rp(S.Light,"OutdoorAmbient") rp(S.Light,"Ambient") end
    end
    FPS.restore = function()
        FPS.shadows(false) FPS.postfx(false) FPS.atmosphere(false) FPS.terrain(false)
        FPS.particles(false) FPS.decals(false) FPS.beams(false) FPS.lighting(false)
        St.Orig = {}
    end
end

--====================================================================================
-- HAKI / ANTI-STUCK
--====================================================================================
local function checkHaki()
    if not St.AutoHaki or not R.CommF then return end
    if tick() - St.HakiTry < 3 then return end
    local c = LP.Character if not c or c:FindFirstChild("HasBuso") then return end
    St.HakiTry = tick()
    task.spawn(function() pcall(function() R.CommF:InvokeServer("Buso") end) end)
end
local function autoBuyHakiTick()
    if not St.AutoBuyHaki or not R.CommF then return end
    if tick() - St.HakiBuyTry < 10 then return end
    local c = LP.Character if not c or c:FindFirstChild("HasBuso") then return end
    St.HakiBuyTry = tick()
    task.spawn(function() pcall(function() R.CommF:InvokeServer("BuyHaki", "Buso") end) end)
end
local function antiStuckTick()
    if not St.AntiStuck then return end
    local hrp = getRoot() if not hrp then return end
    local now = tick()
    if now - St.StuckCheck < 0.5 then return end
    St.StuckCheck = now
    if now - St.LastAttack < 2 or MOVE.Active then St.StuckTime = 0 St.LastPos = hrp.Position return end
    if (hrp.Position - St.LastPos).Magnitude < 2 then St.StuckTime = St.StuckTime + 0.5 else St.StuckTime = 0 end
    St.LastPos = hrp.Position
    if St.StuckTime >= (St.MobTimeout or 5) then
        St.StuckTime = 0
        St.Sub = "Anti-stuck"
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 15, 0)
    end
end

--====================================================================================
-- TARGETS
--====================================================================================
local function findMob(name)
    local hrp = getRoot() if not hrp then return nil end
    local best, bd
    for _, e in ipairs(enemies()) do
        if e.m.Name == name and e.h.Health > 0 then
            local d = dist(e.r.Position, hrp.Position)
            if not bd or d < bd then best, bd = e.m, d end
        end
    end
    return best, bd
end
local function findNearest(maxd)
    maxd = maxd or 3000
    local hrp = getRoot() if not hrp then return nil end
    local best, bd
    for _, e in ipairs(enemies()) do
        if e.h.Health > 0 then
            local d = dist(e.r.Position, hrp.Position)
            if d <= maxd and (not bd or d < bd) then best, bd = e.m, d end
        end
    end
    return best, bd
end
local bossMapT = 0
local function findBoss(name)
    for _, e in ipairs(enemies()) do if e.m.Name == name then return e.m end end
    if tick() - bossMapT > 3 then
        bossMapT = tick()
        local map = S.WS:FindFirstChild("Map")
        if map then
            for _, o in ipairs(map:GetDescendants()) do
                if o.Name == name then
                    local h = o:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 then return o end
                end
            end
        end
    end
end
local function hoverAt(p)
    local hrp = getRoot() if not hrp then return end
    local a = p + Vector3.new(0, St.Hover, 0)
    local d = dist(hrp.Position, a)
    if d > 60 then
        if St.FarTP and d > 1500 then teleportTo(CFrame.new(a)) else moveTo(CFrame.new(a)) end
    else
        stopMoving()
        hrp.CFrame = CFrame.new(a)
    end
end
local function targetFarm(mob, label)
    local mrp = mob and mob:FindFirstChild("HumanoidRootPart")
    if not mrp then St.Sub = label.." · không có" return false end
    St.TargetName = mob.Name
    St.CurrentMobName = mob.Name
    equipWeapon()
    St.Sub = label.." · "..dn(mob.Name)
    hoverAt(mrp.Position)
    return true
end

--====================================================================================
-- CHEST
--====================================================================================
local chestCache, chestScan = {}, 0
local function getChests()
    if tick() - chestScan > 3 then
        chestScan = tick()
        local out = {}
        for _, o in ipairs(S.WS:GetDescendants()) do
            if o.Name == "Chest" or o.Name == "ChestFolderValue" then
                local p = o:IsA("BasePart") and o or o:FindFirstChildWhichIsA("BasePart")
                if p then out[#out+1] = p end
            end
        end
        chestCache = out
    end
    return chestCache
end
local function findNearestChest()
    local hrp = getRoot() if not hrp then return nil end
    local best, bd
    for _, p in ipairs(getChests()) do
        if p.Parent then
            local d = dist(p.Position, hrp.Position)
            if d <= 800 and (not bd or d < bd) then best, bd = p, d end
        end
    end
    return best
end
local function runChestFarm()
    if tick() - St.LastChest < 0.5 then return end
    local c = findNearestChest()
    if c then
        St.LastChest = tick()
        St.Sub = "Chest · tới rương"
        teleportTo(CFrame.new(c.Position + Vector3.new(0,3,0)))
        task.wait(0.12)
    else St.Sub = "Chest · không có" task.wait(0.5) end
end

--====================================================================================
-- FRUIT
--====================================================================================
local FR_EX = {"bloxfruit","meshes","/","fruitdealer","fruitshop","fruitview","fruitnotifier","fruitinventory","fruitremote"}
local function looksLikeFruit(inst)
    if not inst or not inst.Parent then return false end
    local n = inst.Name:lower()
    for _, x in ipairs(FR_EX) do if n:find(x,1,true) then return false end end
    local par = inst.Parent
    if par:IsA("Model") and S.Players:GetPlayerFromCharacter(par) then return false end
    if not (D.FRUIT_BY_KEY[inst.Name] or inst.Name:find("Fruit") or inst.Name:find("^%a+%-%a+$")) then return false end
    if inst:IsA("Tool") or inst:IsA("BasePart") then return true end
    return inst:IsA("Model") and (inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart")) ~= nil
end
local function partPos(inst)
    if not inst then return nil end
    if inst:IsA("BasePart") then return inst.Position end
    local h = inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart")
    if h then return h.Position end
    local ok, pv = pcall(function() return inst:GetPivot().Position end)
    return ok and pv or nil
end
local function scanFruits(force)
    if not force and tick() - St.LastFruitScan < 1.2 and #St.FruitCache > 0 then return St.FruitCache end
    St.LastFruitScan = tick()
    local out = {}
    local function walk(inst, depth)
        if depth > 2 or #out > 40 then return end
        if (inst:IsA("Tool") or inst:IsA("Model")) and looksLikeFruit(inst) then
            local p = partPos(inst)
            if p then out[#out+1] = { inst=inst, name=inst.Name, pos=p, rarity=fruitRarity(inst.Name), price=fruitPrice(inst.Name) } end
        end
        for _, c in ipairs(inst:GetChildren()) do walk(c, depth+1) end
    end
    for _, c in ipairs(S.WS:GetChildren()) do walk(c, 0) end
    St.FruitCache = out
    return out
end
local function tickFruit()
    if not (St.FruitSniper or St.FruitBring or St.FruitNotify or St.AutoStoreFruit) then return end
    local list = scanFruits()
    if St.FruitNotify then
        for _, f in ipairs(list) do
            if not St.NotifiedFruits[f.inst] then
                St.NotifiedFruits[f.inst] = true
                local tag = ({"Common","Uncommon","Rare","Legendary","Mythical"})[f.rarity+1] or "?"
                notify("Fruit: "..f.name, tag.." · $"..tostring(f.price), 5)
            end
        end
    end
    if St.FruitSniper then
        local hrp = getRoot()
        if hrp then
            local best, bd
            for _, f in ipairs(list) do
                if f.rarity >= St.FruitMinRarity then
                    local d = dist(f.pos, hrp.Position)
                    if d < 5000 and (not bd or d < bd) then best, bd = f, d end
                end
            end
            if best and tick() - St.LastFruit >= 1.5 then
                St.LastFruit = tick()
                St.Sub = "Fruit · "..best.name
                teleportTo(CFrame.new(best.pos))
            end
        end
    end
    if St.FruitBring then
        local hrp = getRoot()
        if hrp then
            for _, f in ipairs(list) do
                if dist(f.pos, hrp.Position) < 300 then
                    pcall(function()
                        local h = f.inst:FindFirstChild("Handle") or f.inst:FindFirstChildWhichIsA("BasePart")
                        if h then h.CFrame = CFrame.new(hrp.Position + Vector3.new(0,3,0)) end
                    end)
                end
            end
        end
    end
    if St.AutoStoreFruit and tick() - St.LastStoreFruit > 5 then
        local inv = Invoke("GetFruits")
        if type(inv) == "table" then
            for _, f in ipairs(inv) do
                local nm = type(f) == "table" and (f.Name or f.name) or nil
                local ra = type(f) == "table" and tonumber(f.Rarity or f.rarity) or fruitRarity(nm)
                if nm and (ra or 0) >= St.StoreMinRarity then
                    St.LastStoreFruit = tick()
                    Invoke("StoreFruit", nm)
                    St.Sub = "Kho · "..nm
                    break
                end
            end
        end
    end
end

--====================================================================================
-- ESP
--====================================================================================
local espCache = {}
local function espClear()
    for _, e in pairs(espCache) do
        pcall(function() e.bb:Destroy() end)
        pcall(function() e.hl:Destroy() end)
    end
    espCache = {}
end
local function espTrack(inst, text, color)
    if not inst or not inst.Parent then return end
    local e = espCache[inst]
    if not e then
        local bb = Instance.new("BillboardGui")
        bb.Name = "HL_ESP"
        bb.Size = UDim2.new(0, 180, 0, 30)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = St.ESPRange
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,0,1,0)
        lbl.BackgroundTransparency = 0.35
        lbl.BackgroundColor3 = Color3.fromRGB(0,0,0)
        lbl.TextColor3 = color
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextStrokeTransparency = 0.5
        lbl.Parent = bb
        local hl = Instance.new("Highlight")
        hl.FillColor = color
        hl.FillTransparency = 0.78
        hl.OutlineColor = Color3.fromRGB(255,255,255)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = inst
        bb.Parent = inst
        e = { bb=bb, label=lbl, hl=hl }
        espCache[inst] = e
    end
    e.label.Text = text
    e.label.TextColor3 = color
    return e
end
local function espUpdate()
    local anyOn = St.ESPPlayers or St.ESPMobs or St.ESPBoss or St.ESPChests or St.ESPFruits
    if not anyOn then if next(espCache) then espClear() end return end
    for inst, e in pairs(espCache) do
        if not inst.Parent then
            pcall(function() e.bb:Destroy() end)
            pcall(function() e.hl:Destroy() end)
            espCache[inst] = nil
        end
    end
    local me = pos()
    if St.ESPPlayers then
        for _, pl in ipairs(S.Players:GetPlayers()) do
            if pl ~= LP and pl.Character then
                local h = pl.Character:FindFirstChildOfClass("Humanoid")
                local r = pl.Character:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then
                    local lv = 0
                    local d = pl:FindFirstChild("Data")
                    if d and d:FindFirstChild("Level") then lv = d.Level.Value end
                    espTrack(r, string.format("%s [Lv.%d] %dm", pl.Name, lv, dist(r.Position, me)), Color3.fromRGB(90,255,130))
                end
            end
        end
    end
    if St.ESPMobs or St.ESPBoss then
        for _, e in ipairs(enemies()) do
            local d = dist(e.r.Position, me)
            if d < St.ESPRange then
                local isBoss = e.h.MaxHealth >= 5000
                if (isBoss and St.ESPBoss) or (not isBoss and St.ESPMobs) then
                    espTrack(e.r, string.format("%s%s · %dm", e.m.Name, isBoss and " [BOSS]" or "", math.floor(d)),
                        isBoss and Color3.fromRGB(255,80,80) or Color3.fromRGB(255,175,70))
                end
            end
        end
    end
    if St.ESPFruits then
        for _, f in ipairs(scanFruits()) do
            local d = dist(f.pos, me)
            if d < St.ESPRange then espTrack(f.inst, string.format("%s (r%d) · %dm", f.name, f.rarity, math.floor(d)), Color3.fromRGB(255,110,240)) end
        end
    end
    if St.ESPChests then
        for _, p in ipairs(getChests()) do
            if p.Parent then
                local d = dist(p.Position, me)
                if d < St.ESPRange then espTrack(p, string.format("RƯƠNG · %dm", math.floor(d)), Color3.fromRGB(255,230,90)) end
            end
        end
    end
end

--====================================================================================
-- RAID
--====================================================================================
local RaidFns = {}
do
    local function hasChip()
        local c = LP.Character
        if c and c:FindFirstChild("Special Microchip") then return true end
        local bp = LP:FindFirstChild("Backpack")
        if bp and bp:FindFirstChild("Special Microchip") then return true end
        return false
    end
    local function unequipChip()
        local c = LP.Character if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then pcall(function() h:UnequipTools() end) end
        local chip = c:FindFirstChild("Special Microchip")
        if chip then
            local bp = LP:FindFirstChild("Backpack")
            if bp then pcall(function() chip.Parent = bp end) end
        end
    end
    local function fruitInBag(full)
        if not full then return false end
        local s = full:match("^([^%-]+)") or full
        local function has(c)
            if not c then return false end
            for _, t in ipairs(c:GetChildren()) do
                if t:IsA("Tool") and (t.Name == full or t.Name == s or t.Name == s.."-"..s or t.Name == s.." Fruit") then return true end
            end
            return false
        end
        return has(LP.Character) or has(LP:FindFirstChild("Backpack"))
    end
    local function inRaid()
        local pg = LP:FindFirstChild("PlayerGui") if not pg then return false end
        local m = pg:FindFirstChild("Main") if not m then return false end
        local top = m:FindFirstChild("TopHUDList")
        local t = top and top:FindFirstChild("RaidTimer")
        if t and t.Visible then return true end
        local t2 = m:FindFirstChild("Timer")
        return t2 and t2.Visible or false
    end
    local function buyChip()
        if hasChip() then return end
        if tick() - St.LastChipBuy < 5 then return end
        St.LastChipBuy = tick()
        St.Sub = "Raid · mua chip"
        Invoke("RaidsNpc", "Select", St.RaidChip)
        task.wait(1.2)
        if hasChip() then return end
        Invoke("BuyChip", St.RaidChip)
        task.wait(1)
        if hasChip() then return end
        for _, fn in ipairs(D.CHEAP) do
            local s = fn:match("^([^%-]+)") or fn
            Invoke("LoadFruit", fn)
            local ok = false
            for _ = 1, 8 do task.wait(0.2) if fruitInBag(fn) then ok = true break end end
            if not ok then
                Invoke("LoadFruit", s)
                for _ = 1, 8 do task.wait(0.2) if fruitInBag(s) then ok = true break end end
            end
            if ok then
                Invoke("RaidsNpc", "Select", St.RaidChip)
                for _ = 1, 15 do
                    task.wait(0.25)
                    if hasChip() then St.Sub = "Raid · chip sẵn sàng" St.RaidAttempts = 0 return end
                end
            end
        end
        St.Sub = "Raid · mua thất bại"
        task.wait(2)
    end
    local function startRaid()
        if inRaid() then St.RaidAttempts = 0 return end
        if not hasChip() then St.Sub = "Raid · chờ chip" return end
        if tick() - St.LastSummonTry < 3 then return end
        St.LastSummonTry = tick()
        St.RaidAttempts = St.RaidAttempts + 1
        unequipChip()
        task.wait(0.15)
        local summon
        local map = S.WS:FindFirstChild("Map")
        if map then
            local islName = SEA == 3 and "Boat Castle" or "CircleIsland"
            local isl = map:FindFirstChild(islName)
            if isl then summon = isl:FindFirstChild("RaidSummon2") or isl:FindFirstChild("RaidSummon") or isl:FindFirstChild("RaidSummon1") end
            if not summon then
                for _, d in ipairs(map:GetDescendants()) do
                    if d.Name == "RaidSummon2" or d.Name == "RaidSummon" or d.Name == "RaidSummon1" then summon = d break end
                end
            end
        end
        if summon then
            local buttonPart
            local button = summon:FindFirstChild("Button", true)
            if button then buttonPart = button:FindFirstChild("Main", true) or button:FindFirstChildWhichIsA("BasePart", true) end
            if not buttonPart then
                for _, d in ipairs(summon:GetDescendants()) do
                    if d:IsA("BasePart") and d:FindFirstChildOfClass("ClickDetector") then buttonPart = d break end
                end
            end
            if buttonPart then
                local hrp = getRoot()
                if hrp then
                    hrp.CFrame = CFrame.new(buttonPart.Position + Vector3.new(0,3,30), buttonPart.Position)
                    task.wait(0.15)
                    local click = buttonPart:FindFirstChildOfClass("ClickDetector")
                    if click then
                        pcall(function() fireclickdetector(click, 5) end) task.wait(0.12)
                        pcall(function() fireclickdetector(click, 1) end) task.wait(0.12)
                        pcall(function() fireclickdetector(click) end)
                    end
                    pcall(function() firetouchinterest(hrp, buttonPart, 0) task.wait(0.05) firetouchinterest(hrp, buttonPart, 1) end)
                end
            end
            if R.Raids then pcall(function() R.Raids:FireServer("Start", St.RaidChip) end) pcall(function() R.Raids:FireServer("Start") end) end
            if R.Btn then pcall(function() R.Btn:FireServer("Start", St.RaidChip) end) end
            if R.CommF then
                pcall(function() R.CommF:InvokeServer("Raid", St.RaidChip) end)
                pcall(function() R.CommF:InvokeServer("StartRaid", St.RaidChip) end)
            end
        else
            St.Sub = "Raid · không thấy bàn"
            if R.CommF then pcall(function() R.CommF:InvokeServer("StartRaid", St.RaidChip) end) end
        end
        for _ = 1, 15 do
            task.wait(0.4)
            if inRaid() then St.Sub = "Raid · đã vào" St.RaidAttempts = 0 return end
        end
        if St.RaidAttempts >= 4 then St.RaidAttempts = 0 St.LastChipBuy = 0 end
    end
    local function clearRaid()
        if not inRaid() then St.Sub = "Raid · chờ vào" return end
        if St.RaidChip == "Magma" or St.RaidChip == "Flame" then
            local map = S.WS:FindFirstChild("Map")
            if map then for _, d in ipairs(map:GetDescendants()) do if d.Name == "Lava" and d.Parent then pcall(function() d:Destroy() end) end end end
        end
        local names = {"Island 5","Island 4","Island 3","Island 2","Island 1"}
        local found
        local origin = S.WS:FindFirstChild("_WorldOrigin")
        local locs = origin and origin:FindFirstChild("Locations")
        local hrp = getRoot()
        if locs and hrp then
            for _, n in ipairs(names) do
                local t = locs:FindFirstChild(n)
                if t and dist(t.Position, hrp.Position) <= 3000 then found = t St.Sub = "Raid · "..n break end
            end
        end
        if not found then
            local rm = S.WS:FindFirstChild("RaidMap")
            if rm then
                for _, n in ipairs(names) do
                    local t = rm:FindFirstChild(n)
                    if t then found = t St.Sub = "Raid · "..n break end
                end
            end
        end
        if found and hrp then
            local p = found:IsA("BasePart") and found.Position or found:GetPivot().Position
            if dist(hrp.Position, p) > 100 then teleportTo(CFrame.new(p + Vector3.new(0,120,0))) task.wait(0.3) end
        elseif not found then St.Sub = "Raid · clear" end
        St.TargetName = nil
        bringMobs(5000)
    end
    RaidFns.hasChip, RaidFns.inRaid, RaidFns.buy, RaidFns.start, RaidFns.clear = hasChip, inRaid, buyChip, startRaid, clearRaid
end

--====================================================================================
-- EXTENSIONS v14 — FISHING / MASTERY / SPECIAL QUEST / PVP / MOVEMENT / ISLAND
--====================================================================================
local X = St

-- ISLANDS
local ISLANDS = {
    ["Sea 1"] = {
        ["Starter Island"]    = Vector3.new(0,0,0),
        ["Marine Fort"]       = Vector3.new(-5039,27,4324),
        ["Jungle"]            = Vector3.new(-1598,36,153),
        ["Pirate Village"]    = Vector3.new(-1141,4,3831),
        ["Desert"]            = Vector3.new(894,5,4392),
        ["Snow Island"]       = Vector3.new(1389,88,-1298),
        ["Marine Ford"]       = Vector3.new(-5039,27,4324),
        ["Skylands"]          = Vector3.new(-4839,716,-2619),
        ["Prison"]            = Vector3.new(5308,1,475),
        ["Colosseum"]         = Vector3.new(-1580,6,-2986),
        ["Magma Village"]     = Vector3.new(-5313,10,8515),
        ["Underwater City"]   = Vector3.new(61122,18,1569),
        ["Fountain City"]     = Vector3.new(5259,37,4050),
    },
    ["Sea 2"] = {
        ["Kingdom of Rose"]   = Vector3.new(-429,71,1836),
        ["Swan Mansion"]      = Vector3.new(638,71,918),
        ["Green Zone"]        = Vector3.new(-2440,71,-3216),
        ["Graveyard"]         = Vector3.new(-5497,47,-795),
        ["Snow Mountain"]     = Vector3.new(609,400,-5372),
        ["Ice Castle"]        = Vector3.new(-6064,15,-4902),
        ["Fire Village"]      = Vector3.new(-5428,15,-5299),
        ["Cursed Ship"]       = Vector3.new(1037,125,32911),
        ["Forgotten Island"]  = Vector3.new(-3054,235,-10142),
    },
    ["Sea 3"] = {
        ["Port Town"]         = Vector3.new(-290,42,5581),
        ["Hydra Island"]      = Vector3.new(5213,1004,758),
        ["Great Tree"]        = Vector3.new(2180,27,-6741),
        ["Castle on the Sea"] = Vector3.new(5259,37,4050),
        ["Haunted Castle"]    = Vector3.new(-9479,141,5566),
        ["Cake Land"]         = Vector3.new(-2021,37,-12028),
        ["Chocolate Land"]    = Vector3.new(233,29,-12201),
        ["Tiki Outpost"]      = Vector3.new(-16547,61,-173),
        ["Submerged Island"]  = Vector3.new(10778,-2087,9265),
    },
}

local SPECIAL_QUESTS = {
    { name="Saber",         npc="Saber Expert",    pos=Vector3.new(-1404,30,-3068) },
    { name="Pole",          npc="Pole",            pos=Vector3.new(-7906,5634,-1411) },
    { name="Saw",           npc="Saw",             pos=Vector3.new(-9189,301,5480) },
    { name="Trident",       npc="Trident",         pos=Vector3.new(-1256,7,-2832) },
    { name="Dragon",        npc="Dragon",          pos=Vector3.new(6738,127,-713) },
    { name="Warden",        npc="Warden",          pos=Vector3.new(-2440,71,-3216) },
    { name="Chief Warden",  npc="Chief Warden",    pos=Vector3.new(-2440,71,-3216) },
    { name="Greybeard",     npc="Greybeard",       pos=Vector3.new(-5039,27,4324) },
    { name="Tree Destroyer",npc="Tree Destroyer",  pos=Vector3.new(-2021,37,-12028) },
    { name="Elite Hunter",  npc="Elite Hunter",    pos=Vector3.new(5259,37,4050) },
    { name="Player Hunter", npc="Player Hunter",   pos=Vector3.new(5259,37,4050) },
}

-- MATERIALS / REGIONS
local MATERIALS = {
    [1]={"Leather","Scrap Metal","Angel Wings","Magma Ore","Fish Tail"},
    [2]={"Leather","Scrap Metal","Angel Wings","Magma Ore","Fish Tail","Radioactive Material","Mystic Droplet","Mini Tusk"},
    [3]={"Leather","Scrap Metal","Angel Wings","Magma Ore","Fish Tail","Radioactive Material","Mystic Droplet","Mini Tusk","Vampire Fang","Dragon Scale","Cursed Dual Katana Shard","Conjured Cocoa","Candy Cane","Gunpowder","Bones","Ectoplasm"},
}
local REGIONS = {
    ["Sea 1 - Bandit"]=Vector3.new(1059,15,1550),
    ["Sea 1 - Prisoner"]=Vector3.new(5308,1,475),
    ["Sea 1 - Sky Guards"]=Vector3.new(-4721,843,-1949),
    ["Sea 2 - Zombie"]=Vector3.new(-5497,47,-795),
    ["Sea 2 - Swan Pirate"]=Vector3.new(638,71,918),
    ["Sea 2 - Forgotten"]=Vector3.new(-3054,235,-10142),
    ["Sea 2 - Cursed Ship"]=Vector3.new(1037,125,32911),
    ["Sea 3 - Haunted"]=Vector3.new(-9479,141,5566),
    ["Sea 3 - Tiki"]=Vector3.new(-16547,61,-173),
    ["Sea 3 - Cake Land"]=Vector3.new(-2021,37,-12028),
    ["Sea 3 - Choc"]=Vector3.new(233,29,-12201),
    ["Sea 3 - Submerged"]=Vector3.new(10778,-2087,9265),
    ["Sea 3 - Hydra"]=Vector3.new(5213,1004,758),
    ["Sea 3 - Castle"]=Vector3.new(5259,37,4050),
}

-- findGroundDrop
local function findGroundDrop(name)
    local hrp = getRoot() if not hrp then return nil end
    local best, bd
    for _, o in ipairs(S.WS:GetChildren()) do
        if o.Name == name or o:FindFirstChild(name) then
            local p = o:IsA("BasePart") and o or o:FindFirstChildWhichIsA("BasePart", true)
            if p then
                local d = dist(p.Position, hrp.Position)
                if d < 800 and (not bd or d < bd) then best, bd = p, d end
            end
        end
    end
    return best
end

-- AUTO FISHING
local function autoFishTick()
    if not X.AutoFish then return end
    if SEA == 1 then X.Sub = "Fish · cần Sea 2+" return end
    if X.AutoBuyBait and not X.HasBait then
        pcall(function() Invoke("BuyBait") end)
        task.wait(1)
        X.HasBait = true
        return
    end
    local bp = LP:FindFirstChild("Backpack")
    local rod
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("rod") then rod = t break end
        end
    end
    local c = LP.Character
    if c then
        local eq = c:FindFirstChildWhichIsA("Tool")
        if eq and eq.Name:lower():find("rod") then rod = eq end
    end
    if not rod then X.Sub = "Fish · không có cần" task.wait(1) return end
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if h and rod.Parent ~= c then pcall(function() h:EquipTool(rod) end) end
    if rod:FindFirstChild("RemoteFunction") then
        pcall(function() rod.RemoteFunction:InvokeServer("Cast") end)
    end
    X.Sub = "Fish · đang câu..."
    task.wait(3)
end

-- MASTERY FARM
local function masteryFarmTick()
    if not X.AutoMastery then return end
    local m = findNearest(2000)
    if m then
        X.TargetName = nil
        X.CurrentMobName = m.Name
        if X.MasteryTarget == "Fruit" then X.EquipType = "Fruit"
        elseif X.MasteryTarget == "Gun" then X.EquipType = "Gun"
        elseif X.MasteryTarget == "Sword" then X.EquipType = "Sword"
        else X.EquipType = "Melee" end
        targetFarm(m, "Mastery")
    else X.Sub = "Mastery · không có mob" task.wait(0.5) end
end

-- SPECIAL QUEST
local function specialQuestTick()
    if not X.AutoSpecialQuest then return end
    for _, q in ipairs(SPECIAL_QUESTS) do
        if q.name == X.SpecialQuest then
            local hrp = getRoot() if not hrp then return end
            local d = dist(hrp.Position, q.pos)
            if d > 35 then
                X.Sub = "Quest · tới "..q.npc
                if d > 400 then teleportTo(q.pos + Vector3.new(0,5,3))
                else moveTo(q.pos + Vector3.new(0,5,3), 400) end
                return
            end
            stopMoving()
            X.Sub = "Quest · "..q.name
            pcall(function() Invoke("StartQuest", q.name) end)
            task.wait(1)
            return
        end
    end
end

-- COMPLETE QUEST / HAKI PAD
local function completeQuestTick()
    if not X.AutoCompleteQuest then return end
    if not R.CommF then return end
    pcall(function() R.CommF:InvokeServer("CompleteQuest") end)
    task.wait(2)
end
local function hakiPadTick()
    if not X.AutoHakiPad then return end
    if not R.CommF then return end
    local c = LP.Character
    if c and c:FindFirstChild("HasBuso") then return end
    pcall(function() R.CommF:InvokeServer("BuyHaki", "Buso") end)
    task.wait(3)
end

-- RIP INDRA / SOUL REAPER / DOUGH KING / LUCKY GRAVE
local function ripIndraAttackTick()
    if not X.AutoRipIndraAttack then return end
    local b = findBoss("Rip_indra") or findBoss("rip_indra")
    if b then targetFarm(b, "Rip Indra")
    else X.Sub = "Rip Indra · chờ" hoverAt(CFrame.new(-16565,104,1579).Position) end
end
local function soulReaperTick()
    if not X.AutoSoulReaper then return end
    local b = findBoss("Soul Reaper")
    if b then targetFarm(b, "Soul Reaper")
    else X.Sub = "Soul Reaper · chờ" hoverAt(CFrame.new(-9479,141,5566).Position) end
end
local function doughKingTick()
    if not X.AutoDoughKing then return end
    local b = findBoss("Dough King")
    if b then targetFarm(b, "Dough King")
    else X.Sub = "Dough King · chờ" hoverAt(CFrame.new(-2021,37,-12028).Position) end
end
local function tryLuckyGraveTick()
    if not X.TryLuckyGrave then return end
    if tick() - X.LastGrave < 5 then return end
    X.LastGrave = tick()
    pcall(function() Invoke("LuckyGrave") end)
    X.Sub = "Lucky Grave · thử"
    task.wait(2)
end

-- FACTORY / PIRATE RAID
local function factoryRaidTick()
    if not X.AutoFactoryRaid then return end
    if SEA ~= 2 then X.Sub = "Factory · cần Sea 2" return end
    local p = Vector3.new(632, 73, 918)
    local hrp = getRoot() if not hrp then return end
    if dist(hrp.Position, p) > 50 then X.Sub = "Factory · tới" moveTo(p, 400) return end
    stopMoving()
    pcall(function() Invoke("FactoryRaid") end)
    X.Sub = "Factory · raid"
    task.wait(2)
end
local function pirateRaidTick()
    if not X.AutoPirateRaid then return end
    if SEA ~= 3 then X.Sub = "Pirate Raid · cần Sea 3" return end
    local b = findBoss("Pirate Millionaire")
    if b then targetFarm(b, "Pirate Raid")
    else X.Sub = "Pirate Raid · chờ" hoverAt(CFrame.new(-290,42,5581).Position) end
end

-- GACHA / MAGNET
local function gachaMagnetTick()
    if not X.AutoGachaMagnet then return end
    if tick() - X.LastGacha < 5 then return end
    X.LastGacha = tick()
    pcall(function() Invoke("Gacha", "Magnet") end)
    X.Sub = "Gacha Magnet · thử"
    task.wait(2)
end
local function magnetEventTick()
    if not X.AutoMagnetEvent then return end
    if SEA ~= 3 then X.Sub = "Magnet Event · cần Sea 3" return end
    local best, bd
    local hrp = getRoot() if not hrp then return end
    for _, e in ipairs(enemies()) do
        if e.m.Name:lower():find("magnet") then
            local d = dist(e.r.Position, hrp.Position)
            if not bd or d < bd then best, bd = e.m, d end
        end
    end
    if best then targetFarm(best, "Magnet")
    else X.Sub = "Magnet Event · chờ" hoverAt(CFrame.new(-13234,331,-7625).Position) end
end

-- PVP
local PvP = { LastHL = nil }
local function silentAimTick()
    if not X.SilentAim then return end
    local cam = S.WS.CurrentCamera
    local sc = Vector2.new(VP.X/2, VP.Y/2)
    local best, bd, bestHP
    if X.SilentAimPlayer then
        for _, pl in ipairs(S.Players:GetPlayers()) do
            if pl ~= LP and pl.Character then
                local head = pl.Character:FindFirstChild("Head")
                local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                if head and hum and hum.Health > 0 then
                    local sp, onScreen = cam:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local d = (Vector2.new(sp.X, sp.Y) - sc).Magnitude
                        if d < X.AimbotFOV then
                            if X.TargetLowestHP then
                                if not bestHP or hum.Health < bestHP then best, bd, bestHP = head, d, hum.Health end
                            else
                                if not bd or d < bd then best, bd = head, d end
                            end
                        end
                    end
                end
            end
        end
    else
        for _, e in ipairs(enemies()) do
            if e.h.Health > 0 then
                local head = e.m:FindFirstChild("Head") or e.r
                local sp, onScreen = cam:WorldToViewportPoint(head.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - sc).Magnitude
                    if d < X.AimbotFOV then
                        if X.TargetLowestHP then
                            if not bestHP or e.h.Health < bestHP then best, bd, bestHP = head, d, e.h.Health end
                        else
                            if not bd or d < bd then best, bd = head, d end
                        end
                    end
                end
            end
        end
    end
    if best then
        cam.CFrame = CFrame.new(cam.CFrame.Position, best.Position)
        if X.Tracer then
            if PvP.LastHL and PvP.LastHL.Parent then
                local old = PvP.LastHL:FindFirstChild("HL_Tracer")
                if old then old:Destroy() end
            end
            if PvP.LastHL ~= best then
                local hl = Instance.new("Highlight")
                hl.Name = "HL_Tracer"
                hl.FillColor = Color3.fromRGB(255,0,0)
                hl.FillTransparency = 0.5
                hl.OutlineColor = Color3.fromRGB(255,255,255)
                hl.Parent = best
                PvP.LastHL = best
            end
        end
    end
end
local function drawFovCircle()
    if not X.FovCircle then
        if X._fovCircle then X._fovCircle:Destroy() X._fovCircle = nil end
        return
    end
    if not X._fovCircle or not X._fovCircle.Parent then
        local sg2 = Instance.new("ScreenGui")
        sg2.Name = "HL_FOV"
        sg2.IgnoreGuiInset = true
        sg2.Parent = GUI
        local c = Instance.new("Frame")
        c.Name = "Circle"
        c.BackgroundTransparency = 1
        c.Size = UDim2.new(0, X.AimbotFOV*2, 0, X.AimbotFOV*2)
        c.Position = UDim2.new(0.5, -X.AimbotFOV, 0.5, -X.AimbotFOV)
        c.Parent = sg2
        local st2 = Instance.new("UIStroke")
        st2.Color = Color3.fromRGB(255,200,90)
        st2.Thickness = 1
        st2.Transparency = 0.5
        st2.Parent = c
        local cc = Instance.new("UICorner")
        cc.CornerRadius = UDim.new(1,0)
        cc.Parent = c
        X._fovCircle = sg2
    end
    pcall(function()
        if X._fovCircle and X._fovCircle:FindFirstChild("Circle") then
            X._fovCircle.Circle.Size = UDim2.new(0, X.AimbotFOV*2, 0, X.AimbotFOV*2)
            X._fovCircle.Circle.Position = UDim2.new(0.5, -X.AimbotFOV, 0.5, -X.AimbotFOV)
        end
    end)
end

-- WATER WALK / BYPASS SPEED
local function waterWalkTick()
    if not X.WaterWalk then return end
    local hrp = getRoot() if not hrp then return end
    if hrp.Position.Y < -5 then
        hrp.CFrame = CFrame.new(hrp.Position.X, 1, hrp.Position.Z)
        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
    end
end
local function bypassSpeedTick()
    if not X.BypassSpeed then return end
    local hrp = getRoot()
    local h = getHum()
    if not hrp or not h then return end
    local mv = h.MoveDirection
    if mv.Magnitude > 0 then
        local speed = h.WalkSpeed * X.BypassSpeedMul
        hrp.AssemblyLinearVelocity = Vector3.new(mv.X*speed, hrp.AssemblyLinearVelocity.Y, mv.Z*speed)
    end
end

-- BERRY / HOP
local function autoBerryTick()
    if not X.AutoBerry then return end
    local hrp = getRoot() if not hrp then return end
    for _, o in ipairs(S.WS:GetChildren()) do
        if o.Name:lower():find("berry") then
            local p = o:IsA("BasePart") and o or o:FindFirstChildWhichIsA("BasePart")
            if p and dist(p.Position, hrp.Position) < 500 then
                teleportTo(CFrame.new(p.Position + Vector3.new(0,3,0)))
                task.wait(0.2)
                return
            end
        end
    end
    X.Sub = "Berry · không có"
    task.wait(0.5)
end
local function collectHopTick()
    if not X.AutoCollectHop then return end
    local hrp = getRoot() if not hrp then return end
    for _, o in ipairs(S.WS:GetDescendants()) do
        if o.Name:lower():find("hop") and o:IsA("BasePart") and dist(o.Position, hrp.Position) < 300 then
            teleportTo(CFrame.new(o.Position + Vector3.new(0,3,0)))
            task.wait(0.2)
            return
        end
    end
    X.Sub = "Hop · không có"
    task.wait(0.5)
end

-- ISLAND TP
local function islandTeleportTick()
    if not X.IslandTP then return end
    X.IslandTP = false
    local seaName = SEA == 1 and "Sea 1" or (SEA == 2 and "Sea 2" or "Sea 3")
    local sea = ISLANDS[seaName]
    if not sea then X.Sub = "Island · không rõ Sea" return end
    local p = sea[X.IslandName]
    if not p then X.Sub = "Island · không có "..X.IslandName return end
    teleportTo(CFrame.new(p + Vector3.new(0, 10, 0)))
    X.Sub = "Island · "..X.IslandName
end

-- Bones / Ecto / Dough / Elite / Mastery / Materials / Region
local function runRegionFarm()
    if not X.RegionFarm then return end
    local p = REGIONS[X.RegionName]
    if not p then X.Sub = "Region · không tìm thấy" task.wait(0.5) return end
    local hrp = getRoot() if not hrp then return end
    local target = p + Vector3.new(0, X.Hover, 0)
    if dist(hrp.Position, target) > 50 then
        X.Sub = "Region · di chuyển tới "..X.RegionName
        if X.FarTP and dist(hrp.Position, target) > 1500 then teleportTo(CFrame.new(target)) else moveTo(CFrame.new(target)) end
        return
    end
    -- Tìm và đánh mob gần nhất trong vùng
    local m = findNearest(2000)
    if m then
        X.CurrentMobName = m.Name
        targetFarm(m, "Region")
    else
        X.Sub = "Region · chờ mob "..X.RegionName
        task.wait(0.5)
    end
end
local function runBonesFarm()
    if not X.AutoBones then return end
    if SEA ~= 3 then X.Sub = "Bones · cần Sea 3" return end
    local lv = myLevel()
    local mob, giver, q, qid = "Reborn Skeleton", CFrame.new(-9479,141,5566), "HauntedQuest1", 1
    if X.AutoQuest then
        local qp = getQuestInfo()
        local done = qp and qp.cur >= qp.max
        if X.QuestLv ~= lv or done or not qp then
            local hrp = getRoot()
            if hrp and dist(hrp.Position, giver.Position) > 14 then moveTo(giver + Vector3.new(0,4,3)) return end
            stopMoving() Invoke("StartQuest", q, qid) X.QuestLv = lv task.wait(0.3) return
        end
    end
    local m = findMob(mob)
    if m then targetFarm(m, "Bones") else hoverAt(giver.Position) end
    X.Sub = "Bones · "..mob
end
local function runEctoFarm()
    if not X.AutoEcto then return end
    if SEA ~= 2 then X.Sub = "Ecto · cần Sea 2" return end
    local mob, giver = "Ship Deckhand", CFrame.new(1037,125,32911)
    local m = findMob(mob)
    if m then targetFarm(m, "Ecto") else hoverAt(giver.Position) end
    X.Sub = "Ectoplasm · "..mob
end
local function runDoughFarm()
    if not X.AutoDough then return end
    if SEA ~= 3 then X.Sub = "Dough · cần Sea 3" return end
    local b = findBoss("Cake Prince") or findBoss("Dough King")
    if b then targetFarm(b, "Cake Prince")
    else hoverAt(CFrame.new(-2021,37,-12028).Position) X.Sub = "Dough · chờ spawn" end
end
local function runEliteFarm()
    if not X.AutoElite then return end
    if SEA ~= 3 then X.Sub = "Elite · cần Sea 3" return end
    local m = findMob("Elite Pirate") or findMob("Elite Hunter")
    if m then targetFarm(m, "Elite")
    else X.Sub = "Elite · chờ spawn" hoverAt(CFrame.new(5259,37,4050).Position) end
end
local function collectMaterials()
    if not X.AutoMaterials then return end
    local list = MATERIALS[SEA] or MATERIALS[1]
    local hrp = getRoot() if not hrp then return end
    local found
    for _, n in ipairs(list) do
        local p = findGroundDrop(n)
        if p then found = p X.Sub = "Material · "..n break end
    end
    if found and dist(found.Position, hrp.Position) > 4 then
        teleportTo(CFrame.new(found.Position + Vector3.new(0,3,0)))
        task.wait(0.25)
    elseif not found then
        X.Sub = "Material · chờ drop"
        task.wait(0.5)
    end
end
local function runDungeonMode()
    if not X.AutoDungeon then return end
    local npc = CFrame.new(5259, 37, 4050)
    local hrp = getRoot() if not hrp then return end
    if dist(hrp.Position, npc.Position) > 30 then
        X.Sub = "Dungeon · tới NPC"
        moveTo(npc + Vector3.new(0,4,3))
        return
    end
    stopMoving()
    pcall(function() Invoke("Dungeon", "Start") end)
    pcall(function() Invoke("StartDungeon") end)
    X.Sub = "Dungeon · đang chạy"
    task.wait(1)
end
local function aimbotTick()
    if not X.Aimbot then return end
    local cam = S.WS.CurrentCamera
    local hrp = getRoot() if not hrp then return end
    local myPos = hrp.Position
    local sc = Vector2.new(VP.X/2, VP.Y/2)
    local best, bd
    for _, e in ipairs(enemies()) do
        if e.h.Health > 0 then
            local head = e.m:FindFirstChild("Head") or e.r
            local sp, onScreen = cam:WorldToViewportPoint(head.Position)
            if onScreen then
                local d = (Vector2.new(sp.X, sp.Y) - sc).Magnitude
                if d < X.AimbotFOV and dist(myPos, head.Position) < 1000 then
                    if not bd or d < bd then best, bd = head, d end
                end
            end
        end
    end
    if best then
        local tgt = CFrame.new(cam.CFrame.Position, best.Position)
        cam.CFrame = cam.CFrame:Lerp(tgt, math.clamp(X.AimbotSmooth, 0.05, 1))
    end
end
local function killAuraTick()
    if not X.KillAura then return end
    if tick() - X.LastAura < 0.05 then return end
    X.LastAura = tick()
    local hrp = getRoot() if not hrp then return end
    if not R.Hit or not R.Attack then return end
    local list = {} local first
    for _, e in ipairs(enemies()) do
        if e.h.Health > 0 and dist(e.r.Position, hrp.Position) <= X.AuraRange then
            if not first then first = e.m:FindFirstChild("Head") or e.r end
            list[#list+1] = { e.m, e.r }
            list[#list+1] = e.m
        end
    end
    if #list > 0 then
        pcall(function()
            R.Attack:FireServer(0)
            R.Hit:FireServer(first, list, nil, "")
        end)
    end
end

local FAST_PRESETS = {
    Legit={delay=0.060, burst=1}, Safe={delay=0.033, burst=1}, Normal={delay=0.016, burst=1},
    Fast={delay=0.008, burst=2}, Turbo={delay=0.000, burst=3}, Insane={delay=0.000, burst=5},
}
local function tryBuySkills()
    if not R.CommF then return end
    if X.AutoBuyGeppo then local c = LP.Character if c and not c:FindFirstChild("Geppo") then Invoke("BuyHaki","Geppo") end end
    if X.AutoBuySoru then local c = LP.Character if c and not c:FindFirstChild("Soru") then Invoke("BuyHaki","Soru") end end
    if X.AutoBuyKen then local c = LP.Character if c and not c:FindFirstChild("HasKen") then Invoke("BuyHaki","Ken") end end
end
local DEFAULT_CODES = {
    "Sub2CaptainMaui","kittgaming","Sub2Fer999","Enyu_is_Pro","Magicbus","JCWK","Starcodeheo","Bluxxy","fudd10_v2","fudd10","Bignews",
    "THEGREATACE","Sub2NoobMaster123","Sub2UncleKizaru","Sub2Daigrock","Axiore","TantaiGaming","StrawHatMaine","Sub2OfficialNoobie",
    "FountainDrip","Chandler","SECRET_ADMIN","ADMIN_SECRET","KITTGAMING","THEGREATACEBLASTER","GAMER_ROBOT_1M","FUDD10_HAHA",
    "DEVSCOOKING","SUB2GAMERROBOT_EXP1","FountainCity","SkyCity","Kingdom",
}
local function autoRedeem()
    if not X.AutoRedeem or X.Redeemed then return end
    X.Redeemed = true
    for _, c in ipairs(DEFAULT_CODES) do Invoke("Redeem", c) task.wait(0.35) end
    notify("Redeem", "Đã thử ".. #DEFAULT_CODES .." code", 5)
end
local function playerAlertTick()
    if not X.PlayerAlert then X.AlertedPlayers = {} return end
    local hrp = getRoot() if not hrp then return end
    for _, pl in ipairs(S.Players:GetPlayers()) do
        if pl ~= LP and pl.Character then
            local r = pl.Character:FindFirstChild("HumanoidRootPart")
            if r and dist(r.Position, hrp.Position) <= X.AlertRange then
                if not X.AlertedPlayers[pl] then
                    X.AlertedPlayers[pl] = true
                    notify("CẢNH BÁO", pl.Name.." lại gần ("..math.floor(dist(r.Position, hrp.Position)).."m)", 5)
                end
            else X.AlertedPlayers[pl] = nil end
        end
    end
end
local function timerTick()
    if X.TimerMin <= 0 or X.TimerStart <= 0 then return end
    if (tick() - X.TimerStart) / 60 >= X.TimerMin then
        X.TimerMin = 0 X.TimerStart = 0
        notify("Hẹn giờ", "Hết — rejoin.", 5)
        pcall(function() S.TP:Teleport(game.PlaceId, LP) end)
    end
end
local function rollFruitLoop()
    if not X.RollAuto then return end
    if tick() - X.LastRoll < 6 then return end
    X.LastRoll = tick()
    Invoke("Cousin", "Buy") task.wait(0.3)
    local inv = Invoke("GetFruits")
    if type(inv) ~= "table" then return end
    for _, f in ipairs(inv) do
        local nm = type(f) == "table" and (f.Name or f.name) or tostring(f)
        if fruitRarity(nm) >= X.RollMin then
            X.RollAuto = false
            notify("Roll", "Đã ra "..nm, 6)
            break
        end
    end
end
local function storeByNameTick()
    if #X.StoreNames == 0 then return end
    if tick() - X.LastStoreName < 5 then return end
    X.LastStoreName = tick()
    local inv = Invoke("GetFruits")
    if type(inv) ~= "table" then return end
    for _, f in ipairs(inv) do
        local nm = type(f) == "table" and (f.Name or f.name) or tostring(f)
        for _, want in ipairs(X.StoreNames) do
            if nm == want or nm:lower() == want:lower() then
                Invoke("StoreFruit", nm)
                X.Sub = "Kho · "..nm
                return
            end
        end
    end
end
local function sniperByNameTick()
    if X.FruitSniperName == "" or not X.FruitSniper then return end
    for _, f in ipairs(scanFruits()) do
        if f.name == X.FruitSniperName or f.name:lower() == X.FruitSniperName:lower() then
            local hrp = getRoot()
            if hrp and dist(f.pos, hrp.Position) < 6000 and tick() - X.LastSniper > 1.5 then
                X.LastSniper = tick()
                teleportTo(CFrame.new(f.pos))
                X.Sub = "Sniper · "..f.name
                return
            end
        end
    end
end
local AWAKEN_CMDS = {"AwakeFruit","AwakenFruit","Awakening"}
local function awakenTick()
    if not X.AutoAwaken or X.AwakenFruit == "" then return end
    if tick() - X.LastAwake < 8 then return end
    X.LastAwake = tick()
    for _, cmd in ipairs(AWAKEN_CMDS) do pcall(function() Invoke(cmd, X.AwakenFruit) end) end
end
local function raceV4Tick()
    if not X.RaceV4 then return end
    if SEA ~= 3 then X.Sub = "Race V4 · cần Sea 3" return end
    local hrp = getRoot() if not hrp then return end
    local tp = Vector3.new(-21748, 90, 454)
    if dist(hrp.Position, tp) > 50 then moveTo(CFrame.new(tp)) X.Sub = "Race V4 · tới Trial" return end
    stopMoving()
    pcall(function() Invoke("RaceV4") end)
    pcall(function() Invoke("StartRaceV4") end)
    X.Sub = "Race V4 · thử trial"
end
local function runDarkbeard()
    if not X.AutoDarkbeard then return end
    local b = findBoss("Darkbeard")
    if b then targetFarm(b, "Darkbeard")
    else X.Sub = "Darkbeard · chờ spawn" hoverAt(CFrame.new(-13234,331,-7625).Position) end
end
local function runOrder()
    if not X.AutoOrder then return end
    local b = findBoss("Order")
    if b then targetFarm(b, "Order")
    else X.Sub = "Order · chờ spawn" hoverAt(CFrame.new(-14408,340,-7916).Position) end
end
local function runRipIndra()
    if not X.AutoRipIndra then return end
    local b = findBoss("Rip_indra") or findBoss("rip_indra")
    if b then targetFarm(b, "Rip Indra")
    else X.Sub = "Rip Indra · chờ spawn" hoverAt(CFrame.new(-16565,104,1579).Position) end
end
local SEA_BEASTS = {"Terror Shark","Sea Beast","Island Eater","Sea Serpent"}
local SEA_EVENT_BOSSES = {"Stone","Hydra Leader","Beautiful Pirate","Longma","Trial of God","Cake Queen","Cursed Captain","Soul Reaper"}
local function seaBeastTick()
    if not X.AutoSeaBeast then return end
    for _, n in ipairs(SEA_BEASTS) do
        local b = findBoss(n)
        if b then targetFarm(b, "Sea Beast") return end
    end
    X.Sub = "Sea Beast · chờ"
end
local function seaEventTick()
    if not X.AutoSeaEvent then return end
    for _, n in ipairs(SEA_EVENT_BOSSES) do
        local b = findBoss(n)
        if b then targetFarm(b, "Sea Event") return end
    end
    X.Sub = "Sea Event · chờ"
end
local BOSS_RESPAWN = { ["Darkbeard"]=60,["Order"]=60,["Rip_indra"]=60,["Cake Prince"]=90,["Dough King"]=120,["Soul Reaper"]=120,["Cursed Captain"]=60,["Stone"]=30,["Hydra Leader"]=30 }
local function updateBossTimers()
    if X.Destroyed then return end
    local seen = {}
    for _, e in ipairs(enemies()) do
        if e.h.MaxHealth >= 5000 then seen[e.m.Name] = true X._lastBossSeen[e.m.Name] = true end
    end
    for name in pairs(X._lastBossSeen) do
        if not seen[name] then
            X.BossTimers[name] = tick() + (BOSS_RESPAWN[name] or 60)
            X._lastBossSeen[name] = nil
        end
    end
end
local function discord(msg)
    if X.DiscordURL == "" then return end
    task.spawn(function()
        pcall(function()
            local req = request or http_request or (syn and syn.request)
            if req then
                req({ Url=X.DiscordURL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=S.Http:JSONEncode({ content="**HL HUB** "..msg }) })
            end
        end)
    end)
end

--====================================================================================
-- SERVER HOP + CONFIG
--====================================================================================
local function serverHopPing()
    St.Sub = "Hop · tìm server"
    local list, cursor = {}, ""
    for _ = 1, 3 do
        local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100%s"):format(game.PlaceId, cursor ~= "" and ("&cursor="..cursor) or "")
        local ok, d = pcall(function() return S.Http:JSONDecode(game:HttpGet(url)) end)
        if not ok or type(d) ~= "table" or not d.data then break end
        for _, srv in ipairs(d.data) do
            if srv.id ~= game.JobId and not St.HopVisited[srv.id]
                and srv.playing and srv.maxPlayers and srv.playing > 0 and srv.playing < srv.maxPlayers-1
                and (not srv.ping or srv.ping <= St.HopPingMax) then list[#list+1] = srv end
        end
        cursor = d.nextPageCursor or ""
        if cursor == "" or #list >= 10 then break end
    end
    if #list == 0 then notify("Server Hop", "Không tìm thấy server phù hợp", 4) return end
    table.sort(list, function(a,b) return (a.ping or 999) < (b.ping or 999) end)
    local pick = list[math.random(1, math.min(3, #list))]
    St.HopVisited[pick.id] = true
    pcall(function() S.TP:TeleportToPlaceInstance(game.PlaceId, pick.id, LP) end)
end

local CFG_KEYS = {"AutoQuest","AutoHaki","BringMobs","BringRange","BringRate","AutoEquip","EquipType","AttackRange","Hover","Speed","FarTP","WalkSpeed","AtkDelay","AtkBurst","SafeMode","SafeHP","RaidChip","AutoBuyChip","AutoClearRaid","FlySpeed","FruitMinRarity","StoreMinRarity","AntiStuck","MobTimeout","AutoSkill","HopPingMax","AutoBuyHaki","ESPRange","AutoStats","StatType","Lang","Theme","Profile","AutoBones","AutoDough","AutoElite","AutoEcto","AutoMastery","AutoMaterials","RegionFarm","RegionName","Aimbot","AimbotFOV","AimbotSmooth","FastMode","KillAura","AuraRange","AutoBuyGeppo","AutoBuySoru","AutoBuyKen","AutoRedeem","PlayerAlert","AlertRange","AutoRejoin","TimerMin","DiscordURL","FruitSniperName","AwakenFruit","AutoAwaken","RaceV4","AutoDarkbeard","AutoOrder","AutoRipIndra","AutoDungeon","AutoSeaBeast","AutoSeaEvent","RollMin","StoreNames","MasteryTarget","SpecialQuest","AutoFish","AutoBuyBait","SilentAim","SilentAimPlayer","Tracer","TargetLowestHP","FovCircle","WaterWalk","BypassSpeed","BypassSpeedMul","AutoBerry","AutoCollectHop","IslandName","AntiAFK"}
local function saveConfig()
    pcall(function()
        if not writefile then return end
        local t = { SkillCD=St.SkillCD }
        for _, k in ipairs(CFG_KEYS) do t[k] = St[k] end
        writefile(CFG_FILE, S.Http:JSONEncode(t))
    end)
end
local function loadConfig()
    pcall(function()
        if not (readfile and isfile and isfile(CFG_FILE)) then return end
        local t = S.Http:JSONDecode(readfile(CFG_FILE))
        for k, v in pairs(t) do if St[k] ~= nil and type(v) == type(St[k]) then St[k] = v end end
    end)
    MOVE.Speed = St.Speed
end
loadConfig()

--====================================================================================
-- MAIN LOOP
--====================================================================================
local function logBoss(name)
    St.BossKillLog[#St.BossKillLog+1] = { name=name, at=os.date("%H:%M:%S") }
    notify("Boss", name.." đã biến mất", 5)
end

local function doFarmLoop()
    local lv = myLevel()
    St.MyLevel = lv
    local info = getQuestInfo()
    if info then
        local row = getQuestRowFromTitle(info.title) or pickTarget(lv)
        St.CurrentMobName = row[2]
        St.Sub = string.format("%s (%d/%d)", row[2], info.cur, info.max)
        if info.cur < info.max then
            local mob, mobDist
            local hrp = getRoot()
            if hrp then
                for _, e in ipairs(enemies()) do
                    if e.m.Name == row[2] and e.h.Health > 0 then
                        local d = dist(e.r.Position, hrp.Position)
                        if not mobDist or d < mobDist then mob, mobDist = e.m, d end
                    end
                end
            end
            if mob then
                if not hrp then return end
                local mrp = mob:FindFirstChild("HumanoidRootPart")
                if mrp then
                    local tp = mrp.Position + Vector3.new(0, St.Hover, 0)
                    local md = dist(hrp.Position, tp)
                    if md > 15 then
                        if md > 400 then teleportTo(tp) else moveTo(tp, St.Speed) end
                    else stopMoving() hrp.CFrame = CFrame.new(tp) end
                end
                equipWeapon()
            else
                local gp = Vector3.new(row[3], row[4], row[5])
                if hrp and dist(hrp.Position, gp) > 40 then
                    St.Sub = "→ vùng "..row[2]
                    moveTo(gp + Vector3.new(0, St.Hover, 0), St.Speed)
                else St.Sub = "Chờ mob "..row[2] task.wait(0.3) end
            end
            return
        end
        if St.QuestCompletedAt == 0 then St.QuestCompletedAt = tick() end
        local el = tick() - St.QuestCompletedAt
        if el < 1.5 then
            St.Sub = string.format("✓ Xong (%d/%d) · đánh thêm %.1fs", info.cur, info.max, 1.5-el)
            local mob
            for _, e in ipairs(enemies()) do if e.m.Name == row[2] and e.h.Health > 0 then mob = e.m break end end
            if mob then
                local mrp = mob:FindFirstChild("HumanoidRootPart")
                if mrp then
                    local hrp = getRoot()
                    if hrp and dist(hrp.Position, mrp.Position) > 15 then
                        if dist(hrp.Position, mrp.Position) > 400 then teleportTo(mrp.Position + Vector3.new(0, St.Hover, 0))
                        else moveTo(mrp.Position + Vector3.new(0, St.Hover, 0), St.Speed) end
                    else stopMoving() end
                end
                equipWeapon()
            end
            task.wait(0.1)
            return
        end
        St.QuestCompletedAt = 0
        St.Sub = "Chuẩn bị nhận quest mới..."
        task.wait(0.2)
        return
    end
    St.QuestCompletedAt = 0
    if not St.AutoQuest then St.Sub = "Idle · không có quest" task.wait(0.5) return end
    local row = pickTarget(lv)
    St.CurrentMobName = row[2]
    if tick() - St.LastQuestTry > 2 then
        tryAcceptQuest(row)
    else
        St.Sub = "→ NPC "..row[6]
        local gp = Vector3.new(row[3], row[4], row[5])
        local hrp = getRoot()
        if hrp and dist(hrp.Position, gp) > 35 then
            if dist(hrp.Position, gp) > 400 then teleportTo(gp + Vector3.new(0,5,3))
            else moveTo(gp + Vector3.new(0,5,3), 400) end
        end
    end
end

local function extStep()
    if X.Destroyed then return false end
    if X.AutoFish then autoFishTick() return true end
    if X.AutoFactoryRaid then factoryRaidTick() return true end
    if X.AutoPirateRaid then pirateRaidTick() return true end
    if X.AutoHakiPad then hakiPadTick() return true end
    if X.AutoRipIndraAttack then ripIndraAttackTick() return true end
    if X.AutoSoulReaper then soulReaperTick() return true end
    if X.AutoDoughKing then doughKingTick() return true end
    if X.AutoMagnetEvent then magnetEventTick() return true end
    if X.AutoGachaMagnet then gachaMagnetTick() return true end
    if X.TryLuckyGrave then tryLuckyGraveTick() return true end
    if X.AutoSpecialQuest then specialQuestTick() return true end
    if X.AutoMastery then masteryFarmTick() return true end
    if X.AutoCompleteQuest then completeQuestTick() return true end
    if X.AutoBerry then autoBerryTick() return true end
    if X.AutoCollectHop then collectHopTick() return true end
    if X.IslandTP then islandTeleportTick() return true end
    return false
end

local function step()
    local h = getHum()
    if St.Panic then St.Attacking = false St.Sub = "PANIC" task.wait(0.5) return end
    if not h or h.Health <= 0 then St.Attacking = false St.Sub = "Chết" task.wait(1) return end
    if St.SafeMode and h.MaxHealth > 0 and h.Health / h.MaxHealth * 100 < St.SafeHP then St.Attacking = false St.Sub = "Safe" task.wait(0.5) return end
    St.Attacking = true
    St.MyLevel = myLevel()
    checkHaki() autoBuyHakiTick() antiStuckTick()

    if extStep() then task.wait(St.LoopDelay) return end

    if St.AutoRipIndra then runRipIndra() return end
    if St.AutoOrder then runOrder() return end
    if St.AutoDarkbeard then runDarkbeard() return end
    if St.AutoSeaEvent then seaEventTick() return end
    if St.AutoSeaBeast then seaBeastTick() return end
    if St.AutoDungeon then runDungeonMode() return end
    if St.AutoMagnet then magnetEventTick() return end
    if St.AutoDough then runDoughFarm() return end
    if St.AutoElite then runEliteFarm() return end
    if St.AutoBones then runBonesFarm() return end
    if St.AutoEcto then runEctoFarm() return end
    if St.AutoMaterials then collectMaterials() return end
    if St.RegionFarm then runRegionFarm() return end
    if St.RaceV4 then raceV4Tick() return end

    if St.AutoRaid then
        St.TargetName = nil
        if St.AutoClearRaid and RaidFns.inRaid() then RaidFns.clear()
        elseif RaidFns.hasChip() and not RaidFns.inRaid() then RaidFns.start()
        elseif St.AutoBuyChip and not RaidFns.hasChip() then RaidFns.buy()
        else St.Sub = "Raid · chờ" end
    elseif St.AutoBoss then
        local b = findBoss(GUI_State.SelectedBoss)
        if b then St.BossSeen = GUI_State.SelectedBoss targetFarm(b, "Boss")
        else
            if St.BossSeen then logBoss(St.BossSeen) St.BossSeen = nil end
            St.Sub = "Boss · chờ spawn" task.wait(0.5)
        end
    elseif St.AutoNearest then
        local m = findNearest(3000)
        if m then targetFarm(m, "Gần nhất") else St.Sub = "Gần nhất · không có" St.TargetName = nil task.wait(0.4) end
    elseif St.AutoSpecific then
        local m = findMob(GUI_State.SelectedMob)
        if m then targetFarm(m, "Mob chỉ định") else St.Sub = "Mob chỉ định · không có" task.wait(0.4) end
    elseif St.AutoChest then
        St.TargetName = nil
        runChestFarm()
    elseif St.AutoFarm then
        doFarmLoop()
    end
    task.wait(St.LoopDelay)
end

local function mainLoop()
    while anyMode() and not St.Destroyed do
        local ok, err = pcall(step)
        if not ok then warn("[HL] "..tostring(err)) task.wait(0.5) end
    end
    St.Attacking = false St.Sub = "Idle" St.TargetName = nil
    stopMoving() cleanBring()
end
local UI = {}
UI.upd = function()
    if anyMode() and not St.Running and not St.Destroyed then
        St.Running = true
        task.spawn(function() mainLoop() St.Running = false end)
    end
end

--====================================================================================
-- THREADS
--====================================================================================
do
    local lastAtk = 0
    conn(S.Run.Heartbeat, function()
        if St.Destroyed or St.Panic or not St.Attacking then return end
        if St.KillAura then return end -- Tránh đánh đúp khi KillAura bật
        local now = tick()
        if now - lastAtk < St.AtkDelay then return end
        lastAtk = now
        for _ = 1, math.max(1, St.AtkBurst) do doAttack() end
    end)
end
task.spawn(function()
    pcall(function() sethiddenproperty(LP, "SimulationRadius", math.huge) end)
    while not St.Destroyed do
        task.wait(math.max(0.05, St.BringRate))
        if St.Attacking and St.BringMobs and not St.Panic and not St.AutoRaid then pcall(bringMobs) end
    end
end)
task.spawn(function()
    while not St.Destroyed do task.wait(0.1) if St.Attacking and not St.Panic then pcall(autoSkillTick) end end
end)
task.spawn(function()
    while not St.Destroyed do
        task.wait(3)
        if St.AutoStats and R.CommF and not St.Panic then task.spawn(function() Invoke("AddPoint", St.StatType, 3) end) end
    end
end)
task.spawn(function()
    while not St.Destroyed do task.wait(0.5) if not St.Panic then pcall(tickFruit) end end
end)
task.spawn(function()
    while not St.Destroyed do task.wait(0.6) if not St.Panic then pcall(espUpdate) end end
end)
task.spawn(function()
    while not St.Destroyed do
        task.wait(0.02)
        if St.Attacking or St.KillAura then pcall(aimbotTick) pcall(killAuraTick) end
        if X.SilentAim then pcall(silentAimTick) end
        if X.WaterWalk then pcall(waterWalkTick) end
        if X.BypassSpeed then pcall(bypassSpeedTick) end
        pcall(drawFovCircle)
    end
end)
task.spawn(function()
    while not St.Destroyed do
        task.wait(0.5)
        pcall(tryBuySkills) pcall(playerAlertTick) pcall(timerTick)
        pcall(storeByNameTick) pcall(sniperByNameTick) pcall(awakenTick)
        pcall(rollFruitLoop) pcall(autoRedeem)
    end
end)
task.spawn(function()
    while not St.Destroyed do task.wait(1) pcall(updateBossTimers) end
end)
task.spawn(function()
    while not St.Destroyed do
        task.wait(60)
        if X.AntiAFK then
            pcall(function() S.VU:CaptureController() S.VU:ClickButton2(Vector2.new()) end)
        end
    end
end)
conn(S.Players.PlayerRemoving, function(pl)
    if pl == LP and X.AutoRejoin then
        task.wait(2)
        pcall(function() S.TP:Teleport(game.PlaceId, LP) end)
    end
end)
conn(LP.Idled, function()
    pcall(function() S.VU:CaptureController() S.VU:ClickButton2(Vector2.new()) end)
end)
conn(S.Run.Heartbeat, function()
    if St.Destroyed then return end
    local cnt = #enemies()
    if St._lastEnemyCount and cnt < St._lastEnemyCount then
        St.StatKills = St.StatKills + (St._lastEnemyCount - cnt)
    end
    St._lastEnemyCount = cnt
end)

--====================================================================================
-- UI
--====================================================================================
do
local T = {
    bg0=Color3.fromRGB(6,8,14), bg1=Color3.fromRGB(12,15,22),
    bg2=Color3.fromRGB(18,22,34), bg3=Color3.fromRGB(26,32,48),
    txt=Color3.fromRGB(240,244,255), dim=Color3.fromRGB(150,158,185),
    fnt=Color3.fromRGB(78,88,112),
    acc=Color3.fromRGB(255,200,90), hot=Color3.fromRGB(255,230,160),
    vio=Color3.fromRGB(200,150,255),
    ok=Color3.fromRGB(72,235,168), warn=Color3.fromRGB(255,200,110),
    bad=Color3.fromRGB(255,100,115),
    border=Color3.fromRGB(30,38,54), border2=Color3.fromRGB(56,66,90),
}
local F = { black=Enum.Font.GothamBlack, bold=Enum.Font.GothamBold, med=Enum.Font.GothamMedium, reg=Enum.Font.Gotham, mono=Enum.Font.Code }
local function mk(c, p)
    local o = Instance.new(c)
    for k, v in pairs(p) do if k ~= "Parent" and k ~= "Children" then pcall(function() o[k] = v end) end end
    if p.Children then for _, c2 in ipairs(p.Children) do c2.Parent = o end end
    o.Parent = p.Parent
    return o
end
local function tw(o, t, p, s, d) S.Tween:Create(o, TweenInfo.new(t, s or Enum.EasingStyle.Quint, d or Enum.EasingDirection.Out), p):Play() end
local function corner(o, r) mk("UICorner", { CornerRadius=UDim.new(0, r or 8), Parent=o }) end
local function stroke(o, c, t, tr) return mk("UIStroke", { Color=c or T.acc, Thickness=t or 1, Transparency=tr or 0.4, ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=o }) end
local ORD = {}
local function nx(par) ORD[par] = (ORD[par] or 0) + 1 return ORD[par] end

local sg = mk("ScreenGui", { Name="HL_Hub", ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=GUI, DisplayOrder=60 })
local reopen = mk("TextButton", { Size=UDim2.new(0,110,0,34), Position=UDim2.new(0,14,0,170), BackgroundColor3=T.acc, Text="HOÀNG LÂM", Font=F.black, TextSize=13, TextColor3=T.bg0, Visible=false, Parent=sg })
corner(reopen, 10); stroke(reopen, T.hot, 1.5, 0.3)

local W = MOBILE and math.min(440, VP.X - 20) or 660
local H = MOBILE and math.min(440, VP.Y - 80) or 470

local main = mk("Frame", { Size=UDim2.new(0,W,0,H), Position=UDim2.new(0.5,-W/2,0.5,-H/2), BackgroundColor3=T.bg0, BorderSizePixel=0, Active=true, ClipsDescendants=true, Parent=sg })
corner(main, 20); stroke(main, T.border2, 1, 0.4)
local topGrad = mk("Frame", { Size=UDim2.new(1,-40,0,2), Position=UDim2.new(0,20,0,0), BackgroundColor3=T.acc, BorderSizePixel=0, Parent=main })
mk("UIGradient", { Color=ColorSequence.new({ ColorSequenceKeypoint.new(0,T.bg0), ColorSequenceKeypoint.new(0.35,T.acc), ColorSequenceKeypoint.new(0.7,T.vio), ColorSequenceKeypoint.new(1,T.bg0) }), Parent=topGrad })
local glow = mk("Frame", { Size=UDim2.new(0,340,0,340), Position=UDim2.new(1,-170,0,-170), BackgroundColor3=T.acc, BackgroundTransparency=0.92, BorderSizePixel=0, Parent=main })
corner(glow, 999)

local header = mk("Frame", { Size=UDim2.new(1,0,0,66), BackgroundColor3=T.bg1, BackgroundTransparency=0.15, BorderSizePixel=0, Parent=main })
corner(header, 20)
mk("Frame", { Size=UDim2.new(1,0,0.5,0), Position=UDim2.new(0,0,0.5,0), BackgroundColor3=T.bg1, BackgroundTransparency=0.15, BorderSizePixel=0, Parent=header })
local logo = mk("Frame", { Size=UDim2.new(0,42,0,42), Position=UDim2.new(0,18,0.5,-21), BackgroundColor3=T.bg3, BorderSizePixel=0, Parent=header })
corner(logo, 12); stroke(logo, T.acc, 1, 0.3)
mk("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="HL", Font=F.black, TextSize=18, TextColor3=T.hot, Parent=logo })
mk("TextLabel", { Size=UDim2.new(0,200,0,20), Position=UDim2.new(0,74,0,14), BackgroundTransparency=1, Text=AUTHOR.brand.." "..AUTHOR.version, Font=F.black, TextSize=15, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=header })
mk("TextLabel", { Size=UDim2.new(0,200,0,15), Position=UDim2.new(0,74,0,36), BackgroundTransparency=1, Text="BY "..AUTHOR.name:upper().." · ZALO "..AUTHOR.zalo, Font=F.reg, TextSize=9, TextColor3=T.fnt, TextXAlignment=Enum.TextXAlignment.Left, Parent=header })
local pill = mk("Frame", { Size=UDim2.new(0,90,0,28), Position=UDim2.new(1,-160,0.5,-14), BackgroundColor3=T.bg2, BorderSizePixel=0, Parent=header })
corner(pill, 999)
local pillStroke = stroke(pill, T.border2, 1, 0.4)
local pillDot = mk("Frame", { Size=UDim2.new(0,8,0,8), Position=UDim2.new(0,12,0.5,-4), BackgroundColor3=T.fnt, BorderSizePixel=0, Parent=pill })
corner(pillDot, 999)
local pillText = mk("TextLabel", { Size=UDim2.new(1,-24,1,0), Position=UDim2.new(0,24,0,0), BackgroundTransparency=1, Text="IDLE", Font=F.bold, TextSize=11, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=pill })
local minBtn = mk("TextButton", { Size=UDim2.new(0,32,0,32), Position=UDim2.new(1,-76,0.5,-16), BackgroundColor3=T.bg3, BorderSizePixel=0, Text="—", Font=F.bold, TextSize=16, TextColor3=T.txt, Parent=header })
corner(minBtn, 10)
local closeBtn = mk("TextButton", { Size=UDim2.new(0,32,0,32), Position=UDim2.new(1,-40,0.5,-16), BackgroundColor3=T.bg3, BorderSizePixel=0, Text="✕", Font=F.bold, TextSize=15, TextColor3=T.txt, Parent=header })
corner(closeBtn, 10)

local body = mk("Frame", { Size=UDim2.new(1,0,1,-66), Position=UDim2.new(0,0,0,66), BackgroundTransparency=1, Parent=main })
local sidebar = mk("Frame", { Size=UDim2.new(0,150,1,-24), Position=UDim2.new(0,12,0,12), BackgroundColor3=T.bg1, BackgroundTransparency=0.3, BorderSizePixel=0, Parent=body })
corner(sidebar, 14); stroke(sidebar, T.border, 1, 0.5)
local sidebarScroll = mk("ScrollingFrame", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=3, ScrollBarImageColor3=T.border2, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ElasticBehavior=Enum.ElasticBehavior.Never, Parent=sidebar })
mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder, Parent=sidebarScroll })
mk("UIPadding", { PaddingTop=UDim.new(0,10), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8), PaddingBottom=UDim.new(0,10), Parent=sidebarScroll })
local pageHolder = mk("Frame", { Size=UDim2.new(1,-186,1,-24), Position=UDim2.new(0,174,0,12), BackgroundColor3=T.bg1, BackgroundTransparency=0.3, BorderSizePixel=0, Parent=body })
corner(pageHolder, 14); stroke(pageHolder, T.border, 1, 0.5)

local pages, tabBtns = {}, {}
local function newTab(label, order, key)
    local b = mk("TextButton", { Size=UDim2.new(1,0,0,26), BackgroundColor3=T.bg2, BackgroundTransparency=0.5, BorderSizePixel=0, Text="", AutoButtonColor=false, LayoutOrder=order, Parent=sidebarScroll })
    corner(b, 8)
    local ind = mk("Frame", { Size=UDim2.new(0,3,0,12), Position=UDim2.new(0,5,0.5,-6), BackgroundColor3=T.acc, BorderSizePixel=0, Visible=false, Parent=b })
    corner(ind, 999)
    local dot = mk("Frame", { Size=UDim2.new(0,5,0,5), Position=UDim2.new(0,14,0.5,-2.5), BackgroundColor3=T.fnt, BorderSizePixel=0, Parent=b })
    corner(dot, 999)
    local lbl = mk("TextLabel", { Size=UDim2.new(1,-30,1,0), Position=UDim2.new(0,24,0,0), BackgroundTransparency=1, Text=label, Font=F.med, TextSize=10, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=b })
    tabBtns[key] = { btn=b, ind=ind, dot=dot, lbl=lbl }
end
local function newPage(key)
    local p = mk("Frame", { Name=key, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false, Parent=pageHolder })
    local sc = mk("ScrollingFrame", { Size=UDim2.new(1,-18,1,-18), Position=UDim2.new(0,9,0,9), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=3, ScrollBarImageColor3=T.border2, ScrollBarImageTransparency=0.3, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ElasticBehavior=Enum.ElasticBehavior.Never, Parent=p })
    mk("UIListLayout", { Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder, Parent=sc })
    pages[key] = { root=p, scroll=sc }
    return sc
end

local pageNames = {"Home","Farm","Dungeon","Fruit","Attack","Raid","Misc","FPS","Ext","Event","Utils","Fish","Mastery","Quest","PvP","Island","About"}
local pageRefs = {}
for i, k in ipairs(pageNames) do
    pageRefs[k] = newPage(k)
    newTab(k, i, k)
end
local scHome = pageRefs.Home
local scFarm = pageRefs.Farm
local scDungeon = pageRefs.Dungeon
local scFruit = pageRefs.Fruit
local scAttack = pageRefs.Attack
local scRaid = pageRefs.Raid
local scMisc = pageRefs.Misc
local scFPS = pageRefs.FPS
local scExt = pageRefs.Ext
local scEvent = pageRefs.Event
local scUtils = pageRefs.Utils
local scFish = pageRefs.Fish
local scMastery = pageRefs.Mastery
local scQuest = pageRefs.Quest
local scPvP = pageRefs.PvP
local scIsland = pageRefs.Island
local scAbout = pageRefs.About

local function sec(par, txt)
    local w = mk("Frame", { Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, LayoutOrder=nx(par), Parent=par })
    mk("TextLabel", { Size=UDim2.new(1,0,0,14), BackgroundTransparency=1, Text=txt, Font=F.bold, TextSize=10, TextColor3=T.fnt, TextXAlignment=Enum.TextXAlignment.Left, Parent=w })
    mk("Frame", { Size=UDim2.new(0,22,0,2), Position=UDim2.new(0,0,0,16), BackgroundColor3=T.acc, BorderSizePixel=0, Parent=w })
    return w
end
local function glass(par, props, r)
    props.Parent = props.Parent or par
    props.LayoutOrder = props.LayoutOrder or nx(props.Parent)
    local f = mk("Frame", props)
    corner(f, r or 10); stroke(f, T.border2, 1, 0.5)
    return f
end
local function toggle(par, label, desc, def, cb)
    local h = desc and desc ~= ""
    local w = glass(par, { Size=UDim2.new(1,0,0, h and 66 or 50), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
    mk("TextLabel", { Size=UDim2.new(1,-90,0,18), Position=UDim2.new(0,14,0,10), BackgroundTransparency=1, Text=label, Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=w })
    if h then mk("TextLabel", { Size=UDim2.new(1,-90,0,28), Position=UDim2.new(0,14,0,30), BackgroundTransparency=1, Text=desc, Font=F.reg, TextSize=10, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextWrapped=true, Parent=w }) end
    local tr = mk("Frame", { Size=UDim2.new(0,42,0,22), Position=UDim2.new(1,-58,0.5,-11), BackgroundColor3=def and T.ok or T.bg3, BorderSizePixel=0, Parent=w })
    corner(tr, 999)
    local tS = stroke(tr, def and T.ok or T.border2, 1, 0.3)
    local kn = mk("Frame", { Size=UDim2.new(0,16,0,16), Position=def and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, Parent=tr })
    corner(kn, 999)
    local st = def and true or false
    local function paint()
        kn.Position = st and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
        tr.BackgroundColor3 = st and T.ok or T.bg3
        tS.Color = st and T.ok or T.border2
    end
    mk("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", Parent=w }).MouseButton1Click:Connect(function()
        st = not st St.Panic = false paint() if cb then pcall(cb, st) end
    end)
    return { set = function(v) v = v and true or false if st ~= v then st = v paint() if cb then pcall(cb, st) end end end, get = function() return st end }
end
local function slider(par, label, desc, mn, mx, def, un, cb, step)
    step = step or 1
    local h = desc and desc ~= ""
    local w = glass(par, { Size=UDim2.new(1,0,0, h and 82 or 62), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
    mk("TextLabel", { Size=UDim2.new(1,-130,0,18), Position=UDim2.new(0,14,0,10), BackgroundTransparency=1, Text=label, Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=w })
    local vl = mk("TextLabel", { Size=UDim2.new(0,110,0,18), Position=UDim2.new(1,-124,0,10), BackgroundTransparency=1, Text=tostring(def)..(un or ""), Font=F.mono, TextSize=11, TextColor3=T.hot, TextXAlignment=Enum.TextXAlignment.Right, Parent=w })
    if h then mk("TextLabel", { Size=UDim2.new(1,-28,0,26), Position=UDim2.new(0,14,0,30), BackgroundTransparency=1, Text=desc, Font=F.reg, TextSize=10, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextWrapped=true, Parent=w }) end
    local th = mk("Frame", { Size=UDim2.new(1,-28,0,20), Position=UDim2.new(0,14,0, h and 56 or 38), BackgroundTransparency=1, Parent=w })
    local tb = mk("Frame", { Size=UDim2.new(1,0,0,6), Position=UDim2.new(0,0,0.5,-3), BackgroundColor3=T.bg3, BorderSizePixel=0, Parent=th })
    corner(tb, 999)
    local r0 = math.clamp((def-mn)/math.max(1e-9,mx-mn), 0, 1)
    local fl = mk("Frame", { Size=UDim2.new(r0,0,1,0), BackgroundColor3=T.acc, BorderSizePixel=0, Parent=tb })
    corner(fl, 999)
    local kn = mk("Frame", { Size=UDim2.new(0,16,0,16), Position=UDim2.new(r0,0,0.5,0), AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=3, Parent=th })
    corner(kn, 999); stroke(kn, T.acc, 2, 0.2)
    local dragging = false
    local function apply(v)
        v = math.clamp(math.floor(v/step+0.5)*step, mn, mx)
        local r = (v-mn)/math.max(1e-9,mx-mn)
        fl.Size = UDim2.new(r,0,1,0)
        kn.Position = UDim2.new(r,0,0.5,0)
        vl.Text = tostring(math.floor(v*100+0.5)/100)..(un or "")
        if cb then pcall(cb, v) end
    end
    local function upd(ax)
        local tx, tw2 = tb.AbsolutePosition.X, tb.AbsoluteSize.X
        if tw2 <= 0 then return end
        apply(mn + math.clamp((ax-tx)/tw2, 0, 1) * (mx-mn))
    end
    th.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true upd(i.Position.X) end
    end)
    conn(S.UIS.InputChanged, function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then upd(i.Position.X) end
    end)
    conn(S.UIS.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    return { set = apply }
end
local function segments(par, label, opts, def, cb)
    local w = glass(par, { Size=UDim2.new(1,0,0,74), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
    mk("TextLabel", { Size=UDim2.new(1,-28,0,18), Position=UDim2.new(0,14,0,10), BackgroundTransparency=1, Text=label, Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=w })
    local row = mk("Frame", { Size=UDim2.new(1,-28,0,32), Position=UDim2.new(0,14,0,34), BackgroundColor3=T.bg3, BorderSizePixel=0, Parent=w })
    corner(row, 8)
    mk("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder, VerticalAlignment=Enum.VerticalAlignment.Center, Parent=row })
    mk("UIPadding", { PaddingLeft=UDim.new(0,3), PaddingRight=UDim.new(0,3), Parent=row })
    local btns, cur = {}, def
    local function paint()
        for n, b in pairs(btns) do
            local on = n == cur
            b.BackgroundColor3 = on and T.acc or T.bg3
            b.TextColor3 = on and T.bg0 or T.dim
        end
    end
    for i, opt in ipairs(opts) do
        local b = mk("TextButton", { Size=UDim2.new(1/#opts,-3,1,-6), BackgroundColor3=cur==opt and T.acc or T.bg3, BorderSizePixel=0, Text=opt, Font=F.bold, TextSize=11, TextColor3=cur==opt and T.bg0 or T.dim, AutoButtonColor=false, LayoutOrder=i, Parent=row })
        corner(b, 6); btns[opt] = b
        b.MouseButton1Click:Connect(function() cur = opt paint() if cb then pcall(cb, opt) end end)
    end
    paint()
    return { set = function(v) cur = v paint() if cb then pcall(cb, v) end end }
end
local openDropdown = nil
local function dropdown(par, label, opts, def, cb)
    local w = glass(par, { Size=UDim2.new(1,0,0,66), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0, ZIndex=10 })
    w.ClipsDescendants = false
    local function norm(e)
        if type(e) == "table" then return { display=e.display or e.value, value=e.value or e.display } end
        return { display=e, value=e }
    end
    local nd = {}
    for _, e in ipairs(opts) do nd[#nd+1] = norm(e) end
    local dN = norm(def)
    for _, o in ipairs(nd) do if o.value == dN.value then dN = o break end end
    mk("TextLabel", { Size=UDim2.new(1,-140,0,18), Position=UDim2.new(0,14,0,10), BackgroundTransparency=1, Text=label, Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11, Parent=w })
    local curLabel = mk("TextLabel", { Size=UDim2.new(0,130,0,18), Position=UDim2.new(1,-136,0,10), BackgroundTransparency=1, Text=tostring(dN.display), Font=F.mono, TextSize=11, TextColor3=T.hot, TextXAlignment=Enum.TextXAlignment.Right, TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=11, Parent=w })
    local row = mk("Frame", { Size=UDim2.new(1,-28,0,32), Position=UDim2.new(0,14,0,34), BackgroundColor3=T.bg3, BorderSizePixel=0, ZIndex=11, Parent=w })
    corner(row, 8); stroke(row, T.border2, 1, 0.4)
    mk("TextLabel", { Size=UDim2.new(0,20,1,0), Position=UDim2.new(1,-24,0,0), BackgroundTransparency=1, Text="▾", Font=F.bold, TextSize=12, TextColor3=T.dim, ZIndex=12, Parent=row })
    local cur = { display=dN.display, value=dN.value }
    local btn = mk("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=12, Parent=row })
    local function close() if openDropdown and openDropdown.Parent then openDropdown:Destroy() end openDropdown = nil end
    btn.MouseButton1Click:Connect(function()
        if openDropdown and openDropdown.Parent and openDropdown:GetAttribute("Owner") == label then close() return end
        close()
        local listH = math.min(170, VP.Y * 0.35)
        local list = mk("ScrollingFrame", { Name="HL_DropList", Size=UDim2.new(0, row.AbsoluteSize.X, 0, listH), Position=UDim2.new(0, row.AbsolutePosition.X - sg.AbsolutePosition.X, 0, row.AbsolutePosition.Y - sg.AbsolutePosition.Y + row.AbsoluteSize.Y + 4), BackgroundColor3=T.bg1, BorderSizePixel=0, ScrollBarThickness=3, ScrollBarImageColor3=T.border2, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=500, Parent=sg })
        list:SetAttribute("Owner", label)
        corner(list, 8); stroke(list, T.border2, 1, 0.2)
        mk("UIListLayout", { Padding=UDim.new(0,2), SortOrder=Enum.SortOrder.LayoutOrder, Parent=list })
        mk("UIPadding", { PaddingTop=UDim.new(0,6), PaddingBottom=UDim.new(0,6), PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6), Parent=list })
        for i, opt in ipairs(nd) do
            local sel = cur.value == opt.value
            local b = mk("TextButton", { Size=UDim2.new(1,0,0,30), BackgroundColor3=sel and T.acc or T.bg3, BorderSizePixel=0, Text=tostring(opt.display), Font=F.med, TextSize=11, TextColor3=sel and T.bg0 or T.dim, TextXAlignment=Enum.TextXAlignment.Left, AutoButtonColor=false, LayoutOrder=i, ZIndex=501, Parent=list })
            corner(b, 6); mk("UIPadding", { PaddingLeft=UDim.new(0,10), Parent=b })
            b.MouseButton1Click:Connect(function()
                cur = { display=opt.display, value=opt.value }
                curLabel.Text = tostring(opt.display)
                close()
                if cb then pcall(cb, opt.value) end
            end)
        end
        openDropdown = list
    end)
    return {
        set = function(v)
            for _, o in ipairs(nd) do
                if o.value == v then cur = { display=o.display, value=o.value } curLabel.Text = tostring(o.display) if cb then pcall(cb, o.value) end return end
            end
        end,
        get = function() return cur.value end,
    }
end
local function actBtn(par, label, cb, variant)
    local bg, fg = T.bg2, T.txt
    if variant == "primary" then bg, fg = T.acc, T.bg0
    elseif variant == "danger" then bg, fg = T.bad, Color3.new(1,1,1)
    elseif variant == "ok" then bg, fg = T.ok, T.bg0 end
    local b = mk("TextButton", { Size=UDim2.new(1,0,0, MOBILE and 42 or 38), BackgroundColor3=bg, BorderSizePixel=0, Text=label, Font=F.bold, TextSize=12, TextColor3=fg, AutoButtonColor=false, LayoutOrder=nx(par), Parent=par })
    corner(b, 10); stroke(b, T.border2, 1, 0.4)
    b.MouseButton1Click:Connect(function() task.spawn(function() pcall(cb) end) end)
    return b
end

local MT = {}
local SL = {}
local RARITY = {"Common","Uncommon","Rare","Legendary","Mythical"}
local RARITY_IDX = { Common=0, Uncommon=1, Rare=2, Legendary=3, Mythical=4 }

-- HOME
sec(scHome, "STATUS")
local statRow = mk("Frame", { Size=UDim2.new(1,0,0,80), BackgroundTransparency=1, LayoutOrder=nx(scHome), Parent=scHome })
mk("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder, Parent=statRow })
local function tile(lbl, v, col, order)
    local t = glass(statRow, { Size=UDim2.new(0.32,0,1,0), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0, LayoutOrder=order })
    mk("TextLabel", { Size=UDim2.new(1,-20,0,12), Position=UDim2.new(0,12,0,12), BackgroundTransparency=1, Text=lbl, Font=F.bold, TextSize=9, TextColor3=T.fnt, TextXAlignment=Enum.TextXAlignment.Left, Parent=t })
    local vv = mk("TextLabel", { Size=UDim2.new(1,-20,0,22), Position=UDim2.new(0,12,0,28), BackgroundTransparency=1, Text=v, Font=F.black, TextSize=18, TextColor3=col, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=t })
    local dot = mk("Frame", { Size=UDim2.new(0,6,0,6), Position=UDim2.new(1,-14,1,-14), BackgroundColor3=col, BorderSizePixel=0, Parent=t })
    corner(dot, 999)
    return vv
end
local lvlTile = tile("LEVEL", "1", T.hot, 1)
local modeTile = tile("MODE", "None", T.vio, 2)
local statusTile = tile("STATUS", "Idle", T.ok, 3)
sec(scHome, "MODULE ĐANG BẬT")
local modCard = glass(scHome, { Size=UDim2.new(1,0,0,290), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
local modRow = mk("Frame", { Size=UDim2.new(1,-32,1,-28), Position=UDim2.new(0,16,0,14), BackgroundTransparency=1, Parent=modCard })
mk("UIListLayout", { Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder, Parent=modRow })
local function modLine(txt)
    local w = mk("Frame", { Size=UDim2.new(1,0,0,14), BackgroundTransparency=1, LayoutOrder=nx(modRow), Parent=modRow })
    local d = mk("Frame", { Size=UDim2.new(0,6,0,6), Position=UDim2.new(0,0,0.5,-3), BackgroundColor3=T.fnt, BorderSizePixel=0, Parent=w })
    corner(d, 999)
    local l = mk("TextLabel", { Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,12,0,0), BackgroundTransparency=1, Text=txt, Font=F.med, TextSize=10, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=w })
    return { dot=d, lbl=l }
end
local mLines = {
    AutoFarm=modLine("Auto Farm"), AutoRaid=modLine("Auto Raid"), AutoBoss=modLine("Auto Boss"),
    AutoChest=modLine("Auto Chest"), AutoNearest=modLine("Auto Nearest"), AutoSpecific=modLine("Auto Specific"),
    AutoDungeon=modLine("Auto Dungeon"), AutoMagnet=modLine("Auto Magnet"), AutoBones=modLine("Auto Bones"),
    AutoEcto=modLine("Auto Ecto"), AutoDough=modLine("Auto Dough"), AutoElite=modLine("Auto Elite"),
    AutoMastery=modLine("Auto Mastery"), AutoMaterials=modLine("Auto Materials"), RegionFarm=modLine("Region Farm"),
    AutoFish=modLine("Auto Fish"), AutoSpecialQuest=modLine("Auto Special Quest"),
    AutoDarkbeard=modLine("Auto Darkbeard"), AutoOrder=modLine("Auto Order"), AutoRipIndra=modLine("Auto Rip Indra"),
    SilentAim=modLine("Silent Aim"), KillAura=modLine("Kill Aura"),
}
sec(scHome, "THỐNG KÊ")
local stCard = glass(scHome, { Size=UDim2.new(1,0,0,110), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
local kLbl = mk("TextLabel", { Size=UDim2.new(1,-20,0,18), Position=UDim2.new(0,12,0,8), BackgroundTransparency=1, Text="Kills: 0", Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=stCard })
local cLbl = mk("TextLabel", { Size=UDim2.new(1,-20,0,18), Position=UDim2.new(0,12,0,28), BackgroundTransparency=1, Text="Chests: 0", Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=stCard })
local tLbl = mk("TextLabel", { Size=UDim2.new(1,-20,0,18), Position=UDim2.new(0,12,0,48), BackgroundTransparency=1, Text="Time: 00:00", Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=stCard })
local rLbl = mk("TextLabel", { Size=UDim2.new(1,-20,0,18), Position=UDim2.new(0,12,0,68), BackgroundTransparency=1, Text="Kills/phút: 0", Font=F.bold, TextSize=12, TextColor3=T.hot, TextXAlignment=Enum.TextXAlignment.Left, Parent=stCard })

-- FARM
sec(scFarm, "FARM CHÍNH")
MT.AutoFarm = toggle(scFarm, "Auto Farm Level", "Đánh đủ quest → chờ 1.5s → nhận mới.", St.AutoFarm, function(v) St.AutoFarm = v UI.upd() end)
sec(scFarm, "MOB TARGET")
MT.AutoNearest = toggle(scFarm, "Auto Nearest Mob", "Mob gần nhất.", St.AutoNearest, function(v) St.AutoNearest = v UI.upd() end)
MT.AutoSpecific = toggle(scFarm, "Auto Specific Mob", "Mob chọn bên dưới.", St.AutoSpecific, function(v) St.AutoSpecific = v UI.upd() end)
local mobList = {}
for _, n in ipairs(D.MOBS[SEA] or D.MOBS[1]) do mobList[#mobList+1] = { display=dn(n), value=n } end
GUI_State.SelectedMob = mobList[1].value
dropdown(scFarm, "Mob chỉ định", mobList, mobList[1].value, function(v) GUI_State.SelectedMob = v end)
sec(scFarm, "BOSS / RƯƠNG")
MT.AutoBoss = toggle(scFarm, "Auto Boss Farm", "Farm boss chọn.", St.AutoBoss, function(v) St.AutoBoss = v UI.upd() end)
local bossList = D.BOSSES[SEA] or D.BOSSES[1]
GUI_State.SelectedBoss = bossList[1]
dropdown(scFarm, "Boss", bossList, bossList[1], function(v) GUI_State.SelectedBoss = v end)
MT.AutoChest = toggle(scFarm, "Auto Chest", "Bay tới rương gần nhất.", St.AutoChest, function(v) St.AutoChest = v UI.upd() end)
sec(scFarm, "HỖ TRỢ")
toggle(scFarm, "Auto Quest", "Tự nhận quest khi hết.", St.AutoQuest, function(v) St.AutoQuest = v end)
toggle(scFarm, "Auto Haki", "Tự bật Buso.", St.AutoHaki, function(v) St.AutoHaki = v end)
toggle(scFarm, "Auto Buy Haki", "Mua Buso khi chưa có.", St.AutoBuyHaki, function(v) St.AutoBuyHaki = v end)
toggle(scFarm, "Bring Mobs", "Gom mob về dưới chân.", St.BringMobs, function(v) St.BringMobs = v if not v then pcall(cleanBring) end end)
toggle(scFarm, "Auto Skill Z/X/C", "Tự bấm skill khi đánh.", St.AutoSkill, function(v) St.AutoSkill = v end)
toggle(scFarm, "Anti-Stuck", "Nhấc lên khi bị kẹt.", St.AntiStuck, function(v) St.AntiStuck = v end)
toggle(scFarm, "Auto Stats", "Tự cộng điểm chỉ số.", St.AutoStats, function(v) St.AutoStats = v end)
dropdown(scFarm, "Chỉ số cộng", { {display="Melee",value="Melee"},{display="Defense",value="Defense"},{display="Sword",value="Sword"},{display="Gun",value="Gun"},{display="Blox Fruit",value="Demon Fruit"} }, St.StatType, function(v) St.StatType = v end)
sec(scFarm, "VŨ KHÍ")
toggle(scFarm, "Auto Equip Weapon", "", St.AutoEquip, function(v) St.AutoEquip = v end)
segments(scFarm, "Loại vũ khí", { "Melee","Sword","Gun","Fruit" }, St.EquipType, function(v) St.EquipType = v end)
sec(scFarm, "TỐC ĐỘ")
toggle(scFarm, "Teleport xa", "Nhảy thẳng khi >1500 studs.", St.FarTP, function(v) St.FarTP = v end)
SL.speed = slider(scFarm, "Speed", "Tốc độ bay.", 80, 500, St.Speed, " ss", function(v) St.Speed = v MOVE.Speed = v end)
slider(scFarm, "Hover Height", "Độ cao trên đầu mob.", 10, 60, St.Hover, " ss", function(v) St.Hover = v end)
slider(scFarm, "Attack Range", "Bán kính đánh.", 30, 200, St.AttackRange, " ss", function(v) St.AttackRange = v end)
SL.bring = slider(scFarm, "Bring Range", "Bán kính gom mob.", 100, 800, St.BringRange, " ss", function(v) St.BringRange = v end)
SL.rate = slider(scFarm, "Bring Rate", "Chu kỳ gom mob.", 50, 500, math.floor(St.BringRate*1000), " ms", function(v) St.BringRate = v/1000 end, 10)
toggle(scFarm, "Safe Mode", "Máu thấp dừng farm.", St.SafeMode, function(v) St.SafeMode = v end)
slider(scFarm, "Ngưỡng máu %", "", 5, 95, St.SafeHP, " %", function(v) St.SafeHP = v end)
slider(scFarm, "Mob Timeout", "", 2, 15, St.MobTimeout, " s", function(v) St.MobTimeout = v end)

-- DUNGEON
sec(scDungeon, "DUNGEON MODE")
MT.AutoDungeon = toggle(scDungeon, "Auto Dungeon", "Wave-based combat.", St.AutoDungeon, function(v) St.AutoDungeon = v UI.upd() end)
sec(scDungeon, "MAGNET FARM")
MT.AutoMagnet = toggle(scDungeon, "Auto Magnet Farm", "Farm Magnet enemies.", St.AutoMagnet, function(v) St.AutoMagnet = v UI.upd() end)

-- FRUIT
sec(scFruit, "FRUIT SNIPER")
toggle(scFruit, "Fruit Sniper", "Bay tới fruit đủ hiếm.", St.FruitSniper, function(v) St.FruitSniper = v end)
segments(scFruit, "Rarity tối thiểu", RARITY, RARITY[St.FruitMinRarity+1] or "Rare", function(v) St.FruitMinRarity = RARITY_IDX[v] or 2 end)
sec(scFruit, "BRING / NOTIFY")
toggle(scFruit, "Fruit Bring", "Hút fruit về người.", St.FruitBring, function(v) St.FruitBring = v end)
toggle(scFruit, "Fruit Notifier", "Thông báo khi fruit spawn.", St.FruitNotify, function(v) St.FruitNotify = v end)
sec(scFruit, "AUTO STORE")
toggle(scFruit, "Auto Store Fruit", "", St.AutoStoreFruit, function(v) St.AutoStoreFruit = v end)
segments(scFruit, "Rarity để cất", RARITY, RARITY[St.StoreMinRarity+1] or "Rare", function(v) St.StoreMinRarity = RARITY_IDX[v] or 2 end)
sec(scFruit, "HÀNH ĐỘNG")
actBtn(scFruit, "Bay tới fruit gần nhất", function()
    local list = scanFruits(true)
    local hrp = getRoot() if not hrp then return end
    local best, bd
    for _, f in ipairs(list) do local d = dist(f.pos, hrp.Position) if not bd or d < bd then best, bd = f, d end end
    if best then teleportTo(CFrame.new(best.pos)) St.Sub = "Fruit · "..best.name end
end, "primary")
sec(scFruit, "DANH SÁCH FRUIT")
for _, f in ipairs(D.FRUITS) do
    local row = glass(scFruit, { Size=UDim2.new(1,0,0,30), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
    mk("TextLabel", { Size=UDim2.new(0.55,-14,1,0), Position=UDim2.new(0,14,0,0), BackgroundTransparency=1, Text=f.name, Font=F.med, TextSize=11, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=row })
    mk("TextLabel", { Size=UDim2.new(0.45,-14,1,0), Position=UDim2.new(0.55,0,0,0), BackgroundTransparency=1, Text=RARITY[f.rarity+1].." · $"..tostring(f.price), Font=F.mono, TextSize=10, TextColor3=({T.fnt,T.dim,T.hot,T.vio,T.bad})[f.rarity+1], TextXAlignment=Enum.TextXAlignment.Right, TextTruncate=Enum.TextTruncate.AtEnd, Parent=row })
end

-- ATTACK
sec(scAttack, "TIMING")
SL.delay = slider(scAttack, "Attack Delay", "ms giữa các đòn.", 0, 100, math.floor(St.AtkDelay*1000), " ms", function(v) St.AtkDelay = v/1000 end)
SL.burst = slider(scAttack, "Multi Hit", "Số lần gửi mỗi lượt.", 1, 5, St.AtkBurst, " hits", function(v) St.AtkBurst = math.floor(v) end)
sec(scAttack, "PRESET")
actBtn(scAttack, "An toàn — 33/s", function() SL.delay.set(30) SL.burst.set(1) end)
actBtn(scAttack, "Bình thường — 60/s", function() SL.delay.set(16) SL.burst.set(1) end, "primary")
actBtn(scAttack, "Nhanh — 120/s", function() SL.delay.set(8) SL.burst.set(2) end)
actBtn(scAttack, "TURBO — nhanh nhất", function() SL.delay.set(0) SL.burst.set(2) SL.speed.set(320) SL.bring.set(400) SL.rate.set(100) end, "ok")
actBtn(scAttack, "Cực nhanh — 300/s", function() SL.delay.set(0) SL.burst.set(5) end, "danger")
sec(scAttack, "SKILL CD")
slider(scAttack, "Skill Z CD", "", 0.1, 5, St.SkillCD.Z, " s", function(v) St.SkillCD.Z = v end, 0.1)
slider(scAttack, "Skill X CD", "", 0.1, 5, St.SkillCD.X, " s", function(v) St.SkillCD.X = v end, 0.1)
slider(scAttack, "Skill C CD", "", 0.1, 8, St.SkillCD.C, " s", function(v) St.SkillCD.C = v end, 0.1)
sec(scAttack, "COMBAT NÂNG CAO")
toggle(scAttack, "Aimbot Camera", "", St.Aimbot, function(v) St.Aimbot = v end)
slider(scAttack, "Aimbot FOV", "", 50, 800, St.AimbotFOV, " px", function(v) St.AimbotFOV = v end)
slider(scAttack, "Aimbot Smooth", "0.05 mượt, 1 khóa cứng.", 0.05, 1, St.AimbotSmooth, "", function(v) St.AimbotSmooth = v end, 0.05)
toggle(scAttack, "Kill Aura", "", St.KillAura, function(v) St.KillAura = v end)
slider(scAttack, "Kill Aura Range", "", 20, 200, St.AuraRange, " ss", function(v) St.AuraRange = v end)
segments(scAttack, "Fast Attack Mode", { "Legit","Safe","Normal","Fast","Turbo","Insane" }, St.FastMode, function(v)
    local p = FAST_PRESETS[v] or FAST_PRESETS.Normal
    St.FastMode = v St.AtkDelay = p.delay St.AtkBurst = p.burst
end)

-- RAID
sec(scRaid, "MODE")
MT.AutoRaid = toggle(scRaid, "Auto Raid", "Mua chip + clear đảo.", St.AutoRaid, function(v) St.AutoRaid = v UI.upd() end)
sec(scRaid, "TÙY CHỌN")
toggle(scRaid, "Auto Buy Chip", "", St.AutoBuyChip, function(v) St.AutoBuyChip = v end)
toggle(scRaid, "Auto Clear Raid", "", St.AutoClearRaid, function(v) St.AutoClearRaid = v end)
dropdown(scRaid, "Loại chip", { "Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Door","Rubber","Barrier","Ghost","Revive","Dough","Soul","Chop" }, St.RaidChip, function(v) St.RaidChip = v end)

-- MISC
sec(scMisc, "NHÂN VẬT")
toggle(scMisc, "No Clip", "", St.NoClip, function(v)
    St.NoClip = v
    if not v then
        local c = LP.Character
        if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
    end
end)
toggle(scMisc, "Fly (camera)", "", St.Fly, function(v) St.Fly = v end)
slider(scMisc, "Fly Speed", "", 30, 400, St.FlySpeed, "", function(v) St.FlySpeed = v end)
toggle(scMisc, "Infinite Jump", "", St.InfJump, function(v) St.InfJump = v end)
toggle(scMisc, "Lock Speed/Jump", "", St.LockSpeed, function(v) St.LockSpeed = v end)
slider(scMisc, "Walk Speed", "", 16, 200, St.WalkSpeed, "", function(v) St.WalkSpeed = v end)
sec(scMisc, "HÀNH ĐỘNG")
actBtn(scMisc, "Reset nhân vật", function() local h = getHum() if h then h.Health = 0 end end)
actBtn(scMisc, "Xoá sương mù", function()
    pcall(function()
        S.Light.FogEnd = 1e6 S.Light.FogStart = 0
        local at = S.Light:FindFirstChildOfClass("Atmosphere")
        if at then at.Density = 0 at.Haze = 0 end
    end)
end, "primary")
sec(scMisc, "SERVER")
actBtn(scMisc, "Server Hop (ping thấp)", function() serverHopPing() end, "primary")
actBtn(scMisc, "Rejoin", function() pcall(function() S.TP:Teleport(game.PlaceId, LP) end) end)
slider(scMisc, "Ping tối đa khi hop", "", 50, 500, St.HopPingMax, " ms", function(v) St.HopPingMax = v end)
sec(scMisc, "CODE / CONFIG")
actBtn(scMisc, "Nhập tất cả code", function()
    for _, c in ipairs(DEFAULT_CODES) do Invoke("Redeem", c) task.wait(0.3) end
end, "primary")
actBtn(scMisc, "Lưu config", function() saveConfig() notify("Config", "Đã lưu", 3) end, "ok")
actBtn(scMisc, "Tải config", function() loadConfig() notify("Config", "Đã tải", 4) end)

-- FPS
sec(scFPS, "MASTER")
local fS = {}
local fpsMaster = toggle(scFPS, "Bật tất cả FPS Boost", "", false, function(v) for _, t in pairs(fS) do t.set(v) end end)
sec(scFPS, "RENDER")
fS.sh = toggle(scFPS, "Tắt Shadows", "", false, function(v) FPS.shadows(v) end)
fS.pf = toggle(scFPS, "Tắt Post FX", "", false, function(v) FPS.postfx(v) end)
fS.at = toggle(scFPS, "Tắt Atmosphere", "", false, function(v) FPS.atmosphere(v) end)
fS.tr = toggle(scFPS, "Tắt nước Terrain", "", false, function(v) FPS.terrain(v) end)
fS.pa = toggle(scFPS, "Tắt Particles", "", false, function(v) FPS.particles(v) end)
fS.de = toggle(scFPS, "Tắt Decal", "", false, function(v) FPS.decals(v) end)
fS.be = toggle(scFPS, "Tắt Beams", "", false, function(v) FPS.beams(v) end)
fS.li = toggle(scFPS, "Làm tối Lighting", "", false, function(v) FPS.lighting(v) end)
sec(scFPS, "HÀNH ĐỘNG")
actBtn(scFPS, "Bật tất cả", function() fpsMaster.set(true) end, "primary")
actBtn(scFPS, "Khôi phục", function() FPS.restore() for _, t in pairs(fS) do t.set(false) end fpsMaster.set(false) end)

-- EXT
sec(scExt, "FARM ĐẶC BIỆT")
MT.AutoBones = toggle(scExt, "Auto Bones (Sea 3)", "", St.AutoBones, function(v) St.AutoBones = v UI.upd() end)
MT.AutoEcto = toggle(scExt, "Auto Ectoplasm (Sea 2)", "", St.AutoEcto, function(v) St.AutoEcto = v UI.upd() end)
MT.AutoDough = toggle(scExt, "Auto Dough King", "", St.AutoDough, function(v) St.AutoDough = v UI.upd() end)
MT.AutoElite = toggle(scExt, "Auto Elite Hunter", "", St.AutoElite, function(v) St.AutoElite = v UI.upd() end)
MT.AutoMastery = toggle(scExt, "Auto Mastery", "", St.AutoMastery, function(v) St.AutoMastery = v UI.upd() end)
MT.AutoMaterials = toggle(scExt, "Auto Materials", "", St.AutoMaterials, function(v) St.AutoMaterials = v UI.upd() end)
sec(scExt, "REGION FARM")
MT.RegionFarm = toggle(scExt, "Region Farm", "Bay tới vùng chọn + đánh mob.", St.RegionFarm, function(v) St.RegionFarm = v UI.upd() end)
local regionOpts = {}
for k in pairs(REGIONS) do regionOpts[#regionOpts+1] = k end
table.sort(regionOpts)
dropdown(scExt, "Vùng farm", regionOpts, St.RegionName, function(v) St.RegionName = v end)
sec(scExt, "KỸ NĂNG")
toggle(scExt, "Auto Buy Geppo", "", St.AutoBuyGeppo, function(v) St.AutoBuyGeppo = v end)
toggle(scExt, "Auto Buy Soru", "", St.AutoBuySoru, function(v) St.AutoBuySoru = v end)
toggle(scExt, "Auto Buy Ken", "", St.AutoBuyKen, function(v) St.AutoBuyKen = v end)
toggle(scExt, "Auto Redeem Code", "", St.AutoRedeem, function(v) St.AutoRedeem = v if v then St.Redeemed = false end end)
sec(scExt, "FRUIT NÂNG CAO")
toggle(scExt, "Fruit Sniper theo TÊN", "", St.FruitSniper, function(v) St.FruitSniper = v end)
local fruitNames = {}
for _, f in ipairs(D.FRUITS) do fruitNames[#fruitNames+1] = f.name end
dropdown(scExt, "Fruit sniper tên", fruitNames, St.FruitSniperName ~= "" and St.FruitSniperName or fruitNames[1], function(v) St.FruitSniperName = v end)
local snCard = glass(scExt, { Size=UDim2.new(1,0,0,120), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
mk("TextLabel", { Size=UDim2.new(1,-20,0,16), Position=UDim2.new(0,12,0,10), BackgroundTransparency=1, Text="Auto Store theo tên (mỗi dòng 1 fruit)", Font=F.bold, TextSize=11, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=snCard })
local storeBox = mk("TextBox", { Size=UDim2.new(1,-24,0,80), Position=UDim2.new(0,12,0,32), BackgroundColor3=T.bg1, BorderSizePixel=0, Text=table.concat(St.StoreNames, "\n"), PlaceholderText="Dough-Dough\nLeopard-Leopard", Font=F.mono, TextSize=10, TextColor3=T.hot, TextWrapped=true, ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, Parent=snCard })
corner(storeBox, 8)
storeBox.FocusLost:Connect(function()
    St.StoreNames = {}
    for line in storeBox.Text:gmatch("[^\r\n]+") do
        local s = line:gsub("^%s+",""):gsub("%s+$","")
        if s ~= "" then St.StoreNames[#St.StoreNames+1] = s end
    end
    notify("Store", #St.StoreNames.." fruit", 3)
end)
sec(scExt, "ROLL / AWAKEN / RACE")
toggle(scExt, "Auto Roll Fruit", "", St.RollAuto, function(v) St.RollAuto = v end)
segments(scExt, "Roll rarity tối thiểu", RARITY, RARITY[St.RollMin+1] or "Rare", function(v) St.RollMin = RARITY_IDX[v] or 2 end)
toggle(scExt, "Auto Awaken", "", St.AutoAwaken, function(v) St.AutoAwaken = v end)
dropdown(scExt, "Fruit awaken", fruitNames, St.AwakenFruit ~= "" and St.AwakenFruit or fruitNames[1], function(v) St.AwakenFruit = v end)
toggle(scExt, "Auto Race V4 Trial", "", St.RaceV4, function(v) St.RaceV4 = v UI.upd() end)

-- EVENT
sec(scEvent, "BOSS SỰ KIỆN")
toggle(scEvent, "Auto Darkbeard", "", St.AutoDarkbeard, function(v) St.AutoDarkbeard = v UI.upd() end)
toggle(scEvent, "Auto Order", "", St.AutoOrder, function(v) St.AutoOrder = v UI.upd() end)
toggle(scEvent, "Auto Rip Indra", "", St.AutoRipIndra, function(v) St.AutoRipIndra = v UI.upd() end)
toggle(scEvent, "Auto Sea Beast", "", St.AutoSeaBeast, function(v) St.AutoSeaBeast = v UI.upd() end)
toggle(scEvent, "Auto Sea Event Boss", "", St.AutoSeaEvent, function(v) St.AutoSeaEvent = v UI.upd() end)
sec(scEvent, "BOSS TIMER")
local btCard = glass(scEvent, { Size=UDim2.new(1,0,0,180), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
local btList = mk("Frame", { Size=UDim2.new(1,-20,1,-20), Position=UDim2.new(0,10,0,10), BackgroundTransparency=1, Parent=btCard })
mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder, Parent=btList })
local btLabels = {}
for name in pairs(BOSS_RESPAWN) do
    local row = mk("Frame", { Size=UDim2.new(1,0,0,18), BackgroundTransparency=1, LayoutOrder=nx(btList), Parent=btList })
    mk("TextLabel", { Size=UDim2.new(0.6,0,1,0), BackgroundTransparency=1, Text=name, Font=F.med, TextSize=11, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=row })
    local cdl = mk("TextLabel", { Size=UDim2.new(0.4,0,1,0), Position=UDim2.new(0.6,0,0,0), BackgroundTransparency=1, Text="--", Font=F.mono, TextSize=11, TextColor3=T.hot, TextXAlignment=Enum.TextXAlignment.Right, Parent=row })
    btLabels[name] = cdl
end

-- UTILS
sec(scUtils, "CẢNH BÁO / AN TOÀN")
toggle(scUtils, "Cảnh báo người chơi", "", St.PlayerAlert, function(v) St.PlayerAlert = v end)
slider(scUtils, "Bán kính cảnh báo", "", 50, 2000, St.AlertRange, " ss", function(v) St.AlertRange = v end)
toggle(scUtils, "Auto Rejoin khi mất kết nối", "", St.AutoRejoin, function(v) St.AutoRejoin = v end)
toggle(scUtils, "Anti-AFK", "", St.AntiAFK, function(v) St.AntiAFK = v end)
sec(scUtils, "HẸN GIỜ")
actBtn(scUtils, "Đặt 15 phút", function() St.TimerMin = 15 St.TimerStart = tick() notify("Timer", "Rejoin sau 15p", 3) end)
actBtn(scUtils, "Đặt 30 phút", function() St.TimerMin = 30 St.TimerStart = tick() notify("Timer", "Rejoin sau 30p", 3) end)
actBtn(scUtils, "Đặt 60 phút", function() St.TimerMin = 60 St.TimerStart = tick() notify("Timer", "Rejoin sau 60p", 3) end)
actBtn(scUtils, "Huỷ hẹn giờ", function() St.TimerMin = 0 St.TimerStart = 0 end, "danger")
sec(scUtils, "GIAO DIỆN")
segments(scUtils, "Ngôn ngữ", { "VN","EN" }, St.Lang, function(v) St.Lang = v end)
segments(scUtils, "Theme màu", { "Gold","Cyan","Pink","Green","Purple","Red" }, St.Theme, function(v)
    local th = { Gold={Color3.fromRGB(255,200,90),Color3.fromRGB(255,230,160)}, Cyan={Color3.fromRGB(80,220,255),Color3.fromRGB(170,240,255)}, Pink={Color3.fromRGB(255,120,200),Color3.fromRGB(255,190,230)}, Green={Color3.fromRGB(90,255,150),Color3.fromRGB(180,255,210)}, Purple={Color3.fromRGB(180,120,255),Color3.fromRGB(220,180,255)}, Red={Color3.fromRGB(255,90,90),Color3.fromRGB(255,160,160)} }
    local t = th[v] or th.Gold
    St.Theme = v T.acc, T.hot = t[1], t[2]
    pcall(function()
        for _, d in ipairs(sg:GetDescendants()) do
            if d:IsA("UIStroke") and d.Color == th.Gold[1] then d.Color = T.acc
            elseif d:IsA("Frame") and d.BackgroundColor3 == th.Gold[1] then d.BackgroundColor3 = T.acc
            elseif d:IsA("TextLabel") and d.TextColor3 == th.Gold[2] then d.TextColor3 = T.hot end
        end
    end)
end)
sec(scUtils, "PROFILES")
actBtn(scUtils, "Lưu Profile", function() St.Profile = "Profile_"..os.date("%Y%m%d_%H%M%S") saveConfig() notify("Profile", "Đã lưu: "..St.Profile, 4) end, "ok")
actBtn(scUtils, "Tải Profile", function() loadConfig() notify("Profile", "Đã tải", 4) end)
actBtn(scUtils, "Reset config", function() pcall(function() if delfile and isfile and isfile(CFG_FILE) then delfile(CFG_FILE) end end) notify("Config", "Đã xoá", 4) end, "danger")
sec(scUtils, "DISCORD WEBHOOK")
local dcCard = glass(scUtils, { Size=UDim2.new(1,0,0,80), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
mk("TextLabel", { Size=UDim2.new(1,-20,0,16), Position=UDim2.new(0,12,0,10), BackgroundTransparency=1, Text="URL Webhook", Font=F.bold, TextSize=11, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=dcCard })
local dcBox = mk("TextBox", { Size=UDim2.new(1,-24,0,40), Position=UDim2.new(0,12,0,30), BackgroundColor3=T.bg1, BorderSizePixel=0, Text=St.DiscordURL, PlaceholderText="https://discord.com/api/webhooks/...", Font=F.mono, TextSize=10, TextColor3=T.hot, ClearTextOnFocus=false, Parent=dcCard })
corner(dcBox, 8)
dcBox.FocusLost:Connect(function() St.DiscordURL = dcBox.Text if St.DiscordURL ~= "" then discord("Test HL HUB") end end)
actBtn(scUtils, "Test webhook", function() discord("Test thủ công từ HL HUB") end, "primary")

-- FISH
sec(scFish, "FISHING")
toggle(scFish, "Auto Fishing", "", St.AutoFish, function(v) St.AutoFish = v UI.upd() end)
toggle(scFish, "Auto Buy Bait", "", St.AutoBuyBait, function(v) St.AutoBuyBait = v end)
toggle(scFish, "Auto Sell Fish", "", St.AutoSellFish, function(v) St.AutoSellFish = v end)
toggle(scFish, "Auto Quest Fishing", "", St.AutoFishQuest, function(v) St.AutoFishQuest = v end)
sec(scFish, "COLLECT")
toggle(scFish, "Auto Berry", "", St.AutoBerry, function(v) St.AutoBerry = v UI.upd() end)
toggle(scFish, "Auto Collect Hop", "", St.AutoCollectHop, function(v) St.AutoCollectHop = v UI.upd() end)

-- MASTERY
sec(scMastery, "MASTERY FARM")
toggle(scMastery, "Auto Mastery", "Farm mastery mob gần nhất.", St.AutoMastery, function(v) St.AutoMastery = v UI.upd() end)
segments(scMastery, "Mastery Target", {"Melee","Sword","Gun","Fruit"}, St.MasteryTarget, function(v)
    St.MasteryTarget = v
    if v == "Fruit" then St.EquipType = "Fruit"
    elseif v == "Gun" then St.EquipType = "Gun"
    elseif v == "Sword" then St.EquipType = "Sword"
    else St.EquipType = "Melee" end
end)

-- QUEST
sec(scQuest, "QUEST ĐẶC BIỆT")
toggle(scQuest, "Auto Special Quest", "", St.AutoSpecialQuest, function(v) St.AutoSpecialQuest = v UI.upd() end)
local qNames = {}
for _, q in ipairs(SPECIAL_QUESTS) do qNames[#qNames+1] = q.name end
dropdown(scQuest, "Chọn Quest", qNames, St.SpecialQuest, function(v) St.SpecialQuest = v end)
toggle(scQuest, "Auto Complete Quest", "", St.AutoCompleteQuest, function(v) St.AutoCompleteQuest = v UI.upd() end)
sec(scQuest, "BOSS ĐẶC BIỆT")
toggle(scQuest, "Auto Rip Indra Attack", "", St.AutoRipIndraAttack, function(v) St.AutoRipIndraAttack = v UI.upd() end)
toggle(scQuest, "Auto Soul Reaper", "", St.AutoSoulReaper, function(v) St.AutoSoulReaper = v UI.upd() end)
toggle(scQuest, "Auto Dough King", "", St.AutoDoughKing, function(v) St.AutoDoughKing = v UI.upd() end)
sec(scQuest, "RAID ĐẶC BIỆT")
toggle(scQuest, "Auto Factory Raid", "Sea 2.", St.AutoFactoryRaid, function(v) St.AutoFactoryRaid = v UI.upd() end)
toggle(scQuest, "Auto Pirate Raid", "Sea 3.", St.AutoPirateRaid, function(v) St.AutoPirateRaid = v UI.upd() end)
toggle(scQuest, "Auto Haki Pad", "", St.AutoHakiPad, function(v) St.AutoHakiPad = v UI.upd() end)
sec(scQuest, "GACHA / MAGNET")
toggle(scQuest, "Auto Gacha Magnet", "", St.AutoGachaMagnet, function(v) St.AutoGachaMagnet = v UI.upd() end)
toggle(scQuest, "Auto Magnet Event", "", St.AutoMagnetEvent, function(v) St.AutoMagnetEvent = v UI.upd() end)
toggle(scQuest, "Try Lucky Gravestone", "", St.TryLuckyGrave, function(v) St.TryLuckyGrave = v UI.upd() end)

-- PVP
sec(scPvP, "SILENT AIM")
toggle(scPvP, "Silent Aim", "Khóa mục tiêu ngầm.", St.SilentAim, function(v) St.SilentAim = v end)
toggle(scPvP, "Aim Player (thay NPC)", "", St.SilentAimPlayer, function(v) St.SilentAimPlayer = v end)
toggle(scPvP, "Target Lowest HP", "", St.TargetLowestHP, function(v) St.TargetLowestHP = v end)
toggle(scPvP, "Tracer", "Highlight mục tiêu.", St.Tracer, function(v) St.Tracer = v end)
toggle(scPvP, "FOV Circle", "", St.FovCircle, function(v) St.FovCircle = v end)
sec(scPvP, "MOVEMENT")
toggle(scPvP, "Water Walk", "Đi trên mặt nước.", St.WaterWalk, function(v) St.WaterWalk = v end)
toggle(scPvP, "Bypass Speed", "Tăng tốc không đổi WalkSpeed.", St.BypassSpeed, function(v) St.BypassSpeed = v end)
slider(scPvP, "Bypass Multiplier", "", 1.1, 3.0, St.BypassSpeedMul, "x", function(v) St.BypassSpeedMul = v end, 0.1)

-- ISLAND
sec(scIsland, "TELEPORT ĐẢO")
toggle(scIsland, "Teleport to Island", "Nhấn để dịch chuyển.", St.IslandTP, function(v) St.IslandTP = v end)
local seaName = SEA == 1 and "Sea 1" or (SEA == 2 and "Sea 2" or "Sea 3")
local islandOpts = {}
if ISLANDS[seaName] then
    for k in pairs(ISLANDS[seaName]) do islandOpts[#islandOpts+1] = k end
    table.sort(islandOpts)
end
dropdown(scIsland, "Chọn đảo", islandOpts, St.IslandName, function(v) St.IslandName = v end)

-- ABOUT
local function stopAll()
    for _, t in pairs(MT) do t.set(false) end
    St.AutoFarm, St.AutoRaid, St.AutoBoss = false, false, false
    St.AutoChest, St.AutoNearest, St.AutoSpecific = false, false, false
    St.AutoDungeon, St.AutoMagnet = false, false
    St.AutoBones, St.AutoDough, St.AutoElite, St.AutoEcto = false, false, false, false
    St.AutoMastery, St.AutoMaterials, St.RegionFarm = false, false, false
    St.AutoDarkbeard, St.AutoOrder, St.AutoRipIndra = false, false, false
    St.AutoSeaBeast, St.AutoSeaEvent, St.RaceV4 = false, false, false
    St.AutoFish, St.AutoSpecialQuest = false, false
    St.AutoFactoryRaid, St.AutoPirateRaid, St.AutoHakiPad = false, false, false
    St.AutoRipIndraAttack, St.AutoSoulReaper, St.AutoDoughKing = false, false, false
    St.AutoGachaMagnet, St.AutoMagnetEvent, St.TryLuckyGrave = false, false, false
    St.AutoCompleteQuest, St.AutoBerry, St.AutoCollectHop = false, false, false
    St.Panic = true St.Attacking = false
    stopMoving() cleanBring()
    UI.upd()
end
local function unload()
    St.Destroyed = true St.Panic = true St.Attacking = false
    for _, c in ipairs(CONN) do pcall(function() c:Disconnect() end) end
    stopMoving()
    pcall(cleanBring) pcall(espClear) pcall(FPS.restore)
    pcall(function() sg:Destroy() end)
    pcall(function() if St._fovCircle then St._fovCircle:Destroy() end end)
    pcall(function()
        for _, g in ipairs(GUI:GetChildren()) do
            if g.Name == "HL_Watermark" or g.Name == "HL_FOV" then g:Destroy() end
        end
    end)
end

sec(scAbout, "PHÍM TẮT")
local hkCard = glass(scAbout, { Size=UDim2.new(1,0,0,90), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
for i, c in ipairs({ {k="RightShift",d="Panic stop"},{k="RightCtrl",d="Panic stop"},{k="Kéo header",d="Di chuyển"} }) do
    mk("TextLabel", { Size=UDim2.new(0,110,0,20), Position=UDim2.new(0,16,0,14+(i-1)*24), BackgroundTransparency=1, Text=c.k, Font=F.mono, TextSize=11, TextColor3=T.bad, TextXAlignment=Enum.TextXAlignment.Left, Parent=hkCard })
    mk("TextLabel", { Size=UDim2.new(1,-140,0,20), Position=UDim2.new(0,130,0,14+(i-1)*24), BackgroundTransparency=1, Text=c.d, Font=F.reg, TextSize=11, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=hkCard })
end
sec(scAbout, "TÁC GIẢ")
local auCard = glass(scAbout, { Size=UDim2.new(1,0,0,96), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
mk("TextLabel", { Size=UDim2.new(1,-28,0,22), Position=UDim2.new(0,14,0,12), BackgroundTransparency=1, Text=AUTHOR.brand.." "..AUTHOR.version, Font=F.black, TextSize=15, TextColor3=T.hot, TextXAlignment=Enum.TextXAlignment.Left, Parent=auCard })
mk("TextLabel", { Size=UDim2.new(1,-28,0,16), Position=UDim2.new(0,14,0,36), BackgroundTransparency=1, Text="MADE BY "..AUTHOR.name:upper(), Font=F.bold, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=auCard })
mk("TextLabel", { Size=UDim2.new(1,-28,0,16), Position=UDim2.new(0,14,0,56), BackgroundTransparency=1, Text="ZALO "..AUTHOR.zalo.." · © 2026 "..AUTHOR.name, Font=F.reg, TextSize=11, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=auCard })
mk("TextLabel", { Size=UDim2.new(1,-28,0,16), Position=UDim2.new(0,14,0,74), BackgroundTransparency=1, Text="Nghiêm cấm bán lại / đổi tên tác giả.", Font=F.reg, TextSize=10, TextColor3=T.bad, TextXAlignment=Enum.TextXAlignment.Left, Parent=auCard })
sec(scAbout, "HÀNH ĐỘNG")
actBtn(scAbout, "Xem log boss", function()
    local n = #St.BossKillLog
    if n == 0 then notify("Log", "Chưa có boss nào bị hạ.", 4) return end
    local lines = {}
    for _, e in ipairs(St.BossKillLog) do lines[#lines+1] = e.at.." · "..e.name end
    print("[HL] Log boss:\n"..table.concat(lines, "\n"))
    local last = St.BossKillLog[n]
    notify("Log boss", n.." boss · gần nhất: "..last.name, 6)
end)
actBtn(scAbout, "Reset Quest Tracker", function() St.QuestLv = -1 St.LastQuestTry = 0 St.QuestCompletedAt = 0 end)
actBtn(scAbout, "Dừng tất cả", stopAll, "danger")
actBtn(scAbout, "Gỡ script", unload, "danger")

-- TAB SWITCH
local busyTab = false
local function setTab(key)
    if busyTab then return end
    busyTab = true
    if openDropdown then pcall(function() openDropdown:Destroy() end) openDropdown = nil end
    for k, p in pairs(pages) do p.root.Visible = (k == key) end
    for k, t in pairs(tabBtns) do
        local on = k == key
        t.ind.Visible = on
        tw(t.btn, 0.22, { BackgroundColor3 = on and T.bg3 or T.bg2, BackgroundTransparency = on and 0 or 0.5 })
        tw(t.dot, 0.22, { BackgroundColor3 = on and T.hot or T.fnt })
        tw(t.lbl, 0.22, { TextColor3 = on and T.txt or T.dim })
    end
    task.wait(0.1)
    busyTab = false
end
for k, t in pairs(tabBtns) do t.btn.MouseButton1Click:Connect(function() setTab(k) end) end
task.spawn(setTab, "Home")

local MODE_COL = { AutoFarm=T.ok, AutoRaid=T.vio, AutoBoss=T.bad, AutoChest=T.warn, AutoNearest=T.hot, AutoSpecific=T.vio, AutoDungeon=T.acc, AutoMagnet=T.hot, AutoBones=T.ok, AutoEcto=T.ok, AutoDough=T.hot, AutoElite=T.vio, AutoMastery=T.warn, AutoMaterials=T.dim, RegionFarm=T.hot, AutoFish=T.acc, AutoSpecialQuest=T.vio, AutoDarkbeard=T.bad, AutoOrder=T.bad, AutoRipIndra=T.bad, SilentAim=T.bad, KillAura=T.bad }
UI.upd = function()
    for k, p in pairs(mLines) do
        local on = St[k]
        tw(p.dot, 0.22, { BackgroundColor3 = on and MODE_COL[k] or T.fnt })
        tw(p.lbl, 0.22, { TextColor3 = on and T.txt or T.dim })
    end
    if anyMode() then
        tw(pill, 0.22, { BackgroundColor3 = T.ok })
        pillStroke.Color = T.ok
        pillText.TextColor3 = T.bg0
        pillDot.BackgroundColor3 = T.bg0
        local mt, mc = "AUTO", T.ok
        if St.AutoRaid then mt, mc = "RAID", T.vio
        elseif St.AutoDungeon then mt, mc = "DUNGEON", T.acc
        elseif St.AutoMagnet then mt, mc = "MAGNET", T.hot
        elseif St.AutoFish then mt, mc = "FISH", T.acc
        elseif St.AutoSpecialQuest then mt, mc = "QUEST", T.vio
        elseif St.AutoBoss then mt, mc = "BOSS", T.bad
        elseif St.AutoNearest then mt, mc = "NEAR", T.hot
        elseif St.AutoSpecific then mt, mc = "MOB", T.vio
        elseif St.AutoChest then mt, mc = "CHEST", T.warn
        elseif St.AutoFarm then mt, mc = "FARM", T.hot end
        pillText.Text = mt modeTile.Text = mt modeTile.TextColor3 = mc
        if not St.Running and not St.Destroyed then
            St.Running = true
            task.spawn(function() mainLoop() St.Running = false end)
        end
    else
        pillText.Text = "IDLE"
        pillText.TextColor3 = T.dim
        pillStroke.Color = T.border2
        pillDot.BackgroundColor3 = T.fnt
        tw(pill, 0.22, { BackgroundColor3 = T.bg2 })
        modeTile.Text = "None"
        modeTile.TextColor3 = T.dim
        St.Sub = "Idle"
    end
end

-- DRAG
local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = i.Position startPos = main.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
conn(S.UIS.InputChanged, function(i)
    if not dragging then return end
    if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
    local d = i.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
end)
conn(S.UIS.InputBegan, function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightControl or i.KeyCode == Enum.KeyCode.RightShift then stopAll() end
end)
local minimized = false
local origSize = UDim2.new(0, W, 0, H)
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tw(main, 0.32, { Size = minimized and UDim2.new(0, W, 0, 66) or origSize })
    body.Visible = not minimized
    minBtn.Text = minimized and "+" or "—"
end)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false reopen.Visible = true end)
reopen.MouseButton1Click:Connect(function() reopen.Visible = false main.Visible = true end)

task.spawn(function()
    while not St.Destroyed and sg.Parent do
        St.MyLevel = myLevel()
        lvlTile.Text = tostring(St.MyLevel)
        local s = St.Sub
        if #s > 16 then s = string.sub(s, 1, 14)..".." end
        statusTile.Text = s
        task.wait(0.3)
    end
end)
task.spawn(function()
    while not St.Destroyed do
        task.wait(1)
        local mins = (tick() - St.StatStart) / 60
        kLbl.Text = "Kills: "..St.StatKills
        cLbl.Text = "Chests: "..St.StatChests
        tLbl.Text = string.format("Time: %02d:%02d", math.floor(mins), math.floor((mins*60)%60))
        rLbl.Text = "Kills/phút: "..(mins > 0 and string.format("%.1f", St.StatKills/mins) or "0")
    end
end)
task.spawn(function()
    while not St.Destroyed do
        task.wait(0.5)
        for name, lbl in pairs(btLabels) do
            local t = St.BossTimers[name]
            if t and tick() < t then
                lbl.Text = string.format("%02d:%02d", math.floor((t-tick())/60), math.floor((t-tick())%60))
                lbl.TextColor3 = T.bad
            else lbl.Text = "Sẵn sàng" lbl.TextColor3 = T.ok end
        end
    end
end)

main.Size = UDim2.new(0, W, 0, 0)
main.BackgroundTransparency = 1
task.wait(0.1)
tw(main, 0.55, { Size = origSize, BackgroundTransparency = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local wm = mk("ScreenGui", { Name="HL_Watermark", ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=999, Parent=GUI })
local wf = mk("Frame", { Size=UDim2.new(0,230,0,22), Position=UDim2.new(1,-238,0,8), BackgroundColor3=Color3.fromRGB(10,12,20), BackgroundTransparency=0.35, BorderSizePixel=0, Parent=wm })
corner(wf, 6); stroke(wf, T.acc, 1, 0.4)
mk("TextLabel", { Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,5,0,0), BackgroundTransparency=1, Text=AUTHOR.brand.." · Zalo "..AUTHOR.zalo, Font=F.bold, TextSize=10, TextColor3=T.hot, Parent=wf })
end -- UI

--====================================================================================
-- PLAYER MODS
--====================================================================================
conn(S.Run.Stepped, function()
    if St.Destroyed then return end
    if St.NoClip then
        local c = LP.Character
        if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end end
    end
    if St.LockSpeed then
        local h = getHum()
        if h then h.WalkSpeed = math.max(16, tonumber(St.WalkSpeed) or 50) h.UseJumpPower = true h.JumpPower = 90 end
    end
end)
do
    local flyBV, flyBG
    local function flyOff()
        if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
        if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
    end
    conn(S.Run.Heartbeat, function()
        if St.Destroyed then return end
        if not St.Fly then if flyBV then flyOff() end return end
        local r = getRoot() if not r then return end
        if not flyBV or flyBV.Parent ~= r then
            flyOff()
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
            flyBV.Velocity = Vector3.new(0,0,0)
            flyBV.P = 1e4
            flyBV.Parent = r
            flyBG = Instance.new("BodyGyro")
            flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
            flyBG.P = 9e4
            flyBG.Parent = r
            return
        end
        local cam = S.WS.CurrentCamera
        local h = getHum()
        local md = h and h.MoveDirection or Vector3.new(0,0,0)
        local dir = Vector3.new(0,0,0)
        if md.Magnitude > 0 then
            local lv = cam.CFrame:VectorToObjectSpace(md)
            dir = cam.CFrame.LookVector * -lv.Z + cam.CFrame.RightVector * lv.X
        end
        if S.UIS:IsKeyDown(Enum.KeyCode.Space) or (h and h.Jump) then dir = dir + Vector3.new(0,1,0) end
        if S.UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then dir = dir.Unit end
        flyBV.Velocity = dir * St.FlySpeed
        flyBG.CFrame = cam.CFrame
    end)
    conn(S.UIS.JumpRequest, function()
        if not St.InfJump or St.Destroyed then return end
        local h = getHum()
        if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

--====================================================================================
-- BOOT
--====================================================================================
notify(AUTHOR.brand.." "..AUTHOR.version, "Đã load — MEGA FULL EDITION", 8)
print("═══════════════════════════════════════════════════")
print("  "..AUTHOR.brand.." "..AUTHOR.version.." — MEGA FULL")
print("  MADE BY "..AUTHOR.name:upper().." · ZALO "..AUTHOR.zalo)
print("  Sea: "..tostring(SEA or "?"))
print("  CommF_: "..tostring(R.CommF ~= nil))
print("  Attack: "..tostring(R.Attack ~= nil).." · Hit: "..tostring(R.Hit ~= nil))
print("  Quest logic: đánh đủ → chờ 1.5s → nhận mới")
print("  17 tab UI · 60+ chức năng")
print("═══════════════════════════════════════════════════")
