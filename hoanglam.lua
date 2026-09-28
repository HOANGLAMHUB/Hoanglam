--[[====================================================================================
  HOÀNG LÂM HUB v7.0 — FULL BUILD (KEY SYSTEM + MAIN HUB)
  MADE BY HOÀNG LÂM · ZALO 0363194767
  © 2026 Hoàng Lâm. Nghiêm cấm bán lại / đổi tên tác giả.
  Key server: https://keyserver-hchy.onrender.com
====================================================================================]]

if not game:IsLoaded() then game.Loaded:Wait() end
if not getgenv then getgenv = getfenv end

local AUTHOR = {
    name    = "Hoàng Lâm",
    zalo    = "0363194767",
    version = "v7.0",
    brand   = "HOÀNG LÂM HUB",
}
local SERVER_URL = "https://keyserver-hchy.onrender.com"
local KEY_FILE   = "HL_key.txt"

--====================================================================================
-- PHẦN 1 · KEY SYSTEM
--====================================================================================
do
    local Http = game:GetService("HttpService")
    local LP   = game:GetService("Players").LocalPlayer
    local SG   = game:GetService("StarterGui")
    local GUI0 = (gethui and gethui()) or game:GetService("CoreGui")

    local function notify(t, x, d)
        pcall(function()
            SG:SetCore("SendNotification", { Title = t, Text = x, Duration = d or 5 })
        end)
    end
    local function enc(s)
        return (tostring(s):gsub("([^%w%-_%.~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end))
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
    local function hwid()
        local ok, r = pcall(function() if gethwid then return gethwid() end end)
        if ok and r then
            if type(r) == "table" then r = r[1] or r[2] or "" end
            r = tostring(r):gsub("%s+", "")
            if #r >= 3 then return r end
        end
        return "UID_" .. tostring(LP and LP.UserId or 0)
    end
    local HWID = hwid()
    local function api(path)
        local body = httpGet(SERVER_URL .. path)
        if not body then return nil, "Không kết nối được server key (chờ 30-60s nếu Render vừa sleep)." end
        local ok, d = pcall(function() return Http:JSONDecode(body) end)
        if not ok or type(d) ~= "table" then return nil, "Server key trả về sai định dạng." end
        return d
    end
    local REASON = {
        expired    = "Key đã hết hạn 48h. Bấm GET KEY.",
        wrong_hwid = "Key thuộc máy khác.",
        not_found  = "Key không đúng. Kiểm tra lại.",
        missing    = "Thiếu key.",
    }
    local function verify(key)
        key = tostring(key or ""):gsub("%s+", ""):upper()
        if key == "" then return false, "Chưa nhập key." end
        local d, err = api("/api/verify?key=" .. enc(key) .. "&hwid=" .. enc(HWID))
        if not d then return false, err end
        if d.status == "success" and d.valid == true then return true, tonumber(d.expiresAt) end
        return false, REASON[d.reason] or "Key không hợp lệ."
    end
    local function saveK(k)
        pcall(function() if writefile then writefile(KEY_FILE, tostring(k):gsub("%s+", "")) end end)
    end
    local function clearK()
        pcall(function()
            if delfile and isfile and isfile(KEY_FILE) then delfile(KEY_FILE) end
        end)
    end

    local PASSED = false
    do
        local s
        pcall(function()
            if isfile and isfile(KEY_FILE) and readfile then
                s = tostring(readfile(KEY_FILE) or ""):gsub("%s+", "")
            end
        end)
        if s and s ~= "" then
            if verify(s) then
                PASSED = true
                notify(AUTHOR.brand, "Key còn hạn — đăng nhập tự động ✔")
            else
                clearK()
            end
        end
    end

    if not PASSED then
        pcall(function()
            local o = GUI0:FindFirstChild("HL_KeyUI")
            if o then o:Destroy() end
        end)
        local T = {
            bg0 = Color3.fromRGB(6, 8, 14), bg1 = Color3.fromRGB(12, 15, 24),
            bg2 = Color3.fromRGB(18, 22, 34), bg3 = Color3.fromRGB(26, 32, 48),
            txt = Color3.fromRGB(240, 244, 255), dim = Color3.fromRGB(150, 160, 185),
            fnt = Color3.fromRGB(78, 88, 112), acc = Color3.fromRGB(255, 200, 90),
            hot = Color3.fromRGB(255, 230, 160), vio = Color3.fromRGB(200, 150, 255),
            ok  = Color3.fromRGB(72, 235, 168), bad = Color3.fromRGB(255, 100, 115),
        }
        local F = {
            black = Enum.Font.GothamBlack, bold = Enum.Font.GothamBold,
            reg = Enum.Font.Gotham, mono = Enum.Font.Code,
        }
        local function mk(c, p)
            local o = Instance.new(c)
            for k, v in pairs(p) do
                if k ~= "Parent" then pcall(function() o[k] = v end) end
            end
            o.Parent = p.Parent
            return o
        end
        local function corner(o, r)
            mk("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = o })
        end
        local function stroke(o, c, t, tr)
            mk("UIStroke", {
                Color = c or T.acc, Thickness = t or 1, Transparency = tr or 0.4,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = o,
            })
        end

        local sg = mk("ScreenGui", {
            Name = "HL_KeyUI", ResetOnSpawn = false, IgnoreGuiInset = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = GUI0,
        })
        local W, H = 400, 540
        local main = mk("Frame", {
            Size = UDim2.new(0, W, 0, H), Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
            BackgroundColor3 = T.bg0, BorderSizePixel = 0,
            Active = true, Draggable = true, Parent = sg,
        })
        corner(main, 18); stroke(main, T.acc, 1.2, 0.5)

        local gtop = mk("Frame", {
            Size = UDim2.new(1, -36, 0, 2), Position = UDim2.new(0, 18, 0, 0),
            BackgroundColor3 = T.acc, BorderSizePixel = 0, Parent = main,
        })
        mk("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, T.bg0),
                ColorSequenceKeypoint.new(0.3, T.acc),
                ColorSequenceKeypoint.new(0.7, T.vio),
                ColorSequenceKeypoint.new(1, T.bg0),
            }), Parent = gtop,
        })

        local logo = mk("Frame", {
            Size = UDim2.new(0, 58, 0, 58), Position = UDim2.new(0, 28, 0, 26),
            BackgroundColor3 = T.bg3, BorderSizePixel = 0, Parent = main,
        })
        corner(logo, 999); stroke(logo, T.acc, 1.5, 0.3)
        mk("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "HL",
            Font = F.black, TextSize = 24, TextColor3 = T.hot, Parent = logo,
        })

        mk("TextLabel", {
            Size = UDim2.new(0, 280, 0, 26), Position = UDim2.new(0, 100, 0, 30),
            BackgroundTransparency = 1, Text = AUTHOR.brand .. " " .. AUTHOR.version,
            Font = F.black, TextSize = 20, TextColor3 = T.txt,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = main,
        })
        mk("TextLabel", {
            Size = UDim2.new(0, 280, 0, 16), Position = UDim2.new(0, 100, 0, 58),
            BackgroundTransparency = 1,
            Text = "MADE BY " .. AUTHOR.name:upper() .. " · ZALO " .. AUTHOR.zalo,
            Font = F.reg, TextSize = 10, TextColor3 = T.fnt,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = main,
        })

        local status = mk("TextLabel", {
            Size = UDim2.new(1, -56, 0, 44), Position = UDim2.new(0, 28, 0, 100),
            BackgroundTransparency = 1, Text = "Dán key để sử dụng script.",
            Font = F.reg, TextSize = 12, TextColor3 = T.dim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true, Parent = main,
        })
        local function setStat(s, c) status.Text = s status.TextColor3 = c or T.dim end

        mk("TextLabel", {
            Size = UDim2.new(1, -56, 0, 14), Position = UDim2.new(0, 28, 0, 148),
            BackgroundTransparency = 1, Text = "YOUR KEY",
            Font = F.bold, TextSize = 10, TextColor3 = T.fnt,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = main,
        })

        local keyBox = mk("TextBox", {
            Size = UDim2.new(1, -56, 0, 46), Position = UDim2.new(0, 28, 0, 166),
            BackgroundColor3 = T.bg2, BorderSizePixel = 0,
            PlaceholderText = "HL-XXXX-XXXX-XXXX", PlaceholderColor3 = T.fnt,
            Text = "", Font = F.mono, TextSize = 14, TextColor3 = T.hot,
            ClearTextOnFocus = false, Parent = main,
        })
        corner(keyBox, 10); stroke(keyBox, T.acc, 1, 0.6)

        local function button(txt, y, bg, fg)
            local b = mk("TextButton", {
                Size = UDim2.new(1, -56, 0, 46), Position = UDim2.new(0, 28, 0, y),
                BackgroundColor3 = bg, BorderSizePixel = 0, Text = txt,
                Font = F.black, TextSize = 14, TextColor3 = fg or Color3.new(1, 1, 1),
                AutoButtonColor = true, Parent = main,
            })
            corner(b, 11)
            return b
        end
        local verifyBtn = button("✔  VERIFY KEY", 226, Color3.fromRGB(30, 120, 88))
        mk("TextLabel", {
            Size = UDim2.new(1, -56, 0, 16), Position = UDim2.new(0, 28, 0, 284),
            BackgroundTransparency = 1, Text = "— CHƯA CÓ KEY? —",
            Font = F.bold, TextSize = 10, TextColor3 = T.fnt, Parent = main,
        })
        local getBtn = button("📋  GET KEY (COPY LINK)", 306, Color3.fromRGB(40, 92, 148))
        local buyBtn = button("💰  MUA KEY NGAY (ZALO)", 356, Color3.fromRGB(150, 100, 30))

        local linkBox = mk("TextBox", {
            Size = UDim2.new(1, -56, 0, 60), Position = UDim2.new(0, 28, 0, 412),
            BackgroundColor3 = T.bg1, BorderSizePixel = 0,
            Text = "Link vượt sẽ hiện ở đây.",
            Font = F.mono, TextSize = 11, TextColor3 = T.dim,
            TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            ClearTextOnFocus = false, TextEditable = true, Parent = main,
        })
        corner(linkBox, 10)
        mk("UIPadding", {
            PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 8),
            Parent = linkBox,
        })
        mk("TextLabel", {
            Size = UDim2.new(1, -56, 0, 40), Position = UDim2.new(0, 28, 0, 480),
            BackgroundTransparency = 1,
            Text = "© 2026 " .. AUTHOR.name .. " · Zalo " .. AUTHOR.zalo .. " · Nghiêm cấm sao chép.",
            Font = F.reg, TextSize = 10, TextColor3 = T.fnt,
            TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = main,
        })

        getBtn.MouseButton1Click:Connect(function()
            setStat("Đang tạo link...", T.dim)
            local d, err = api("/api/getlink?hwid=" .. enc(HWID))
            if not d then setStat("✘ " .. err, T.bad) return end
            if d.status == "success" and d.link then
                linkBox.Text = d.link
                pcall(function() if setclipboard then setclipboard(d.link) end end)
                setStat("✔ Đã COPY link — mở trình duyệt vượt link.", T.ok)
            else
                setStat("✘ " .. tostring(d.message or "Lỗi tạo link."), T.bad)
            end
        end)

        buyBtn.MouseButton1Click:Connect(function()
            setStat("Liên hệ Zalo " .. AUTHOR.zalo .. " để mua key.", T.hot)
            pcall(function() if setclipboard then setclipboard(AUTHOR.zalo) end end)
            notify(AUTHOR.brand, "Đã copy Zalo " .. AUTHOR.zalo .. " — liên hệ mua key.")
        end)

        verifyBtn.MouseButton1Click:Connect(function()
            setStat("Đang kiểm tra...", T.dim)
            local ok, info = verify(keyBox.Text)
            if ok then
                saveK(keyBox.Text)
                local left = ""
                if type(info) == "number" then
                    local h = math.max(0, math.floor((info/1000 - os.time())/3600))
                    left = " (còn ~" .. h .. "h)"
                end
                setStat("✔ Key hợp lệ" .. left .. "!", T.ok)
                notify(AUTHOR.brand, "Key hợp lệ ✔")
                task.wait(0.7)
                sg:Destroy()
                PASSED = true
            else
                setStat("✘ " .. tostring(info), T.bad)
            end
        end)

        while not PASSED do task.wait(0.15) end
    end
end

--====================================================================================
-- PHẦN 2 · MAIN HUB
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
    VIM     = game:GetService("VirtualInputManager"),
    SG      = game:GetService("StarterGui"),
}
local LP     = S.Players.LocalPlayer
local Cam    = S.WS.CurrentCamera
local GUI    = (gethui and gethui()) or game:GetService("CoreGui")
local MOBILE = S.UIS.TouchEnabled and not S.UIS.MouseEnabled

if not firetouchinterest then firetouchinterest = function() end end
if not fireclickdetector then fireclickdetector = function() end end
if not fireproximityprompt then fireproximityprompt = function() end end

pcall(function()
    for _, g in ipairs(GUI:GetChildren()) do
        if g.Name == "HL_Hub" or g.Name == "HL_Watermark" or g.Name == "BF_SikeHubV4"
            or g.Name == "HL_Admin" then
            g:Destroy()
        end
    end
end)

local function safe(fn, ...) local ok, r = pcall(fn, ...) if ok then return r end end
local UNPACK = table.unpack or unpack

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
local function FireRaid(...)
    local a = { ... }
    if R.Raids then pcall(function() R.Raids:FireServer(UNPACK(a)) end) end
    if R.Btn   then pcall(function() R.Btn:FireServer(UNPACK(a)) end) end
    if R.CommF then
        pcall(function() R.CommF:InvokeServer("Raid", UNPACK(a)) end)
        pcall(function() R.CommF:InvokeServer("StartRaid", UNPACK(a)) end)
    end
end

