-- HL HUB v10.1 DEBUG: neu loi, noi dung loi duoc COPY vao clipboard + hien thong bao
local __ok, __err = xpcall(function()
--[[====================================================================================
  HOÀNG LÂM HUB v10.1 — SPEED EDITION (FULL)
  MADE BY HOÀNG LÂM · ZALO 0363194767 · © 2026
  Key server: https://keyserver-hchy.onrender.com
  Blox Fruits · Sea 1/2/3 · Delta X / PC
  v10.1: farm chạy đa luồng (di chuyển / đánh / skill / bring tách riêng),
         hover trên đầu mob + gom mob, cache mob, tween hiệu quả,
         sửa toàn bộ lỗi UI / Panic / Anti-Stuck / Config / Fruit / Server Hop.
====================================================================================]]

if not game:IsLoaded() then game.Loaded:Wait() end
if not getgenv then getgenv = getfenv end

local AUTHOR = {
    name    = "Hoàng Lâm",
    zalo    = "0363194767",
    version = "v10.1",
    brand   = "HOÀNG LÂM HUB",
}
local SERVER_URL = "https://keyserver-hchy.onrender.com"
local KEY_FILE   = "HL_key.txt"
local CFG_FILE   = "HL_config.json"

--====================================================================================
-- KEY SYSTEM
--====================================================================================
do
    local Http = game:GetService("HttpService")
    local LPk  = game:GetService("Players").LocalPlayer
    local SGk  = game:GetService("StarterGui")
    local GUIk = (gethui and gethui()) or game:GetService("CoreGui")

    local function notifyk(t, x, d)
        pcall(function() SGk:SetCore("SendNotification", { Title = t, Text = x, Duration = d or 5 }) end)
    end
    local function enc(s)
        return (tostring(s):gsub("([^%w%-_%.~])", function(c) return string.format("%%%02X", string.byte(c)) end))
    end
    local function httpGet(url)
        local ok, b = pcall(function() return game:HttpGet(url) end)
        if ok and b and b ~= "" then return b end
        local req = request or http_request or (syn and syn.request)
        if req then
            local ok2, res = pcall(req, { Url = url, Method = "GET" })
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
            r = tostring(r):gsub("%s+", "")
            if #r >= 3 then return r end
        end
        return "UID_" .. tostring(LPk and LPk.UserId or 0)
    end
    local HWID = hwidf()
    local function api(path)
        local body = httpGet(SERVER_URL .. path)
        if not body then return nil, "Không kết nối server key (chờ 30-60s)." end
        local ok, d = pcall(function() return Http:JSONDecode(body) end)
        if not ok or type(d) ~= "table" then return nil, "Server trả sai định dạng." end
        return d
    end
    local REASON = {
        expired    = "Key hết hạn. Bấm GET KEY.",
        wrong_hwid = "Key thuộc máy khác.",
        not_found  = "Key không đúng.",
        missing    = "Thiếu key.",
    }
    local function verify(key)
        key = (tostring(key or ""):gsub("%s+", "")):upper()
        if key == "" then return false, "Chưa nhập key." end
        local d, err = api("/api/verify?key=" .. enc(key) .. "&hwid=" .. enc(HWID))
        if not d then return false, err end
        if d.status == "success" and d.valid == true then return true, tonumber(d.expiresAt) end
        return false, REASON[d.reason] or "Key không hợp lệ."
    end
    local function saveK(k)
        pcall(function() if writefile then writefile(KEY_FILE, (tostring(k):gsub("%s+", ""))) end end)
    end
    local function clearK()
        pcall(function() if delfile and isfile and isfile(KEY_FILE) then delfile(KEY_FILE) end end)
    end

    local PASSED = false
    do
        local s
        pcall(function()
            if isfile and isfile(KEY_FILE) and readfile then
                s = (tostring(readfile(KEY_FILE) or ""):gsub("%s+", ""))
            end
        end)
        if s and s ~= "" then
            if verify(s) then
                PASSED = true
                notifyk(AUTHOR.brand, "Key còn hạn — tự đăng nhập ✔")
            else
                clearK()
            end
        end
    end

    if not PASSED then
        pcall(function() local o = GUIk:FindFirstChild("HL_KeyUI") if o then o:Destroy() end end)
        local Tk = {
            bg0=Color3.fromRGB(6,8,14), bg1=Color3.fromRGB(12,15,24),
            bg2=Color3.fromRGB(18,22,34), bg3=Color3.fromRGB(26,32,48),
            txt=Color3.fromRGB(240,244,255), dim=Color3.fromRGB(150,160,185),
            fnt=Color3.fromRGB(78,88,112), acc=Color3.fromRGB(255,200,90),
            hot=Color3.fromRGB(255,230,160), ok=Color3.fromRGB(72,235,168),
            bad=Color3.fromRGB(255,100,115),
        }
        local Fk = { black=Enum.Font.GothamBlack, bold=Enum.Font.GothamBold, reg=Enum.Font.Gotham, mono=Enum.Font.Code }
        local function mkk(c, p)
            local o = Instance.new(c)
            for k, v in pairs(p) do if k ~= "Parent" then pcall(function() o[k] = v end) end end
            o.Parent = p.Parent
            return o
        end
        local function cork(o, r) mkk("UICorner", { CornerRadius=UDim.new(0, r or 8), Parent=o }) end
        local function strok(o, c, t, tr)
            mkk("UIStroke", { Color=c or Tk.acc, Thickness=t or 1, Transparency=tr or 0.4, ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=o })
        end

        local sgk = mkk("ScreenGui", { Name="HL_KeyUI", ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=GUIk })
        local Wk, Hk = 400, 540
        local maink = mkk("Frame", { Size=UDim2.new(0,Wk,0,Hk), Position=UDim2.new(0.5,-Wk/2,0.5,-Hk/2), BackgroundColor3=Tk.bg0, BorderSizePixel=0, Active=true, Draggable=true, Parent=sgk })
        cork(maink, 18); strok(maink, Tk.acc, 1.2, 0.5)
        mkk("Frame", { Size=UDim2.new(1,-36,0,2), Position=UDim2.new(0,18,0,0), BackgroundColor3=Tk.acc, BorderSizePixel=0, Parent=maink })
        local logok = mkk("Frame", { Size=UDim2.new(0,58,0,58), Position=UDim2.new(0,28,0,26), BackgroundColor3=Tk.bg3, BorderSizePixel=0, Parent=maink })
        cork(logok, 999); strok(logok, Tk.acc, 1.5, 0.3)
        mkk("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="HL", Font=Fk.black, TextSize=24, TextColor3=Tk.hot, Parent=logok })
        mkk("TextLabel", { Size=UDim2.new(0,280,0,26), Position=UDim2.new(0,100,0,30), BackgroundTransparency=1, Text=AUTHOR.brand.." "..AUTHOR.version, Font=Fk.black, TextSize=20, TextColor3=Tk.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=maink })
        mkk("TextLabel", { Size=UDim2.new(0,280,0,16), Position=UDim2.new(0,100,0,58), BackgroundTransparency=1, Text="MADE BY "..AUTHOR.name:upper().." · ZALO "..AUTHOR.zalo, Font=Fk.reg, TextSize=10, TextColor3=Tk.fnt, TextXAlignment=Enum.TextXAlignment.Left, Parent=maink })
        local statusk = mkk("TextLabel", { Size=UDim2.new(1,-56,0,44), Position=UDim2.new(0,28,0,100), BackgroundTransparency=1, Text="Dán key để sử dụng.", Font=Fk.reg, TextSize=12, TextColor3=Tk.dim, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextWrapped=true, Parent=maink })
        local function setStatk(s, c) statusk.Text = s statusk.TextColor3 = c or Tk.dim end
        mkk("TextLabel", { Size=UDim2.new(1,-56,0,14), Position=UDim2.new(0,28,0,148), BackgroundTransparency=1, Text="YOUR KEY", Font=Fk.bold, TextSize=10, TextColor3=Tk.fnt, TextXAlignment=Enum.TextXAlignment.Left, Parent=maink })
        local keyBoxk = mkk("TextBox", { Size=UDim2.new(1,-56,0,46), Position=UDim2.new(0,28,0,166), BackgroundColor3=Tk.bg2, BorderSizePixel=0, PlaceholderText="HL-XXXX-XXXX-XXXX", PlaceholderColor3=Tk.fnt, Text="", Font=Fk.mono, TextSize=14, TextColor3=Tk.hot, ClearTextOnFocus=false, Parent=maink })
        cork(keyBoxk, 10); strok(keyBoxk, Tk.acc, 1, 0.6)
        local function btnk(txt, y, bg)
            local b = mkk("TextButton", { Size=UDim2.new(1,-56,0,46), Position=UDim2.new(0,28,0,y), BackgroundColor3=bg, BorderSizePixel=0, Text=txt, Font=Fk.black, TextSize=14, TextColor3=Color3.new(1,1,1), AutoButtonColor=true, Parent=maink })
            cork(b, 11)
            return b
        end
        local verifyBtnk = btnk("✔  VERIFY KEY", 226, Color3.fromRGB(30,120,88))
        mkk("TextLabel", { Size=UDim2.new(1,-56,0,16), Position=UDim2.new(0,28,0,284), BackgroundTransparency=1, Text="— CHƯA CÓ KEY? —", Font=Fk.bold, TextSize=10, TextColor3=Tk.fnt, Parent=maink })
        local getBtnk = btnk("📋  GET KEY (COPY LINK)", 306, Color3.fromRGB(40,92,148))
        local buyBtnk = btnk("💰  MUA KEY (ZALO)", 356, Color3.fromRGB(150,100,30))
        local linkBoxk = mkk("TextBox", { Size=UDim2.new(1,-56,0,60), Position=UDim2.new(0,28,0,412), BackgroundColor3=Tk.bg1, BorderSizePixel=0, Text="Link vượt sẽ hiện ở đây.", Font=Fk.mono, TextSize=11, TextColor3=Tk.dim, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, ClearTextOnFocus=false, TextEditable=true, Parent=maink })
        cork(linkBoxk, 10)
        mkk("UIPadding", { PaddingTop=UDim.new(0,8), PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10), PaddingBottom=UDim.new(0,8), Parent=linkBoxk })
        mkk("TextLabel", { Size=UDim2.new(1,-56,0,40), Position=UDim2.new(0,28,0,480), BackgroundTransparency=1, Text="© 2026 "..AUTHOR.name.." · Zalo "..AUTHOR.zalo, Font=Fk.reg, TextSize=10, TextColor3=Tk.fnt, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, Parent=maink })

        getBtnk.MouseButton1Click:Connect(function()
            setStatk("Đang tạo link...", Tk.dim)
            local d, err = api("/api/getlink?hwid=" .. enc(HWID))
            if not d then setStatk("✘ " .. tostring(err), Tk.bad) return end
            if d.status == "success" and d.link then
                linkBoxk.Text = d.link
                pcall(function() if setclipboard then setclipboard(d.link) end end)
                setStatk("✔ Đã COPY link.", Tk.ok)
            else
                setStatk("✘ " .. tostring(d.message or "Lỗi."), Tk.bad)
            end
        end)
        buyBtnk.MouseButton1Click:Connect(function()
            setStatk("Liên hệ Zalo " .. AUTHOR.zalo, Tk.hot)
            pcall(function() if setclipboard then setclipboard(AUTHOR.zalo) end end)
        end)
        verifyBtnk.MouseButton1Click:Connect(function()
            setStatk("Đang kiểm tra...", Tk.dim)
            local ok, info = verify(keyBoxk.Text)
            if ok then
                saveK(keyBoxk.Text)
                setStatk("✔ Key hợp lệ!", Tk.ok)
                notifyk(AUTHOR.brand, "Key hợp lệ ✔")
                task.wait(0.6)
                sgk:Destroy()
                PASSED = true
            else
                setStatk("✘ " .. tostring(info), Tk.bad)
            end
        end)
        while not PASSED do task.wait(0.15) end
    end
end

pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="HL DEBUG",Text="1/4 Key OK",Duration=5}) end)
--====================================================================================
-- CORE
--====================================================================================
local S = {
    Players = game:GetService("Players"),
    Run     = game:GetService("RunService"),
    Tween   = game:GetService("TweenService"),
    UIS     = game:GetService("UserInputService"),
    RS      = game:GetService("ReplicatedStorage"),
    WS      = game:GetService("Workspace"),
    Light   = game:GetService("Lighting"),
    TP      = game:GetService("TeleportService"),
    Http    = game:GetService("HttpService"),
    VU      = game:GetService("VirtualUser"),
    SG      = game:GetService("StarterGui"),
}
local LP     = S.Players.LocalPlayer
local GUI    = (gethui and gethui()) or game:GetService("CoreGui")
local MOBILE = S.UIS.TouchEnabled and not S.UIS.MouseEnabled
local VP     = S.WS.CurrentCamera.ViewportSize