local function getRoot()
    local c = LP.Character
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
end
local function getHum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function myLevel()
    local d = LP:FindFirstChild("Data")
    if d and d:FindFirstChild("Level") then return tonumber(d.Level.Value) or 1 end
    local ls = LP:FindFirstChild("leaderstats")
    if ls and ls:FindFirstChild("Level") then return tonumber(ls.Level.Value) or 1 end
    return 1
end
local function dist(a, b) return (a - b).Magnitude end

local function placeSea()
    local id = game.PlaceId
    if id == 2753915549 or id == 9792993051        then return 1 end
    if id == 4442272183 or id == 79091703265657     then return 2 end
    if id == 7449423635 or id == 100117331123089    then return 3 end
end
local SEA = placeSea()

-- MoveBlock
local MoveBlock = Instance.new("Part")
MoveBlock.Name = "HL_MoveBlock"
MoveBlock.Size = Vector3.new(1, 1, 1)
MoveBlock.Anchored = true
MoveBlock.CanCollide = false
MoveBlock.CanTouch = false
MoveBlock.Transparency = 1
MoveBlock.Parent = S.WS

local ShouldTween, TweenInst = false, nil
local currentSpeed = 170

local function unclip(on)
    local c = LP.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = not on end
    end
end
local function stopMoving()
    ShouldTween = false
    if TweenInst then pcall(function() TweenInst:Cancel() end) TweenInst = nil end
    unclip(false)
end
S.Run.Heartbeat:Connect(function()
    if not ShouldTween then return end
    local hrp = getRoot()
    if not hrp then return end
    if dist(hrp.Position, MoveBlock.Position) <= 250 then hrp.CFrame = MoveBlock.CFrame
    else MoveBlock.CFrame = hrp.CFrame end
    unclip(true)
end)
local function moveTo(cf, sp)
    local hrp = getRoot()
    if not hrp then return end
    cf = typeof(cf) == "CFrame" and cf or CFrame.new(cf)
    local d = dist(hrp.Position, cf.Position)
    if d <= 5 then hrp.CFrame = cf MoveBlock.CFrame = cf return end
    if TweenInst then pcall(function() TweenInst:Cancel() end) end
    ShouldTween = true
    TweenInst = S.Tween:Create(MoveBlock, TweenInfo.new(d / (sp or currentSpeed), Enum.EasingStyle.Linear), { CFrame = cf })
    TweenInst:Play()
end
local function teleportTo(cf)
    local hrp = getRoot()
    if not hrp then return end
    cf = typeof(cf) == "CFrame" and cf or CFrame.new(cf)
    if TweenInst then pcall(function() TweenInst:Cancel() end) end
    ShouldTween = false
    MoveBlock.CFrame = cf
    hrp.CFrame = cf
end

--====================================================================================
-- DATA
--====================================================================================
local D = {}
D.CHEAP = {
    "Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Chop-Chop", "Spring-Spring",
    "Bomb-Bomb", "Smoke-Smoke", "Spike-Spike", "Flame-Flame", "Ice-Ice",
    "Sand-Sand", "Dark-Dark", "Diamond-Diamond", "Light-Light", "Rubber-Rubber",
    "Ghost-Ghost", "Revive-Revive", "Magma-Magma",
}
D.BOSSES = {
    [1] = { "The Gorilla King", "Bobby", "Yeti", "Mob Leader", "Vice Admiral", "Saber Expert" },
    [2] = { "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper",
            "Thunder God", "Cyborg", "Ice Admiral", "Ghost Captain", "Don Swan", "Smoke Admiral",
            "Cursed Captain", "Darkbeard", "Order", "Diamond", "Jeremy", "Fajita",
            "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Longma", "Hydra Leader", "Trial of God" },
    [3] = { "Stone", "Hydra Leader", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate",
            "Longma", "Trial of God", "Cake Queen", "Cursed Captain", "Soul Reaper",
            "Dough King", "Rip_indra", "Ope", "Cursed Skeleton" },
}
D.MOBS = {
    [1] = { "Bandit","Monkey","Gorilla","Pirate","Brute","Desert Bandit","Desert Officer",
            "Snow Bandit","Snowman","Chief Petty Officer","Sky Bandit","Dark Master","Prisoner",
            "Dangerous Prisoner","Toga Warrior","Gladiator","Military Soldier","Military Spy",
            "Fishman Warrior","Fishman Commando","God's Guard","Shanda","Royal Squad",
            "Royal Soldier","Galley Pirate","Galley Captain" },
    [2] = { "Raider","Mercenary","Swan Pirate","Factory Staff","Marine Lieutenant",
            "Marine Captain","Zombie","Vampire","Snow Trooper","Winter Warrior","Lab Subordinate",
            "Horned Warrior","Magma Ninja","Lava Pirate","Ship Deckhand","Ship Engineer",
            "Ship Steward","Ship Officer","Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter" },
    [3] = { "Pirate Millionaire","Pistol Billionaire","Dragon Crew Warrior","Dragon Crew Archer",
            "Hydra Enforcer","Venomous Assailant","Marine Commodore","Marine Rear Admiral",
            "Fishman Raider","Fishman Captain","Forest Pirate","Jungle Pirate","Musketeer Pirate",
            "Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy","Peanut Scout",
            "Peanut President","Ice Cream Chef","Ice Cream Commander","Cookie Crafter","Cake Guard",
            "Baking Staff","Head Baker","Cocoa Warrior","Chocolate Bar Battler","Sweet Thief",
            "Candy Rebel","Candy Pirate","Snow Demon","Isle Outlaw","Island Boy","Isle Champion",
            "Skull Slayer","Reef Bandit","Coral Pirate","Sea Chanter","Ocean Prophet",
            "High Disciple","Grand Devotee" },
}
D.MOB_DISPLAY = { ["God's Guard"] = "Sky Guards" }
local function dn(n) return D.MOB_DISPLAY[n] or n end

D.FRUITS = {
    { name="Rocket-Rocket", rarity=0, price=5000 },
    { name="Spin-Spin", rarity=0, price=7500 },
    { name="Blade-Blade", rarity=0, price=30000 },
    { name="Spring-Spring", rarity=0, price=60000 },
    { name="Bomb-Bomb", rarity=0, price=80000 },
    { name="Smoke-Smoke", rarity=0, price=100000 },
    { name="Spike-Spike", rarity=0, price=180000 },
    { name="Flame-Flame", rarity=1, price=250000 },
    { name="Ice-Ice", rarity=1, price=350000 },
    { name="Sand-Sand", rarity=1, price=420000 },
    { name="Dark-Dark", rarity=1, price=500000 },
    { name="Eagle-Eagle", rarity=1, price=550000 },
    { name="Diamond-Diamond", rarity=1, price=600000 },
    { name="Falcon-Falcon", rarity=1, price=650000 },
    { name="Light-Light", rarity=2, price=650000 },
    { name="Rubber-Rubber", rarity=2, price=750000 },
    { name="Ghost-Ghost", rarity=2, price=940000 },
    { name="Magma-Magma", rarity=2, price=960000 },
    { name="Door-Door", rarity=2, price=950000 },
    { name="Chop-Chop", rarity=2, price=1000000 },
    { name="Quake-Quake", rarity=3, price=1000000 },
    { name="Buddha-Buddha", rarity=3, price=1200000 },
    { name="Love-Love", rarity=3, price=1300000 },
    { name="Creation-Creation", rarity=3, price=1400000 },
    { name="Spider-Spider", rarity=3, price=1500000 },
    { name="Sound-Sound", rarity=3, price=1700000 },
    { name="Phoenix-Phoenix", rarity=3, price=1800000 },
    { name="Portal-Portal", rarity=3, price=1900000 },
    { name="Rumble-Rumble", rarity=3, price=2100000 },
    { name="Pain-Pain", rarity=3, price=2300000 },
    { name="Blizzard-Blizzard", rarity=3, price=2400000 },
    { name="Gravity-Gravity", rarity=4, price=2500000 },
    { name="Mammoth-Mammoth", rarity=4, price=2700000 },
    { name="T-Rex-T-Rex", rarity=4, price=2700000 },
    { name="Dough-Dough", rarity=4, price=2800000 },
    { name="Shadow-Shadow", rarity=4, price=2900000 },
    { name="Venom-Venom", rarity=4, price=3000000 },
    { name="Gas-Gas", rarity=4, price=3200000 },
    { name="Spirit-Spirit", rarity=4, price=3400000 },
    { name="Control-Control", rarity=4, price=9000000 },
    { name="Yeti-Yeti", rarity=4, price=5000000 },
    { name="Leopard-Leopard", rarity=4, price=5000000 },
    { name="Kitsune-Kitsune", rarity=4, price=8000000 },
    { name="Dragon-Dragon", rarity=4, price=15000000 },
    { name="Dragon-West", rarity=4, price=15000000 },
    { name="Dragon-East", rarity=4, price=15000000 },
}
D.FRUIT_BY_KEY = {}
for _, f in ipairs(D.FRUITS) do
    local k = f.name:match("^([^%-]+)") or f.name
    D.FRUIT_BY_KEY[k] = f
    D.FRUIT_BY_KEY[f.name] = f
end
local function fruitRarity(name)
    if not name then return 0 end
    local e = D.FRUIT_BY_KEY[name]
    if e then return e.rarity end
    local s = tostring(name):match("^([^%-]+)")
    if s and D.FRUIT_BY_KEY[s] then return D.FRUIT_BY_KEY[s].rarity end
    return 0
end
local function fruitPrice(name)
    if not name then return 0 end
    local e = D.FRUIT_BY_KEY[name]
    if e then return e.price end
    local s = tostring(name):match("^([^%-]+)")
    if s and D.FRUIT_BY_KEY[s] then return D.FRUIT_BY_KEY[s].price end
    return 0
end

-- STATE
local St = {
    AutoLevel=false, AutoRaid=false, AutoBoss=false, AutoChest=false,
    AutoNearest=false, AutoSpecific=false,
    AutoQuest=true, AutoHaki=true, BringMobs=true, BringRange=250,
    AutoEquip=true, EquipType="Melee", AttackRange=70, Hover=18,
    Speed=170, AtkDelay=0.03, AtkBurst=1,
    AutoBuyChip=false, AutoClearRaid=false, RaidChip="Flame",
    NoClip=false, InfJump=false, Fly=false, FlySpeed=120, LockSpeed=false,
    SafeMode=false, SafeHP=30,
    FruitSniper=false, FruitMinRarity=2, FruitBring=false, FruitNotify=false,
    AutoStoreFruit=false, StoreMinRarity=2, LastStoreFruit=0,
    LastFruitScan=0, FruitCache={}, NotifiedFruits={},
    LastFruit=0, LastChest=0, LastDrop=0,
    Sub="Idle", MyLevel=1, QuestLv=-1, Kills=0, Tracked={}, BringLast=0,
    LastChipBuy=0, LastSummonTry=0, RaidAttempts=0,
    Panic=false, Running=false, LastEquipped=nil,
    Orig={}, Destroyed=false,
}
local function anyMode()
    return St.AutoLevel or St.AutoRaid or St.AutoBoss or St.AutoChest
        or St.AutoNearest or St.AutoSpecific
end

local GUI_State = { SelectedBoss = "The Gorilla King", SelectedMob = "Bandit" }
local runChestFarm, tickFruit

-- WEAPON
local SW, ML, GN = {}, {}, {}
for _, n in ipairs({
    "cutlass","katana","iron mace","dual katana","triple katana","dark blade","yoru","wando",
    "shisui","saddi","koko","tushita","bisento","pole","trident","true triple katana",
    "cursed dual katana","dark dagger","buddy sword","dragon heart","canvander","rengoku",
    "spikey trident","midnight blade","hallow scythe","yama","fox lamp","longsword",
    "gravity cane","ice sword","flame sword","sand sword","pipe","soul cane","shark saw",
}) do SW[n] = true end
for _, n in ipairs({
    "combat","black leg","electro","fishman karate","dragon talon","superhuman",
    "death step","sharkman karate","electric claw","godhuman","sanguine art",
}) do ML[n] = true end
for _, n in ipairs({
    "flintlock","musket","slingshot","dual flintlock","refined slingshot","bizarre rifle",
    "kabucha","acidum rifle","serpent bow","soul guitar",
}) do GN[n] = true end
local function classify(t)
    if not t or not t:IsA("Tool") then return nil end
    local n = t.Name:lower()
    if GN[n] then return "Gun" end
    if SW[n] then return "Sword" end
    if ML[n] then return "Melee" end
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
    local c, bp = LP.Character, LP:FindFirstChild("Backpack")
    if not c or not bp then return end
    local want
    for _, t in ipairs(bp:GetChildren()) do
        if t:IsA("Tool") and classify(t) == St.EquipType then want = t break end
    end
    if not want then
        for _, t in ipairs(c:GetChildren()) do
            if t:IsA("Tool") and classify(t) == St.EquipType then return end
        end
        return
    end
    if St.LastEquipped == want then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h:EquipTool(want) end) St.LastEquipped = want end
end

-- FPS BOOST
local FPS = {}
do
    local function sp(i, p)
        St.Orig[i] = St.Orig[i] or {}
        if St.Orig[i][p] == nil then pcall(function() St.Orig[i][p] = i[p] end) end
    end
    local function rp(i, p)
        if St.Orig[i] and St.Orig[i][p] ~= nil then pcall(function() i[p] = St.Orig[i][p] end) end
    end
    FPS.shadows = function(on)
        if on then sp(S.Light, "GlobalShadows") pcall(function() S.Light.GlobalShadows = false end)
        else rp(S.Light, "GlobalShadows") end
    end
    FPS.postfx = function(on)
        for _, fx in ipairs(S.Light:GetChildren()) do
            if fx:IsA("BloomEffect") or fx:IsA("BlurEffect") or fx:IsA("DepthOfFieldEffect")
                or fx:IsA("SunRaysEffect") or fx:IsA("ColorCorrectionEffect") then
                if on then sp(fx, "Enabled") pcall(function() fx.Enabled = false end)
                else rp(fx, "Enabled") end
            end
        end
    end
    FPS.atmosphere = function(on)
        if on then
            sp(S.Light, "FogEnd"); sp(S.Light, "FogStart")
            pcall(function() S.Light.FogEnd = 0 S.Light.FogStart = 0 end)
            for _, at in ipairs(S.Light:GetChildren()) do
                if at:IsA("Atmosphere") then
                    sp(at, "Density"); sp(at, "Haze")
                    pcall(function() at.Density = 0 at.Haze = 0 end)
                end
            end
        else
            rp(S.Light, "FogEnd"); rp(S.Light, "FogStart")
            for _, at in ipairs(S.Light:GetChildren()) do
                if at:IsA("Atmosphere") then rp(at, "Density"); rp(at, "Haze") end
            end
        end
    end
    FPS.terrain = function(on)
        local t = S.WS:FindFirstChildOfClass("Terrain")
        if not t then return end
        if on then
            sp(t, "WaterWaveSize"); sp(t, "WaterReflectance"); sp(t, "WaterTransparency")
            pcall(function() t.WaterWaveSize = 0 t.WaterReflectance = 0 t.WaterTransparency = 1 end)
        else
            rp(t, "WaterWaveSize"); rp(t, "WaterReflectance"); rp(t, "WaterTransparency")
        end
    end
    FPS.particles = function(on)
        if on then
            for _, d in ipairs(S.WS:GetDescendants()) do
                if d:IsA("ParticleEmitter") or d:IsA("Fire") or d:IsA("Smoke") or d:IsA("Sparkles") then
                    if d.Enabled then sp(d, "Enabled") pcall(function() d.Enabled = false end) end
                end
            end
        else
            for i in pairs(St.Orig) do
                if i:IsA("ParticleEmitter") or i:IsA("Fire") or i:IsA("Smoke") or i:IsA("Sparkles") then
                    rp(i, "Enabled")
                end
            end
        end
    end
    FPS.decals = function(on)
        if on then
            for _, d in ipairs(S.WS:GetDescendants()) do
                if d:IsA("Decal") or d:IsA("Texture") then
                    if d.Transparency < 1 then sp(d, "Transparency") pcall(function() d.Transparency = 1 end) end
                end
            end
        else
            for i in pairs(St.Orig) do
                if i:IsA("Decal") or i:IsA("Texture") then rp(i, "Transparency") end
            end
        end
    end
    FPS.beams = function(on)
        if on then
            for _, d in ipairs(S.WS:GetDescendants()) do
                if d:IsA("Beam") or d:IsA("Trail") or d:IsA("SelectionBox") then
                    if d.Enabled then sp(d, "Enabled") pcall(function() d.Enabled = false end) end
                end
            end
        else
            for i in pairs(St.Orig) do
                if i:IsA("Beam") or i:IsA("Trail") or i:IsA("SelectionBox") then rp(i, "Enabled") end
            end
        end
    end
    FPS.access = function(on)
        if on then
            for _, p in ipairs(S.Players:GetPlayers()) do
                local c = p.Character
                if c then
                    for _, d in ipairs(c:GetDescendants()) do
                        if d:IsA("Accessory") or d:IsA("Hat") then
                            sp(d, "Transparency")
                            pcall(function() d.Transparency = 1 end)
                        end
                    end
                end
            end
        else
            for i in pairs(St.Orig) do
                if i:IsA("Accessory") or i:IsA("Hat") then rp(i, "Transparency") end
            end
        end
    end
    FPS.damage = function(on)
        local pg = LP:FindFirstChild("PlayerGui")
        if not pg then return end
        for _, g in ipairs(pg:GetChildren()) do
            if g:IsA("ScreenGui") and (g.Name:lower():find("damage") or g.Name:lower():find("number")) then
                if on then sp(g, "Enabled") pcall(function() g.Enabled = false end)
                else rp(g, "Enabled") end
            end
        end
    end
    FPS.lighting = function(on)
        if on then
            sp(S.Light, "Brightness"); sp(S.Light, "ClockTime")
            sp(S.Light, "OutdoorAmbient"); sp(S.Light, "Ambient")
            pcall(function()
                S.Light.Brightness = 0.5
                S.Light.ClockTime = 0
                S.Light.OutdoorAmbient = Color3.new(0, 0, 0)
                S.Light.Ambient = Color3.new(0, 0, 0)
            end)
        else
            rp(S.Light, "Brightness"); rp(S.Light, "ClockTime")
            rp(S.Light, "OutdoorAmbient"); rp(S.Light, "Ambient")
        end
    end
    FPS.restore = function()
        FPS.shadows(false); FPS.postfx(false); FPS.atmosphere(false); FPS.terrain(false)
        FPS.particles(false); FPS.decals(false); FPS.beams(false); FPS.access(false)
        FPS.damage(false); FPS.lighting(false)
        St.Orig = {}
    end
end