if not firetouchinterest then firetouchinterest = function() end end
if not fireclickdetector then fireclickdetector = function() end end

pcall(function()
    for _, g in ipairs(GUI:GetChildren()) do
        if g.Name == "HL_Hub" or g.Name == "HL_Watermark" or g.Name == "HL_KeyUI" then g:Destroy() end
    end
    local old = S.WS:FindFirstChild("HL_MoveBlock")
    if old then old:Destroy() end
end)

local UNPACK = table.unpack or unpack
local function notify(t, x, d)
    pcall(function() S.SG:SetCore("SendNotification", { Title = t, Text = x, Duration = d or 4 }) end)
end

-- kết nối sự kiện có thể gỡ khi Unload
local CONN = {}
local function conn(sig, fn)
    local c = sig:Connect(fn)
    CONN[#CONN + 1] = c
    return c
end

-- REMOTES
local R = {}
do
    local rm = S.RS:FindFirstChild("Remotes") or S.RS:FindFirstChild("Remote")
    if rm then
        R.CommF = rm:FindFirstChild("CommF_") or rm:FindFirstChild("CommF") or rm:FindFirstChild("CommE_")
        R.Raids = rm:FindFirstChild("Raids")
        R.Btn   = rm:FindFirstChild("ButtonEnabler")
    end
    local md = S.RS:FindFirstChild("Modules")
    if md then
        local net = md:FindFirstChild("Net")
        if net then
            R.Attack = net:FindFirstChild("RE/RegisterAttack")
            R.Hit    = net:FindFirstChild("RE/RegisterHit")
        end
    end
end
local function Invoke(...)
    if not R.CommF then return nil end
    local a = { ... }
    local ok, r = pcall(function() return R.CommF:InvokeServer(UNPACK(a)) end)
    return ok and r or nil
end

-- HELPERS
local function getRoot()
    local c = LP.Character
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
end
local function getHum() local c = LP.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function pos() local r = getRoot() return r and r.Position or Vector3.new(0, 0, 0) end
local function dist(a, b) return (a - b).Magnitude end
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
-- MOVE (tween MoveBlock + ghim nhân vật)
--====================================================================================
local MoveBlock = Instance.new("Part")
MoveBlock.Name = "HL_MoveBlock"
MoveBlock.Size = Vector3.new(1, 1, 1)
MoveBlock.Anchored = true
MoveBlock.CanCollide = false
MoveBlock.CanTouch = false
MoveBlock.Transparency = 1
MoveBlock.Parent = S.WS

local ShouldTween, TweenInst, TweenTarget = false, nil, nil
local currentSpeed = 260

local function unclip(on)
    local c = LP.Character if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = not on end
    end
end
local function cancelTween()
    if TweenInst then pcall(function() TweenInst:Cancel() end) end
    TweenInst, TweenTarget = nil, nil
end
local function stopMoving()
    ShouldTween = false
    cancelTween()
    unclip(false)
end
conn(S.Run.Heartbeat, function()
    if not ShouldTween then return end
    local hrp = getRoot() if not hrp then return end
    if dist(hrp.Position, MoveBlock.Position) <= 300 then
        hrp.CFrame = MoveBlock.CFrame
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    else
        MoveBlock.CFrame = hrp.CFrame
    end
    unclip(true)
end)
local function moveTo(cf, sp)
    local hrp = getRoot() if not hrp then return end
    cf = typeof(cf) == "CFrame" and cf or CFrame.new(cf)
    -- đang tween tới đúng chỗ này rồi thì thôi (tránh tạo tween mỗi tick)
    if ShouldTween and TweenInst and TweenTarget and (TweenTarget - cf.Position).Magnitude < 4 then return end
    local d = dist(hrp.Position, cf.Position)
    cancelTween()
    if d <= 5 then
        MoveBlock.CFrame = cf
        hrp.CFrame = cf
        return
    end
    MoveBlock.CFrame = hrp.CFrame
    ShouldTween = true
    TweenTarget = cf.Position
    local tw = S.Tween:Create(MoveBlock, TweenInfo.new(d / (sp or currentSpeed), Enum.EasingStyle.Linear), { CFrame = cf })
    TweenInst = tw
    tw.Completed:Connect(function(state)
        if state == Enum.PlaybackState.Completed and TweenInst == tw then
            ShouldTween = false
            TweenInst, TweenTarget = nil, nil
            unclip(false)
        end
    end)
    tw:Play()
end
local function teleportTo(cf)
    local hrp = getRoot() if not hrp then return end
    cf = typeof(cf) == "CFrame" and cf or CFrame.new(cf)
    cancelTween()
    ShouldTween = false
    MoveBlock.CFrame = cf
    hrp.CFrame = cf
end

--====================================================================================
-- DATA
--====================================================================================
local D = {}
D.CHEAP = {
    "Rocket-Rocket","Spin-Spin","Blade-Blade","Chop-Chop","Spring-Spring",
    "Bomb-Bomb","Smoke-Smoke","Spike-Spike","Flame-Flame","Ice-Ice",
    "Sand-Sand","Dark-Dark","Diamond-Diamond","Light-Light","Rubber-Rubber",
    "Ghost-Ghost","Revive-Revive","Magma-Magma",
}
D.BOSSES = {
    [1] = { "The Gorilla King","Bobby","Yeti","Mob Leader","Vice Admiral","Saber Expert" },
    [2] = { "Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Ice Admiral","Ghost Captain","Don Swan","Smoke Admiral","Cursed Captain","Darkbeard","Order","Diamond","Jeremy","Fajita","Kilo Admiral","Captain Elephant","Beautiful Pirate","Longma","Hydra Leader","Trial of God" },
    [3] = { "Stone","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate","Longma","Trial of God","Cake Queen","Cursed Captain","Soul Reaper","Dough King","Rip_indra","Ope","Cursed Skeleton" },
}
D.MOBS = {
    [1] = { "Bandit","Monkey","Gorilla","Pirate","Brute","Desert Bandit","Desert Officer","Snow Bandit","Snowman","Chief Petty Officer","Sky Bandit","Dark Master","Prisoner","Dangerous Prisoner","Toga Warrior","Gladiator","Military Soldier","Military Spy","Fishman Warrior","Fishman Commando","God's Guard","Shanda","Royal Squad","Royal Soldier","Galley Pirate","Galley Captain" },
    [2] = { "Raider","Mercenary","Swan Pirate","Factory Staff","Marine Lieutenant","Marine Captain","Zombie","Vampire","Snow Trooper","Winter Warrior","Lab Subordinate","Horned Warrior","Magma Ninja","Lava Pirate","Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter" },
    [3] = { "Pirate Millionaire","Pistol Billionaire","Dragon Crew Warrior","Dragon Crew Archer","Hydra Enforcer","Venomous Assailant","Marine Commodore","Marine Rear Admiral","Fishman Raider","Fishman Captain","Forest Pirate","Jungle Pirate","Musketeer Pirate","Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy","Peanut Scout","Peanut President","Ice Cream Chef","Ice Cream Commander","Cookie Crafter","Cake Guard","Baking Staff","Head Baker","Cocoa Warrior","Chocolate Bar Battler","Sweet Thief","Candy Rebel","Candy Pirate","Snow Demon","Isle Outlaw","Island Boy","Isle Champion","Skull Slayer","Reef Bandit","Coral Pirate","Sea Chanter","Ocean Prophet","High Disciple","Grand Devotee" },
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
        {"Dragon-West",4,15000000},{"Dragon-East",4,15000000},
    }
    D.FRUITS = {}
    D.FRUIT_BY_KEY = {}
    for _, f in ipairs(FR) do
        local e = { name = f[1], rarity = f[2], price = f[3] }
        D.FRUITS[#D.FRUITS + 1] = e
        D.FRUIT_BY_KEY[f[1]] = e
        D.FRUIT_BY_KEY[f[1]:match("^([^%-]+)") or f[1]] = e
    end
end
local function fruitInfo(n)
    if not n then return nil end
    return D.FRUIT_BY_KEY[n] or D.FRUIT_BY_KEY[tostring(n):match("^([^%-]+)") or ""]
end
local function fruitRarity(n) local e = fruitInfo(n) return e and e.rarity or 0 end
local function fruitPrice(n) local e = fruitInfo(n) return e and e.price or 0 end

-- QUEST TABLE: {maxLevel, mob, x, y, z, quest, id}
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
local function pickTarget(l)
    for _, r in ipairs(Q) do
        if l <= r[1] then return r[2], CFrame.new(r[3], r[4], r[5]), r[6], r[7] end
    end
    local r = Q[#Q]
    return r[2], CFrame.new(r[3], r[4], r[5]), r[6], r[7]
end

--====================================================================================
-- STATE
--====================================================================================
local St = {
    -- modes
    AutoLevel=false, AutoRaid=false, AutoBoss=false, AutoChest=false,
    AutoNearest=false, AutoSpecific=false,
    -- farm
    AutoQuest=true, AutoHaki=true, BringMobs=true, BringRange=350, BringRate=0.12,
    AutoEquip=true, EquipType="Melee", AttackRange=70, Hover=22,
    Speed=260, FarTP=false, AtkDelay=0.016, AtkBurst=1, LoopDelay=0.04,
    SafeMode=false, SafeHP=30,
    AutoSkill=true, SkillTime={Z=0,X=0,C=0}, SkillCD={Z=0.6,X=1.2,C=3},
    AutoStats=false, StatType="Melee",
    AntiStuck=true, StuckTime=0, LastPos=Vector3.new(0,0,0), MobTimeout=5,
    AutoBuyHaki=false,
    -- raid
    AutoBuyChip=false, AutoClearRaid=false, RaidChip="Flame",
    -- player
    NoClip=false, InfJump=false, Fly=false, FlySpeed=120, LockSpeed=false, WalkSpeed=50,
    -- fruit
    FruitSniper=false, FruitMinRarity=2, FruitBring=false, FruitNotify=false,
    AutoStoreFruit=false, StoreMinRarity=2, LastStoreFruit=0,
    LastFruitScan=0, FruitCache={}, NotifiedFruits={}, LastFruit=0, LastChest=0,
    -- esp
    ESPPlayers=false, ESPMobs=false, ESPBoss=false, ESPChests=false,
    ESPFruits=false, ESPNpcs=false, ESPRange=1500,
    -- hop
    HopPingMax=200, HopVisited={},
    -- runtime
    Sub="Idle", MyLevel=1, QuestLv=-1, QuestCur=0, QuestMax=0, QuestDone=false, QuestTry=0,
    Attacking=false, LastAttack=0, TargetName=nil, StuckCheck=0,
    HakiTry=0, HakiBuyTry=0, EquipTry=0, BossSeen=nil, BossKillLog={},
    LastChipBuy=0, LastSummonTry=0, RaidAttempts=0,
    Panic=false, Running=false, Orig={}, Destroyed=false,
}
local function anyMode()
    return St.AutoLevel or St.AutoRaid or St.AutoBoss or St.AutoChest
        or St.AutoNearest or St.AutoSpecific
end
local GUI_State = { SelectedBoss = "The Gorilla King", SelectedMob = "Bandit" }

--====================================================================================
-- WEAPON
--====================================================================================
local WPN = { Sword = {}, Melee = {}, Gun = {} }
for n in ("cutlass,katana,iron mace,dual katana,triple katana,dark blade,yoru,wando,shisui,saddi,koko,tushita,bisento,pole,trident,true triple katana,cursed dual katana,dark dagger,buddy sword,dragon heart,canvander,rengoku,spikey trident,midnight blade,hallow scythe,yama,fox lamp,longsword,gravity cane,ice sword,flame sword,sand sword,pipe,soul cane,shark saw"):gmatch("[^,]+") do WPN.Sword[n] = true end
for n in ("combat,black leg,electro,fishman karate,dragon talon,superhuman,death step,sharkman karate,electric claw,godhuman,sanguine art"):gmatch("[^,]+") do WPN.Melee[n] = true end
for n in ("flintlock,musket,slingshot,dual flintlock,refined slingshot,bizarre rifle,kabucha,acidum rifle,serpent bow,soul guitar"):gmatch("[^,]+") do WPN.Gun[n] = true end

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
    end
    if t:FindFirstChild("GunClient") or t:FindFirstChild("GunType") then return "Gun" end
    if t:FindFirstChild("SwordClient") or t:FindFirstChild("Blade") then return "Sword" end
    if n:find("sword") or n:find("blade") or n:find("katana") then return "Sword" end
    if n:find("gun") or n:find("pistol") or n:find("rifle") or n:find("bow") then return "Gun" end
    if t:FindFirstChild("Handle") then return "Melee" end
end
local function equipWeapon()
    if not St.AutoEquip then return end
    if tick() - St.EquipTry < 0.5 then return end
    local c, bp = LP.Character, LP:FindFirstChild("Backpack")
    if not c or not bp then return end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") and classify(t) == St.EquipType then return end
    end
    for _, t in ipairs(bp:GetChildren()) do
        if t:IsA("Tool") and classify(t) == St.EquipType then
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
    local function sp(i, p) St.Orig[i] = St.Orig[i] or {} if St.Orig[i][p] == nil then pcall(function() St.Orig[i][p] = i[p] end) end end
    local function rp(i, p) if St.Orig[i] and St.Orig[i][p] ~= nil then pcall(function() i[p] = St.Orig[i][p] end) end end
    local function isFx(i) return i:IsA("ParticleEmitter") or i:IsA("Fire") or i:IsA("Smoke") or i:IsA("Sparkles") end
    FPS.shadows = function(on) if on then sp(S.Light, "GlobalShadows") pcall(function() S.Light.GlobalShadows = false end) else rp(S.Light, "GlobalShadows") end end
    FPS.postfx = function(on)
        for _, fx in ipairs(S.Light:GetChildren()) do
            if fx:IsA("BloomEffect") or fx:IsA("BlurEffect") or fx:IsA("DepthOfFieldEffect") or fx:IsA("SunRaysEffect") or fx:IsA("ColorCorrectionEffect") then
                if on then sp(fx, "Enabled") pcall(function() fx.Enabled = false end) else rp(fx, "Enabled") end
            end
        end
    end
    FPS.atmosphere = function(on)
        if on then
            sp(S.Light, "FogEnd") sp(S.Light, "FogStart")
            pcall(function() S.Light.FogEnd = 0 S.Light.FogStart = 0 end)
            for _, at in ipairs(S.Light:GetChildren()) do
                if at:IsA("Atmosphere") then sp(at, "Density") sp(at, "Haze") pcall(function() at.Density = 0 at.Haze = 0 end) end
            end
        else
            rp(S.Light, "FogEnd") rp(S.Light, "FogStart")
            for _, at in ipairs(S.Light:GetChildren()) do
                if at:IsA("Atmosphere") then rp(at, "Density") rp(at, "Haze") end
            end
        end
    end
    FPS.terrain = function(on)
        local t = S.WS:FindFirstChildOfClass("Terrain") if not t then return end
        if on then
            sp(t, "WaterWaveSize") sp(t, "WaterReflectance") sp(t, "WaterTransparency")
            pcall(function() t.WaterWaveSize = 0 t.WaterReflectance = 0 t.WaterTransparency = 1 end)
        else rp(t, "WaterWaveSize") rp(t, "WaterReflectance") rp(t, "WaterTransparency") end
    end
    FPS.particles = function(on)
        if on then
            for _, d in ipairs(S.WS:GetDescendants()) do
                if isFx(d) and d.Enabled then sp(d, "Enabled") pcall(function() d.Enabled = false end) end
            end
        else
            for i in pairs(St.Orig) do if typeof(i) == "Instance" and isFx(i) then rp(i, "Enabled") end end
        end
    end
    FPS.decals = function(on)
        if on then
            for _, d in ipairs(S.WS:GetDescendants()) do
                if (d:IsA("Decal") or d:IsA("Texture")) and d.Transparency < 1 then sp(d, "Transparency") pcall(function() d.Transparency = 1 end) end
            end
        else
            for i in pairs(St.Orig) do if typeof(i) == "Instance" and (i:IsA("Decal") or i:IsA("Texture")) then rp(i, "Transparency") end end
        end
    end
    FPS.beams = function(on)
        if on then
            for _, d in ipairs(S.WS:GetDescendants()) do
                if (d:IsA("Beam") or d:IsA("Trail") or d:IsA("SelectionBox")) and d.Enabled then sp(d, "Enabled") pcall(function() d.Enabled = false end) end
            end
        else
            for i in pairs(St.Orig) do if typeof(i) == "Instance" and (i:IsA("Beam") or i:IsA("Trail") or i:IsA("SelectionBox")) then rp(i, "Enabled") end end
        end
    end
    FPS.lighting = function(on)
        if on then
            sp(S.Light, "Brightness") sp(S.Light, "ClockTime") sp(S.Light, "OutdoorAmbient") sp(S.Light, "Ambient")
            pcall(function() S.Light.Brightness = 0.5 S.Light.ClockTime = 0 S.Light.OutdoorAmbient = Color3.new(0,0,0) S.Light.Ambient = Color3.new(0,0,0) end)
        else rp(S.Light, "Brightness") rp(S.Light, "ClockTime") rp(S.Light, "OutdoorAmbient") rp(S.Light, "Ambient") end
    end
    FPS.restore = function()
        FPS.shadows(false) FPS.postfx(false) FPS.atmosphere(false) FPS.terrain(false)
        FPS.particles(false) FPS.decals(false) FPS.beams(false) FPS.lighting(false)
        St.Orig = {}
    end
end

--====================================================================================
-- ENEMY CACHE / QUEST / SKILL / ANTI-STUCK / HAKI
--====================================================================================
local EN = { list = {}, t = 0 }
local function enemies()
    local now = tick()
    if now - EN.t > 0.1 then
        EN.t = now
        local out = {}
        local f = S.WS:FindFirstChild("Enemies")
        if f then
            for _, e in ipairs(f:GetChildren()) do
                local h = e:FindFirstChildOfClass("Humanoid")
                local r = e:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then out[#out + 1] = { m = e, h = h, r = r } end
            end
        end
        EN.list = out
    end
    return EN.list
end

local function questProgress()
    local pg = LP:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local quest = main and main:FindFirstChild("Quest")
    if not quest or quest.Visible ~= true then return nil end
    local container = quest:FindFirstChild("Container")
    local title = container and container:FindFirstChild("QuestTitle")
    local lbl = title and title:FindFirstChild("Title")
    if not lbl then return nil end
    local text = lbl.Text or ""
    local c, m = text:match("%((%d+)%s*/%s*(%d+)%)")
    if c and m then return { cur = tonumber(c), max = tonumber(m) } end
    return nil
end

local function autoSkillTick()
    if not St.AutoSkill then return end
    if tick() - St.LastAttack > 1.2 then return end -- chỉ xài skill khi đang trúng mob
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

local function antiStuckTick()
    if not St.AntiStuck then return end
    local hrp = getRoot() if not hrp then return end
    local now = tick()
    if now - St.StuckCheck < 0.5 then return end
    St.StuckCheck = now
    if now - St.LastAttack < 2 or ShouldTween then
        St.StuckTime = 0
        St.LastPos = hrp.Position
        return
    end
    if (hrp.Position - St.LastPos).Magnitude < 2 then St.StuckTime = St.StuckTime + 0.5 else St.StuckTime = 0 end
    St.LastPos = hrp.Position
    if St.StuckTime >= (St.MobTimeout or 5) then
        St.StuckTime = 0
        St.Sub = "Anti-stuck"
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 15, 0)
    end
end

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

--====================================================================================
-- COMBAT (đánh + gom mob chạy luồng riêng)
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
                list[#list + 1] = { e.m, e.r }
                list[#list + 1] = e.m
            end
        end
    end
    if #list == 0 then return end
    St.LastAttack = tick()
    pcall(function()
        R.Attack:FireServer(0)
        R.Hit:FireServer(first, list, nil, "078da5141")
    end)
end

local function bringMobs(rangeOverride)
    local hrp = getRoot() if not hrp then return end
    local range = rangeOverride or St.BringRange
    local tgt = Vector3.new(hrp.Position.X, hrp.Position.Y - St.Hover, hrp.Position.Z)
    for _, e in ipairs(enemies()) do
        if e.h.Health > 0 and e.r.Parent and dist(e.r.Position, hrp.Position) <= range
            and (not St.TargetName or e.m.Name == St.TargetName) then
            local bp = e.r:FindFirstChild("HL_Bring")
            if not bp then
                bp = Instance.new("BodyPosition")
                bp.Name = "HL_Bring"
                bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bp.P = 200000
                bp.D = 500
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
    for _, e in ipairs(enemies()) do
        if e.m.Name == name then return e.m end
    end
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

-- bay tới trên đầu điểm p, tới gần thì ghim đứng yên (mob bị gom xuống dưới chân)
local function hoverAt(p)
    local hrp = getRoot() if not hrp then return end
    local a = p + Vector3.new(0, St.Hover, 0)
    local d = dist(hrp.Position, a)
    if d > 60 then
        if St.FarTP and d > 1500 then teleportTo(CFrame.new(a)) else moveTo(CFrame.new(a)) end
    else
        cancelTween()
        MoveBlock.CFrame = CFrame.new(a)
        ShouldTween = true
    end
end
local function targetFarm(mob, label)
    local mrp = mob and mob:FindFirstChild("HumanoidRootPart")
    if not mrp then St.Sub = label .. " · không có" return false end
    St.TargetName = mob.Name
    equipWeapon()
    St.Sub = label .. " · " .. dn(mob.Name)
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
                if p then out[#out + 1] = p end
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
        teleportTo(CFrame.new(c.Position + Vector3.new(0, 3, 0)))
        task.wait(0.12)
    else
        St.Sub = "Chest · không có"
        task.wait(0.5)
    end
end

--====================================================================================
-- FRUIT
--====================================================================================
local FR_EX = { "bloxfruit","meshes","/","fruitdealer","fruitshop","fruitview","fruitnotifier","fruitinventory","fruitremote" }
local function looksLikeFruit(inst)
    if not inst or not inst.Parent then return false end
    local n = inst.Name:lower()
    for _, x in ipairs(FR_EX) do if n:find(x, 1, true) then return false end end
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
            if p then out[#out + 1] = { inst = inst, name = inst.Name, pos = p, rarity = fruitRarity(inst.Name), price = fruitPrice(inst.Name) } end
        end
        for _, c in ipairs(inst:GetChildren()) do walk(c, depth + 1) end
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
                local tag = ({"Common","Uncommon","Rare","Legendary","Mythical"})[f.rarity + 1] or "?"
                notify("Fruit: " .. f.name, tag .. " · $" .. tostring(f.price), 5)
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
                St.Sub = "Fruit · " .. best.name
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
                        if h then h.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 3, 0)) end
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
                    St.Sub = "Kho · " .. nm
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
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 0.35
        lbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextColor3 = color
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextStrokeTransparency = 0.5
        lbl.Parent = bb
        local hl = Instance.new("Highlight")
        hl.FillColor = color
        hl.FillTransparency = 0.78
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = inst
        bb.Parent = inst
        e = { bb = bb, label = lbl, hl = hl }
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
                    espTrack(r, string.format("%s [Lv.%d] %dm", pl.Name, lv, dist(r.Position, me)), Color3.fromRGB(90, 255, 130))
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
                        isBoss and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(255, 175, 70))
                end
            end
        end
    end
    if St.ESPFruits then
        for _, f in ipairs(scanFruits()) do
            local d = dist(f.pos, me)
            if d < St.ESPRange then
                espTrack(f.inst, string.format("%s (r%d) · %dm", f.name, f.rarity, math.floor(d)), Color3.fromRGB(255, 110, 240))
            end
        end
    end
    if St.ESPChests then
        for _, p in ipairs(getChests()) do
            if p.Parent then
                local d = dist(p.Position, me)
                if d < St.ESPRange then
                    espTrack(p, string.format("RƯƠNG · %dm", math.floor(d)), Color3.fromRGB(255, 230, 90))
                end
            end
        end
    end
end

--====================================================================================
-- LEVEL FARM
--====================================================================================
local function runLevelFarm()
    local lv = myLevel()
    St.MyLevel = lv
    local eff = lv
    if SEA == 1 then eff = math.min(lv, 699)
    elseif SEA == 2 then eff = math.clamp(lv, 700, 1499)
    elseif SEA == 3 then eff = math.max(lv, 1500) end
    local mobName, giverCF, qName, qId = pickTarget(eff)
    if not mobName then St.Sub = "Không mục tiêu" task.wait(1) return end
    St.TargetName = mobName

    local qp = questProgress()
    if qp then
        St.QuestCur, St.QuestMax = qp.cur, qp.max
        St.QuestDone = (qp.cur >= qp.max)
    else
        St.QuestCur, St.QuestMax = 0, 0
    end

    if St.AutoQuest then
        local need = St.QuestLv ~= lv or St.QuestDone or (not qp and tick() - St.QuestTry > 4)
        if need then
            local hrp = getRoot()
            if hrp and dist(hrp.Position, giverCF.Position) > 14 then
                St.Sub = "→ NPC nhận quest"
                if St.FarTP and dist(hrp.Position, giverCF.Position) > 1500 then teleportTo(giverCF + Vector3.new(0, 4, 3))
                else moveTo(giverCF + Vector3.new(0, 4, 3)) end
                return
            end
            stopMoving()
            St.Sub = "Nhận quest: " .. qName
            Invoke("StartQuest", qName, qId)
            St.QuestLv = lv
            St.QuestDone = false
            St.QuestTry = tick()
            task.wait(0.25)
            return
        end
    end

    local live = findMob(mobName)
    if live then
        targetFarm(live, "Level")
        St.Sub = string.format("%s [Lv.%d] %d/%d", dn(mobName), lv, St.QuestCur, St.QuestMax)
    else
        St.Sub = "Đang tới → " .. dn(mobName)
        hoverAt(giverCF.Position)
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
                if t:IsA("Tool") and (t.Name == full or t.Name == s or t.Name == s .. "-" .. s or t.Name == s .. " Fruit") then return true end
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
            St.Sub = "Raid · " .. s
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
        St.Sub = "Raid · tìm bàn"
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
                    hrp.CFrame = CFrame.new(buttonPart.Position + Vector3.new(0, 3, 30), buttonPart.Position)
                    task.wait(0.15)
                    local endPos = buttonPart.Position + Vector3.new(0, 2, 6)
                    local d = dist(hrp.Position, endPos)
                    local tw2 = S.Tween:Create(hrp, TweenInfo.new(d / 80, Enum.EasingStyle.Linear), { CFrame = CFrame.new(endPos, buttonPart.Position) })
                    tw2:Play()
                    pcall(function() tw2.Completed:Wait() end)
                    unequipChip()
                    task.wait(0.1)
                    local click = buttonPart:FindFirstChildOfClass("ClickDetector")
                    if click then
                        pcall(function() fireclickdetector(click, 5) end) task.wait(0.12)
                        pcall(function() fireclickdetector(click, 1) end) task.wait(0.12)
                        pcall(function() fireclickdetector(click) end)
                    end
                    for _, dd in ipairs(summon:GetDescendants()) do
                        if dd:IsA("ClickDetector") and dd ~= click then pcall(function() fireclickdetector(dd, 5) end) end
                    end
                    pcall(function()
                        firetouchinterest(hrp, buttonPart, 0)
                        task.wait(0.05)
                        firetouchinterest(hrp, buttonPart, 1)
                    end)
                end
            end
            if R.Raids then
                pcall(function() R.Raids:FireServer("Start", St.RaidChip) end)
                pcall(function() R.Raids:FireServer("Start") end)
            end
            if R.Btn then pcall(function() R.Btn:FireServer("Start", St.RaidChip) end) end
            if R.CommF then
                pcall(function() R.CommF:InvokeServer("Raid", St.RaidChip) end)
                pcall(function() R.CommF:InvokeServer("StartRaid", St.RaidChip) end)
            end
        else
            St.Sub = "Raid · không thấy bàn"
            if R.CommF then pcall(function() R.CommF:InvokeServer("StartRaid", St.RaidChip) end) end
        end
        St.Sub = "Raid · xác minh"
        for _ = 1, 15 do
            task.wait(0.4)
            if inRaid() then St.Sub = "Raid · đã vào" St.RaidAttempts = 0 return end
        end
        St.Sub = "Raid · thử lại " .. St.RaidAttempts
        if St.RaidAttempts >= 4 then St.RaidAttempts = 0 St.LastChipBuy = 0 end
    end
    local function clearRaid()
        if not inRaid() then St.Sub = "Raid · chờ vào" return end
        if St.RaidChip == "Magma" or St.RaidChip == "Flame" then
            local map = S.WS:FindFirstChild("Map")
            if map then for _, d in ipairs(map:GetDescendants()) do if d.Name == "Lava" and d.Parent then pcall(function() d:Destroy() end) end end end
        end
        local names = { "Island 5", "Island 4", "Island 3", "Island 2", "Island 1" }
        local found
        local origin = S.WS:FindFirstChild("_WorldOrigin")
        local locs = origin and origin:FindFirstChild("Locations")
        local hrp = getRoot()
        if locs and hrp then
            for _, n in ipairs(names) do
                local t = locs:FindFirstChild(n)
                if t and dist(t.Position, hrp.Position) <= 3000 then found = t St.Sub = "Raid · " .. n break end
            end
        end
        if not found then
            local rm = S.WS:FindFirstChild("RaidMap")
            if rm then
                for _, n in ipairs(names) do
                    local t = rm:FindFirstChild(n)
                    if t then found = t St.Sub = "Raid · " .. n break end
                end
            end
        end
        if found and hrp then
            local p = found:IsA("BasePart") and found.Position or found:GetPivot().Position
            if dist(hrp.Position, p) > 100 then teleportTo(CFrame.new(p + Vector3.new(0, 120, 0))) task.wait(0.3) end
        elseif not found then
            St.Sub = "Raid · clear"
        end
        St.TargetName = nil
        bringMobs(5000)
    end
    RaidFns.hasChip, RaidFns.inRaid, RaidFns.buy, RaidFns.start, RaidFns.clear = hasChip, inRaid, buyChip, startRaid, clearRaid
end

--====================================================================================
-- SERVER HOP (theo ping) + CONFIG
--====================================================================================
local function serverHopPing()
    St.Sub = "Hop · tìm server"
    local list, cursor = {}, ""
    for _ = 1, 3 do
        local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100%s")
            :format(game.PlaceId, cursor ~= "" and ("&cursor=" .. cursor) or "")
        local ok, d = pcall(function() return S.Http:JSONDecode(game:HttpGet(url)) end)
        if not ok or type(d) ~= "table" or not d.data then break end
        for _, srv in ipairs(d.data) do
            if srv.id ~= game.JobId and not St.HopVisited[srv.id]
                and srv.playing and srv.maxPlayers
                and srv.playing > 0 and srv.playing < srv.maxPlayers - 1
                and (not srv.ping or srv.ping <= St.HopPingMax) then
                list[#list + 1] = srv
            end
        end
        cursor = d.nextPageCursor or ""
        if cursor == "" or #list >= 10 then break end
    end
    if #list == 0 then notify("Server Hop", "Không tìm thấy server phù hợp", 4) return end
    table.sort(list, function(a, b) return (a.ping or 999) < (b.ping or 999) end)
    local pick = list[math.random(1, math.min(3, #list))]
    St.HopVisited[pick.id] = true
    pcall(function() S.TP:TeleportToPlaceInstance(game.PlaceId, pick.id, LP) end)
end

local CFG_KEYS = {
    "AutoQuest","AutoHaki","BringMobs","BringRange","BringRate","AutoEquip","EquipType",
    "AttackRange","Hover","Speed","FarTP","WalkSpeed","AtkDelay","AtkBurst","SafeMode","SafeHP",
    "RaidChip","AutoBuyChip","AutoClearRaid","FlySpeed","FruitMinRarity","StoreMinRarity",
    "AntiStuck","MobTimeout","AutoSkill","HopPingMax","AutoBuyHaki","ESPRange","AutoStats","StatType",
}
local function saveConfig()
    pcall(function()
        if not writefile then return end
        local t = { SkillCD = St.SkillCD }
        for _, k in ipairs(CFG_KEYS) do t[k] = St[k] end
        writefile(CFG_FILE, S.Http:JSONEncode(t))
    end)
end
local function loadConfig()
    pcall(function()
        if not (readfile and isfile and isfile(CFG_FILE)) then return end
        local t = S.Http:JSONDecode(readfile(CFG_FILE))
        for _, k in ipairs(CFG_KEYS) do
            if t[k] ~= nil and type(t[k]) == type(St[k]) then St[k] = t[k] end
        end
        if type(t.SkillCD) == "table" then
            for k, v in pairs(t.SkillCD) do
                if type(v) == "number" and St.SkillCD[k] then St.SkillCD[k] = v end
            end
        end
    end)
    currentSpeed = St.Speed
end
loadConfig()

--====================================================================================
-- MAIN LOGIC LOOP (chỉ lo di chuyển / quest / chọn mục tiêu)
--====================================================================================
local function logBoss(name)
    St.BossKillLog[#St.BossKillLog + 1] = { name = name, at = os.date("%H:%M:%S") }
    notify("Boss", name .. " đã biến mất / bị hạ", 5)
end

local function step()
    local h = getHum()
    if St.Panic then
        St.Attacking = false St.Sub = "PANIC" task.wait(0.5) return
    end
    if not h or h.Health <= 0 then
        St.Attacking = false St.Sub = "Chết · chờ hồi sinh" task.wait(1) return
    end
    if St.SafeMode and h.MaxHealth > 0 and h.Health / h.MaxHealth * 100 < St.SafeHP then
        St.Attacking = false St.Sub = "Safe mode" task.wait(0.5) return
    end
    St.Attacking = true
    St.MyLevel = myLevel()
    checkHaki()
    autoBuyHakiTick()
    antiStuckTick()
    if St.AutoRaid then
        St.TargetName = nil
        if St.AutoClearRaid and RaidFns.inRaid() then RaidFns.clear()
        elseif RaidFns.hasChip() and not RaidFns.inRaid() then RaidFns.start()
        elseif St.AutoBuyChip and not RaidFns.hasChip() then RaidFns.buy()
        else St.Sub = "Raid · chờ" end
    elseif St.AutoBoss then
        local b = findBoss(GUI_State.SelectedBoss)
        if b then
            St.BossSeen = GUI_State.SelectedBoss
            targetFarm(b, "Boss")
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
    elseif St.AutoLevel then
        runLevelFarm()
    end
    task.wait(St.LoopDelay)
end

local function mainLoop()
    while anyMode() and not St.Destroyed do
        local ok, err = pcall(step)
        if not ok then
            warn("[HL] " .. tostring(err))
            task.wait(0.5)
        end
    end
    St.Attacking = false
    St.Sub = "Idle"
    St.TargetName = nil
    stopMoving()
    cleanBring()
end
local UI = {}
UI.upd = function()
    if anyMode() and not St.Running and not St.Destroyed then
        St.Running = true
        task.spawn(function() mainLoop() St.Running = false end)
    end
end

--====================================================================================
-- LUỒNG SONG SONG: ĐÁNH · BRING · SKILL · STATS · FRUIT · ESP · ANTI-AFK
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
task.spawn(function() -- bring
    pcall(function() sethiddenproperty(LP, "SimulationRadius", math.huge) end)
    local lastSim = 0
    while not St.Destroyed do
        task.wait(math.max(0.05, St.BringRate))
        if St.Attacking and St.BringMobs and not St.Panic and not St.AutoRaid then
            pcall(bringMobs)
            if tick() - lastSim > 5 then
                lastSim = tick()
                pcall(function() sethiddenproperty(LP, "SimulationRadius", math.huge) end)
            end
        end
    end
end)
task.spawn(function() -- skill
    while not St.Destroyed do
        task.wait(0.1)
        if St.Attacking and not St.Panic then pcall(autoSkillTick) end
    end
end)
task.spawn(function() -- auto stats
    while not St.Destroyed do
        task.wait(3)
        if St.AutoStats and R.CommF and not St.Panic then
            task.spawn(function() Invoke("AddPoint", St.StatType, 3) end)
        end
    end
end)
task.spawn(function() -- fruit
    while not St.Destroyed do
        task.wait(0.5)
        if not St.Panic then pcall(tickFruit) end
    end
end)
task.spawn(function() -- esp
    while not St.Destroyed do
        task.wait(0.6)
        if not St.Panic then pcall(espUpdate) end
    end
end)
conn(LP.Idled, function()
    pcall(function()
        S.VU:CaptureController()
        S.VU:ClickButton2(Vector2.new())
    end)
end)

pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="HL DEBUG",Text="2/4 Core OK (chua co UI)",Duration=5}) end)
--====================================================================================
-- PART 2 — UI 8 TAB / PLAYER MODS / WATERMARK / BOOT
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
local F = {
    black=Enum.Font.GothamBlack, bold=Enum.Font.GothamBold,
    med=Enum.Font.GothamMedium, reg=Enum.Font.Gotham, mono=Enum.Font.Code,
}
local function mk(c, p)
    local o = Instance.new(c)
    for k, v in pairs(p) do
        if k ~= "Parent" and k ~= "Children" then pcall(function() o[k] = v end) end
    end
    if p.Children then for _, c2 in ipairs(p.Children) do c2.Parent = o end end
    o.Parent = p.Parent
    return o
end
local function tw(o, t, p, s, d)
    S.Tween:Create(o, TweenInfo.new(t, s or Enum.EasingStyle.Quint, d or Enum.EasingDirection.Out), p):Play()
end
local function corner(o, r) mk("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = o }) end
local function stroke(o, c, t, tr)
    return mk("UIStroke", { Color=c or T.acc, Thickness=t or 1, Transparency=tr or 0.4, ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=o })
end
local ORD = {}
local function nx(par) ORD[par] = (ORD[par] or 0) + 1 return ORD[par] end

local sg = mk("ScreenGui", {
    Name="HL_Hub", ResetOnSpawn=false, IgnoreGuiInset=true,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=GUI, DisplayOrder=60,
})
local reopen = mk("TextButton", {
    Size=UDim2.new(0,110,0,34), Position=UDim2.new(0,14,0,170),
    BackgroundColor3=T.acc, Text="HOÀNG LÂM", Font=F.black, TextSize=13,
    TextColor3=T.bg0, Visible=false, Parent=sg,
})
corner(reopen, 10); stroke(reopen, T.hot, 1.5, 0.3)

local W = MOBILE and math.min(440, VP.X - 20) or 660
local H = MOBILE and math.min(440, VP.Y - 80) or 470

local main = mk("Frame", {
    Size=UDim2.new(0,W,0,H), Position=UDim2.new(0.5,-W/2,0.5,-H/2),
    BackgroundColor3=T.bg0, BorderSizePixel=0, Active=true,
    ClipsDescendants=true, Parent=sg,
})
corner(main, 20); stroke(main, T.border2, 1, 0.4)
local topGrad = mk("Frame", { Size=UDim2.new(1,-40,0,2), Position=UDim2.new(0,20,0,0), BackgroundColor3=T.acc, BorderSizePixel=0, Parent=main })
mk("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.bg0), ColorSequenceKeypoint.new(0.35, T.acc),
        ColorSequenceKeypoint.new(0.7, T.vio), ColorSequenceKeypoint.new(1, T.bg0),
    }), Parent=topGrad,
})
local glow = mk("Frame", {
    Size=UDim2.new(0,340,0,340), Position=UDim2.new(1,-170,0,-170),
    BackgroundColor3=T.acc, BackgroundTransparency=0.92, BorderSizePixel=0, Parent=main,
})
corner(glow, 999)

local header = mk("Frame", { Size=UDim2.new(1,0,0,66), BackgroundColor3=T.bg1, BackgroundTransparency=0.15, BorderSizePixel=0, Parent=main })
corner(header, 20)
mk("Frame", { Size=UDim2.new(1,0,0.5,0), Position=UDim2.new(0,0,0.5,0), BackgroundColor3=T.bg1, BackgroundTransparency=0.15, BorderSizePixel=0, Parent=header })
local logo = mk("Frame", { Size=UDim2.new(0,42,0,42), Position=UDim2.new(0,18,0.5,-21), BackgroundColor3=T.bg3, BorderSizePixel=0, Parent=header })
corner(logo, 12); stroke(logo, T.acc, 1, 0.3)
mk("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="HL", Font=F.black, TextSize=18, TextColor3=T.hot, Parent=logo })
mk("TextLabel", {
    Size=UDim2.new(0,200,0,20), Position=UDim2.new(0,74,0,14), BackgroundTransparency=1,
    Text=AUTHOR.brand.." "..AUTHOR.version, Font=F.black, TextSize=15, TextColor3=T.txt,
    TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=header,
})
mk("TextLabel", {
    Size=UDim2.new(0,200,0,15), Position=UDim2.new(0,74,0,36), BackgroundTransparency=1,
    Text="BY "..AUTHOR.name:upper().." · ZALO "..AUTHOR.zalo, Font=F.reg, TextSize=9, TextColor3=T.fnt,
    TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=header,
})
local pill = mk("Frame", { Size=UDim2.new(0,90,0,28), Position=UDim2.new(1,-160,0.5,-14), BackgroundColor3=T.bg2, BorderSizePixel=0, Parent=header })
corner(pill, 999)
local pillStroke = stroke(pill, T.border2, 1, 0.4)
local pillDot = mk("Frame", { Size=UDim2.new(0,8,0,8), Position=UDim2.new(0,12,0.5,-4), BackgroundColor3=T.fnt, BorderSizePixel=0, Parent=pill })
corner(pillDot, 999)
local pillText = mk("TextLabel", {
    Size=UDim2.new(1,-24,1,0), Position=UDim2.new(0,24,0,0), BackgroundTransparency=1,
    Text="IDLE", Font=F.bold, TextSize=11, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=pill,
})
local minBtn = mk("TextButton", {
    Size=UDim2.new(0,32,0,32), Position=UDim2.new(1,-76,0.5,-16), BackgroundColor3=T.bg3,
    BorderSizePixel=0, Text="—", Font=F.bold, TextSize=16, TextColor3=T.txt, AutoButtonColor=false, Parent=header,
})
corner(minBtn, 10)
local closeBtn = mk("TextButton", {
    Size=UDim2.new(0,32,0,32), Position=UDim2.new(1,-40,0.5,-16), BackgroundColor3=T.bg3,
    BorderSizePixel=0, Text="✕", Font=F.bold, TextSize=15, TextColor3=T.txt, AutoButtonColor=false, Parent=header,
})
corner(closeBtn, 10)

local body = mk("Frame", { Size=UDim2.new(1,0,1,-66), Position=UDim2.new(0,0,0,66), BackgroundTransparency=1, Parent=main })
local sidebar = mk("Frame", {
    Size=UDim2.new(0,156,1,-24), Position=UDim2.new(0,12,0,12),
    BackgroundColor3=T.bg1, BackgroundTransparency=0.3, BorderSizePixel=0, Parent=body,
})
corner(sidebar, 14); stroke(sidebar, T.border, 1, 0.5)
mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder, Parent=sidebar })
mk("UIPadding", { PaddingTop=UDim.new(0,10), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8), PaddingBottom=UDim.new(0,10), Parent=sidebar })
local pageHolder = mk("Frame", {
    Size=UDim2.new(1,-192,1,-24), Position=UDim2.new(0,180,0,12),
    BackgroundColor3=T.bg1, BackgroundTransparency=0.3, BorderSizePixel=0, Parent=body,
})
corner(pageHolder, 14); stroke(pageHolder, T.border, 1, 0.5)

local pages, tabBtns = {}, {}
local function newTab(label, order, key)
    local b = mk("TextButton", {
        Size=UDim2.new(1,0,0,30), BackgroundColor3=T.bg2, BackgroundTransparency=0.5,
        BorderSizePixel=0, Text="", AutoButtonColor=false, LayoutOrder=order, Parent=sidebar,
    })
    corner(b, 9)
    local ind = mk("Frame", { Size=UDim2.new(0,3,0,14), Position=UDim2.new(0,6,0.5,-7), BackgroundColor3=T.acc, BorderSizePixel=0, Visible=false, Parent=b })
    corner(ind, 999)
    local dot = mk("Frame", { Size=UDim2.new(0,6,0,6), Position=UDim2.new(0,16,0.5,-3), BackgroundColor3=T.fnt, BorderSizePixel=0, Parent=b })
    corner(dot, 999)
    local lbl = mk("TextLabel", {
        Size=UDim2.new(1,-34,1,0), Position=UDim2.new(0,28,0,0), BackgroundTransparency=1,
        Text=label, Font=F.med, TextSize=11, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=b,
    })
    tabBtns[key] = { btn=b, ind=ind, dot=dot, lbl=lbl }
end
local function newPage(key)
    local p = mk("Frame", { Name=key, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false, Parent=pageHolder })
    local sc = mk("ScrollingFrame", {
        Size=UDim2.new(1,-18,1,-18), Position=UDim2.new(0,9,0,9),
        BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=3,
        ScrollBarImageColor3=T.border2, ScrollBarImageTransparency=0.3,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ElasticBehavior=Enum.ElasticBehavior.Never, Parent=p,
    })
    mk("UIListLayout", { Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder, Parent=sc })
    pages[key] = { root=p, scroll=sc }
    return sc
end
local scHome, scFarm, scFruit = newPage("Home"), newPage("Farm"), newPage("Fruit")
local scAttack, scRaid, scMisc = newPage("Attack"), newPage("Raid"), newPage("Misc")
local scFPS, scAbout = newPage("FPS"), newPage("About")
for i, k in ipairs({"Home","Farm","Fruit","Attack","Raid","Misc","FPS","About"}) do newTab(k, i, k) end

--------------------------------------------------------------------------------
-- WIDGETS
--------------------------------------------------------------------------------
local function sec(par, txt)
    local w = mk("Frame", { Size=UDim2.new(1,0,0,24), BackgroundTransparency=1, LayoutOrder=nx(par), Parent=par })
    mk("TextLabel", {
        Size=UDim2.new(1,0,0,14), BackgroundTransparency=1, Text=txt, Font=F.bold, TextSize=10,
        TextColor3=T.fnt, TextXAlignment=Enum.TextXAlignment.Left, Parent=w,
    })
    mk("Frame", { Size=UDim2.new(0,22,0,2), Position=UDim2.new(0,0,0,18), BackgroundColor3=T.acc, BorderSizePixel=0, Parent=w })
    return w
end
local function glass(par, props, r)
    props.Parent = props.Parent or par
    props.LayoutOrder = props.LayoutOrder or nx(props.Parent)
    local f = mk("Frame", props)
    corner(f, r or 12); stroke(f, T.border2, 1, 0.5)
    return f
end
local function toggle(par, label, desc, def, cb)
    local hasDesc = desc and desc ~= ""
    local w = glass(par, {
        Size=UDim2.new(1,0,0, hasDesc and 72 or 54),
        BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0,
    })
    mk("TextLabel", {
        Size=UDim2.new(1,-100,0,18), Position=UDim2.new(0,16,0,11), BackgroundTransparency=1,
        Text=label, Font=F.bold, TextSize=13, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.AtEnd, Parent=w,
    })
    if hasDesc then
        mk("TextLabel", {
            Size=UDim2.new(1,-100,0,32), Position=UDim2.new(0,16,0,32), BackgroundTransparency=1,
            Text=desc, Font=F.reg, TextSize=11, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left,
            TextYAlignment=Enum.TextYAlignment.Top, TextWrapped=true, Parent=w,
        })
    end
    local tr = mk("Frame", { Size=UDim2.new(0,46,0,24), Position=UDim2.new(1,-62,0,15), BackgroundColor3=def and T.ok or T.bg3, BorderSizePixel=0, Parent=w })
    corner(tr, 999)
    local tS = stroke(tr, def and T.ok or T.border2, 1, 0.3)
    local kn = mk("Frame", {
        Size=UDim2.new(0,18,0,18), Position=def and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9),
        BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, Parent=tr,
    })
    corner(kn, 999)
    local st = def and true or false
    local function paint()
        tw(kn, 0.22, { Position = st and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9) })
        tw(tr, 0.22, { BackgroundColor3 = st and T.ok or T.bg3 })
        tS.Color = st and T.ok or T.border2
    end
    local click = mk("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", Parent=w })
    click.MouseButton1Click:Connect(function()
        st = not st
        St.Panic = false
        paint()
        if cb then cb(st) end
    end)
    return {
        set = function(v) v = v and true or false if st ~= v then st = v paint() if cb then cb(st) end end end,
        get = function() return st end,
    }