-- COMBAT
local function doAttack()
    if not R.Attack or not R.Hit then return end
    local hrp = getRoot() if not hrp then return end
    local folder = S.WS:FindFirstChild("Enemies") if not folder then return end
    local range = St.AttackRange + (MOBILE and 15 or 0)
    local hits = {}
    for _, e in ipairs(folder:GetChildren()) do
        local h = e:FindFirstChildOfClass("Humanoid")
        local mrp = e:FindFirstChild("HumanoidRootPart")
        local head = e:FindFirstChild("Head")
        if h and mrp and h.Health > 0 then
            local d1 = dist(mrp.Position, hrp.Position)
            local d2 = head and dist(head.Position, hrp.Position) or math.huge
            if d1 <= range or d2 <= range then hits[#hits + 1] = e end
        end
    end
    if #hits == 0 then return end
    local args = { [1] = nil, [2] = {}, [4] = "078da5141" }
    for _, mob in ipairs(hits) do
        local head = mob:FindFirstChild("Head")
        local mrp = mob:FindFirstChild("HumanoidRootPart")
        if head and not args[1] then args[1] = head end
        if mrp then
            table.insert(args[2], { [1] = mob, [2] = mrp })
            table.insert(args[2], mob)
        end
    end
    pcall(function() R.Attack:FireServer(0) R.Hit:FireServer(UNPACK(args)) end)
end
local function bringMobs()
    if not St.BringMobs then return end
    if tick() - St.BringLast < 0.35 then return end
    St.BringLast = tick()
    local hrp = getRoot() if not hrp then return end
    pcall(function() sethiddenproperty(LP, "SimulationRadius", math.huge) end)
    local folder = S.WS:FindFirstChild("Enemies") if not folder then return end
    for _, mob in ipairs(folder:GetChildren()) do
        local h = mob:FindFirstChildOfClass("Humanoid")
        local mrp = mob:FindFirstChild("HumanoidRootPart")
        if h and mrp and h.Health > 0 and dist(mrp.Position, hrp.Position) <= St.BringRange then
            local bp = mrp:FindFirstChild("HL_Bring")
            if not bp then
                bp = Instance.new("BodyPosition")
                bp.Name = "HL_Bring"
                bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bp.P = 200000
                bp.D = 500
                bp.Parent = mrp
            end
            bp.Position = Vector3.new(hrp.Position.X, hrp.Position.Y - St.Hover, hrp.Position.Z)
        end
    end
end
local function checkHaki()
    if not St.AutoHaki or not R.CommF then return end
    local c = LP.Character
    if not c or c:FindFirstChild("HasBuso") then return end
    pcall(function() R.CommF:InvokeServer("Buso") end)
end

-- TARGETS
local function findMob(name)
    local folder = S.WS:FindFirstChild("Enemies") if not folder then return nil end
    local hrp = getRoot() if not hrp then return nil end
    local best, bd
    for _, e in ipairs(folder:GetChildren()) do
        if e.Name == name then
            local h = e:FindFirstChildOfClass("Humanoid")
            local mrp = e:FindFirstChild("HumanoidRootPart")
            if h and mrp and h.Health > 0 then
                local d = dist(mrp.Position, hrp.Position)
                if not bd or d < bd then best, bd = e, d end
            end
        end
    end
    return best, bd
end
local function findNearest(maxd)
    maxd = maxd or 3000
    local folder = S.WS:FindFirstChild("Enemies") if not folder then return nil end
    local hrp = getRoot() if not hrp then return nil end
    local best, bd
    for _, e in ipairs(folder:GetChildren()) do
        local h = e:FindFirstChildOfClass("Humanoid")
        local mrp = e:FindFirstChild("HumanoidRootPart")
        if h and mrp and h.Health > 0 then
            local d = dist(mrp.Position, hrp.Position)
            if d <= maxd and (not bd or d < bd) then best, bd = e, d end
        end
    end
    return best, bd
end
local function findBoss(name)
    local folder = S.WS:FindFirstChild("Enemies")
    if folder then
        for _, e in ipairs(folder:GetChildren()) do
            local h = e:FindFirstChildOfClass("Humanoid")
            if e.Name == name and h and h.Health > 0 then return e end
        end
    end
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
local function farmTarget(mob, label)
    if not mob then St.Sub = label .. " · không mục tiêu" return false end
    local hrp = getRoot() if not hrp then return false end
    local mrp = mob:FindFirstChild("HumanoidRootPart") if not mrp then return false end
    equipWeapon()
    St.Sub = label .. " · " .. dn(mob.Name)
    local tcf = CFrame.new(mrp.Position + Vector3.new(0, St.Hover, 5))
    if dist(hrp.Position, tcf.Position) > 4 then moveTo(tcf) task.wait(0.03) end
    hrp = getRoot() if not hrp then return false end
    if dist(hrp.Position, mrp.Position) > St.AttackRange + 20 then return false end
    bringMobs()
    for _ = 1, math.max(1, St.AtkBurst) do doAttack() end
    return true
end
local function findNearestChest()
    local hrp = getRoot() if not hrp then return nil end
    local best, bd
    for _, o in ipairs(S.WS:GetDescendants()) do
        if o.Name == "Chest" or o.Name == "ChestFolderValue" then
            local p = o:IsA("BasePart") and o or o:FindFirstChildWhichIsA("BasePart")
            if p then
                local d = dist(p.Position, hrp.Position)
                if d <= 500 and (not bd or d < bd) then best, bd = p, d end
            end
        end
    end
    return best
end
runChestFarm = function()
    if tick() - St.LastChest < 1.2 then return end
    local c = findNearestChest()
    if c then
        St.LastChest = tick()
        St.Sub = "Chest · tới rương"
        teleportTo(CFrame.new(c.Position + Vector3.new(0, 3, 0)))
        task.wait(0.15)
    else
        St.Sub = "Chest · không có"
        task.wait(0.5)
    end
end

-- FRUIT SCAN
local FR_EX = { "bloxfruit","meshes","/","fruitdealer","fruitshop","fruitview",
                "fruitnotifier","fruitinventory","fruitremote" }
local function looksLikeFruit(inst)
    if not inst or not inst.Parent then return false end
    local n = inst.Name:lower()
    for _, x in ipairs(FR_EX) do if n:find(x, 1, true) then return false end end
    if inst:IsA("Tool") then return true end
    if inst:IsA("Model") or inst:IsA("BasePart") then
        if not inst.Name:find("%a+%-%a+") and not D.FRUIT_BY_KEY[inst.Name] then return false end
        if inst:IsA("Model") and not inst:FindFirstChild("Handle")
            and not inst:FindFirstChildWhichIsA("BasePart") then return false end
        return true
    end
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
            if p then
                out[#out + 1] = {
                    inst = inst, name = inst.Name, pos = p,
                    rarity = fruitRarity(inst.Name), price = fruitPrice(inst.Name),
                }
            end
        end
        for _, c in ipairs(inst:GetChildren()) do walk(c, depth + 1) end
    end
    for _, c in ipairs(S.WS:GetChildren()) do walk(c, 0) end
    St.FruitCache = out
    return out
end
tickFruit = function()
    if not (St.FruitSniper or St.FruitBring or St.FruitNotify or St.AutoStoreFruit) then return end
    local list = scanFruits()
    if St.FruitNotify then
        for _, f in ipairs(list) do
            if not St.NotifiedFruits[f.inst] then
                St.NotifiedFruits[f.inst] = true
                local tag = ({ "Common","Uncommon","Rare","Legendary","Mythical" })[f.rarity + 1] or "?"
                pcall(function()
                    S.SG:SetCore("SendNotification", {
                        Title = "Fruit: " .. f.name,
                        Text = tag .. " · $" .. tostring(f.price),
                        Duration = 5,
                    })
                end)
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
                        local h = f.inst:FindFirstChild("Handle")
                            or f.inst:FindFirstChildWhichIsA("BasePart")
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
                    pcall(function() Invoke("StoreFruit", nm) end)
                    St.Sub = "Kho · " .. nm
                    break
                end
            end
        end
    end
end

-- LEVEL FARM
local function pickTarget(l)
    if l<=9 then return "Bandit",CFrame.new(1059,15,1550),"BanditQuest1",1
    elseif l<=14 then return "Monkey",CFrame.new(-1598,36,153),"JungleQuest",1
    elseif l<=29 then return "Gorilla",CFrame.new(-1598,36,153),"JungleQuest",2
    elseif l<=44 then return "Pirate",CFrame.new(-1141,4,3831),"BuggyQuest1",1
    elseif l<=59 then return "Brute",CFrame.new(-1141,4,3831),"BuggyQuest1",2
    elseif l<=74 then return "Desert Bandit",CFrame.new(894,5,4392),"DesertQuest",1
    elseif l<=89 then return "Desert Officer",CFrame.new(894,5,4392),"DesertQuest",2
    elseif l<=99 then return "Snow Bandit",CFrame.new(1389,88,-1298),"SnowQuest",1
    elseif l<=119 then return "Snowman",CFrame.new(1389,88,-1298),"SnowQuest",2
    elseif l<=149 then return "Chief Petty Officer",CFrame.new(-5039,27,4324),"MarineQuest2",1
    elseif l<=174 then return "Sky Bandit",CFrame.new(-4839,716,-2619),"SkyQuest",1
    elseif l<=189 then return "Dark Master",CFrame.new(-4839,716,-2619),"SkyQuest",2
    elseif l<=209 then return "Prisoner",CFrame.new(5308,1,475),"PrisonerQuest",1
    elseif l<=249 then return "Dangerous Prisoner",CFrame.new(5308,1,475),"PrisonerQuest",2
    elseif l<=274 then return "Toga Warrior",CFrame.new(-1580,6,-2986),"ColosseumQuest",1
    elseif l<=299 then return "Gladiator",CFrame.new(-1580,6,-2986),"ColosseumQuest",2
    elseif l<=324 then return "Military Soldier",CFrame.new(-5313,10,8515),"MagmaQuest",1
    elseif l<=374 then return "Military Spy",CFrame.new(-5313,10,8515),"MagmaQuest",2
    elseif l<=399 then return "Fishman Warrior",CFrame.new(61122,18,1569),"FishmanQuest",1
    elseif l<=449 then return "Fishman Commando",CFrame.new(61122,18,1569),"FishmanQuest",2
    elseif l<=474 then return "God's Guard",CFrame.new(-4721,843,-1949),"SkyExp1Quest",1
    elseif l<=524 then return "Shanda",CFrame.new(-7859,5544,-381),"SkyExp1Quest",2
    elseif l<=549 then return "Royal Squad",CFrame.new(-7906,5634,-1411),"SkyExp2Quest",1
    elseif l<=624 then return "Royal Soldier",CFrame.new(-7906,5634,-1411),"SkyExp2Quest",2
    elseif l<=649 then return "Galley Pirate",CFrame.new(5259,37,4050),"FountainQuest",1
    elseif l<=699 then return "Galley Captain",CFrame.new(5259,37,4050),"FountainQuest",2
    elseif l<=724 then return "Raider",CFrame.new(-429,71,1836),"Area1Quest",1
    elseif l<=774 then return "Mercenary",CFrame.new(-429,71,1836),"Area1Quest",2
    elseif l<=799 then return "Swan Pirate",CFrame.new(638,71,918),"Area2Quest",1
    elseif l<=874 then return "Factory Staff",CFrame.new(632,73,918),"Area2Quest",2
    elseif l<=899 then return "Marine Lieutenant",CFrame.new(-2440,71,-3216),"MarineQuest3",1
    elseif l<=949 then return "Marine Captain",CFrame.new(-2440,71,-3216),"MarineQuest3",2
    elseif l<=974 then return "Zombie",CFrame.new(-5497,47,-795),"ZombieQuest",1
    elseif l<=999 then return "Vampire",CFrame.new(-5497,47,-795),"ZombieQuest",2
    elseif l<=1049 then return "Snow Trooper",CFrame.new(609,400,-5372),"SnowMountainQuest",1
    elseif l<=1099 then return "Winter Warrior",CFrame.new(609,400,-5372),"SnowMountainQuest",2
    elseif l<=1124 then return "Lab Subordinate",CFrame.new(-6064,15,-4902),"IceSideQuest",1
    elseif l<=1174 then return "Horned Warrior",CFrame.new(-6064,15,-4902),"IceSideQuest",2
    elseif l<=1199 then return "Magma Ninja",CFrame.new(-5428,15,-5299),"FireSideQuest",1
    elseif l<=1249 then return "Lava Pirate",CFrame.new(-5428,15,-5299),"FireSideQuest",2
    elseif l<=1274 then return "Ship Deckhand",CFrame.new(1037,125,32911),"ShipQuest1",1
    elseif l<=1299 then return "Ship Engineer",CFrame.new(1037,125,32911),"ShipQuest1",2
    elseif l<=1324 then return "Ship Steward",CFrame.new(968,125,33244),"ShipQuest2",1
    elseif l<=1349 then return "Ship Officer",CFrame.new(968,125,33244),"ShipQuest2",2
    elseif l<=1374 then return "Arctic Warrior",CFrame.new(5667,26,-6486),"FrostQuest",1
    elseif l<=1424 then return "Snow Lurker",CFrame.new(5667,26,-6486),"FrostQuest",2
    elseif l<=1449 then return "Sea Soldier",CFrame.new(-3054,235,-10142),"ForgottenQuest",1
    elseif l<=1499 then return "Water Fighter",CFrame.new(-3054,240,-10146),"ForgottenQuest",2
    elseif l<=1524 then return "Pirate Millionaire",CFrame.new(-290,42,5581),"PiratePortQuest",1
    elseif l<=1574 then return "Pistol Billionaire",CFrame.new(-290,42,5581),"PiratePortQuest",2
    elseif l<=1599 then return "Dragon Crew Warrior",CFrame.new(6738,127,-713),"DragonCrewQuest",1
    elseif l<=1624 then return "Dragon Crew Archer",CFrame.new(6738,127,-713),"DragonCrewQuest",2
    elseif l<=1649 then return "Hydra Enforcer",CFrame.new(5213,1004,758),"VenomCrewQuest",1
    elseif l<=1699 then return "Venomous Assailant",CFrame.new(5213,1004,758),"VenomCrewQuest",2
    elseif l<=1724 then return "Marine Commodore",CFrame.new(2180,27,-6741),"MarineTreeIsland",1
    elseif l<=1774 then return "Marine Rear Admiral",CFrame.new(2179,28,-6740),"MarineTreeIsland",2
    elseif l<=1799 then return "Fishman Raider",CFrame.new(3142,108,7482),"DeepForestIsland3",1
    elseif l<=1824 then return "Fishman Captain",CFrame.new(-10581,330,-8761),"DeepForestIsland3",2
    elseif l<=1849 then return "Forest Pirate",CFrame.new(-13234,331,-7625),"DeepForestIsland",1
    elseif l<=1899 then return "Forest Pirate",CFrame.new(-13234,331,-7625),"DeepForestIsland",2
    elseif l<=1924 then return "Jungle Pirate",CFrame.new(-12680,389,-9902),"DeepForestIsland2",1
    elseif l<=1974 then return "Musketeer Pirate",CFrame.new(-12680,389,-9902),"DeepForestIsland2",2
    elseif l<=1999 then return "Reborn Skeleton",CFrame.new(-9479,141,5566),"HauntedQuest1",1
    elseif l<=2024 then return "Living Zombie",CFrame.new(-9479,141,5566),"HauntedQuest1",2
    elseif l<=2049 then return "Demonic Soul",CFrame.new(-9516,172,6078),"HauntedQuest2",1
    elseif l<=2074 then return "Posessed Mummy",CFrame.new(-9516,172,6078),"HauntedQuest2",2
    elseif l<=2099 then return "Peanut Scout",CFrame.new(-2104,38,-10194),"NutsIslandQuest",1
    elseif l<=2124 then return "Peanut President",CFrame.new(-2104,38,-10194),"NutsIslandQuest",2
    elseif l<=2149 then return "Ice Cream Chef",CFrame.new(-820,65,-10965),"IceCreamIslandQuest",1
    elseif l<=2199 then return "Ice Cream Commander",CFrame.new(-820,65,-10965),"IceCreamIslandQuest",2
    elseif l<=2224 then return "Cookie Crafter",CFrame.new(-2021,37,-12028),"CakeQuest1",1
    elseif l<=2249 then return "Cake Guard",CFrame.new(-2021,37,-12028),"CakeQuest1",2
    elseif l<=2274 then return "Baking Staff",CFrame.new(-1927,37,-12842),"CakeQuest2",1
    elseif l<=2299 then return "Head Baker",CFrame.new(-1927,37,-12842),"CakeQuest2",2
    elseif l<=2324 then return "Cocoa Warrior",CFrame.new(233,29,-12201),"ChocQuest1",1
    elseif l<=2349 then return "Chocolate Bar Battler",CFrame.new(233,29,-12201),"ChocQuest1",2
    elseif l<=2374 then return "Sweet Thief",CFrame.new(150,30,-12774),"ChocQuest2",1
    elseif l<=2399 then return "Candy Rebel",CFrame.new(150,30,-12774),"ChocQuest2",2
    elseif l<=2424 then return "Candy Pirate",CFrame.new(-1150,20,-14446),"CandyQuest1",1
    elseif l<=2449 then return "Snow Demon",CFrame.new(-1150,20,-14446),"CandyQuest1",2
    elseif l<=2474 then return "Isle Outlaw",CFrame.new(-16547,61,-173),"TikiQuest1",1
    elseif l<=2524 then return "Island Boy",CFrame.new(-16547,61,-173),"TikiQuest1",2
    elseif l<=2574 then return "Isle Champion",CFrame.new(-16539,55,1051),"TikiQuest2",1
    elseif l<=2599 then return "Skull Slayer",CFrame.new(-16665,104,1579),"TikiQuest3",2
    elseif l<=2624 then return "Reef Bandit",CFrame.new(10778,-2087,9265),"SubmergedQuest1",1
    elseif l<=2649 then return "Coral Pirate",CFrame.new(10778,-2087,9265),"SubmergedQuest1",2
    elseif l<=2674 then return "Sea Chanter",CFrame.new(10880,-2086,10032),"SubmergedQuest2",1
    elseif l<=2699 then return "Ocean Prophet",CFrame.new(10880,-2086,10032),"SubmergedQuest2",2
    elseif l<=2719 then return "High Disciple",CFrame.new(9640,-1992,9613),"SubmergedQuest3",1
    else return "Grand Devotee",CFrame.new(9640,-1992,9613),"SubmergedQuest3",2
    end
end
local function runLevelFarm()
    local lv = myLevel()
    St.MyLevel = lv
    local mobName, giverCF, qName, qId = pickTarget(lv)
    if not mobName then St.Sub = "Không mục tiêu" task.wait(1) return end
    equipWeapon()
    if St.AutoQuest then
        local changed = St.QuestLv ~= lv
        local done = St.Kills >= 8
        if changed or done then
            local hrp = getRoot()
            if hrp and dist(hrp.Position, giverCF.Position) > 12 then
                St.Sub = "→ NPC nhận quest"
                moveTo(giverCF + Vector3.new(0, 5, 3))
                task.wait(0.05)
                return
            end
            St.Sub = "Nhận quest: " .. qName
            Invoke("StartQuest", qName, qId)
            St.QuestLv = lv
            St.Kills = 0
            St.Tracked = {}
            task.wait(0.9)
            return
        end
    end
    local live, d = findMob(mobName)
    if live and d and d < 500 then
        St.Sub = string.format("%s [Lv.%d]", dn(mobName), lv)
        farmTarget(live, "Level")
    else
        St.Sub = "Đang tới → " .. dn(mobName)
        moveTo(giverCF)
    end
    local folder = S.WS:FindFirstChild("Enemies")
    if folder then
        local now = {}
        for _, e in ipairs(folder:GetChildren()) do
            local h = e:FindFirstChildOfClass("Humanoid")
            if e.Name == mobName and h and h.Health > 0 then now[e] = true end
        end
        for i in pairs(St.Tracked) do if not now[i] or not i.Parent then St.Kills = St.Kills + 1 end end
        St.Tracked = now
    end
end

-- RAID
local function hasChip()
    local c = LP.Character
    if c and c:FindFirstChild("Special Microchip") then return true end
    local bp = LP:FindFirstChild("Backpack")
    if bp and bp:FindFirstChild("Special Microchip") then return true end
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
            if t:IsA("Tool") and (t.Name == full or t.Name == s or t.Name == s .. "-" .. s or t.Name == s .. " Fruit") then
                return true
            end
        end
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
local function runBuyChip()
    if hasChip() then return end
    if tick() - St.LastChipBuy < 5 then return end
    St.LastChipBuy = tick()
    St.Sub = "Raid · mua chip"
    pcall(function() Invoke("RaidsNpc", "Select", St.RaidChip) end)
    task.wait(1.5)
    if hasChip() then return end
    pcall(function() Invoke("BuyChip", St.RaidChip) end)
    task.wait(1.2)
    if hasChip() then return end
    for _, fn in ipairs(D.CHEAP) do
        local s = fn:match("^([^%-]+)") or fn
        St.Sub = "Raid · " .. s
        pcall(function() Invoke("LoadFruit", fn) end)
        local ok = false
        for _ = 1, 8 do task.wait(0.2) if fruitInBag(fn) then ok = true break end end
        if not ok then
            pcall(function() Invoke("LoadFruit", s) end)
            for _ = 1, 8 do task.wait(0.2) if fruitInBag(s) then ok = true break end end
        end
        if ok then
            pcall(function() Invoke("RaidsNpc", "Select", St.RaidChip) end)
            for _ = 1, 15 do
                task.wait(0.25)
                if hasChip() then St.Sub = "Raid · chip sẵn sàng" St.RaidAttempts = 0 return end
            end
        end
    end
    St.Sub = "Raid · mua thất bại"
    task.wait(2)
end
local function runStartRaid()
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
        if isl then
            summon = isl:FindFirstChild("RaidSummon2") or isl:FindFirstChild("RaidSummon") or isl:FindFirstChild("RaidSummon1")
        end
        if not summon then
            for _, d in ipairs(map:GetDescendants()) do
                if d.Name == "RaidSummon2" or d.Name == "RaidSummon" or d.Name == "RaidSummon1" then
                    summon = d break
                end
            end
        end
    end
    if summon then
        local buttonPart
        local button = summon:FindFirstChild("Button", true)
        if button then
            buttonPart = button:FindFirstChild("Main", true) or button:FindFirstChildWhichIsA("BasePart", true)
        end
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
                for _, d in ipairs(summon:GetDescendants()) do
                    if d:IsA("ClickDetector") and d ~= click then
                        pcall(function() fireclickdetector(d, 5) end)
                    end
                end
                pcall(function()
                    firetouchinterest(hrp, buttonPart, 0)
                    task.wait(0.05)
                    firetouchinterest(hrp, buttonPart, 1)
                end)
            end
        end
        FireRaid("Start", St.RaidChip)
    else
        St.Sub = "Raid · không thấy bàn"
        FireRaid("StartRaid", St.RaidChip)
    end
    St.Sub = "Raid · xác minh"
    for _ = 1, 15 do
        task.wait(0.4)
        if inRaid() then St.Sub = "Raid · đã vào" St.RaidAttempts = 0 return end
    end
    St.Sub = "Raid · thử lại " .. St.RaidAttempts
    if St.RaidAttempts >= 4 then St.RaidAttempts = 0 St.LastChipBuy = 0 end
end
local function runClearRaid()
    if not inRaid() then St.Sub = "Raid · chờ vào" return end
    if St.RaidChip == "Magma" or St.RaidChip == "Flame" then
        local map = S.WS:FindFirstChild("Map")
        if map then
            for _, d in ipairs(map:GetDescendants()) do
                if d.Name == "Lava" and d.Parent then pcall(function() d:Destroy() end) end
            end
        end
    end
    local names = { "Island 5", "Island 4", "Island 3", "Island 2", "Island 1" }
    local found
    local origin = S.WS:FindFirstChild("_WorldOrigin")
    local locs = origin and origin:FindFirstChild("Locations")
    if locs then
        local hrp = getRoot()
        if hrp then
            for _, n in ipairs(names) do
                local t = locs:FindFirstChild(n)
                if t and dist(t.Position, hrp.Position) <= 3000 then found = t St.Sub = "Raid · " .. n break end
            end
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
    if found then
        local hrp = getRoot()
        local p = found:IsA("BasePart") and found.Position or found:GetPivot().Position
        if hrp and dist(hrp.Position, p) > 100 then
            teleportTo(CFrame.new(p + Vector3.new(0, 120, 0)))
            task.wait(0.3)
        end
    else
        St.Sub = "Raid · clear"
    end
    local folder = S.WS:FindFirstChild("Enemies")
    if folder then
        local hrp = getRoot()
        if hrp then
            for _, e in ipairs(folder:GetChildren()) do
                local h = e:FindFirstChildOfClass("Humanoid")
                local mrp = e:FindFirstChild("HumanoidRootPart")
                if h and mrp and h.Health > 0 and dist(mrp.Position, hrp.Position) <= 5000 then
                    local bp = mrp:FindFirstChild("HL_Bring")
                    if not bp then
                        bp = Instance.new("BodyPosition")
                        bp.Name = "HL_Bring"
                        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bp.P = 200000
                        bp.D = 500
                        bp.Parent = mrp
                    end
                    bp.Position = Vector3.new(hrp.Position.X, hrp.Position.Y - St.Hover, hrp.Position.Z)
                end
            end
            for _ = 1, math.max(1, St.AtkBurst) do doAttack() end
        end
    end
end

-- MAIN LOOP
local function mainLoop()
    while anyMode() and not St.Destroyed do
        if St.Panic then St.Sub = "PANIC" task.wait(0.5) continue end
        local h = getHum()
        if not h or h.Health <= 0 then St.Sub = "Chết" task.wait(1) continue end
        if St.SafeMode and h.MaxHealth > 0 and h.Health / h.MaxHealth * 100 < St.SafeHP then
            St.Sub = "Safe" task.wait(0.5) continue
        end
        St.MyLevel = myLevel()
        checkHaki()
        if St.AutoRaid then
            if St.AutoClearRaid and inRaid() then runClearRaid()
            elseif hasChip() and not inRaid() then runStartRaid()
            elseif St.AutoBuyChip and not hasChip() then runBuyChip()
            else St.Sub = "Raid · chờ" end
        elseif St.AutoBoss then
            local b = findBoss(GUI_State.SelectedBoss)
            if b then farmTarget(b, "Boss") else St.Sub = "Boss · tìm" task.wait(0.5) end
        elseif St.AutoNearest then
            local m = findNearest(3000)
            if not m then St.Sub = "Gần nhất · không có" task.wait(0.5) end
            farmTarget(m, "Gần nhất")
        elseif St.AutoSpecific then
            local m = findMob(GUI_State.SelectedMob)
            farmTarget(m, "Mob chỉ định")
        elseif St.AutoChest then
            runChestFarm()
        elseif St.AutoLevel then
            runLevelFarm()
        end
        tickFruit()
        task.wait(math.max(0, St.AtkDelay))
    end
    if not anyMode() then St.Sub = "Idle" end
end

--====================================================================================
-- UI
--====================================================================================
local UI = {}
do
    local T = {
        bg0 = Color3.fromRGB(6, 8, 14), bg1 = Color3.fromRGB(12, 15, 22),
        bg2 = Color3.fromRGB(18, 22, 34), bg3 = Color3.fromRGB(26, 32, 48),
        bg4 = Color3.fromRGB(36, 44, 64),
        txt = Color3.fromRGB(240, 244, 255), dim = Color3.fromRGB(150, 158, 185),
        fnt = Color3.fromRGB(78, 88, 112),
        acc = Color3.fromRGB(255, 200, 90), hot = Color3.fromRGB(255, 230, 160),
        vio = Color3.fromRGB(200, 150, 255),
        ok  = Color3.fromRGB(72, 235, 168), warn = Color3.fromRGB(255, 200, 110),
        bad = Color3.fromRGB(255, 100, 115),
        border = Color3.fromRGB(30, 38, 54), border2 = Color3.fromRGB(56, 66, 90),
    }
    local F = {
        black = Enum.Font.GothamBlack, bold = Enum.Font.GothamBold,
        med = Enum.Font.GothamMedium, reg = Enum.Font.Gotham, mono = Enum.Font.Code,
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
        return S.Tween:Create(o, TweenInfo.new(t, s or Enum.EasingStyle.Quint, d or Enum.EasingDirection.Out), p):Play()
    end
    local function corner(o, r) mk("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = o }) end
    local function stroke(o, c, t, tr)
        return mk("UIStroke", {
            Color = c or T.acc, Thickness = t or 1, Transparency = tr or 0.4,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = o,
        })
    end

    local sg = mk("ScreenGui", {
        Name = "HL_Hub", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = GUI, DisplayOrder = 60,
    })
    local reopen = mk("TextButton", {
        Size = UDim2.new(0, 110, 0, 34), Position = UDim2.new(0, 14, 0, 170),
        BackgroundColor3 = T.acc, Text = "HOÀNG LÂM", Font = F.black, TextSize = 13,
        TextColor3 = T.bg0, Visible = false, Parent = sg,
    })
    corner(reopen, 10); stroke(reopen, T.hot, 1.5, 0.3)

    local W, H = MOBILE and 420 or 660, MOBILE and 360 or 470
    local main = mk("Frame", {
        Size = UDim2.new(0, W, 0, H), Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
        BackgroundColor3 = T.bg0, BorderSizePixel = 0, Active = true,
        ClipsDescendants = true, Parent = sg,
    })
    corner(main, 20); stroke(main, T.border2, 1, 0.4)
    local topGrad = mk("Frame", {
        Size = UDim2.new(1, -40, 0, 2), Position = UDim2.new(0, 20, 0, 0),
        BackgroundColor3 = T.acc, BorderSizePixel = 0, Parent = main,
    })
    mk("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, T.bg0),
            ColorSequenceKeypoint.new(0.35, T.acc),
            ColorSequenceKeypoint.new(0.7, T.vio),
            ColorSequenceKeypoint.new(1, T.bg0),
        }), Parent = topGrad,
    })
    local glow = mk("Frame", {
        Size = UDim2.new(0, 340, 0, 340), Position = UDim2.new(1, -170, 0, -170),
        BackgroundColor3 = T.acc, BackgroundTransparency = 0.92, BorderSizePixel = 0, Parent = main,
    })
    corner(glow, 999)

    local header = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 66), BackgroundColor3 = T.bg1,
        BackgroundTransparency = 0.15, BorderSizePixel = 0, Parent = main,
    })
    corner(header, 20)
    mk("Frame", {
        Size = UDim2.new(1, 0, 0.5, 0), Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = T.bg1, BackgroundTransparency = 0.15, BorderSizePixel = 0, Parent = header,
    })
    local logo = mk("Frame", {
        Size = UDim2.new(0, 42, 0, 42), Position = UDim2.new(0, 18, 0.5, -21),
        BackgroundColor3 = T.bg3, BorderSizePixel = 0, Parent = header,
    })
    corner(logo, 12); stroke(logo, T.acc, 1, 0.3)
    local logoInner = mk("Frame", {
        Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0.5, -13, 0.5, -13),
        BackgroundColor3 = T.acc, BackgroundTransparency = 0.86, BorderSizePixel = 0, Parent = logo,
    })
    corner(logoInner, 999)
    mk("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "HL",
        Font = F.black, TextSize = 18, TextColor3 = T.hot, Parent = logo,
    })
    mk("TextLabel", {
        Size = UDim2.new(0, 300, 0, 20), Position = UDim2.new(0, 74, 0, 14),
        BackgroundTransparency = 1, Text = AUTHOR.brand .. " " .. AUTHOR.version,
        Font = F.black, TextSize = 16, TextColor3 = T.txt,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = header,
    })
    mk("TextLabel", {
        Size = UDim2.new(0, 300, 0, 15), Position = UDim2.new(0, 74, 0, 36),
        BackgroundTransparency = 1,
        Text = "BY " .. AUTHOR.name:upper() .. " · ZALO " .. AUTHOR.zalo .. " · SEA " .. tostring(SEA or "?"),
        Font = F.reg, TextSize = 10, TextColor3 = T.fnt,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = header,
    })
    local pill = mk("Frame", {
        Size = UDim2.new(0, 118, 0, 28), Position = UDim2.new(1, -196, 0.5, -14),
        BackgroundColor3 = T.bg2, BorderSizePixel = 0, Parent = header,
    })
    corner(pill, 999)
    local pillStroke = stroke(pill, T.border2, 1, 0.4)
    local pillDot = mk("Frame", {
        Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 14, 0.5, -4),
        BackgroundColor3 = T.fnt, BorderSizePixel = 0, Parent = pill,
    })
    corner(pillDot, 999)
    local pillText = mk("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1, Text = "IDLE", Font = F.bold, TextSize = 11,
        TextColor3 = T.dim, TextXAlignment = Enum.TextXAlignment.Left, Parent = pill,
    })
    local minBtn = mk("TextButton", {
        Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(1, -76, 0.5, -16),
        BackgroundColor3 = T.bg3, BorderSizePixel = 0, Text = "—", Font = F.bold,
        TextSize = 16, TextColor3 = T.txt, AutoButtonColor = false, Parent = header,
    })
    corner(minBtn, 10)
    local closeBtn = mk("TextButton", {
        Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(1, -40, 0.5, -16),
        BackgroundColor3 = T.bg3, BorderSizePixel = 0, Text = "✕", Font = F.bold,
        TextSize = 15, TextColor3 = T.txt, AutoButtonColor = false, Parent = header,
    })
    corner(closeBtn, 10)

    local body = mk("Frame", {
        Size = UDim2.new(1, 0, 1, -66), Position = UDim2.new(0, 0, 0, 66),
        BackgroundTransparency = 1, Parent = main,
    })
    local sidebar = mk("Frame", {
        Size = UDim2.new(0, 156, 1, -24), Position = UDim2.new(0, 12, 0, 12),
        BackgroundColor3 = T.bg1, BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = body,
    })
    corner(sidebar, 14); stroke(sidebar, T.border, 1, 0.5)
    mk("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sidebar })
    mk("UIPadding", {
        PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 12), Parent = sidebar,
    })
    local pageHolder = mk("Frame", {
        Size = UDim2.new(1, -192, 1, -24), Position = UDim2.new(0, 180, 0, 12),
        BackgroundColor3 = T.bg1, BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = body,
    })
    corner(pageHolder, 14); stroke(pageHolder, T.border, 1, 0.5)

    local pages, tabBtns = {}, {}
    local function newTab(label, order, key)
        local b = mk("TextButton", {
            Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = T.bg2,
            BackgroundTransparency = 0.5, BorderSizePixel = 0, Text = "",
            AutoButtonColor = false, LayoutOrder = order, Parent = sidebar,
        })
        corner(b, 9)
        local ind = mk("Frame", {
            Size = UDim2.new(0, 3, 0, 16), Position = UDim2.new(0, 6, 0.5, -8),
            BackgroundColor3 = T.acc, BorderSizePixel = 0, Visible = false, Parent = b,
        })
        corner(ind, 999)
        local dot = mk("Frame", {
            Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(0, 18, 0.5, -3),
            BackgroundColor3 = T.fnt, BorderSizePixel = 0, Parent = b,
        })
        corner(dot, 999)
        local lbl = mk("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 30, 0, 0),
            BackgroundTransparency = 1, Text = label, Font = F.med, TextSize = 12,
            TextColor3 = T.dim, TextXAlignment = Enum.TextXAlignment.Left, Parent = b,
        })
        tabBtns[key] = { btn = b, ind = ind, dot = dot, lbl = lbl }
    end
    local function newPage(key)
        local p = mk("Frame", { Name = key, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, Parent = pageHolder })
        local sc = mk("ScrollingFrame", {
            Size = UDim2.new(1, -18, 1, -18), Position = UDim2.new(0, 9, 0, 9),
            BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
            ScrollBarImageColor3 = T.border2, ScrollBarImageTransparency = 0.3,
            CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ElasticBehavior = Enum.ElasticBehavior.Never, Parent = p,
        })
        mk("UIListLayout", { Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sc })
        pages[key] = { root = p, scroll = sc }
        return sc
    end

    local scHome   = newPage("Home")
    local scFarm   = newPage("Farm")
    local scFruit  = newPage("Fruit")
    local scAttack = newPage("Attack")
    local scRaid   = newPage("Raid")
    local scMisc   = newPage("Misc")
    local scFPS    = newPage("FPS")
    local scAbout  = newPage("About")
    newTab("Home", 1, "Home"); newTab("Farm", 2, "Farm"); newTab("Fruit", 3, "Fruit")
    newTab("Attack", 4, "Attack"); newTab("Raid", 5, "Raid"); newTab("Misc", 6, "Misc")
    newTab("FPS", 7, "FPS"); newTab("About", 8, "About")

    local function sec(par, txt, order)
        local w = mk("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = order, Parent = par })
        mk("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = txt,
            Font = F.bold, TextSize = 10, TextColor3 = T.fnt,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = w,
        })
        mk("Frame", {
            Size = UDim2.new(0, 22, 0, 2), Position = UDim2.new(0, 0, 0, 20),
            BackgroundColor3 = T.acc, BorderSizePixel = 0, Parent = w,
        })
        return w
    end
    local function glass(par, props, r)
        local f = mk("Frame", props, par)
        corner(f, r or 12); stroke(f, T.border2, 1, 0.5)
        return f
    end
    local function toggle(par, label, desc, def, cb, order)
        local w = glass(par, {
            Size = UDim2.new(1, 0, 0, desc and desc ~= "" and 74 or 56),
            BackgroundColor3 = T.bg2, BackgroundTransparency = 0.15,
            BorderSizePixel = 0, LayoutOrder = order,
        })
        mk("TextLabel", {
            Size = UDim2.new(1, -100, 0, 18), Position = UDim2.new(0, 18, 0, 12),
            BackgroundTransparency = 1, Text = label, Font = F.bold, TextSize = 13,
            TextColor3 = T.txt, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Parent = w,
        })
        if desc and desc ~= "" then
            mk("TextLabel", {
                Size = UDim2.new(1, -100, 0, 34), Position = UDim2.new(0, 18, 0, 34),
                BackgroundTransparency = 1, Text = desc, Font = F.reg, TextSize = 11,
                TextColor3 = T.dim, TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, Parent = w,
            })
        end
        local tr = mk("Frame", {
            Size = UDim2.new(0, 48, 0, 26), Position = UDim2.new(1, -66, 0, 15),
            BackgroundColor3 = def and T.ok or T.bg3, BorderSizePixel = 0, Parent = w,
        })
        corner(tr, 999)
        local tS = stroke(tr, def and T.ok or T.border2, 1, 0.3)
        local kn = mk("Frame", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = def and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
            BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = tr,
        })
        corner(kn, 999)
        local st = def
        local function paint()
            tw(kn, 0.22, { Position = st and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10) })
            tw(tr, 0.22, { BackgroundColor3 = st and T.ok or T.bg3 })
            tS.Color = st and T.ok or T.border2
        end
        local click = mk("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = w })
        click.MouseButton1Click:Connect(function() st = not st paint() if cb then cb(st) end end)
        return {
            set = function(v) if st ~= v then st = v paint() if cb then cb(st) end end end,
            get = function() return st end,
        }
    end
    local function slider(par, label, desc, mn, mx, def, un, cb, order)
        local w = glass(par, {
            Size = UDim2.new(1, 0, 0, 92), BackgroundColor3 = T.bg2,
            BackgroundTransparency = 0.15, BorderSizePixel = 0, LayoutOrder = order,
        })
        mk("TextLabel", {
            Size = UDim2.new(1, -140, 0, 18), Position = UDim2.new(0, 18, 0, 14),
            BackgroundTransparency = 1, Text = label, Font = F.bold, TextSize = 13,
            TextColor3 = T.txt, TextXAlignment = Enum.TextXAlignment.Left, Parent = w,
        })
        local vl = mk("TextLabel", {
            Size = UDim2.new(0, 120, 0, 18), Position = UDim2.new(1, -138, 0, 14),
            BackgroundTransparency = 1, Text = tostring(def) .. (un or ""),
            Font = F.mono, TextSize = 12, TextColor3 = T.hot,
            TextXAlignment = Enum.TextXAlignment.Right, Parent = w,
        })
        if desc and desc ~= "" then
            mk("TextLabel", {
                Size = UDim2.new(1, -36, 0, 34), Position = UDim2.new(0, 18, 0, 34),
                BackgroundTransparency = 1, Text = desc, Font = F.reg, TextSize = 11,
                TextColor3 = T.dim, TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, Parent = w,
            })
        end
        local th = mk("Frame", {
            Size = UDim2.new(1, -36, 0, 24), Position = UDim2.new(0, 18, 0, 64),
            BackgroundTransparency = 1, BorderSizePixel = 0, Parent = w,
        })
        local tb = mk("Frame", {
            Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 0.5, -4),
            BackgroundColor3 = T.bg3, BorderSizePixel = 0, Parent = th,
        })
        corner(tb, 999)
        local r0 = math.clamp((def - mn) / math.max(1, (mx - mn)), 0, 1)
        local fl = mk("Frame", {
            Size = UDim2.new(r0, 0, 1, 0), BackgroundColor3 = T.acc,
            BorderSizePixel = 0, Parent = tb,
        })
        corner(fl, 999)
        mk("UIGradient", {
            Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, T.acc), ColorSequenceKeypoint.new(1, T.hot) }),
            Parent = fl,
        })
        local ks = MOBILE and 22 or 18
        local kn = mk("Frame", {
            Size = UDim2.new(0, ks, 0, ks), Position = UDim2.new(r0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0, ZIndex = 3, Parent = th,
        })
        corner(kn, 999); stroke(kn, T.acc, 2, 0.2)
        local dragging = false
        local function upd(ax)
            local tx = tb.AbsolutePosition.X
            local tw_ = tb.AbsoluteSize.X
            if tw_ <= 0 then return end
            local r = math.clamp((ax - tx) / tw_, 0, 1)
            local v = math.floor(mn + r * (mx - mn) + 0.5)
            fl.Size = UDim2.new(r, 0, 1, 0)
            kn.Position = UDim2.new(r, 0, 0.5, 0)
            vl.Text = tostring(v) .. (un or "")
            if cb then cb(v) end
        end
        th.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true upd(i.Position.X)
            end
        end)
        S.UIS.InputChanged:Connect(function(i)
            if not dragging then return end
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                upd(i.Position.X)
            end
        end)
        S.UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        return {
            set = function(v)
                v = math.clamp(math.floor(v + 0.5), mn, mx)
                local r = (v - mn) / math.max(1, (mx - mn))
                fl.Size = UDim2.new(r, 0, 1, 0)
                kn.Position = UDim2.new(r, 0, 0.5, 0)
                vl.Text = tostring(v) .. (un or "")
                if cb then cb(v) end
            end,
        }
    end
    local function segments(par, label, opts, def, cb, order)
        local w = glass(par, {
            Size = UDim2.new(1, 0, 0, 82), BackgroundColor3 = T.bg2,
            BackgroundTransparency = 0.15, BorderSizePixel = 0, LayoutOrder = order,
        })
        mk("TextLabel", {
            Size = UDim2.new(1, -36, 0, 18), Position = UDim2.new(0, 18, 0, 14),
            BackgroundTransparency = 1, Text = label, Font = F.bold, TextSize = 13,
            TextColor3 = T.txt, TextXAlignment = Enum.TextXAlignment.Left, Parent = w,
        })
        local row = mk("Frame", {
            Size = UDim2.new(1, -36, 0, 38), Position = UDim2.new(0, 18, 0, 36),
            BackgroundColor3 = T.bg3, BorderSizePixel = 0, Parent = w,
        })
        corner(row, 10)
        mk("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center, Parent = row,
        })
        mk("UIPadding", { PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = row })
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
                Size = UDim2.new(1/#opts, -4, 1, -8),
                BackgroundColor3 = cur == opt and T.acc or T.bg3, BorderSizePixel = 0,
                Text = opt, Font = F.bold, TextSize = 12,
                TextColor3 = cur == opt and T.bg0 or T.dim,
                AutoButtonColor = false, LayoutOrder = i, Parent = row,
            })
            corner(b, 7); btns[opt] = b
            b.MouseButton1Click:Connect(function() cur = opt paint() if cb then cb(opt) end end)
        end
        paint()
        return {
            set = function(v) cur = v paint() if cb then cb(v) end end,
            get = function() return cur end,
        }
    end
    local openDropdown = nil
    local function dropdown(par, label, opts, def, cb, order)
        local w = glass(par, {
            Size = UDim2.new(1, 0, 0, 68), BackgroundColor3 = T.bg2,
            BackgroundTransparency = 0.15, BorderSizePixel = 0, LayoutOrder = order, ZIndex = 10,
        })
        w.ClipsDescendants = false
        local norm = function(e)
            if type(e) == "table" then return { display = e.display or e.value, value = e.value or e.display } end
            return { display = e, value = e }
        end
        local nd = {}
        for _, e in ipairs(opts) do nd[#nd + 1] = norm(e) end
        local dN = norm(def)
        mk("TextLabel", {
            Size = UDim2.new(1, -140, 0, 18), Position = UDim2.new(0, 18, 0, 14),
            BackgroundTransparency = 1, Text = label, Font = F.bold, TextSize = 13,
            TextColor3 = T.txt, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11, Parent = w,
        })
        local curLabel = mk("TextLabel", {
            Size = UDim2.new(0, 130, 0, 18), Position = UDim2.new(1, -148, 0, 14),
            BackgroundTransparency = 1, Text = tostring(dN.display), Font = F.mono,
            TextSize = 12, TextColor3 = T.hot, TextXAlignment = Enum.TextXAlignment.Right,
            TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 11, Parent = w,
        })
        local row = mk("Frame", {
            Size = UDim2.new(1, -36, 0, 32), Position = UDim2.new(0, 18, 0, 36),
            BackgroundColor3 = T.bg3, BorderSizePixel = 0, ZIndex = 11, Parent = w,
        })
        corner(row, 8); stroke(row, T.border2, 1, 0.4)
        mk("TextLabel", {
            Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -24, 0, 0),
            BackgroundTransparency = 1, Text = "▾", Font = F.bold, TextSize = 12,
            TextColor3 = T.dim, TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 12, Parent = row,
        })
        local cur = { display = dN.display, value = dN.value }
        local isOpen = false
        local btn = mk("TextButton", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 12, Parent = row,
        })
        local function close()
            if openDropdown and openDropdown.Parent then openDropdown:Destroy() end
            openDropdown = nil
            isOpen = false
        end
        btn.MouseButton1Click:Connect(function()
            if isOpen then close() return end
            close()
            local list = mk("ScrollingFrame", {
                Name = "HL_DropList",
                Size = UDim2.new(0, row.AbsoluteSize.X, 0, 170),
                Position = UDim2.new(0, row.AbsolutePosition.X - sg.AbsolutePosition.X,
                    0, row.AbsolutePosition.Y - sg.AbsolutePosition.Y + row.AbsoluteSize.Y + 4),
                BackgroundColor3 = T.bg1, BorderSizePixel = 0, ScrollBarThickness = 3,
                ScrollBarImageColor3 = T.border2, CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 500, Parent = sg,
            })
            corner(list, 8); stroke(list, T.border2, 1, 0.2)
            mk("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })
            mk("UIPadding", {
                PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
                PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = list,
            })
            for i, opt in ipairs(nd) do
                local sel = cur.value == opt.value
                local b = mk("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = sel and T.acc or T.bg3, BorderSizePixel = 0,
                    Text = tostring(opt.display), Font = F.med, TextSize = 12,
                    TextColor3 = sel and T.bg0 or T.dim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false, LayoutOrder = i, ZIndex = 501, Parent = list,
                })
                corner(b, 6)
                mk("UIPadding", { PaddingLeft = UDim.new(0, 10), Parent = b })
                b.MouseButton1Click:Connect(function()
                    cur = { display = opt.display, value = opt.value }
                    curLabel.Text = tostring(opt.display)
                    close()
                    if cb then cb(opt.value) end
                end)
            end
            openDropdown = list
            isOpen = true
        end)
        return {
            set = function(v)
                for _, o in ipairs(nd) do
                    if o.value == v then
                        cur = { display = o.display, value = o.value }
                        curLabel.Text = tostring(o.display)
                        if cb then cb(o.value) end
                        return
                    end
                end
            end,
            get = function() return cur.value end,
        }
    end
    local function actBtn(par, label, cb, order, variant)
        variant = variant or "default"
        local bg, fg = T.bg2, T.txt
        if variant == "primary" then bg, fg = T.acc, T.bg0
        elseif variant == "danger" then bg, fg = T.bad, Color3.new(1, 1, 1)
        elseif variant == "ok" then bg, fg = T.ok, T.bg0 end
        local b = mk("TextButton", {
            Size = UDim2.new(1, 0, 0, MOBILE and 46 or 42),
            BackgroundColor3 = bg, BorderSizePixel = 0, Text = label, Font = F.bold,
            TextSize = 13, TextColor3 = fg, AutoButtonColor = false,
            LayoutOrder = order, Parent = par,
        })
        corner(b, 11); stroke(b, T.border2, 1, 0.4)
        b.MouseEnter:Connect(function() tw(b, 0.15, { BackgroundColor3 = bg:Lerp(Color3.new(1, 1, 1), 0.08) }) end)
        b.MouseLeave:Connect(function() tw(b, 0.15, { BackgroundColor3 = bg }) end)
        b.MouseButton1Click:Connect(function() task.spawn(function() pcall(cb) end) end)
        return b
    end

    -- HOME
    sec(scHome, "STATUS", 1)
    local statRow = mk("Frame", { Size = UDim2.new(1, 0, 0, 84), BackgroundTransparency = 1, LayoutOrder = 2, Parent = scHome })
    mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder, Parent = statRow,
    })
    local function tile(lbl, v, col, order)
        local t = glass(statRow, {
            Size = UDim2.new(1/3, -6, 1, 0), BackgroundColor3 = T.bg2,
            BackgroundTransparency = 0.15, BorderSizePixel = 0,
            LayoutOrder = order, Parent = statRow,
        })
        mk("TextLabel", {
            Size = UDim2.new(1, -24, 0, 14), Position = UDim2.new(0, 16, 0, 14),
            BackgroundTransparency = 1, Text = lbl, Font = F.bold, TextSize = 9,
            TextColor3 = T.fnt, TextXAlignment = Enum.TextXAlignment.Left, Parent = t,
        })
        local vv = mk("TextLabel", {
            Size = UDim2.new(1, -24, 0, 24), Position = UDim2.new(0, 16, 0, 32),
            BackgroundTransparency = 1, Text = v, Font = F.black, TextSize = 20,
            TextColor3 = col, TextXAlignment = Enum.TextXAlignment.Left, Parent = t,
        })
        local dot = mk("Frame", {
            Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(1, -18, 1, -18),
            BackgroundColor3 = col, BorderSizePixel = 0, Parent = t,
        })
        corner(dot, 999)
        return vv
    end
    local lvlTile = tile("LEVEL", "1", T.hot, 1)
    local modeTile = tile("MODE", "None", T.vio, 2)
    local statusTile = tile("STATUS", "Idle", T.ok, 3)
    sec(scHome, "MODULE ĐANG BẬT", 3)
    local modCard = glass(scHome, {
        Size = UDim2.new(1, 0, 0, 180), BackgroundColor3 = T.bg2,
        BackgroundTransparency = 0.15, BorderSizePixel = 0,
        LayoutOrder = 4, Parent = scHome,
    })
    local modRow = mk("Frame", {
        Size = UDim2.new(1, -36, 1, -32), Position = UDim2.new(0, 18, 0, 16),
        BackgroundTransparency = 1, Parent = modCard,
    })
    mk("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = modRow })
    local function modLine(txt, order)
        local w = mk("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = order, Parent = modRow })
        local d = mk("Frame", {
            Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 0, 0.5, -4),
            BackgroundColor3 = T.fnt, BorderSizePixel = 0, Parent = w,
        })
        corner(d, 999)
        local l = mk("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 16, 0, 0),
            BackgroundTransparency = 1, Text = txt, Font = F.med, TextSize = 12,
            TextColor3 = T.dim, TextXAlignment = Enum.TextXAlignment.Left, Parent = w,
        })
        return { dot = d, lbl = l }
    end
    local mLines = {
        L = modLine("Auto Level Farm", 1),
        R = modLine("Auto Raid", 2),
        B = modLine("Auto Boss", 3),
        C = modLine("Auto Chest", 4),
        N = modLine("Auto Nearest", 5),
        S = modLine("Auto Specific", 6),
    }

    -- FARM
    sec(scFarm, "LEVEL FARMING", 1)
    local tglLevel = toggle(scFarm, "Auto Level Farm", "Tự đánh mob theo level + quest.", St.AutoLevel, function(v)
        St.AutoLevel = v UI.upd()
    end, 2)
    sec(scFarm, "MOB TARGET", 3)
    toggle(scFarm, "Auto Nearest Mob", "Mob gần nhất.", St.AutoNearest, function(v)
        St.AutoNearest = v UI.upd()
    end, 4)
    toggle(scFarm, "Auto Specific Mob", "Mob chọn bên dưới.", St.AutoSpecific, function(v)
        St.AutoSpecific = v UI.upd()
    end, 5)
    local function mobOpts()
        local raw = D.MOBS[SEA] or D.MOBS[1]
        local out = {}
        for _, n in ipairs(raw) do out[#out + 1] = { display = dn(n), value = n } end
        return out
    end
    local mobList = mobOpts()
    dropdown(scFarm, "Mob chỉ định", mobList, mobList[1].value, function(v) GUI_State.SelectedMob = v end, 6)
    GUI_State.SelectedMob = mobList[1].value
    sec(scFarm, "BOSS", 7)
    toggle(scFarm, "Auto Boss Farm", "Farm boss chọn.", St.AutoBoss, function(v)
        St.AutoBoss = v UI.upd()
    end, 8)
    local bossList = D.BOSSES[SEA] or D.BOSSES[1]
    dropdown(scFarm, "Boss", bossList, bossList[1], function(v) GUI_State.SelectedBoss = v end, 9)
    GUI_State.SelectedBoss = bossList[1]
    sec(scFarm, "VŨ KHÍ", 10)
    toggle(scFarm, "Auto Equip Weapon", "Tự cầm vũ khí.", St.AutoEquip, function(v)
        St.AutoEquip = v St.LastEquipped = nil
    end, 11)
    segments(scFarm, "Loại vũ khí", { "Melee", "Sword", "Gun" }, St.EquipType, function(v)
        St.EquipType = v St.LastEquipped = nil
    end, 12)
    sec(scFarm, "PHỤ", 13)
    toggle(scFarm, "Auto Quest", "", St.AutoQuest, function(v) St.AutoQuest = v end, 14)
    toggle(scFarm, "Auto Haki", "", St.AutoHaki, function(v) St.AutoHaki = v end, 15)
    toggle(scFarm, "Bring Mobs", "", St.BringMobs, function(v) St.BringMobs = v end, 16)
    sec(scFarm, "TINH CHỈNH", 17)
    slider(scFarm, "Attack Range", "", 30, 200, St.AttackRange, " studs", function(v) St.AttackRange = v end, 18)
    slider(scFarm, "Bring Range", "", 50, 600, St.BringRange, " studs", function(v) St.BringRange = v end, 19)
    slider(scFarm, "Hover Height", "", 5, 100, St.Hover, " studs", function(v) St.Hover = v end, 20)
    slider(scFarm, "Speed", "", 80, 350, St.Speed, " studs/s", function(v) St.Speed = v currentSpeed = v end, 21)
    toggle(scFarm, "Safe Mode", "Máu thấp dừng farm.", St.SafeMode, function(v) St.SafeMode = v end, 22)
    slider(scFarm, "Ngưỡng máu %", "", 5, 95, St.SafeHP, " %", function(v) St.SafeHP = v end, 23)

    -- FRUIT
    sec(scFruit, "FRUIT SNIPER", 1)
    toggle(scFruit, "Fruit Sniper", "Bay tới fruit đủ hiếm.", St.FruitSniper, function(v) St.FruitSniper = v end, 2)
    segments(scFruit, "Rarity tối thiểu", { "Common","Uncommon","Rare","Legendary","Mythical" }, "Rare", function(v)
        local m = { Common=0, Uncommon=1, Rare=2, Legendary=3, Mythical=4 }
        St.FruitMinRarity = m[v] or 2
    end, 3)
    sec(scFruit, "FRUIT BRING / NOTIFY", 4)
    toggle(scFruit, "Fruit Bring", "Hút fruit về người.", St.FruitBring, function(v) St.FruitBring = v end, 5)
    toggle(scFruit, "Fruit Notifier", "Thông báo khi fruit spawn.", St.FruitNotify, function(v) St.FruitNotify = v end, 6)
    sec(scFruit, "AUTO STORE", 7)
    toggle(scFruit, "Auto Store Fruit", "Cất fruit vào kho.", St.AutoStoreFruit, function(v) St.AutoStoreFruit = v end, 8)
    segments(scFruit, "Rarity để cất", { "Common","Uncommon","Rare","Legendary","Mythical" }, "Rare", function(v)
        local m = { Common=0, Uncommon=1, Rare=2, Legendary=3, Mythical=4 }
        St.StoreMinRarity = m[v] or 2
    end, 9)
    sec(scFruit, "HÀNH ĐỘNG", 10)
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
    end, 11, "primary")
    actBtn(scFruit, "Xem kho fruit", function()
        local inv = Invoke("GetFruits")
        if type(inv) ~= "table" then return end
        local lines = {}
        for _, f in ipairs(inv) do
            local nm = type(f) == "table" and (f.Name or f.name) or tostring(f)
            local ra = fruitRarity(nm)
            lines[#lines + 1] = nm .. " [r" .. ra .. "]"
        end
        print("[HOÀNG LÂM HUB] Kho: " .. table.concat(lines, ", "))
        pcall(function()
            S.SG:SetCore("SendNotification", {
                Title = "Kho Fruit",
                Text = #lines .. " fruit (xem Console)",
                Duration = 5,
            })
        end)
    end, 12)
    sec(scFruit, "DANH SÁCH FRUIT", 13)
    local rarityNames = { "Common","Uncommon","Rare","Legendary","Mythical" }
    for i, f in ipairs(D.FRUITS) do
        local row = glass(scFruit, {
            Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = T.bg2,
            BackgroundTransparency = 0.15, BorderSizePixel = 0, LayoutOrder = 13 + i,
        })
        mk("TextLabel", {
            Size = UDim2.new(0.7, -18, 1, 0), Position = UDim2.new(0, 18, 0, 0),
            BackgroundTransparency = 1, Text = f.name, Font = F.med, TextSize = 12,
            TextColor3 = T.txt, TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
        })
        mk("TextLabel", {
            Size = UDim2.new(0.3, -18, 1, 0), Position = UDim2.new(0.7, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = rarityNames[f.rarity + 1] .. " · $" .. tostring(f.price),
            Font = F.mono, TextSize = 10,
            TextColor3 = ({ T.fnt, T.dim, T.hot, T.vio, T.bad })[f.rarity + 1],
            TextXAlignment = Enum.TextXAlignment.Right, Parent = row,
        })
    end

    -- ATTACK
    sec(scAttack, "TIMING", 1)
    local adS = slider(scAttack, "Attack Delay", "ms giữa các đòn. 0 = mỗi frame.", 0, 100, St.AtkDelay * 1000, " ms", function(v)
        St.AtkDelay = v / 1000
    end, 2)
    local mhS = slider(scAttack, "Multi Hit", "Hit mỗi đòn.", 1, 5, St.AtkBurst, " hits", function(v)
        St.AtkBurst = math.floor(v)
    end, 3)
    sec(scAttack, "PRESET", 4)
    actBtn(scAttack, "An toàn — 33/s", function() adS.set(30) mhS.set(1) end, 5)
    actBtn(scAttack, "Bình thường — 60/s", function() adS.set(16) mhS.set(1) end, 6, "primary")
    actBtn(scAttack, "Nhanh — 120/s", function() adS.set(8) mhS.set(2) end, 7)
    actBtn(scAttack, "Cực nhanh — 300/s", function() adS.set(0) mhS.set(5) end, 8, "danger")

    -- RAID
    sec(scRaid, "MODE", 1)
    local tglRaid = toggle(scRaid, "Auto Raid", "Mua chip + clear đảo.", St.AutoRaid, function(v)
        St.AutoRaid = v UI.upd()
    end, 2)
    sec(scRaid, "TÙY CHỌN", 3)
    toggle(scRaid, "Auto Buy Chip", "", St.AutoBuyChip, function(v) St.AutoBuyChip = v end, 4)
    toggle(scRaid, "Auto Clear Raid", "", St.AutoClearRaid, function(v) St.AutoClearRaid = v end, 5)
    segments(scRaid, "Loại chip",
        { "Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Door","Rubber",
          "Barrier","Ghost","Revive","Dough","Soul","Chop" },
        St.RaidChip, function(v) St.RaidChip = v end, 6)

    -- MISC
    sec(scMisc, "NHÂN VẬT", 1)
    toggle(scMisc, "No Clip", "", St.NoClip, function(v)
        St.NoClip = v
        if not v then
            local c = LP.Character
            if c then
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
            end
        end
    end, 2)
    toggle(scMisc, "Fly (camera)", "", St.Fly, function(v) St.Fly = v end, 3)
    slider(scMisc, "Fly Speed", "", 30, 400, St.FlySpeed, "", function(v) St.FlySpeed = v end, 4)
    toggle(scMisc, "Infinite Jump", "Giữ space bay lên.", St.InfJump, function(v) St.InfJump = v end, 5)
    toggle(scMisc, "Lock Speed/Jump", "", St.LockSpeed, function(v) St.LockSpeed = v end, 6)
    sec(scMisc, "HÀNH ĐỘNG", 7)
    actBtn(scMisc, "Reset nhân vật", function()
        local c = LP.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 0 end
        end
    end, 8)
    actBtn(scMisc, "Xoá sương mù", function()
        pcall(function()
            S.Light.FogEnd = 1e6
            S.Light.FogStart = 0
            local at = S.Light:FindFirstChildOfClass("Atmosphere")
            if at then at.Density = 0 at.Haze = 0 end
        end)
    end, 9, "primary")
    sec(scMisc, "SERVER", 10)
    actBtn(scMisc, "Server Hop", function()
        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local body = game:HttpGet(url)
            local d = S.Http:JSONDecode(body)
            if not d or not d.data then return end
            for _, srv in ipairs(d.data) do
                if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                    S.TP:TeleportToPlaceInstance(game.PlaceId, srv.id, LP)
                    return
                end
            end
        end)
    end, 11, "primary")
    actBtn(scMisc, "Rejoin", function()
        pcall(function() S.TP:Teleport(game.PlaceId, LP) end)
    end, 12)
    sec(scMisc, "TIỆN ÍCH", 13)
    actBtn(scMisc, "Nhập tất cả code", function()
        local codes = {
            "Sub2CaptainMaui","kittgaming","Sub2Fer999","Enyu_is_Pro","Magicbus",
            "JCWK","Starcodeheo","Bluxxy","fudd10_v2","fudd10","Bignews",
            "THEGREATACE","Sub2NoobMaster123","Sub2UncleKizaru","Sub2Daigrock",
            "Axiore","TantaiGaming","StrawHatMaine",
        }
        for _, c in ipairs(codes) do
            pcall(function() Invoke("Redeem", c) end)
            task.wait(0.3)
        end
    end, 14, "primary")

    -- FPS
    sec(scFPS, "MASTER", 1)
    local fpsMaster
    local fS = {}
    fpsMaster = toggle(scFPS, "Bật tất cả FPS Boost", "", false, function(v)
        for _, t in pairs(fS) do t.set(v) end
    end, 2)
    sec(scFPS, "RENDER", 3)
    fS.sh = toggle(scFPS, "Tắt Shadows", "", false, function(v) FPS.shadows(v) end, 4)
    fS.pf = toggle(scFPS, "Tắt Post FX", "", false, function(v) FPS.postfx(v) end, 5)
    fS.at = toggle(scFPS, "Tắt Atmosphere", "", false, function(v) FPS.atmosphere(v) end, 6)
    fS.tr = toggle(scFPS, "Tắt nước Terrain", "", false, function(v) FPS.terrain(v) end, 7)
    fS.pa = toggle(scFPS, "Tắt Particles", "", false, function(v) FPS.particles(v) end, 8)
    fS.de = toggle(scFPS, "Tắt Decal", "", false, function(v) FPS.decals(v) end, 9)
    fS.be = toggle(scFPS, "Tắt Beams", "", false, function(v) FPS.beams(v) end, 10)
    sec(scFPS, "NHÂN VẬT", 11)
    fS.ac = toggle(scFPS, "Ẩn phụ kiện", "", false, function(v) FPS.access(v) end, 12)
    sec(scFPS, "KHÁC", 13)
    fS.dm = toggle(scFPS, "Ẩn Damage Numbers", "", false, function(v) FPS.damage(v) end, 14)
    fS.li = toggle(scFPS, "Làm tối Lighting", "", false, function(v) FPS.lighting(v) end, 15)
    sec(scFPS, "HÀNH ĐỘNG", 16)
    actBtn(scFPS, "Bật tất cả", function() fpsMaster.set(true) end, 17, "primary")
    actBtn(scFPS, "Khôi phục mặc định", function()
        FPS.restore()
        for _, t in pairs(fS) do t.set(false) end
        fpsMaster.set(false)
    end, 18)

    -- ABOUT
    sec(scAbout, "PHÍM TẮT", 1)
    local hkCard = glass(scAbout, {
        Size = UDim2.new(1, 0, 0, 130), BackgroundColor3 = T.bg2,
        BackgroundTransparency = 0.15, BorderSizePixel = 0,
        LayoutOrder = 2, Parent = scAbout,
    })
    for i, c in ipairs({
        { k = "RightShift", d = "Panic stop" },
        { k = "RightCtrl", d = "Panic stop" },
        { k = "Kéo header", d = "Di chuyển cửa sổ" },
    }) do
        mk("TextLabel", {
            Size = UDim2.new(0, 110, 0, 20), Position = UDim2.new(0, 18, 0, 16 + (i-1)*30),
            BackgroundTransparency = 1, Text = c.k, Font = F.mono, TextSize = 12,
            TextColor3 = T.bad, TextXAlignment = Enum.TextXAlignment.Left, Parent = hkCard,
        })
        mk("TextLabel", {
            Size = UDim2.new(1, -150, 0, 20), Position = UDim2.new(0, 134, 0, 16 + (i-1)*30),
            BackgroundTransparency = 1, Text = c.d, Font = F.reg, TextSize = 12,
            TextColor3 = T.dim, TextXAlignment = Enum.TextXAlignment.Left, Parent = hkCard,
        })
    end
    sec(scAbout, "TÁC GIẢ", 3)
    local auCard = glass(scAbout, {
        Size = UDim2.new(1, 0, 0, 100), BackgroundColor3 = T.bg2,
        BackgroundTransparency = 0.15, BorderSizePixel = 0,
        LayoutOrder = 4, Parent = scAbout,
    })
    mk("TextLabel", {
        Size = UDim2.new(1, -32, 0, 22), Position = UDim2.new(0, 16, 0, 14),
        BackgroundTransparency = 1, Text = AUTHOR.brand .. " " .. AUTHOR.version,
        Font = F.black, TextSize = 16, TextColor3 = T.hot,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = auCard,
    })
    mk("TextLabel", {
        Size = UDim2.new(1, -32, 0, 16), Position = UDim2.new(0, 16, 0, 40),
        BackgroundTransparency = 1, Text = "MADE BY " .. AUTHOR.name:upper(),
        Font = F.bold, TextSize = 13, TextColor3 = T.txt,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = auCard,
    })
    mk("TextLabel", {
        Size = UDim2.new(1, -32, 0, 16), Position = UDim2.new(0, 16, 0, 60),
        BackgroundTransparency = 1,
        Text = "ZALO " .. AUTHOR.zalo .. " · © 2026 " .. AUTHOR.name,
        Font = F.reg, TextSize = 11, TextColor3 = T.dim,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = auCard,
    })
    mk("TextLabel", {
        Size = UDim2.new(1, -32, 0, 16), Position = UDim2.new(0, 16, 0, 78),
        BackgroundTransparency = 1,
        Text = "Nghiêm cấm bán lại / đổi tên tác giả.",
        Font = F.reg, TextSize = 10, TextColor3 = T.bad,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = auCard,
    })
    sec(scAbout, "HÀNH ĐỘNG", 5)
    actBtn(scAbout, "Reset Quest Tracker", function()
        St.QuestLv = -1 St.Kills = 0 St.Tracked = {}
    end, 6)
    actBtn(scAbout, "Dừng tất cả", function()
        St.AutoLevel = false St.AutoRaid = false St.AutoBoss = false
        St.AutoChest = false St.AutoNearest = false St.AutoSpecific = false
        St.Panic = true stopMoving()
        tglLevel.set(false) tglRaid.set(false)
        UI.upd()
    end, 7, "danger")
    actBtn(scAbout, "Gỡ script", function()
        St.Destroyed = true St.Panic = true stopMoving()
        pcall(function() sg:Destroy() end)
        pcall(function() MoveBlock:Destroy() end)
        pcall(function()
            for _, g in ipairs(GUI:GetChildren()) do
                if g.Name == "HL_Watermark" then g:Destroy() end
            end
        end)
    end, 8, "danger")

    -- tab switch
    local busyTab = false
    local function setTab(key)
        if busyTab then return end
        busyTab = true
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
    setTab("Home")

    UI.upd = function()
        local any = anyMode()
        local function set(p, on, col)
            tw(p.dot, 0.22, { BackgroundColor3 = on and col or T.fnt })
            tw(p.lbl, 0.22, { TextColor3 = on and T.txt or T.dim })
        end
        set(mLines.L, St.AutoLevel, T.ok)
        set(mLines.R, St.AutoRaid, T.vio)
        set(mLines.B, St.AutoBoss, T.bad)
        set(mLines.C, St.AutoChest, T.warn)
        set(mLines.N, St.AutoNearest, T.hot)
        set(mLines.S, St.AutoSpecific, T.vio)
        if any then
            tw(pill, 0.22, { BackgroundColor3 = T.ok })
            pillStroke.Color = T.ok
            pillText.TextColor3 = T.bg0
            pillDot.BackgroundColor3 = T.bg0
            if St.AutoRaid then pillText.Text = "RAID" modeTile.Text = "Raid" modeTile.TextColor3 = T.vio
            elseif St.AutoBoss then pillText.Text = "BOSS" modeTile.Text = "Boss" modeTile.TextColor3 = T.bad
            elseif St.AutoNearest then pillText.Text = "NEAREST" modeTile.Text = "Nearest" modeTile.TextColor3 = T.hot
            elseif St.AutoSpecific then pillText.Text = "SPECIFIC" modeTile.Text = "Specific" modeTile.TextColor3 = T.vio
            elseif St.AutoChest then pillText.Text = "CHEST" modeTile.Text = "Chest" modeTile.TextColor3 = T.warn
            elseif St.AutoLevel then pillText.Text = "FARM" modeTile.Text = "Farm" modeTile.TextColor3 = T.hot end
            if not St.Running then
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

    -- drag
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = i.Position startPos = main.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    S.UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = i.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end)

    -- panic
    S.UIS.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == Enum.KeyCode.RightControl or i.KeyCode == Enum.KeyCode.RightShift then
            St.Panic = true
            St.AutoLevel = false St.AutoRaid = false St.AutoBoss = false
            St.AutoChest = false St.AutoNearest = false St.AutoSpecific = false
            stopMoving()
            tglLevel.set(false) tglRaid.set(false)
            UI.upd()
        end
    end)

    -- minimize / close
    local minimized = false
    local originalSize = UDim2.new(0, W, 0, H)
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        tw(main, 0.32, { Size = minimized and UDim2.new(0, W, 0, 66) or originalSize })
        body.Visible = not minimized
        minBtn.Text = minimized and "+" or "—"
    end)
    closeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        reopen.Visible = true
    end)
    reopen.MouseButton1Click:Connect(function()
        reopen.Visible = false
        main.Visible = true
    end)

    -- status bar
    task.spawn(function()
        while not St.Destroyed and sg.Parent do
            St.MyLevel = myLevel()
            lvlTile.Text = tostring(St.MyLevel)
            local s = St.Sub
            if #s > 20 then s = string.sub(s, 1, 18) .. ".." end
            statusTile.Text = s
            task.wait(0.35)
        end
    end)

    main.Size = UDim2.new(0, W, 0, 0)
    main.BackgroundTransparency = 1
    main.Visible = false
    task.wait(0.1)
    main.Visible = true
    tw(main, 0.55, { Size = originalSize, BackgroundTransparency = 0 },
        Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- WATERMARK + ANTI-TAMPER
    local wm = mk("ScreenGui", {
        Name = "HL_Watermark", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999, Parent = GUI,
    })
    local wf = mk("Frame", {
        Size = UDim2.new(0, 240, 0, 22), Position = UDim2.new(1, -248, 0, 8),
        BackgroundColor3 = Color3.fromRGB(10, 12, 20), BackgroundTransparency = 0.35,
        BorderSizePixel = 0, Parent = wm,
    })
    corner(wf, 6); stroke(wf, T.acc, 1, 0.4)
    mk("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1, Text = AUTHOR.brand .. " · Zalo " .. AUTHOR.zalo,
        Font = F.bold, TextSize = 10, TextColor3 = T.hot,
        TextXAlignment = Enum.TextXAlignment.Center, Parent = wf,
    })

    pcall(function() sg:SetAttribute("Author", AUTHOR.name) end)
    pcall(function() sg:SetAttribute("Zalo", AUTHOR.zalo) end)
    task.spawn(function()
        while not St.Destroyed do
            task.wait(3)
            local h = GUI:FindFirstChild("HL_Hub")
            if h then
                if h:GetAttribute("Author") ~= AUTHOR.name then
                    pcall(function() h:SetAttribute("Author", AUTHOR.name) end)
                end
                if h:GetAttribute("Zalo") ~= AUTHOR.zalo then
                    pcall(function() h:SetAttribute("Zalo", AUTHOR.zalo) end)
                end
            end
        end
    end)