end
local function slider(par, label, desc, mn, mx, def, un, cb, step)
    step = step or 1
    local w = glass(par, { Size=UDim2.new(1,0,0,88), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
    mk("TextLabel", {
        Size=UDim2.new(1,-140,0,18), Position=UDim2.new(0,16,0,12), BackgroundTransparency=1,
        Text=label, Font=F.bold, TextSize=13, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=w,
    })
    local vl = mk("TextLabel", {
        Size=UDim2.new(0,120,0,18), Position=UDim2.new(1,-136,0,12), BackgroundTransparency=1,
        Text=tostring(def)..(un or ""), Font=F.mono, TextSize=12, TextColor3=T.hot,
        TextXAlignment=Enum.TextXAlignment.Right, Parent=w,
    })
    if desc and desc ~= "" then
        mk("TextLabel", {
            Size=UDim2.new(1,-36,0,30), Position=UDim2.new(0,16,0,32), BackgroundTransparency=1,
            Text=desc, Font=F.reg, TextSize=11, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left,
            TextYAlignment=Enum.TextYAlignment.Top, TextWrapped=true, Parent=w,
        })
    end
    local th = mk("Frame", { Size=UDim2.new(1,-32,0,24), Position=UDim2.new(0,16,0,60), BackgroundTransparency=1, BorderSizePixel=0, Parent=w })
    local tb = mk("Frame", { Size=UDim2.new(1,0,0,8), Position=UDim2.new(0,0,0.5,-4), BackgroundColor3=T.bg3, BorderSizePixel=0, Parent=th })
    corner(tb, 999)
    local r0 = math.clamp((def - mn) / math.max(1e-9, (mx - mn)), 0, 1)
    local fl = mk("Frame", { Size=UDim2.new(r0,0,1,0), BackgroundColor3=T.acc, BorderSizePixel=0, Parent=tb })
    corner(fl, 999)
    mk("UIGradient", { Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, T.acc), ColorSequenceKeypoint.new(1, T.hot) }), Parent=fl })
    local ks = MOBILE and 22 or 18
    local kn = mk("Frame", {
        Size=UDim2.new(0,ks,0,ks), Position=UDim2.new(r0,0,0.5,0), AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=3, Parent=th,
    })
    corner(kn, 999); stroke(kn, T.acc, 2, 0.2)
    local dragging = false
    local function apply(v)
        v = math.clamp(math.floor(v / step + 0.5) * step, mn, mx)
        local r = (v - mn) / math.max(1e-9, (mx - mn))
        fl.Size = UDim2.new(r, 0, 1, 0)
        kn.Position = UDim2.new(r, 0, 0.5, 0)
        vl.Text = tostring(math.floor(v * 100 + 0.5) / 100) .. (un or "")
        if cb then cb(v) end
    end
    local function upd(ax)
        local tx, tww = tb.AbsolutePosition.X, tb.AbsoluteSize.X
        if tww <= 0 then return end
        apply(mn + math.clamp((ax - tx) / tww, 0, 1) * (mx - mn))
    end
    th.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true upd(i.Position.X)
        end
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
    local w = glass(par, { Size=UDim2.new(1,0,0,80), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
    mk("TextLabel", {
        Size=UDim2.new(1,-36,0,18), Position=UDim2.new(0,16,0,12), BackgroundTransparency=1,
        Text=label, Font=F.bold, TextSize=13, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, Parent=w,
    })
    local row = mk("Frame", { Size=UDim2.new(1,-32,0,38), Position=UDim2.new(0,16,0,34), BackgroundColor3=T.bg3, BorderSizePixel=0, Parent=w })
    corner(row, 10)
    mk("UIListLayout", {
        FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder,
        VerticalAlignment=Enum.VerticalAlignment.Center, Parent=row,
    })
    mk("UIPadding", { PaddingLeft=UDim.new(0,4), PaddingRight=UDim.new(0,4), Parent=row })
    local btns, cur = {}, def
    local function paint()
        for n, b in pairs(btns) do
            local on = n == cur
            tw(b, 0.18, { BackgroundColor3 = on and T.acc or T.bg3 })
            b.TextColor3 = on and T.bg0 or T.dim
        end
    end
    for i, opt in ipairs(opts) do
        local b = mk("TextButton", {
            Size=UDim2.new(1/#opts,-4,1,-8), BackgroundColor3=cur==opt and T.acc or T.bg3, BorderSizePixel=0,
            Text=opt, Font=F.bold, TextSize=11, TextColor3=cur==opt and T.bg0 or T.dim,
            AutoButtonColor=false, LayoutOrder=i, Parent=row,
        })
        corner(b, 7); btns[opt] = b
        b.MouseButton1Click:Connect(function() cur = opt paint() if cb then cb(opt) end end)
    end
    paint()
    return { set = function(v) cur = v paint() if cb then cb(v) end end, get = function() return cur end }
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
    for _, e in ipairs(opts) do nd[#nd + 1] = norm(e) end
    local dN = norm(def)
    for _, o in ipairs(nd) do if o.value == dN.value then dN = o break end end
    mk("TextLabel", {
        Size=UDim2.new(1,-140,0,18), Position=UDim2.new(0,16,0,12), BackgroundTransparency=1,
        Text=label, Font=F.bold, TextSize=13, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11, Parent=w,
    })
    local curLabel = mk("TextLabel", {
        Size=UDim2.new(0,130,0,18), Position=UDim2.new(1,-136,0,12), BackgroundTransparency=1,
        Text=tostring(dN.display), Font=F.mono, TextSize=12, TextColor3=T.hot,
        TextXAlignment=Enum.TextXAlignment.Right, TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=11, Parent=w,
    })
    local row = mk("Frame", { Size=UDim2.new(1,-32,0,32), Position=UDim2.new(0,16,0,34), BackgroundColor3=T.bg3, BorderSizePixel=0, ZIndex=11, Parent=w })
    corner(row, 8); stroke(row, T.border2, 1, 0.4)
    mk("TextLabel", {
        Size=UDim2.new(0,20,1,0), Position=UDim2.new(1,-24,0,0), BackgroundTransparency=1, Text="▾",
        Font=F.bold, TextSize=12, TextColor3=T.dim, ZIndex=12, Parent=row,
    })
    local cur = { display=dN.display, value=dN.value }
    local btn = mk("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=12, Parent=row })
    local function close()
        if openDropdown and openDropdown.Parent then openDropdown:Destroy() end
        openDropdown = nil
    end
    btn.MouseButton1Click:Connect(function()
        if openDropdown and openDropdown.Parent and openDropdown:GetAttribute("Owner") == label then close() return end
        close()
        local listH = math.min(170, VP.Y * 0.35)
        local list = mk("ScrollingFrame", {
            Name="HL_DropList",
            Size=UDim2.new(0, row.AbsoluteSize.X, 0, listH),
            Position=UDim2.new(0, row.AbsolutePosition.X - sg.AbsolutePosition.X, 0, row.AbsolutePosition.Y - sg.AbsolutePosition.Y + row.AbsoluteSize.Y + 4),
            BackgroundColor3=T.bg1, BorderSizePixel=0, ScrollBarThickness=3, ScrollBarImageColor3=T.border2,
            CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=500, Parent=sg,
        })
        list:SetAttribute("Owner", label)
        corner(list, 8); stroke(list, T.border2, 1, 0.2)
        mk("UIListLayout", { Padding=UDim.new(0,2), SortOrder=Enum.SortOrder.LayoutOrder, Parent=list })
        mk("UIPadding", { PaddingTop=UDim.new(0,6), PaddingBottom=UDim.new(0,6), PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6), Parent=list })
        for i, opt in ipairs(nd) do
            local sel = cur.value == opt.value
            local b = mk("TextButton", {
                Size=UDim2.new(1,0,0,30), BackgroundColor3=sel and T.acc or T.bg3, BorderSizePixel=0,
                Text=tostring(opt.display), Font=F.med, TextSize=12, TextColor3=sel and T.bg0 or T.dim,
                TextXAlignment=Enum.TextXAlignment.Left, AutoButtonColor=false, LayoutOrder=i, ZIndex=501, Parent=list,
            })
            corner(b, 6)
            mk("UIPadding", { PaddingLeft=UDim.new(0,10), Parent=b })
            b.MouseButton1Click:Connect(function()
                cur = { display=opt.display, value=opt.value }
                curLabel.Text = tostring(opt.display)
                close()
                if cb then cb(opt.value) end
            end)
        end
        openDropdown = list
    end)
    return {
        set = function(v)
            for _, o in ipairs(nd) do
                if o.value == v then
                    cur = { display=o.display, value=o.value }
                    curLabel.Text = tostring(o.display)
                    if cb then cb(o.value) end
                    return
                end
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
    local b = mk("TextButton", {
        Size=UDim2.new(1,0,0, MOBILE and 42 or 40), BackgroundColor3=bg, BorderSizePixel=0,
        Text=label, Font=F.bold, TextSize=13, TextColor3=fg, AutoButtonColor=false, LayoutOrder=nx(par), Parent=par,
    })
    corner(b, 11); stroke(b, T.border2, 1, 0.4)
    b.MouseEnter:Connect(function() tw(b, 0.15, { BackgroundColor3 = bg:Lerp(Color3.new(1,1,1), 0.08) }) end)
    b.MouseLeave:Connect(function() tw(b, 0.15, { BackgroundColor3 = bg }) end)
    b.MouseButton1Click:Connect(function() task.spawn(function() pcall(cb) end) end)
    return b
end

local MT = {}   -- toggle của các mode farm (để "Dừng tất cả" tắt được hết)
local SL = {}   -- slider có thể chỉnh từ preset
local RARITY = { "Common","Uncommon","Rare","Legendary","Mythical" }
local RARITY_IDX = { Common=0, Uncommon=1, Rare=2, Legendary=3, Mythical=4 }

--------------------------------------------------------------------------------
-- HOME
--------------------------------------------------------------------------------
sec(scHome, "STATUS")
local statRow = mk("Frame", { Size=UDim2.new(1,0,0,80), BackgroundTransparency=1, LayoutOrder=nx(scHome), Parent=scHome })
mk("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder, Parent=statRow })
local function tile(lbl, v, col, order)
    local t = glass(statRow, {
        Size=UDim2.new(0.32,0,1,0), BackgroundColor3=T.bg2, BackgroundTransparency=0.15,
        BorderSizePixel=0, LayoutOrder=order,
    })
    mk("TextLabel", {
        Size=UDim2.new(1,-20,0,12), Position=UDim2.new(0,12,0,12), BackgroundTransparency=1,
        Text=lbl, Font=F.bold, TextSize=9, TextColor3=T.fnt, TextXAlignment=Enum.TextXAlignment.Left, Parent=t,
    })
    local vv = mk("TextLabel", {
        Size=UDim2.new(1,-20,0,22), Position=UDim2.new(0,12,0,28), BackgroundTransparency=1,
        Text=v, Font=F.black, TextSize=18, TextColor3=col, TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.AtEnd, Parent=t,
    })
    local dot = mk("Frame", { Size=UDim2.new(0,6,0,6), Position=UDim2.new(1,-14,1,-14), BackgroundColor3=col, BorderSizePixel=0, Parent=t })
    corner(dot, 999)
    return vv
end
local lvlTile = tile("LEVEL", "1", T.hot, 1)
local modeTile = tile("MODE", "None", T.vio, 2)
local statusTile = tile("STATUS", "Idle", T.ok, 3)
sec(scHome, "MODULE ĐANG BẬT")
local modCard = glass(scHome, { Size=UDim2.new(1,0,0,170), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
local modRow = mk("Frame", { Size=UDim2.new(1,-32,1,-28), Position=UDim2.new(0,16,0,14), BackgroundTransparency=1, Parent=modCard })
mk("UIListLayout", { Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder, Parent=modRow })
local function modLine(txt)
    local w = mk("Frame", { Size=UDim2.new(1,0,0,18), BackgroundTransparency=1, LayoutOrder=nx(modRow), Parent=modRow })
    local d = mk("Frame", { Size=UDim2.new(0,7,0,7), Position=UDim2.new(0,0,0.5,-3.5), BackgroundColor3=T.fnt, BorderSizePixel=0, Parent=w })
    corner(d, 999)
    local l = mk("TextLabel", {
        Size=UDim2.new(1,-18,1,0), Position=UDim2.new(0,14,0,0), BackgroundTransparency=1,
        Text=txt, Font=F.med, TextSize=12, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=w,
    })
    return { dot=d, lbl=l }
end
local mLines = {
    AutoLevel = modLine("Auto Level Farm"), AutoRaid = modLine("Auto Raid"),
    AutoBoss = modLine("Auto Boss"), AutoChest = modLine("Auto Chest"),
    AutoNearest = modLine("Auto Nearest"), AutoSpecific = modLine("Auto Specific"),
}

--------------------------------------------------------------------------------
-- FARM
--------------------------------------------------------------------------------
sec(scFarm, "LEVEL FARMING")
MT.AutoLevel = toggle(scFarm, "Auto Level Farm", "Tự đánh mob theo level + quest.", St.AutoLevel, function(v) St.AutoLevel = v UI.upd() end)
sec(scFarm, "MOB TARGET")
MT.AutoNearest = toggle(scFarm, "Auto Nearest Mob", "Mob gần nhất.", St.AutoNearest, function(v) St.AutoNearest = v UI.upd() end)
MT.AutoSpecific = toggle(scFarm, "Auto Specific Mob", "Mob chọn bên dưới.", St.AutoSpecific, function(v) St.AutoSpecific = v UI.upd() end)
local mobList = {}
for _, n in ipairs(D.MOBS[SEA] or D.MOBS[1]) do mobList[#mobList + 1] = { display = dn(n), value = n } end
GUI_State.SelectedMob = mobList[1].value
dropdown(scFarm, "Mob chỉ định", mobList, mobList[1].value, function(v) GUI_State.SelectedMob = v end)
sec(scFarm, "BOSS / RƯƠNG")
MT.AutoBoss = toggle(scFarm, "Auto Boss Farm", "Farm boss chọn.", St.AutoBoss, function(v) St.AutoBoss = v UI.upd() end)
local bossList = D.BOSSES[SEA] or D.BOSSES[1]
GUI_State.SelectedBoss = bossList[1]
dropdown(scFarm, "Boss", bossList, bossList[1], function(v) GUI_State.SelectedBoss = v end)
MT.AutoChest = toggle(scFarm, "Auto Chest", "Bay tới rương gần nhất.", St.AutoChest, function(v) St.AutoChest = v UI.upd() end)
sec(scFarm, "VŨ KHÍ")
toggle(scFarm, "Auto Equip Weapon", "Tự cầm vũ khí.", St.AutoEquip, function(v) St.AutoEquip = v end)
segments(scFarm, "Loại vũ khí", { "Melee", "Sword", "Gun" }, St.EquipType, function(v) St.EquipType = v end)
sec(scFarm, "PHỤ")
toggle(scFarm, "Auto Quest", "Đọc realtime (x/y), tự nhận lại khi mất.", St.AutoQuest, function(v) St.AutoQuest = v end)
toggle(scFarm, "Auto Skill Z/X/C", "Chỉ bấm khi đang trúng mob.", St.AutoSkill, function(v) St.AutoSkill = v end)
toggle(scFarm, "Auto Haki", "", St.AutoHaki, function(v) St.AutoHaki = v end)
toggle(scFarm, "Auto Buy Haki (Buso)", "Tự mua khi chưa có.", St.AutoBuyHaki, function(v) St.AutoBuyHaki = v end)
toggle(scFarm, "Bring Mobs", "Gom mob về dưới chân.", St.BringMobs, function(v) St.BringMobs = v end)
toggle(scFarm, "Anti-Stuck", "Kẹt không đánh được → nhấc lên.", St.AntiStuck, function(v) St.AntiStuck = v end)
toggle(scFarm, "Auto Stats", "Tự cộng điểm chỉ số.", St.AutoStats, function(v) St.AutoStats = v end)
dropdown(scFarm, "Chỉ số cộng", {
    { display="Melee", value="Melee" }, { display="Defense", value="Defense" },
    { display="Sword", value="Sword" }, { display="Gun", value="Gun" },
    { display="Blox Fruit", value="Demon Fruit" },
}, St.StatType, function(v) St.StatType = v end)
sec(scFarm, "TỐC ĐỘ / TINH CHỈNH")
toggle(scFarm, "Teleport xa", "Nhảy thẳng khi >1500 studs. Nhanh nhưng dễ bị kick.", St.FarTP, function(v) St.FarTP = v end)
SL.speed = slider(scFarm, "Speed", "Tốc độ bay tween.", 80, 450, St.Speed, " studs/s", function(v) St.Speed = v currentSpeed = v end)
SL.hover = slider(scFarm, "Hover Height", "Độ cao đứng trên mob.", 5, 100, St.Hover, " studs", function(v) St.Hover = v end)
slider(scFarm, "Attack Range", "", 30, 200, St.AttackRange, " studs", function(v) St.AttackRange = v end)
SL.bring = slider(scFarm, "Bring Range", "", 50, 800, St.BringRange, " studs", function(v) St.BringRange = v end)
SL.rate = slider(scFarm, "Bring Rate", "Chu kỳ gom mob.", 50, 500, math.floor(St.BringRate * 1000), " ms", function(v) St.BringRate = v / 1000 end, 10)
toggle(scFarm, "Safe Mode", "Máu thấp dừng farm.", St.SafeMode, function(v) St.SafeMode = v end)
slider(scFarm, "Ngưỡng máu %", "", 5, 95, St.SafeHP, " %", function(v) St.SafeHP = v end)
slider(scFarm, "Mob Timeout", "s đứng yên trước khi Anti-Stuck.", 2, 15, St.MobTimeout, " s", function(v) St.MobTimeout = v end)

--------------------------------------------------------------------------------
-- FRUIT
--------------------------------------------------------------------------------
sec(scFruit, "FRUIT SNIPER")
toggle(scFruit, "Fruit Sniper", "Bay tới fruit đủ hiếm.", St.FruitSniper, function(v) St.FruitSniper = v end)
segments(scFruit, "Rarity tối thiểu", RARITY, RARITY[St.FruitMinRarity + 1] or "Rare", function(v) St.FruitMinRarity = RARITY_IDX[v] or 2 end)
sec(scFruit, "FRUIT BRING / NOTIFY")
toggle(scFruit, "Fruit Bring", "Hút fruit về người.", St.FruitBring, function(v) St.FruitBring = v end)
toggle(scFruit, "Fruit Notifier", "Thông báo khi fruit spawn.", St.FruitNotify, function(v) St.FruitNotify = v end)
sec(scFruit, "AUTO STORE")
toggle(scFruit, "Auto Store Fruit", "Cất fruit vào kho.", St.AutoStoreFruit, function(v) St.AutoStoreFruit = v end)
segments(scFruit, "Rarity để cất", RARITY, RARITY[St.StoreMinRarity + 1] or "Rare", function(v) St.StoreMinRarity = RARITY_IDX[v] or 2 end)
sec(scFruit, "HÀNH ĐỘNG")
actBtn(scFruit, "Bay tới fruit gần nhất", function()
    local list = scanFruits(true)
    local hrp = getRoot()
    if not hrp then return end
    local best, bd
    for _, f in ipairs(list) do
        local d = dist(f.pos, hrp.Position)
        if not bd or d < bd then best, bd = f, d end
    end
    if best then teleportTo(CFrame.new(best.pos)) St.Sub = "Fruit · " .. best.name end
end, "primary")
actBtn(scFruit, "Xem kho fruit", function()
    local inv = Invoke("GetFruits")
    if type(inv) ~= "table" then return end
    local lines = {}
    for _, f in ipairs(inv) do
        local nm = type(f) == "table" and (f.Name or f.name) or tostring(f)
        lines[#lines + 1] = nm .. " [r" .. fruitRarity(nm) .. "]"
    end
    print("[HOÀNG LÂM HUB] Kho: " .. table.concat(lines, ", "))
    notify("Kho Fruit", #lines .. " fruit (xem Console)", 5)
end)
sec(scFruit, "DANH SÁCH FRUIT")
for _, f in ipairs(D.FRUITS) do
    local row = glass(scFruit, { Size=UDim2.new(1,0,0,32), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
    mk("TextLabel", {
        Size=UDim2.new(0.55,-14,1,0), Position=UDim2.new(0,14,0,0), BackgroundTransparency=1,
        Text=f.name, Font=F.med, TextSize=12, TextColor3=T.txt, TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.AtEnd, Parent=row,
    })
    mk("TextLabel", {
        Size=UDim2.new(0.45,-14,1,0), Position=UDim2.new(0.55,0,0,0), BackgroundTransparency=1,
        Text=RARITY[f.rarity + 1] .. " · $" .. tostring(f.price), Font=F.mono, TextSize=10,
        TextColor3=({T.fnt, T.dim, T.hot, T.vio, T.bad})[f.rarity + 1],
        TextXAlignment=Enum.TextXAlignment.Right, TextTruncate=Enum.TextTruncate.AtEnd, Parent=row,
    })
end

--------------------------------------------------------------------------------
-- ATTACK
--------------------------------------------------------------------------------
sec(scAttack, "TIMING")
SL.delay = slider(scAttack, "Attack Delay", "ms giữa các đòn. 0 = mỗi frame.", 0, 100, math.floor(St.AtkDelay * 1000 + 0.5), " ms", function(v) St.AtkDelay = v / 1000 end)
SL.burst = slider(scAttack, "Multi Hit", "Số lần gửi mỗi lượt.", 1, 5, St.AtkBurst, " hits", function(v) St.AtkBurst = math.floor(v) end)
sec(scAttack, "PRESET")
actBtn(scAttack, "An toàn — 33/s", function() SL.delay.set(30) SL.burst.set(1) end)
actBtn(scAttack, "Bình thường — 60/s", function() SL.delay.set(16) SL.burst.set(1) end, "primary")
actBtn(scAttack, "Nhanh — 120/s", function() SL.delay.set(8) SL.burst.set(2) end)
actBtn(scAttack, "TURBO — farm nhanh nhất", function()
    SL.delay.set(0) SL.burst.set(2) SL.speed.set(320) SL.bring.set(400) SL.rate.set(100) SL.hover.set(22)
    notify("TURBO", "Đã bật preset nhanh nhất (rủi ro cao hơn).", 4)
end, "ok")
actBtn(scAttack, "Cực nhanh — 300/s", function() SL.delay.set(0) SL.burst.set(5) end, "danger")
sec(scAttack, "SKILL")
slider(scAttack, "Skill Z CD", "s cooldown cho Z.", 0.1, 5, St.SkillCD.Z, " s", function(v) St.SkillCD.Z = v end, 0.1)
slider(scAttack, "Skill X CD", "", 0.1, 5, St.SkillCD.X, " s", function(v) St.SkillCD.X = v end, 0.1)
slider(scAttack, "Skill C CD", "", 0.1, 8, St.SkillCD.C, " s", function(v) St.SkillCD.C = v end, 0.1)

--------------------------------------------------------------------------------
-- RAID
--------------------------------------------------------------------------------
sec(scRaid, "MODE")
MT.AutoRaid = toggle(scRaid, "Auto Raid", "Mua chip + clear đảo.", St.AutoRaid, function(v) St.AutoRaid = v UI.upd() end)
sec(scRaid, "TÙY CHỌN")
toggle(scRaid, "Auto Buy Chip", "", St.AutoBuyChip, function(v) St.AutoBuyChip = v end)
toggle(scRaid, "Auto Clear Raid", "", St.AutoClearRaid, function(v) St.AutoClearRaid = v end)
dropdown(scRaid, "Loại chip",
    { "Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Door","Rubber","Barrier","Ghost","Revive","Dough","Soul","Chop" },
    St.RaidChip, function(v) St.RaidChip = v end)

--------------------------------------------------------------------------------
-- MISC
--------------------------------------------------------------------------------
sec(scMisc, "NHÂN VẬT")
toggle(scMisc, "No Clip", "", St.NoClip, function(v)
    St.NoClip = v
    if not v then
        local c = LP.Character
        if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
    end
end)
toggle(scMisc, "Fly (camera)", "Joystick / WASD, Space lên, Shift xuống.", St.Fly, function(v) St.Fly = v end)
slider(scMisc, "Fly Speed", "", 30, 400, St.FlySpeed, "", function(v) St.FlySpeed = v end)
toggle(scMisc, "Infinite Jump", "Nhảy liên tục (cả mobile).", St.InfJump, function(v) St.InfJump = v end)
toggle(scMisc, "Lock Speed/Jump", "Giữ WalkSpeed bên dưới.", St.LockSpeed, function(v) St.LockSpeed = v end)
slider(scMisc, "Walk Speed", "Dùng khi bật Lock Speed.", 16, 200, St.WalkSpeed, "", function(v) St.WalkSpeed = v end)
sec(scMisc, "HÀNH ĐỘNG")
actBtn(scMisc, "Reset nhân vật", function()
    local h = getHum()
    if h then h.Health = 0 end
end)
actBtn(scMisc, "Xoá sương mù", function()
    pcall(function()
        S.Light.FogEnd = 1e6
        S.Light.FogStart = 0
        local at = S.Light:FindFirstChildOfClass("Atmosphere")
        if at then at.Density = 0 at.Haze = 0 end
    end)
end, "primary")
sec(scMisc, "SERVER")
actBtn(scMisc, "Server Hop (ping thấp)", function() serverHopPing() end, "primary")
actBtn(scMisc, "Rejoin", function() pcall(function() S.TP:Teleport(game.PlaceId, LP) end) end)
slider(scMisc, "Ping tối đa khi hop", "Chỉ hop sang server có ping < ngưỡng.", 50, 500, St.HopPingMax, " ms", function(v) St.HopPingMax = v end)
sec(scMisc, "TIỆN ÍCH")
actBtn(scMisc, "Nhập tất cả code", function()
    local codes = {
        "Sub2CaptainMaui","kittgaming","Sub2Fer999","Enyu_is_Pro","Magicbus",
        "JCWK","Starcodeheo","Bluxxy","fudd10_v2","fudd10","Bignews",
        "THEGREATACE","Sub2NoobMaster123","Sub2UncleKizaru","Sub2Daigrock",
        "Axiore","TantaiGaming","StrawHatMaine",
    }
    for _, c in ipairs(codes) do Invoke("Redeem", c) task.wait(0.3) end
end, "primary")
actBtn(scMisc, "Lưu config", function() saveConfig() notify("Config", "Đã lưu", 3) end, "ok")
actBtn(scMisc, "Tải config", function() loadConfig() notify("Config", "Đã tải (giao diện cập nhật khi chạy lại script)", 4) end)

--------------------------------------------------------------------------------
-- FPS
--------------------------------------------------------------------------------
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
sec(scFPS, "KHÁC")
fS.li = toggle(scFPS, "Làm tối Lighting", "", false, function(v) FPS.lighting(v) end)
sec(scFPS, "HÀNH ĐỘNG")
actBtn(scFPS, "Bật tất cả", function() fpsMaster.set(true) end, "primary")
actBtn(scFPS, "Khôi phục mặc định", function()
    FPS.restore()
    for _, t in pairs(fS) do t.set(false) end
    fpsMaster.set(false)
end)

--------------------------------------------------------------------------------
-- ABOUT
--------------------------------------------------------------------------------
local function stopAll()
    for _, t in pairs(MT) do t.set(false) end
    St.AutoLevel, St.AutoRaid, St.AutoBoss = false, false, false
    St.AutoChest, St.AutoNearest, St.AutoSpecific = false, false, false
    St.Panic = true
    St.Attacking = false
    stopMoving()
    cleanBring()
    UI.upd()
end
local function unload()
    St.Destroyed = true
    St.Panic = true
    St.Attacking = false
    for _, c in ipairs(CONN) do pcall(function() c:Disconnect() end) end
    stopMoving()
    pcall(cleanBring)
    pcall(espClear)
    pcall(FPS.restore)
    pcall(function() sg:Destroy() end)
    pcall(function() MoveBlock:Destroy() end)
    pcall(function()
        for _, g in ipairs(GUI:GetChildren()) do if g.Name == "HL_Watermark" then g:Destroy() end end
    end)
end

sec(scAbout, "PHÍM TẮT")
local hkCard = glass(scAbout, { Size=UDim2.new(1,0,0,120), BackgroundColor3=T.bg2, BackgroundTransparency=0.15, BorderSizePixel=0 })
for i, c in ipairs({
    { k="RightShift", d="Panic stop" },
    { k="RightCtrl", d="Panic stop" },
    { k="Kéo header", d="Di chuyển cửa sổ" },
}) do
    mk("TextLabel", {
        Size=UDim2.new(0,110,0,20), Position=UDim2.new(0,16,0,14+(i-1)*28), BackgroundTransparency=1,
        Text=c.k, Font=F.mono, TextSize=12, TextColor3=T.bad, TextXAlignment=Enum.TextXAlignment.Left, Parent=hkCard,
    })
    mk("TextLabel", {
        Size=UDim2.new(1,-140,0,20), Position=UDim2.new(0,130,0,14+(i-1)*28), BackgroundTransparency=1,
        Text=c.d, Font=F.reg, TextSize=12, TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Left, Parent=hkCard,
    })
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
    if n == 0 then notify("Log boss", "Chưa có boss nào bị hạ.", 4) return end
    local lines = {}
    for _, e in ipairs(St.BossKillLog) do lines[#lines + 1] = e.at .. " · " .. e.name end
    print("[HOÀNG LÂM HUB] Log boss:\n" .. table.concat(lines, "\n"))
    local last = St.BossKillLog[n]
    notify("Log boss", n .. " boss · gần nhất: " .. last.name .. " (" .. last.at .. ")", 6)
end)
actBtn(scAbout, "Reset Quest Tracker", function() St.QuestLv = -1 St.QuestTry = 0 end)
actBtn(scAbout, "Dừng tất cả", stopAll, "danger")
actBtn(scAbout, "Gỡ script", unload, "danger")

--------------------------------------------------------------------------------
-- TAB SWITCH / STATE PAINT
--------------------------------------------------------------------------------
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
    task.wait(0.12)
    busyTab = false
end
for k, t in pairs(tabBtns) do t.btn.MouseButton1Click:Connect(function() setTab(k) end) end
task.spawn(setTab, "Home")

local MODE_COL = { AutoLevel=T.ok, AutoRaid=T.vio, AutoBoss=T.bad, AutoChest=T.warn, AutoNearest=T.hot, AutoSpecific=T.vio }
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
        if St.AutoRaid then pillText.Text = "RAID" modeTile.Text = "Raid" modeTile.TextColor3 = T.vio
        elseif St.AutoBoss then pillText.Text = "BOSS" modeTile.Text = "Boss" modeTile.TextColor3 = T.bad
        elseif St.AutoNearest then pillText.Text = "NEAR" modeTile.Text = "Near" modeTile.TextColor3 = T.hot
        elseif St.AutoSpecific then pillText.Text = "MOB" modeTile.Text = "Mob" modeTile.TextColor3 = T.vio
        elseif St.AutoChest then pillText.Text = "CHEST" modeTile.Text = "Chest" modeTile.TextColor3 = T.warn
        elseif St.AutoLevel then pillText.Text = "FARM" modeTile.Text = "Farm" modeTile.TextColor3 = T.hot end
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

-- PANIC
conn(S.UIS.InputBegan, function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightControl or i.KeyCode == Enum.KeyCode.RightShift then stopAll() end
end)

-- MIN / CLOSE
local minimized = false
local originalSize = UDim2.new(0, W, 0, H)
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tw(main, 0.32, { Size = minimized and UDim2.new(0, W, 0, 66) or originalSize })
    body.Visible = not minimized
    minBtn.Text = minimized and "+" or "—"
end)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false reopen.Visible = true end)
reopen.MouseButton1Click:Connect(function() reopen.Visible = false main.Visible = true end)

-- STATUS BAR realtime
task.spawn(function()
    while not St.Destroyed and sg.Parent do
        St.MyLevel = myLevel()
        lvlTile.Text = tostring(St.MyLevel)
        local s = St.Sub
        if #s > 16 then s = string.sub(s, 1, 14) .. ".." end
        statusTile.Text = s
        task.wait(0.35)
    end
end)

-- HIỆN MAIN
main.Size = UDim2.new(0, W, 0, 0)
main.BackgroundTransparency = 1
task.wait(0.1)
tw(main, 0.55, { Size = originalSize, BackgroundTransparency = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- WATERMARK
local wm = mk("ScreenGui", {
    Name="HL_Watermark", ResetOnSpawn=false, IgnoreGuiInset=true,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=999, Parent=GUI,
})
local wf = mk("Frame", {
    Size=UDim2.new(0,230,0,22), Position=UDim2.new(1,-238,0,8),
    BackgroundColor3=Color3.fromRGB(10,12,20), BackgroundTransparency=0.35, BorderSizePixel=0, Parent=wm,
})
corner(wf, 6); stroke(wf, T.acc, 1, 0.4)
mk("TextLabel", {
    Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,5,0,0), BackgroundTransparency=1,
    Text=AUTHOR.brand.." · Zalo "..AUTHOR.zalo, Font=F.bold, TextSize=10, TextColor3=T.hot, Parent=wf,
})
pcall(function() sg:SetAttribute("Author", AUTHOR.name) end)
pcall(function() sg:SetAttribute("Zalo", AUTHOR.zalo) end)
end -- UI

--====================================================================================
-- PLAYER MODS
--====================================================================================
conn(S.Run.Stepped, function()
    if St.Destroyed then return end
    if St.NoClip then
        local c = LP.Character
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
            end
        end
    end
    if St.LockSpeed then
        local h = getHum()
        if h then
            h.WalkSpeed = math.max(16, tonumber(St.WalkSpeed) or 50)
            h.UseJumpPower = true
            h.JumpPower = 90
        end
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
        if not St.Fly then
            if flyBV then flyOff() end
            return
        end
        local r = getRoot() if not r then return end
        if not flyBV or flyBV.Parent ~= r then
            flyOff()
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            flyBV.Velocity = Vector3.new(0, 0, 0)
            flyBV.P = 1e4
            flyBV.Parent = r
            flyBG = Instance.new("BodyGyro")
            flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            flyBG.P = 9e4
            flyBG.Parent = r
            return
        end
        local cam = S.WS.CurrentCamera
        local h = getHum()
        local md = h and h.MoveDirection or Vector3.new(0, 0, 0)
        local dir = Vector3.new(0, 0, 0)
        if md.Magnitude > 0 then
            local lv = cam.CFrame:VectorToObjectSpace(md)
            dir = cam.CFrame.LookVector * -lv.Z + cam.CFrame.RightVector * lv.X
        end
        if S.UIS:IsKeyDown(Enum.KeyCode.Space) or (h and h.Jump) then dir = dir + Vector3.new(0, 1, 0) end
        if S.UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
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

-- watermark guard
task.spawn(function()
    while not St.Destroyed do
        task.wait(3)
        local h = GUI:FindFirstChild("HL_Hub")
        if h then
            if h:GetAttribute("Author") ~= AUTHOR.name then pcall(function() h:SetAttribute("Author", AUTHOR.name) end) end
            if h:GetAttribute("Zalo") ~= AUTHOR.zalo then pcall(function() h:SetAttribute("Zalo", AUTHOR.zalo) end) end
        end
    end
end)

pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="HL DEBUG",Text="3/4 UI + Player mods OK",Duration=5}) end)
--====================================================================================
-- BOOT
--====================================================================================
notify(AUTHOR.brand .. " " .. AUTHOR.version, "Đã load · Made by " .. AUTHOR.name .. " · Zalo " .. AUTHOR.zalo, 8)
print("══════════════════════════════════════════════════════════")
print("  " .. AUTHOR.brand .. " " .. AUTHOR.version .. " — READY")
print("  MADE BY " .. AUTHOR.name:upper() .. " · ZALO " .. AUTHOR.zalo)
print("  © 2026 " .. AUTHOR.name .. ". Nghiêm cấm bán lại / đổi tên tác giả.")
print("  Key server: " .. SERVER_URL)
print("  Sea: " .. tostring(SEA or "?"))
print("  CommF_: " .. tostring(R.CommF ~= nil))
print("══════════════════════════════════════════════════════════")

end, function(e) return debug.traceback(tostring(e), 2) end)
if not __ok then
    warn("[HL ERROR] " .. tostring(__err))
    pcall(function() setclipboard(tostring(__err)) end)
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="HL LOI (da copy)",Text=tostring(__err):sub(1,200),Duration=20}) end)
else
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="HL DEBUG",Text="4/4 Boot xong",Duration=5}) end)
end