end

--====================================================================================
-- PLAYER MODS
--====================================================================================
S.Run.Stepped:Connect(function()
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
            h.WalkSpeed = math.max(16, tonumber(St.Speed) or 170)
            h.JumpPower = 90
            h.UseJumpPower = true
        end
    end
end)

do
    local flyBV, flyBG
    local function flySet(on)
        local r = getRoot()
        if on then
            if not r then St.Fly = false return end
            if not flyBV then
                flyBV = Instance.new("BodyVelocity")
                flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                flyBV.Velocity = Vector3.zero
                flyBV.P = 1e4
                flyBV.Parent = r
                flyBG = Instance.new("BodyGyro")
                flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                flyBG.P = 9e4
                flyBG.Parent = r
            end
        else
            if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
            if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
        end
    end
    S.Run.Heartbeat:Connect(function()
        if St.Destroyed then return end
        if not St.Fly then
            if flyBV then flySet(false) end
            return
        end
        local r = getRoot()
        if not r then return end
        if not flyBV or flyBV.Parent ~= r then
            flySet(false)
            flySet(true)
            return
        end
        local cam = S.WS.CurrentCamera
        local fwd, right = cam.CFrame.LookVector, cam.CFrame.RightVector
        local dir = Vector3.zero
        if S.UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + fwd end
        if S.UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - fwd end
        if S.UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - right end
        if S.UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + right end
        if S.UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if S.UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
        if dir.Magnitude > 0 then dir = dir.Unit end
        flyBV.Velocity = dir * St.FlySpeed
        flyBG.CFrame = CFrame.lookAt(r.Position, r.Position + dir)
    end)
    task.spawn(function()
        while not St.Destroyed do
            task.wait(0.2)
            if St.InfJump then
                local h = getHum()
                if h and h.Health > 0 and S.UIS:IsKeyDown(Enum.KeyCode.Space) then
                    local st = h:GetState()
                    if st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Landed
                        or st == Enum.HumanoidStateType.Jumping then
                        h:ChangeState(Enum.HumanoidStateType.Jumping)
                        local r = getRoot()
                        if r then
                            local v = r.AssemblyLinearVelocity
                            r.AssemblyLinearVelocity = Vector3.new(v.X, math.max(v.Y, 45), v.Z)
                        end
                    end
                end
            end
        end
    end)
    task.spawn(function()
        while not St.Destroyed do
            task.wait(60)
            pcall(function()
                S.VU:CaptureController()
                S.VU:ClickButton2(Vector2.new())
            end)
        end
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(1.5)
    if St.Fly then
        St.Fly = false
        task.wait(0.3)
        St.Fly = true
    end
end)

--====================================================================================
-- BOOT
--====================================================================================
pcall(function()
    S.SG:SetCore("SendNotification", {
        Title = AUTHOR.brand .. " " .. AUTHOR.version,
        Text = "Đã load · Made by " .. AUTHOR.name .. " · Zalo " .. AUTHOR.zalo,
        Duration = 8,
    })
end)
print("══════════════════════════════════════════════════════════")
print("  " .. AUTHOR.brand .. " " .. AUTHOR.version .. " — READY")
print("  MADE BY " .. AUTHOR.name:upper() .. " · ZALO " .. AUTHOR.zalo)
print("  © 2026 " .. AUTHOR.name .. ". Nghiêm cấm bán lại / đổi tên tác giả.")
print("  Key server: " .. SERVER_URL)
print("  Sea: " .. tostring(SEA or "?"))
print("  CommF_: " .. tostring(R.CommF ~= nil))
print("══════════════════════════════════════════════════════════")