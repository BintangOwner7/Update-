-- deobfuscate by Asta
-- niskala Asta

local BRAND_ASSET_ID = "126710436488213"
local BRAND_ASSET    = "rbxassetid://" .. BRAND_ASSET_ID
local BRAND_NAME     = "A2"

local Presentation = (function()

local Presentation = {}
Presentation.LibraryURL = "https://raw.githubusercontent.com/aseumusu-design/library-v2/refs/heads/main/A2UI_v4.6-live"
Presentation.BubbleLogo = BRAND_ASSET
Presentation.Title = BRAND_NAME .. " HUB"
Presentation.Columns = 2
local aliases = {
    dashboard = "home", discord = "discord",
    main = "menu", survivor = "survival", killer = "sword", visual = "target",
    teleport = "rocket", settings = "settings", move = "player",
    ["server-cog"] = "settings", sparkles = "star", camera = "target",
    ["eye-off"] = "shield", ["user-cog"] = "user", crosshair = "target",
    shirt = "user", ["plug-zap"] = "bolt", zap = "bolt", swords = "sword",
    fence = "shield", ["arrow-up-right"] = "rocket", ["flask-conical"] = "package",
    ["repeat"] = "refresh", eye = "target", flashlight = "star", map = "pin",
    users = "user", ["sliders-vertical"] = "settings",
}
function Presentation.Icon(name, fallback)
    local lower = tostring(name or ""):lower()
    return aliases[lower] or fallback or "info"
end
function Presentation.Metrics(frames, elapsed, pingSeconds)
    local fps = elapsed > 0 and math.floor(frames / elapsed + .5) or 0
    local ping = type(pingSeconds) == "number" and math.max(0, math.floor(pingSeconds * 1000 + .5)) or nil
    return fps, ping
end
function Presentation.Clamp(x, y, width, height, size)
    return math.clamp(x, 10, math.max(10, width - size - 10)),
        math.clamp(y, 10, math.max(10, height - size - 10))
end
local function create(class, properties)
    local object = Instance.new(class)
    for key, value in pairs(properties) do object[key] = value end
    return object
end
local function iconImage(A2, parent, name, properties)
    local icon = A2.Icons[name] or A2.Icons.info
    properties.BackgroundTransparency = 1
    properties.Image = type(icon[1]) == "number" and ("rbxassetid://" .. tostring(icon[1])) or icon[1]
    properties.ImageRectSize = icon[2] or Vector2.new(0, 0)
    properties.ImageRectOffset = icon[3] or Vector2.new(0, 0)
    properties.ImageColor3 = A2.Theme.text
    properties.Parent = parent
    return create("ImageLabel", properties)
end
function Presentation.Section(A2, tab, section, iconName)

    if not section._inner or not tab._page then return end
    if not tab._a2Columns then
        local holder = create("Frame", { Name = "A2GroupedColumns", Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = tab._page })
        local columns = {}
        for i = 1, Presentation.Columns do
            local column = create("Frame", { Name = "Column" .. i,
                Size = UDim2.new(.5, -6, 0, 0), Position = UDim2.new((i - 1) * .5, (i - 1) * 6, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = holder })
            create("UIListLayout", { Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = column })
            columns[i] = column
        end
        tab._a2Columns, tab._a2SectionCount = columns, 0
    end
    tab._a2SectionCount = tab._a2SectionCount + 1
    local card = section._inner.Parent
    local index = (tab._a2SectionCount - 1) % Presentation.Columns + 1
    card.Parent = tab._a2Columns[index]
    card.LayoutOrder = tab._a2SectionCount
    local corner = card:FindFirstChildOfClass("UICorner")
    if corner then corner.CornerRadius = UDim.new(0, 8) end
    for _, child in ipairs(section._inner:GetChildren()) do
        if child:IsA("TextLabel") and child.LayoutOrder == -1000 then
            local header = create("Frame", { Name = "SectionHeader", Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1, LayoutOrder = -1000, Parent = section._inner })
            child.Parent = header
            child.Position, child.Size = UDim2.fromOffset(28, 0), UDim2.new(1, -28, 1, 0)
            child.TextSize, child.TextWrapped = 12, true
            iconImage(A2, header, iconName, { Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(0, 3) })
        end
    end
end
function Presentation.CompactSlider(section)
    if not section._inner then return end
    for _, row in ipairs(section._inner:GetChildren()) do
        if row:IsA("Frame") and row.LayoutOrder == section._count then
            local holder, track, badge
            for _, child in ipairs(row:GetChildren()) do
                if child:IsA("TextLabel") or child:IsA("TextBox") then badge = child
                elseif child:IsA("Frame") then
                    if child:FindFirstChildOfClass("UIListLayout") then holder = child else track = child end
                end
            end
            if holder and track and badge then
                row.Size = UDim2.new(1, 0, 0, 30)
                holder.Size = UDim2.new(.46, -6, 0, 0)
                track.Position, track.Size = UDim2.new(.48, 0, 0, 11), UDim2.new(.52, -54, 0, 6)
                badge.Position = UDim2.new(1, 0, 0, 5)
            end
        end
    end
end
function Presentation.Mount(A2, win)

    if not Instance then return end
    local UIS, Run = game:GetService("UserInputService"), game:GetService("RunService")
    local connections = {}
    local function bind(signal, fn) table.insert(connections, signal:Connect(fn)) end
    local bubble = win.OpenBtn
    if bubble then
        for _, connection in ipairs(win._bubbleConnections or {}) do connection:Disconnect() end
        win._bubbleConnections = {}

        local BUBBLE_SIZE, BUBBLE_RADIUS, BUBBLE_GRAB = 46, 10, 8
        bubble.Size = UDim2.fromOffset(BUBBLE_SIZE, BUBBLE_SIZE)
        local function setCorner(object, radius)
            if not object then return end
            local corner = object:FindFirstChildOfClass("UICorner")
            if not corner then corner = create("UICorner", { Parent = object }) end
            corner.CornerRadius = UDim.new(0, radius)
        end
        setCorner(bubble, BUBBLE_RADIUS)
        setCorner(bubble:FindFirstChild("BubbleHalo"), BUBBLE_RADIUS + 4)
        setCorner(bubble:FindFirstChild("innerRing"), BUBBLE_RADIUS)

        for _, descendant in ipairs(bubble:GetDescendants()) do
            local corner = descendant:FindFirstChildOfClass("UICorner")
            if corner and corner.CornerRadius.Offset >= 999 then
                corner.CornerRadius = UDim.new(0, BUBBLE_RADIUS)
            end
        end

        for _, child in ipairs(bubble:GetChildren()) do
            if child:IsA("TextLabel") then child.Visible = false end
        end
        local existingLogo = bubble:FindFirstChild("A2BubbleLogo")
        if existingLogo then existingLogo:Destroy() end
        local logoSize = BUBBLE_SIZE - 16
        create("ImageLabel", { Name = "A2BubbleLogo", Image = Presentation.BubbleLogo,
            ImageColor3 = A2.Theme.white, BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5),
            Size = UDim2.fromOffset(logoSize, logoSize),
            ScaleType = Enum.ScaleType.Fit, ZIndex = 203, Parent = bubble })

        local dragging, dragInput, dragStart, startPos, moved, suppressUntil, openedThisPress = false, nil, nil, nil, false, 0, false

        local function parentSize()
            local parent = bubble.Parent
            local size = parent and parent.AbsoluteSize
            if not size or size.X < 1 or size.Y < 1 then size = win.Gui.AbsoluteSize end
            return size
        end
        local function clampBubble()
            local size = parentSize()
            if not size or size.X < 1 or size.Y < 1 then return end
            local pos, anchor = bubble.Position, bubble.AnchorPoint
            local px = pos.X.Offset + pos.X.Scale * size.X
            local py = pos.Y.Offset + pos.Y.Scale * size.Y
            local x, y = Presentation.Clamp(px - anchor.X * BUBBLE_SIZE, py - anchor.Y * BUBBLE_SIZE,
                size.X, size.Y, BUBBLE_SIZE)
            bubble.Position = UDim2.fromOffset(x + anchor.X * BUBBLE_SIZE, y + anchor.Y * BUBBLE_SIZE)
        end
        bind(bubble.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging, dragInput, dragStart = true, input, input.Position
                moved, openedThisPress = false, false

                startPos = bubble.Position
                input.Changed:Connect(function()
                    if input.UserInputState ~= Enum.UserInputState.End then return end
                    dragging = false
                    if moved then
                        suppressUntil = os.clock() + .25
                    elseif not openedThisPress then
                        openedThisPress = true
                        win:Open()
                    end
                end)
            end
        end)
        bind(bubble.InputChanged, function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        bind(UIS.InputChanged, function(input)
            if not dragging then return end
            local isMouse = input.UserInputType == Enum.UserInputType.MouseMovement
            local isTouch = input.UserInputType == Enum.UserInputType.Touch
            if not (isMouse or isTouch) then return end
            if isTouch and dragInput and input ~= dragInput then return end
            local delta = input.Position - dragStart
            if delta.Magnitude > BUBBLE_GRAB then moved = true end
            if not moved then return end

            local size = parentSize()
            local sx = size and size.X or 0
            local sy = size and size.Y or 0
            bubble.Position = UDim2.fromOffset(
                startPos.X.Offset + startPos.X.Scale * sx + delta.X,
                startPos.Y.Offset + startPos.Y.Scale * sy + delta.Y)
            clampBubble()
        end)
        bind(bubble.Activated, function()
            if moved or os.clock() < suppressUntil or openedThisPress then return end
            openedThisPress = true
            win:Open()
        end)
        bind(win.Gui:GetPropertyChangedSignal("AbsoluteSize"), clampBubble)
    end
    local bar = create("TextLabel", { Name = "A2LivePerformance", AnchorPoint = Vector2.new(.5, 0),
        Position = UDim2.new(.5, 0, 0, 12), Size = UDim2.fromOffset(238, 30),
        BackgroundColor3 = A2.Theme.bgPanel, TextColor3 = A2.Theme.text, BorderSizePixel = 0,
        Text = "A2 v4  |  FPS â¦  |  PING â¦", Font = Enum.Font.GothamMedium, TextSize = 12,
        ZIndex = 250, Active = true, Parent = win.Gui })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = bar })

    local barStroke = create("UIStroke", {
        Color = A2.Theme.glow or A2.Theme.primary or A2.Theme.stroke,
        Transparency = .1, Thickness = 2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = bar })
    if A2.SetGlow then
        A2:SetGlow(barStroke, "pulse", { Prop = "Color",
            Color = A2.Theme.glow or A2.Theme.primary, Speed = 2.4 })
    end

    do
        local barDragging, barDragInput, barDragStart, barStartPos, barMoved = false, nil, nil, nil, false
        local BAR_GRAB = 4
        local function barParentSize()
            local parent = bar.Parent
            local size = parent and parent.AbsoluteSize
            if not size or size.X < 1 or size.Y < 1 then size = win.Gui.AbsoluteSize end
            return size
        end
        local function clampBar()
            local size = barParentSize()
            if not size or size.X < 1 or size.Y < 1 then return end
            local pos, anchor = bar.Position, bar.AnchorPoint
            local abs = bar.AbsoluteSize
            local w = abs.X > 0 and abs.X or 238
            local h = abs.Y > 0 and abs.Y or 30
            local px = pos.X.Offset + pos.X.Scale * size.X
            local py = pos.Y.Offset + pos.Y.Scale * size.Y
            local x = math.clamp(px - anchor.X * w, 4, math.max(4, size.X - w - 4))
            local y = math.clamp(py - anchor.Y * h, 4, math.max(4, size.Y - h - 4))
            bar.Position = UDim2.fromOffset(x + anchor.X * w, y + anchor.Y * h)
        end
        bind(bar.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                barDragging, barDragInput, barDragStart = true, input, input.Position
                barMoved = false
                barStartPos = bar.Position
                input.Changed:Connect(function()
                    if input.UserInputState ~= Enum.UserInputState.End then return end
                    barDragging = false
                end)
            end
        end)
        bind(bar.InputChanged, function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                barDragInput = input
            end
        end)
        bind(UIS.InputChanged, function(input)
            if not barDragging then return end
            local isMouse = input.UserInputType == Enum.UserInputType.MouseMovement
            local isTouch = input.UserInputType == Enum.UserInputType.Touch
            if not (isMouse or isTouch) then return end
            if isTouch and barDragInput and input ~= barDragInput then return end
            local delta = input.Position - barDragStart
            if delta.Magnitude > BAR_GRAB then barMoved = true end
            if not barMoved then return end
            local size = barParentSize()
            local sx = size and size.X or 0
            local sy = size and size.Y or 0
            bar.Position = UDim2.fromOffset(
                barStartPos.X.Offset + barStartPos.X.Scale * sx + delta.X,
                barStartPos.Y.Offset + barStartPos.Y.Scale * sy + delta.Y)
            clampBar()
        end)
        bind(win.Gui:GetPropertyChangedSignal("AbsoluteSize"), clampBar)
    end
    local frames, elapsed = 0, 0
    local function update()
        local success, ping = pcall(function() return game:GetService("Players").LocalPlayer:GetNetworkPing() end)
        local fps, ms = Presentation.Metrics(frames, elapsed, success and ping or nil)
        bar.Text = string.format("A2 v4  |  FPS %d  |  PING %s", fps, ms and (tostring(ms) .. " ms") or "â")
    end
    update()
    bind(Run.RenderStepped, function(dt)
        frames, elapsed = frames + 1, elapsed + dt
        if elapsed >= .5 then update(); frames, elapsed = 0, 0 end
    end)
    bind(win.Gui.Destroying, function()
        for _, connection in ipairs(connections) do connection:Disconnect() end
    end)
end
return Presentation
end)()

local env = getgenv and getgenv() or _G
local previous = env.A2UI_NO_AUTOMOUNT
env.A2UI_NO_AUTOMOUNT = true
local ok, A2 = pcall(function()
    return (function()
local A2UI = {}
A2UI.__index = A2UI
A2UI.Version = "4.6-live"
local CoreGui           = game:GetService("CoreGui")
local Players           = game:GetService("Players")
local HttpService       = game:GetService("HttpService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local Mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local C = {
    primary   = Color3.fromRGB(218, 222, 232),
    secondary = Color3.fromRGB(153, 164, 184),
    glow      = Color3.fromRGB(205, 211, 225),
    bgDeep    = Color3.fromRGB(9, 11, 16),
    bgPanel   = Color3.fromRGB(16, 18, 24),
    bgRow     = Color3.fromRGB(27, 30, 38),
    bgHover   = Color3.fromRGB(42, 46, 57),
    stroke    = Color3.fromRGB(91, 99, 116),
    text      = Color3.fromRGB(222, 225, 232),
    dim       = Color3.fromRGB(150, 156, 169),
    white     = Color3.fromRGB(250, 251, 253),
    good      = Color3.fromRGB(46, 204, 113),
    bad       = Color3.fromRGB(239, 79, 79),
    warn      = Color3.fromRGB(236, 162, 1),
}
A2UI.Theme = C
local GRADIENT_HOT = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.primary),
    ColorSequenceKeypoint.new(1, C.secondary),
})
local GRADIENT_TITLE = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.white),
    ColorSequenceKeypoint.new(0.6, C.primary),
    ColorSequenceKeypoint.new(1, C.secondary),
})
local GRADIENT_PANEL = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.bgPanel),
    ColorSequenceKeypoint.new(1, C.bgDeep),
})
local function detectExecutor()
    if type(identifyexecutor) == "function" then
        local ok, name = pcall(identifyexecutor)
        if ok and name and tostring(name) ~= "" then return tostring(name) end
    end
    if type(getexecutorname) == "function" then
        local ok, name = pcall(getexecutorname)
        if ok and name and tostring(name) ~= "" then return tostring(name) end
    end
    if RunService:IsStudio() then return "Roblox Studio" end
    return "Unknown Executor"
end
local function getPlaceName()
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if ok and info and info.Name then return info.Name end
    return game.Name
end
local A2_ENV = {
    Executor = detectExecutor(),
    Place    = getPlaceName(),
    PlaceId  = game.PlaceId,
    User     = LocalPlayer and LocalPlayer.Name or "Player",
    Mobile   = Mobile,
}
A2UI.Env = A2_ENV
local function guiParent()
    local p
    pcall(function()
        if type(gethui) == "function" then p = gethui() end
    end)
    if p then return p end
    pcall(function()
        if LocalPlayer then p = LocalPlayer:WaitForChild("PlayerGui", 10) end
    end)
    if p then return p end
    pcall(function() p = CoreGui end)
    return p
end
local function getRequestFunction()
    if type(request) == "function" then return request end
    if type(http_request) == "function" then return http_request end
    if syn and type(syn.request) == "function" then return syn.request end
    if http and type(http.request) == "function" then return http.request end
    return nil
end
local function validWebhookUrl(url)
    if type(url) ~= "string" then return false end
    return url:match("^https://discord%.com/api/webhooks/") ~= nil
        or url:match("^https://discordapp%.com/api/webhooks/") ~= nil
end
function A2UI:SetWebhook(url)
    url = tostring(url or ""):gsub("%s+$", "")
    if url == "" then self.WebhookURL = nil; return false, "URL webhook kosong" end
    if not validWebhookUrl(url) then return false, "URL harus Discord webhook yang valid" end
    self.WebhookURL = url
    return true
end
function A2UI:Webhook(opts)
    opts = opts or {}
    local url = opts.URL or self.WebhookURL
    if not validWebhookUrl(url) then return false, "Webhook belum diatur / URL tidak valid" end
    local now = os.clock()
    if self._lastWebhook and now - self._lastWebhook < 1 then
        return false, "Tunggu sebentar sebelum kirim webhook lagi"
    end
    local req = getRequestFunction()
    if not req then return false, "Executor tidak punya fungsi HTTP request" end
    local payload = {
        username = opts.Username or "A2 FUSION",
        content = opts.Content or "A2 status update",
    }
    if opts.Embeds then payload.embeds = opts.Embeds end
    local okEncode, body = pcall(function() return HttpService:JSONEncode(payload) end)
    if not okEncode then return false, "Gagal encode payload" end
    local ok, response = pcall(function()
        return req({ Url = url, Method = "POST",
            Headers = { ["Content-Type"] = "application/json" }, Body = body })
    end)
    if not ok then return false, tostring(response) end
    self._lastWebhook = now
    local status = type(response) == "table" and (response.StatusCode or response.Status) or nil
    if status and tonumber(status) and (tonumber(status) < 200 or tonumber(status) >= 300) then
        return false, "Discord menolak (HTTP " .. tostring(status) .. ")"
    end
    return true, response
end
A2UI.SendWebhook = A2UI.Webhook
local VirtualUser = game:GetService("VirtualUser")
local antiAFKEnabled = false
if LocalPlayer then
    LocalPlayer.Idled:Connect(function()
        if antiAFKEnabled then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end)
end
function A2UI:SetAntiAFK(enabled)
    antiAFKEnabled = enabled and true or false
    return antiAFKEnabled
end
function A2UI:IsAntiAFK() return antiAFKEnabled end
local CONFIG_DIR = "A2Fusion/Configs"
function A2UI:RegisterConfigElement(flag, getFn, setFn)
    if type(flag) ~= "string" or flag == "" then return end
    self._configElements = self._configElements or {}
    self._configElements[flag] = { Get = getFn, Set = setFn }
    if self._pendingConfig and self._pendingConfig[flag] ~= nil and type(setFn) == "function" then
        local v = self._pendingConfig[flag]
        self._pendingConfig[flag] = nil
        task.defer(function() pcall(setFn, v) end)
    end
end
local function ensureDir(path)
    if type(makefolder) ~= "function" then return end
    local acc = ""
    for part in tostring(path):gmatch("[^/]+") do
        acc = (acc == "" and part) or (acc .. "/" .. part)
        pcall(function()
            if not (isfolder and isfolder(acc)) then makefolder(acc) end
        end)
    end
end
A2UI._ensureDir = ensureDir
function A2UI:ListConfigs()
    ensureDir("A2Fusion/Configs")
    local out = {}
    if type(listfiles) ~= "function" then return out end
    local ok, files = pcall(listfiles, "A2Fusion/Configs")
    if not ok or type(files) ~= "table" then return out end
    for _, f in ipairs(files) do
        local name = tostring(f):gsub("\\", "/"):match("([^/]+)%.json$")
        if name then table.insert(out, name) end
    end
    table.sort(out)
    return out
end
function A2UI:DeleteConfig(name)
    if type(delfile) ~= "function" then return false, "Executor tidak support delfile" end
    local ok, err = pcall(delfile, "A2Fusion/Configs/" .. tostring(name) .. ".json")
    return ok, ok and ("Config '" .. tostring(name) .. "' dihapus") or tostring(err)
end
function A2UI:_autoSave()
    if self._autoSavePending then return end
    self._autoSavePending = true
    task.delay(1.2, function()
        self._autoSavePending = false
        pcall(function() self:SaveConfig("autosave") end)
    end)
end
function A2UI:SaveConfig(name)
    name = tostring(name or "default")
    if type(writefile) ~= "function" then return false, "Executor tidak support writefile" end
    self._configElements = self._configElements or {}
    local data = {}
    for flag, el in pairs(self._configElements) do
        local ok, v = pcall(el.Get)
        if ok then data[flag] = v end
    end
    ensureDir(CONFIG_DIR)
    local okE, body = pcall(function() return HttpService:JSONEncode(data) end)
    if not okE then return false, "Gagal encode config" end
    local okW, err = pcall(function() return writefile(CONFIG_DIR .. "/" .. name .. ".json", body) end)
    if not okW then return false, tostring(err) end
    return true, CONFIG_DIR .. "/" .. name .. ".json"
end
function A2UI:LoadConfig(name)
    name = tostring(name or "default")
    if type(readfile) ~= "function" then return false, "Executor tidak support readfile" end
    local okR, body = pcall(function() return readfile(CONFIG_DIR .. "/" .. name .. ".json") end)
    if not okR or type(body) ~= "string" then return false, "Config '" .. name .. "' tidak ditemukan" end
    local okD, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not okD or type(data) ~= "table" then return false, "File config rusak / bukan JSON" end
    self._configElements = self._configElements or {}
    local applied, missing = 0, 0
    for flag, value in pairs(data) do
        local el = self._configElements[flag]
        if el and type(el.Set) == "function" then
            pcall(function() el.Set(value) end)
            applied = applied + 1
        else
            self._pendingConfig = self._pendingConfig or {}
            self._pendingConfig[flag] = value
            missing = missing + 1
        end
    end
    return true, "Applied " .. applied .. " nilai" .. (missing > 0 and (" â¢ " .. missing .. " menunggu elemen") or "")
end
A2UI.LoaderURL = ""
function A2UI:SetLoaderURL(url)
    url = tostring(url or ""):gsub("%s+$", "")
    if url == "" or not url:match("^https?://") then return false, "URL loader tidak valid" end
    self.LoaderURL = url
    return true
end
function A2UI:InstallAutoExecute(loaderUrl)
    loaderUrl = tostring(loaderUrl or ""):gsub("%s+$", "")
    if loaderUrl == "" then loaderUrl = tostring(self.LoaderURL or ""):gsub("%s+$", "") end
    if loaderUrl == "" or not loaderUrl:match("^https?://") then
        return false, "Isi Loader URL dulu â host loader.lua kamu (misal GitHub raw), lalu paste URL-nya"
    end
    if type(writefile) ~= "function" then return false, "Executor tidak support writefile" end
    local loaderCode = "-- A2 FUSION auto-loader (jangan dihapus)\nloadstring(game:HttpGet(" .. string.format("%q", loaderUrl) .. "))()"
    local folders = { "Autoexecute", "autoexecute", "AutoExec", "autoexec" }
    local written = {}
    for _, folder in ipairs(folders) do
        pcall(function()
            if isfolder and not isfolder(folder) then makefolder(folder) end
        end)
        local okW = pcall(function()
            writefile(folder .. "/A2Fusion_Loader.lua", loaderCode)
        end)
        if okW then table.insert(written, folder .. "/A2Fusion_Loader.lua") end
    end
    if #written == 0 then return false, "Gagal menulis loader ke semua folder autoexecute" end
    return true, table.concat(written, "\n")
end
A2UI.AutoExecDir = "A2Fusion/AutoExec"
function A2UI:IsAutoExecEnabled()
    if type(readfile) ~= "function" then return true end
    local ok, v = pcall(readfile, "A2Fusion/autoexec_enabled.txt")
    if not ok or type(v) ~= "string" then return true end
    return not v:match("^%s*0")
end
function A2UI:SetAutoExecEnabled(on)
    ensureDir("A2Fusion")
    if type(writefile) == "function" then
        pcall(writefile, "A2Fusion/autoexec_enabled.txt", on and "1" or "0")
    end
end
function A2UI:RunAutoExecFolder()
    local dir = self.AutoExecDir
    ensureDir(dir)
    if type(listfiles) ~= "function" or type(readfile) ~= "function" then
        return false, "Executor tidak support listfiles/readfile"
    end
    local ok, files = pcall(listfiles, dir)
    if not ok or type(files) ~= "table" then return false, "Folder " .. dir .. " tidak bisa dibaca" end
    table.sort(files)
    local ran, failed = 0, {}
    local compile = loadstring or load
    for _, path in ipairs(files) do
        local p = tostring(path):gsub("\\", "/")
        local fname = p:match("([^/]+)$") or p
        if fname:lower():match("%.lua$") or fname:lower():match("%.txt$") or fname:lower():match("%.luau$") then
            local okR, src = pcall(readfile, path)
            if okR and type(src) == "string" then
                src = src:gsub("^\239\187\191", "")
                local trimmed = src:match("^%s*(.-)%s*$")
                if trimmed:match("^https?://%S+$") then
                    local okH, body = pcall(function() return game:HttpGet(trimmed) end)
                    src = okH and body or nil
                end
                if src and trimmed ~= "" then
                    local fn, cerr = compile(src, "=" .. fname)
                    if fn then
                        ran = ran + 1
                        task.spawn(function()
                            local okX, xerr = pcall(fn)
                            if not okX then warn("[A2 AutoExec] " .. fname .. ": " .. tostring(xerr)) end
                        end)
                    else
                        table.insert(failed, fname)
                        warn("[A2 AutoExec] compile " .. fname .. ": " .. tostring(cerr))
                    end
                else
                    table.insert(failed, fname)
                end
            end
        end
    end
    local msg = ran .. " file dijalankan dari " .. dir
    if #failed > 0 then msg = msg .. " â¢ gagal: " .. table.concat(failed, ", ") end
    return true, msg, ran
end
local function mk(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then o[k] = v end
    end
    if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
        o.TextStrokeColor3 = (props and props.TextStrokeColor3) or C.glow
        if not props or props.TextStrokeTransparency == nil then
            o.TextStrokeTransparency = o.TextSize >= 14 and 0.72 or 0.84
        end
    end
    if props and props.Parent then o.Parent = props.Parent end
    return o
end
local function corner(parent, r) return mk("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = parent }) end
local function stroke(parent, color, thick, trans, grad)
    local s = mk("UIStroke", {
        Color = color or C.stroke, Thickness = thick or 1,
        Transparency = trans or 0.5, Parent = parent,
    })
    if grad then
        mk("UIGradient", { Color = GRADIENT_HOT, Rotation = 45, Parent = s })
    end
    return s
end
local function pad(parent, t, r, b, l)
    return mk("UIPadding", {
        PaddingTop = UDim.new(0, t or 0), PaddingRight = UDim.new(0, r or 0),
        PaddingBottom = UDim.new(0, b or 0), PaddingLeft = UDim.new(0, l or 0), Parent = parent,
    })
end
local function textGlow(label, color, strength)
    if not label then return end
    label.TextStrokeColor3 = color or C.primary
    label.TextStrokeTransparency = math.clamp(strength or 0.7, 0, 1)
end
local effectLabels = setmetatable({}, { __mode = "k" })
local effectConnection
local function TextGradient(label, colors)
    if not label then return end
    local gradient = label:FindFirstChildOfClass("UIGradient")
    if not gradient then gradient = mk("UIGradient", { Parent = label }) end
    gradient.Name = "TextGradient"
    gradient.Color = colors or GRADIENT_TITLE
    gradient.Rotation = 18
    return gradient
end
local function ShimmerSweep(label, color)
    if not label then return end
    local gradient = TextGradient(label)
    effectLabels[label] = { Gradient = gradient, Base = color or C.text }
    if not effectConnection then
        effectConnection = RunService.RenderStepped:Connect(function()
            local alive = false
            local phase = (os.clock() % 3.4) / 3.4
            local center = -.16 + phase * 1.32
            for text, effect in pairs(effectLabels) do
                if not text.Parent then effectLabels[text] = nil
                else
                    alive = true
                    local visible, node = true, text
                    while node do
                        if node:IsA("GuiObject") and not node.Visible then visible = false; break end
                        if node:IsA("ScreenGui") and not node.Enabled then visible = false; break end
                        node = node.Parent
                    end
                    local g = effect.Gradient
                    if visible and g.Parent then
                        local base = effect.Base
                        local colored = text:GetAttribute("A2TextGradient") ~= false
                        local sweep = text:GetAttribute("A2ShimmerSweep") ~= false
                        local keys = {}
                        for i = 0, 16 do
                            local t = i / 16
                            local col = colored and base:Lerp(C.secondary, t * .35) or base
                            local light = sweep and math.max(0, 1 - math.abs(t - center) / .12) or 0
                            keys[#keys + 1] = ColorSequenceKeypoint.new(t, col:Lerp(C.white, light))
                        end
                        g.Color = ColorSequence.new(keys)
                    end
                end
            end
            if not alive and effectConnection then effectConnection:Disconnect(); effectConnection = nil end
        end)
    end
    return gradient
end
A2UI.TextGradient = TextGradient
A2UI.ShimmerSweep = ShimmerSweep
local shineText = ShimmerSweep
local ICON_ASSETS = {
    home = { 16898613509, Vector2.new(48, 48), Vector2.new(820, 147) },
    settings = { 16898613777, Vector2.new(48, 48), Vector2.new(771, 257) },
    link = { 16898613509, Vector2.new(48, 48), Vector2.new(918, 453) },
    rocket = { 16898613699, Vector2.new(48, 48), Vector2.new(918, 147) },
    package = { 16898613613, Vector2.new(48, 48), Vector2.new(918, 196) },
    send = { 16898613699, Vector2.new(48, 48), Vector2.new(967, 857) },
    check = { 16898612819, Vector2.new(48, 48), Vector2.new(710, 869) },
    save = { 16898613699, Vector2.new(48, 48), Vector2.new(918, 453) },
    pin = { 16898613699, Vector2.new(48, 48), Vector2.new(918, 0) },
    download = { 16898613044, Vector2.new(48, 48), Vector2.new(820, 906) },
    trash = { 16898613869, Vector2.new(48, 48), Vector2.new(918, 514) },
    refresh = { 16898613699, Vector2.new(48, 48), Vector2.new(404, 869) },
    clipboard = { 16898613044, Vector2.new(48, 48), Vector2.new(49, 869) },
    play = { 16898613699, Vector2.new(48, 48), Vector2.new(918, 257) },
    pause = { 16898613699, Vector2.new(48, 48), Vector2.new(0, 771) },
    info = { 16898613509, Vector2.new(48, 48), Vector2.new(612, 869) },
    hourglass = { 16898613509, Vector2.new(48, 48), Vector2.new(49, 918) },
    star = { 16898613777, Vector2.new(48, 48), Vector2.new(967, 147) },
    bolt = { 16898612819, Vector2.new(48, 48), Vector2.new(306, 820) },
    shield = { 16898613777, Vector2.new(48, 48), Vector2.new(869, 0) },
    user = { 16898613869, Vector2.new(48, 48), Vector2.new(661, 869) },
    farm = { 16898612629, Vector2.new(48, 48), Vector2.new(869, 710) },
    survival = { 16898613509, Vector2.new(48, 48), Vector2.new(661, 771) },
    combat = { 16898613777, Vector2.new(48, 48), Vector2.new(967, 759) },
    player = { 16898613869, Vector2.new(48, 48), Vector2.new(661, 869) },
    power = { 16898613699, Vector2.new(48, 48), Vector2.new(820, 147) },
    key = { 16898613509, Vector2.new(48, 48), Vector2.new(869, 404) },
    mail = { 16898613613, Vector2.new(48, 48), Vector2.new(820, 0) },
    menu = { 16898613613, Vector2.new(48, 48), Vector2.new(49, 820) },
    warning = { 16898612629, Vector2.new(48, 48), Vector2.new(771, 98) },
    target = { 16898613044, Vector2.new(48, 48), Vector2.new(453, 869) },
    coins = { 16898613044, Vector2.new(48, 48), Vector2.new(869, 612) },
    heart = { 16898613509, Vector2.new(48, 48), Vector2.new(661, 771) },
    sword = { 16898613777, Vector2.new(48, 48), Vector2.new(710, 967) },
    close = { 16898613869, Vector2.new(48, 48), Vector2.new(869, 906) },
    minimize = { 16898613613, Vector2.new(48, 48), Vector2.new(771, 196) },
}
A2UI.Icons = ICON_ASSETS
local function assetUri(value)
    if type(value) == "number" and value > 0 and value < math.huge then
        return "rbxassetid://" .. string.format("%.0f", math.floor(value))
    end
    if type(value) ~= "string" then return nil end
    value = value:match("^%s*(.-)%s*$")
    if value:match("^rbxassetid://%d+$") then return value end
    if value:match("^%d+$") then return "rbxassetid://" .. value end
    local id = value:match("^https?://www%.roblox%.com/asset/%?id=(%d+)")
    if id then return "rbxassetid://" .. id end
    return nil
end
function A2UI:SetIcon(name, id)
    local uri = assetUri(id)
    if type(name) ~= "string" or not uri then return false, "Nama / asset ID ikon tidak valid" end
    ICON_ASSETS[name:lower()] = { uri }
    return true
end
local function makeIcon(parent, value, props)
    props = props or {}
    if value == "discord" then
        local mark = mk("Frame", { Name = "DiscordLogo", Size = props.Size or UDim2.fromOffset(22, 22),
            Position = props.Position or UDim2.new(), BackgroundTransparency = 1, Parent = parent })
        local body = mk("Frame", { Size = UDim2.fromScale(.94, .68), Position = UDim2.fromScale(.03, .2),
            BackgroundColor3 = props.Color or C.primary, BorderSizePixel = 0, Parent = mark })
        corner(body, 7)
        for _, x in ipairs({.3, .68}) do
            local eye = mk("Frame", { Size = UDim2.fromScale(.16, .25), Position = UDim2.fromScale(x - .08, .37),
                BackgroundColor3 = C.bgPanel, BorderSizePixel = 0, Parent = body })
            corner(eye, 9)
        end
        return mark, false
    end
    local named = type(value) == "string" and ICON_ASSETS[value:lower()] or nil
    local uri = assetUri(value)
    if not uri then
        if not named then
            if value ~= nil then warn("[A2 UI] Ikon tidak dikenal: " .. tostring(value) .. "; memakai info") end
            named = ICON_ASSETS.info
        end
        uri = assetUri(named[1])
    end
    local image = mk("ImageLabel", {
        Size = props.Size or UDim2.new(0, 22, 0, 22),
        Position = props.Position or UDim2.new(0, 0, 0, 0),
        AnchorPoint = props.AnchorPoint,
        BackgroundTransparency = 1, Image = uri,
        ImageColor3 = props.Color or C.dim,
        ImageTransparency = props.Transparency or 0,
        ImageRectSize = named and named[2] or Vector2.new(0, 0),
        ImageRectOffset = named and named[3] or Vector2.new(0, 0),
        ScaleType = Enum.ScaleType.Fit, Parent = parent,
    })
    return image, true
end
local function overlayGui(parent)
    local gui = parent:FindFirstChild("A2Overlays")
    if not gui or not gui:IsA("ScreenGui") then
        if gui then gui:Destroy() end
        gui = mk("ScreenGui", {
            Name = "A2Overlays", ResetOnSpawn = false, IgnoreGuiInset = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 10000,
            Parent = parent,
        })
    end
    return gui
end
local function vlist(parent, gap, align)
    return mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, gap or 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = align or Enum.HorizontalAlignment.Left, Parent = parent,
    })
end
local function hlist(parent, gap, valign)
    return mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, gap or 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = valign or Enum.VerticalAlignment.Center, Parent = parent,
    })
end
local activeDrag = nil
UserInputService.InputChanged:Connect(function(input)
    if activeDrag and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - activeDrag.start
        activeDrag.frame.Position = UDim2.new(
            activeDrag.pos.X.Scale, activeDrag.pos.X.Offset + d.X,
            activeDrag.pos.Y.Scale, activeDrag.pos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        activeDrag = nil
    end
end)
local function draggable(frame, handle)
    handle = handle or frame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            activeDrag = { frame = frame, start = input.Position, pos = frame.Position }
        end
    end)
end
function A2UI:Confirm(opts)
    opts = opts or {}
    local parent = guiParent()
    if not parent then return end
    parent = overlayGui(parent)
    local old = parent:FindFirstChild("A2Confirm")
    if old then old:Destroy() end
    local overlay = mk("Frame", {
        Name = "A2Confirm", Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(5, 6, 10), BackgroundTransparency = 0.45,
        BorderSizePixel = 0, ZIndex = 9000, Parent = parent,
    })
    TweenService:Create(overlay, TweenInfo.new(0.18), { BackgroundTransparency = 0.35 }):Play()
    local dismiss = mk("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Text = "", ZIndex = 9000, Parent = overlay,
    })
    local card = mk("Frame", {
        Size = UDim2.new(0, 330, 0, 160), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 26), BackgroundColor3 = C.bgPanel,
        BorderSizePixel = 0, ZIndex = 9001, Parent = overlay,
    })
    corner(card, 14)
    stroke(card, C.glow, 1.5, 0.3)
    mk("UIGradient", { Color = GRADIENT_PANEL, Rotation = 135, Parent = card })
    local iconLbl = mk("TextLabel", {
        Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(0, 16, 0, 14),
        BackgroundColor3 = C.bgRow, BorderSizePixel = 0, Text = "",
        Font = Enum.Font.GothamBlack, TextSize = 18, TextColor3 = C.warn, Parent = card,
    })
    makeIcon(iconLbl, "warning", { Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 6, 0, 6), Color = C.warn })
    corner(iconLbl, 10)
    stroke(iconLbl, C.warn, 1, 0.4)
    local title = mk("TextLabel", {
        Size = UDim2.new(1, -70, 0, 20), Position = UDim2.new(0, 60, 0, 19),
        BackgroundTransparency = 1, Text = opts.Title or "Konfirmasi",
        Font = Enum.Font.GothamBlack, TextSize = 15, TextColor3 = C.white,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = card,
    })
    mk("UIGradient", { Color = GRADIENT_TITLE, Rotation = 90, Parent = title })
    textGlow(title, C.primary, 0.7)
    mk("TextLabel", {
        Size = UDim2.new(1, -32, 0, 46), Position = UDim2.new(0, 16, 0, 56),
        BackgroundTransparency = 1, Text = opts.Content or "",
        Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.dim,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true, Parent = card,
    })
    local closed = false
    local finish
    local function mkBtn(x, w, text, col, result)
        local b = mk("TextButton", {
            Size = UDim2.new(0, w, 0, 34), Position = UDim2.new(1, x, 1, -46),
            BackgroundColor3 = col, BackgroundTransparency = 0.82, BorderSizePixel = 0,
            Text = text, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.white,
            AutoButtonColor = false, ZIndex = 9002, Parent = card,
        })
        corner(b, 9)
        stroke(b, col, 1, 0.35)
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), { BackgroundTransparency = 0.6 }):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), { BackgroundTransparency = 0.82 }):Play()
        end)
        b.MouseButton1Click:Connect(function() finish(result) end)
        return b
    end
    finish = function(result)
        if closed then return end
        closed = true
        TweenService:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 0.5, 14),
        }):Play()
        for _, d in ipairs(card:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                TweenService:Create(d, TweenInfo.new(0.15), { TextTransparency = 1 }):Play()
            elseif d:IsA("Frame") then
                pcall(function()
                    TweenService:Create(d, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
                end)
            end
        end
        TweenService:Create(overlay, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
        task.delay(0.22, function() pcall(function() overlay:Destroy() end) end)
        if opts.Callback then task.spawn(function() opts.Callback(result) end) end
    end
    dismiss.MouseButton1Click:Connect(function() finish(false) end)
    mkBtn(-146, 130, opts.YesText or "Ya, Tutup", C.bad, true)
    mkBtn(-246, 90, opts.NoText or "Batal", Color3.fromRGB(52, 58, 78), false)
    TweenService:Create(card, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }):Play()
end
local function PlayIntro(parent, done)
    local intro = mk("ScreenGui", {
        Name = "A2Intro", IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100000,
        Parent = parent,
    })
    local bg = mk("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = C.bgDeep,
        BorderSizePixel = 0, Parent = intro,
    })
    mk("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.bgDeep),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(14, 15, 26)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 20, 48)),
        }),
        Rotation = 125, Parent = bg,
    })
    for i, pos in ipairs({
        UDim2.new(0.18, 0, 0.25, 0), UDim2.new(0.82, 0, 0.75, 0), UDim2.new(0.5, 0, 0.95, 0),
    }) do
        local orb = mk("Frame", {
            Size = UDim2.new(0, 340, 0, 340), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = pos, BackgroundColor3 = (i == 2) and C.secondary or C.primary,
            BackgroundTransparency = 0.86, BorderSizePixel = 0, Parent = bg,
        })
        corner(orb, 999)
        local t = TweenService:Create(orb, TweenInfo.new(6 + i, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = pos + UDim2.new(0, (i % 2 == 0) and 60 or -60, 0, (i % 2 == 0) and -40 or 40),
        })
        t.Completed:Connect(function() end)
        t:Play()
    end
    local center = mk("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Parent = intro,
    })
    local cl = mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 14),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center, Parent = center,
    })
    local badge = mk("Frame", {
        Size = UDim2.new(0, 92, 0, 92), BackgroundColor3 = C.bgPanel,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        LayoutOrder = 1, Parent = center,
    })
    corner(badge, 26)
    stroke(badge, C.glow, 2, 0.1, true)
    local badgeText = mk("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "A2",
        Font = Enum.Font.GothamBlack, TextSize = 44, TextColor3 = C.white, Parent = badge,
    })
    textGlow(badgeText, C.primary, 0.35)
    mk("UIGradient", { Color = GRADIENT_TITLE, Rotation = 90, Parent = badgeText })
    local holoRing = mk("Frame", {
        AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5),
        Size = UDim2.fromOffset(126, 126), BackgroundTransparency = 1, Rotation = 35,
        ZIndex = 0, Parent = badge,
    })
    corner(holoRing, 999); stroke(holoRing, C.secondary, 2, .2)
    local holoRing2 = mk("Frame", {
        AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5),
        Size = UDim2.fromOffset(148, 88), BackgroundTransparency = 1, Rotation = -25,
        ZIndex = 0, Parent = badge,
    })
    corner(holoRing2, 999); stroke(holoRing2, C.white, 1, .45)
    task.spawn(function()
        while badge.Parent do
            TweenService:Create(holoRing, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = holoRing.Rotation + 360}):Play()
            TweenService:Create(holoRing2, TweenInfo.new(4, Enum.EasingStyle.Linear), {Rotation = holoRing2.Rotation - 360}):Play()
            task.wait(3)
        end
    end)
    badge.Size = UDim2.new(0, 0, 0, 0)
    local title = mk("TextLabel", {
        Size = UDim2.new(0, 500, 0, 40), BackgroundTransparency = 1, Text = "A2 FUSION",
        Font = Enum.Font.GothamBlack, TextSize = 38, TextColor3 = C.white,
        TextStrokeTransparency = 0.6, LayoutOrder = 2, Parent = center,
    })
    mk("UIGradient", { Color = GRADIENT_TITLE, Rotation = 90, Parent = title })
    textGlow(title, C.primary, 0.55)
    title.TextTransparency = 1
    shineText(title, C.white)
    local sub = mk("TextLabel", {
        Size = UDim2.new(0, 600, 0, 16), BackgroundTransparency = 1,
        Text = "EXECUTOR: " .. string.upper(A2_ENV.Executor) .. "   â¢   PLACE: " .. string.upper(A2_ENV.Place),
        Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.dim,
        LayoutOrder = 3, Parent = center,
    })
    sub.TextTransparency = 1
    local sub2 = mk("TextLabel", {
        Size = UDim2.new(0, 600, 0, 14), BackgroundTransparency = 1,
        Text = "USER: " .. A2_ENV.User .. "   â¢   PLACE ID: " .. tostring(A2_ENV.PlaceId),
        Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.dim,
        TextTransparency = 1, LayoutOrder = 4, Parent = center,
    })
    local barHolder = mk("Frame", {
        Size = UDim2.new(0, 260, 0, 6), BackgroundColor3 = C.bgRow,
        BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 5, Parent = center,
    })
    corner(barHolder, 3)
    stroke(barHolder, C.stroke, 1, 0.5)
    local barFill = mk("Frame", {
        Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.primary,
        BorderSizePixel = 0, Parent = barHolder,
    })
    corner(barFill, 3)
    mk("UIGradient", { Color = GRADIENT_HOT, Rotation = 0, Parent = barFill })
    local status = mk("TextLabel", {
        Size = UDim2.new(0, 400, 0, 13), BackgroundTransparency = 1,
        Text = "INITIALIZING...", Font = Enum.Font.GothamMedium, TextSize = 10,
        TextColor3 = C.primary, TextTransparency = 1, LayoutOrder = 6, Parent = center,
    })
    textGlow(status, C.primary, 0.6)
    local STEPS = { "LOADING ENVIRONMENT...", "INJECTING UI ENGINE...", "BUILDING INTERFACE...", "READY" }
    local function seq()
        TweenService:Create(badge, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 92, 0, 92), BackgroundTransparency = 0,
        }):Play()
        task.wait(0.35)
        TweenService:Create(title, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
        task.wait(0.2)
        TweenService:Create(sub, TweenInfo.new(0.45), { TextTransparency = 0 }):Play()
        TweenService:Create(sub2, TweenInfo.new(0.45), { TextTransparency = 0 }):Play()
        TweenService:Create(barHolder, TweenInfo.new(0.3), { BackgroundTransparency = 0 }):Play()
        TweenService:Create(status, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
        for i, step in ipairs(STEPS) do
            status.Text = step
            local a = i / #STEPS
            TweenService:Create(barFill, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
                Size = UDim2.new(a, 0, 1, 0),
            }):Play()
            task.wait(0.45)
        end
        TweenService:Create(badge, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
        TweenService:Create(badge, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, 110, 0, 110),
        }):Play()
        task.wait(0.35)
        local fade = TweenService:Create(bg, TweenInfo.new(0.5), { BackgroundTransparency = 1 })
        fade:Play()
        for _, d in ipairs(intro:GetDescendants()) do
            if d:IsA("TextLabel") then
                TweenService:Create(d, TweenInfo.new(0.45), { TextTransparency = 1 }):Play()
            elseif d:IsA("Frame") or d:IsA("ImageLabel") then
                pcall(function()
                    TweenService:Create(d, TweenInfo.new(0.45), { BackgroundTransparency = 1 }):Play()
                end)
            end
        end
        task.wait(0.55)
        pcall(function() intro:Destroy() end)
        if done then task.spawn(done) end
    end
    task.spawn(seq)
end
local notifHolder
function A2UI:Notify(opts)
    opts = opts or {}
    local parent = guiParent()
    if not parent then return end
    parent = overlayGui(parent)
    if not notifHolder or not notifHolder.Parent then
        notifHolder = mk("Frame", {
            Name = "A2Notifs", Size = UDim2.new(0, 310, 1, -20),
            Position = UDim2.new(1, -322, 0, 10), BackgroundTransparency = 1,
            ZIndex = 5000, Parent = parent,
        })
        vlist(notifHolder, 8, Enum.HorizontalAlignment.Right)
    end
    local accentColor = (opts.Color and C[opts.Color:lower()]) or C.primary
    local card = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = C.bgRow, BorderSizePixel = 0,
        LayoutOrder = -os.clock(), ZIndex = 5001, Parent = notifHolder,
    })
    corner(card, 10)
    stroke(card, C.glow, 1, 0.4)
    local bar = mk("Frame", {
        Size = UDim2.new(0, 3, 1, -14), Position = UDim2.new(0, 0, 0, 7),
        BackgroundColor3 = accentColor, BorderSizePixel = 0, Parent = card,
    })
    corner(bar, 2)
    local holder = mk("Frame", {
        Size = UDim2.new(1, -18, 0, 0), Position = UDim2.new(0, 12, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = card,
    })
    vlist(holder, 2)
    pad(holder, 10, 8, 10, 0)
    local t = mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
        Text = opts.Title or "A2", Font = Enum.Font.GothamBold, TextSize = 13,
        TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, Parent = holder,
    })
    textGlow(t, accentColor, 0.75)
    if opts.Content then
        mk("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, Text = opts.Content, Font = Enum.Font.Gotham,
            TextSize = 11, TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true, Parent = holder,
        })
    end
    card.Position = UDim2.new(1, 50, 0, 0)
    TweenService:Create(card, TweenInfo.new(0.14, Enum.EasingStyle.Quint), { Position = UDim2.new(0, 0, 0, 0) }):Play()
    task.delay(tonumber(opts.Duration) or 2, function()
        if card and card.Parent then
            local out = TweenService:Create(card, TweenInfo.new(0.14), { BackgroundTransparency = 1 })
            out:Play()
            for _, d in ipairs(card:GetDescendants()) do
                if d:IsA("TextLabel") then
                    TweenService:Create(d, TweenInfo.new(0.14), { TextTransparency = 1 }):Play()
                elseif d:IsA("Frame") then
                    TweenService:Create(d, TweenInfo.new(0.14), { BackgroundTransparency = 1 }):Play()
                end
            end
            task.wait(0.16)
            pcall(function() card:Destroy() end)
        end
    end)
end
-- ===== FAST TOAST (v13.1) =====
-- Notif super ringan: SATU frame dipakai ulang, tanpa bikin instance baru
-- tiap kali. Dipakai untuk ON/OFF fitur supaya tidak lag.
local toastHolder, toastLabel, toastBar, toastToken = nil, nil, nil, 0
function A2UI:Toast(text, ok, duration)
    if A2UI_NO_TOAST then return end
    local parent = guiParent()
    if not parent then return end
    parent = overlayGui(parent)
    if not toastHolder or not toastHolder.Parent then
        toastHolder = mk("Frame", {
            Name = "A2Toast", Size = UDim2.new(0, 230, 0, 32),
            Position = UDim2.new(0.5, -115, 0, 18), BackgroundColor3 = C.bgRow,
            BackgroundTransparency = 0.05, BorderSizePixel = 0, ZIndex = 6000,
            Parent = parent,
        })
        corner(toastHolder, 8)
        stroke(toastHolder, C.glow, 1, 0.45)
        toastBar = mk("Frame", {
            Size = UDim2.new(0, 3, 1, -10), Position = UDim2.new(0, 0, 0, 5),
            BackgroundColor3 = C.primary, BorderSizePixel = 0, Parent = toastHolder,
        })
        corner(toastBar, 2)
        toastLabel = mk("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold,
            TextSize = 12, TextColor3 = C.text,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = toastHolder,
        })
        toastHolder.Visible = false
    end
    toastToken = toastToken + 1
    local myToken = toastToken
    local accent = ok and C.good or C.bad or C.dim
    toastLabel.Text = tostring(text or "")
    toastBar.BackgroundColor3 = accent
    toastHolder.Visible = true
    toastHolder.BackgroundTransparency = 0.05
    toastLabel.TextTransparency = 0
    task.delay(tonumber(duration) or 0.9, function()
        if myToken ~= toastToken then return end
        if toastHolder and toastHolder.Parent then
            toastHolder.Visible = false
        end
    end)
end

function A2UI:CreateA2Watermark(parent, opts)
    opts = opts or {}
    parent = parent or self.Gui
    if not parent then return nil end
    if parent:IsA("PlayerGui") or parent:IsA("CoreGui") then parent = overlayGui(parent) end
    local holder = mk("Frame", {
        Name = "A2Watermark3D", AnchorPoint = opts.AnchorPoint or Vector2.new(1, 0),
        Position = opts.Position or UDim2.new(1, -16, 0, 16),
        Size = opts.Size or UDim2.fromOffset(112, 78), BackgroundTransparency = 1,
        ClipsDescendants = false, ZIndex = opts.ZIndex or 120, Parent = parent,
    })
    local depth = opts.Depth or 5
    local hasTag = opts.Tag ~= ""
    for i = depth, 0, -1 do
        local face = mk("TextLabel", {
            Name = i == 0 and "A2Face" or ("A2Depth" .. i),
            Size = UDim2.new(1, -depth * 2, 1, hasTag and -18 or -depth),
            Position = UDim2.fromOffset(depth + i, i), BackgroundTransparency = 1,
            Text = opts.Text or "A2", Font = Enum.Font.GothamBlack,
            TextSize = opts.TextSize or 46, TextColor3 = i == 0 and C.white or C.secondary,
            TextStrokeColor3 = i == 0 and C.glow or C.bgDeep,
            TextStrokeTransparency = i == 0 and .48 or .92,
            TextTransparency = i == 0 and 0 or .12 + i * .06,
            Rotation = 0, ZIndex = holder.ZIndex + depth - i + 1, Parent = holder,
        })
        if i == 0 then
            mk("UIGradient", {Color = GRADIENT_TITLE, Rotation = 90, Parent = face})
        end
    end
    if hasTag then
        mk("TextLabel", {
            Position = UDim2.new(0, 0, 1, -16), Size = UDim2.new(1, 0, 0, 14),
            BackgroundTransparency = 1, Text = opts.Tag or "A2 FUSION",
            Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C.primary,
            ZIndex = holder.ZIndex + depth + 2, Parent = holder,
        })
    end
    return holder
end
local function mountCharacter(viewport, opts)
    opts = opts or {}
    local wantLive = opts.Live
    if wantLive == nil then wantLive = true end
    local wantSpin = opts.Rotate
    if wantSpin == nil then wantSpin = not wantLive end
    local world = mk("WorldModel", {Parent = viewport})
    local camera = mk("Camera", {FieldOfView = 35, Parent = viewport})
    viewport.CurrentCamera = camera
    local message = mk("TextLabel", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = "Memuat karakterâ¦", TextSize = 12, Font = Enum.Font.Gotham,
        TextColor3 = C.dim, ZIndex = 3, Parent = viewport,
    })
    local model, pedestal, spinConnection, syncConnection
    local connections = {}
    local generation, destroyed = 0, false
    local radius, height, bottom, angle = 2, 5, -2.5, math.rad(15)
    local centerOffset = Vector3.new()
    local baseYaw = math.rad(180)
    local partPairs = {}
    local liveCharacter
    local lastPose = {}
    local function isVisible()
        local node = viewport
        while node do
            if node:IsA("GuiObject") and not node.Visible then return false end
            if node:IsA("ScreenGui") and not node.Enabled then return false end
            node = node.Parent
        end
        return true
    end
    local function frameCamera()
        if not model or destroyed then return end
        local size = viewport.AbsoluteSize
        if size.X < 1 or size.Y < 1 then return end
        local halfVertical = math.rad(camera.FieldOfView * .5)
        local halfHorizontal = math.atan(math.tan(halfVertical) * size.X / size.Y)
        local distance = math.max((height * .5 + .35) / math.tan(halfVertical),
            radius / math.tan(halfHorizontal)) * 1.12 + radius
        local target = Vector3.new(0, -.12, 0)
        camera.CFrame = CFrame.lookAt(target + Vector3.new(0, distance * .06, distance), target)
    end
    table.insert(connections, viewport:GetPropertyChangedSignal("AbsoluteSize"):Connect(frameCamera))
    local function resolveLiveCharacter()
        local userId = tonumber(opts.UserId)
        if userId and LocalPlayer and userId ~= LocalPlayer.UserId then
            local player = Players:GetPlayerByUserId(userId)
            return player and player.Character or nil
        end
        return LocalPlayer and LocalPlayer.Character or nil
    end
    local function relPath(part, root)
        local names, node = {}, part
        while node and node ~= root do
            table.insert(names, 1, node.Name)
            node = node.Parent
        end
        return table.concat(names, "/")
    end
    local function cleanClone(clone)
        for _, object in ipairs(clone:GetDescendants()) do
            if object:IsA("Script") or object:IsA("LocalScript") or object:IsA("ModuleScript")
                or object:IsA("Animator") then
                object:Destroy()
            elseif object:IsA("Humanoid") then
                pcall(function()
                    object.EvaluateStateMachine = false
                    object.PlatformStand = true
                    object.RequiresNeck = false
                    object.BreakJointsOnDeath = false
                    object.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                end)
            elseif object:IsA("BasePart") then
                object.Anchored = true
                object.CanCollide = false
                object.CastShadow = false
                if object.Name == "HumanoidRootPart" then object.Transparency = 1 end
            end
        end
    end
    local function buildPartPairs(live)
        partPairs = {}
        if not live then return end
        local cloneMap = {}
        for _, object in ipairs(model:GetDescendants()) do
            if object:IsA("BasePart") then cloneMap[relPath(object, model)] = object end
        end
        for _, object in ipairs(live:GetDescendants()) do
            if object:IsA("BasePart") then
                local clonePart = cloneMap[relPath(object, live)]
                if clonePart then table.insert(partPairs, {clone = clonePart, live = object}) end
            end
        end
    end
    local function buildPedestal()
        if pedestal then pedestal:Destroy() end
        pedestal = mk("Part", {
            Name = "AvatarPedestal", Anchored = true, CanCollide = false,
            Shape = Enum.PartType.Cylinder, Size = Vector3.new(.12, radius * 2, radius * 2),
            CFrame = CFrame.new(0, bottom - .1, 0) * CFrame.Angles(0, 0, math.pi * .5),
            Material = Enum.Material.SmoothPlastic, Color = C.secondary,
            Transparency = .35, Parent = world,
        })
    end
    local function syncPose()
        if destroyed or not model or not model.Parent then return end
        local root = liveCharacter and liveCharacter.Parent
            and liveCharacter:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local base = CFrame.Angles(0, baseYaw + angle, 0) * CFrame.new(centerOffset)
        local inv = root.CFrame:Inverse()
        for _, pair in ipairs(partPairs) do
            local lp, cp = pair.live, pair.clone
            if lp and lp.Parent and cp and cp.Parent then
                local cf = base * (inv * lp.CFrame)
                cp.CFrame = cf
                lastPose[pair] = cf
            end
        end
    end
    local function freezePose()
        for pair, cf in pairs(lastPose) do
            local cp = pair.clone
            if cp and cp.Parent then cp.CFrame = cf end
        end
    end
    local function startLiveLoop()
        if syncConnection then syncConnection:Disconnect() end
        local tick = 0
        syncConnection = RunService.RenderStepped:Connect(function(dt)
            if destroyed or not model or not model.Parent or not isVisible() then return end
            if wantSpin then
                angle = (angle + math.rad(tonumber(opts.RotationSpeed) or 12) * math.min(dt, .1)) % (2 * math.pi)
            end
            if liveCharacter and liveCharacter.Parent
                and liveCharacter:FindFirstChild("HumanoidRootPart") then
                tick = tick + 1
                if tick % 90 == 0 then buildPartPairs(liveCharacter) end
                syncPose()
            else
                freezePose()
            end
        end)
    end
    local function loadAvatar()
        generation = generation + 1
        local ticket = generation
        task.spawn(function()
            local userId = tonumber(opts.UserId) or (LocalPlayer and LocalPlayer.UserId)
            local live = resolveLiveCharacter()
            local useLive = wantLive and live ~= nil
            local candidate
            if useLive then
                local wasArchivable = live.Archivable
                local ok, clone = pcall(function()
                    live.Archivable = true
                    return live:Clone()
                end)
                pcall(function() live.Archivable = wasArchivable end)
                if ok then candidate = clone end
            end
            if not candidate and userId then
                local ok, result = pcall(function()
                    local description = Players:GetHumanoidDescriptionFromUserIdAsync(userId)
                    return Players:CreateHumanoidModelFromDescriptionAsync(description, Enum.HumanoidRigType.R15)
                end)
                if ok then candidate = result end
            end
            if destroyed or ticket ~= generation then
                if candidate then candidate:Destroy() end
                return
            end
            if not candidate then
                message.Text = "Karakter belum tersedia"
                message.Visible = model == nil
                return
            end
            if spinConnection then spinConnection:Disconnect(); spinConnection = nil end
            if syncConnection then syncConnection:Disconnect(); syncConnection = nil end
            if model then model:Destroy() end
            model = candidate
            cleanClone(model)
            local rootPart = model:FindFirstChild("HumanoidRootPart")
            if rootPart then model.PrimaryPart = rootPart end
            model.Parent = world
            model:PivotTo(CFrame.new())
            local okB, bounds, size = pcall(function() return model:GetBoundingBox() end)
            if okB and bounds then
                height = size.Y
                bottom = -height * .5
                radius = math.max(math.sqrt(size.X * size.X + size.Z * size.Z) * .5, 1.8)
                centerOffset = -bounds.Position
            else
                height, bottom, radius = 5, -2.5, 2
                centerOffset = Vector3.new()
            end
            liveCharacter = useLive and live or nil
            buildPartPairs(liveCharacter)
            buildPedestal()
            message.Visible = false
            angle = wantSpin and math.rad(15) or 0
            lastPose = {}
            if useLive then
                syncPose()
                startLiveLoop()
            else
                local neutralPivot = CFrame.new(centerOffset)
                model:PivotTo(CFrame.Angles(0, angle, 0) * neutralPivot)
                spinConnection = RunService.RenderStepped:Connect(function(dt)
                    if destroyed or not model or not model.Parent or not isVisible() then return end
                    if wantSpin then
                        angle = (angle + math.rad(tonumber(opts.RotationSpeed) or 18) * math.min(dt, .1)) % (2 * math.pi)
                        model:PivotTo(CFrame.Angles(0, angle, 0) * neutralPivot)
                    end
                end)
            end
            frameCamera()
        end)
    end
    if LocalPlayer and (opts.UserId == nil or tonumber(opts.UserId) == LocalPlayer.UserId) then
        table.insert(connections, LocalPlayer.CharacterAppearanceLoaded:Connect(loadAvatar))
        table.insert(connections, LocalPlayer.CharacterAdded:Connect(function()
            task.delay(.5, function() if not destroyed then loadAvatar() end end)
        end))
    end
    viewport.Destroying:Connect(function()
        destroyed = true; generation = generation + 1
        if spinConnection then spinConnection:Disconnect() end
        if syncConnection then syncConnection:Disconnect() end
        for _, connection in ipairs(connections) do connection:Disconnect() end
    end)
    loadAvatar()
    return viewport
end
function A2UI:AddCharacterPreview(section, opts)
    opts = opts or {}
    local isSection = type(section) == "table" and section._inner ~= nil
    local parent = isSection and section._inner or section
    if not parent then return nil end
    if isSection then section._count = (section._count or 0) + 1 end
    local card = mk("Frame", {
        Name = "A2CharacterPreview", Size = UDim2.new(1, 0, 0, opts.Height or 260),
        BackgroundColor3 = C.bgRow, BorderSizePixel = 0,
        LayoutOrder = isSection and section._count or 1, Parent = parent,
    })
    corner(card, 12); stroke(card, C.secondary, 1, .45)
    local title = mk("TextLabel", {
        Size = UDim2.new(1, -24, 0, 22), Position = UDim2.fromOffset(12, 8),
        BackgroundTransparency = 1, Text = opts.Title or "3D CHARACTER",
        Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.white,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = card,
    })
    textGlow(title, C.glow, .62)
    local viewport = mk("ViewportFrame", {
        Name = "AvatarViewport", Size = UDim2.new(1, -24, 1, -48),
        Position = UDim2.fromOffset(12, 36), BackgroundColor3 = C.bgDeep,
        BorderSizePixel = 0, Ambient = C.primary, LightColor = C.white,
        LightDirection = Vector3.new(-1, -1, -2), Parent = card,
    })
    corner(viewport, 10)
    mountCharacter(viewport, opts)
    return card
end
function A2UI:AddSidePreview(opts)
    opts = opts or {}
    if not self.Gui or not self.Main then return nil end
    local gui, main = self.Gui, self.Main
    local width = opts.Width or 190
    local height = opts.Height or 320
    local gap = opts.Gap or 10
    local offsetY = opts.OffsetY or 34
    local holder = mk("Frame", {
        Name = "A2SidePreview", Size = UDim2.fromOffset(width, height),
        BackgroundColor3 = C.bgPanel, BackgroundTransparency = .2,
        BorderSizePixel = 0, ClipsDescendants = true, Visible = false, ZIndex = 60,
        Parent = gui,
    })
    corner(holder, 14)
    local edge = stroke(holder, C.glow, 1.4, .4)
    mk("UIGradient", { Color = GRADIENT_PANEL, Rotation = 135, Parent = holder })
    local title = mk("TextLabel", {
        Size = UDim2.new(1, -18, 0, 20), Position = UDim2.fromOffset(9, 6),
        BackgroundTransparency = 1, Text = opts.Title or "A2 â¢ LIVE",
        Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.white,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 3, Parent = holder,
    })
    textGlow(title, C.glow, .5)
    shineText(title, C.primary)
    local viewport = mk("ViewportFrame", {
        Name = "AvatarViewport", Size = UDim2.new(1, -16, 1, -48),
        Position = UDim2.fromOffset(8, 32), BackgroundColor3 = C.bgDeep,
        BorderSizePixel = 0, Ambient = C.primary, LightColor = C.white,
        LightDirection = Vector3.new(-1, -1, -2), Parent = holder,
    })
    corner(viewport, 10)
    mountCharacter(viewport, opts)
    local breathe = TweenService:Create(edge,
        TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        { Transparency = .12, Thickness = 2.2 })
    breathe:Play()
    local function follow()
        if not main.Parent then return end
        local screen = gui.AbsoluteSize
        local pos, size = main.AbsolutePosition, main.AbsoluteSize
        if screen.X < 1 or size.X < 1 then return end
        local s = self._fitScale or 1
        local w, h = width * s, height * s
        holder.Size = UDim2.fromOffset(w, h)
        local x = pos.X + size.X + gap * s
        if x + w > screen.X - 6 then x = pos.X - gap * s - w end
        if x < 6 then x = math.max(6, math.min(screen.X - w - 6, pos.X + size.X + gap * s)) end
        local y = pos.Y + (size.Y - h) * .5 + (self._sideOffsetY or offsetY) * s
        holder.Position = UDim2.fromOffset(x, math.clamp(y, 6, math.max(6, screen.Y - h - 6)))
    end
    local function sync()
        holder.Visible = main.Visible and gui.Enabled
    end
    self._sidePreview = holder
    self._sideFollow = follow
    self._sideSync = sync
    local conns = {}
    local function watch(signal)
        table.insert(conns, signal:Connect(function() follow() sync() end))
    end
    watch(main:GetPropertyChangedSignal("AbsolutePosition"))
    watch(main:GetPropertyChangedSignal("AbsoluteSize"))
    watch(main:GetPropertyChangedSignal("Visible"))
    watch(gui:GetPropertyChangedSignal("AbsoluteSize"))
    watch(gui:GetPropertyChangedSignal("Enabled"))
    gui.Destroying:Connect(function()
        breathe:Cancel()
        for _, c in ipairs(conns) do c:Disconnect() end
    end)
    follow()
    sync()
    return holder
end
function A2UI:CreateWindow(opts)
    opts = opts or {}
    local self = setmetatable({}, A2UI)
    self.Tabs = {}
    self._tabCount = 0
    self._visible = true
    self._configElements = {}
    self.LoaderURL = A2UI.LoaderURL
    self:LoadUIPreferences()
    local parent = guiParent()
    if not parent then error("[A2 UI] Parent GUI tidak ditemukan") end
    pcall(function()
        local old = parent:FindFirstChild("A2FusionUI")
        if old then old:Destroy() end
        local oldIntro = parent:FindFirstChild("A2Intro")
        if oldIntro then oldIntro:Destroy() end
    end)
    local gui = mk("ScreenGui", {
        Name = "A2FusionUI", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 9999, Enabled = true,
    })
    pcall(function() gui.Parent = parent end)
    if not gui.Parent then
        pcall(function() gui.Parent = LocalPlayer:WaitForChild("PlayerGui", 10) end)
    end
    if not gui.Parent then error("[A2 UI] ScreenGui gagal dipasang") end
    self.Gui = gui
    local main = mk("Frame", {
        Name = "A2Main", Size = UDim2.new(0, 760, 0, 520),
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, -30),
        BackgroundColor3 = C.bgPanel, ClipsDescendants = true, BorderSizePixel = 0,
        Visible = false, Parent = gui,
    })
    corner(main, 16)
    stroke(main, C.glow, 1.5, 0.35)
    mk("UIGradient", { Color = GRADIENT_PANEL, Rotation = 135, Parent = main })
    self.Main = main
    mk("ImageLabel", {
        Name = "Shadow", AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 160, 1, 160), ZIndex = 0,
        Image = "rbxassetid://8992230677", ImageColor3 = C.glow,
        ImageTransparency = 0.75, ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(99, 99, 99, 99), Parent = main,
    })
    main.Position = UDim2.new(0.5, 0, 0.5, 20)
    main.Size = UDim2.new(0, 0, 0, 0)
    main.BackgroundTransparency = 1
    local scale = mk("UIScale", { Parent = main })
    local function fit()
        local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
        local s = 0.94 * math.min(1, (vp.X - 22) / 760, (vp.Y - 22) / 520)
        local mode = self.UIPreferences.Device
        local mobileMode = mode == "HP" or (mode == "Auto" and Mobile)
        local requested = mobileMode and .98 or 1
        s = math.max(.1, s * requested * self.UIPreferences.Scale)
        self._fitScale = s
        scale.Scale = s
    end
    self._fitUI = fit
    fit()
    self._cameraConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        if self._fitConnection then self._fitConnection:Disconnect() end
        local camera = workspace.CurrentCamera
        if camera then self._fitConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(fit) end
        fit()
    end)
    pcall(function()
        self._fitConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
    end)
    self.Watermark = self:CreateA2Watermark(main, {
        Position = UDim2.new(1, -250, 0, 5), Size = UDim2.fromOffset(72, 36),
        TextSize = 26, Depth = 3, Tag = "", ZIndex = 140,
    })
    local top = mk("Frame", {
        Name = "Top", Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = C.bgDeep,
        BackgroundTransparency = 0.35, BorderSizePixel = 0, Parent = main,
    })
    corner(top, 16)
    mk("Frame", { Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 1, -16),
        BackgroundColor3 = C.bgDeep, BackgroundTransparency = 0.35, BorderSizePixel = 0, Parent = top })
    draggable(main, top)
    local divider = mk("Frame", {
        Size = UDim2.new(1, -28, 0, 1), Position = UDim2.new(0, 14, 1, -1),
        BackgroundColor3 = C.primary, BorderSizePixel = 0, Parent = top,
    })
    mk("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = divider,
    })
    local logo = mk("Frame", {
        Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0, 14, 0.5, -16),
        BackgroundColor3 = C.bgRow, BorderSizePixel = 0, Parent = top,
    })
    corner(logo, 10)
    stroke(logo, C.primary, 1.5, 0.2, true)
    local logoText = mk("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "A2",
        Font = Enum.Font.GothamBlack, TextSize = 16, TextColor3 = C.white, Parent = logo,
    })
    mk("UIGradient", { Color = GRADIENT_TITLE, Rotation = 90, Parent = logoText })
    textGlow(logoText, C.primary, 0.5)
    local titleText = mk("TextLabel", {
        Size = UDim2.new(0, 300, 0, 20), Position = UDim2.new(0, 56, 0, 8),
        BackgroundTransparency = 1, Text = opts.Title or "A2 FUSION",
        Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = C.white,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = top,
    })
    mk("UIGradient", { Color = GRADIENT_TITLE, Rotation = 90, Parent = titleText })
    textGlow(titleText, C.primary, 0.75)
    if opts.Shine ~= false then shineText(titleText, C.white) end
    mk("TextLabel", {
        Size = UDim2.new(0, 300, 0, 14), Position = UDim2.new(0, 56, 0, 27),
        BackgroundTransparency = 1, Text = opts.Author or ("by " .. A2_ENV.User),
        Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.dim,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = top,
    })
    local status = mk("Frame", {
        Size = UDim2.new(0, 0, 0, 22), AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(1, -196, 0.5, -11),
        BackgroundColor3 = C.bgRow, BorderSizePixel = 0, Parent = top,
    })
    corner(status, 7)
    stroke(status, C.stroke, 1, 0.5)
    local dot = mk("Frame", {
        Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(0, 9, 0.5, -3),
        BackgroundColor3 = C.good, BorderSizePixel = 0, Parent = status,
    })
    corner(dot, 3)
    local statusText = mk("TextLabel", {
        Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(0, 21, 0, 0),
        BackgroundTransparency = 1, Text = string.upper(opts.Status or A2_ENV.Executor) .. "  ",
        Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C.good,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = status,
    })
    textGlow(statusText, C.good, 0.6)
    local function winBtn(x, iconName, col, cb)
        local b = mk("TextButton", {
            Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, x, 0.5, -13),
            BackgroundColor3 = C.bgRow, BorderSizePixel = 0, Text = "",
            Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = col or C.dim,
            AutoButtonColor = false, Parent = top,
        })
        makeIcon(b, iconName, { Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 5, 0, 5), Color = col or C.dim })
        corner(b, 8)
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = C.bgHover }):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = C.bgRow }):Play()
        end)
        b.MouseButton1Click:Connect(cb)
        return b
    end
    winBtn(-70, "minimize", C.dim, function() self:Minimize() end)
    winBtn(-38, "close", C.dim, function() self:Close() end)
    local side = mk("Frame", {
        Name = "Side", Size = UDim2.new(0, 156, 1, -48), Position = UDim2.new(0, 0, 0, 48),
        BackgroundColor3 = C.bgDeep, BackgroundTransparency = 0.45, BorderSizePixel = 0, Parent = main,
    })
    mk("Frame", { Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = C.stroke, BackgroundTransparency = 0.5, BorderSizePixel = 0, Parent = side })
    local sideLogo = mk("Frame", {
        Name = "A2SidebarLogo", Size = UDim2.fromOffset(78, 68),
        Position = UDim2.new(.5, 0, 0, 8), AnchorPoint = Vector2.new(.5, 0),
        BackgroundTransparency = 1, Parent = side,
    })
    if opts.Logo then
        mk("ImageLabel", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Image = assetUri(opts.Logo) or opts.Logo, ScaleType = Enum.ScaleType.Fit, Parent = sideLogo,
        })
    else
        self:CreateA2Watermark(sideLogo, {
            AnchorPoint = Vector2.new(0, 0), Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromScale(1, 1), TextSize = 39, Depth = 4, Tag = "A2 FUSION", ZIndex = 2,
        })
    end
    mk("TextLabel", {
        Size = UDim2.new(1, -20, 0, 18), Position = UDim2.new(0, 12, 0, 78),
        BackgroundTransparency = 1, Text = opts.SidebarTitle or "NAVIGATION",
        Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C.dim,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = side,
    })
    local searchFrame = mk("Frame", {
        Name = "MenuSearch", Size = UDim2.new(1, -20, 0, 28), Position = UDim2.new(0, 10, 0, 98),
        BackgroundColor3 = C.bgRow, BackgroundTransparency = .1, BorderSizePixel = 0, Parent = side,
    })
    corner(searchFrame, 7); stroke(searchFrame, C.stroke, 1, .35)
    local searchBox = mk("TextBox", {
        Size = UDim2.new(1, -14, 1, 0), Position = UDim2.fromOffset(7, 0),
        BackgroundTransparency = 1, PlaceholderText = "Search...", PlaceholderColor3 = C.dim,
        Text = "", TextColor3 = C.text, TextSize = 11, Font = Enum.Font.Gotham,
        ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, Parent = searchFrame,
    })
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(searchBox.Text)
        for _, tab in ipairs(self.Tabs) do
            local name = string.lower(tostring(tab._title or ""))
            tab._btn.Visible = query == "" or string.find(name, query, 1, true) ~= nil
        end
    end)
    local sideScroll = mk("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -218), Position = UDim2.new(0, 0, 0, 132),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = C.primary,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = side,
    })
    vlist(sideScroll, 4, Enum.HorizontalAlignment.Center)
    pad(sideScroll, 8, 8, 8, 8)
    self.SideScroll = sideScroll
    self:AddPlayerProfile(side)
    local content = mk("Frame", {
        Name = "Content", Size = UDim2.new(1, -156, 1, -48), Position = UDim2.new(0, 156, 0, 48),
        BackgroundColor3 = C.bgPanel, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = main,
    })
    self.Content = content
    local ob = mk("TextButton", {
        Name = "A2Open", Size = UDim2.fromOffset(46, 46),
        Position = UDim2.new(0, 20, .5, -32), BackgroundColor3 = C.bgPanel,
        BorderSizePixel = 0, Text = "", AutoButtonColor = false,
        ClipsDescendants = false, Visible = false, ZIndex = 200, Parent = gui,
    })
    corner(ob, 10); stroke(ob, C.primary, 1.5, .18, true)
    mk("UIGradient", {Color = GRADIENT_PANEL, Rotation = 135, Parent = ob})
    local bubbleScale = mk("UIScale", {Scale = 1, Parent = ob})
    local halo = mk("Frame", {
        Name = "BubbleHalo", AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(.5, .5), Size = UDim2.new(1, 12, 1, 12),
        BackgroundTransparency = 1, ZIndex = 199, Parent = ob,
    })
    corner(halo, 14)
    local haloStroke = stroke(halo, C.glow, 2, .72)
    local innerRing = mk("Frame", {
        AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5),
        Size = UDim2.new(1, -10, 1, -10), BackgroundTransparency = 1, ZIndex = 201, Parent = ob,
    })
    corner(innerRing, 10); stroke(innerRing, C.secondary, 1, .65)
    local obText = mk("TextLabel", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "A2",
        Font = Enum.Font.GothamBlack, TextSize = 23, TextColor3 = C.white,
        ZIndex = 202, Parent = ob,
    })
    textGlow(obText, C.glow, .45)
    shineText(obText, C.primary)
    local pulse = TweenService:Create(haloStroke,
        TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Transparency = .35, Thickness = 2.8})
    pulse:Play()
    self.OpenBtn, self._bubbleScale = ob, bubbleScale
    self._bubbleConnections = {}
    local function bind(signal, fn)
        table.insert(self._bubbleConnections, signal:Connect(fn))
    end
    local function clampBubble()
        local screen = gui.AbsoluteSize
        if screen.X < 1 or screen.Y < 1 then return end
        local p = ob.AbsolutePosition
        ob.Position = UDim2.fromOffset(math.clamp(p.X, 10, math.max(10, screen.X - 74)),
            math.clamp(p.Y, 10, math.max(10, screen.Y - 74)))
    end
    local pointer, start, original, dragged, suppressUntil = nil, nil, nil, false, 0
    bind(ob.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            pointer, start, original, dragged = input, input.Position, ob.Position, false
        end
    end)
    bind(UserInputService.InputChanged, function(input)
        if not pointer then return end
        local touch = pointer.UserInputType == Enum.UserInputType.Touch
        if (touch and input ~= pointer) or (not touch and input.UserInputType ~= Enum.UserInputType.MouseMovement) then return end
        local delta = input.Position - start
        if delta.Magnitude > 6 then dragged = true; suppressUntil = os.clock() + .3 end
        if dragged then
            ob.Position = UDim2.new(original.X.Scale, original.X.Offset + delta.X,
                original.Y.Scale, original.Y.Offset + delta.Y)
            clampBubble()
        end
    end)
    bind(UserInputService.InputEnded, function(input)
        if input == pointer then
            if dragged then suppressUntil = os.clock() + .3 end
            pointer = nil
            clampBubble()
        end
    end)
    bind(ob.Activated, function()
        if dragged or os.clock() < suppressUntil then return end
        self:Open()
    end)
    bind(gui:GetPropertyChangedSignal("AbsoluteSize"), clampBubble)
    ob.MouseEnter:Connect(function()
        
    end)
    ob.MouseLeave:Connect(function()
        
    end)
    gui.Destroying:Connect(function()
        pulse:Cancel()
        for _, connection in ipairs(self._bubbleConnections) do connection:Disconnect() end
        if self._hotkeyConnection then self._hotkeyConnection:Disconnect() end
        if self._fitConnection then self._fitConnection:Disconnect() end
        if self._cameraConnection then self._cameraConnection:Disconnect() end
        if self._textAddedConnection then self._textAddedConnection:Disconnect() end
        if self._musicConnection then self._musicConnection:Disconnect() end
        if self.Music then self.Music:Destroy() end
    end)
    local function registerText(label)
        if not (label:IsA("TextLabel") or label:IsA("TextButton") or label:IsA("TextBox")) then return end
        if label.Text == "" then return end
        task.defer(function()
            if not label.Parent then return end
            ShimmerSweep(label, label.TextColor3)
            label:SetAttribute("A2TextGradient", self.UIPreferences.TextGradient)
            label:SetAttribute("A2ShimmerSweep", self.UIPreferences.ShimmerSweep)
        end)
    end
    for _, label in ipairs(gui:GetDescendants()) do registerText(label) end
    self._textAddedConnection = gui.DescendantAdded:Connect(registerText)
    self._hotkeyConnection = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.LeftControl then
            if self._visible then self:Close() else self:Open() end
        end
    end)
    self.Minimized = false
    if opts.Visible ~= false then self:ShowWindow() else self:Close() end
    return self
end
function A2UI:_cancelWindowTweens()
    for _, tween in ipairs(self._windowTweens or {}) do tween:Cancel() end
    self._windowTweens = {}
    self._transitionId = (self._transitionId or 0) + 1
    return self._transitionId
end
function A2UI:_windowTween(object, info, goal)
    local tween = TweenService:Create(object, info, goal)
    table.insert(self._windowTweens, tween)
    tween:Play()
end
function A2UI:ShowWindow()
    self:Open()
end
function A2UI:Open()
    if not self.Main or not self.Main.Parent then return end
    if self._visible and self.Main.Visible then return end
    self:_cancelWindowTweens()
    self._visible, self.Minimized = true, false
    local main = self.Main
    local sc = main:FindFirstChildOfClass("UIScale")
    main.Size = UDim2.fromOffset(760, 520)
    main.BackgroundTransparency = 0
    if not self._openPosition then self._openPosition = UDim2.fromScale(.5, .5) end
    main.Position = self._openPosition
    if sc then sc.Scale = (self._fitScale or 1) * .92 end
    main.Visible = true
    if sc then self:_windowTween(sc,
        TweenInfo.new(.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Scale = self._fitScale or 1}) end
    if self.OpenBtn then self.OpenBtn.Visible = false end
end
function A2UI:Close()
    if not self.Main or not self.Main.Parent then return end
    if not self._visible and self.OpenBtn and self.OpenBtn.Visible then return end
    local ticket = self:_cancelWindowTweens()
    self._visible, self.Minimized = false, true
    local main = self.Main
    if self.ProfileDialog then self.ProfileDialog.Visible = false end
    if main.Visible then self._openPosition = main.Position end
    local sc = main:FindFirstChildOfClass("UIScale")
    if sc then self:_windowTween(sc,
        TweenInfo.new(.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {Scale = (self._fitScale or 1) * .86}) end
    task.delay(.22, function()
        if ticket ~= self._transitionId or self._visible or not main.Parent then return end
        main.Visible = false
        if sc then sc.Scale = self._fitScale or 1 end
        if self.OpenBtn and self.OpenBtn.Parent then
            self.OpenBtn.Visible = true
            if self._bubbleScale then
                self._bubbleScale.Scale = .65
                self:_windowTween(self._bubbleScale,
                    TweenInfo.new(.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
            end
        end
    end)
end
function A2UI:Minimize()
    if self._visible then self:Close() else self:Open() end
end
function A2UI:Tag(opts)
    opts = opts or {}
    if opts.Title and self.Main then
        local top = self.Main:FindFirstChild("Top")
        if top then
            local badge = mk("TextLabel", {
                Size = UDim2.new(0, 0, 0, 18), AutomaticSize = Enum.AutomaticSize.X,
                Position = UDim2.new(1, -98, 0.5, -9), BackgroundColor3 = C.bgRow,
                Text = "  " .. tostring(opts.Title) .. "  ", Font = Enum.Font.GothamMedium,
                TextSize = 10, TextColor3 = C.dim, Parent = top,
            })
            corner(badge, 6)
        end
    end
end
local Tab = {}
Tab.__index = Tab
function A2UI:Tab(opts)
    opts = opts or {}
    self._tabCount = self._tabCount + 1
    local idx = self._tabCount
    local tab = setmetatable({}, Tab)
    tab.Window = self
    tab._count = 0
    tab._title = opts.Title or ("Tab " .. tostring(idx))
    local btn = mk("TextButton", {
        Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = C.bgRow,
        BackgroundTransparency = 1, BorderSizePixel = 0, Text = "",
        AutoButtonColor = false, LayoutOrder = idx, Parent = self.SideScroll,
    })
    corner(btn, 10)
    local icon, iconIsImage = makeIcon(btn, opts.Icon or "info", {
        Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 10, 0.5, -11),
        Color = C.dim,
    })
    local hl = mk("Frame", {
        Size = UDim2.new(0, 3, 0, 18), Position = UDim2.new(0, 0, 0.5, -9),
        BackgroundColor3 = C.primary, BorderSizePixel = 0, Visible = false, Parent = btn,
    })
    corner(hl, 2)
    mk("UIGradient", { Color = GRADIENT_HOT, Rotation = 90, Parent = hl })
    local lbl = mk("TextLabel", {
        Size = UDim2.new(1, -42, 1, 0), Position = UDim2.new(0, 36, 0, 0),
        BackgroundTransparency = 1, Text = tab._title,
        Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.dim,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = btn,
    })
    tab._btn, tab._hl, tab._lbl, tab._icon, tab._iconIsImage = btn, hl, lbl, icon, iconIsImage
    local page = mk("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = C.primary,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false, Parent = self.Content,
    })
    vlist(page, 10, Enum.HorizontalAlignment.Left)
    pad(page, 14, 14, 14, 14)
    tab._page = page
    btn.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
    btn.MouseEnter:Connect(function()
        if self._currentTab ~= tab then
            TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0.7 }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if self._currentTab ~= tab then
            TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 1 }):Play()
        end
    end)
    self.Tabs[#self.Tabs + 1] = tab
    if #self.Tabs == 1 then self:SelectTab(tab) end
    return tab
end
function A2UI:SelectTab(tab)
    for _, t in ipairs(self.Tabs) do
        local on = (t == tab)
        t._page.Visible = on
        t._btn.BackgroundTransparency = on and 0 or 1
        t._hl.Visible = on
        t._lbl.TextColor3 = on and C.text or C.dim
        if t._iconIsImage then
            t._icon.ImageColor3 = on and C.secondary or C.dim
        else
            t._icon.TextColor3 = on and C.secondary or C.dim
        end
        if on then
            stroke(t._btn, C.glow, 1, 0.35)
        else
            local s = t._btn:FindFirstChildOfClass("UIStroke")
            if s then s:Destroy() end
        end
    end
    self._currentTab = tab
end
function Tab:Space()
    mk("Frame", { Size = UDim2.new(1, 0, 0, 2), BackgroundTransparency = 1, Parent = self._page })
end
function Tab:FeatureGrid(opts)
    opts = opts or {}
    local gridFrame = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Parent = self._page,
    })
    local grid = mk("UIGridLayout", {
        CellSize = UDim2.new(0.5, -6, 0, opts.CardHeight or 108),
        CellPadding = UDim2.new(0, 12, 0, 12), SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = gridFrame,
    })
    local api = {Frame = gridFrame, Layout = grid}
    function api:Card(cardOpts)
        cardOpts = cardOpts or {}
        local color = typeof(cardOpts.Color) == "Color3" and cardOpts.Color or C[string.lower(tostring(cardOpts.Color or "primary"))] or C.primary
        local card = mk("TextButton", {
            Size = UDim2.new(0, 0, 0, opts.CardHeight or 108), BackgroundColor3 = C.bgRow,
            BackgroundTransparency = 0, BorderSizePixel = 0, Text = "", AutoButtonColor = false,
            LayoutOrder = cardOpts.LayoutOrder or 1, Parent = gridFrame,
        })
        corner(card, 12); stroke(card, color, 1, .35)
        local accent = mk("Frame", {Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = color, BorderSizePixel = 0, Parent = card}); corner(accent, 2)
        makeIcon(card, cardOpts.Icon or "bolt", {Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 14, 0, 14), Color = color})
        local title = mk("TextLabel", {Size = UDim2.new(1, -58, 0, 20), Position = UDim2.new(0, 50, 0, 12), BackgroundTransparency = 1, Text = cardOpts.Title or "Feature", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.white, TextXAlignment = Enum.TextXAlignment.Left, Parent = card})
        local desc = mk("TextLabel", {Size = UDim2.new(1, -64, 0, 33), Position = UDim2.new(0, 50, 0, 35), BackgroundTransparency = 1, Text = cardOpts.Desc or "", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.dim, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = card})
        card.MouseEnter:Connect(function() TweenService:Create(card, TweenInfo.new(.12), {BackgroundColor3 = C.bgHover}):Play() end)
        card.MouseLeave:Connect(function() TweenService:Create(card, TweenInfo.new(.12), {BackgroundColor3 = C.bgRow}):Play() end)
        card.MouseButton1Click:Connect(function() if cardOpts.Callback then cardOpts.Callback() end end)
        return card
    end
    return api
end
local Section = {}
Section.__index = Section
function Tab:Section(opts)
    opts = opts or {}
    local sec = setmetatable({}, Section)
    sec.Tab = self
    sec._count = 0
    local card = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = C.bgRow, BorderSizePixel = 0, Parent = self._page,
    })
    corner(card, 12)
    stroke(card, C.stroke, 1, 0.55)
    local inner = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Parent = card,
    })
    vlist(inner, 8, Enum.HorizontalAlignment.Left)
    pad(inner, 12, 12, 12, 12)
    if opts.Title then
        local h = mk("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = opts.Title,
            Font = Enum.Font.GothamBlack, TextSize = 14, TextColor3 = C.white,
            TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = -1000, Parent = inner,
        })
        mk("UIGradient", { Color = GRADIENT_TITLE, Rotation = 90, Parent = h })
        textGlow(h, C.primary, 0.75)
    end
    sec._inner = inner
    return sec
end
function Section:Space()
    mk("Frame", { Size = UDim2.new(1, 0, 0, 2), BackgroundTransparency = 1,
        LayoutOrder = self._count, Parent = self._inner })
end
function Section:Columns(opts)
    opts = opts or {}
    self._count = self._count + 1
    local gap = tonumber(opts.Gap) or 10
    local row = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, LayoutOrder = self._count, Parent = self._inner,
    })
    hlist(row, gap, Enum.VerticalAlignment.Top)
    local function makeColumn(order)
        local column = mk("Frame", {
            Size = UDim2.new(0.5, -gap * 0.5, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = order, Parent = row,
        })
        vlist(column, 8, Enum.HorizontalAlignment.Left)
        local sub = setmetatable({}, Section)
        sub.Tab = self.Tab
        sub._count = 0
        sub._inner = column
        return sub
    end
    return makeColumn(1), makeColumn(2)
end
function Section:_row(title, desc)
    self._count = self._count + 1
    local row = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, LayoutOrder = self._count, Parent = self._inner,
    })
    local textHolder = mk("Frame", {
        Size = UDim2.new(1, -60, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Parent = row,
    })
    vlist(textHolder, 2)
    local t = mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Text = title or "", Font = Enum.Font.GothamBold,
        TextSize = 13, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true, Parent = textHolder,
    })
    local d
    if desc and desc ~= "" then
        d = mk("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, Text = desc, Font = Enum.Font.Gotham,
            TextSize = 11, TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true, Parent = textHolder,
        })
    end
    return row, t, d
end
function Section:Toggle(opts)
    opts = opts or {}
    local row = self:_row(opts.Title, opts.Desc)
    local state = opts.Value and true or false
    local sw = mk("Frame", {
        Size = UDim2.new(0, 42, 0, 22), Position = UDim2.new(1, -42, 0, 0),
        BackgroundColor3 = C.bgHover, BorderSizePixel = 0, Parent = row,
    })
    corner(sw, 11)
    local swStroke = stroke(sw, C.stroke, 1, 0.5)
    local knob = mk("Frame", {
        Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = C.dim, BorderSizePixel = 0, Parent = sw,
    })
    corner(knob, 8)
    local function render()
        TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
            Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = state and C.white or C.dim,
        }):Play()
        TweenService:Create(sw, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
            BackgroundColor3 = state and C.primary or C.bgHover,
        }):Play()
        if opts.Glow then
            A2UI:SetGlow(swStroke, "pulse", { Prop = "Color", Color = opts.GlowColor or C.primary, Speed = state and 2.0 or 3.6 })
            swStroke.Thickness = state and 2.5 or 2
            swStroke.Transparency = state and 0 or 0.35
        end
    end
    render()
    local function setState(v, fire)
        state = v and true or false
        render()
        if fire ~= false and opts.Callback then
            task.spawn(function() opts.Callback(state) end)
        end
        -- FIX: notif instan tiap fitur di-ON/OFF (toast ringan, 0.9 detik)
        if fire ~= false and opts.Title then
            pcall(A2UI.Toast, A2UI, tostring(opts.Title) .. (state and "  â¢  ON" or "  â¢  OFF"), state, 0.9)
        end
    end
    local hit = mk("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = row,
    })
    hit.MouseButton1Click:Connect(function() setState(not state, true) end)
    if opts.Flag and self.Tab and self.Tab.Window then
        local w = self.Tab.Window
        local _set = setState
        setState = function(v, fire)
            _set(v, fire)
            if fire ~= false then w:_autoSave() end
        end
        w:RegisterConfigElement(opts.Flag,
            function() return state end,
            function(v) setState(v, false) end)
    end
    return { Set = function(_, v, f) setState(v, f) end, Get = function() return state end }
end
function Section:Slider(opts)
    opts = opts or {}
    local v = opts.Value or {}
    local min = tonumber(v.Min) or 0
    local max = tonumber(v.Max) or 100
    if max < min then min, max = max, min end
    local step = tonumber(opts.Step) or 1
    local suffix = tostring(opts.Suffix or "")
    local cur = tonumber(v.Default) or min
    if cur < min then cur = min end
    if cur > max then cur = max end
    local row = self:_row(opts.Title, opts.Desc)
    local range = max - min
    local alpha = range > 0 and (cur - min) / range or 0
    local badge = mk("TextBox", {
        Size = UDim2.new(0, 0, 0, 18), AutomaticSize = Enum.AutomaticSize.X,
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = C.bgHover,
        Text = "  " .. tostring(cur) .. suffix .. "  ", Font = Enum.Font.GothamMedium,
        TextSize = 11, TextColor3 = C.secondary, Parent = row,
        ClearTextOnFocus = true, TextEditable = true,
        TextXAlignment = Enum.TextXAlignment.Center,
    })
    mk("UISizeConstraint", { MinSize = Vector2.new(44, 18), Parent = badge })
    corner(badge, 6)
    local track = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 0, 26),
        BackgroundColor3 = C.bgHover, BorderSizePixel = 0, Parent = row,
    })
    corner(track, 4)
    local fill = mk("Frame", {
        Size = UDim2.new(alpha, 0, 1, 0), BackgroundColor3 = C.primary,
        BorderSizePixel = 0, Parent = track,
    })
    corner(fill, 4)
    mk("UIGradient", { Color = GRADIENT_HOT, Rotation = 0, Parent = fill })
    local knob = mk("Frame", {
        Size = UDim2.new(0, 16, 0, 16), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(alpha, 0, 0.5, 0), BackgroundColor3 = C.white,
        BorderSizePixel = 0, Parent = track,
    })
    corner(knob, 8)
    stroke(knob, C.secondary, 2, 0)
    local dragging = false
    local function setVal(val, fire)
        val = math.clamp(val, min, max)
        if step > 0 then val = math.floor(val / step + 0.5) * step end
        cur = val
        local a = range > 0 and (cur - min) / range or 0
        fill.Size = UDim2.new(a, 0, 1, 0)
        knob.Position = UDim2.new(a, 0, 0.5, 0)
        badge.Text = "  " .. tostring(cur) .. suffix .. "  "
        if fire ~= false and opts.Callback then
            task.spawn(function() opts.Callback(cur) end)
        end
    end
    local function fromX(x)
        local a = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        setVal(min + a * (max - min), true)
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; fromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            fromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local function a2CommitTyped()
        local cleaned = tostring(badge.Text or ""):gsub("[^%d%.%-]", "")
        local typed = tonumber(cleaned)
        if typed then setVal(typed, true) end
        badge.Text = "  " .. tostring(cur) .. suffix .. "  "
    end
    badge.FocusLost:Connect(a2CommitTyped)
    if badge.ReturnPressedFromOnScreenKeyboard then
        badge.ReturnPressedFromOnScreenKeyboard:Connect(function()
            pcall(function() badge:ReleaseFocus() end)
        end)
    end
    if opts.Flag and self.Tab and self.Tab.Window then
        local w = self.Tab.Window
        local _set = setVal
        setVal = function(val, fire)
            _set(val, fire)
            if fire ~= false then w:_autoSave() end
        end
        w:RegisterConfigElement(opts.Flag,
            function() return cur end,
            function(v) setVal(v, false) end)
    end
    return { Set = function(_, val) setVal(val, false) end, Get = function() return cur end }
end
local function colorOf(c)
    if typeof(c) == "Color3" then return c end
    if type(c) == "string" then return C[c:lower()] or C.primary end
    return C.primary
end
function Section:Button(opts)
    opts = opts or {}
    self._count = self._count + 1
    local col = colorOf(opts.Color)
    local btn = mk("TextButton", {
        Size = UDim2.new(1, 0, 0, opts.Desc and 44 or 36),
        BackgroundColor3 = col, BackgroundTransparency = 0.85, BorderSizePixel = 0,
        Text = "", AutoButtonColor = false, LayoutOrder = self._count, Parent = self._inner,
    })
    corner(btn, 10)
    stroke(btn, col, 1, 0.35)
    local title = mk("TextLabel", {
        Size = UDim2.new(1, opts.Icon and -38 or -16, 0, 16),
        Position = UDim2.new(0, opts.Icon and 32 or 10, 0, opts.Desc and 7 or 10),
        BackgroundTransparency = 1, Text = opts.Title or "Button",
        Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.text,
        TextXAlignment = opts.Justify == "Center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
        Parent = btn,
    })
    if opts.Icon then
        makeIcon(btn, opts.Icon, {
            Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 8, 0.5, -11),
            Color = col,
        })
    end
    if opts.Glow then textGlow(title, col, tonumber(opts.GlowStrength) or 0.72) end
    if opts.Shine then shineText(title, col) end
    if opts.Desc then
        mk("TextLabel", {
            Size = UDim2.new(1, -16, 0, 14), Position = UDim2.new(0, 10, 0, 25),
            BackgroundTransparency = 1, Text = opts.Desc, Font = Enum.Font.Gotham,
            TextSize = 10, TextColor3 = C.dim,
            TextXAlignment = opts.Justify == "Center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
            Parent = btn,
        })
    end
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0.65 }):Play()
        if opts.Glow then TweenService:Create(title, TweenInfo.new(0.12), { TextStrokeTransparency = 0.35 }):Play() end
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0.85 }):Play()
        if opts.Glow then TweenService:Create(title, TweenInfo.new(0.12), { TextStrokeTransparency = tonumber(opts.GlowStrength) or 0.72 }):Play() end
    end)
    btn.MouseButton1Click:Connect(function()
        if opts.Callback then task.spawn(function() opts.Callback() end) end
    end)
    return btn
end
function Section:Input(opts)
    opts = opts or {}
    self._count = self._count + 1
    local row = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, LayoutOrder = self._count, Parent = self._inner,
    })
    mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
        Text = opts.Title or "Input", Font = Enum.Font.GothamBold,
        TextSize = 12, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local box = mk("TextBox", {
        Size = UDim2.new(1, 0, 0, 34), Position = UDim2.new(0, 0, 0, 20),
        BackgroundColor3 = C.bgHover, BorderSizePixel = 0, Text = opts.Value or "",
        PlaceholderText = opts.Placeholder or "", PlaceholderColor3 = C.dim,
        Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.text,
        TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Parent = row,
    })
    corner(box, 8); stroke(box, C.stroke, 1, 0.5)
    pad(box, 0, 10, 0, 10)
    box.Focused:Connect(function() stroke(box, C.secondary, 1, 0.15) end)
    box.FocusLost:Connect(function()
        stroke(box, C.stroke, 1, 0.5)
        if opts.Flag and self.Tab and self.Tab.Window then self.Tab.Window:_autoSave() end
        if opts.Callback then task.spawn(function() opts.Callback(box.Text) end) end
    end)
    if opts.Flag and self.Tab and self.Tab.Window then
        self.Tab.Window:RegisterConfigElement(opts.Flag,
            function() return box.Text end,
            function(v)
                box.Text = tostring(v or "")
                if opts.Callback then pcall(function() opts.Callback(box.Text) end) end
            end)
    end
    return box
end
function Section:Dropdown(opts)
    opts = opts or {}
    self._count = self._count + 1
    local values = opts.Values or {}
    local current = opts.Value
    local open = false
    local row = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, LayoutOrder = self._count, Parent = self._inner,
    })
    mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
        Text = opts.Title or "Dropdown", Font = Enum.Font.GothamBold,
        TextSize = 12, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local btn = mk("TextButton", {
        Size = UDim2.new(1, 0, 0, 34), Position = UDim2.new(0, 0, 0, 20),
        BackgroundColor3 = C.bgHover, BorderSizePixel = 0,
        Text = "  " .. tostring(current or "Pilih..."), Font = Enum.Font.Gotham,
        TextSize = 12, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false, Parent = row,
    })
    corner(btn, 8); stroke(btn, C.stroke, 1, 0.5)
    local listFrame = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 58),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.bgPanel,
        BorderSizePixel = 0, Visible = false, Parent = row,
    })
    corner(listFrame, 8); stroke(listFrame, C.glow, 1, 0.3)
    local listScroll = mk("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.primary, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = listFrame,
    })
    vlist(listScroll, 2); pad(listScroll, 6, 6, 6, 6)
    mk("UISizeConstraint", { MaxSize = Vector2.new(9999, 180), Parent = listScroll })
    local obj = {}
    local function rebuild()
        for _, ch in ipairs(listScroll:GetChildren()) do
            if ch:IsA("TextButton") then ch:Destroy() end
        end
        for i, val in ipairs(values) do
            local selected = tostring(val) == tostring(current)
            local it = mk("TextButton", {
                Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = selected and C.primary or C.bgRow,
                BackgroundTransparency = selected and 0.7 or 1,
                BorderSizePixel = 0, Text = "  " .. tostring(val), Font = Enum.Font.Gotham,
                TextSize = 11, TextColor3 = selected and C.white or C.text,
                TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false,
                LayoutOrder = i, Parent = listScroll,
            })
            corner(it, 6)
            it.MouseButton1Click:Connect(function()
                current = val
                btn.Text = "  " .. tostring(val)
                open = false
                listFrame.Visible = false
                if opts.Flag and self.Tab and self.Tab.Window then self.Tab.Window:_autoSave() end
                if opts.Callback then task.spawn(function() opts.Callback(val) end) end
            end)
        end
    end
    rebuild()
    btn.MouseButton1Click:Connect(function()
        open = not open
        listFrame.Visible = open
        if open then rebuild() end
    end)
    if opts.Flag and self.Tab and self.Tab.Window then
        self.Tab.Window:RegisterConfigElement(opts.Flag,
            function() return current end,
            function(v) obj.Select(v) end)
    end
    obj.Refresh = function(newValues) values = newValues or {}; rebuild() end
    obj.Select = function(val)
        current = val; btn.Text = "  " .. tostring(val)
        if opts.Callback then task.spawn(function() pcall(opts.Callback, val) end) end
    end
    obj.Get = function() return current end
    return obj
end
function Section:Paragraph(opts)
    opts = opts or {}
    self._count = self._count + 1
    local col = colorOf(opts.Color)
    local card = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = C.bgHover, BackgroundTransparency = 0.5, BorderSizePixel = 0,
        LayoutOrder = self._count, Parent = self._inner,
    })
    corner(card, 9)
    local bar = mk("Frame", {
        Size = UDim2.new(0, 3, 1, -12), Position = UDim2.new(0, 0, 0, 6),
        BackgroundColor3 = col, BorderSizePixel = 0, Parent = card,
    })
    corner(bar, 2)
    mk("UIGradient", { Color = GRADIENT_HOT, Rotation = 90, Parent = bar })
    local holder = mk("Frame", {
        Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 12, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = card,
    })
    vlist(holder, 2); pad(holder, 8, 4, 8, 0)
    local title = mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Text = opts.Title or "", Font = Enum.Font.GothamBold,
        TextSize = 12, TextColor3 = col, TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true, Parent = holder,
    })
    if opts.Shine then shineText(title, col) end
    local desc = mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Text = opts.Desc or "", Font = Enum.Font.Gotham,
        TextSize = 11, TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true, Parent = holder,
    })
    return {
        SetTitle = function(_, t) title.Text = t end,
        SetDesc = function(_, d) desc.Text = d end,
        Set = function(_, t, d)
            if t then title.Text = t end
            if d then desc.Text = d end
        end,
    }
end
function Tab:Button(opts) return self:Section({}):Button(opts) end
function Tab:Paragraph(opts) return self:Section({}):Paragraph(opts) end
function Tab:Toggle(opts) return self:Section({}):Toggle(opts) end
function Tab:Input(opts) return self:Section({}):Input(opts) end
function Tab:Dropdown(opts) return self:Section({}):Dropdown(opts) end
function Tab:Slider(opts) return self:Section({}):Slider(opts) end
function Tab:Columns(opts) return self:Section({}):Columns(opts) end
local glowTargets = setmetatable({}, { __mode = "k" })
local glowConn
local function ensureGlowLoop()
    if glowConn then return end
    glowConn = RunService.Heartbeat:Connect(function()
        local t = os.clock()
        for obj, fx in pairs(glowTargets) do
            if not obj.Parent then glowTargets[obj] = nil
            else
                local col
                if fx.Mode == "rainbow" then
                    col = Color3.fromHSV(((t * (fx.Speed or 0.25)) + (fx.Offset or 0)) % 1, 0.75, 1)
                else
                    local a = (math.sin(t * (fx.Speed or 3)) + 1) / 2
                    col = (fx.Color or C.primary):Lerp(C.white, a * 0.6)
                end
                local prop = fx.Prop
                pcall(function() obj[prop] = col end)
                if fx.Stroke and obj:IsA("GuiObject") then
                    pcall(function() obj.TextStrokeColor3 = col; obj.TextStrokeTransparency = 0.35 end)
                end
            end
        end
    end)
end
function A2UI:SetGlow(obj, mode, opts)
    opts = opts or {}
    if not obj then return end
    if not mode then glowTargets[obj] = nil; return end
    local prop = opts.Prop
    if not prop then
        if obj:IsA("UIStroke") then prop = "Color"
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then prop = "TextColor3"
        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then prop = "ImageColor3"
        else prop = "BackgroundColor3" end
    end
    glowTargets[obj] = { Mode = mode, Prop = prop, Speed = opts.Speed, Color = opts.Color,
        Offset = opts.Offset, Stroke = opts.TextStroke }
    ensureGlowLoop()
end
A2UI.Themes = {
    Silver  = { primary = Color3.fromRGB(218, 222, 232), secondary = Color3.fromRGB(153, 164, 184), glow = Color3.fromRGB(205, 211, 225) },
    Cyber   = { primary = Color3.fromRGB(0, 229, 255),   secondary = Color3.fromRGB(0, 140, 255),   glow = Color3.fromRGB(120, 240, 255) },
    Neon    = { primary = Color3.fromRGB(57, 255, 136),  secondary = Color3.fromRGB(0, 196, 140),   glow = Color3.fromRGB(150, 255, 190) },
    Blood   = { primary = Color3.fromRGB(255, 64, 88),   secondary = Color3.fromRGB(180, 20, 50),   glow = Color3.fromRGB(255, 140, 150) },
    Sunset  = { primary = Color3.fromRGB(255, 154, 60),  secondary = Color3.fromRGB(255, 80, 120),  glow = Color3.fromRGB(255, 200, 140) },
    Ocean   = { primary = Color3.fromRGB(64, 156, 255),  secondary = Color3.fromRGB(32, 90, 200),   glow = Color3.fromRGB(150, 200, 255) },
    Sakura  = { primary = Color3.fromRGB(255, 150, 200), secondary = Color3.fromRGB(220, 100, 170), glow = Color3.fromRGB(255, 200, 230) },
    Gold    = { primary = Color3.fromRGB(255, 210, 90),  secondary = Color3.fromRGB(200, 150, 40),  glow = Color3.fromRGB(255, 230, 160) },
}
local function sameColor(a, b)
    return math.abs(a.R - b.R) < 0.004 and math.abs(a.G - b.G) < 0.004 and math.abs(a.B - b.B) < 0.004
end
local function remapSeq(seq, map)
    local kps = {}
    for i, kp in ipairs(seq.Keypoints) do
        local v = kp.Value
        for _, m in ipairs(map) do if sameColor(v, m[1]) then v = m[2]; break end end
        kps[i] = ColorSequenceKeypoint.new(kp.Time, v)
    end
    return ColorSequence.new(kps)
end
function A2UI:SetAccent(primary, secondary, glow)
    if typeof(primary) ~= "Color3" then return false end
    local h, s, v = primary:ToHSV()
    secondary = secondary or Color3.fromHSV(h, math.min(1, s * 1.1), v * 0.72)
    glow = glow or primary:Lerp(C.white, 0.45)
    local map = { { C.primary, primary }, { C.secondary, secondary }, { C.glow, glow } }
    local root = self.Gui
    if root then
        local props = { "BackgroundColor3", "TextColor3", "ImageColor3", "TextStrokeColor3", "Color", "ScrollBarImageColor3", "PlaceholderColor3" }
        for _, o in ipairs(root:GetDescendants()) do
            if o:IsA("UIGradient") then
                pcall(function() o.Color = remapSeq(o.Color, map) end)
            else
                for _, p in ipairs(props) do
                    local ok, cur = pcall(function() return o[p] end)
                    if ok and typeof(cur) == "Color3" then
                        for _, m in ipairs(map) do
                            if sameColor(cur, m[1]) then pcall(function() o[p] = m[2] end); break end
                        end
                    end
                end
            end
        end
    end
    C.primary, C.secondary, C.glow = primary, secondary, glow
    GRADIENT_HOT = ColorSequence.new({ ColorSequenceKeypoint.new(0, primary), ColorSequenceKeypoint.new(1, secondary) })
    GRADIENT_TITLE = ColorSequence.new({ ColorSequenceKeypoint.new(0, C.white), ColorSequenceKeypoint.new(0.6, primary), ColorSequenceKeypoint.new(1, secondary) })
    return true
end
function A2UI:SetTheme(name)
    local t = A2UI.Themes[name]
    if not t then return false end
    return self:SetAccent(t.primary, t.secondary, t.glow)
end
local function toHex(c)
    return string.format("#%02X%02X%02X", math.floor(c.R * 255 + .5), math.floor(c.G * 255 + .5), math.floor(c.B * 255 + .5))
end
local function fromHex(s)
    s = tostring(s or ""):gsub("#", ""):gsub("%s", "")
    if #s ~= 6 or not s:match("^%x+$") then return nil end
    return Color3.fromRGB(tonumber(s:sub(1, 2), 16), tonumber(s:sub(3, 4), 16), tonumber(s:sub(5, 6), 16))
end
A2UI.ToHex, A2UI.FromHex = toHex, fromHex
local function bindFlag(sec, flag, getFn, setFn)
    if flag and sec.Tab and sec.Tab.Window then
        sec.Tab.Window:RegisterConfigElement(flag, getFn, setFn)
        return function() sec.Tab.Window:_autoSave() end
    end
    return function() end
end
local function dragInput(target, onMove)
    local dragging = false
    target.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; onMove(i.Position)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            onMove(i.Position)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
function Section:ColorPicker(opts)
    opts = opts or {}
    local color = typeof(opts.Default) == "Color3" and opts.Default or C.primary
    local h, s, v = color:ToHSV()
    local rainbow = opts.Rainbow and true or false
    local open = false
    local row = self:_row(opts.Title or "Color", opts.Desc)
    local swatch = mk("TextButton", {
        Size = UDim2.new(0, 46, 0, 22), Position = UDim2.new(1, -46, 0, 0),
        BackgroundColor3 = color, BorderSizePixel = 0, Text = "", AutoButtonColor = false, Parent = row,
    })
    corner(swatch, 7)
    local swStroke = stroke(swatch, C.white, 1.5, 0.35)
    self._count = self._count + 1
    local panel = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = C.bgPanel, BorderSizePixel = 0, Visible = false,
        LayoutOrder = self._count, Parent = self._inner,
    })
    corner(panel, 10); stroke(panel, C.glow, 1, 0.4)
    pad(panel, 10, 10, 10, 10)
    vlist(panel, 8)
    local sv = mk("ImageButton", {
        Size = UDim2.new(1, -34, 0, 130), BackgroundColor3 = Color3.fromHSV(h, 1, 1),
        BorderSizePixel = 0, AutoButtonColor = false, Image = "", LayoutOrder = 1,
    })
    local svWrap = mk("Frame", { Size = UDim2.new(1, 0, 0, 130), BackgroundTransparency = 1, LayoutOrder = 1, Parent = panel })
    sv.Parent = svWrap
    corner(sv, 8)
    local white = mk("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = sv })
    corner(white, 8)
    mk("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = white })
    local black = mk("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = sv })
    corner(black, 8)
    mk("UIGradient", { Transparency = NumberSequence.new(1, 0), Rotation = 90, Parent = black })
    local svKnob = mk("Frame", {
        Size = UDim2.new(0, 12, 0, 12), AnchorPoint = Vector2.new(.5, .5),
        BackgroundTransparency = 1, Position = UDim2.new(s, 0, 1 - v, 0), ZIndex = 5, Parent = sv,
    })
    corner(svKnob, 6); stroke(svKnob, C.white, 2, 0)
    local hue = mk("ImageButton", {
        Size = UDim2.new(0, 22, 1, 0), Position = UDim2.new(1, -22, 0, 0),
        BackgroundColor3 = C.white, BorderSizePixel = 0, AutoButtonColor = false, Image = "", Parent = svWrap,
    })
    corner(hue, 6)
    local hk = {}
    for i = 0, 6 do hk[#hk + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6 % 1, 1, 1)) end
    mk("UIGradient", { Color = ColorSequence.new(hk), Rotation = 90, Parent = hue })
    local hueKnob = mk("Frame", {
        Size = UDim2.new(1, 4, 0, 4), AnchorPoint = Vector2.new(.5, .5), Position = UDim2.new(.5, 0, h, 0),
        BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 5, Parent = hue,
    })
    corner(hueKnob, 2)
    local bar = mk("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, LayoutOrder = 2, Parent = panel })
    local hex = mk("TextBox", {
        Size = UDim2.new(0, 92, 1, 0), BackgroundColor3 = C.bgHover, BorderSizePixel = 0,
        Text = toHex(color), Font = Enum.Font.Code, TextSize = 12, TextColor3 = C.text,
        ClearTextOnFocus = false, Parent = bar,
    })
    corner(hex, 6); stroke(hex, C.stroke, 1, 0.5)
    local rb = mk("TextButton", {
        Size = UDim2.new(0, 84, 1, 0), Position = UDim2.new(0, 100, 0, 0),
        BackgroundColor3 = C.bgHover, BorderSizePixel = 0, Text = "RAINBOW",
        Font = Enum.Font.GothamBlack, TextSize = 10, TextColor3 = C.dim, AutoButtonColor = false, Parent = bar,
    })
    corner(rb, 6); local rbStroke = stroke(rb, C.stroke, 1, 0.5)
    local presets = mk("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = 3, Parent = panel })
    hlist(presets, 6)
    local presetCols = { Color3.fromRGB(255,64,88), Color3.fromRGB(255,154,60), Color3.fromRGB(255,210,90), Color3.fromRGB(57,255,136),
        Color3.fromRGB(0,229,255), Color3.fromRGB(64,156,255), Color3.fromRGB(170,110,255), Color3.fromRGB(255,150,200), Color3.fromRGB(250,251,253) }
    local save = function() end
    local function apply(fire)
        color = Color3.fromHSV(h, s, v)
        swatch.BackgroundColor3 = color
        sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        svKnob.Position = UDim2.new(s, 0, 1 - v, 0)
        hueKnob.Position = UDim2.new(.5, 0, h, 0)
        if not hex:IsFocused() then hex.Text = toHex(color) end
        if fire ~= false then
            if opts.Callback then task.spawn(opts.Callback, color) end
        end
    end
    local function setColor(c, fire)
        if typeof(c) ~= "Color3" then return end
        h, s, v = c:ToHSV(); apply(fire)
        if fire ~= false then save() end
    end
    for i, pc in ipairs(presetCols) do
        local p = mk("TextButton", { Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = pc, BorderSizePixel = 0,
            Text = "", AutoButtonColor = false, LayoutOrder = i, Parent = presets })
        corner(p, 10); stroke(p, C.white, 1, 0.6)
        p.MouseButton1Click:Connect(function() setColor(pc, true) end)
    end
    dragInput(sv, function(pos)
        s = math.clamp((pos.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
        v = 1 - math.clamp((pos.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
        apply(true); save()
    end)
    dragInput(hue, function(pos)
        h = math.clamp((pos.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 0.999)
        apply(true); save()
    end)
    hex.FocusLost:Connect(function()
        local c = fromHex(hex.Text)
        if c then setColor(c, true) else hex.Text = toHex(color) end
    end)
    local rainbowConn
    local function setRainbow(on)
        rainbow = on and true or false
        rb.TextColor3 = rainbow and C.white or C.dim
        rbStroke.Transparency = rainbow and 0 or 0.5
        if rainbow then A2UI:SetGlow(rbStroke, "rainbow", { Prop = "Color" }) else A2UI:SetGlow(rbStroke, nil); rbStroke.Color = C.stroke end
        if rainbowConn then rainbowConn:Disconnect(); rainbowConn = nil end
        if rainbow then
            local last = 0
            rainbowConn = RunService.Heartbeat:Connect(function()
                if not row.Parent then rainbowConn:Disconnect(); return end
                h = (os.clock() * 0.2) % 1
                if os.clock() - last > 0.05 then last = os.clock(); apply(true) else apply(false) end
            end)
        end
    end
    rb.MouseButton1Click:Connect(function() setRainbow(not rainbow); save() end)
    swatch.MouseButton1Click:Connect(function()
        open = not open
        panel.Visible = open
        swStroke.Transparency = open and 0 or 0.35
    end)
    save = bindFlag(self, opts.Flag,
        function() return { Hex = toHex(color), Rainbow = rainbow } end,
        function(val)
            if type(val) == "table" then
                local c = fromHex(val.Hex); if c then setColor(c, true) end
                setRainbow(val.Rainbow)
            elseif type(val) == "string" then
                local c = fromHex(val); if c then setColor(c, true) end
            end
        end)
    apply(false)
    if rainbow then setRainbow(true) end
    return {
        Set = function(_, c, fire) setColor(c, fire) end,
        Get = function() return color end,
        GetHex = function() return toHex(color) end,
        SetRainbow = function(_, on) setRainbow(on) end,
    }
end
function Section:Keybind(opts)
    opts = opts or {}
    local key = opts.Default
    if type(key) == "string" then key = Enum.KeyCode[key] end
    local listening = false
    local row = self:_row(opts.Title or "Keybind", opts.Desc)
    local btn = mk("TextButton", {
        Size = UDim2.new(0, 0, 0, 22), AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = C.bgHover, BorderSizePixel = 0, Font = Enum.Font.GothamBold,
        TextSize = 11, TextColor3 = C.primary, AutoButtonColor = false, Parent = row,
        Text = "  " .. (key and key.Name or "None") .. "  ",
    })
    corner(btn, 6); local st = stroke(btn, C.primary, 1, 0.5)
    local save = function() end
    local function setKey(k, fire)
        key = k
        btn.Text = "  " .. (key and key.Name or "None") .. "  "
        if fire ~= false then save(); if opts.Changed then task.spawn(opts.Changed, key) end end
    end
    btn.MouseButton1Click:Connect(function()
        listening = true
        btn.Text = "  ...  "
        A2UI:SetGlow(st, "pulse", { Prop = "Color" }); st.Transparency = 0
    end)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not row.Parent then return end
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false
                A2UI:SetGlow(st, nil); st.Color = C.primary; st.Transparency = 0.5
                setKey(input.KeyCode == Enum.KeyCode.Backspace and nil or input.KeyCode, true)
            end
            return
        end
        if not gpe and key and input.KeyCode == key and opts.Callback then task.spawn(opts.Callback, key) end
    end)
    save = bindFlag(self, opts.Flag, function() return key and key.Name or "" end,
        function(name) setKey(name ~= "" and Enum.KeyCode[name] or nil, false) end)
    return { Set = function(_, k) setKey(type(k) == "string" and Enum.KeyCode[k] or k, false) end, Get = function() return key end }
end
function Section:Checkbox(opts)
    opts = opts or {}
    local state = opts.Value and true or false
    local col = colorOf(opts.Color)
    local row = self:_row(opts.Title or "Checkbox", opts.Desc)
    local box = mk("Frame", {
        Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -22, 0, 0),
        BackgroundColor3 = C.bgHover, BorderSizePixel = 0, Parent = row,
    })
    corner(box, 6); local st = stroke(box, C.stroke, 1.5, 0.3)
    local tick = mk("TextLabel", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "â",
        Font = Enum.Font.GothamBlack, TextSize = 15, TextColor3 = C.bgDeep, TextTransparency = 1, Parent = box })
    local save = function() end
    local function render()
        TweenService:Create(box, TweenInfo.new(.15), { BackgroundColor3 = state and col or C.bgHover }):Play()
        TweenService:Create(tick, TweenInfo.new(.15), { TextTransparency = state and 0 or 1 }):Play()
        st.Color = state and col or C.stroke
    end
    local function set(vv, fire)
        state = vv and true or false; render()
        if fire ~= false then save(); if opts.Callback then task.spawn(opts.Callback, state) end end
    end
    local hit = mk("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = row })
    hit.MouseButton1Click:Connect(function() set(not state, true) end)
    render()
    save = bindFlag(self, opts.Flag, function() return state end, function(x) set(x, false) end)
    return { Set = function(_, x, f) set(x, f) end, Get = function() return state end }
end
function Section:MultiDropdown(opts)
    opts = opts or {}
    self._count = self._count + 1
    local values = opts.Values or {}
    local selected = {}
    for _, x in ipairs(opts.Value or {}) do selected[tostring(x)] = true end
    local row = mk("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, LayoutOrder = self._count, Parent = self._inner })
    vlist(row, 4)
    mk("TextLabel", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = opts.Title or "Multi Select",
        Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1, Parent = row })
    local btn = mk("TextButton", { Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = C.bgHover, BorderSizePixel = 0,
        Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, AutoButtonColor = false, LayoutOrder = 2, Text = "", Parent = row })
    corner(btn, 8); stroke(btn, C.stroke, 1, 0.5); pad(btn, 0, 10, 0, 10)
    local list = mk("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = C.bgPanel, BorderSizePixel = 0, Visible = false, LayoutOrder = 3, Parent = row })
    corner(list, 8); stroke(list, C.glow, 1, 0.3); pad(list, 6, 6, 6, 6); vlist(list, 2)
    local save = function() end
    local function getList()
        local out = {}
        for _, x in ipairs(values) do if selected[tostring(x)] then out[#out + 1] = x end end
        return out
    end
    local function refreshText()
        local l = getList()
        local parts = {}
        for i, x in ipairs(l) do parts[i] = tostring(x) end
        btn.Text = #parts > 0 and table.concat(parts, ", ") or "Pilih..."
    end
    local function rebuild()
        for _, ch in ipairs(list:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
        for i, x in ipairs(values) do
            local on = selected[tostring(x)]
            local it = mk("TextButton", { Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = C.primary,
                BackgroundTransparency = on and 0.7 or 1, BorderSizePixel = 0,
                Text = (on and "  â  " or "  â  ") .. tostring(x), Font = Enum.Font.Gotham, TextSize = 11,
                TextColor3 = on and C.white or C.text, TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false, LayoutOrder = i, Parent = list })
            corner(it, 6)
            it.MouseButton1Click:Connect(function()
                selected[tostring(x)] = not selected[tostring(x)] or nil
                rebuild(); refreshText(); save()
                if opts.Callback then task.spawn(opts.Callback, getList()) end
            end)
        end
    end
    btn.MouseButton1Click:Connect(function() list.Visible = not list.Visible; if list.Visible then rebuild() end end)
    refreshText()
    save = bindFlag(self, opts.Flag, getList, function(l)
        selected = {}
        for _, x in ipairs(type(l) == "table" and l or {}) do selected[tostring(x)] = true end
        refreshText(); rebuild()
    end)
    return {
        Get = getList,
        Set = function(_, l) selected = {}; for _, x in ipairs(l or {}) do selected[tostring(x)] = true end; refreshText(); rebuild() end,
        Refresh = function(_, nv) values = nv or {}; rebuild(); refreshText() end,
    }
end
function Section:Label(opts)
    if type(opts) == "string" then opts = { Text = opts } end
    opts = opts or {}
    self._count = self._count + 1
    local col = colorOf(opts.Color or "text")
    local lbl = mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        Text = opts.Text or "Label", Font = opts.Bold and Enum.Font.GothamBlack or Enum.Font.GothamMedium,
        TextSize = opts.Size or 13, TextColor3 = col, TextWrapped = true, RichText = true,
        TextXAlignment = Enum.TextXAlignment[opts.Align or "Left"], LayoutOrder = self._count, Parent = self._inner,
    })
    if opts.Gradient then TextGradient(lbl) end
    if opts.Glow == "rainbow" then A2UI:SetGlow(lbl, "rainbow", { TextStroke = true, Speed = opts.Speed })
    elseif opts.Glow then
        A2UI:SetGlow(lbl, "pulse", { TextStroke = true, Color = col, Speed = opts.Speed })
    end
    return {
        Instance = lbl,
        Set = function(_, t) lbl.Text = tostring(t) end,
        SetColor = function(_, c) lbl.TextColor3 = c; local fx = glowTargets[lbl]; if fx then fx.Color = c end end,
        SetGlow = function(_, mode) A2UI:SetGlow(lbl, mode, { TextStroke = true, Color = lbl.TextColor3 }) end,
    }
end
function Section:GlowText(opts)
    if type(opts) == "string" then opts = { Text = opts } end
    opts = opts or {}
    opts.Size = opts.Size or 20; opts.Bold = true; opts.Align = opts.Align or "Center"
    if opts.Glow == nil then opts.Glow = "rainbow" end
    return self:Label(opts)
end
function Section:Divider(text)
    self._count = self._count + 1
    local f = mk("Frame", { Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, LayoutOrder = self._count, Parent = self._inner })
    local line = mk("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, .5, 0), BackgroundColor3 = C.primary,
        BorderSizePixel = 0, Parent = f })
    mk("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(.5, .2), NumberSequenceKeypoint.new(1, 1) }), Parent = line })
    if text then
        local t = mk("TextLabel", { Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, AnchorPoint = Vector2.new(.5, 0),
            Position = UDim2.new(.5, 0, 0, 0), BackgroundColor3 = C.bgRow, BorderSizePixel = 0, Text = "  " .. text .. "  ",
            Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = C.dim, Parent = f })
    end
end
function Section:ProgressBar(opts)
    opts = opts or {}
    local val = math.clamp(tonumber(opts.Value) or 0, 0, 100)
    local row = self:_row(opts.Title or "Progress", opts.Desc)
    local pct = mk("TextLabel", { Size = UDim2.new(0, 50, 0, 16), Position = UDim2.new(1, -50, 0, 0), BackgroundTransparency = 1,
        Text = tostring(val) .. "%", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.primary,
        TextXAlignment = Enum.TextXAlignment.Right, Parent = row })
    local track = mk("Frame", { Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 1, 6), BackgroundColor3 = C.bgHover,
        BorderSizePixel = 0, Parent = row })
    corner(track, 4)
    mk("Frame", { Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, Position = UDim2.new(0, 0, 1, 0), Parent = row })
    local fill = mk("Frame", { Size = UDim2.new(val / 100, 0, 1, 0), BackgroundColor3 = opts.Color and colorOf(opts.Color) or C.primary,
        BorderSizePixel = 0, Parent = track })
    corner(fill, 4)
    if not opts.Color then mk("UIGradient", { Color = GRADIENT_HOT, Parent = fill }) end
    if opts.Glow then A2UI:SetGlow(fill, "rainbow") end
    local sp = mk("UIPadding", { PaddingBottom = UDim.new(0, 16), Parent = row })
    local function set(x)
        val = math.clamp(tonumber(x) or 0, 0, 100)
        TweenService:Create(fill, TweenInfo.new(.25, Enum.EasingStyle.Quart), { Size = UDim2.new(val / 100, 0, 1, 0) }):Play()
        pct.Text = string.format("%d%%", math.floor(val + .5))
    end
    return { Set = function(_, x) set(x) end, Get = function() return val end }
end
function Section:Stepper(opts)
    opts = opts or {}
    local min, max, step = tonumber(opts.Min) or 0, tonumber(opts.Max) or 100, tonumber(opts.Step) or 1
    local cur = math.clamp(tonumber(opts.Default) or min, min, max)
    local row = self:_row(opts.Title or "Stepper", opts.Desc)
    local box = mk("Frame", { Size = UDim2.new(0, 96, 0, 24), Position = UDim2.new(1, -96, 0, 0), BackgroundColor3 = C.bgHover,
        BorderSizePixel = 0, Parent = row })
    corner(box, 7); stroke(box, C.stroke, 1, 0.5)
    local function sb(txt, x)
        local b = mk("TextButton", { Size = UDim2.new(0, 26, 1, 0), Position = UDim2.new(x, x == 1 and -26 or 0, 0, 0),
            BackgroundTransparency = 1, Text = txt, Font = Enum.Font.GothamBlack, TextSize = 14, TextColor3 = C.primary, Parent = box })
        return b
    end
    local minus, plus = sb("â", 0), sb("+", 1)
    local num = mk("TextLabel", { Size = UDim2.new(1, -52, 1, 0), Position = UDim2.new(0, 26, 0, 0), BackgroundTransparency = 1,
        Text = tostring(cur), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.white, Parent = box })
    local save = function() end
    local function set(x, fire)
        cur = math.clamp(x, min, max); num.Text = tostring(cur)
        if fire ~= false then save(); if opts.Callback then task.spawn(opts.Callback, cur) end end
    end
    minus.MouseButton1Click:Connect(function() set(cur - step, true) end)
    plus.MouseButton1Click:Connect(function() set(cur + step, true) end)
    save = bindFlag(self, opts.Flag, function() return cur end, function(x) set(tonumber(x) or cur, false) end)
    return { Set = function(_, x, f) set(x, f) end, Get = function() return cur end }
end
function Section:ButtonGroup(opts)
    opts = opts or {}
    self._count = self._count + 1
    local list = opts.Buttons or {}
    local f = mk("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = self._count, Parent = self._inner })
    local n = math.max(#list, 1)
    hlist(f, 6)
    for i, b in ipairs(list) do
        local col = colorOf(b.Color)
        local btn = mk("TextButton", { Size = UDim2.new(1 / n, -(6 * (n - 1)) / n, 1, 0), BackgroundColor3 = col,
            BackgroundTransparency = 0.82, BorderSizePixel = 0, Text = b.Title or ("Button " .. i), Font = Enum.Font.GothamBold,
            TextSize = 12, TextColor3 = C.white, AutoButtonColor = false, LayoutOrder = i, Parent = f })
        corner(btn, 9); local st = stroke(btn, col, 1, 0.3)
        if b.Glow then A2UI:SetGlow(st, b.Glow == "rainbow" and "rainbow" or "pulse", { Color = col, Offset = i * 0.12 }) end
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(.12), { BackgroundTransparency = 0.6 }):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(.12), { BackgroundTransparency = 0.82 }):Play() end)
        btn.MouseButton1Click:Connect(function()
            TweenService:Create(btn, TweenInfo.new(.08), { BackgroundTransparency = 0.4 }):Play()
            task.delay(.1, function() TweenService:Create(btn, TweenInfo.new(.2), { BackgroundTransparency = 0.82 }):Play() end)
            if b.Callback then task.spawn(b.Callback) end
        end)
    end
end
function Section:Stats(opts)
    opts = opts or {}
    self._count = self._count + 1
    local stats = opts.Stats or {}
    local f = mk("Frame", { Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1, LayoutOrder = self._count, Parent = self._inner })
    hlist(f, 6)
    local n = math.max(#stats, 1)
    local api = {}
    for i, s in ipairs(stats) do
        local col = colorOf(s.Color)
        local card = mk("Frame", { Size = UDim2.new(1 / n, -(6 * (n - 1)) / n, 1, 0), BackgroundColor3 = C.bgHover,
            BorderSizePixel = 0, LayoutOrder = i, Parent = f })
        corner(card, 10); stroke(card, col, 1, 0.55)
        mk("TextLabel", { Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0, 8), BackgroundTransparency = 1,
            Text = string.upper(s.Title or ""), Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C.dim, Parent = card })
        local val = mk("TextLabel", { Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 26), BackgroundTransparency = 1,
            Text = tostring(s.Value or "-"), Font = Enum.Font.GothamBlack, TextSize = 17, TextColor3 = col, Parent = card })
        textGlow(val, col, 0.45)
        api[s.Title or i] = val
    end
    return { Set = function(_, key, value) local l = api[key]; if l then l.Text = tostring(value) end end }
end
function Section:Badges(opts)
    opts = opts or {}
    self._count = self._count + 1
    local f = mk("Frame", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = self._count, Parent = self._inner })
    hlist(f, 6)
    for i, b in ipairs(opts.Badges or {}) do
        local col = colorOf(b.Color)
        local l = mk("TextLabel", { Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = col,
            BackgroundTransparency = 0.8, BorderSizePixel = 0, Text = "  " .. tostring(b.Text) .. "  ", Font = Enum.Font.GothamBlack,
            TextSize = 10, TextColor3 = col, LayoutOrder = i, Parent = f })
        corner(l, 11); local st = stroke(l, col, 1, 0.3)
        if b.Glow then A2UI:SetGlow(st, b.Glow == "rainbow" and "rainbow" or "pulse", { Color = col }) end
    end
end
function Tab:ThemeSection(opts)
    opts = opts or {}
    local win = self.Window or A2UI
    local sec = self:Section({ Title = opts.Title or "Theme & Glow" })
    local names = {}
    for k in pairs(A2UI.Themes) do names[#names + 1] = k end
    table.sort(names)
    sec:Dropdown({ Title = "Preset Theme", Values = names, Value = "Silver", Flag = opts.Flag and (opts.Flag .. ".preset"),
        Callback = function(n) win:SetTheme(n); A2UI:Notify({ Title = "Theme", Content = "Theme " .. n .. " aktif.", Color = "primary" }) end })
    sec:ColorPicker({ Title = "Warna Aksen Custom", Desc = "Pilih warna bebas, hex, atau rainbow.", Default = C.primary,
        Flag = opts.Flag and (opts.Flag .. ".accent"), Callback = function(c) win:SetAccent(c) end })
    return sec
end
for _, name in ipairs({ "ColorPicker", "Keybind", "Checkbox", "MultiDropdown", "Label", "GlowText",
    "ProgressBar", "Stepper", "ButtonGroup", "Stats", "Badges" }) do
    Tab[name] = function(self, opts) local s = self:Section({}); return s[name](s, opts) end
end
Tab.Divider = function(self, text) return self:Section({}):Divider(text) end
local UI_PREF_DIR = "A2Fusion/UI"
function A2UI:LoadUIPreferences()
    self.UIPreferences = { Device = "Auto", Scale = 1, TextGradient = true, ShimmerSweep = true,
        MusicId = "", Volume = .35, Loop = true }
    self._uiPrefPath = UI_PREF_DIR .. "/" .. tostring(LocalPlayer and LocalPlayer.UserId or 0) .. ".json"
    self._uiSaveStatus = type(writefile) == "function" and type(readfile) == "function" and "Auto-save aktif" or "Sesi saja â¢ penyimpanan file tidak tersedia"
    if type(readfile) ~= "function" then return end
    local ok, body = pcall(readfile, self._uiPrefPath)
    if not ok then return end
    local decoded, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not decoded or type(data) ~= "table" then return end
    for k, v in pairs(data) do
        if self.UIPreferences[k] ~= nil and type(v) == type(self.UIPreferences[k]) then self.UIPreferences[k] = v end
    end
    local prefs = self.UIPreferences
    if prefs.Device ~= "Auto" and prefs.Device ~= "PC" and prefs.Device ~= "HP" then prefs.Device = "Auto" end
    prefs.Scale = math.clamp(prefs.Scale, .65, 1.2)
    prefs.Volume = math.clamp(prefs.Volume, 0, 1)
    if not prefs.MusicId:match("^%d+$") then prefs.MusicId = "" end
end
function A2UI:SaveUIPreferences()
    if type(writefile) ~= "function" or type(readfile) ~= "function" then
        self._uiSaveStatus = "Sesi saja â¢ penyimpanan file tidak tersedia"
    else
        ensureDir(UI_PREF_DIR)
        local ok = pcall(function() writefile(self._uiPrefPath, HttpService:JSONEncode(self.UIPreferences)) end)
        self._uiSaveStatus = ok and "Tersimpan otomatis" or "Gagal simpan â¢ perubahan hanya di sesi ini"
    end
    if self._uiSaveLabel then self._uiSaveLabel.Text = self._uiSaveStatus end
end
function A2UI:SetUIPreference(key, value)
    local prefs = self.UIPreferences
    if prefs[key] == nil or type(value) ~= type(prefs[key]) then return false end
    if key == "Device" and value ~= "Auto" and value ~= "PC" and value ~= "HP" then return false end
    if key == "Scale" then value = math.clamp(value, .65, 1.2) end
    if key == "Volume" then value = math.clamp(value, 0, 1) end
    if key == "MusicId" and value ~= "" and not value:match("^%d+$") then return false end
    prefs[key] = value
    if self._fitUI then self._fitUI() end
    if self.Gui and (key == "TextGradient" or key == "ShimmerSweep") then
        for _, label in ipairs(self.Gui:GetDescendants()) do
            if label:IsA("TextLabel") or label:IsA("TextButton") or label:IsA("TextBox") then
                label:SetAttribute("A2" .. key, value)
            end
        end
    end
    if self.Music then self.Music.Volume = prefs.Volume; self.Music.Looped = prefs.Loop end
    self:SaveUIPreferences()
    return true
end
function A2UI:AddPlayerProfile(side)
    local profile = mk("TextButton", { Name = "PlayerProfile", Size = UDim2.new(1, -16, 0, 72),
        Position = UDim2.new(0, 8, 1, -80), BackgroundColor3 = C.bgRow, BorderSizePixel = 0,
        Text = "", AutoButtonColor = false, Parent = side })
    corner(profile, 12); stroke(profile, C.secondary, 1, .5)
    local avatar = mk("ImageLabel", { Name = "PlayerHeadshot", Size = UDim2.fromOffset(38, 38),
        Position = UDim2.fromOffset(9, 9), BackgroundColor3 = C.bgHover, BorderSizePixel = 0,
        Image = "", ScaleType = Enum.ScaleType.Crop, Parent = profile })
    corner(avatar, 999); stroke(avatar, C.primary, 1, .2)
    makeIcon(avatar, "user", { Size = UDim2.fromOffset(24, 24), Position = UDim2.fromOffset(7, 7) })
    mk("TextLabel", { Size = UDim2.new(1, -61, 0, 20), Position = UDim2.fromOffset(54, 9),
        BackgroundTransparency = 1, Text = LocalPlayer and LocalPlayer.DisplayName or "Player",
        TextColor3 = C.white, TextSize = 12, Font = Enum.Font.GothamBold, TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = profile })
    mk("TextLabel", { Size = UDim2.new(1, -61, 0, 16), Position = UDim2.fromOffset(54, 29),
        BackgroundTransparency = 1, Text = "@" .. A2_ENV.User, TextColor3 = C.dim, TextSize = 9,
        Font = Enum.Font.Gotham, TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = profile })
    mk("TextLabel", { Size = UDim2.new(1, -18, 0, 14), Position = UDim2.fromOffset(9, 51),
        BackgroundTransparency = 1, Text = "UI Settings  âº", TextColor3 = C.secondary, TextSize = 10,
        Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = profile })
    profile.Activated:Connect(function() self:OpenProfileSettings() end)
    task.spawn(function()
        if not LocalPlayer then return end
        for _ = 1, 3 do
            local ok, url, ready = pcall(function()
                return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
            end)
            if not avatar.Parent then return end
            if ok and ready and url ~= "" then
                avatar.Image = url
                for _, child in ipairs(avatar:GetChildren()) do if child:IsA("ImageLabel") then child:Destroy() end end
                return
            end
            task.wait(1)
        end
    end)
end
function A2UI:OpenProfileSettings()
    if self.ProfileDialog and self.ProfileDialog.Parent then self.ProfileDialog.Visible = true; return end
    local layer = mk("Frame", { Name = "ProfileSettingsWindow", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = C.bgDeep, BackgroundTransparency = .18, BorderSizePixel = 0,
        ZIndex = 300, Parent = self.Main })
    self.ProfileDialog = layer
    local card = mk("Frame", { Size = UDim2.new(1, -80, 1, -48), Position = UDim2.fromOffset(40, 24),
        BackgroundColor3 = C.bgPanel, BorderSizePixel = 0, ZIndex = 301, Parent = layer })
    corner(card, 14); stroke(card, C.primary, 1, .35)
    mk("TextLabel", { Size = UDim2.new(1, -72, 0, 26), Position = UDim2.fromOffset(18, 12),
        BackgroundTransparency = 1, Text = "PLAYER â¢ UI SETTINGS", TextColor3 = C.white,
        Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 302, Parent = card })
    local close = mk("TextButton", { Size = UDim2.fromOffset(32, 32), Position = UDim2.new(1, -46, 0, 12),
        BackgroundColor3 = C.bgRow, BorderSizePixel = 0, Text = "", ZIndex = 303, Parent = card })
    corner(close, 8)
    makeIcon(close, "close", { Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(7, 7) }).ZIndex = 304
    close.Activated:Connect(function() layer.Visible = false end)
    local page = mk("ScrollingFrame", { Size = UDim2.new(1, -24, 1, -98), Position = UDim2.fromOffset(12, 54),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.primary, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 302, Parent = card })
    vlist(page, 10); pad(page, 6, 6, 6, 6)
    local tab = setmetatable({ Window = self, _page = page }, Tab)
    local controls = tab:Section({ Title = "Display" })
    controls:Dropdown({ Title = "UI PC / HP", Values = { "Auto", "PC", "HP" }, Value = self.UIPreferences.Device,
        Callback = function(v) self:SetUIPreference("Device", v) end })
    controls:Slider({ Title = "Ukuran UI (%)", Step = 5, Value = { Min = 65, Max = 120, Default = self.UIPreferences.Scale * 100 },
        Callback = function(v) self:SetUIPreference("Scale", v / 100) end })
    controls:Toggle({ Title = "TextGradient", Value = self.UIPreferences.TextGradient,
        Callback = function(v) self:SetUIPreference("TextGradient", v) end })
    controls:Toggle({ Title = "Shimmer Sweep", Value = self.UIPreferences.ShimmerSweep,
        Callback = function(v) self:SetUIPreference("ShimmerSweep", v) end })
    self._uiSaveLabel = mk("TextLabel", { Size = UDim2.new(1, -36, 0, 24), Position = UDim2.new(0, 18, 1, -34),
        BackgroundTransparency = 1, Text = self._uiSaveStatus, TextColor3 = C.dim, TextSize = 11,
        Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 303, Parent = card })
end
A2UI.DiscordInvite = "https://discord.gg/V2MGKHTqq"
function A2UI:OpenDiscordInvite()
    if type(setclipboard) == "function" then
        local ok = pcall(setclipboard, A2UI.DiscordInvite)
        if ok then self:Notify({ Title = "Discord A2 FUSION", Content = "Link disalin â¢ buka di Discord atau browser." }); return end
    end
    local tab = self._currentTab
    if tab then
        if not self._inviteInput or not self._inviteInput.Parent then
            self._inviteInput = tab:Section({ Title = "Discord A2 FUSION" }):Input({ Title = "Link undangan", Value = A2UI.DiscordInvite })
        end
        self._inviteInput:CaptureFocus()
        self._inviteInput.SelectionStart = 1
        self._inviteInput.CursorPosition = #A2UI.DiscordInvite + 1
    end
    self:Notify({ Title = "Discord", Content = A2UI.DiscordInvite .. " â¢ salin link ini." })
end
function A2UI:AddDashboardMusic(tab)
    local SoundService = game:GetService("SoundService")
    local sound = mk("Sound", { Name = "A2DashboardMusic", Volume = self.UIPreferences.Volume,
        Looped = self.UIPreferences.Loop, Parent = SoundService })
    self.Music = sound
    local section = tab:Section({ Title = "Music" })
    local status = mk("TextLabel", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
        Text = "Stopped", TextColor3 = C.dim, TextSize = 11, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = section._inner, LayoutOrder = -1 })
    local box = section:Input({ Title = "Roblox Audio ID", Placeholder = "Masukkan ID audio yang diizinkan game",
        Value = self.UIPreferences.MusicId,
        Callback = function(v)
            v = v:match("^%s*(.-)%s*$")
            local uri = assetUri(v)
            if not uri then status.Text = "ID audio tidak valid"; return end
            self:SetUIPreference("MusicId", uri:match("(%d+)$"))
        end })
    local ticket = 0
    section:Button({ Title = "Play / Resume", Icon = "play", Callback = function()
        local uri = assetUri(box.Text)
        if not uri then status.Text = "Masukkan Roblox Audio ID yang valid"; return end
        ticket = ticket + 1
        local currentTicket = ticket
        if sound.SoundId ~= uri then sound:Stop(); sound.SoundId = uri end
        self:SetUIPreference("MusicId", uri:match("(%d+)$"))
        status.Text = sound.IsLoaded and "Playing" or "Loading audioâ¦"
        local ok, err = pcall(function()
            if sound.IsPaused then sound:Resume() else sound:Play() end
        end)
        if not ok then status.Text = "Gagal memutar audio"; warn("[A2 Music] " .. tostring(err)); return end
        task.delay(10, function()
            if currentTicket == ticket and sound.Parent and not sound.IsLoaded then
                sound:Stop(); status.Text = "Audio gagal dimuat / tidak diizinkan game"
            end
        end)
    end })
    section:Button({ Title = "Pause", Icon = "pause", Callback = function()
        ticket = ticket + 1; sound:Pause(); status.Text = "Paused"
    end })
    section:Button({ Title = "Stop", Icon = "power", Callback = function()
        ticket = ticket + 1; sound:Stop(); status.Text = "Stopped"
    end })
    section:Slider({ Title = "Volume", Step = 1, Value = { Min = 0, Max = 100, Default = self.UIPreferences.Volume * 100 },
        Callback = function(v) self:SetUIPreference("Volume", v / 100) end })
    section:Toggle({ Title = "Loop", Value = self.UIPreferences.Loop,
        Callback = function(v) self:SetUIPreference("Loop", v) end })
    sound.Loaded:Connect(function() if sound.Playing then status.Text = "Playing" end end)
    sound.Ended:Connect(function() status.Text = "Finished" end)
    local elapsed = 0
    self._musicConnection = RunService.Heartbeat:Connect(function(dt)
        elapsed = elapsed + dt
        if elapsed < .5 then return end
        elapsed = 0
        if sound.Playing and sound.IsLoaded then
            local function clock(t) return string.format("%d:%02d", math.floor(t / 60), math.floor(t % 60)) end
            status.Text = "Playing â¢ " .. clock(sound.TimePosition) .. " / " .. clock(sound.TimeLength)
        end
    end)
end
function A2UI:Boot(opts)
    local ok, result = pcall(function() return self:CreateWindow(opts or {}) end)
    if ok and result then
        self.LastError = nil
        return result
    end
    self.LastError = tostring(result)
    warn("[A2 UI] CreateWindow gagal: " .. self.LastError)
    return nil, self.LastError
end
local function isModuleScript()
    local ok, result = pcall(function()
        if type(getgenv) == "function" or type(identifyexecutor) == "function"
            or type(getexecutorname) == "function" then return false end
        return script and script:IsA("ModuleScript")
    end)
    return ok and result == true
end
local skipAutoMount = false
pcall(function()
    if type(getgenv) == "function" then
        skipAutoMount = getgenv().A2UI_NO_AUTOMOUNT == true
    end
end)
-- FIX PERF (v13.1): A2UI:MountDemo() demo UI dihapus (226 baris,
-- tidak pernah dipanggil karena auto-mount selalu dimatikan).
function A2UI:MountDemo() end
if not isModuleScript() and not skipAutoMount then
    A2UI:MountDemo()
end
return A2UI

    end)()
end)
env.A2UI_NO_AUTOMOUNT = previous
if not ok or type(A2) ~= "table" or type(A2.CreateWindow) ~= "function" then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "A2 HUB",
            Text = "Gagal memuat UI: " .. tostring(A2),
            Duration = 10,
        })
    end)
    error("[A2 FUSION] Gagal memuat A2 UI: " .. tostring(A2))
end
local UIS = game:GetService("UserInputService")
local HTTP = game:GetService("HttpService")
local lib = { Scheme = {}, _pendingNotifies = {}, _controls = {} }
local function keyFromString(k)
    if typeof(k) == "EnumItem" then return k end
    if type(k) ~= "string" or k == "" or k:lower() == "none" then return nil end
    local valid, key = pcall(function() return Enum.KeyCode[k:gsub("%s+", "")] end)
    return valid and key or nil
end
local function wrap(methods, control, ctx)
    local t = { _control = control, _ctx = ctx }
    return setmetatable(t, { __index = function(self, name)
        local method = methods[name]
        if method then return function(...)
            local args = table.pack(...)
            local start = args[1] == self and 2 or 1
            return method(self, table.unpack(args, start, args.n))
        end end
    end })
end
local function register(section, name, opts, wrapped)
    opts = opts or {}
    local flag = opts.Flag or (section._path .. "/" .. tostring(name))
    local base, i = flag, 1
    while lib._controls[flag] do i = i + 1; flag = base .. "#" .. i end
    lib._controls[flag] = wrapped
    return wrapped
end
function lib:Notify(opts, force)
    opts = opts or {}

    if self._suppressNotify and not force then return end
    if not self._win then table.insert(self._pendingNotifies, opts); return end
    self._win:Notify({ Title = opts.Title or Presentation.Title, Content = opts.Description or opts.Content or "", Duration = opts.Duration or 2 })
end
function lib:JoinDiscord()
    local url = "https://discord.gg/nfgXzV2rh"
    if setclipboard then pcall(setclipboard, url) end
    if OpenBrowserWindow then pcall(OpenBrowserWindow, url) end
    self:Notify({ Title = "Discord", Description = url })
end
function lib:SetWatermark(opts)
    if self._win and self._win.Watermark then self._win.Watermark.Visible = (opts or {}).Enabled ~= false end
end
local ValueMethods = {}
function ValueMethods.SetValue(self, value)
    self._control:Set(value, false)
    if self._ctx.callback then self._ctx.callback(self._control:Get()) end
end
function ValueMethods.GetValue(self) return self._control:Get() end
ValueMethods.Get = ValueMethods.GetValue
local ToggleMethods = setmetatable({}, { __index = ValueMethods })
function ToggleMethods.SetValue(self, value)
    self._control:Set(value and true or false, false)
    if self._ctx.callback then self._ctx.callback(self._control:Get()) end
end
function ToggleMethods.AddKeyPicker(self, name, opts)
    opts = opts or {}
    local mode, held = opts.Mode or "Toggle", false
    local function fire(value)
        self:SetValue(value)
        if opts.Callback then opts.Callback(value) end
    end
    local keyControl = self._ctx.section:Keybind({ Title = opts.Text or (tostring(name) .. " Keybind"), Default = keyFromString(opts.Default), Callback = function()
        if mode == "Hold" then held = true; fire(true) else fire(not self:GetValue()) end
    end })
    if mode == "Hold" then
        UIS.InputEnded:Connect(function(input)
            if held and input.KeyCode == keyControl:Get() then held = false; fire(false) end
        end)
    end
    return register(self._ctx.owner, name, opts, wrap(ValueMethods, keyControl, {}))
end
local ColorMethods = setmetatable({}, { __index = ValueMethods })
local function colorControl(owner, name, color, opts)
    opts = opts or {}
    local ctrl = owner._section:ColorPicker({ Title = name, Default = color, Callback = opts.Callback })
    return register(owner, name, opts, wrap(ColorMethods, ctrl, { callback = opts.Callback }))
end
function ToggleMethods.AddColorPicker(self, color, opts)
    return colorControl(self._ctx.owner, (opts or {}).Title or "Color", color, opts)
end
local DropdownMethods = {}
function DropdownMethods.SetValues(self, values) self._control.Refresh(values or {}) end
DropdownMethods.Refresh = DropdownMethods.SetValues
DropdownMethods.SetOptions = DropdownMethods.SetValues
DropdownMethods.Update = DropdownMethods.SetValues
function DropdownMethods.SetValue(self, value) self._control.Select(value) end
function DropdownMethods.GetValue(self) return self._control.Get() end
DropdownMethods.Get = DropdownMethods.GetValue
local InputMethods = {}
function InputMethods.SetValue(self, value)
    self._control.Text = tostring(value or "")
    if self._ctx.callback then self._ctx.callback(self._control.Text) end
end
function InputMethods.GetValue(self) return self._control.Text end
InputMethods.Get = InputMethods.GetValue
local SectionMT = {}; SectionMT.__index = SectionMT
function SectionMT:AddToggle(name, default, callback, opts)
    opts = opts or {}
    local ctrl = self._section:Toggle({ Title = name, Value = default, Callback = callback, Glow = opts.Glow, GlowColor = opts.GlowColor })
    return register(self, name, opts, wrap(ToggleMethods, ctrl, { section = self._section, owner = self, callback = callback }))
end
SectionMT.AddCheckbox = SectionMT.AddToggle
function SectionMT:AddSlider(name, minimum, maximum, default, callback, opts)
    opts = opts or {}
    local step = tonumber(opts.Increment)
    if step == nil then
        local fraction = tostring(default):match("%.(%d+)")
        step = fraction and 10 ^ (-#fraction) or 1
    end
    local ctrl = self._section:Slider({ Title = name, Value = { Min = minimum, Max = maximum, Default = default }, Step = step, Callback = callback })
    Presentation.CompactSlider(self._section)
    return register(self, name, opts, wrap(ValueMethods, ctrl, { callback = callback }))
end
function SectionMT:AddButton(name, callback, opts)
    return self._section:Button({ Title = name, Icon = Presentation.Icon((opts or {}).Icon, "bolt"), Callback = callback, Glow = true, Shine = true })
end
function SectionMT:AddDropdown(name, values, default, callback, opts)
    local ctrl = self._section:Dropdown({ Title = name, Values = values, Value = default or nil, Callback = callback })
    return register(self, name, opts, wrap(DropdownMethods, ctrl, {}))
end
function SectionMT:AddTextbox(name, default, callback, opts)
    local ctrl = self._section:Input({ Title = name, Placeholder = tostring(default or ""), Value = "", Callback = callback })
    return register(self, name, opts, wrap(InputMethods, ctrl, { callback = callback }))
end
function SectionMT:AddKeybind(name, default, callback, opts)
    local ctrl = self._section:Keybind({ Title = name, Default = keyFromString(default), Callback = callback })
    return register(self, name, opts, wrap(ValueMethods, ctrl, {}))
end
function SectionMT:AddColorPicker(name, color, opts) return colorControl(self, name, color, opts) end
local function safeName(name)
    name = tostring(name or "")
    if name == "" or name:find("[^%w _%-]") then return nil end
    return name
end
function SectionMT:AddConfigManager(folder)
    folder = folder or "OxioHub/Configs"
    local win, currentName, selected = lib._win, "", nil
    if A2._ensureDir then A2._ensureDir(folder) end
    local function list()
        local result = {}
        if not listfiles then return result end
        local success, files = pcall(listfiles, folder)
        if success then for _, file in ipairs(files) do
            local name = tostring(file):gsub("\\", "/"):match("([^/]+)%.json$")
            if name then table.insert(result, name) end
        end end
        table.sort(result); return result
    end
    self._section:Input({ Title = "Config Name", Placeholder = "Nama config...", Callback = function(v) currentName = v end })
    local dropdown = self._section:Dropdown({ Title = "Select Config", Values = list(), Callback = function(v) selected = v end })
    local function refresh() dropdown.Refresh(list()) end

    local function report(success, err) lib:Notify({ Title = "Config", Description = success and "Selesai." or tostring(err) }, true) end
    self:AddButton("Save Config", function()
        local name = safeName(currentName)
        if not name then report(false, "Isi nama config tanpa karakter khusus."); return end
        local success, err = pcall(function()
            if not writefile then error("Executor tidak mendukung writefile") end
            local data = {}
            for flag, ctrl in pairs(lib._controls) do
                local value = ctrl:GetValue()
                if typeof(value) == "Color3" then value = { _type = "Color3", value.R, value.G, value.B }
                elseif typeof(value) == "EnumItem" then value = { _type = "KeyCode", Name = value.Name } end
                data[flag] = value
            end
            writefile(folder .. "/" .. name .. ".json", HTTP:JSONEncode(data))
        end)
        refresh(); report(success, err)
    end)
    self:AddButton("Load Config", function()
        local name = safeName(selected)
        if not name then report(false, "Pilih config dulu."); return end

        lib._suppressNotify = true
        local success, err = pcall(function()
            if not readfile then error("Executor tidak mendukung readfile") end
            local data = HTTP:JSONDecode(readfile(folder .. "/" .. name .. ".json"))
            for flag, value in pairs(data) do
                if type(value) == "table" and value._type == "Color3" then value = Color3.new(value[1], value[2], value[3])
                elseif type(value) == "table" and value._type == "KeyCode" then value = keyFromString(value.Name) end
                local ctrl = lib._controls[flag]
                if ctrl then ctrl:SetValue(value) end
            end
        end)

        task.delay(1, function() lib._suppressNotify = false end)
        report(success, err)
    end)
    self:AddButton("Delete Config", function()
        local name = safeName(selected)
        if not name then return end
        local success, err = pcall(function()
            if not delfile then error("Executor tidak mendukung delfile") end
            delfile(folder .. "/" .. name .. ".json")
        end)
        refresh(); report(success, err)
    end)
    self:AddButton("Refresh List", refresh)
end
local PageMT = {}; PageMT.__index = PageMT
function PageMT:CreateSection(title, icon)
    local section = self._tab:Section({ Title = title })
    Presentation.Section(A2, self._tab, section, Presentation.Icon(icon, icon))
    local sec = setmetatable({ _section = section, _path = self._path .. "/" .. tostring(title) }, SectionMT)
    if title == "UI Config" then sec:AddButton("Join Discord", function() lib:JoinDiscord() end) end
    return sec
end
local TabMT = {}; TabMT.__index = TabMT
function TabMT:CreatePage(name)
    return setmetatable({ _tab = self._tab, _path = self._path .. "/" .. tostring(name) }, PageMT)
end
local WindowMT = {}; WindowMT.__index = WindowMT
function WindowMT:CreateTab(name)
    return setmetatable({ _tab = self._win:Tab({ Title = tostring(name), Icon = Presentation.Icon(name) }), _path = tostring(name) }, TabMT)
end
function WindowMT:SetMenuKey(key)
    local k = keyFromString(key)
    if k then self._menuKey = k end
end
function WindowMT:SetLocked(locked)
    self._locked = locked and true or false
    self._lockedPosition = self._win.Main.Position
end
function WindowMT:SetTransparency(a, b)
    self._win.Main.BackgroundTransparency = math.clamp(tonumber(b or a) or 0, 0, 1)
end
function WindowMT:ShowGUI() self._win:Open() end
function WindowMT:HideGUI() self._win:Close() end
function WindowMT:Toggle() self._win:Minimize() end
function lib:CreateWindow(opts)
    opts = opts or {}
    local win = A2:CreateWindow({ Title = Presentation.Title, Author = opts.Subtitle or "", SidebarTitle = "MENU" })
    self._win = win
    Presentation.Mount(A2, win)
    win:AddSidePreview({ Title = "A2 â¢ LIVE", OffsetY = 34, Gap = 10, Width = 190, Height = 320 })
    self:SetWatermark({ Enabled = opts.Watermark ~= false })
    local window = setmetatable({ _win = win, _menuKey = Enum.KeyCode.RightShift }, WindowMT)
    if win._hotkeyConnection then win._hotkeyConnection:Disconnect() end
    local hotkey = UIS.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == window._menuKey then win:Minimize() end
    end)
    local positionLock = win.Main:GetPropertyChangedSignal("Position"):Connect(function()
        if window._locked and win._visible and win.Main.Position ~= window._lockedPosition then
            win.Main.Position = window._lockedPosition
        end
    end)
    win.Gui.Destroying:Connect(function() hotkey:Disconnect(); positionLock:Disconnect() end)
    for _, notification in ipairs(self._pendingNotifies) do self:Notify(notification) end
    self._pendingNotifies = {}
    return window
end

local v, Players, localPlayer, RunService, UserInputService, VirtualInputManager, ReplicatedStorage, CoreGui, playerGui, currentCamera, CollectionService, HttpService, tbl, tbl2, tbl3, flag, tbl4, fn, fn2, fn3
local fn4, fn5, fn6, fn7, fn8, v2, fn9, fn10, fn11

do
    lib.Scheme.AccentColor = Color3.fromRGB(255, 255, 255)
    lib.Scheme.BackgroundColor = Color3.fromRGB(10, 10, 12)
    lib.Scheme.MainColor = Color3.fromRGB(16, 16, 18)
    lib.Scheme.OutlineColor = Color3.fromRGB(255, 255, 255)
    lib.Scheme.FontColor = Color3.fromRGB(235, 235, 240)
    lib.Scheme.SubTextColor = Color3.fromRGB(140, 140, 150)
    lib.Scheme.HoverColor = Color3.fromRGB(22, 22, 26)

    v = lib:CreateWindow({
        Title = BRAND_NAME .. " HUB",
        Subtitle = "Violance District",
        SubtitleColor = Color3.fromRGB(190, 140, 255),
        Logo = BRAND_ASSET,
        LogoSize = 32,
        SphereText = false,
        SphereWords = "ZX",
        SphereImage = BRAND_ASSET,
        SphereIconSize = 38,
        Watermark = true,
        WatermarkText = BRAND_NAME .. " v7",
        WatermarkIcon = BRAND_ASSET,
    })

    Players = game:GetService("Players")
    localPlayer = Players.LocalPlayer
    RunService = game:GetService("RunService")
    UserInputService = game:GetService("UserInputService")
    VirtualInputManager = game:GetService("VirtualInputManager")
    local GuiService = game:GetService("GuiService")
    ReplicatedStorage = game:GetService("ReplicatedStorage")
    CoreGui = game:GetService("CoreGui")
    playerGui = localPlayer:WaitForChild("PlayerGui")
    currentCamera = workspace.CurrentCamera
    CollectionService = game:GetService("CollectionService")
    HttpService = game:GetService("HttpService")
    game:GetService("TeleportService")
    local TweenService = game:GetService("TweenService")
    _G.Ox = {}
    _G.Ox.AntiBlindEnabled = false
    _G.Ox.GotBlindedRemote = nil
    _G.Ox.NoSlowdownEnabled = false
    _G.Ox.BypassLeapEnabled = false
    _G.Ox.InfAbyssalEnabled = false
    _G.Ox.KILLER_SilentAimFlask = false
    _G.Ox.KILLER_FlaskLaser = false
    _G.Ox.NEX_CureFlaskLaserThread = nil
    _G.Ox.NEX_CureFlaskLaserPart = nil
    _G.Ox.InfiniteLungeEnabled = false

    local tbl5 = {
        ["122812055447896"] = "Veil lunge",
        ["133963973694098"] = "Mayers Basic",
        ["117042998468241"] = "Mayers lunge",
        ["135002183282873"] = "cure lunge",
        ["121216847022485"] = "cure Basic",
        ["132817836308238"] = "Jeff Basic",
        ["129784271201071"] = "Jeff lunge",
        ["82666958311998"] = "Jeff Frenzy",
        ["78432063483146"] = "Abyssal Basic",
        ["118907603246885"] = "Abyssal lunge",
        ["139369275981139"] = "Jason Basic",
        ["110355011987939"] = "Jason lunge",
        ["111920872708571"] = "Masked Basic",
        ["105374834496520"] = "Masked lunge",
        ["138720291317243"] = "Masked Tony",
        ["106871536134254"] = "Masked Alex",
        ["130593238885843"] = "Masked Cobra",
        ["115244153053858"] = "Masked Cobra lunge",
        ["74968262036854"] = "Hidden Basic",
        ["113255068724446"] = "Hidden lunge",
        ["98163597193511"] = "Hidden S1",
        ["80411309607666"] = "Abyssal S1",
    }

    _G.Ox.ParryConfig = {
        AutoParry = false,
        ParrySafety = false,
        ParryAggressive = false,
        ParryCircle = true,
        ParryRadius = 15,
        ParryFace = 0.7,
        AutoCrouch = false,
        Ignored_Skills = {},
    }

    _G.Ox.ParryV2 = {
        Enabled = false,
        SafetyParry = false,
        Mode = "Legit",
        Trigger = "Remote",
        Range = 12,
        KillerFace = 0.6,
        ShowCircle = true,
        IsOnCooldown = false,
        IsResolving = false,
        CooldownToken = 0,
        CooldownThread = nil,
        Attached = {},
        Gradients = {},
        Icon = nil,
        LockConnection = nil,
        ParryTrack = nil,
        RangeAdornment = nil,
        BtnCache = nil,
    }

    _G.Ox.ParryV2Anim = {
        Default = "rbxassetid://109133187196613",
        Shield = "rbxassetid://75939529748815",
        Robot = "rbxassetid://126894569253341",
        Katana = "rbxassetid://127096285501517",
        Fish = "rbxassetid://123307242865945",
        Watcher = "rbxassetid://81793464499285",
        Enten = "rbxassetid://127096285501517",
        BloodShield = "rbxassetid://75939529748815",
        Fih = "rbxassetid://123307242865945",
        Feedbacker = "rbxassetid://126894569253341",
        StopWatch = "rbxassetid://81793464499285",
    }

    _G.Ox.ParryV2AttackAnims = {
        ["rbxassetid://78432063483146"] = true,
        ["rbxassetid://121216847022485"] = true,
        ["rbxassetid://74968262036854"] = true,
        ["rbxassetid://132817836308238"] = true,
        ["rbxassetid://82666958311998"] = true,
        ["rbxassetid://111920872708571"] = true,
        ["rbxassetid://106871536134254"] = true,
        ["rbxassetid://109402730355822"] = true,
        ["rbxassetid://130593238885843"] = true,
        ["rbxassetid://138720291317243"] = true,
        ["rbxassetid://139369275981139"] = true,
        ["rbxassetid://133963973694098"] = true,
        ["rbxassetid://78935059863801"] = true,
        ["rbxassetid://118907603246885"] = true,
        ["rbxassetid://135002183282873"] = true,
        ["rbxassetid://113255068724446"] = true,
        ["rbxassetid://129784271201071"] = true,
        ["rbxassetid://105374834496520"] = true,
        ["rbxassetid://117070354890871"] = true,
        ["rbxassetid://115244153053858"] = true,
        ["rbxassetid://110355011987939"] = true,
        ["rbxassetid://117042998468241"] = true,
        ["rbxassetid://122812055447896"] = true,
    }

    _G.Ox._V2RayParams = RaycastParams.new()
    _G.Ox._V2RayParams.FilterType = Enum.RaycastFilterType.Exclude
    _G.Ox._V2ParryRangeRay = RaycastParams.new()
    _G.Ox._V2ParryRangeRay.FilterType = Enum.RaycastFilterType.Exclude
    _G.Ox._V2ParryLastRadius = -1
    _G.Ox._V2ParryLastRoot = nil
    _G.Ox.AttachedParry = {}

    if not _G.Ox.State then
        _G.Ox.State = {}
    end

    _G.Ox.State.ParryCooldown = false
    _G.Ox.State.ParryCooldownTime = 60
    _G.Ox.State.AutoParryAdornment = nil
    _G.Ox.State.ParryCooldownThread = nil
    _G.Ox.AutoParryCustom = {Gui = nil, IsActive = false, GuiVisible = false}
    local ox = _G.Ox
    local parryHUD = _G.Ox.ParryHUD
    local v3 = parryHUD

    if not parryHUD then
        local tbl6 = {}
        v3 = tbl6
        tbl6.gradients = {}
        tbl6.icon = nil
        tbl6.rescanConn = nil
        tbl6.cachedIconColor = nil
    end

    ox.ParryHUD = v3
    ParryHUD = _G.Ox.ParryHUD

    IsDowned = function(arg)
        if not arg then
            return false
        end
        local flag2 = arg:GetAttribute("Knocked") == true or arg:GetAttribute("IsHooked") == true
        return flag2
    end

    IsKiller = function(arg)
        local flag2 = arg and arg.Team and arg.Team.Name == "Killer"
        return flag2
    end

    TriggerCrouch = function()
        pcall(function()
            local playerGui2 = localPlayer:FindFirstChild("PlayerGui")

            for match in string.gmatch("Survivor-mob.Controls.crouch.icon", "[^%.]+") do
                if playerGui2 then
                    playerGui2 = playerGui2:FindFirstChild(match)
                end
            end

            if playerGui2 and playerGui2:IsA("GuiObject") and playerGui2.Visible and playerGui2.Parent and playerGui2.Parent:IsA("GuiButton") then
                local parent = playerGui2.Parent

                if UserInputService.TouchEnabled and type(firesignal) == "function" then
                    firesignal(parent.MouseButton1Click)
                    task.wait(1.4)
                    firesignal(parent.MouseButton1Click)
                else
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
                    task.wait(1.4)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
                end
            else
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
                task.wait(1.4)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
            end
        end)
    end

    IsSafeToParry = function(arg)
        if not _G.Ox.ParryConfig.ParrySafety then
            return true
        end

        if not arg then
            return false
        end
        local checkInterractable = arg:FindFirstChild("CheckInterractable")

        if checkInterractable then
            if checkInterractable:GetAttribute("isVaulting") == true then
                return false
            end

            if checkInterractable:GetAttribute("isRepairing") == true then
                return false
            end

            if checkInterractable:GetAttribute("isUnhooking") == true then
                return false
            end

            if checkInterractable:GetAttribute("isHealing") == true then
                return false
            end

            if checkInterractable:GetAttribute("isSliding") == true then
                return false
            end
        end

        return true
    end

    tapMobileParryButton = function()
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return
        end
        local survivorMob = playerGui2:FindFirstChild("Survivor-mob")
        local guiMob = survivorMob and survivorMob:FindFirstChild("Controls") and survivorMob.Controls:FindFirstChild("Gui-mob")

        if guiMob and guiMob.Visible then
            if firesignal then
                pcall(function()
                    firesignal(guiMob.MouseButton1Down)
                    task.wait(0.01)
                    firesignal(guiMob.MouseButton1Up)
                end)
            end
        else
            pcall(function()
                if not mouse2click then
                    if mouse2press and mouse2release then
                        mouse2press()
                        task.wait(0.01)
                        mouse2release()
                        return
                    end

                    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
                    task.wait(0.01)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
                    return
                end

                mouse2click()
            end)
        end
    end

    ExecuteParry = function()
        if _G.Ox.State.ParryCooldown then
            return
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local items = remotes and remotes:FindFirstChild("Items")
        local parryingDagger = items and items:FindFirstChild("Parrying Dagger")
        local parry = parryingDagger and parryingDagger:FindFirstChild("parry")

        if parry then
            for i = 1, 8 do
                parry:FireServer()
            end
        end

        task.spawn(tapMobileParryButton)
    end

    ParryHUD.Scan = function()
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return false
        end
        table.clear(ParryHUD.gradients)
        ParryHUD.icon = nil

        for i, v4 in ipairs({"Survivor", "Survivor-con"}) do
            local v5 = playerGui2:FindFirstChild(v4)

            if v5 then
                local gen = v5:FindFirstChild("Gen")
                local itemFrame = gen and gen:FindFirstChild("ItemFrame")

                if itemFrame then
                    local gui = itemFrame:FindFirstChild("Gui")
                    local bar = gui and gui:FindFirstChild("Bar")
                    local uiGradient = bar and bar:FindFirstChild("UIGradient")

                    if uiGradient then
                        table.insert(ParryHUD.gradients, uiGradient)
                    end

                    local icon = itemFrame:FindFirstChild("icon")

                    if icon then
                        ParryHUD.icon = icon
                    end
                end
            end
        end

        local survivorMob = playerGui2:FindFirstChild("Survivor-mob")
        local controls = survivorMob and survivorMob:FindFirstChild("Controls")

        if controls then
            for i, child in ipairs(controls:GetChildren()) do
                if child:IsA("ImageButton") and child.Name == "Gui-mob" then
                    local bar = child:FindFirstChild("Bar")
                    local uiGradient = bar and bar:FindFirstChild("UIGradient")

                    if uiGradient then
                        table.insert(ParryHUD.gradients, uiGradient)
                    end
                end
            end
        end

        local flag2 = #ParryHUD.gradients > 0 or ParryHUD.icon ~= nil
        return flag2
    end

    ParryHUD.SetColor = function(cachedIconColor)
        if #ParryHUD.gradients == 0 and not ParryHUD.icon then
            ParryHUD.Scan()
        end

        ParryHUD.cachedIconColor = cachedIconColor

        for i, gradient in ipairs(ParryHUD.gradients) do
            if gradient and gradient.Parent and gradient.Parent.Parent then
                local icon = gradient.Parent.Parent:FindFirstChild("icon")

                if icon then
                    icon.ImageColor3 = cachedIconColor
                end

                local gui = gradient.Parent.Parent:FindFirstChild("Gui")

                if gui then
                    gui.ImageColor3 = cachedIconColor
                end
            end
        end

        if ParryHUD.icon then
            ParryHUD.icon.ImageColor3 = cachedIconColor
        end
    end

    ParryHUD.Tween = function(arg)
        if #ParryHUD.gradients == 0 then
            ParryHUD.Scan()
        end

        for i, gradient in ipairs(ParryHUD.gradients) do
            if gradient and gradient.Parent then
                gradient.Offset = Vector2.new(0, 0.75)
                local tween = TweenService:Create(gradient, TweenInfo.new(arg, Enum.EasingStyle.Linear), {Offset = Vector2.new(0, 0.25)})
                tween:Play()

                tween.Completed:Connect(function()
                    if not _G.Ox.State.ParryCooldown then
                        ParryHUD.SetColor(Color3.fromRGB(255, 255, 255))
                    end
                end)
            end
        end
    end

    ParryHUD.Reset = function()
        ParryHUD.SetColor(Color3.fromRGB(255, 255, 255))

        for i, gradient in ipairs(ParryHUD.gradients) do
            if gradient and gradient.Parent then
                gradient.Offset = Vector2.new(0, 0.25)
            end
        end
    end

    ParryHUD.SetupWatcher = function()
        if ParryHUD.rescanConn then
            ParryHUD.rescanConn:Disconnect()
        end

        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return
        end

        ParryHUD.rescanConn = playerGui2.ChildAdded:Connect(function(child)
            local name = child.Name

            if name == "Survivor" or name == "Survivor-con" or name == "Survivor-mob" then
                task.wait(0.3)
                ParryHUD.Scan()

                if _G.Ox.State.ParryCooldown and ParryHUD.cachedIconColor then
                    ParryHUD.SetColor(ParryHUD.cachedIconColor)
                end
            end
        end)

        task.spawn(function()
            local n = 0

            while n < 10 and not ParryHUD.Scan() do
                task.wait(0.5)
                n = n + 0.5
            end
        end)
    end

    ParryHUD.SetupWatcher()

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1.5)
        ParryHUD.Scan()

        if _G.Ox.State.ParryCooldown and ParryHUD.cachedIconColor then
            ParryHUD.SetColor(ParryHUD.cachedIconColor)
        end
    end)

    ListenToParryResult = function()
        task.spawn(function()
            local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
            local parryingDagger = remotes and remotes:WaitForChild("Items", 5):WaitForChild("Parrying Dagger", 5)
            local parryResult = parryingDagger and parryingDagger:WaitForChild("parryResult", 5)

            if parryResult then
                parryResult.OnClientEvent:Connect(function(arg, arg2)
                    local num = tonumber(arg2)
                    local n = num or (arg == true and 90 or 60)
                    _G.Ox.State.ParryCooldown = true

                    if _G.Ox.State.ParryCooldownThread then
                        task.cancel(_G.Ox.State.ParryCooldownThread)
                    end

                    ParryHUD.SetColor(Color3.fromRGB(77, 77, 77))
                    ParryHUD.Tween(n)

                    _G.Ox.State.ParryCooldownThread = task.delay(n, function()
                        _G.Ox.State.ParryCooldown = false
                        ParryHUD.SetColor(Color3.fromRGB(255, 255, 255))
                    end)
                end)
            end
        end)
    end

    ListenToParryResult()

    IsInKillerPOV = function(arg, arg2, arg3)
        if not arg or not arg2 then
            return false
        end
        local n = arg2.Position - arg.Position
        local vector = Vector3.new(n.X, 0, n.Z)
        if vector.Magnitude < 0.15 then
            return true
        end
        local vector2 = Vector3.new(arg.CFrame.LookVector.X, 0, arg.CFrame.LookVector.Z)
        if vector2.Magnitude < 0.05 then
            return false
        end
        local v4 = vector2.Unit:Dot(vector.Unit)
        local n2 = arg3 or 0.35
        local flag2 = n2 <= v4
        return flag2
    end

    AttachParrySensor = function(arg)
        if not arg or _G.Ox.AttachedParry[arg] then
            return
        end
        _G.Ox.AttachedParry[arg] = true
        local humanoid = arg:WaitForChild("Humanoid", 5)
        if not humanoid then
            return
        end
        local animator = humanoid:FindFirstChildOfClass("Animator")
        local animator2 = animator or humanoid:WaitForChild("Animator", 5)
        if not animator2 then
            return
        end

        humanoid.ChildAdded:Connect(function(child)
            if child:IsA("Animator") then
                _G.Ox.AttachedParry[arg] = nil
                AttachParrySensor(arg)
            end
        end)

        arg.AncestryChanged:Connect(function(child, parent)
            if not parent then
                _G.Ox.AttachedParry[arg] = nil
            end
        end)

        animator2.AnimationPlayed:Connect(function(arg2)
            local animation = arg2.Animation
            local animationId = animation and arg2.Animation.AnimationId or ""
            local match = animationId:match("%d+")
            local v4 = tbl5[match]
            if not v4 then
                return
            end

            if match == "80411309607666" and _G.Ox.ParryConfig.AutoCrouch then
                local character = localPlayer.Character
                if IsDowned(character) then
                    return
                end
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart and humanoidRootPart2 and (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude <= 40 then
                    TriggerCrouch()
                end

                return
            end

            if not _G.Ox.ParryConfig.AutoParry then
                return
            end

            if _G.Ox.State.ParryCooldown then
                return
            end

            if _G.Ox.ParryConfig.Ignored_Skills and _G.Ox.ParryConfig.Ignored_Skills[v4] then
                return
            end
            local character = localPlayer.Character
            if IsDowned(character) or not IsSafeToParry(character) then
                return
            end
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart or not humanoidRootPart2 then
                return
            end
            local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude
            local parryFace = _G.Ox.ParryConfig.ParryFace

            if parryFace < 0.2 then
                parryFace = 0.35
            end

            -- ============ FIX ANTI FAKE HIT (v13.1) ============
            -- BUG LAMA: kalau radius <= 14 (smallCircle), cek anti-fake
            -- DILEWATI TOTAL -> animasi attack APA PUN termasuk FAKE HIT
            -- (killer pakai AdjustWeight(0)) tetap ke-parry.
            -- Sekarang anti-fake SELALU jalan di radius berapa pun.
            -- smallCircle tetap dipakai HANYA untuk hitung jangkauan, bukan
            -- untuk melewati cek anti-fake.
            local smallCircle = _G.Ox.ParryConfig.ParryRadius <= 14
            local function killerFacingMe()
                if not humanoidRootPart2 or not humanoidRootPart2.Parent then return false end
                local toMe = humanoidRootPart.Position - humanoidRootPart2.Position
                if toMe.Magnitude < 0.15 then return true end
                local flat = Vector3.new(toMe.X, 0, toMe.Z)
                if flat.Magnitude < 0.05 then return true end
                local unit = flat.Unit
                -- baca 3D: ROOT + BADAN + MATA (bukan cuma root)
                local parts = {
                    humanoidRootPart2,
                    arg:FindFirstChild("UpperTorso"),
                    arg:FindFirstChild("Torso"),
                    arg:FindFirstChild("Head"),
                }
                for _, part in ipairs(parts) do
                    if part and part:IsA("BasePart") then
                        local lv = part.CFrame.LookVector
                        local flatLv = Vector3.new(lv.X, 0, lv.Z)
                        if flatLv.Magnitude > 0.05 and flatLv.Unit:Dot(unit) >= parryFace then
                            return true
                        end
                    end
                end
                return false
            end

            local function facingOk()
                return killerFacingMe()
            end

            -- Fake attack = animasi attack jalan tapi bobot ~0 (AdjustWeight(0)).
            -- Kalau bobot sudah jelas >= 0.15 (atau tidak terbaca) -> HIT ASLI.
            -- Kalau masih ~0, pantau sebentar: naik -> HIT ASLI (parry),
            -- tetap ~0 / animasi selesai -> FAKE (JANGAN parry).
            local function parryIfReal(track)
                if _G.Ox.State.ParryCooldown or IsDowned(character) then return end
                if not humanoidRootPart or not humanoidRootPart.Parent then return end
                if not humanoidRootPart2 or not humanoidRootPart2.Parent then return end
                if not killerFacingMe() then return end

                local w = track and track.WeightCurrent
                if type(w) ~= "number" or w >= 0.15 then
                    ExecuteParry()
                    return
                end

                task.spawn(function()
                    local t0 = os.clock()
                    while os.clock() - t0 < 0.15 do
                        if _G.Ox.State.ParryCooldown or IsDowned(character) then return end
                        if not humanoidRootPart or not humanoidRootPart.Parent then return end
                        if not humanoidRootPart2 or not humanoidRootPart2.Parent then return end
                        local w2 = track and track.WeightCurrent
                        if type(w2) == "number" and w2 >= 0.15 then
                            if killerFacingMe() then ExecuteParry() end
                            return
                        end
                        if track and track.IsPlaying == false then
                            return -- animasi selesai tanpa bobot -> FAKE
                        end
                        task.wait(0.02)
                    end
                end)
            end

            if _G.Ox.ParryConfig.ParryAggressive then
                if _G.Ox.ParryConfig.ParryRadius + 5 < magnitude then
                    return
                end

                local function fn12()
                    if _G.Ox.State.ParryCooldown or IsDowned(character) then
                        return true
                    end

                    if not humanoidRootPart or not humanoidRootPart2 or not humanoidRootPart.Parent or not humanoidRootPart2.Parent then
                        return true
                    end

                    if (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude > 12 or not facingOk() then
                        return false
                    end
                    parryIfReal(arg2)
                    return true
                end

                if fn12() then
                    return
                end
                local connection = nil
                local now = os.clock()

                connection = RunService.Heartbeat:Connect(function()
                    if (os.clock() - now >= 0.9 or fn12()) and connection then
                        connection:Disconnect()
                    end
                end)
            else
                local n = _G.Ox.ParryConfig.ParryRadius + (smallCircle and 4 or 2)
                if _G.Ox.ParryConfig.ParryRadius + 6 < magnitude then
                    return
                end

                if magnitude <= n and facingOk() then
                    parryIfReal(arg2)
                    return
                end
                local now = os.clock()
                local connection = nil

                connection = RunService.Heartbeat:Connect(function()
                    if os.clock() - now < 0.9 and not _G.Ox.State.ParryCooldown and humanoidRootPart and humanoidRootPart2 and humanoidRootPart.Parent and humanoidRootPart2.Parent and not IsDowned(character) then
                        if (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude <= n and facingOk() then
                            parryIfReal(arg2)

                            if connection then
                                connection:Disconnect()
                            end
                        end

                        return
                    end

                    if connection then
                        connection:Disconnect()
                    end
                end)
            end
        end)
    end

    TryAttachParry = function(arg)
        if arg ~= localPlayer and IsKiller(arg) and arg.Character then
            AttachParrySensor(arg.Character)
        end
    end

    SetupPlayerParry = function(arg)
        if arg == localPlayer then
            return
        end

        arg.CharacterAdded:Connect(function()
            TryAttachParry(arg)
        end)

        arg:GetPropertyChangedSignal("Team"):Connect(function()
            TryAttachParry(arg)
        end)

        if arg.Character then
            TryAttachParry(arg)
        end
    end

    for i, player in ipairs(Players:GetPlayers()) do
        SetupPlayerParry(player)
    end

    Players.PlayerAdded:Connect(SetupPlayerParry)

    V2_HasParryingDagger = function()
        local character = localPlayer.Character
        if not character then
            return false
        end

        if character:FindFirstChild("Parrying Dagger") then
            return true
        end

        for i, child in ipairs(character:GetChildren()) do
            if child.Name == "Parrying Dagger" and (child:IsA("Tool") or child:IsA("Accessory") or child:IsA("Model")) then
                return true
            end
        end

        return false
    end

    V2_IsBusy = function()
        local character = localPlayer.Character
        if not character then
            return true
        end

        if localPlayer:GetAttribute("IsDead") then
            return true
        end

        if character:GetAttribute("IsCarried") then
            return true
        end

        if character:GetAttribute("IsHooked") then
            return true
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and CollectionService:HasTag(humanoidRootPart, "doing action") then
            return true
        end

        if IsDowned(character) then
            return true
        end
        local checkInterractable = character:FindFirstChild("CheckInterractable")

        if checkInterractable then
            if checkInterractable:GetAttribute("isVaulting") then
                return true
            end

            if checkInterractable:GetAttribute("isSliding") then
                return true
            end

            if checkInterractable:GetAttribute("isDroppingPallet") then
                return true
            end

            if checkInterractable:GetAttribute("isRepairing") then
                return true
            end

            if checkInterractable:GetAttribute("isHealing") then
                return true
            end

            if checkInterractable:GetAttribute("isUnhooking") then
                return true
            end

            if checkInterractable:GetAttribute("isExiting") then
                return true
            end
        end

        return false
    end

    V2_IsLowHealth = function()
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return true
        end
        local flag2 = humanoid.Health < humanoid.MaxHealth * 0.5
        return flag2
    end

    V2_CanParry = function()
        local parryV2 = _G.Ox.ParryV2
        if not parryV2.Enabled then
            return false
        end

        if not V2_HasParryingDagger() then
            return false
        end

        if parryV2.IsOnCooldown then
            return false
        end

        if parryV2.IsResolving then
            return false
        end

        if parryV2.SafetyParry and V2_IsBusy() then
            return false
        end

        if not V2_IsLowHealth() then
            return true
        end
        return false
    end

    V2_HasLOS = function(arg)
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoidRootPart2 = arg and arg:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart or not humanoidRootPart2 then
            return false
        end
        local position = humanoidRootPart2.Position
        local n = humanoidRootPart.Position - position
        local magnitude = n.Magnitude
        if magnitude < 0.1 then
            return true
        end
        _G.Ox._V2RayParams.FilterDescendantsInstances = {arg, character}
        local flag2

        if workspace:Raycast(position, n.Unit * magnitude, _G.Ox._V2RayParams) then
            flag2 = false
        else
            flag2 = true
        end

        return flag2
    end

    V2_IsBtnValid = function(arg)
        if not arg or not arg.Parent then
            return false
        end

        local ok, result = pcall(function()
            if not arg:IsA("GuiButton") and not arg:IsA("ImageButton") and not arg:IsA("TextButton") then
                return false
            end

            if arg.Visible == false then
                return false
            end

            if arg.AbsoluteSize.X < 4 or arg.AbsoluteSize.Y < 4 then
                return false
            end
            local parent = arg.Parent
            local playerGui2 = localPlayer:FindFirstChild("PlayerGui")

            while parent and parent ~= playerGui2 do
                if parent:IsA("GuiObject") and parent.Visible == false then
                    return false
                end
                parent = parent.Parent
            end

            return true
        end)

        local flag2 = ok and result == true
        return flag2
    end

    V2_FindParryButton = function()
        local parryV2 = _G.Ox.ParryV2
        if parryV2.BtnCache and V2_IsBtnValid(parryV2.BtnCache) then
            return parryV2.BtnCache
        end
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return nil
        end

        local v4, v5, v6 = ipairs({
            {"Survivor-mob", "Controls", "Gui-mob"},
            {"SurvivorMob", "Controls", "GuiMob"},
            {"Survivor-mob", "Controls", "GuiMob"},
        })

        local v7 = v6
        local v8 = v4
        local v9 = v5

        while true do
            local v10, v11 = v8(v9, v7)
            if v10 == nil then
                break
            end
            local v12 = playerGui2

            for i, v13 in ipairs(v11) do
                local v14 = v12 and v12:FindFirstChild(v13)
                v12 = v14
            end

            v7 = v10
            if v12 and V2_IsBtnValid(v12) then
                parryV2.BtnCache = v12
                return v12
            end
        end

        return nil
    end

    V2_TriggerByButton = function()
        local v4 = V2_FindParryButton()

        if not v4 then
            pcall(function()
                local mouseLocation = UserInputService:GetMouseLocation()
                VirtualInputManager:SendMouseButtonEvent(mouseLocation.X, mouseLocation.Y, 1, true, game, 0)

                task.delay(0.06, function()
                    local mouseLocation2 = UserInputService:GetMouseLocation()
                    VirtualInputManager:SendMouseButtonEvent(mouseLocation2.X, mouseLocation2.Y, 1, false, game, 0)
                end)
            end)

            return false
        end

        pcall(function()
            if type(firesignal) == "function" then
                firesignal(v4.MouseButton1Down)

                task.delay(0.06, function()
                    pcall(function()
                        firesignal(v4.MouseButton1Up)

                        if v4.MouseButton1Click then
                            firesignal(v4.MouseButton1Click)
                        end
                    end)
                end)
            else
                local absolutePosition = v4.AbsolutePosition
                local absoluteSize = v4.AbsoluteSize
                local guiInset = GuiService:GetGuiInset()
                local n = absolutePosition.X + absoluteSize.X / 2 + guiInset.X
                local n2 = absolutePosition.Y + absoluteSize.Y / 2 + guiInset.Y
                local n3 = 9901 + math.random(1, 400)
                VirtualInputManager:SendTouchEvent(n3, 0, n, n2)

                task.delay(0.06, function()
                    pcall(function()
                        VirtualInputManager:SendTouchEvent(n3, 2, n, n2)
                    end)
                end)
            end
        end)

        return true
    end

    V2_SetIconsColor = function(imageColor3)
        local parryV2 = _G.Ox.ParryV2

        if #parryV2.Gradients == 0 then
            if ParryHUD and ParryHUD.Scan then
                ParryHUD.Scan()
            end

            local v4 = ParryHUD
            local gradients = v4 and ParryHUD.gradients or {}
            parryV2.Gradients = gradients
            local v5 = ParryHUD
            local icon = v5 and ParryHUD.icon or nil
            parryV2.Icon = icon
        end

        for i, gradient in ipairs(parryV2.Gradients) do
            if gradient and gradient.Parent and gradient.Parent.Parent then
                local icon = gradient.Parent.Parent:FindFirstChild("icon")

                if icon then
                    icon.ImageColor3 = imageColor3
                end

                local gui = gradient.Parent.Parent:FindFirstChild("Gui")

                if gui then
                    gui.ImageColor3 = imageColor3
                end
            end
        end

        if parryV2.Icon then
            parryV2.Icon.ImageColor3 = imageColor3
        end
    end

    V2_PlayCooldownTween = function(arg)
        local parryV2 = _G.Ox.ParryV2

        if #parryV2.Gradients == 0 then
            if ParryHUD and ParryHUD.Scan then
                ParryHUD.Scan()
            end

            local v4 = ParryHUD
            local gradients = v4 and ParryHUD.gradients or {}
            parryV2.Gradients = gradients
        end

        for i, gradient in ipairs(parryV2.Gradients) do
            if gradient and gradient.Parent then
                gradient.Offset = Vector2.new(0, 0.75)
                local tween = TweenService:Create(gradient, TweenInfo.new(arg, Enum.EasingStyle.Linear), {Offset = Vector2.new(0, 0.25)})
                tween:Play()

                tween.Completed:Connect(function()
                    if not parryV2.IsOnCooldown then
                        V2_SetIconsColor(Color3.fromRGB(255, 255, 255))
                    end
                end)
            end
        end
    end

    V2_StartCooldown = function(arg)
        local parryV2 = _G.Ox.ParryV2
        parryV2.CooldownToken = parryV2.CooldownToken + 1
        local cooldownToken = parryV2.CooldownToken
        parryV2.IsResolving = false
        parryV2.IsOnCooldown = true
        V2_SetIconsColor(Color3.fromRGB(77, 77, 77))
        V2_PlayCooldownTween(arg)

        if parryV2.CooldownThread then
            task.cancel(parryV2.CooldownThread)
        end

        parryV2.CooldownThread = task.delay(arg, function()
            if parryV2.CooldownToken == cooldownToken then
                parryV2.IsOnCooldown = false
                V2_SetIconsColor(Color3.fromRGB(255, 255, 255))
                parryV2.CooldownThread = nil
            end
        end)
    end

    V2_ResetCooldown = function()
        local parryV2 = _G.Ox.ParryV2

        if parryV2.CooldownThread then
            task.cancel(parryV2.CooldownThread)
            parryV2.CooldownThread = nil
        end

        parryV2.IsOnCooldown = false
        parryV2.IsResolving = false
        V2_SetIconsColor(Color3.fromRGB(255, 255, 255))
    end

    V2_FaceLookDirection = function()
        local currentCamera2 = workspace.CurrentCamera
        if not currentCamera2 then
            return
        end
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart or not humanoidRootPart.Parent then
            return
        end
        local character2 = localPlayer.Character
        local humanoid = character2 and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        local lookVector = currentCamera2.CFrame.LookVector
        local vector = Vector3.new(lookVector.X, 0, lookVector.Z)
        if vector.Magnitude <= 0 then
            return
        end
        local cframe = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + vector.Unit)
        TweenService:Create(humanoidRootPart, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = cframe}):Play()

        if humanoid then
            humanoid.AutoRotate = false
        end

        local parryV2 = _G.Ox.ParryV2

        if parryV2.LockConnection then
            parryV2.LockConnection:Disconnect()
        end

        local now = tick()

        parryV2.LockConnection = RunService.Heartbeat:Connect(function()
            if tick() - now >= 0.8 then
                if parryV2.LockConnection then
                    parryV2.LockConnection:Disconnect()
                    parryV2.LockConnection = nil
                end

                if humanoid then
                    humanoid.AutoRotate = true
                end

                return
            end

            if humanoidRootPart and humanoidRootPart.Parent then
                humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + vector.Unit)
            elseif parryV2.LockConnection then
                parryV2.LockConnection:Disconnect()
                parryV2.LockConnection = nil
            end
        end)
    end

    V2_MatchParrySkin = function(arg)
        if type(arg) ~= "string" or arg == "" then
            return nil
        end
        local parryV2Anim = _G.Ox.ParryV2Anim
        if not parryV2Anim then
            return nil
        end

        if parryV2Anim[arg] then
            return parryV2Anim[arg]
        end
        local str = string.lower(arg):gsub("^equippedskin[_%-]?", ""):gsub("^skin[_%-]?", ""):gsub("[_%-]?parrying[_%-]?dagger", ""):gsub("[_%-]?dagger", ""):gsub("%s+", "")

        for k, v4 in pairs(parryV2Anim) do
            local v5 = string.lower(k)
            if v5 == str or string.find(str, v5, 1, true) or string.find(v5, str, 1, true) then
                return v4
            end
        end

        return nil
    end

    V2_ScanSkinFromInstance = function(arg)
        if not arg then
            return nil
        end

        for i, v4 in ipairs({
            "EquippedSkin_Parrying_Dagger",
            "EquippedSkin_ParryingDagger",
            "EquippedSkin",
            "ParryingDaggerSkin",
            "ParrySkin",
            "Skin",
            "SkinName",
            "CurrentSkin",
            "EquippedSkinName",
        }) do
            local attribute = arg:GetAttribute(v4)
            local v5 = V2_MatchParrySkin(attribute)
            if v5 then
                return v5
            end
        end

        local ok, result = pcall(function()
            return arg:GetAttributes()
        end)

        if ok and type(result) == "table" then
            for k, v4 in pairs(result) do
                if type(k) == "string" and type(v4) == "string" then
                    local v5 = string.lower(k)
                    if not v5:find("skin") and not v5:find("parry") then
                        continue
                    end
                    local v6 = V2_MatchParrySkin(v4)
                    if v6 then
                        return v6
                    end
                end
            end
        end

        return nil
    end

    V2_ResolveAnimId = function()
        local character = localPlayer.Character

        if character then
            local v4 = V2_ScanSkinFromInstance(character)
            if v4 then
                return v4
            end
            local parryingDagger = character:FindFirstChild("Parrying Dagger")
            local parryingDagger2 = parryingDagger or character:FindFirstChild("ParryingDagger") or character:FindFirstChild("parrying dagger")

            if parryingDagger2 then
                local v5 = V2_ScanSkinFromInstance(parryingDagger2)
                if v5 then
                    return v5
                end

                for i, descendant in ipairs(parryingDagger2:GetDescendants()) do
                    if not descendant:IsA("StringValue") and (not descendant:IsA("ValueBase") or type(descendant.Value) ~= "string") then
                        continue
                    end
                    local v6 = V2_MatchParrySkin(tostring(descendant.Value))
                    if v6 then
                        return v6
                    end
                end
            end

            local backpack = localPlayer:FindFirstChild("Backpack")

            if backpack then
                local parryingDagger3 = backpack:FindFirstChild("Parrying Dagger")
                local parryingDagger4 = parryingDagger3 or backpack:FindFirstChild("ParryingDagger")

                if parryingDagger4 then
                    local v5 = V2_ScanSkinFromInstance(parryingDagger4)
                    if v5 then
                        return v5
                    end
                end
            end
        end

        local v4 = V2_ScanSkinFromInstance(localPlayer)
        if not v4 then
            return _G.Ox.ParryV2Anim.Default
        end
        return v4
    end

    V2_PlayParryAnim = function()
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return
        end
        local parryV2 = _G.Ox.ParryV2

        if parryV2.ParryTrack then
            pcall(function()
                parryV2.ParryTrack:Stop(0.05)
            end)
        end

        pcall(function()
            local animation = Instance.new("Animation")
            animation.AnimationId = V2_ResolveAnimId()
            parryV2.ParryTrack = animator:LoadAnimation(animation)
            parryV2.ParryTrack.Priority = Enum.AnimationPriority.Action4
            parryV2.ParryTrack:Play()
        end)
    end

    V2_DoParry = function()
        if not V2_CanParry() then
            return
        end
        local parryV2 = _G.Ox.ParryV2
        parryV2.IsResolving = true
        V2_SetIconsColor(Color3.fromRGB(77, 77, 77))
        local trigger = parryV2.Trigger
        local str = trigger or "Remote"
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")

        if str == "Button" then
            V2_TriggerByButton()
        else
            local parryingDagger = remotes and remotes:FindFirstChild("Items") and remotes.Items:FindFirstChild("Parrying Dagger")
            local parry = parryingDagger and parryingDagger:FindFirstChild("parry")

            if parry then
                pcall(function()
                    parry:FireServer()
                end)
            end

            V2_FaceLookDirection()
            local character = localPlayer.Character
            local humanoid = character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.AutoRotate = false
            end

            V2_PlayParryAnim()
            local character2 = localPlayer.Character
            local humanoidRootPart = character2 and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                pcall(function()
                    CollectionService:AddTag(humanoidRootPart, "doing action")
                end)
            end

            local slow = remotes and remotes:FindFirstChild("Mechanics") and remotes.Mechanics:FindFirstChild("Slow")

            if slow then
                pcall(function()
                    slow:Fire(0, 1, 0)
                end)
            end
        end

        task.delay(2, function()
            if parryV2.IsResolving then
                parryV2.IsResolving = false
                local n = parryV2.Trigger == "Button" and 1.2 or 60
                V2_StartCooldown(n)
                local character = localPlayer.Character
                local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart then
                    pcall(function()
                        CollectionService:RemoveTag(humanoidRootPart, "doing action")
                    end)
                end
            end
        end)
    end

    task.spawn(function()
        local remotes = ReplicatedStorage:WaitForChild("Remotes", 8)
        local items = remotes and remotes:WaitForChild("Items", 5)
        local parryingDagger = items and items:WaitForChild("Parrying Dagger", 5)
        local parryResult = parryingDagger and parryingDagger:WaitForChild("parryResult", 5)
        if not parryResult then
            return
        end

        parryResult.OnClientEvent:Connect(function(arg, arg2)
            local parryV2 = _G.Ox.ParryV2
            if not parryV2.IsResolving then
                return
            end
            parryV2.IsResolving = false
            local num = tonumber(arg2)

            if num and num > 0 then
                V2_StartCooldown(num)
            elseif arg == true then
                V2_StartCooldown(90)
            else
                V2_StartCooldown(60)
            end

            local character = localPlayer.Character
            local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                pcall(function()
                    CollectionService:RemoveTag(humanoidRootPart, "doing action")
                end)
            end
        end)
    end)

    local cylinderHandleAdornment = Instance.new("CylinderHandleAdornment")
    cylinderHandleAdornment.Name = "OXIO_ParryRange_V2"
    local range = _G.Ox.ParryV2.Range
    local radius = range or 12
    cylinderHandleAdornment.Radius = radius
    local max = math.max
    local range2 = _G.Ox.ParryV2.Range
    local n = range2 or 12
    cylinderHandleAdornment.InnerRadius = max(0.1, n - 0.15)
    cylinderHandleAdornment.Height = 0.01
    cylinderHandleAdornment.Color3 = Color3.fromRGB(80, 80, 80)
    cylinderHandleAdornment.AlwaysOnTop = false
    cylinderHandleAdornment.Transparency = 1
    cylinderHandleAdornment.Adornee = workspace:FindFirstChildOfClass("Terrain")

    pcall(function()
        cylinderHandleAdornment.Parent = CoreGui
    end)

    if not cylinderHandleAdornment.Parent then
        pcall(function()
            cylinderHandleAdornment.Parent = localPlayer:WaitForChild("PlayerGui")
        end)
    end

    _G.Ox.ParryV2.RangeAdornment = cylinderHandleAdornment

    V2_UpdateRangeCircle = function()
        local parryV2 = _G.Ox.ParryV2
        local rangeAdornment = parryV2.RangeAdornment
        if not rangeAdornment then
            return
        end

        if parryV2.Enabled and parryV2.ShowCircle then
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

            if not humanoidRootPart then
                if rangeAdornment.Transparency ~= 1 then
                    rangeAdornment.Transparency = 1
                end

                return
            end

            local range3 = parryV2.Range
            local v2ParryLastRadius = range3 or 12
            if humanoidRootPart == _G.Ox._V2ParryLastRoot and v2ParryLastRadius == _G.Ox._V2ParryLastRadius then
                return
            end
            _G.Ox._V2ParryLastRoot = humanoidRootPart
            _G.Ox._V2ParryLastRadius = v2ParryLastRadius
            rangeAdornment.Transparency = 0.4
            rangeAdornment.Radius = v2ParryLastRadius
            rangeAdornment.InnerRadius = math.max(0.1, v2ParryLastRadius - 0.15)
            local v2ParryRangeRay = _G.Ox._V2ParryRangeRay
            v2ParryRangeRay.FilterDescendantsInstances = {character}
            local hit = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -15, 0), v2ParryRangeRay)
            local position = hit and hit.Position or humanoidRootPart.Position - Vector3.new(0, 3, 0)
            rangeAdornment.CFrame = CFrame.new(position + Vector3.new(0, 0.05, 0)) * CFrame.Angles(math.pi / 2, 0, 0)
            return
        end

        if rangeAdornment.Transparency ~= 1 then
            rangeAdornment.Transparency = 1
        end
    end

    V2_AttachParrySensor = function(arg)
        if not arg or _G.Ox.ParryV2.Attached[arg] then
            return
        end
        _G.Ox.ParryV2.Attached[arg] = true
        local humanoid = arg:FindFirstChild("Humanoid")
        local v4 = humanoid

        if not humanoid then
            local humanoid2 = arg:WaitForChild("Humanoid", 5)
            v4 = humanoid2
            if not humanoid2 then
                return
            end
        end

        local animator = v4:FindFirstChildOfClass("Animator")
        local v5 = animator

        if not animator then
            local animator2 = v4:WaitForChild("Animator", 5)
            v5 = animator2
            if not animator2 then
                return
            end
        end

        v4.ChildAdded:Connect(function(child)
            if child:IsA("Animator") then
                _G.Ox.ParryV2.Attached[arg] = nil
                V2_AttachParrySensor(arg)
            end
        end)

        arg.AncestryChanged:Connect(function(child, parent)
            if not parent then
                _G.Ox.ParryV2.Attached[arg] = nil
            end
        end)

        v5.AnimationPlayed:Connect(function(arg2)
            local animation = arg2.Animation
            local animationId = animation and arg2.Animation.AnimationId or ""
            if not _G.Ox.ParryV2AttackAnims[animationId] then
                return
            end
            local parryV2 = _G.Ox.ParryV2
            if not parryV2.Enabled then
                return
            end

            if not V2_HasParryingDagger() then
                return
            end

            if parryV2.IsOnCooldown or parryV2.IsResolving then
                return
            end
            local character = localPlayer.Character
            if not character then
                return
            end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart or not humanoidRootPart2 then
                return
            end
            local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude
            local mode = parryV2.Mode
            local str = mode or "Legit"
            local range3 = parryV2.Range
            local n2 = range3 or 12

            if str == "Aggressive" then
                if n2 + 3 < magnitude then
                    return
                end
                local num = tonumber(parryV2.KillerFace)
                local n3 = num or 0.6
                local n4 = math.clamp(n3, -1, 1)

                local function fn12()
                    local n5 = humanoidRootPart.Position - humanoidRootPart2.Position
                    local vector = Vector3.new(n5.X, 0, n5.Z)
                    if vector.Magnitude < 0.05 then
                        return true
                    end
                    local vector2 = Vector3.new(humanoidRootPart2.CFrame.LookVector.X, 0, humanoidRootPart2.CFrame.LookVector.Z)
                    if vector2.Magnitude < 0.05 then
                        return false
                    end
                    local v6 = vector2.Unit:Dot(vector.Unit)

                    local flag2 = (n2 <= 14) or (n4 <= v6)
                    return flag2
                end

                local function fn13()
                    if parryV2.IsOnCooldown or parryV2.IsResolving or not humanoidRootPart or not humanoidRootPart2 or not humanoidRootPart.Parent or not humanoidRootPart2.Parent then
                        return true
                    end

                    if (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude > n2 or not fn12() then
                        return false
                    end
                    V2_DoParry()
                    return true
                end

                if fn13() then
                    return
                end
                local connection = nil
                local now = os.clock()

                connection = RunService.Heartbeat:Connect(function()
                    if (os.clock() - now >= 1.5 or fn13()) and connection then
                        connection:Disconnect()
                    end
                end)
            else
                if n2 < magnitude then
                    return
                end

                if not V2_HasLOS(arg) then
                    return
                end

                local v2Small = (parryV2.Range or 12) <= 14
                local V2F = {}

                V2F.FacingOk = function()
                    if v2Small then
                        return true
                    end
                    local n3 = Vector3.new(humanoidRootPart.Position.X, 0, humanoidRootPart.Position.Z) - Vector3.new(humanoidRootPart2.Position.X, 0, humanoidRootPart2.Position.Z)
                    if n3.Magnitude <= 0 then
                        return true
                    end
                    local unit = n3.Unit
                    local vector = Vector3.new(humanoidRootPart2.CFrame.LookVector.X, 0, humanoidRootPart2.CFrame.LookVector.Z)
                    if vector.Magnitude <= 0 then
                        return true
                    end
                    local unit2 = vector.Unit
                    local num = tonumber(parryV2.KillerFace)
                    local n4 = num or 0.6
                    local n5 = math.clamp(n4, -1, 1)
                    return n5 <= unit2:Dot(unit)
                end

                V2F.StrictOk = function()
                    if str ~= "Strict" then
                        return true
                    end
                    local n3 = Vector3.new(humanoidRootPart.Position.X, 0, humanoidRootPart.Position.Z) - Vector3.new(humanoidRootPart2.Position.X, 0, humanoidRootPart2.Position.Z)
                    if n3.Magnitude <= 0 then
                        return true
                    end
                    local unit = n3.Unit
                    local currentCamera2 = workspace.CurrentCamera
                    local vector2 = nil

                    if currentCamera2 then
                        vector2 = Vector3.new(currentCamera2.CFrame.LookVector.X, 0, currentCamera2.CFrame.LookVector.Z)
                    end

                    if not vector2 or vector2.Magnitude < 0.05 then
                        vector2 = Vector3.new(humanoidRootPart.CFrame.LookVector.X, 0, humanoidRootPart.CFrame.LookVector.Z)
                    end

                    if vector2.Magnitude > 0 and vector2.Unit:Dot(-unit) < 0.5 then
                        return false
                    end
                    return true
                end

                V2F.Try = function()
                    if parryV2.IsOnCooldown or parryV2.IsResolving or not humanoidRootPart or not humanoidRootPart2 or not humanoidRootPart.Parent or not humanoidRootPart2.Parent then
                        return true
                    end
                    if (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude > n2 then
                        return false
                    end
                    if not V2F.FacingOk() then
                        return false
                    end
                    if not V2F.StrictOk() then
                        return false
                    end
                    V2_DoParry()
                    return true
                end

                if V2F.Try() then
                    return
                end
                local v2Conn = nil
                local v2Now = os.clock()

                v2Conn = RunService.Heartbeat:Connect(function()
                    if (os.clock() - v2Now >= 0.5 or V2F.Try()) and v2Conn then
                        v2Conn:Disconnect()
                    end
                end)
            end
        end)
    end

    V2_TryAttach = function(arg)
        if arg ~= localPlayer and arg.Team and arg.Team.Name == "Killer" and arg.Character then
            V2_AttachParrySensor(arg.Character)
        end
    end

    V2_SetupPlayer = function(arg)
        if arg == localPlayer then
            return
        end

        arg.CharacterAdded:Connect(function()
            V2_TryAttach(arg)
        end)

        arg:GetPropertyChangedSignal("Team"):Connect(function()
            V2_TryAttach(arg)
        end)

        if arg.Character then
            V2_TryAttach(arg)
        end
    end

    for k, player in pairs(Players:GetPlayers()) do
        V2_SetupPlayer(player)
    end

    Players.PlayerAdded:Connect(V2_SetupPlayer)

    RunService.Heartbeat:Connect(function()
        if _G.Ox.ParryV2 and _G.Ox.ParryV2.Enabled and _G.Ox.ParryV2.ShowCircle then
            _G.Ox._V2ParryLastRoot = nil
            V2_UpdateRangeCircle()
        elseif _G.Ox.ParryV2 and _G.Ox.ParryV2.RangeAdornment and _G.Ox.ParryV2.RangeAdornment.Transparency ~= 1 then
            _G.Ox.ParryV2.RangeAdornment.Transparency = 1
        end
    end)

    UpdateCustomParryGUI = function(arg)
        if not _G.Ox.AutoParryCustom.Gui then
            return
        end
        local frame = _G.Ox.AutoParryCustom.Gui:FindFirstChild("Frame")
        if not frame then
            return
        end
        local actionButton = frame:FindFirstChild("ActionButton")
        local uiStroke = frame:FindFirstChild("UIStroke")

        if arg then
            if actionButton then
                actionButton.Text = "PARRY [ON]"
                actionButton.TextColor3 = Color3.fromRGB(180, 255, 180)
                actionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            end

            if uiStroke then
                uiStroke.Color = Color3.fromRGB(100, 200, 100)
            end
        else
            if actionButton then
                actionButton.Text = "PARRY [OFF]"
                actionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                actionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            end

            if uiStroke then
                uiStroke.Color = Color3.fromRGB(90, 90, 95)
            end
        end
    end

    ToggleParryStatus = function()
        local parryConfig = _G.Ox.ParryConfig
        local autoParry

        if _G.Ox.ParryConfig.AutoParry then
            autoParry = false
        else
            autoParry = true
        end

        parryConfig.AutoParry = autoParry
        _G.Ox.AutoParryCustom.IsActive = _G.Ox.ParryConfig.AutoParry
        UpdateCustomParryGUI(_G.Ox.ParryConfig.AutoParry)
        local notify = lib.Notify
        local tbl6 = {Title = "Auto Parry"}
        local autoParry2 = _G.Ox.ParryConfig.AutoParry
        local description = autoParry2 and "Aktif" or "Nonaktif"
        tbl6.Description = description
        tbl6.Duration = 2
        notify(lib, tbl6)
    end

    CreateCustomParryGUI = function()
        if _G.Ox.AutoParryCustom.Gui then
            _G.Ox.AutoParryCustom.Gui:Destroy()
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AutoParryCustomGui"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = CoreGui
        screenGui.Enabled = false
        _G.Ox.AutoParryCustom.Gui = screenGui
        _G.Ox.AutoParryCustom.GuiVisible = false
        local frame = Instance.new("Frame", screenGui)
        frame.Name = "Frame"
        frame.Size = UDim2.fromOffset(110, 36)
        frame.Position = UDim2.fromScale(0.85, 0.35)
        frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        frame.BackgroundTransparency = 0.1
        frame.Active = true
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        local uiStroke = Instance.new("UIStroke", frame)
        uiStroke.Name = "UIStroke"
        uiStroke.Color = Color3.fromRGB(90, 90, 95)
        uiStroke.Thickness = 1.5
        uiStroke.Transparency = 0.2
        local textButton = Instance.new("TextButton", frame)
        textButton.Name = "ActionButton"
        textButton.Size = UDim2.new(1, 0, 1, 0)
        textButton.Text = "PARRY [OFF]"
        textButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 12
        textButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        textButton.BorderSizePixel = 0
        textButton.AutoButtonColor = false
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 8)
        local flag2 = false
        local flag3 = false
        local flag4 = false
        local position = nil
        local position2 = nil
        local thread = nil

        update = function(arg)
            if not flag2 or not flag4 or not position or not position2 then
                return
            end
            local n2 = arg.Position - position

            if not flag3 and (math.abs(n2.X) > 18 or math.abs(n2.Y) > 18) then
                flag3 = true
            end

            if flag3 then
                frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n2.X, position2.Y.Scale, position2.Y.Offset + n2.Y)
            end
        end

        textButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag2 = true
                flag3 = false
                flag4 = false
                position = input.Position
                position2 = frame.Position

                if thread then
                    task.cancel(thread)
                end

                thread = task.delay(0.18, function()
                    if flag2 then
                        flag4 = true
                    end
                end)
            end
        end)

        textButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if thread then
                    task.cancel(thread)
                end

                if flag2 and not flag3 then
                    ToggleParryStatus()
                end

                flag2 = false
                flag3 = false
                flag4 = false
                position = nil
                position2 = nil
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if flag2 and flag4 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)

        if _G.Ox.AutoParryCustom._statusConn then
            _G.Ox.AutoParryCustom._statusConn:Disconnect()
        end

        _G.Ox.AutoParryCustom._statusConn = RunService.Heartbeat:Connect(function()
            if _G.Ox.AutoParryCustom.Gui and _G.Ox.AutoParryCustom.Gui.Parent then
                if _G.Ox.AutoParryCustom.IsActive ~= _G.Ox.ParryConfig.AutoParry then
                    _G.Ox.AutoParryCustom.IsActive = _G.Ox.ParryConfig.AutoParry
                    UpdateCustomParryGUI(_G.Ox.ParryConfig.AutoParry)
                end

                return
            end

            if _G.Ox.AutoParryCustom._statusConn then
                _G.Ox.AutoParryCustom._statusConn:Disconnect()
            end
        end)
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1)

        if _G.Ox.AutoParryCustom.GuiVisible and _G.Ox.AutoParryCustom.Gui then
            _G.Ox.AutoParryCustom.Gui.Enabled = true
            UpdateCustomParryGUI(_G.Ox.ParryConfig.AutoParry)
        end
    end)

    task.spawn(function()
        task.wait(1.5)
        CreateCustomParryGUI()
    end)

    _G.Ox.InstantTPGate = {
        Enabled = false,
        GateClientModule = nil,
        oldGateNew = nil,
        oldGateCanUse = nil,
    }

    _G.Ox.KorlessMorph = {Enabled = false, Connection = nil}
    _G.Ox.SelfHeal = {Enabled = false}

    _G.Ox.AuraHeal = {Enabled = false, Radius = 30, Interval = 0.5, HealSelf = true, HealOthers = true}
    _G.Ox.FlowstateNoCD = {Enabled = false, Connection = nil, CharAddedConn = nil}
    _G.Ox.NoFall = {Enabled = false}
    _G.Ox.BulletBlockConfig = {Enabled = false}
    _G.Ox.BypassGate = {Enabled = false}
    _G.Ox.NextKiller = {Enabled = false, IndicatorGui = nil}

    _G.Ox.CounterParry = {
        Enabled = false,
        Distance = 15,
        Interval = 0.3,
        AnimId = "rbxassetid://117042998468241",
        Thread = nil,
        Track = nil,
    }

    _G.Ox.AutoStalk = {Enabled = false, Range = 150, Conn = nil, LastFire = 0}

    _G.Ox.Crosshair = {
        Enabled = false,
        Size = 8,
        Thickness = 2,
        Color = Color3.fromRGB(255, 255, 255),
        Style = "Dot",
        OffsetX = 0,
        OffsetY = 0,
    }

    _G.Ox.Spectator = {Enabled = false, Gui = nil, Label = nil}

    _G.Ox.Moonwalk = {
        Enabled = false,
        GuiVisible = false,
        Gui = nil,
        IsActive = false,

        SwaySpeed = 56,
        SwayAngle = 23,
        Counter = 0,
        DragLocked = false,
    }

    _G.Ox.CrosshairGui = nil
    _G.Ox.CrosshairElements = {}
    _G.Ox.CrosshairCreated = false
    _G.Ox.LastCrosshairStyle = nil
    local ox2 = _G.Ox
    local config = _G.Ox.Config
    local config2 = config or {}
    ox2.Config = config2
    _G.Ox.Config.Surv_PerfectVault = false
    _G.Ox.autoVaultEnabled = false
    _G.Ox.autoPalletSlideEnabled = false
    _G.Ox.lastActionTime = 0
    _G.Ox.COOLDOWN = 1.5
    _G.Ox.StreamerMode = {Enabled = false, SpooferConns = {}}
    _G.Ox.InfinityZoom = {Enabled = false}
    _G.Ox.StretchRes = {Enabled = false, Amount = 0.67, Conn = nil}
    _G.Ox.CameraFOV = {Enabled = false, Value = 90, Connection = nil}
    _G.Ox.Auto = {SkillCheck = false, SkillCheckMode = "Perfect"}
    _G.Ox.MapPredict = {Enabled = false}
    _G.Ox.KillerPerks = {Enabled = false, Gui = nil, Minimized = false}

    _G.Ox.Stun = {
        Enabled = false,
        Data = {},
        HitSoundEnabled = false,
        HitSoundVolume = 1,
        HitSoundId = "rbxassetid://106225491596534",
        HitSoundCooldown = 0.3,
        HitSoundLastTime = 0,
    }

    _G.Ox.GodMode = false
    _G.Ox.BypassGenEnabled = false
    _G.Ox.GenBoostSkillCheck = true
    _G.Ox.BypassGenMode = "Manual Repair"
    _G.Ox.RepairAnimTrack = nil
    _G.Ox.ProcessedGens = {}
    _G.Ox.AutoRepairEnabled = false
    _G.Ox.AutoRepairThread = nil
    _G.Ox.AutoCurrentPoint = nil
    _G.Ox.AutoCurrentGenModel = nil
    _G.Ox.LastFireTime = 0
    _G.Ox.AutoFireInterval = 0.5
    _G.Ox.ScriptAlive = true
    _G.Ox.BypassToggleValue = false
    _G.Ox.UnlimitedVaultEnabled = false
    local ox3 = _G.Ox
    local state = _G.Ox.State
    local state2 = state or {}
    ox3.State = state2
    _G.Ox.State.busy = false
    _G.Ox.State.RandomMode_IsNormal = false
    _G.Ox.Connections = {SkillHeartbeat = nil}
    _G.Ox.Speed = {Enabled = false, Value = 0.1, Connection = nil, Loop = nil}
    _G.Ox.AutoRun = {PC = false, Mobile = false, MobileThread = nil}

    _G.Ox.Utility = {
        InvisEnabled = false,
        BandageEnabled = false,
        BandageSpeed = 50,
    }

    _G.Ox.AntiHook = {
        Enabled = false,
        -- FIX ANTI HOOK: offset -250 bikin server anggap posisi kita di bawah
        -- map, jadi karakter ditarik balik ("dipindahin mundur"). Sekarang
        -- offset kecil (-6) dan rate wajar (12 Hz) biar tidak rubber-band.
        OffsetY = -6,
        Hz = 12,
        Interval = 1 / 12,
        Remote = nil,
        Connection = nil,
        Accumulator = 0,
        SendCounter = 0,
        LastCounterTime = os.clock(),
        WasHeld = false,
    }

    _G.Ox.ConfigData = {Surv_SkillFrequency = 10, Surv_SkillSpeed = 1}

    _G.Ox.Teleport = {
        GenIndex = 1,
        HookIndex = 1,
        GateIndex = 1,
        PalletIndex = 1,
        WindowIndex = 1,
    }

    tbl = {
        Generators = {},
        Hooks = {},
        Gates = {},
        Pallets = {},
        Windows = {},
    }

    tbl2 = {Enabled = false, Conn = nil}

    if not _G.Ox.State then
        _G.Ox.State = {}
    end

    _G.Ox.State.ThirdPersonConn = nil

    tbl3 = {
        ["Left Arm"] = true,
        ["Right Arm"] = true,
        LeftHand = true,
        RightHand = true,
        LeftLowerArm = true,
        RightLowerArm = true,
        LeftUpperArm = true,
        RightUpperArm = true,
    }

    _G.Ox.FakePerks = {
        QuickRecoveryEnabled = false,
        PerfectLandingEnabled = false,
        FlowstateEnabled = false,
        FakeAdrenalineRush = false,
        PerkCooldown = 10,
        boostActive = false,
        perfectLandingBoostActive = false,
        fsOnCooldown = false,
        lastQRTime = 0,
        lastPLTime = 0,
        lastFSTime = 0,
        qrConnection = nil,
        plConnection = nil,
        fsConnection = nil,
        fsAnimConnection = nil,
        adrenalineOn = false,
        adrenalineConns = {},
        lastARTime = 0,
    }

    _G.Ox.AutoPallet = {
        Enabled = false,
        Safety = true,
        Distance = 10,
        Cooldown = 2.5,
        LastDrop = 0,
        UsedPallets = {},
        Connection = nil,
    }

    _G.Ox.FullBright = false
    _G.Ox.NoFog = false
    _G.Ox.NoShadow = false
    _G.Ox.TimeOfDayValue = 14

    _G.Ox.LowGFX = {
        Enabled = false,
        Textures = true,
        VisualEffects = true,
        Particles = true,
        Parts = true,
        Sky = false,
        Saved = {},
    }

    _G.Ox.AimConfig = {
        Aim_SilentVeilV2 = false,
        Veil_ShowFOV = true,
        SpearSmart_enable = false,
        Veil_FOV = 150,
        SPEAR_Speed = 165,
        SPEAR_Gravity = 103,
        SPEAR_AuraSpeed = 165,
        SPEAR_AuraGravity = 96.5,
        SPEAR_MaxDist = 500,
        Veil_LeadMultiplier = 1.4,
        AIM_TargetPart = "Torso",
        Pistol_BlockKnocked = false,
        LockAim = false,
        Flash_Silent = false,
        Flash_YOffset = 1.5,
    }

    _G.Ox.SurvivorFOVFrame = nil
    _G.Ox.SurvivorFOVGui = nil
    _G.Ox.isAimbotHolding = false
    _G.Ox.lockedAimbotTarget = nil
    _G.Ox.survivorAimbotHighlight = nil
    _G.Ox.isKillerAimbotHolding = false
    _G.Ox.lockedKillerAimbotTarget = nil
    _G.Ox.killerAimbotHighlight = nil

    _G.Ox.Config = {
        SpearSmart_enable = false,
        Surv_Aimbot_Enabled = false,
        Surv_Aimbot_ShowFOV = true,
        Surv_Aimbot_Radius = 150,
        Surv_Aimbot_MaxDist = 300,
        Surv_Aimbot_Smoothness = 0.5,
        Surv_Aimbot_Predict = 0.01,
        Killer_Aimbot_Enabled = false,
        Killer_Aimbot_MaxDist = 12,
        Killer_Aimbot_Smoothness = 0.5,
    }

    local flag2 = false
    local flag3 = false
    flag = false

    _G.Ox.ESPConfig = {
        Master = false,
        Player = false,
        Killer = false,
        Outline = false,
        Name = false,
        Distance = false,
        KillerWarn = false,
        ItemIcon = false,
        Generator = false,
        GeneratorName = true,
        Pallet = false,
        Hook = false,
        Gate = false,
        Window = false,
        SCP = false,
        HookCount = false,
        Status = false,
        MaxDistance = 1000,
    }

    _G.Ox.ESPColors = {
        Player = Color3.fromRGB(60, 255, 60),
        Killer = Color3.fromRGB(255, 60, 60),
        Generator = Color3.fromRGB(255, 255, 0),
        GeneratorDone = Color3.fromRGB(0, 255, 0),
        Pallet = Color3.fromRGB(60, 255, 255),
        Hook = Color3.fromRGB(255, 105, 180),
        Gate = Color3.fromRGB(255, 255, 255),
        Window = Color3.fromRGB(60, 255, 255),
        SCP = Color3.fromRGB(255, 0, 255),
        Injured = Color3.fromRGB(255, 140, 0),
        Downed = Color3.fromRGB(255, 40, 40),
        Hooked = Color3.fromRGB(240, 240, 255),
    }

    tbl4 = {
        Generators = {},
        Windows = {},
        Pallets = {},
        Hooks = {},
        Gates = {},
        SCPs = {},
    }

    GetRole = function()
        if not localPlayer.Team then
            return "Unknown"
        end
        local name = localPlayer.Team.Name
        if name == "Killer" then
            return "Killer"
        end

        if name == "Survivors" then
            return "Survivor"
        end
        return "Spectator"
    end

    GetDistance = function(arg)
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return math.huge
        end
        return (arg - humanoidRootPart.Position).Magnitude
    end

    fn = function(arg, arg2)
        if arg and type(arg.SetValue) == "function" then
            pcall(function()
                arg:SetValue(arg2)
            end)
        end
    end

    ClearCrosshair = function()
        if _G.Ox.CrosshairGui then
            _G.Ox.CrosshairGui:Destroy()
            _G.Ox.CrosshairGui = nil
        end

        _G.Ox.CrosshairElements = {}
        _G.Ox.CrosshairCreated = false
        _G.Ox.LastCrosshairStyle = nil
    end

    DrawCrosshair = function()
        if not _G.Ox.Crosshair.Enabled then
            if _G.Ox.CrosshairGui then
                _G.Ox.CrosshairGui.Enabled = false
            end

            return
        end

        if _G.Ox.CrosshairGui then
            _G.Ox.CrosshairGui.Enabled = true
        end

        if _G.Ox.LastCrosshairStyle ~= _G.Ox.Crosshair.Style or not _G.Ox.CrosshairGui then
            ClearCrosshair()
            _G.Ox.LastCrosshairStyle = _G.Ox.Crosshair.Style
        end

        if not _G.Ox.CrosshairCreated then
            _G.Ox.CrosshairCreated = true
            _G.Ox.CrosshairGui = Instance.new("ScreenGui")
            _G.Ox.CrosshairGui.Name = "CrosshairUI"
            _G.Ox.CrosshairGui.IgnoreGuiInset = true
            _G.Ox.CrosshairGui.ResetOnSpawn = false
            _G.Ox.CrosshairGui.DisplayOrder = 999
            _G.Ox.CrosshairGui.Parent = CoreGui

            local function createFrame(size, position)
                local frame = Instance.new("Frame")
                frame.BackgroundColor3 = _G.Ox.Crosshair.Color
                frame.BorderSizePixel = 0
                frame.AnchorPoint = Vector2.new(0.5, 0.5)
                frame.Size = size
                frame.Position = position
                frame.Parent = _G.Ox.CrosshairGui
                return frame
            end

            local udim2 = UDim2.new(0.5, _G.Ox.Crosshair.OffsetX, 0.5, _G.Ox.Crosshair.OffsetY)

            if _G.Ox.Crosshair.Style == "Plus" then
                _G.Ox.CrosshairElements[1] = createFrame(UDim2.new(0, _G.Ox.Crosshair.Size * 2, 0, _G.Ox.Crosshair.Thickness), udim2)
                _G.Ox.CrosshairElements[2] = createFrame(UDim2.new(0, _G.Ox.Crosshair.Thickness, 0, _G.Ox.Crosshair.Size * 2), udim2)
            elseif _G.Ox.Crosshair.Style == "Dot" then
                local frame = Instance.new("Frame")
                frame.BackgroundColor3 = _G.Ox.Crosshair.Color
                frame.BorderSizePixel = 0
                frame.AnchorPoint = Vector2.new(0.5, 0.5)
                frame.Size = UDim2.new(0, _G.Ox.Crosshair.Size, 0, _G.Ox.Crosshair.Size)
                frame.Position = udim2
                Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
                frame.Parent = _G.Ox.CrosshairGui
                _G.Ox.CrosshairElements[1] = frame
            elseif _G.Ox.Crosshair.Style == "Circle" then
                local frame = Instance.new("Frame")
                frame.BackgroundTransparency = 1
                frame.BorderSizePixel = 0
                frame.AnchorPoint = Vector2.new(0.5, 0.5)
                frame.Size = UDim2.new(0, _G.Ox.Crosshair.Size * 2, 0, _G.Ox.Crosshair.Size * 2)
                frame.Position = udim2
                frame.Parent = _G.Ox.CrosshairGui
                local uiStroke = Instance.new("UIStroke")
                uiStroke.Color = _G.Ox.Crosshair.Color
                uiStroke.Thickness = _G.Ox.Crosshair.Thickness
                uiStroke.Parent = frame
                Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
                _G.Ox.CrosshairElements[1] = frame
            end
        end

        local udim2 = UDim2.new(0.5, _G.Ox.Crosshair.OffsetX, 0.5, _G.Ox.Crosshair.OffsetY)

        if _G.Ox.Crosshair.Style == "Plus" then
            if _G.Ox.CrosshairElements[1] then
                _G.Ox.CrosshairElements[1].Size = UDim2.new(0, _G.Ox.Crosshair.Size * 2, 0, _G.Ox.Crosshair.Thickness)
                _G.Ox.CrosshairElements[1].Position = udim2
                _G.Ox.CrosshairElements[1].BackgroundColor3 = _G.Ox.Crosshair.Color
            end

            if _G.Ox.CrosshairElements[2] then
                _G.Ox.CrosshairElements[2].Size = UDim2.new(0, _G.Ox.Crosshair.Thickness, 0, _G.Ox.Crosshair.Size * 2)
                _G.Ox.CrosshairElements[2].Position = udim2
                _G.Ox.CrosshairElements[2].BackgroundColor3 = _G.Ox.Crosshair.Color
            end
        elseif _G.Ox.Crosshair.Style == "Dot" then
            if _G.Ox.CrosshairElements[1] then
                _G.Ox.CrosshairElements[1].Size = UDim2.new(0, _G.Ox.Crosshair.Size, 0, _G.Ox.Crosshair.Size)
                _G.Ox.CrosshairElements[1].Position = udim2
                _G.Ox.CrosshairElements[1].BackgroundColor3 = _G.Ox.Crosshair.Color
            end
        elseif _G.Ox.Crosshair.Style == "Circle" and _G.Ox.CrosshairElements[1] then
            _G.Ox.CrosshairElements[1].Size = UDim2.new(0, _G.Ox.Crosshair.Size * 2, 0, _G.Ox.Crosshair.Size * 2)
            _G.Ox.CrosshairElements[1].Position = udim2
            local uiStroke = _G.Ox.CrosshairElements[1]:FindFirstChildOfClass("UIStroke")

            if uiStroke then
                uiStroke.Color = _G.Ox.Crosshair.Color
                uiStroke.Thickness = _G.Ox.Crosshair.Thickness
            end
        end
    end

    local function fn12()
        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and (not player.Team or player.Team.Name ~= "Survivors") then
                local character = player.Character
                if not character then
                    continue
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    return humanoidRootPart
                end
            end
        end

        return nil
    end

    local function fn13(arg)
        if not _G.Ox.AutoPallet.Safety then
            return true
        end

        if not arg then
            return false
        end

        if arg:GetAttribute("Knocked") == true then
            return false
        end

        if arg:GetAttribute("IsCarried") == true then
            return false
        end

        if arg:GetAttribute("IsHooked") == true then
            return false
        end
        local checkInterractable = arg:FindFirstChild("CheckInterractable")

        if checkInterractable then
            if checkInterractable:GetAttribute("isVaulting") == true then
                return false
            end

            if checkInterractable:GetAttribute("isRepairing") == true then
                return false
            end

            if checkInterractable:GetAttribute("isUnhooking") == true then
                return false
            end

            if checkInterractable:GetAttribute("isHealing") == true then
                return false
            end

            if checkInterractable:GetAttribute("isSliding") == true then
                return false
            end

            if checkInterractable:GetAttribute("isCarrying") == true then
                return false
            end
        end

        local humanoid = arg:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health <= 0 then
            return false
        end
        return true
    end

    local function fn14(arg)
        local v4 = nil
        local distance = _G.Ox.AutoPallet.Distance
        local v5 = ipairs
        local pallets = tbl4.Pallets
        local tbl6 = pallets or {}

        for k, v6 in v5(tbl6) do
            if v6 and v6.Parent and not _G.Ox.AutoPallet.UsedPallets[v6] then
                local primaryPartPallet = v6:FindFirstChild("PrimaryPartPallet")
                local palletPoint = primaryPartPallet or v6:FindFirstChild("PalletPoint") or v6:FindFirstChild("PalletPointSlide") or v6:FindFirstChildWhichIsA("BasePart")

                if palletPoint then
                    local ok, result = pcall(function()
                        return palletPoint.Position
                    end)

                    if ok and result then
                        local magnitude = (arg.Position - result).Magnitude

                        if magnitude < distance then
                            distance = magnitude
                            v4 = v6
                        end
                    end
                end
            end
        end

        return v4
    end

    local function fn15(arg)
        if not arg then
            return false
        end
        local palletPointSlide = arg:FindFirstChild("PalletPointSlide")
        local palletPoint = palletPointSlide or arg:FindFirstChild("PalletPoint") or arg:FindFirstChildWhichIsA("BasePart")
        if not palletPoint then
            return false
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local palletDropEvent = remotes and remotes:FindFirstChild("Pallet") and remotes.Pallet:FindFirstChild("PalletDropEvent")
        if not palletDropEvent then
            return false
        end

        pcall(function()
            palletDropEvent:FireServer(palletPoint)
        end)

        _G.Ox.AutoPallet.UsedPallets[arg] = true
        _G.Ox.AutoPallet.LastDrop = tick()
        return true
    end

    StartAutoPallet = function()
        if _G.Ox.AutoPallet.Connection then
            return
        end

        _G.Ox.AutoPallet.Connection = task.spawn(function()
            while _G.Ox.AutoPallet.Enabled do
                task.wait(0.3)

                if GetRole() == "Survivor" and tick() - _G.Ox.AutoPallet.LastDrop >= _G.Ox.AutoPallet.Cooldown then
                    pcall(function()
                        local character = localPlayer.Character
                        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
                            return
                        end

                        if not fn13(character) then
                            return
                        end
                        local v4 = fn12()
                        if not v4 then
                            return
                        end

                        if _G.Ox.AutoPallet.Distance < (humanoidRootPart.Position - v4.Position).Magnitude then
                            return
                        end
                        local v5 = fn14(humanoidRootPart)

                        if v5 then
                            fn15(v5)
                        end
                    end)
                end
            end
        end)
    end

    StopAutoPallet = function()
        if _G.Ox.AutoPallet.Connection then
            task.cancel(_G.Ox.AutoPallet.Connection)
            _G.Ox.AutoPallet.Connection = nil
        end

        _G.Ox.AutoPallet.UsedPallets = {}
    end

    ToggleAutoPallet = function(enabled)
        _G.Ox.AutoPallet.Enabled = enabled

        if enabled then
            if GetRole() ~= "Survivor" then
                lib:Notify({
                    Title = "Auto Drop Pallet",
                    Description = "Kamu harus Survivor!",
                    Duration = 3,
                })

                _G.Ox.AutoPallet.Enabled = false

                if AutoPalletToggle then
                    fn(AutoPalletToggle, false)
                end

                return
            end

            _G.Ox.AutoPallet.UsedPallets = {}
            StartAutoPallet()

            lib:Notify({
                Title = "Auto Drop Pallet",
                Description = "AKTIF",
                Duration = 2,
            })
        else
            StopAutoPallet()

            lib:Notify({
                Title = "Auto Drop Pallet",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        _G.Ox.AutoPallet.UsedPallets = {}
        _G.Ox.AutoPallet.LastDrop = 0
    end)

    DropAllPallets = function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local palletDropEvent = remotes and remotes:FindFirstChild("Pallet") and remotes.Pallet:FindFirstChild("PalletDropEvent")

        if not palletDropEvent then
            lib:Notify({
                Title = "Drop All Pallet",
                Description = "Remote tidak ditemukan!",
                Duration = 2,
            })

            return
        end

        local tbl6 = {}
        local map = workspace:FindFirstChild("Map")

        if not map then
            lib:Notify({
                Title = "Drop All Pallet",
                Description = "Map tidak ditemukan!",
                Duration = 2,
            })

            return
        end

        for i, descendant in ipairs(map:GetDescendants()) do
            if descendant.Name == "PalletPoint" and descendant:IsA("BasePart") then
                local model = descendant:FindFirstAncestorWhichIsA("Model")

                if model then
                    if not tbl6[model] then
                        tbl6[model] = {}
                    end

                    table.insert(tbl6[model], descendant)
                end
            end
        end

        local n2 = 0
        local v4, v5, v6 = pairs(tbl6)
        local v7 = v6
        local v8 = v4
        local v9 = v5

        while true do
            local v10, v11 = v8(v9, v7)
            if v10 == nil then
                break
            end

            for i, v12 in ipairs(v11) do
                pcall(function()
                    palletDropEvent:FireServer(v12)
                    n2 = n2 + 1
                end)
            end

            v7 = v10
        end

        lib:Notify({
            Title = "Drop All Pallet",
            Description = string.format("Berhasil menjatuhkan %d pallet!", n2),
            Duration = 3,
        })
    end

    local n2 = 0

    fn2 = function(arg)
        if not arg and tick() - n2 < 2 then
            return
        end
        n2 = tick()
        table.clear(tbl.Generators)
        table.clear(tbl.Windows)
        table.clear(tbl.Pallets)
        table.clear(tbl.Hooks)
        table.clear(tbl.Gates)
        table.clear(tbl4.Generators)
        table.clear(tbl4.Windows)
        table.clear(tbl4.Pallets)
        table.clear(tbl4.Hooks)
        table.clear(tbl4.Gates)
        table.clear(tbl4.SCPs)
        local map = workspace:FindFirstChild("Map")
        local v4 = map or workspace
        local descendants = v4:GetDescendants()

        for i, descendant in ipairs(descendants) do
            if i % 200 == 0 then
                task.wait()
            end

            if descendant:IsA("Model") then
                local v5 = string.lower(descendant.Name)

                if v5 == "generator" then
                    local generatorBody = descendant:FindFirstChild("GeneratorBody")
                    local basePart = generatorBody or descendant:FindFirstChildWhichIsA("BasePart")

                    if basePart then
                        local tbl6 = {model = descendant, part = basePart}
                        table.insert(tbl.Generators, tbl6)
                        table.insert(tbl4.Generators, tbl6)
                    end
                elseif v5 == "hook" and descendant:FindFirstChild("HookPoint") then
                    table.insert(tbl.Hooks, descendant)
                    table.insert(tbl4.Hooks, descendant)
                elseif v5 == "gate" and descendant:FindFirstChild("ExitLever") then
                    table.insert(tbl.Gates, descendant)
                    table.insert(tbl4.Gates, descendant)
                elseif v5 == "window" then
                    table.insert(tbl.Windows, descendant)
                    table.insert(tbl4.Windows, descendant)
                end
            elseif descendant:IsA("BasePart") and descendant.Name == "PrimaryPartPallet" then
                local parent = descendant.Parent

                if parent and not table.find(tbl.Pallets, parent) then
                    table.insert(tbl.Pallets, parent)
                    table.insert(tbl4.Pallets, parent)
                end
            end
        end

        local descendants2 = workspace:GetDescendants()

        for i, v5 in ipairs(descendants2) do
            if i % 200 == 0 then
                task.wait()
            end

            if v5:IsA("Model") and string.match(string.lower(v5.Name), "^scp") and not table.find(tbl4.SCPs, v5) then
                table.insert(tbl4.SCPs, v5)
            end
        end
    end

    fn3 = function(arg)
        if not arg then
            return
        end
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            local vector = Vector3.new(0, 3, 0)

            if arg:IsA("BasePart") then
                humanoidRootPart.CFrame = arg.CFrame + vector
            elseif arg:IsA("Model") then
                local basePart = arg:FindFirstChildWhichIsA("BasePart")

                if basePart then
                    humanoidRootPart.CFrame = basePart.CFrame + vector
                end
            end

            lib:Notify({
                Title = "Teleport",
                Description = "Berhasil!",
                Duration = 1,
            })
        end
    end

    ApplyFullBright = function()
        local Lighting = game:GetService("Lighting")
        if not Lighting then
            return
        end

        if _G.Ox.FullBright then
            Lighting.Brightness = 2.8
            Lighting.ClockTime = _G.Ox.TimeOfDayValue
            Lighting.FogEnd = 100000
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        end
    end

    ApplyNoFog = function()
        local Lighting = game:GetService("Lighting")
        if not Lighting then
            return
        end

        if _G.Ox.NoFog then
            Lighting.FogStart = 0
            Lighting.FogEnd = 100000
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

            if atmosphere then
                atmosphere.Density = 0
                atmosphere.Offset = 0
                atmosphere.Glare = 0
                atmosphere.Haze = 0
            end
        end
    end

    ApplyNoShadow = function()
        local Lighting = game:GetService("Lighting")
        if not Lighting then
            return
        end
        local globalShadows

        if _G.Ox.NoShadow then
            globalShadows = false
        else
            globalShadows = true
        end

        Lighting.GlobalShadows = globalShadows
    end

    ReapplyPerformance = function()
        ApplyFullBright()
        ApplyNoFog()
        ApplyNoShadow()
    end

    ReapplyPerformanceDelayed = function()
        task.spawn(function()
            ReapplyPerformance()
            task.wait(1.2)
            ReapplyPerformance()
            task.wait(2)
            ReapplyPerformance()
            task.wait(3)
            ReapplyPerformance()
        end)
    end

    StartLightingGuard = function()
        if _G.Ox.LightingGuardConn then
            return
        end
        local n3 = 0

        _G.Ox.LightingGuardConn = RunService.Heartbeat:Connect(function()
            if not _G.Ox.FullBright and not _G.Ox.NoFog and not _G.Ox.NoShadow then
                return
            end
            local now = tick()
            if now - n3 < 0.4 then
                return
            end
            n3 = now
            ReapplyPerformance()
        end)
    end

    StopLightingGuard = function()
        if _G.Ox.FullBright or _G.Ox.NoFog or _G.Ox.NoShadow then
            return
        end

        if _G.Ox.LightingGuardConn then
            _G.Ox.LightingGuardConn:Disconnect()
            _G.Ox.LightingGuardConn = nil
        end
    end

    if not _G.Ox.LightingChildConn then
        _G.Ox.LightingChildConn = game:GetService("Lighting").ChildAdded:Connect(function(child)
            if not _G.Ox.FullBright and not _G.Ox.NoFog then
                return
            end

            task.defer(function()
                if child:IsA("Atmosphere") and _G.Ox.NoFog then
                    child.Density = 0
                    child.Offset = 0
                    child.Glare = 0
                    child.Haze = 0
                end

                ReapplyPerformance()
            end)
        end)
    end

    local function fn16(arg, arg2, arg3)
        table.insert(_G.Ox.LowGFX.Saved, {obj = arg, kind = arg2, extra = arg3})
    end

    LowGFX_ProcessOne = function(arg)
        if not _G.Ox.LowGFX.Enabled or not arg then
            return
        end
        local lowGFX = _G.Ox.LowGFX

        if lowGFX.Parts and (arg:IsA("BasePart") or arg:IsA("UnionOperation") or arg:IsA("MeshPart")) and arg.Material ~= Enum.Material.SmoothPlastic then
            fn16(arg, "Part", arg.Material)
            arg.Material = Enum.Material.SmoothPlastic
        end

        if lowGFX.Particles and (arg:IsA("ParticleEmitter") or arg:IsA("Smoke") or arg:IsA("Explosion") or arg:IsA("Sparkles") or arg:IsA("Fire")) and arg.Enabled ~= false then
            fn16(arg, "Particle", true)
            arg.Enabled = false
        end

        if lowGFX.VisualEffects and (arg:IsA("BloomEffect") or arg:IsA("BlurEffect") or arg:IsA("DepthOfFieldEffect") or arg:IsA("SunRaysEffect") or arg:IsA("ColorCorrectionEffect")) and arg.Enabled ~= false then
            fn16(arg, "VFX", true)
            arg.Enabled = false
        end

        if lowGFX.Textures and (arg:IsA("Decal") or arg:IsA("Texture")) and arg.Texture ~= "" then
            fn16(arg, "Texture", arg.Texture)
            arg.Texture = ""
        end

        if lowGFX.Sky and arg:IsA("Sky") then
            fn16(arg, "Sky", arg.Parent)
            arg.Parent = nil
        end
    end

    ApplyLowGFX = function()
        if not _G.Ox.LowGFX.Enabled then
            return
        end
        local tbl6 = {workspace, game:GetService("Lighting")}
        local v4, v5, v6 = ipairs(tbl6)
        local v7 = v6
        local v8 = v4
        local v9 = v5

        while true do
            local v10, v11 = v8(v9, v7)
            if v10 == nil then
                break
            end
            local descendants = v11:GetDescendants()

            for i, descendant in ipairs(descendants) do
                if i % 250 == 0 then
                    task.wait()
                end

                LowGFX_ProcessOne(descendant)
            end

            v7 = v10
        end
    end

    RestoreLowGFX = function()
        for i, v4 in ipairs(_G.Ox.LowGFX.Saved) do
            local obj = v4.obj

            if obj and obj.Parent then
                pcall(function()
                    if v4.kind == "Part" then
                        obj.Material = v4.extra
                    elseif v4.kind ~= "Particle" and v4.kind ~= "VFX" then
                        if v4.kind == "Texture" then
                            obj.Texture = v4.extra
                        elseif v4.kind == "Sky" and v4.extra then
                            obj.Parent = v4.extra
                        end
                    else
                        obj.Enabled = v4.extra
                    end
                end)
            end
        end

        table.clear(_G.Ox.LowGFX.Saved)
    end

    ToggleLowGFX = function(enabled)
        _G.Ox.LowGFX.Enabled = enabled

        if enabled then
            task.spawn(ApplyLowGFX)

            lib:Notify({
                Title = "Remove Texture",
                Description = "AKTIF - Low GFX",
                Duration = 2,
            })
        else
            RestoreLowGFX()

            lib:Notify({
                Title = "Remove Texture",
                Description = "NONAKTIF - texture dikembalikan",
                Duration = 2,
            })
        end
    end

    if not _G.Ox.LowGFX.StreamConn then
        _G.Ox.LowGFX.StreamConn = workspace.DescendantAdded:Connect(function(descendant)
            if not _G.Ox.LowGFX.Enabled then
                return
            end

            task.defer(function()
                LowGFX_ProcessOne(descendant)
            end)
        end)
    end

    CreateSpectatorUI = function()
        if _G.Ox.Spectator.Gui then
            _G.Ox.Spectator.Gui:Destroy()
            _G.Ox.Spectator.Gui = nil
        end

        _G.Ox.Spectator.Gui = Instance.new("ScreenGui")
        _G.Ox.Spectator.Gui.Name = "SpectatorCounter"
        _G.Ox.Spectator.Gui.ResetOnSpawn = false
        _G.Ox.Spectator.Gui.Parent = localPlayer:WaitForChild("PlayerGui")
        local frame = Instance.new("Frame")
        frame.Name = "MainBox"
        frame.AnchorPoint = Vector2.new(0.5, 1)
        frame.Position = UDim2.new(0.5, 0, 0, -10)
        frame.Size = UDim2.new(0, 68, 0, 22)
        frame.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
        frame.BackgroundTransparency = 0.25
        frame.BorderSizePixel = 0
        frame.Parent = _G.Ox.Spectator.Gui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        local uiGradient = Instance.new("UIGradient")

        uiGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.4),
            NumberSequenceKeypoint.new(1, 1),
        })

        uiGradient.Parent = frame
        local uiListLayout = Instance.new("UIListLayout", frame)
        uiListLayout.FillDirection = Enum.FillDirection.Horizontal
        uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        uiListLayout.Padding = UDim.new(0, 6)
        local imageLabel = Instance.new("ImageLabel", frame)
        imageLabel.Size = UDim2.new(0, 15, 0, 15)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = "rbxassetid://13321848320"
        imageLabel.ImageColor3 = Color3.fromRGB(225, 225, 225)
        _G.Ox.Spectator.Label = Instance.new("TextLabel", frame)
        _G.Ox.Spectator.Label.BackgroundTransparency = 1
        _G.Ox.Spectator.Label.Font = Enum.Font.GothamMedium
        _G.Ox.Spectator.Label.Text = "0"
        _G.Ox.Spectator.Label.TextColor3 = Color3.fromRGB(240, 240, 240)
        _G.Ox.Spectator.Label.TextSize = 13
        _G.Ox.Spectator.Label.AutomaticSize = Enum.AutomaticSize.X
    end

    UpdateSpectatorCount = function()
        if not _G.Ox.Spectator.Enabled or not _G.Ox.Spectator.Label then
            return
        end
        local n3 = 0

        for i, player in ipairs(Players:GetPlayers()) do
            if player.Team and player.Team.Name == "Spectator" then
                n3 = n3 + 1
            end
        end

        _G.Ox.Spectator.Label.Text = tostring(n3)
        local gui = _G.Ox.Spectator.Gui
        local mainBox = gui and _G.Ox.Spectator.Gui:FindFirstChild("MainBox")

        if mainBox then
            local udim2 = UDim2.new
            local n4 = n3 >= 10 and 8 or 0
            local n5 = 55 + n4
            local n6 = n3 >= 100 and 8 or 0
            mainBox.Size = udim2(0, n5 + n6, 0, 22)
        end
    end

    StartSpectatorInfo = function()
        if _G.Ox.Spectator.Enabled then
            return
        end
        _G.Ox.Spectator.Enabled = true
        CreateSpectatorUI()
        UpdateSpectatorCount()

        task.spawn(function()
            while _G.Ox.Spectator.Enabled do
                UpdateSpectatorCount()
                task.wait(1.2)
            end
        end)

        lib:Notify({
            Title = "Spectator Info",
            Description = "â Display aktif di pojok atas",
            Duration = 3,
        })
    end

    StopSpectatorInfo = function()
        _G.Ox.Spectator.Enabled = false

        if _G.Ox.Spectator.Gui then
            _G.Ox.Spectator.Gui:Destroy()
            _G.Ox.Spectator.Gui = nil
            _G.Ox.Spectator.Label = nil
        end

        lib:Notify({
            Title = "Spectator Info",
            Description = "Display dimatikan",
            Duration = 2,
        })
    end

    fn4 = function(arg)
        if arg then
            StartSpectatorInfo()
        else
            StopSpectatorInfo()
        end
    end

    ScanMapESP = function(arg)
        fn2(arg)
    end

    ForceRefreshMap = function()
        fn2(true)

        if _G.Ox.ESPConfig.Master then
            ClearAllESP()
            task.wait(0.1)
            UpdatePlayerESP()
            UpdateSCPESP()
            UpdateStaticESP()
        end
    end

    task.spawn(function()
        task.wait(2)
        ScanMapESP()
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1.5)
        ScanMapESP()

        if _G.Ox.ESPConfig.Master then
            task.spawn(function()
                task.wait(0.5)
                ClearAllESP()
                task.wait(0.2)
                UpdatePlayerESP()
                UpdateSCPESP()
                UpdateStaticESP()
            end)
        end
    end)

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(1)
            ScanMapESP(true)

            if _G.Ox.ESPConfig.Master then
                pcall(UpdatePlayerESP)
                pcall(UpdateSCPESP)
                pcall(UpdateStaticESP)
            end

            ReapplyPerformanceDelayed()

            if _G.Ox.LowGFX.Enabled then
                table.clear(_G.Ox.LowGFX.Saved)
                task.wait(1.5)
                ApplyLowGFX()
                task.wait(2.5)

                if _G.Ox.LowGFX.Enabled then
                    ApplyLowGFX()
                end
            end
        end
    end)

    task.spawn(function()
        while _G.Ox.ScriptAlive do
            task.wait(40)

            if _G.Ox.ESPConfig.Master then
                ScanMapESP()

                if _G.Ox.ESPConfig.Master then
                    pcall(UpdateStaticESP)
                    pcall(UpdatePlayerESP)
                    pcall(UpdateSCPESP)
                end
            end
        end
    end)

    local function fn17()
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return nil
        end
        local survivorMob = playerGui2:FindFirstChild("Survivor-mob")
        if not survivorMob then
            return nil
        end
        local controls = survivorMob:FindFirstChild("Controls")
        if not controls then
            return nil
        end
        local sprint = controls:FindFirstChild("sprint")
        if not sprint then
            return nil
        end

        if sprint:IsA("GuiButton") then
            return sprint
        end
        local icon = sprint:FindFirstChild("icon")
        if icon and icon:IsA("GuiButton") then
            return icon
        end

        if icon and icon.Parent and icon.Parent:IsA("GuiButton") then
            return icon.Parent
        end

        if sprint.Parent and sprint.Parent:IsA("GuiButton") then
            return sprint.Parent
        end
        return sprint
    end

    local function fn18()
        local v4 = fn17()
        if not v4 then
            return false
        end

        pcall(function()
            if type(firesignal) == "function" then
                firesignal(v4.MouseButton1Click)
                firesignal(v4.MouseButton1Down)
                task.wait(0.04)
                firesignal(v4.MouseButton1Up)
            else
                local absolutePosition = v4.AbsolutePosition
                local absoluteSize = v4.AbsoluteSize
                local guiInset = GuiService:GetGuiInset()
                local n3 = absolutePosition.X + absoluteSize.X / 2 + guiInset.X
                local n4 = absolutePosition.Y + absoluteSize.Y / 2 + guiInset.Y
                VirtualInputManager:SendTouchEvent(9901, 0, n3, n4)
                task.wait(0.04)
                VirtualInputManager:SendTouchEvent(9901, 2, n3, n4)
            end
        end)

        return true
    end

    local function fn19()
        local character = localPlayer.Character
        if not character then
            return false
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return false
        end

        if humanoid.MoveDirection.Magnitude > 0.12 then
            return true
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
            if Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude > 1.5 then
                return true
            end
        end

        return false
    end

    local function fn20()
        local character = localPlayer.Character
        if not character then
            return false
        end
        local flag4 = character:GetAttribute("Crouching") == true or character:GetAttribute("Crouchingserver") == true
        return flag4
    end

    local function fn21()
        local character = localPlayer.Character
        if not character then
            return false
        end
        local flag4 = character:GetAttribute("Sprinting") == true or character:GetAttribute("IsRunning") == true
        return flag4
    end

    fn5 = function()
        if _G.Ox.AutoRun.MobileThread then
            return
        end

        _G.Ox.AutoRun.MobileThread = task.spawn(function()
            while _G.Ox.AutoRun.Mobile do
                local v4 = fn19()
                local v5 = fn20()
                local v6 = fn21()

                if v5 then
                    if v6 then
                        fn18()
                    end
                elseif v4 and not v6 then
                    fn18()
                elseif not v4 and v6 then
                    fn18()
                end

                task.wait(0.12)
            end

            _G.Ox.AutoRun.MobileThread = nil
        end)
    end

    fn6 = function()
        _G.Ox.AutoRun.Mobile = false

        if _G.Ox.AutoRun.MobileThread then
            task.cancel(_G.Ox.AutoRun.MobileThread)
            _G.Ox.AutoRun.MobileThread = nil
        end

        if fn21() then
            fn18()
        end
    end

    task.spawn(function()
        while _G.Ox.ScriptAlive do
            task.wait(0.1)
            if not _G.Ox.ScriptAlive then
                break
            end

            if not UserInputService.TouchEnabled and tick() - _G.Ox.lastActionTime >= _G.Ox.COOLDOWN then
                local autoVaultEnabled = _G.Ox.autoVaultEnabled
                local autoPalletSlideEnabled = _G.Ox.autoPalletSlideEnabled

                if autoVaultEnabled or autoPalletSlideEnabled then
                    local pcprompts = playerGui:FindFirstChild("pcprompts")
                    local frame = pcprompts and pcprompts:FindFirstChild("Frame")

                    if frame then
                        local vaultPromptGui = frame:FindFirstChild("VaultPromptGui")
                        local palletSlidePromptGui = frame:FindFirstChild("PalletSlidePromptGui")
                        local visible = vaultPromptGui and vaultPromptGui.Visible
                        local visible2 = palletSlidePromptGui and palletSlidePromptGui.Visible

                        if autoVaultEnabled and visible or autoPalletSlideEnabled and visible2 then
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                            task.wait(0.01)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                            _G.Ox.lastActionTime = tick()
                        end
                    end
                end
            end
        end
    end)

    local function fn22()
        if not UserInputService.TouchEnabled then
            return
        end
        local survivorMob = playerGui:FindFirstChild("Survivor-mob")
        local survivorMob2 = survivorMob or playerGui:WaitForChild("Survivor-mob", 8)
        if not survivorMob2 then
            return
        end
        local controls = survivorMob2:FindFirstChild("Controls")
        local controls2 = controls or survivorMob2:WaitForChild("Controls", 5)
        local action = controls2

        if controls2 then
            local action2 = controls2:FindFirstChild("action")
            action = action2 or controls2:WaitForChild("action", 5)
        end

        if not action then
            return
        end

        local tbl6 = {
            vault = true,
            palletvault = true,
            palletslide = true,
            slide = true,
        }

        local function fn23(arg)
            if not arg:IsA("ImageLabel") and not arg:IsA("ImageButton") then
                return
            end
            local str = arg.Name:lower()
            if not tbl6[str] then
                return
            end

            arg:GetPropertyChangedSignal("Visible"):Connect(function()
                if not arg.Visible then
                    return
                end

                if tick() - _G.Ox.lastActionTime < _G.Ox.COOLDOWN then
                    return
                end
                local pos = str:find("vault")
                local flag4 = pos

                if pos then
                    if str:find("pallet") then
                        flag4 = false
                    else
                        flag4 = true
                    end
                end

                local pos2 = str:find("pallet")
                local pos3 = pos2 or str:find("slide")

                if flag4 and _G.Ox.autoVaultEnabled or pos3 and _G.Ox.autoPalletSlideEnabled then
                    pcall(function()
                        firesignal(action.MouseButton1Down)
                        task.wait(0.01)
                        firesignal(action.MouseButton1Up)
                    end)

                    _G.Ox.lastActionTime = tick()
                end
            end)
        end

        for k, child in pairs(action:GetChildren()) do
            fn23(child)
        end

        action.ChildAdded:Connect(function(child)
            task.wait()
            fn23(child)
        end)
    end

    task.spawn(fn22)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(2)
        fn22()
    end)

    playerGui.ChildAdded:Connect(function(child)
        if child.Name == "Survivor-mob" then
            task.wait(1)
            fn22()
        end
    end);

    (function()
        task.spawn(function()
            local remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
            local killerPerks = remotes and remotes:WaitForChild("KillerPerks", 5)
            local kingscourge = killerPerks and killerPerks:WaitForChild("kingscourge", 5)
            local kingScourgeStart = kingscourge and kingscourge:WaitForChild("KingScourgeStart", 5)

            if kingScourgeStart then
                kingScourgeStart.OnClientEvent:Connect(function()
                    if _G.Ox.Auto.SkillCheckMode == "Random" then
                        _G.Ox.State.RandomMode_IsNormal = true
                    end
                end)
            end
        end)
    end)()

    local function fn23()
        if not playerGui then
            return nil
        end
        local survivorMob = playerGui:FindFirstChild("Survivor-mob")
        if not survivorMob then
            return nil
        end
        local controls = survivorMob:FindFirstChild("Controls")
        if not controls then
            return nil
        end
        local action = controls:FindFirstChild("action")
        local check = action or controls:FindFirstChild("check")
        return check
    end

    local AutoSkill = {
        LastGoalRotation = nil,
        HasClickedThisGoal = false,
        LastLineRotation = nil,
        LastTick = nil,
        WasActive = false,
        PerfectLastGoalRotation = nil,
        PerfectHasClickedThisGoal = false,
        PerfectLastLineRotation = nil,
        PerfectLastTick = nil,
        PerfectWasActive = false,
        InstantLastTriggerTick = 0,
        InstantLastGoalRotation = 0,
        InstantLastGoalInstance = nil,
        InstantCurrentGoalID = 0,
        InstantHasClicked = false,
        InstantForcingRotation = false,
        InstantRotationConnection = nil,
        RandomPick = "Perfect",
        RandomGoal = nil,
        RandomGoalRotation = nil,
    }

    local function VD_ResetSkill()
        AutoSkill.LastGoalRotation = nil
        AutoSkill.HasClickedThisGoal = false
        AutoSkill.LastLineRotation = nil
        AutoSkill.LastTick = nil
        AutoSkill.WasActive = false
        AutoSkill.PerfectLastGoalRotation = nil
        AutoSkill.PerfectHasClickedThisGoal = false
        AutoSkill.PerfectLastLineRotation = nil
        AutoSkill.PerfectLastTick = nil
        AutoSkill.PerfectWasActive = false
        AutoSkill.InstantHasClicked = false
        AutoSkill.RandomGoal = nil
        AutoSkill.RandomGoalRotation = nil
    end

    local function VD_PressSkill()
        if UserInputService.TouchEnabled then
            local btn = playerGui:FindFirstChild("check", true)
            if btn and btn:IsA("GuiObject") then
                local pos = btn.AbsolutePosition
                local size = btn.AbsoluteSize
                local inset = GuiService:GetGuiInset()
                local x = pos.X + (size.X / 2) + inset.X
                local y = pos.Y + (size.Y / 2) + inset.Y
                pcall(function() VirtualInputManager:SendTouchEvent(8822, Enum.UserInputState.Begin.Value, x, y) end)
                task.wait(0.01)
                pcall(function() VirtualInputManager:SendTouchEvent(8822, Enum.UserInputState.End.Value, x, y) end)
                pcall(function()
                    if firesignal and btn.MouseButton1Click then
                        firesignal(btn.MouseButton1Click)
                    end
                end)
                return true
            end
        end
        pcall(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game) end)
        task.wait(0.01)
        pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end)
        return true
    end

    local function VD_GetSkillCheck()
        for _, guiName in ipairs({ "SkillCheckPromptGui", "SkillCheckPromptGui-con" }) do
            local gui = playerGui:FindFirstChild(guiName, true)
            if gui then
                local check = gui:FindFirstChild("Check", true)
                if check and check.Visible then
                    local line = check:FindFirstChild("Line", true)
                    local goal = check:FindFirstChild("Goal", true)
                    if line and goal then return line, goal end
                end
            end
        end
    end

    local function VD_AngularDelta(from, to)
        local d = to - from
        if d > 180 then d = d - 360 end
        if d < -180 then d = d + 360 end
        return d
    end

    local function VD_CrossedZone(prevLr, lr, startPos, endPos)
        local function inZone(r)
            if startPos > endPos then
                return r >= startPos or r <= endPos
            end
            return r >= startPos and r <= endPos
        end
        if inZone(lr) then return true end
        if prevLr == nil then return false end
        local delta = VD_AngularDelta(prevLr, lr)
        local steps = math.abs(math.floor(delta))
        if steps < 2 then return false end
        local stepSize = delta / steps
        for i = 1, steps do
            if inZone((prevLr + stepSize * i) % 360) then return true end
        end
        return false
    end

    local function VD_NormalSkillcheckUpdate()
        local line, goal = VD_GetSkillCheck()
        if not (line and goal) then
            AutoSkill.LastGoalRotation = nil
            AutoSkill.HasClickedThisGoal = false
            AutoSkill.LastLineRotation = nil
            AutoSkill.LastTick = nil
            AutoSkill.WasActive = false
            return
        end

        local lr = line.Rotation % 360
        local gr = goal.Rotation % 360
        local now = os.clock()
        if not AutoSkill.WasActive then
            AutoSkill.WasActive = true
            AutoSkill.HasClickedThisGoal = false
            AutoSkill.LastGoalRotation = gr
            AutoSkill.LastLineRotation = lr
            AutoSkill.LastTick = now
            return
        end
        if AutoSkill.LastGoalRotation and math.abs(VD_AngularDelta(AutoSkill.LastGoalRotation, gr)) > 5 then
            AutoSkill.HasClickedThisGoal = false
            AutoSkill.LastLineRotation = nil
            AutoSkill.LastTick = nil
        end
        AutoSkill.LastGoalRotation = gr
        if AutoSkill.HasClickedThisGoal then
            AutoSkill.LastLineRotation = lr
            AutoSkill.LastTick = now
            return
        end
        if AutoSkill.LastLineRotation and AutoSkill.LastTick then
            local dt = now - AutoSkill.LastTick
            if dt > 0 then
                local lineSpeed = VD_AngularDelta(AutoSkill.LastLineRotation, lr) / dt
                local predicted = (lr + lineSpeed * dt * 0) % 360
                if VD_CrossedZone(AutoSkill.LastLineRotation, predicted, (gr + 104) % 360, (gr + 109) % 360) then
                    AutoSkill.HasClickedThisGoal = true
                    task.spawn(function()
                        task.wait(0.03)
                        VD_PressSkill()
                    end)
                end
            end
        end
        AutoSkill.LastLineRotation = lr
        AutoSkill.LastTick = now
    end

    local function VD_PerfectSkillcheckUpdate()
        local line, goal = VD_GetSkillCheck()
        if not (line and goal) then
            AutoSkill.PerfectLastGoalRotation = nil
            AutoSkill.PerfectHasClickedThisGoal = false
            AutoSkill.PerfectLastLineRotation = nil
            AutoSkill.PerfectLastTick = nil
            AutoSkill.PerfectWasActive = false
            return
        end

        local lr = line.Rotation % 360
        local gr = goal.Rotation % 360
        local now = os.clock()
        if not AutoSkill.PerfectWasActive then
            AutoSkill.PerfectWasActive = true
            AutoSkill.PerfectHasClickedThisGoal = false
            AutoSkill.PerfectLastGoalRotation = gr
            AutoSkill.PerfectLastLineRotation = lr
            AutoSkill.PerfectLastTick = now
            return
        end
        if AutoSkill.PerfectLastGoalRotation and math.abs(VD_AngularDelta(AutoSkill.PerfectLastGoalRotation, gr)) > 5 then
            AutoSkill.PerfectHasClickedThisGoal = false
            AutoSkill.PerfectLastLineRotation = nil
            AutoSkill.PerfectLastTick = nil
        end
        AutoSkill.PerfectLastGoalRotation = gr
        if AutoSkill.PerfectHasClickedThisGoal then
            AutoSkill.PerfectLastLineRotation = lr
            AutoSkill.PerfectLastTick = now
            return
        end
        if AutoSkill.PerfectLastLineRotation and AutoSkill.PerfectLastTick then
            local dt = now - AutoSkill.PerfectLastTick
            if dt > 0 then
                local lineSpeed = VD_AngularDelta(AutoSkill.PerfectLastLineRotation, lr) / dt
                local predicted = (lr + lineSpeed * dt * 0) % 360
                if VD_CrossedZone(AutoSkill.PerfectLastLineRotation, predicted, (gr + 104) % 360, (gr + 108) % 360) then
                    AutoSkill.PerfectHasClickedThisGoal = true
                    VD_PressSkill()
                end
            end
        end
        AutoSkill.PerfectLastLineRotation = lr
        AutoSkill.PerfectLastTick = now
    end

    local function VD_InstantSkillcheckUpdate()
        if AutoSkill.InstantHasClicked then return end

        local prompt = playerGui:FindFirstChild("SkillCheckPromptGui", true)
        if not prompt then
            prompt = playerGui:FindFirstChild("SkillCheckPromptGui-con", true)
        end
        if not prompt then return end

        local check = prompt:FindFirstChild("Check", true)
        if not check or not check.Visible then return end

        local line = check:FindFirstChild("Line", true)
        local goal = check:FindFirstChild("Goal", true)
        if not line or not goal then return end

        line.Rotation = goal.Rotation + 109

        AutoSkill.InstantHasClicked = true
        task.spawn(function()
            VD_PressSkill()
            task.wait(0.2)
            AutoSkill.InstantHasClicked = false
        end)
    end

    local function VD_RandomSkillcheckUpdate()
        local line, goal = VD_GetSkillCheck()
        if line and goal then
            local gr = goal.Rotation % 360
            if AutoSkill.RandomGoal ~= goal
                or math.abs(VD_AngularDelta(AutoSkill.RandomGoalRotation or gr, gr)) > 5 then
                AutoSkill.RandomGoal = goal
                AutoSkill.RandomGoalRotation = gr
                AutoSkill.RandomPick = (math.random(1, 2) == 1) and "Perfect" or "Instant"
            end
        end
        if AutoSkill.RandomPick == "Instant" then
            VD_InstantSkillcheckUpdate()
        else
            VD_PerfectSkillcheckUpdate()
        end
    end

    local function VD_SkillcheckUpdate()
        if not _G.Ox.Auto.SkillCheck then
            VD_ResetSkill()
            return
        end
        local mode = _G.Ox.Auto.SkillCheckMode
        if mode == "Instant" then
            VD_InstantSkillcheckUpdate()
        elseif mode == "Random" then
            VD_RandomSkillcheckUpdate()
        else

            VD_PerfectSkillcheckUpdate()
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        VD_ResetSkill()
    end)

    fn7 = function()
        if _G.Ox.Connections.SkillHeartbeat then _G.Ox.Connections.SkillHeartbeat:Disconnect() end
        VD_ResetSkill()
        _G.Ox.Connections.SkillHeartbeat = RunService.RenderStepped:Connect(function()
            pcall(VD_SkillcheckUpdate)
        end)
    end

    local repairEvent
    do
        local okRS, rs = pcall(function() return game:GetService("ReplicatedStorage") end)
        local rem = okRS and rs and rs:FindFirstChild("Remotes")
        local gen = rem and rem:FindFirstChild("Generator")
        repairEvent = gen and gen:FindFirstChild("RepairEvent")
        if not repairEvent and okRS and rs then
            repairEvent = rs:FindFirstChild("RepairEvent", true)
        end
    end
    local tbl6 = {}
    local n3 = 0

    GetAllGenerators = function()
        local now = tick()
        if now - n3 < 5 then
            return tbl6
        end
        tbl6 = {}
        n3 = now
        local map = workspace:FindFirstChild("Map")
        if not map then
            return tbl6
        end

        pcall(function()
            for k, descendant in pairs(map:GetDescendants()) do
                if descendant:IsA("Model") and descendant.Name == "Generator" then
                    local flag4 = descendant:GetAttribute("RepairProgress") ~= nil or descendant:GetAttribute("kickcount") ~= nil or descendant:GetAttribute("ProgressRepair") ~= nil

                    if flag4 then
                        table.insert(tbl6, descendant)
                    end
                end
            end
        end)

        return tbl6
    end

    _G.Ox.PlayRepairAnim = function()
        local character = localPlayer.Character
        if not character then
            return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return
        end

        if _G.Ox.RepairAnimTrack and _G.Ox.RepairAnimTrack.IsPlaying then
            return
        end

        pcall(function()
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://92960319113695"
            _G.Ox.RepairAnimTrack = animator:LoadAnimation(animation)
            _G.Ox.RepairAnimTrack.Priority = Enum.AnimationPriority.Action
            _G.Ox.RepairAnimTrack:Play()
        end)
    end

    _G.Ox.StopRepairAnim = function()
        if _G.Ox.RepairAnimTrack and _G.Ox.RepairAnimTrack.IsPlaying then
            pcall(function()
                _G.Ox.RepairAnimTrack:Stop()
            end)
        end

        _G.Ox.RepairAnimTrack = nil
    end

    GetGeneratorPoints = function(arg)
        local tbl7 = {}
        if not arg then return tbl7 end

        pcall(function()
            for k, child in pairs(arg:GetChildren()) do
                if child:IsA("BasePart") and child.Name:find("GeneratorPoint") then
                    table.insert(tbl7, child)
                end
            end
        end)

        if #tbl7 == 0 then
            pcall(function()
                for k, child in pairs(arg:GetDescendants()) do
                    if child:IsA("BasePart") and (child.Name:find("GeneratorPoint") or child.Name:find("RepairPoint")) then
                        table.insert(tbl7, child)
                    end
                end
            end)
        end

        if #tbl7 == 0 then
            pcall(function()
                for k, child in pairs(arg:GetDescendants()) do
                    if child:IsA("BasePart") and child.Name:lower():find("point") then
                        table.insert(tbl7, child)
                    end
                end
            end)
        end

        if #tbl7 == 0 then
            local main = arg.PrimaryPart or arg:FindFirstChild("MainPart") or arg:FindFirstChild("Engine") or arg:FindFirstChildWhichIsA("BasePart")
            if main then table.insert(tbl7, main) end
        end

        return tbl7
    end

    _G.Ox.StopAutoRepair = function()
        _G.Ox.StopRepairAnim()
        local autoCurrentPoint = _G.Ox.AutoCurrentPoint
        _G.Ox.AutoCurrentPoint = nil

        if autoCurrentPoint then
            pcall(function()
                repairEvent:FireServer(autoCurrentPoint, false)
            end)
        end
    end

    _G.Ox.StartAutoRepairLoop = function(autoCurrentGenModel)
        _G.Ox.AutoCurrentGenModel = autoCurrentGenModel

        if _G.Ox.AutoRepairThread then
            task.cancel(_G.Ox.AutoRepairThread)
            _G.Ox.AutoRepairThread = nil
        end

        _G.Ox.StopAutoRepair()

        _G.Ox.AutoRepairThread = task.spawn(function()
            while _G.Ox.AutoRepairEnabled and _G.Ox.BypassGenEnabled do
                local character = localPlayer.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                    task.wait(0.1)
                    continue
                end
                local v4 = nil
                local v5, v6, v7 = pairs(GetAllGenerators())
                local v8 = v7
                local v9 = v5
                local v10 = v6
                local v11, v12

                repeat
                    v11, v12 = v9(v10, v8)
                    if v11 == nil then
                        break
                    end

                    for k, v13 in pairs(GetGeneratorPoints(v12)) do
                        if (humanoidRootPart.Position - v13.Position).Magnitude <= 5 then
                            v4 = v13
                            break
                        end
                    end

                    v8 = v11
                until v4

                if v4 then
                    _G.Ox.AutoCurrentPoint = v4
                    local now = tick()

                    if _G.Ox.AutoFireInterval <= now - _G.Ox.LastFireTime then
                        _G.Ox.PlayRepairAnim()

                        pcall(function()
                            repairEvent:FireServer(v4, true)
                        end)

                        _G.Ox.LastFireTime = now
                    end
                elseif _G.Ox.AutoCurrentPoint then
                    _G.Ox.StopAutoRepair()
                    _G.Ox.AutoRepairEnabled = false

                    if _G.Ox.AutoCurrentGenModel then
                        _G.Ox.ProcessedGens[_G.Ox.AutoCurrentGenModel] = nil
                        _G.Ox.AutoCurrentGenModel = nil
                    end

                    break
                end

                task.wait(0.1)
            end

            _G.Ox.StopAutoRepair()
        end)
    end

    waitForRepairing = function(arg, arg2)
        local now = tick()
        local limit = arg2 or 1
        local parent = arg and arg.Parent

        while true do
            if tick() - now >= limit then
                break
            end

            local isRepairing = false
            pcall(function()
                isRepairing = arg:GetAttribute("IsRepairing") == true
                if not isRepairing and parent then
                    isRepairing = parent:GetAttribute("IsRepairing") == true
                end
            end)

            if isRepairing then
                return true
            end
            task.wait(0.05)
        end

        return false
    end

    RecreateBypassButton = function()
        local bypassGenUI = CoreGui:FindFirstChild("BypassGenUI")

        if bypassGenUI then
            bypassGenUI:Destroy()
        end

        _G.Ox.BypassUI = Instance.new("ScreenGui")
        _G.Ox.BypassUI.Name = "BypassGenUI"
        _G.Ox.BypassUI.ResetOnSpawn = false
        _G.Ox.BypassUI.IgnoreGuiInset = true
        _G.Ox.BypassUI.Parent = CoreGui
        _G.Ox.BypassButton = Instance.new("ImageButton")
        _G.Ox.BypassButton.Name = "BypassGenButton"
        _G.Ox.BypassButton.Size = UDim2.new(0, 55, 0, 55)
        _G.Ox.BypassButton.Position = UDim2.new(0.88, 0, 0.55, 0)
        _G.Ox.BypassButton.AnchorPoint = Vector2.new(0.5, 0.5)
        _G.Ox.BypassButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        _G.Ox.BypassButton.BackgroundTransparency = 0.15
        _G.Ox.BypassButton.AutoButtonColor = true
        _G.Ox.BypassButton.Visible = false
        _G.Ox.BypassButton.ZIndex = 10
        _G.Ox.BypassButton.Parent = _G.Ox.BypassUI
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(1, 0)
        uiCorner.Parent = _G.Ox.BypassButton
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = Color3.fromRGB(255, 255, 255)
        uiStroke.Thickness = 1.5
        uiStroke.Transparency = 0.4
        uiStroke.Parent = _G.Ox.BypassButton
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "GEN"
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.GothamBold
        textLabel.ZIndex = 11
        textLabel.Parent = _G.Ox.BypassButton
        local bypassButton = _G.Ox.BypassButton
        local bypassToggleValue = _G.Ox.BypassToggleValue
        -- FIX GEN BOOST: tombol GEN selalu kelihatan saat toggle ON
        -- (dulu cuma muncul di device touch, jadi di PC tidak ada tombol).
        bypassButton.Visible = bypassToggleValue and true or false
    end

    RecreateBypassButton()

    local function GenBoostHasPrompt()
        for _, name in ipairs({ "SkillCheckPromptGui", "SkillCheckPromptGui-con" }) do
            local gui = playerGui:FindFirstChild(name, true)
            if gui then
                local check = gui:FindFirstChild("Check", true)
                if check and check.Visible then
                    return true
                end
            end
        end
        return false
    end

    local function GenBoostSolveOnce()
        local mode = _G.Ox.Auto.SkillCheckMode
        if mode == "Instant" then
            pcall(VD_InstantSkillcheckUpdate)
        elseif mode == "Random" then
            pcall(VD_RandomSkillcheckUpdate)
        else
            pcall(VD_PerfectSkillcheckUpdate)
        end
    end

    local function GenBoostWaitSkillCheck(limit)
        if not _G.Ox.GenBoostSkillCheck then
            return false
        end

        local t0 = tick()
        local seen = false
        local maxWait = limit or 3

        while tick() - t0 < maxWait do
            if GenBoostHasPrompt() then
                seen = true
                GenBoostSolveOnce()
            elseif seen then
                return true
            end
            task.wait(0.02)
        end

        return seen
    end

    -- =====================================================
    -- GEN BOOST BYPASS â METODE LENGKAP (diambil dari v41)
    -- =====================================================
    -- Alur (sama persis seperti v41):
    --   1. Ambil gen terdekat (cache 5 detik, folder "Map").
    --   2. Loop SEMUA titik gen KECUALI titik target:
    --      anchor HRP -> teleport ke titik -> FireServer(point, true)
    --      -> tunggu IsRepairing -> kalau gagal, retry sekali
    --      -> unanchor.
    --   3. Balikin HRP ke CFrame asli (biar tidak nyangkut di gen).
    --   4. FireServer(targetPoint, false) untuk menutup repair.
    -- GenBypass.Processed mencegah double-repair pada gen yang sama.
    _G.Ox.GenBypass = {
        Enabled    = false,
        Processed  = {},
        HotkeyCode = Enum.KeyCode.G,
    }

    local GB = _G.Ox.GenBypass

    local function GB_GetPoints(genModel)
        return GetGeneratorPoints(genModel)
    end

    local function GB_GetNearestPoint()
        local character = localPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil, math.huge end
        local bestPoint, bestDist = nil, math.huge
        for _, gen in pairs(GetAllGenerators()) do
            for _, point in pairs(GB_GetPoints(gen)) do
                local d = (hrp.Position - point.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    bestPoint = point
                end
            end
        end
        return bestPoint, bestDist
    end

    local function GB_IsPromptVisible()
        local ok, frame = pcall(function()
            return localPlayer.PlayerGui.pcprompts.Frame.GeneratorRepair
        end)
        return ok and frame and frame.Visible
    end

    -- ===== INTI: repair lengkap ala v41 =====
    _G.Ox.DoGenBoostRepair = function(targetPoint)
        if not targetPoint or not targetPoint.Parent then return end
        local genModel = targetPoint.Parent
        if GB.Processed[genModel] then return end
        GB.Processed[genModel] = true

        local character = localPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            GB.Processed[genModel] = nil
            return
        end

        local originalCFrame = hrp.CFrame

        -- Urutkan titik: titik target DIPROSES PERTAMA, lalu titik lain.
        -- (v41 asli melewati titik target; kalau player klik dari jauh,
        --  tidak ada yang di-repair sama sekali -> "malah di tempat".
        --  Sekarang titik target ikut di-repair, jadi selalu ada progress.)
        local ordered = { targetPoint }
        for _, point in pairs(GB_GetPoints(genModel)) do
            if point ~= targetPoint then
                table.insert(ordered, point)
            end
        end

        pcall(function()
            for _, point in pairs(ordered) do
                if point and point.Parent then
                    hrp.Anchored = true
                    hrp.CFrame = point.CFrame
                    task.wait(0.15)

                    pcall(function()
                        repairEvent:FireServer(point, true)
                    end)

                    if not waitForRepairing(point, 0.8) then
                        pcall(function()
                            repairEvent:FireServer(point, false)
                        end)
                        task.wait(0.1)
                        hrp.CFrame = point.CFrame
                        task.wait(0.15)
                        pcall(function()
                            repairEvent:FireServer(point, true)
                        end)
                        waitForRepairing(point, 0.5)
                    end

                    hrp.Anchored = false
                    task.wait(0.05)
                end
            end
        end)

        pcall(function()
            if hrp and hrp.Parent then
                hrp.Anchored = false
                hrp.CFrame = originalCFrame
            end
        end)

        task.wait(0.1)

        pcall(function()
            repairEvent:FireServer(targetPoint, false)
        end)
    end

    -- alias biar pemanggil lama tetap jalan
    _G.Ox.DoMultiRepairPlain = _G.Ox.DoGenBoostRepair

    -- ===== Tombol GEN =====
    _G.Ox.BypassButton.MouseButton1Click:Connect(function()
        if not GB.Enabled then return end
        local bestPoint, bestDist = GB_GetNearestPoint()
        -- boleh dari jarak jauh (<=60) karena metode ini teleport sendiri
        if bestPoint and bestDist <= 60 then
            _G.Ox.DoGenBoostRepair(bestPoint)
        else
            lib:Notify({
                Title = "Gen Boost",
                Description = "Ga ada generator di sekitar!",
                Duration = 1.5,
            })
        end
    end)

    -- ===== Hotkey G (PC) =====
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode ~= GB.HotkeyCode then return end
        if not GB.Enabled then return end
        if not GB_IsPromptVisible() then return end
        local bestPoint, bestDist = GB_GetNearestPoint()
        if not bestPoint or bestDist > 8 then return end
        if GB.Processed[bestPoint.Parent] then return end
        _G.Ox.DoGenBoostRepair(bestPoint)
    end)

    -- ===== Bersihkan Processed kalau sudah jauh dari gen =====
    task.spawn(function()
        while true do
            task.wait(2)
            local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for genModel in pairs(GB.Processed) do
                    if not genModel or not genModel.Parent then
                        GB.Processed[genModel] = nil
                    else
                        local nearAny = false
                        for _, point in pairs(GB_GetPoints(genModel)) do
                            if point.Parent and (hrp.Position - point.Position).Magnitude <= 10 then
                                nearAny = true
                                break
                            end
                        end
                        if not nearAny then
                            GB.Processed[genModel] = nil
                        end
                    end
                end
            end
        end
    end)

    isGeneratorPromptVisible = function()
        local ok, result = pcall(function()
            return localPlayer.PlayerGui.pcprompts.Frame.GeneratorRepair
        end)

        local visible = ok and result and result.Visible
        return visible
    end

    getNearestGenPoint = function()
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end
        local v4 = nil
        local huge = math.huge
        local v5, v6, v7 = pairs(GetAllGenerators())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end

            for k, v13 in pairs(GetGeneratorPoints(v12)) do
                local magnitude = (humanoidRootPart.Position - v13.Position).Magnitude

                if magnitude < huge then
                    huge = magnitude
                    v4 = v13
                end
            end

            v8 = v11
        end

        return v4, huge
    end

    -- FIX PERF (v13.1): handler klik-bebas dihapus (sudah tidak dipakai,
    -- Gen Boost sekarang cuma lewat 1 tombol GEN).
    -- FIX PERF: watcher ProcessedGens (state machine 16 state, loop tiap 2s)
    -- dihapus juga karena ProcessedGens tidak pernah diisi lagi -> hemat CPU.
    startProcessedGensWatcher = function() end
    INVIS_URL = "https://script.panduhub.com/invisibility.lua"
    local v4 = nil
    local flag4 = false
    local touchEnabled = UserInputService.TouchEnabled
    local flag5 = touchEnabled

    if touchEnabled then
        if UserInputService.KeyboardEnabled then
            flag5 = false
        else
            flag5 = true
        end
    end

    local function fn25()
        if flag4 then
            return true
        end

        local ok, result = pcall(function()
            return loadstring(game:HttpGet(INVIS_URL))()
        end)

        if not ok or not result then
            return false
        end
        v4 = result
        flag4 = true
        return true
    end

    local InvisGlowStart = (function()
        local State = { Conn = nil, Stroke = nil, Target = nil, Phase = 0, Polling = false }

        local function textOf(inst)
            local t
            pcall(function() t = inst.Text end)
            if type(t) == "string" and t ~= "" then return t end
            return nil
        end

        local a2gui
        pcall(function() a2gui = (lib and lib._win and lib._win.Gui) or nil end)

        local function hasInvis(o)
            local n = tostring(o.Name or ""):upper()
            if n:find("INVIS") and not n:find("INVISIBILITY") then return true end
            local t = textOf(o)
            if t then
                local u = t:upper()
                if u:find("INVIS") and not u:find("INVISIBILITY") then return true end
            end
            return false
        end

        local function subtreeHasInvis(o)
            for _, d in ipairs(o:GetDescendants()) do
                if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                    local t = textOf(d)
                    if t then
                        local u = t:upper()
                        if u:find("INVIS") and not u:find("INVISIBILITY") then return true end
                    end
                end
            end
            return false
        end

        local function matches(inst)
            if hasInvis(inst) then return true end
            local sz = inst.AbsoluteSize
            if sz and math.max(sz.X, sz.Y) <= 200 and subtreeHasInvis(inst) then return true end
            return false
        end

        local function roots()
            local list = {}
            local okHui, hui = pcall(function() return (gethui and gethui()) or nil end)
            if okHui and hui then table.insert(list, hui) end
            pcall(function() table.insert(list, game:GetService("CoreGui")) end)
            local pg = localPlayer:FindFirstChild("PlayerGui")
            if pg then table.insert(list, pg) end
            return list
        end

        local function find()
            local found
            local function walk(inst, depth)
                if found or depth > 8 then return end
                if a2gui and (inst == a2gui or inst:IsDescendantOf(a2gui)) then return end
                for _, c in ipairs(inst:GetChildren()) do
                    if c:IsA("GuiObject") and matches(c) then
                        found = c
                        return
                    end
                    walk(c, depth + 1)
                    if found then return end
                end
            end
            for _, r in ipairs(roots()) do
                walk(r, 0)
                if found then break end
            end
            return found
        end

        local function isOn(btn)
            local function readText(o)
                local t = textOf(o)
                if t then return t end
                for _, d in ipairs(o:GetDescendants()) do
                    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                        local t2 = textOf(d)
                        if t2 then return t2 end
                    end
                end
                return nil
            end
            local t = (readText(btn) or ""):upper()
            if t:find("OFF") then return false end
            if t:find("ON") then return true end
            local a = btn:GetAttribute("Enabled")
            if type(a) == "boolean" then return a end
            return false
        end

        local function attach(btn)
            State.Target = btn
            local stroke = btn:FindFirstChild("A2InvisGlow")
            if not (stroke and stroke:IsA("UIStroke")) then
                if stroke then stroke:Destroy() end
                stroke = Instance.new("UIStroke")
                stroke.Name = "A2InvisGlow"
                stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                stroke.LineJoinMode = Enum.LineJoinMode.Round
                stroke.Parent = btn
            end
            State.Stroke = stroke
            if State.Conn then State.Conn:Disconnect() end
            State.Conn = RunService.Heartbeat:Connect(function()
                if not (btn and btn.Parent and State.Stroke) then
                    if State.Conn then State.Conn:Disconnect(); State.Conn = nil end
                    return
                end
                State.Phase = (State.Phase + 0.07) % (math.pi * 2)
                local pulse = 0.5 + 0.5 * math.sin(State.Phase)
                local base = isOn(btn) and Color3.fromRGB(90, 255, 150) or Color3.fromRGB(255, 70, 70)
                stroke.Color = base:Lerp(Color3.fromRGB(255, 255, 255), pulse * 0.55)
                stroke.Thickness = 2 + pulse * 1.5
                stroke.Transparency = 0.08 + (1 - pulse) * 0.35
            end)
        end

        local function ensure()
            if State.Target and State.Target.Parent and State.Stroke then return true end
            local btn = find()
            if btn then attach(btn); return true end
            return false
        end

        return function()
            if State.Polling then return end
            State.Polling = true
            task.spawn(function()
                local tries = 0
                while State.Polling and tries < 40 do
                    if ensure() then break end
                    tries = tries + 1
                    task.wait(0.25)
                end
                State.Polling = false
            end)
        end
    end)()

    fn8 = function(arg)
        if arg then
            if not flag4 then
                fn25()
            end

            if v4 then
                if flag5 then
                    v4.ShowGUI()
                else
                    v4.Enable()
                end
            end

            InvisGlowStart()
        elseif v4 then
            if flag5 then
                v4.HideGUI()
            end

            v4.Disable()
        end
    end

    v2 = nil
    local flag6 = false

    local function fn26()
        if flag6 then
            return true
        end

        local ok, result = pcall(function()
            return loadstring(game:HttpGet("https://script.panduhub.com/BoostBandage.lua"))()
        end)

        if not ok or not result then
            return false
        end
        v2 = result
        flag6 = true
        return true
    end

    fn9 = function(arg)
        if arg then
            if not flag6 then
                fn26()
            end

            if v2 then
                if flag5 then
                    v2.ShowGUI()
                elseif not v2.Start() then
                    _G.Ox.Utility.BandageEnabled = false
                end
            end
        elseif v2 then
            if flag5 then
                v2.HideGUI()
            end

            v2.Stop()
        end
    end

    local v5 = nil
    local flag7 = false

    local function fn27()
        if flag7 then
            return true
        end

        local ok, result = pcall(function()
            return loadstring(game:HttpGet("https://pastefy.app/Pu94U00g/raw"))()
        end)

        if not ok or not result then
            return false
        end
        v5 = result
        flag7 = true
        return true
    end

    fn10 = function(arg)
        if arg then
            if not flag7 then
                fn27()
            end

            if v5 then
                if flag5 then
                    v5.ShowGUI()
                else
                    v5.Enable()
                end

                lib:Notify({
                    Title = "Dash Lock",
                    Description = "AKTIF - Klik kanan untuk lock",
                    Duration = 3,
                })
            end
        elseif v5 then
            if flag5 then
                v5.HideGUI()
            end

            v5.Disable()

            lib:Notify({
                Title = "Dash Lock",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    task.spawn(function()
        task.wait(2)
        fn27()
    end)

    local v6 = nil
    local flag8 = false

    local function fn28()
        if flag8 then
            return true
        end

        local ok, result = pcall(function()
            return loadstring(game:HttpGet("https://pastefy.app/NKuKyY5i/raw"))()
        end)

        if not ok or not result then
            return false
        end
        v6 = result
        flag8 = true
        return true
    end

    fn11 = function(arg)
        if arg then
            if not fn28() then
                lib:Notify({
                    Title = "Mask GUI",
                    Description = "Gagal load script!",
                    Duration = 3,
                })

                return
            end

            local v7, v8 = v6.Toggle(true)

            if v7 then
                local notify = lib.Notify
                local tbl7 = {Title = "Mask GUI"}
                local description = v8 or "Dimuat! (Tombol M)"
                tbl7.Description = description
                tbl7.Duration = 3
                notify(lib, tbl7)
            else
                local notify = lib.Notify
                local tbl7 = {Title = "Mask GUI"}
                local description = v8 or "Kamu bukan The Masked!"
                tbl7.Description = description
                tbl7.Duration = 3
                notify(lib, tbl7)
            end
        elseif flag8 and v6 then
            v6.Toggle(false)

            lib:Notify({
                Title = "Mask GUI",
                Description = "Disembunyikan",
                Duration = 2,
            })
        end
    end

    task.spawn(function()
        task.wait(2)
        fn28()
    end)

    getTargetPartObject = function(arg)
        if _G.Ox.AimConfig.AIM_TargetPart == "Head" then
            return arg:FindFirstChild("Head")
        end

        if _G.Ox.AimConfig.AIM_TargetPart == "Root" or _G.Ox.AimConfig.AIM_TargetPart == "HumanoidRootPart" then
            return arg:FindFirstChild("HumanoidRootPart")
        end
        local torso = arg:FindFirstChild("Torso")
        local upperTorso = torso or arg:FindFirstChild("UpperTorso") or arg:FindFirstChild("HumanoidRootPart")
        return upperTorso
    end

    getClosestSurvivor = function()
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end
        local veilFov = _G.Ox.AimConfig.Veil_FOV
        local v7 = nil
        local currentCamera2 = workspace.CurrentCamera
        local vector2 = Vector2.new(currentCamera2.ViewportSize.X / 2, currentCamera2.ViewportSize.Y / 2)

        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Team and player.Team.Name == "Survivors" and player.Character then
                local character2 = player.Character
                local humanoid = character2:FindFirstChildOfClass("Humanoid")
                local v8 = getTargetPartObject(character2)

                if humanoid and humanoid.Health > 0 and v8 and (v8.Position - humanoidRootPart.Position).Magnitude <= _G.Ox.AimConfig.SPEAR_MaxDist then
                    local v9, v10 = currentCamera2:WorldToViewportPoint(v8.Position)

                    if v10 then
                        local magnitude = (Vector2.new(v9.X, v9.Y) - vector2).Magnitude

                        if magnitude <= veilFov then
                            veilFov = magnitude
                            v7 = v8
                        end
                    end
                end
            end
        end

        return v7
    end

    getBestAimbotTarget = function()
        local v7 = nil
        local v8 = GetRole()
        local survAimbotRadius = _G.Ox.Config.Surv_Aimbot_Radius
        local huge = math.huge
        local vector2 = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2)

        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local flag9 = false

                if v8 == "Survivor" and _G.Ox.Config.Surv_Aimbot_Enabled and IsKiller(player) then
                    flag9 = true
                elseif v8 == "Killer" and _G.Ox.Config.Killer_Aimbot_Enabled and not IsKiller(player) then
                    local humanoid = player.Character:FindFirstChild("Humanoid")

                    if humanoid and humanoid.Health > 0 and not IsDowned(player.Character) then
                        flag9 = true
                    end
                end

                if flag9 then
                    local humanoidRootPart = player.Character.HumanoidRootPart
                    local v9 = GetDistance(humanoidRootPart.Position)

                    if v8 == "Survivor" and v9 <= _G.Ox.Config.Surv_Aimbot_MaxDist then
                        local v10, v11 = currentCamera:WorldToViewportPoint(humanoidRootPart.Position)

                        if v11 then
                            local magnitude = (Vector2.new(v10.X, v10.Y) - vector2).Magnitude

                            if magnitude < survAimbotRadius then
                                survAimbotRadius = magnitude
                                v7 = humanoidRootPart
                            end
                        end
                    elseif v8 == "Killer" and v9 <= _G.Ox.Config.Killer_Aimbot_MaxDist and v9 < huge then
                        huge = v9
                        v7 = humanoidRootPart
                    end
                end
            end
        end

        return v7
    end

    getBestKillerAimbotTarget = function()
        local v7 = nil
        local huge = math.huge
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end

        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Team and player.Team.Name == "Survivors" and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

                if humanoid and humanoid.Health > 0 and humanoidRootPart2 and not IsDowned(player.Character) then
                    local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

                    if magnitude < huge and magnitude <= _G.Ox.Config.Killer_Aimbot_MaxDist then
                        huge = magnitude
                        v7 = humanoidRootPart2
                    end
                end
            end
        end

        return v7
    end

    getKillerTargetForFlash = function()
        local v7 = nil
        local huge = math.huge
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end

        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Team and player.Team.Name == "Killer" and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

                if humanoid and humanoid.Health > 0 and humanoidRootPart2 and not IsDowned(player.Character) then
                    local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

                    if magnitude < huge then
                        huge = magnitude
                        v7 = humanoidRootPart2
                    end
                end
            end
        end

        return v7
    end

    NEX_UpdateCureFlaskLaser = function()
        local character = localPlayer.Character
        if not character then
            return
        end
        local position = nil
        local v7 = nil
        local v8 = nil
        local huge = math.huge
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            local leftHand = character:FindFirstChild("LeftHand")
            local leftArm = leftHand or character:FindFirstChild("Left Arm")
            local position2 = leftArm and leftArm.Position or humanoidRootPart.Position
            v7 = position2

            for k, player in pairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not IsKiller(player) then
                    local magnitude = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude

                    if magnitude < huge then
                        huge = magnitude
                        v8 = player
                    end
                end
            end
        end

        if v8 then
            position = v8.Character.HumanoidRootPart.Position
        end

        local flag9 = false

        for k, child in pairs(character:GetChildren()) do
            if child:IsA("LocalScript") and child:GetAttribute("action") == true then
                flag9 = true
                break
            end
        end

        if v7 and position and flag9 then
            if not _G.Ox.NEX_CureFlaskLaserPart then
                local part = Instance.new("Part")
                part.Name = "FlaskSilentAimLaser"
                part.Anchored = true
                part.CanCollide = false
                part.CanTouch = false
                part.CastShadow = false
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(255, 50, 50)
                part.Transparency = 0
                part.Parent = workspace
                _G.Ox.NEX_CureFlaskLaserPart = part
            end

            local magnitude = (position - v7).Magnitude

            if magnitude > 0.1 then
                local nexCureFlaskLaserPart = _G.Ox.NEX_CureFlaskLaserPart
                nexCureFlaskLaserPart.Size = Vector3.new(0.16, 0.16, magnitude)
                nexCureFlaskLaserPart.CFrame = CFrame.new((v7 + position) / 2, position)
                nexCureFlaskLaserPart.Transparency = 0
            end
        elseif _G.Ox.NEX_CureFlaskLaserPart then
            _G.Ox.NEX_CureFlaskLaserPart.Transparency = 1
        end
    end

    NEX_StartCureFlaskLaser = function()
        if _G.Ox.NEX_CureFlaskLaserThread then
            return
        end

        _G.Ox.NEX_CureFlaskLaserThread = RunService.RenderStepped:Connect(function()
            if not _G.Ox.KILLER_FlaskLaser then
                if _G.Ox.NEX_CureFlaskLaserPart then
                    pcall(function()
                        _G.Ox.NEX_CureFlaskLaserPart:Destroy()
                    end)

                    _G.Ox.NEX_CureFlaskLaserPart = nil
                end

                if _G.Ox.NEX_CureFlaskLaserThread then
                    _G.Ox.NEX_CureFlaskLaserThread:Disconnect()
                    _G.Ox.NEX_CureFlaskLaserThread = nil
                end

                return
            end

            pcall(NEX_UpdateCureFlaskLaser)
        end)
    end

    setupSpearInterceptor = function()
        if flag3 then
            return
        end

        if not getrawmetatable or not setreadonly then
            return
        end
        local spearthrow = nil

        pcall(function()
            spearthrow = ReplicatedStorage.Remotes.Killers.Veil.Spearthrow
        end)

        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local fall = remotes and ReplicatedStorage.Remotes:FindFirstChild("Mechanics") and ReplicatedStorage.Remotes.Mechanics:FindFirstChild("Fall")

        local function fn29(arg, arg2, arg3, arg4)
            local n4 = math.max(arg3, 0.1)
            local n5 = arg * arg
            local n6 = n5 * n5 - arg2 * (arg2 * n4 * n4 + 2 * arg4 * n5)
            local n7 = n6

            if n6 < 0 then
                n7 = 0
            end

            local n8 = (n5 - math.sqrt(n7)) / (arg2 * n4)
            local v7 = math.atan(n8)
            return v7, n4 / (arg * math.cos(v7))
        end

        local v7 = getrawmetatable(game)
        setreadonly(v7, false)
        local namecall = v7.__namecall

        v7.__namecall = newcclosure(function(arg, ...)
            local v8 = getnamecallmethod()
            local flag9 = v8 == "FireServer" or v8 == "fireServer" or v8 == "InvokeServer"

            if flag9 and not checkcaller() and typeof(arg) == "Instance" then
                if _G.Ox.NoFall.Enabled and fall and arg == fall then
                    local tbl7 = {...}
                    tbl7[1] = 0
                    return namecall(arg, unpack(tbl7))
                end

                if _G.Ox.AntiBlindEnabled and _G.Ox.GotBlindedRemote and arg == _G.Ox.GotBlindedRemote and localPlayer.Team and localPlayer.Team.Name == "Killer" then
                    return nil
                end

                if _G.Ox.Fake and _G.Ox.Fake.KillerInfFrenzy and (arg.Name == "Deactivatefromclient" or arg.Name == "PowerDoneDeactivating") then
                    return nil
                end

                if _G.Ox.Move and _G.Ox.Move.AntiFallDamage then
                    local okName, rname = pcall(function() return arg.Name:lower() end)
                    if okName and (rname:find("falldamage") or rname:find("fall") or rname:find("ragdollfall")) then
                        return nil
                    end
                end

                if _G.Ox.BulletBlockConfig.Enabled and arg.Name == "Fire" then
                    local parent = arg.Parent
                    if parent and parent.Name == "Twist of Fate" then
                        return nil
                    end
                end

                if (v8 == "FireServer" or v8 == "fireServer") and arg.Name == "Fire"
                    and arg.Parent and arg.Parent.Name == "Twist of Fate" and _G.Ox.PistolRedirect then
                    local args = table.pack(...)
                    local ok, redirected = pcall(_G.Ox.PistolRedirect, args)
                    if ok then
                        if not redirected then return nil end
                        return namecall(arg, table.unpack(redirected, 1, redirected.n))
                    end
                end

                if _G.Ox.KILLER_SilentAimFlask and arg.Name == "ThrowFlask" then
                    local tbl7 = {...}
                    local v9 = nil
                    local huge = math.huge
                    local character = localPlayer.Character
                    local position = character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character.HumanoidRootPart.Position

                    if position then
                        for k, player in pairs(Players:GetPlayers()) do
                            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not IsKiller(player) then
                                local magnitude = (player.Character.HumanoidRootPart.Position - position).Magnitude

                                if magnitude < huge then
                                    huge = magnitude
                                    v9 = player
                                end
                            end
                        end
                    end

                    if v9 and tbl7[2] and typeof(tbl7[2]) == "Vector3" then
                        tbl7[1] = (v9.Character.HumanoidRootPart.Position - tbl7[2]).Unit
                        setnamecallmethod(v8)
                        return namecall(arg, unpack(tbl7))
                    end
                end

                if v8 == "FireServer" and typeof(arg) == "Instance" and string.lower(tostring(arg.Name)) == "updatecharacterlook" then
                    local ox4 = _G.Ox
                    local invisEnabled = ox4 and _G.Ox.Utility and _G.Ox.Utility.InvisEnabled

                    if invisEnabled then
                        local tbl7 = {}

                        for i, v9 in ipairs({...}) do
                            if typeof(v9) == "CFrame" then
                                tbl7[i] = v9 * CFrame.new(0, 5000, 0)
                            else
                                tbl7[i] = v9
                            end
                        end

                        return namecall(arg, unpack(tbl7))
                    end
                end

                if arg.ClassName == "RemoteEvent" and arg.Name == "Spearthrow" and _G.Ox.AimConfig.Aim_SilentVeilV2 and not flag2 then
                    local character = localPlayer.Character
                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                    local v9 = character

                    if character then
                        local head = character:FindFirstChild("Head")
                        v9 = head or humanoidRootPart
                    end

                    local flag10 = character and character:GetAttribute("special") == true
                    local v10, v11

                    if flag10 then
                        local spearAuraSpeed = _G.Ox.AimConfig.SPEAR_AuraSpeed
                        local n4 = spearAuraSpeed or 165
                        v10 = n4
                        local spearAuraGravity = _G.Ox.AimConfig.SPEAR_AuraGravity
                        local n5 = spearAuraGravity or 96.5
                        v11 = n5
                    else
                        local spearSpeed = _G.Ox.AimConfig.SPEAR_Speed
                        local n4 = spearSpeed or 165
                        v10 = n4
                        local spearGravity = _G.Ox.AimConfig.SPEAR_Gravity
                        local n5 = spearGravity or 103
                        v11 = n5
                    end

                    local v12 = v10
                    local value = (select(3, ...))

                    if not (select(3, ...)) then
                        local spearSmartEnable = _G.Ox.Config.SpearSmart_enable
                        value = spearSmartEnable and humanoidRootPart and humanoidRootPart.Position
                    end

                    if not value then
                        value = v9 and v9.Position
                    end

                    local v13 = value
                    local n4 = (...)
                    local v14 = getClosestSurvivor()

                    if v14 and v13 then
                        local isModel = v14:IsA("Model")
                        local humanoidRootPart2 = isModel and v14:FindFirstChild("HumanoidRootPart") or v14
                        local position = humanoidRootPart2.Position
                        local vector = Vector3.new(0, 0, 0)
                        local parent = v14.Parent
                        local humanoid = parent and v14.Parent:FindFirstChildOfClass("Humanoid")

                        if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                            vector = humanoid.MoveDirection * humanoid.WalkSpeed
                        elseif humanoidRootPart2:IsA("BasePart") then
                            vector = humanoidRootPart2.AssemblyLinearVelocity
                        end

                        local vector2 = Vector3.new(vector.X, 0, vector.Z)
                        local n5 = position - v13
                        local magnitude = n5.Magnitude
                        local magnitude2 = Vector3.new(n5.X, 0, n5.Z).Magnitude
                        local y = n5.Y

                        if magnitude > 0.1 then
                            local spearMaxDist = _G.Ox.AimConfig.SPEAR_MaxDist
                            local n6 = spearMaxDist or 1000

                            if magnitude <= n6 then
                                local veilLeadMultiplier = _G.Ox.AimConfig.Veil_LeadMultiplier
                                local n7 = veilLeadMultiplier or 1.4
                                local v15, v16 = fn29(v10, v11, magnitude2, y)

                                if _G.Ox.Config.SpearSmart_enable and vector2.Magnitude > 0.5 then
                                    local n8 = vector2 * (v16 * n7)
                                    local n9 = n8
                                    local n10 = math.clamp(magnitude * 0.6, 3, 45)

                                    if n10 < n8.Magnitude then
                                        n9 = n8.Unit * n10
                                    end

                                    local n11 = position + n9 - v13
                                    local magnitude3 = Vector3.new(n11.X, 0, n11.Z).Magnitude
                                    local value2 = select(1, fn29(v10, v11, math.max(magnitude3, 0.1), n11.Y))

                                    if magnitude3 > 0.001 then
                                        n4 = Vector3.new(n11.X, 0, n11.Z).Unit * math.cos(value2) + Vector3.new(0, math.sin(value2), 0)
                                    else
                                        n4 = n11.Unit
                                    end
                                else
                                    local value2 = select(1, fn29(v10, v11, math.max(magnitude2, 0.1), y))

                                    if magnitude2 > 0.001 then
                                        n4 = Vector3.new(n5.X, 0, n5.Z).Unit * math.cos(value2) + Vector3.new(0, math.sin(value2), 0)
                                    else
                                        n4 = n5.Unit
                                    end
                                end
                            end
                        end
                    end

                    flag2 = true

                    pcall(function()
                        if spearthrow then
                            spearthrow:FireServer(n4, v12, v13)
                        else
                            arg:FireServer(n4, v12, v13)
                        end
                    end)

                    flag2 = false
                    return
                end
            end

            return namecall(arg, ...)
        end)

        setreadonly(v7, true)
        flag3 = true
    end

    local function fn29()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local items = remotes and ReplicatedStorage.Remotes:FindFirstChild("Items")
        local flashlight = items and items:FindFirstChild("Flashlight")

        if flashlight then
            _G.Ox.GotBlindedRemote = flashlight:FindFirstChild("GotBlinded")
        end
    end

    task.spawn(function()
        task.wait(1)
        fn29()
        setupSpearInterceptor()
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        fn29()
    end)
end

local tbl5, fn12, fn13, fn14, fn15, fn16, fn17, fn18, fn19, fn20, fn21, fn22

do
    v3 = Connections
    tbl5 = v3 or {}

    fn12 = function()
        if tbl5.LeapBypass then
            task.cancel(tbl5.LeapBypass)
            tbl5.LeapBypass = nil
        end

        tbl5.LeapBypass = task.spawn(function()
            local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23
            local v24, v25, v26, v27, v28, n
            n = 1

            while true do
                if n == 1 then
                    v4 = nil
                    v5 = nil
                    v6, v7, v8 = pairs(getgc(true))
                    v9 = v8
                    n = 2
                elseif n == 2 then
                    v10, v11 = v6(v7, v9)

                    if v10 == nil then
                        n = 9
                    else
                        n = 3
                    end
                elseif n == 3 then
                    v9 = v10

                    if type(v11) == "function" and islclosure(v11) then
                        n = 4
                    else
                        n = 2
                    end
                elseif n == 4 then
                    v12 = debug.getinfo(v11)

                    if v12.name == "tryActivate" then
                        n = 5
                    else
                        n = 6
                    end
                elseif n == 5 then
                    v4 = v11
                    n = 6
                elseif n == 6 then
                    if v12.name == "playM2Animation" then
                        n = 7
                    else
                        n = 8
                    end
                elseif n == 7 then
                    v5 = v11
                    n = 8
                elseif n == 8 then
                    if v4 and v5 then
                        n = 9
                    else
                        n = 2
                    end
                elseif n == 9 then
                    if not v4 and not v5 then
                        n = 20
                    else
                        n = 10
                    end
                elseif n == 10 then
                    if task.wait(0.1) and _G.Ox.BypassLeapEnabled then
                        n = 12
                    else
                        n = 11
                    end
                elseif n == 11 then
                    return
                elseif n == 12 then
                    v13, v14, v15 = pairs({v4, v5})
                    v16 = v15
                    v17 = v13
                    v18 = v14
                    n = 13
                elseif n == 13 then
                    v19, v20 = v17(v18, v16)

                    if v19 == nil then
                        n = 10
                    else
                        n = 14
                    end
                elseif n == 14 then
                    v16 = v19

                    if v20 then
                        n = 15
                    else
                        n = 13
                    end
                elseif n == 15 then
                    v21, v22, v23 = pairs(debug.getupvalues(v20))
                    v24 = v17
                    v25 = v18
                    v26 = v23
                    n = 16
                elseif n == 16 then
                    v27, v28 = v21(v22, v26)

                    if v27 == nil then
                        n = 19
                    else
                        n = 17
                    end
                elseif n == 17 then
                    v26 = v27

                    if type(v28) == "boolean" and v28 == true then
                        n = 18
                    else
                        n = 16
                    end
                elseif n == 18 then
                    debug.setupvalue(v20, v27, false)
                    n = 16
                elseif n == 19 then
                    v16 = v19
                    v17 = v24
                    v18 = v25
                    n = 13
                elseif n == 20 then
                    warn("[BypassLeap] Function tidak ditemukan.")
                    return
                end
            end
        end)
    end

    local flag2 = false

    local function fn23()
        if GetRole() ~= "Killer" then
            return
        end
        local selectedKiller = localPlayer:FindFirstChild("SelectedKiller")
        local attribute = selectedKiller and selectedKiller.Value or localPlayer:GetAttribute("SelectedKiller")

        if attribute and string.find(string.lower(tostring(attribute)), "abyss") then
            pcall(function()
                local corrupt = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Killers"):FindFirstChild("Abysswalker"):FindFirstChild("corrupt")

                if corrupt then
                    corrupt:FireServer()
                end
            end)
        end
    end

    local function fn24()
        if flag2 then
            return
        end
        flag2 = true

        task.spawn(function()
            while flag2 and _G.Ox.InfAbyssalEnabled and GetRole() == "Killer" do
                fn23()
                task.wait(0.5)
            end
        end)
    end

    fn13 = function()
        flag2 = false
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end

        if _G.Ox.InfAbyssalEnabled and input.KeyCode == Enum.KeyCode.Q then
            fn24()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Q then
            fn13()
        end
    end)

    task.spawn(function()
        while _G.Ox.ScriptAlive do
            task.wait(0.5)
            if not _G.Ox.ScriptAlive then
                break
            end

            if _G.Ox.InfAbyssalEnabled and GetRole() == "Killer" then
                local playerGui2 = localPlayer:FindFirstChild("PlayerGui")

                if playerGui2 then
                    local v4 = nil

                    for k, child in pairs(playerGui2:GetChildren()) do
                        if string.sub(child.Name, -4) == "-mob" and child.Name ~= "Survivor-mob" then
                            v4 = child
                            break
                        end
                    end

                    if v4 then
                        local controls = v4:FindFirstChild("Controls")

                        if controls then
                            local move2 = controls:FindFirstChild("move2")

                            if move2 and move2.Visible then
                                fn24()
                            else
                                fn13()
                            end
                        end
                    end
                end
            else
                fn13()
            end
        end
    end)

    EnableInfiniteLunge = function()
        _G.Ox.InfiniteLungeEnabled = true
        local character = localPlayer.Character

        if character then
            character:SetAttribute("lungeboost", 999)

            if _G.Ox.InfLungeAttrConn then
                _G.Ox.InfLungeAttrConn:Disconnect()
            end

            _G.Ox.InfLungeAttrConn = character:GetAttributeChangedSignal("lungeboost"):Connect(function()
                if _G.Ox.InfiniteLungeEnabled and character:GetAttribute("lungeboost") ~= 999 then
                    character:SetAttribute("lungeboost", 999)
                end
            end)
        end

        lib:Notify({
            Title = "Infinite Lunge",
            Description = "AKTIF (999x)",
            Duration = 3,
        })
    end

    DisableInfiniteLunge = function()
        _G.Ox.InfiniteLungeEnabled = false

        if _G.Ox.InfLungeAttrConn then
            _G.Ox.InfLungeAttrConn:Disconnect()
            _G.Ox.InfLungeAttrConn = nil
        end

        local character = localPlayer.Character

        if character then
            character:SetAttribute("lungeboost", 1)
        end

        lib:Notify({
            Title = "Infinite Lunge",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end

    localPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.8)

        if _G.Ox.InfiniteLungeEnabled and character then
            character:SetAttribute("lungeboost", 999)
        end
    end)

    StopCounterParry = function()
        _G.Ox.CounterParry.Enabled = false

        if _G.Ox.CounterParry.Thread then
            task.cancel(_G.Ox.CounterParry.Thread)
            _G.Ox.CounterParry.Thread = nil
        end

        if _G.Ox.CounterParry.Track then
            pcall(function()
                _G.Ox.CounterParry.Track:Stop()
            end)

            _G.Ox.CounterParry.Track = nil
        end
    end

    StartCounterParry = function()
        if _G.Ox.CounterParry.Thread then
            return
        end

        _G.Ox.CounterParry.Thread = task.spawn(function()
            local character, humanoid, animator, humanoidRootPart, animation, ok, track, flag3, distance, v4, v5, v6, v7, v8, v9, character2, humanoidRootPart2, n
            n = 1

            while true do
                if n == 1 then
                    if _G.Ox.CounterParry.Enabled and _G.Ox.ScriptAlive then
                        n = 3
                    else
                        n = 2
                    end
                elseif n == 2 then
                    _G.Ox.CounterParry.Thread = nil
                    return
                elseif n == 3 then
                    character = localPlayer.Character

                    if character and character.Parent and GetRole() == "Killer" then
                        n = 5
                    else
                        n = 4
                    end
                elseif n == 4 then
                    task.wait(0.4)
                    n = 1
                elseif n == 5 then
                    humanoid = character:FindFirstChildOfClass("Humanoid")
                    animator = humanoid

                    if humanoid then
                        n = 6
                    else
                        n = 7
                    end
                elseif n == 6 then
                    animator = humanoid:FindFirstChildOfClass("Animator")
                    n = 7
                elseif n == 7 then
                    humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                    if animator and humanoidRootPart then
                        n = 9
                    else
                        n = 8
                    end
                elseif n == 8 then
                    task.wait(0.3)
                    n = 1
                elseif n == 9 then
                    if _G.Ox.CounterParry.Track and _G.Ox.CounterParry.Track.Parent ~= nil then
                        n = 13
                    else
                        n = 10
                    end
                elseif n == 10 then
                    animation = Instance.new("Animation")
                    animation.AnimationId = _G.Ox.CounterParry.AnimId

                    ok, track = pcall(function()
                        return animator:LoadAnimation(animation)
                    end)

                    if ok and track then
                        n = 12
                    else
                        n = 11
                    end
                elseif n == 11 then
                    task.wait(0.5)
                    n = 1
                elseif n == 12 then
                    _G.Ox.CounterParry.Track = track
                    n = 13
                elseif n == 13 then
                    flag3 = false
                    distance = _G.Ox.CounterParry.Distance
                    v4, v5, v6 = ipairs(Players:GetPlayers())
                    v7 = v6
                    n = 14
                elseif n == 14 then
                    v8, v9 = v4(v5, v7)

                    if v8 == nil then
                        n = 20
                    else
                        n = 15
                    end
                elseif n == 15 then
                    v7 = v8

                    if v9 ~= localPlayer and v9.Team and v9.Team.Name == "Survivors" then
                        n = 16
                    else
                        n = 14
                    end
                elseif n == 16 then
                    character2 = v9.Character
                    humanoidRootPart2 = character2

                    if character2 then
                        n = 17
                    else
                        n = 18
                    end
                elseif n == 17 then
                    humanoidRootPart2 = v9.Character:FindFirstChild("HumanoidRootPart")
                    n = 18
                elseif n == 18 then
                    if humanoidRootPart2 and (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude <= distance then
                        n = 19
                    else
                        n = 14
                    end
                elseif n == 19 then
                    flag3 = true
                    n = 20
                elseif n == 20 then
                    if flag3 and _G.Ox.CounterParry.Track then
                        n = 21
                    else
                        n = 22
                    end
                elseif n == 21 then
                    pcall(function()
                        _G.Ox.CounterParry.Track:Play()
                        _G.Ox.CounterParry.Track:AdjustWeight(0)
                    end)

                    task.wait(0.05)

                    pcall(function()
                        _G.Ox.CounterParry.Track:Stop()
                    end)

                    n = 22
                elseif n == 22 then
                    task.wait(_G.Ox.CounterParry.Interval)
                    n = 1
                end
            end
        end)
    end

    ToggleCounterParry = function(arg)
        if arg then
            if GetRole() ~= "Killer" then
                lib:Notify({
                    Title = "Counter Auto Parry",
                    Description = "Khusus Killer!",
                    Duration = 3,
                })

                _G.Ox.CounterParry.Enabled = false

                if CounterParryToggle then
                    fn(CounterParryToggle, false)
                end

                return
            end

            _G.Ox.CounterParry.Enabled = true
            StartCounterParry()

            lib:Notify({
                Title = "Counter Auto Parry",
                Description = "AKTIF",
                Duration = 2,
            })
        else
            StopCounterParry()

            lib:Notify({
                Title = "Counter Auto Parry",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        _G.Ox.CounterParry.Track = nil
        task.wait(1)

        if _G.Ox.CounterParry.Enabled then
            StartCounterParry()
        end
    end)

    local function fn25()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local killers = remotes and remotes:FindFirstChild("Killers")
        local stalker = killers and killers:FindFirstChild("Stalker")
        local startStalking = stalker and stalker:FindFirstChild("StartStalking")
        return startStalking
    end

    local function fn26()
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end
        local v4 = nil
        local huge = math.huge
        local range = _G.Ox.AutoStalk.Range

        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

                if humanoid and humanoidRootPart2 and humanoid.Health > 30 then
                    local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

                    if magnitude <= range and magnitude < huge then
                        huge = magnitude
                        v4 = player
                    end
                end
            end
        end

        return v4
    end

    StopAutoStalk = function()
        _G.Ox.AutoStalk.Enabled = false

        if _G.Ox.AutoStalk.Conn then
            _G.Ox.AutoStalk.Conn:Disconnect()
            _G.Ox.AutoStalk.Conn = nil
        end
    end

    StartAutoStalk = function()
        if _G.Ox.AutoStalk.Conn then
            return
        end

        _G.Ox.AutoStalk.Conn = RunService.Heartbeat:Connect(function()
            if not _G.Ox.AutoStalk.Enabled or not _G.Ox.ScriptAlive then
                return
            end

            if GetRole() ~= "Killer" then
                return
            end
            local now = tick()
            local lastFire = _G.Ox.AutoStalk.LastFire
            local n = lastFire or 0
            if now - n < 0.35 then
                return
            end
            local v4 = fn26()
            if not v4 or not v4.Character then
                return
            end
            local v5 = fn25()

            if v5 then
                _G.Ox.AutoStalk.LastFire = now

                pcall(function()
                    v5:FireServer(v4)
                end)
            end
        end)
    end

    ToggleAutoStalk = function(arg)
        if arg then
            if GetRole() ~= "Killer" then
                lib:Notify({
                    Title = "Auto Stalk",
                    Description = "Khusus Killer!",
                    Duration = 3,
                })

                _G.Ox.AutoStalk.Enabled = false

                if AutoStalkToggle then
                    fn(AutoStalkToggle, false)
                end

                return
            end

            _G.Ox.AutoStalk.Enabled = true
            StartAutoStalk()
            lib:Notify({Title = "Auto Stalk", Description = "AKTIF", Duration = 2})
        else
            StopAutoStalk()

            lib:Notify({
                Title = "Auto Stalk",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FOVCircleGui_Standalone"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = CoreGui
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.Visible = false
    frame.Parent = screenGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
    local uiStroke = Instance.new("UIStroke", frame)
    uiStroke.Color = Color3.fromRGB(255, 255, 255)
    uiStroke.Thickness = 1.5
    local highlight = Instance.new("Highlight")
    highlight.Name = "VD_VeilTarget"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    v4 = nil

    local function fn27()
        if v4 then
            pcall(function()
                v4:Destroy()
            end)

            v4 = nil
        end
    end

    local function fn28(arg, arg2)
        if arg and arg2 then
            local magnitude = (arg2 - arg).Magnitude

            if magnitude < 0.2 then
                if v4 then
                    v4.Transparency = 1
                end

                return
            end

            if not v4 then
                local part = Instance.new("Part")
                part.Name = "VeilTrackerLine"
                part.Anchored = true
                part.CanCollide = false
                part.CanTouch = false
                part.CanQuery = false
                part.CastShadow = false
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(255, 255, 255)
                part.Parent = workspace
                v4 = part
            end

            local vector = Vector3.new(0.08, 0.08, magnitude)
            v4.Size = vector
            local cframe = CFrame.new((arg + arg2) / 2, arg2)
            v4.CFrame = cframe
            v4.Transparency = 0.15
            return
        end

        if v4 then
            v4.Transparency = 1
        end
    end

    _G.Ox.SurvivorFOVGui = Instance.new("ScreenGui")
    _G.Ox.SurvivorFOVGui.Name = "SurvivorAimbotFOV"
    _G.Ox.SurvivorFOVGui.ResetOnSpawn = false
    _G.Ox.SurvivorFOVGui.IgnoreGuiInset = true
    _G.Ox.SurvivorFOVGui.Parent = CoreGui
    _G.Ox.SurvivorFOVFrame = Instance.new("Frame")
    _G.Ox.SurvivorFOVFrame.BackgroundTransparency = 1
    _G.Ox.SurvivorFOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _G.Ox.SurvivorFOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    _G.Ox.SurvivorFOVFrame.Visible = false
    _G.Ox.SurvivorFOVFrame.Parent = _G.Ox.SurvivorFOVGui
    Instance.new("UICorner", _G.Ox.SurvivorFOVFrame).CornerRadius = UDim.new(1, 0)
    local uiStroke2 = Instance.new("UIStroke", _G.Ox.SurvivorFOVFrame)
    uiStroke2.Color = Color3.fromRGB(255, 255, 255)
    uiStroke2.Thickness = 1.5
    uiStroke2.Transparency = 0.5
    _G.Ox.survivorAimbotHighlight = Instance.new("Highlight")
    _G.Ox.survivorAimbotHighlight.Name = "SurvivorAimbotTarget"
    _G.Ox.survivorAimbotHighlight.FillColor = Color3.fromRGB(255, 0, 0)
    _G.Ox.survivorAimbotHighlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    _G.Ox.survivorAimbotHighlight.FillTransparency = 0.4
    _G.Ox.survivorAimbotHighlight.OutlineTransparency = 0.2
    _G.Ox.killerAimbotHighlight = Instance.new("Highlight")
    _G.Ox.killerAimbotHighlight.Name = "KillerAimbotTarget"
    _G.Ox.killerAimbotHighlight.FillColor = Color3.fromRGB(255, 0, 0)
    _G.Ox.killerAimbotHighlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    _G.Ox.killerAimbotHighlight.FillTransparency = 0.4
    _G.Ox.killerAimbotHighlight.OutlineTransparency = 0.2

    StopMoonwalk = function()
        _G.Ox.Moonwalk.Enabled = false
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.AutoRotate = true
        end
    end

    StartMoonwalk = function()
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoidRootPart or not humanoid then
            return
        end
        humanoid.AutoRotate = false
        _G.Ox.Moonwalk.Enabled = true
    end

    UpdateMoonwalkGUI = function(arg)
        if not _G.Ox.Moonwalk.Gui then
            return
        end
        local frame2 = _G.Ox.Moonwalk.Gui:FindFirstChild("Frame")
        if not frame2 then
            return
        end
        local actionButton = frame2:FindFirstChild("ActionButton")
        local uiStroke3 = frame2:FindFirstChild("UIStroke")

        if arg then
            if actionButton then
                actionButton.Text = "MOON [ON]"
                actionButton.TextColor3 = Color3.fromRGB(180, 255, 180)
                actionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            end

            if uiStroke3 then
                uiStroke3.Color = Color3.fromRGB(100, 200, 100)
            end
        else
            if actionButton then
                actionButton.Text = "MOON [OFF]"
                actionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                actionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            end

            if uiStroke3 then
                uiStroke3.Color = Color3.fromRGB(90, 90, 95)
            end
        end
    end

    ToggleMoonwalkStatus = function()
        if _G.Ox.Moonwalk.Enabled then
            StopMoonwalk()
        else
            StartMoonwalk()
        end

        _G.Ox.Moonwalk.IsActive = _G.Ox.Moonwalk.Enabled
        UpdateMoonwalkGUI(_G.Ox.Moonwalk.Enabled)

        if MoonwalkPCToggle then
            fn(MoonwalkPCToggle, _G.Ox.Moonwalk.Enabled)
        end

        local notify = lib.Notify
        local tbl6 = {Title = "Moonwalk"}
        local enabled = _G.Ox.Moonwalk.Enabled
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl6.Description = description
        tbl6.Duration = 2
        notify(lib, tbl6)
    end

    CreateMoonwalkGUI = function()
        if _G.Ox.Moonwalk.Gui then
            _G.Ox.Moonwalk.Gui:Destroy()
        end

        local screenGui2 = Instance.new("ScreenGui")
        screenGui2.Name = "MoonwalkCustomGui"
        screenGui2.ResetOnSpawn = false
        screenGui2.IgnoreGuiInset = true
        screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui2.Parent = CoreGui
        screenGui2.Enabled = false
        _G.Ox.Moonwalk.Gui = screenGui2
        _G.Ox.Moonwalk.GuiVisible = false
        local frame2 = Instance.new("Frame", screenGui2)
        frame2.Name = "Frame"
        frame2.Size = UDim2.fromOffset(110, 36)
        frame2.Position = UDim2.fromScale(0.85, 0.45)
        frame2.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        frame2.BackgroundTransparency = 0.1
        frame2.Active = true
        frame2.BorderSizePixel = 0
        Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 8)
        local uiStroke3 = Instance.new("UIStroke", frame2)
        uiStroke3.Name = "UIStroke"
        uiStroke3.Color = Color3.fromRGB(90, 90, 95)
        uiStroke3.Thickness = 1.5
        uiStroke3.Transparency = 0.2
        local textButton = Instance.new("TextButton", frame2)
        textButton.Name = "ActionButton"
        textButton.Size = UDim2.new(1, 0, 1, 0)
        textButton.Text = "MOON [OFF]"
        textButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 12
        textButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        textButton.BorderSizePixel = 0
        textButton.AutoButtonColor = false
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 8)
        local flag3 = false
        local flag4 = false
        local flag5 = false
        local position = nil
        local position2 = nil
        local thread = nil

        local function fn29(arg)
            if not flag3 or not flag5 or not position or not position2 then
                return
            end

            if _G.Ox.Moonwalk.DragLocked then
                return
            end
            local n = arg.Position - position

            if not flag4 and (math.abs(n.X) > 18 or math.abs(n.Y) > 18) then
                flag4 = true
            end

            if flag4 then
                frame2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n.X, position2.Y.Scale, position2.Y.Offset + n.Y)
            end
        end

        textButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag3 = true
                flag4 = false
                flag5 = false
                position = input.Position
                position2 = frame2.Position

                if thread then
                    task.cancel(thread)
                end

                thread = task.delay(0.18, function()
                    if flag3 then
                        flag5 = true
                    end
                end)
            end
        end)

        textButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if thread then
                    task.cancel(thread)
                end

                if flag3 and not flag4 then
                    ToggleMoonwalkStatus()
                end

                flag3 = false
                flag4 = false
                flag5 = false
                position = nil
                position2 = nil
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if flag3 and flag5 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                fn29(input)
            end
        end)

        if _G.Ox.Moonwalk._statusConn then
            _G.Ox.Moonwalk._statusConn:Disconnect()
        end

        _G.Ox.Moonwalk._statusConn = RunService.Heartbeat:Connect(function()
            if _G.Ox.Moonwalk.Gui and _G.Ox.Moonwalk.Gui.Parent then
                if _G.Ox.Moonwalk.IsActive ~= _G.Ox.Moonwalk.Enabled then
                    _G.Ox.Moonwalk.IsActive = _G.Ox.Moonwalk.Enabled
                    UpdateMoonwalkGUI(_G.Ox.Moonwalk.Enabled)
                end

                return
            end

            if _G.Ox.Moonwalk._statusConn then
                _G.Ox.Moonwalk._statusConn:Disconnect()
            end
        end)
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1)

        if _G.Ox.Moonwalk.Enabled then
            StartMoonwalk()
        end

        if _G.Ox.Moonwalk.GuiVisible and _G.Ox.Moonwalk.Gui then
            _G.Ox.Moonwalk.Gui.Enabled = true
            UpdateMoonwalkGUI(_G.Ox.Moonwalk.Enabled)
        end
    end)

    task.spawn(function()
        task.wait(1.5)
        CreateMoonwalkGUI()
    end)

    RunService.RenderStepped:Connect(function(deltaTime)
        if not _G.Ox.Speed.Enabled and not _G.Ox.Moonwalk.Enabled and not _G.Ox.Crosshair.Enabled and not _G.Ox.StretchRes.Enabled and not _G.Ox.Config.Surv_Aimbot_Enabled and (not _G.Ox.Config.Killer_Aimbot_Enabled or not _G.Ox.isKillerAimbotHolding) and not _G.Ox.AimConfig.Aim_SilentVeilV2 and (not flag or not _G.Ox.AimConfig.Flash_Silent) then
            return
        end

        if _G.Ox.Crosshair.Enabled then
            DrawCrosshair()
        end

        if _G.Ox.Speed.Enabled then
            local character = localPlayer.Character

            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    local moveDirection = humanoid.MoveDirection

                    if moveDirection.Magnitude > 0 then
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart then
                            local n = (_G.Ox.Speed.Value - 0.1) * 10

                            if n > 0 then
                                humanoidRootPart.CFrame = humanoidRootPart.CFrame + moveDirection * n * deltaTime
                            end
                        end
                    end
                end
            end
        end

        if _G.Ox.Moonwalk.Enabled then
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local currentCamera2 = workspace.CurrentCamera

            if humanoidRootPart and humanoid and currentCamera2 and humanoid.Health > 0 then
                if humanoid.AutoRotate ~= false then
                    humanoid.AutoRotate = false
                end

                local camLook = currentCamera2.CFrame.LookVector
                local flatLook = Vector3.new(camLook.X, 0, camLook.Z)

                if humanoid.MoveDirection.Magnitude > 0 and flatLook.Magnitude >= 0.01 then
                    flatLook = flatLook.Unit
                    _G.Ox.Moonwalk.Counter = (_G.Ox.Moonwalk.Counter or 0) + deltaTime * (_G.Ox.Moonwalk.SwaySpeed or 56)
                    local swayOffset = math.sin(_G.Ox.Moonwalk.Counter) * math.rad(_G.Ox.Moonwalk.SwayAngle or 23)
                    humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + flatLook)
                        * CFrame.Angles(0, swayOffset + math.rad(180), 0)
                end
            end
        end

        if _G.Ox.StretchRes.Enabled and currentCamera then
            currentCamera.CFrame = currentCamera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, _G.Ox.StretchRes.Amount, 0, 0, 0, 1)
        end

        if flag and _G.Ox.AimConfig.Flash_Silent then
            local v5 = getKillerTargetForFlash()

            if v5 then
                local character = localPlayer.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                local n = v5.Position + Vector3.new(0, _G.Ox.AimConfig.Flash_YOffset, 0)
                local currentCamera2 = workspace.CurrentCamera
                currentCamera2.CFrame = currentCamera2.CFrame:Lerp(CFrame.lookAt(currentCamera2.CFrame.Position, n), 0.5)

                if humanoidRootPart then
                    local cframe = CFrame.lookAt(humanoidRootPart.Position, Vector3.new(n.X, humanoidRootPart.Position.Y, n.Z))
                    humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(cframe, 0.5)
                end
            end
        end

        if _G.Ox.Config.Surv_Aimbot_Enabled then
            if GetRole() == "Survivor" then
                if _G.Ox.Config.Surv_Aimbot_ShowFOV then
                    _G.Ox.SurvivorFOVFrame.Visible = true
                    _G.Ox.SurvivorFOVFrame.Size = UDim2.new(0, _G.Ox.Config.Surv_Aimbot_Radius * 2, 0, _G.Ox.Config.Surv_Aimbot_Radius * 2)
                else
                    _G.Ox.SurvivorFOVFrame.Visible = false
                end

                local v5 = getBestAimbotTarget()

                if v5 then
                    _G.Ox.survivorAimbotHighlight.Parent = v5.Parent
                    local position = v5.Position
                    local n = position
                    local v6 = GetDistance(position)

                    if v6 < 100 then
                        n = position + currentCamera.CFrame.RightVector * ((100 - v6) * _G.Ox.Config.Surv_Aimbot_Predict)
                    end

                    local cframe = CFrame.new(currentCamera.CFrame.Position, n)
                    currentCamera.CFrame = currentCamera.CFrame:Lerp(cframe, _G.Ox.Config.Surv_Aimbot_Smoothness)
                    local character = localPlayer.Character
                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                    if humanoidRootPart then
                        local cframe2 = CFrame.new(humanoidRootPart.Position, Vector3.new(n.X, humanoidRootPart.Position.Y, n.Z))
                        humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(cframe2, _G.Ox.Config.Surv_Aimbot_Smoothness)
                    end
                else
                    _G.Ox.survivorAimbotHighlight.Parent = nil
                end
            end
        else
            _G.Ox.SurvivorFOVFrame.Visible = false
            _G.Ox.survivorAimbotHighlight.Parent = nil
        end

        if _G.Ox.Config.Killer_Aimbot_Enabled and _G.Ox.isKillerAimbotHolding then
            if GetRole() == "Killer" then
                if _G.Ox.lockedKillerAimbotTarget then
                    local parent = _G.Ox.lockedKillerAimbotTarget.Parent
                    local humanoid = parent and parent:FindFirstChild("Humanoid")

                    if not humanoid or humanoid.Health <= 0 or IsDowned(parent) then
                        _G.Ox.lockedKillerAimbotTarget = getBestKillerAimbotTarget()
                    end

                    if _G.Ox.lockedKillerAimbotTarget then
                        local position = _G.Ox.lockedKillerAimbotTarget.Position
                        local v5 = GetDistance(position)

                        if _G.Ox.Config.Killer_Aimbot_MaxDist < v5 then
                            _G.Ox.lockedKillerAimbotTarget = getBestKillerAimbotTarget()
                        else
                            _G.Ox.killerAimbotHighlight.Parent = parent
                            local cframe = CFrame.new(currentCamera.CFrame.Position, position)
                            currentCamera.CFrame = currentCamera.CFrame:Lerp(cframe, _G.Ox.Config.Killer_Aimbot_Smoothness)
                            local character = localPlayer.Character
                            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                            if humanoidRootPart then
                                local cframe2 = CFrame.new(humanoidRootPart.Position, Vector3.new(position.X, humanoidRootPart.Position.Y, position.Z))
                                humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(cframe2, _G.Ox.Config.Killer_Aimbot_Smoothness)
                            end
                        end
                    end
                else
                    _G.Ox.lockedKillerAimbotTarget = getBestKillerAimbotTarget()
                end
            end
        elseif _G.Ox.killerAimbotHighlight then
            _G.Ox.killerAimbotHighlight.Parent = nil
        end

        local character = localPlayer.Character
        local flag3 = character and character:GetAttribute("spearmode") == true
        local aimSilentVeilV2 = _G.Ox.AimConfig.Aim_SilentVeilV2
        local v5 = aimSilentVeilV2 and flag3
        local veilShowFOV = v5 and _G.Ox.AimConfig.Veil_ShowFOV

        if veilShowFOV then
            frame.Visible = true
            frame.Size = UDim2.new(0, _G.Ox.AimConfig.Veil_FOV * 2, 0, _G.Ox.AimConfig.Veil_FOV * 2)
        else
            frame.Visible = false
        end

        if veilShowFOV then
            local v6 = getClosestSurvivor()

            if v6 and v6.Parent then
                highlight.Parent = v6.Parent
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                local v7 = character

                if character then
                    local head = character:FindFirstChild("Head")
                    v7 = head or humanoidRootPart
                end

                local position = v7 and v7.Position
                fn28(position, v6.Position)
            else
                highlight.Parent = nil
                fn28(nil, nil)
            end
        else
            highlight.Parent = nil
            fn28(nil, nil)

            if not v5 then
                fn27()
            end
        end
    end)

    local n = 0

    RunService.Heartbeat:Connect(function()
        if _G.Ox.ParryConfig.ParryCircle and _G.Ox.ParryConfig.AutoParry then
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                if not _G.Ox.State.AutoParryAdornment or _G.Ox.State.AutoParryAdornment.Parent ~= humanoidRootPart then
                    if _G.Ox.State.AutoParryAdornment then
                        _G.Ox.State.AutoParryAdornment:Destroy()
                    end

                    _G.Ox.State.AutoParryAdornment = Instance.new("CylinderHandleAdornment")
                    _G.Ox.State.AutoParryAdornment.Name = "AutoParryCircleESP"
                    _G.Ox.State.AutoParryAdornment.Height = 0.05
                    _G.Ox.State.AutoParryAdornment.Transparency = 0.3
                    _G.Ox.State.AutoParryAdornment.Adornee = humanoidRootPart
                    _G.Ox.State.AutoParryAdornment.Parent = humanoidRootPart
                    _G.Ox.State.AutoParryAdornment.ZIndex = 0
                    _G.Ox.State.AutoParryAdornment.AlwaysOnTop = false
                end

                local parryRadius = _G.Ox.ParryConfig.ParryRadius
                _G.Ox.State.AutoParryAdornment.Radius = parryRadius
                _G.Ox.State.AutoParryAdornment.InnerRadius = math.max(0.1, parryRadius - 0.15)
                _G.Ox.State.AutoParryAdornment.CFrame = CFrame.new(0, -3, 0) * CFrame.Angles(math.rad(90), 0, 0)

                if _G.Ox.State.ParryCooldown then
                    _G.Ox.State.AutoParryAdornment.Color3 = Color3.fromRGB(255, 128, 0)
                elseif _G.Ox.ParryConfig.ParryAggressive then
                    _G.Ox.State.AutoParryAdornment.Color3 = Color3.fromRGB(255, 0, 0)
                else
                    _G.Ox.State.AutoParryAdornment.Color3 = Color3.fromRGB(255, 255, 255)
                end
            elseif _G.Ox.State.AutoParryAdornment then
                _G.Ox.State.AutoParryAdornment:Destroy()
                _G.Ox.State.AutoParryAdornment = nil
            end
        elseif _G.Ox.State.AutoParryAdornment then
            _G.Ox.State.AutoParryAdornment:Destroy()
            _G.Ox.State.AutoParryAdornment = nil
        end

        if _G.Ox.GodMode then
            local character = localPlayer.Character

            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid and humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end

        if _G.Ox.AutoPallet.Enabled then
            for k in pairs(_G.Ox.AutoPallet.UsedPallets) do
                if not k or not k.Parent then
                    _G.Ox.AutoPallet.UsedPallets[k] = nil
                end
            end
        end

        if _G.Ox.CameraFOV.Enabled then
            currentCamera.FieldOfView = _G.Ox.CameraFOV.Value
        end

        if _G.Ox.NoSlowdownEnabled then
            local character = localPlayer.Character

            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid and GetRole() == "Killer" and humanoid.WalkSpeed < 16 then
                    humanoid.WalkSpeed = 16
                end
            end
        end

        if _G.Ox.ESPConfig.Master and tick() - n >= 2 then
            n = tick()
            UpdatePlayerESP()
            UpdateSCPESP()
            UpdateStaticESP()
        end
    end)

    local items = ReplicatedStorage:WaitForChild("Items", 5)

    extractAssetId = function(arg)
        return tostring(arg):match("%d+")
    end

    getItemIcon = function(arg)
        if not items then
            return nil
        end
        local v5 = items:FindFirstChild(arg)
        if not v5 then
            return nil
        end
        local v6 = nil

        pcall(function()
            local texture = v5.Texture
            local image = texture or v5.Image
            v6 = image
        end)

        if v6 and v6 ~= "" then
            local v7 = extractAssetId(v6)
            if v7 then
                return string.format("rbxthumb://type=Asset&id=%s&w=420&h=420", v7)
            end
        end

        return nil
    end

    CreateModernESP = function(parent, name, arg)
        if not parent then
            return
        end
        local name2 = arg.name
        local str = name2 or ""
        local flag3 = str ~= ""
        local flag4 = name ~= "PE_Text"

        if not flag4 then
            if flag3 then
                flag4 = false
            else
                flag4 = true
            end
        end

        local str2 = flag4 and "single" or "multi"
        local infoRich = arg.infoRich
        local text = infoRich or ""

        if text == "" then
            local tbl6 = {}

            if arg.subtext and arg.subtext ~= "" then
                table.insert(tbl6, tostring(arg.subtext))
            end

            if arg.distance then
                table.insert(tbl6, tostring(arg.distance) .. "m")
            end

            text = table.concat(tbl6, " <font color=\"#888888\">Â·</font> ")
        end

        local v5 = parent:FindFirstChild(name)
        local v6 = v5

        if v5 and v5:GetAttribute("Layout") ~= str2 then
            v5:Destroy()
            v6 = nil
        end

        if not v6 then
            local billboardGui = Instance.new("BillboardGui")
            v6 = billboardGui
            billboardGui.Name = name
            billboardGui.AlwaysOnTop = true
            billboardGui:SetAttribute("Layout", str2)
            local udim2 = flag4 and UDim2.new(0, 220, 0, 22) or UDim2.new(0, 220, 0, 34)
            billboardGui.Size = udim2
            local vector = Vector3.new
            local offsetY = arg.offsetY
            local n2 = offsetY or 4
            billboardGui.StudsOffset = vector(0, n2, 0)
            billboardGui.Parent = parent
            local frame2 = Instance.new("Frame")
            frame2.Name = "Box"
            frame2.BackgroundTransparency = 1
            frame2.Size = UDim2.new(1, 0, 1, 0)
            frame2.AnchorPoint = Vector2.new(0.5, 0.5)
            frame2.Position = UDim2.new(0.5, 0, 0.5, 0)
            frame2.Parent = billboardGui

            if arg.noDistScale then
                billboardGui:SetAttribute("NoDistScale", true)
            else
                local uiScale = Instance.new("UIScale")
                uiScale.Name = "DistScale"
                uiScale.Scale = 1
                uiScale.Parent = frame2
            end

            if flag4 then
                local uiListLayout = Instance.new("UIListLayout", frame2)
                uiListLayout.FillDirection = Enum.FillDirection.Horizontal
                uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                uiListLayout.Padding = UDim.new(0, 4)
                local imageLabel = Instance.new("ImageLabel")
                imageLabel.Name = "Icon"
                imageLabel.BackgroundTransparency = 1
                imageLabel.Size = UDim2.new(0, 14, 0, 14)
                imageLabel.Visible = false
                imageLabel.Parent = frame2
                local textLabel = Instance.new("TextLabel")
                textLabel.Name = "Text"
                textLabel.BackgroundTransparency = 1
                textLabel.AutomaticSize = Enum.AutomaticSize.XY
                textLabel.Font = Enum.Font.GothamBold
                textLabel.TextSize = 12
                textLabel.TextWrapped = false
                textLabel.TextYAlignment = Enum.TextYAlignment.Center
                textLabel.RichText = true
                textLabel.TextStrokeTransparency = 0
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel.Parent = frame2
            else
                local uiListLayout = Instance.new("UIListLayout", frame2)
                uiListLayout.FillDirection = Enum.FillDirection.Vertical
                uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                uiListLayout.Padding = UDim.new(0, 0)
                local frame3 = Instance.new("Frame")
                frame3.Name = "Row1"
                frame3.BackgroundTransparency = 1
                frame3.AutomaticSize = Enum.AutomaticSize.XY
                frame3.Size = UDim2.new(0, 0, 0, 16)
                frame3.Parent = frame2
                local uiListLayout2 = Instance.new("UIListLayout", frame3)
                uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
                uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
                uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
                uiListLayout2.Padding = UDim.new(0, 4)
                local imageLabel = Instance.new("ImageLabel")
                imageLabel.Name = "Icon"
                imageLabel.BackgroundTransparency = 1
                imageLabel.Size = UDim2.new(0, 14, 0, 14)
                imageLabel.Visible = false
                imageLabel.Parent = frame3
                local textLabel = Instance.new("TextLabel")
                textLabel.Name = "Name"
                textLabel.BackgroundTransparency = 1
                textLabel.AutomaticSize = Enum.AutomaticSize.XY
                textLabel.Font = Enum.Font.GothamBold
                textLabel.TextSize = 12
                textLabel.TextWrapped = false
                textLabel.TextYAlignment = Enum.TextYAlignment.Center
                textLabel.TextStrokeTransparency = 0
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel.Parent = frame3
                local textLabel2 = Instance.new("TextLabel")
                textLabel2.Name = "Info"
                textLabel2.BackgroundTransparency = 1
                textLabel2.AutomaticSize = Enum.AutomaticSize.XY
                textLabel2.Font = Enum.Font.GothamBold
                textLabel2.TextSize = 11
                textLabel2.TextWrapped = false
                textLabel2.TextYAlignment = Enum.TextYAlignment.Center
                textLabel2.RichText = true
                textLabel2.TextStrokeTransparency = 0
                textLabel2.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel2.Parent = frame2
            end
        end

        local box = v6:FindFirstChild("Box")

        if flag4 then
            local text2 = box and box:FindFirstChild("Text")
            local icon = box and box:FindFirstChild("Icon")

            if text2 then
                local str3 = "#FFFFFF"

                if arg.color then
                    str3 = string.format("#%02X%02X%02X", math.floor(arg.color.R * 255), math.floor(arg.color.G * 255), math.floor(arg.color.B * 255))
                end

                local v7 = tostring
                local str4 = str or ""
                local str5 = v7(str4):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                local text3 = ""

                if flag3 then
                    text3 = string.format("<font color=\"%s\">%s</font>", str3, str5)
                end

                if text ~= "" then
                    if text3 == "" then
                        text3 = text
                    elseif arg.noSeparator then
                        text3 = text3 .. " " .. text
                    else
                        text3 = text3 .. " <font color=\"#888888\">Â·</font> " .. text
                    end
                end

                text2.Text = text3
            end

            if icon then
                if arg.icon and arg.icon ~= "" then
                    icon.Image = arg.icon
                    icon.Visible = true
                else
                    icon.Visible = false
                end
            end
        else
            local row1 = box and box:FindFirstChild("Row1")
            local name3 = row1 and row1:FindFirstChild("Name")
            local icon = row1 and row1:FindFirstChild("Icon")
            local info = box and box:FindFirstChild("Info")

            if name3 then
                name3.Text = tostring(str):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                local color = arg.color
                local color2 = color or Color3.new(1, 1, 1)
                name3.TextColor3 = color2
            end

            if icon then
                if arg.icon and arg.icon ~= "" then
                    icon.Image = arg.icon
                    icon.Visible = true
                else
                    icon.Visible = false
                end
            end

            if info then
                if text == "" then
                    info.Visible = false
                else
                    info.Visible = true
                    info.Text = text
                end
            end
        end
    end

    local function fn29()
        local team = localPlayer.Team
        local flag3 = team and localPlayer.Team.Name == "Survivors"
        return flag3
    end

    local function fn30(arg)
        local humanoid = arg:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return false
        end
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return false
        end

        for i, v5 in ipairs(animator:GetPlayingAnimationTracks()) do
            if v5.Animation and string.find(tostring(v5.Animation.AnimationId), "126081405469607") then
                return true
            end
        end

        return false
    end

    local function fn31(arg)
        if not _G.Ox.FakePerks.QuickRecoveryEnabled then
            return
        end

        if not fn29() then
            return
        end

        if _G.Ox.FakePerks.boostActive then
            return
        end

        if tick() - _G.Ox.FakePerks.lastQRTime < _G.Ox.FakePerks.PerkCooldown then
            return
        end
        _G.Ox.FakePerks.boostActive = true
        _G.Ox.FakePerks.lastQRTime = tick()
        local now = tick()

        task.spawn(function()
            while _G.Ox.FakePerks.QuickRecoveryEnabled and tick() - now < 3 do
                if arg and arg.Parent then
                    arg:SetAttribute("speedboost", 1.4)
                end

                task.wait()
            end

            if arg and arg.Parent then
                arg:SetAttribute("speedboost", 1)
            end

            _G.Ox.FakePerks.boostActive = false
        end)
    end

    local function fn32(arg)
        if _G.Ox.FakePerks.qrConnection then
            _G.Ox.FakePerks.qrConnection:Disconnect()
            _G.Ox.FakePerks.qrConnection = nil
        end

        if not arg then
            return
        end

        _G.Ox.FakePerks.qrConnection = arg:GetAttributeChangedSignal("isvaulting"):Connect(function()
            if arg:GetAttribute("isvaulting") == true then
                task.spawn(function()
                    task.wait(0.05)
                    local v5 = fn30(arg)
                    local v6 = v5

                    if not v5 then
                        task.wait(0.05)
                        v6 = fn30(arg)
                    end

                    if not v6 and arg:GetAttribute("isvaulting") == true then
                        fn31(arg)
                    end
                end)
            end
        end)
    end

    ToggleQuickRecovery = function(quickRecoveryEnabled)
        _G.Ox.FakePerks.QuickRecoveryEnabled = quickRecoveryEnabled

        if quickRecoveryEnabled and localPlayer.Character then
            fn32(localPlayer.Character)
        elseif not quickRecoveryEnabled and _G.Ox.FakePerks.qrConnection then
            _G.Ox.FakePerks.qrConnection:Disconnect()
            _G.Ox.FakePerks.qrConnection = nil
        end

        local notify = lib.Notify
        local tbl6 = {Title = "Fake Quick Recovery"}
        local description = quickRecoveryEnabled and "AKTIF" or "NONAKTIF"
        tbl6.Description = description
        tbl6.Duration = 2
        notify(lib, tbl6)
    end

    local function fn33(arg)
        if not _G.Ox.FakePerks.PerfectLandingEnabled then
            return
        end

        if not fn29() then
            return
        end

        if _G.Ox.FakePerks.perfectLandingBoostActive then
            return
        end

        if tick() - _G.Ox.FakePerks.lastPLTime < _G.Ox.FakePerks.PerkCooldown then
            return
        end
        _G.Ox.FakePerks.perfectLandingBoostActive = true
        _G.Ox.FakePerks.lastPLTime = tick()
        local now = tick()

        task.spawn(function()
            while _G.Ox.FakePerks.perfectLandingBoostActive and tick() - now < 3 do
                if arg and arg.Parent then
                    arg:SetAttribute("speedboost", 1.4)
                end

                task.wait()
            end

            if arg and arg.Parent then
                arg:SetAttribute("speedboost", 1)
            end

            _G.Ox.FakePerks.perfectLandingBoostActive = false
        end)
    end

    local function fn34(arg)
        if _G.Ox.FakePerks.plConnection then
            _G.Ox.FakePerks.plConnection:Disconnect()
            _G.Ox.FakePerks.plConnection = nil
        end

        if not arg then
            return
        end

        _G.Ox.FakePerks.plConnection = arg:GetAttributeChangedSignal("speedboost"):Connect(function()
            if not fn29() then
                return
            end

            if arg:GetAttribute("speedboost") == 0.625 then
                fn33(arg)
            end
        end)
    end

    TogglePerfectLanding = function(perfectLandingEnabled)
        _G.Ox.FakePerks.PerfectLandingEnabled = perfectLandingEnabled

        if perfectLandingEnabled then
            if localPlayer.Character then
                fn34(localPlayer.Character)
            end
        else
            if _G.Ox.FakePerks.plConnection then
                _G.Ox.FakePerks.plConnection:Disconnect()
                _G.Ox.FakePerks.plConnection = nil
            end

            if _G.Ox.FakePerks.perfectLandingBoostActive and localPlayer.Character then
                localPlayer.Character:SetAttribute("speedboost", 1)
                _G.Ox.FakePerks.perfectLandingBoostActive = false
            end
        end

        local notify = lib.Notify
        local tbl6 = {Title = "Fake Perfect Landing"}
        local description = perfectLandingEnabled and "AKTIF" or "NONAKTIF"
        tbl6.Description = description
        tbl6.Duration = 2
        notify(lib, tbl6)
    end

    local function fn35(arg)
        if _G.Ox.FakePerks.fsConnection then
            _G.Ox.FakePerks.fsConnection:Disconnect()
            _G.Ox.FakePerks.fsConnection = nil
        end

        if _G.Ox.FakePerks.fsAnimConnection then
            _G.Ox.FakePerks.fsAnimConnection:Disconnect()
            _G.Ox.FakePerks.fsAnimConnection = nil
        end

        if not arg then
            return
        end
        local humanoid = arg:WaitForChild("Humanoid", 3)
        if not humanoid then
            return
        end
        local animator = humanoid:WaitForChild("Animator", 3)
        if not animator then
            return
        end

        _G.Ox.FakePerks.fsAnimConnection = animator.AnimationPlayed:Connect(function(arg2)
            if not arg2.Animation then
                return
            end

            if arg2.Animation.AnimationId ~= "rbxassetid://136962284480779" then
                return
            end
            local connection = nil

            connection = arg2.Stopped:Connect(function()
                if connection then
                    connection:Disconnect()
                end

                _G.Ox.FakePerks.lastFSTime = tick()
                _G.Ox.FakePerks.fsOnCooldown = true

                if arg and arg.Parent then
                    arg:SetAttribute("Flowstate", false)
                end

                task.delay(_G.Ox.FakePerks.PerkCooldown, function()
                    _G.Ox.FakePerks.fsOnCooldown = false

                    if _G.Ox.FakePerks.FlowstateEnabled and arg and arg.Parent then
                        arg:SetAttribute("Flowstate", true)
                    end
                end)
            end)
        end)

        _G.Ox.FakePerks.fsConnection = arg:GetAttributeChangedSignal("Flowstate"):Connect(function()
            if not _G.Ox.FakePerks.FlowstateEnabled then
                return
            end

            if not fn29() then
                return
            end
            local attribute = arg:GetAttribute("Flowstate")

            if attribute == true then
                if _G.Ox.FakePerks.fsOnCooldown or tick() - _G.Ox.FakePerks.lastFSTime < _G.Ox.FakePerks.PerkCooldown then
                    arg:SetAttribute("Flowstate", false)
                end
            elseif attribute == false and not _G.Ox.FakePerks.fsOnCooldown then
                local n2 = tick() - _G.Ox.FakePerks.lastFSTime

                if _G.Ox.FakePerks.PerkCooldown <= n2 then
                    arg:SetAttribute("Flowstate", true)
                end
            end
        end)

        task.wait(0.5)

        if _G.Ox.FakePerks.FlowstateEnabled and arg and arg.Parent then
            arg:SetAttribute("Flowstate", true)
        end
    end

    ToggleFlowstate = function(flowstateEnabled)
        _G.Ox.FakePerks.FlowstateEnabled = flowstateEnabled

        if flowstateEnabled then
            if localPlayer.Character then
                fn35(localPlayer.Character)
            end
        else
            if _G.Ox.FakePerks.fsConnection then
                _G.Ox.FakePerks.fsConnection:Disconnect()
                _G.Ox.FakePerks.fsConnection = nil
            end

            if _G.Ox.FakePerks.fsAnimConnection then
                _G.Ox.FakePerks.fsAnimConnection:Disconnect()
                _G.Ox.FakePerks.fsAnimConnection = nil
            end

            if localPlayer.Character then
                localPlayer.Character:SetAttribute("Flowstate", false)
            end
        end

        local notify = lib.Notify
        local tbl6 = {Title = "Fake Flowstate"}
        local description = flowstateEnabled and "AKTIF" or "NONAKTIF"
        tbl6.Description = description
        tbl6.Duration = 2
        notify(lib, tbl6)
    end

    local function fn36()
        local adrenalineConns = _G.Ox.FakePerks.adrenalineConns
        if not adrenalineConns then
            return
        end

        for i, adrenalineConn in ipairs(adrenalineConns) do
            pcall(function()
                adrenalineConn:Disconnect()
            end)
        end

        _G.Ox.FakePerks.adrenalineConns = {}
    end

    local function fn37(arg)
        if not _G.Ox.FakePerks.FakeAdrenalineRush then
            return
        end

        if not fn29() then
            return
        end

        if not arg or not arg.Parent then
            return
        end

        if _G.Ox.FakePerks.boostActive then
            return
        end
        local now = tick()
        local lastARTime = _G.Ox.FakePerks.lastARTime
        local n2 = lastARTime or 0
        if now - n2 < _G.Ox.FakePerks.PerkCooldown then
            return
        end
        _G.Ox.FakePerks.boostActive = true
        _G.Ox.FakePerks.lastARTime = tick()
        local now2 = tick()

        task.spawn(function()
            while _G.Ox.FakePerks.FakeAdrenalineRush and tick() - now2 < 5 do
                if arg and arg.Parent then
                    arg:SetAttribute("speedboost", 1.4)
                end

                task.wait()
            end

            if arg and arg.Parent then
                arg:SetAttribute("speedboost", 1)
            end

            _G.Ox.FakePerks.boostActive = false
        end)
    end

    local function fn38(arg)
        if not arg then
            return
        end
        local humanoid = arg:FindFirstChildOfClass("Humanoid")
        local humanoid2 = humanoid or arg:WaitForChild("Humanoid", 5)
        if not humanoid2 then
            return
        end
        local health = humanoid2.Health

        table.insert(_G.Ox.FakePerks.adrenalineConns, humanoid2.HealthChanged:Connect(function(health2)
            if not _G.Ox.FakePerks.FakeAdrenalineRush then
                return
            end

            if health2 < health and health2 <= 50 and health2 > 0 then
                fn37(arg)
            end

            health = health2
        end))
    end

    SetupFakeAdrenalineRush = function(arg)
        local fakePerks = _G.Ox.FakePerks
        local fakeAdrenalineRush = arg == true
        fakePerks.FakeAdrenalineRush = fakeAdrenalineRush
        local fakePerks2 = _G.Ox.FakePerks
        local adrenalineOn = arg == true
        fakePerks2.adrenalineOn = adrenalineOn
        fn36()

        if not arg then
            lib:Notify({
                Title = "Fake Perks",
                Description = "Adrenaline Rush OFF",
                Duration = 2,
            })

            return
        end

        fn38(localPlayer.Character)

        table.insert(_G.Ox.FakePerks.adrenalineConns, localPlayer.CharacterAdded:Connect(function(character)
            task.wait(0.3)

            if _G.Ox.FakePerks.FakeAdrenalineRush then
                fn38(character)
            end
        end))

        lib:Notify({
            Title = "Fake Perks",
            Description = "Adrenaline Rush ON",
            Duration = 3,
        })
    end

    local function fn39(character)
        task.wait(0.5)

        if _G.Ox.FakePerks.QuickRecoveryEnabled then
            fn32(character)
        end

        if _G.Ox.FakePerks.PerfectLandingEnabled then
            fn34(character)
        end

        if _G.Ox.FakePerks.FlowstateEnabled then
            fn35(character)
        end

        if _G.Ox.FakePerks.FakeAdrenalineRush then
            fn38(character)
        end
    end

    if localPlayer.Character then
        fn39(localPlayer.Character)
    end

    localPlayer.CharacterAdded:Connect(fn39)

    local function fn40()
        if not _G.Ox.StreamerMode.Enabled then
            return
        end
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return
        end

        local function fn41(arg)
            if not arg:IsA("TextLabel") and not arg:IsA("TextButton") and not arg:IsA("TextBox") then
                if arg:IsA("ImageLabel") or arg:IsA("ImageButton") then
                    local function fn42()
                        if not _G.Ox.StreamerMode.Enabled then
                            return
                        end
                        local image = arg.Image
                        local flag3 = false

                        for i, player in ipairs(Players:GetPlayers()) do
                            if string.find(image, tostring(player.UserId)) then
                                if not arg:GetAttribute("OriginalImage") then
                                    arg:SetAttribute("OriginalImage", image)
                                end

                                flag3 = true
                                break
                            end

                            continue
                        end

                        if flag3 and arg.Image ~= BRAND_ASSET then
                            arg.Image = BRAND_ASSET
                        end
                    end

                    fn42()
                    local connection = arg:GetPropertyChangedSignal("Image"):Connect(fn42)
                    table.insert(_G.Ox.StreamerMode.SpooferConns, connection)
                end
            else
                local function fn42()
                    if not _G.Ox.StreamerMode.Enabled then
                        return
                    end
                    local text = arg.Text
                    local v5 = text
                    local flag3 = false

                    if not arg:GetAttribute("OriginalText") then
                        arg:SetAttribute("OriginalText", text)
                    end

                    for i, player in ipairs(Players:GetPlayers()) do
                        if string.find(v5, player.Name) or string.find(v5, player.DisplayName) then
                            local v6 = string.gsub(v5, player.Name, BRAND_NAME)
                            v5 = string.gsub(v6, player.DisplayName, BRAND_NAME)
                            flag3 = true
                        end
                    end

                    if flag3 and arg.Text ~= v5 then
                        arg.Text = v5
                    end
                end

                fn42()
                local connection = arg:GetPropertyChangedSignal("Text"):Connect(fn42)
                table.insert(_G.Ox.StreamerMode.SpooferConns, connection)
            end
        end

        for i, descendant in ipairs(playerGui2:GetDescendants()) do
            fn41(descendant)
        end

        local connection = playerGui2.DescendantAdded:Connect(function(descendant)
            task.defer(function()
                fn41(descendant)
            end)
        end)

        table.insert(_G.Ox.StreamerMode.SpooferConns, connection)
    end

    local function fn41()
        for i, spooferConn in ipairs(_G.Ox.StreamerMode.SpooferConns) do
            if spooferConn.Connected then
                spooferConn:Disconnect()
            end
        end

        table.clear(_G.Ox.StreamerMode.SpooferConns)
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")

        if playerGui2 then
            for i, descendant in ipairs(playerGui2:GetDescendants()) do
                if not descendant:IsA("TextLabel") and not descendant:IsA("TextButton") and not descendant:IsA("TextBox") then
                    if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                        local attribute = descendant:GetAttribute("OriginalImage")

                        if attribute then
                            descendant.Image = attribute
                            descendant:SetAttribute("OriginalImage", nil)
                        end
                    end
                else
                    local attribute = descendant:GetAttribute("OriginalText")

                    if attribute then
                        descendant.Text = attribute
                        descendant:SetAttribute("OriginalText", nil)
                    end
                end
            end
        end
    end

    local function fn42(enabled)
        _G.Ox.StreamerMode.Enabled = enabled

        if enabled then
            fn40()

            lib:Notify({
                Title = "Streamer Mode",
                Description = "AKTIF - Nama player disembunyikan",
                Duration = 3,
            })
        else
            fn41()

            lib:Notify({
                Title = "Streamer Mode",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1)

        if _G.Ox.StreamerMode.Enabled then
            fn41()
            fn27()
            task.wait(0.5)
            fn40()
        end
    end)

    playerGui.ChildAdded:Connect(function()
        task.wait(0.5)

        if _G.Ox.StreamerMode.Enabled then
            fn40()
        end
    end)

    local function fn43(enabled)
        _G.Ox.StretchRes.Enabled = enabled
        local notify = lib.Notify
        local tbl6 = {Title = "Stretch Res"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl6.Description = description
        tbl6.Duration = 2
        notify(lib, tbl6)
    end

    local tbl6 = {}

    UpdateHookData = function()
        for k, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Team and player.Team.Name == "Survivors" then
                local attribute = player:GetAttribute("HookCount")
                local n2 = attribute or 0
                tbl6[player.Name] = n2
            end
        end
    end

    CreateHookESP = function(parent, arg)
        if not _G.Ox.ESPConfig.HookCount then
            return
        end
        local name = "HookESP_" .. parent.Name
        local v5 = parent:FindFirstChild(name)

        if v5 then
            v5:Destroy()
        end

        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = name
        billboardGui.Parent = parent
        billboardGui.AlwaysOnTop = true
        billboardGui.Size = UDim2.new(0, 40, 0, 14)
        billboardGui.StudsOffset = Vector3.new(0, 5.5, 0)
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 11
        textLabel.TextScaled = true
        textLabel.Text = string.format("Hooked %d", arg)
        textLabel.TextXAlignment = Enum.TextXAlignment.Center
        textLabel.TextYAlignment = Enum.TextYAlignment.Center
        textLabel.Parent = billboardGui

        if arg >= 3 then
            textLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        elseif arg >= 2 then
            textLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        else
            textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end

        local uiStroke3 = Instance.new("UIStroke")
        uiStroke3.Color = Color3.fromRGB(0, 0, 0)
        uiStroke3.Thickness = 2
        uiStroke3.Transparency = 0.5
        uiStroke3.Parent = textLabel
    end

    local tbl7 = {
        "rbxassetid://120434965879067",
        "rbxassetid://81511619438196",
        "rbxassetid://130571419892864",
    }

    CreateHookUICounter = function(parent, arg)
        if not parent then
            return
        end
        local num = tonumber(arg)
        local n2 = num or 0
        local v5 = n2
        local oXioHookCounter = parent:FindFirstChild("OXio_HookCounter")
        local v6 = oXioHookCounter

        if v5 <= 0 then
            if oXioHookCounter then
                oXioHookCounter:Destroy()
            end

            return
        end

        local v7 = tbl7[math.clamp(v5, 1, 3)]
        if not v7 then
            return
        end

        if not oXioHookCounter then
            local imageLabel = Instance.new("ImageLabel")
            v6 = imageLabel
            imageLabel.Name = "OXio_HookCounter"
            imageLabel.BackgroundTransparency = 1
            local zIndex = parent.ZIndex
            local n3 = zIndex or 1
            imageLabel.ZIndex = n3 + 1
            imageLabel.Parent = parent
        end

        v6.Size = UDim2.new(0.509, 0, 0.51, 0)
        v6.Position = UDim2.new(0.91, 0, 0.18, 0)
        v6.AnchorPoint = Vector2.new(0.5, 0.5)
        v6.Image = v7
        v6.ScaleType = Enum.ScaleType.Fit
    end

    UpdateHookUICounter = function()
        if GetRole() == "Killer" then
            local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
            if not playerGui2 then
                return
            end

            local function fn44(arg)
                if arg and type(arg) == "string" then
                    return tonumber(arg:match("id=(%d+)"))
                end
                return nil
            end

            local v5, v6, v7 = ipairs(playerGui2:GetChildren())
            local v8 = v7
            local v9 = v5
            local v10 = v6

            while true do
                local v11, v12 = v9(v10, v8)
                if v11 == nil then
                    break
                end
                v8 = v11

                if typeof(v12) == "Instance" then
                    local frame2 = v12:FindFirstChild("Frame")

                    if frame2 and frame2:IsA("Frame") then
                        for i, child in ipairs(frame2:GetChildren()) do
                            local imageLabel = child:FindFirstChild("ImageLabel")

                            if imageLabel then
                                local attribute = child:GetAttribute("UserId")
                                local v13 = attribute or fn44(imageLabel.Image)
                                local playerByUserId = v13 and Players:GetPlayerByUserId(tonumber(v13)) or nil

                                if playerByUserId and playerByUserId ~= localPlayer and playerByUserId.Team and playerByUserId.Team.Name == "Survivors" then
                                    local v14 = tbl6[playerByUserId.Name]
                                    local attribute2 = v14 or playerByUserId:GetAttribute("HookCount") or 0
                                    CreateHookUICounter(imageLabel, attribute2)
                                else
                                    local oXioHookCounter = imageLabel:FindFirstChild("OXio_HookCounter")

                                    if oXioHookCounter then
                                        oXioHookCounter:Destroy()
                                    end
                                end
                            end
                        end

                        v8 = v11
                    end
                end
            end

            return
        end

        ClearHookUICounter()
    end

    ClearHookUICounter = function()
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return
        end
        local v5, v6, v7 = ipairs(playerGui2:GetChildren())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            v8 = v11

            if typeof(v12) == "Instance" then
                local frame2 = v12:FindFirstChild("Frame")

                if frame2 and frame2:IsA("Frame") then
                    for i, child in ipairs(frame2:GetChildren()) do
                        local imageLabel = child:FindFirstChild("ImageLabel")
                        local oXioHookCounter = imageLabel and imageLabel:FindFirstChild("OXio_HookCounter")

                        if oXioHookCounter then
                            oXioHookCounter:Destroy()
                        end
                    end

                    v8 = v11
                end
            end
        end
    end

    UpdateHookESP = function()
        if not _G.Ox.ESPConfig.HookCount then
            ClearHookESP()
        end
    end

    ClearHookESP = function()
        local v5, v6, v7 = pairs(Players:GetPlayers())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            v8 = v11

            if v12.Character then
                for k, child in pairs(v12.Character:GetChildren()) do
                    if string.match(child.Name, "^HookESP_") then
                        child:Destroy()
                    end
                end

                v8 = v11
            end
        end
    end

    ClearESP = function(arg)
        if arg == "Player" then
            for k, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    if player.Character:FindFirstChild("PEH") then
                        player.Character.PEH:Destroy()
                    end

                    if player.Character:FindFirstChild("PE_Text") then
                        player.Character.PE_Text:Destroy()
                    end
                end
            end
        elseif arg == "Killer" then
            for k, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    if player.Character:FindFirstChild("KEH") then
                        player.Character.KEH:Destroy()
                    end

                    if player.Character:FindFirstChild("KE_Text") then
                        player.Character.KE_Text:Destroy()
                    end
                end
            end
        elseif arg == "Generator" then
            for k, generator in pairs(tbl4.Generators) do
                if generator.model and generator.model.Parent and generator.model:FindFirstChild("GEH") then
                    generator.model.GEH:Destroy()
                end

                if generator.part and generator.part.Parent and generator.part:FindFirstChild("GE_Text") then
                    generator.part.GE_Text:Destroy()
                end
            end
        elseif arg == "Pallet" then
            for k, pallet in pairs(tbl4.Pallets) do
                if pallet and pallet.Parent and pallet:FindFirstChild("PalletEH") then
                    pallet.PalletEH:Destroy()
                end
            end
        elseif arg == "Hook" then
            for k, hook in pairs(tbl4.Hooks) do
                if hook and hook.Parent and hook:FindFirstChild("HookEH") then
                    hook.HookEH:Destroy()
                end
            end
        elseif arg == "Window" then
            for k, window in pairs(tbl4.Windows) do
                if window and window.Parent and window:FindFirstChild("WindowEH") then
                    window.WindowEH:Destroy()
                end
            end
        elseif arg == "Gate" then
            for k, gate in pairs(tbl4.Gates) do
                if gate and gate.Parent and gate:FindFirstChild("GateEH") then
                    gate.GateEH:Destroy()
                end
            end
        elseif arg == "SCP" then
            for k, scP in pairs(tbl4.SCPs) do
                if scP and scP.Parent and scP:FindFirstChild("SCPEH") then
                    scP.SCPEH:Destroy()
                end
            end
        end
    end

    ClearAllESP = function()
        ClearESP("Player")
        ClearESP("Killer")
        ClearESP("Generator")
        ClearESP("Pallet")
        ClearESP("Hook")
        ClearESP("Gate")
        ClearESP("SCP")
        ClearESP("Window")
        ClearHookESP()
    end

    GetSurvivorStatus = function(arg)
        if not arg then
            return nil, nil
        end

        if arg:GetAttribute("IsHooked") == true then
            return "HOOKED", _G.Ox.ESPColors.Hooked
        end

        if arg:GetAttribute("Knocked") == true then
            return "DOWN", _G.Ox.ESPColors.Downed
        end
        local humanoid = arg:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
            return "INJURED", _G.Ox.ESPColors.Injured
        end
        return nil, nil
    end

    buildInfoRich = function(arg, arg2, arg3, arg4, arg5)
        local tbl8 = {}

        if arg and arg ~= "" then
            local str = "#FFFFFF"

            if arg == "INJURED" then
                str = "#FF8C00"
            elseif arg == "DOWN" then
                str = "#FF2828"
            elseif arg == "HOOKED" then
                str = "#F0F0FF"
            end

            table.insert(tbl8, string.format("<font color=\"%s\">%s</font>", str, arg))
        end

        if arg3 then
            table.insert(tbl8, string.format("<font color=\"#FFFFFF\">%dm</font>", arg3))
        end

        if not arg5 and arg4 and arg ~= "HOOKED" then
            local str = "#C8C8C8"

            if arg4 >= 3 then
                str = "#FF3232"
            elseif arg4 >= 2 then
                str = "#FFC832"
            end

            table.insert(tbl8, string.format("<font color=\"%s\">Hooked %d</font>", str, arg4))
        end

        return table.concat(tbl8, " <font color=\"#888888\">Â·</font> ")
    end

    UpdatePlayerESP = function()
        if not _G.Ox.ESPConfig.Master then
            return
        end
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        if _G.Ox.ESPConfig.KillerWarn and humanoidRootPart and GetRole() == "Survivor" then
            local killerWarn = humanoidRootPart:FindFirstChild("KillerWarn")
            local v5 = killerWarn
            local huge = math.huge

            for k, player in pairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Team and player.Team.Name == "Killer" and player.Character then
                    local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

                    if humanoidRootPart2 then
                        local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

                        if magnitude < huge then
                            huge = magnitude
                        end
                    end
                end
            end

            if huge <= 80 then
                if not killerWarn then
                    local billboardGui = Instance.new("BillboardGui")
                    v5 = billboardGui
                    billboardGui.Name = "KillerWarn"
                    billboardGui.Size = UDim2.new(0, 30, 0, 30)
                    billboardGui.AlwaysOnTop = true
                    billboardGui.StudsOffset = Vector3.new(0, 4, 0)
                    billboardGui.Parent = humanoidRootPart
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Name = "WarnText"
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextScaled = true
                    textLabel.TextStrokeTransparency = 0
                    textLabel.Font = Enum.Font.GothamBlack
                    textLabel.Parent = billboardGui
                end

                local warnText = v5:FindFirstChild("WarnText")

                if warnText then
                    if huge <= 40 then
                        warnText.Text = "!!"
                        warnText.TextColor3 = Color3.fromRGB(255, 0, 0)
                    else
                        warnText.Text = "!"
                        warnText.TextColor3 = Color3.fromRGB(255, 255, 0)
                    end
                end
            elseif killerWarn then
                killerWarn:Destroy()
            end
        else
            local killerWarn = humanoidRootPart and humanoidRootPart:FindFirstChild("KillerWarn")

            if killerWarn then
                killerWarn:Destroy()
            end
        end

        local v5, v6, v7 = pairs(Players:GetPlayers())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            v8 = v11

            if v12 ~= localPlayer and v12.Character then
                local humanoidRootPart2 = v12.Character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart2 and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - humanoidRootPart2.Position).Magnitude then
                    for i, v13 in ipairs({"PE_Text", "KE_Text", "PEH", "KEH"}) do
                        local v14 = v12.Character:FindFirstChild(v13)

                        if v14 then
                            v14:Destroy()
                        end
                    end

                    v8 = v11
                else
                    local team = v12.Team
                    local flag3 = team and v12.Team.Name == "Killer"
                    local killer

                    if flag3 then
                        killer = _G.Ox.ESPConfig.Killer
                    else
                        local player = _G.Ox.ESPConfig.Player
                        local hookCount = player or _G.Ox.ESPConfig.HookCount
                        killer = hookCount
                    end

                    local str = flag3 and "KE_Text" or "PE_Text"
                    local name = flag3 and "KEH" or "PEH"
                    local killer2 = flag3 and _G.Ox.ESPColors.Killer or _G.Ox.ESPColors.Player
                    local v13 = nil
                    local v14 = nil

                    if not flag3 and _G.Ox.ESPConfig.Status then
                        local v15, v16 = GetSurvivorStatus(v12.Character)

                        if v15 then
                            v13 = v15
                            v14 = v16
                        end
                    end

                    if killer then
                        local v15, v16, v17 = ipairs({"PE_Text", "KE_Text"})
                        local v18 = v9
                        local v19 = v10

                        for k, v20 in v15, v16, v17 do
                            if v20 ~= str then
                                local v21 = v12.Character:FindFirstChild(v20)

                                if v21 then
                                    v21:Destroy()
                                end
                            end
                        end

                        for i, v20 in ipairs({"PEH", "KEH"}) do
                            if v20 ~= name then
                                local v21 = v12.Character:FindFirstChild(v20)

                                if v21 then
                                    v21:Destroy()
                                end
                            end
                        end

                        v8 = v11
                        v9 = v18
                        v10 = v19

                        if flag3 then
                            for i, child in ipairs(v12.Character:GetChildren()) do
                                if string.match(child.Name, "^HookESP_") then
                                    child:Destroy()
                                end
                            end

                            v8 = v11
                            v9 = v18
                            v10 = v19
                        end

                        local humanoidRootPart3 = v12.Character:FindFirstChild("HumanoidRootPart")
                        local n2 = humanoidRootPart3 and math.floor(GetDistance(humanoidRootPart3.Position)) or nil
                        local v20 = v12.Character:FindFirstChild(name)
                        local v21 = v20

                        if not v20 then
                            local highlight2 = Instance.new("Highlight")
                            v21 = highlight2
                            highlight2.Name = name
                            highlight2.Parent = v12.Character
                        end

                        v21.FillColor = killer2
                        v21.OutlineColor = killer2
                        local outline = _G.Ox.ESPConfig.Outline
                        local fillTransparency = outline and 1 or 0.5
                        v21.FillTransparency = fillTransparency
                        v21.OutlineTransparency = 0
                        local name2 = nil
                        local v22 = nil

                        if _G.Ox.ESPConfig.Name then
                            name2 = v12.Name

                            if flag3 then
                                local attribute = v12:GetAttribute("SelectedKiller")

                                if not attribute then
                                    local selectedKiller = v12:FindFirstChild("SelectedKiller")

                                    if selectedKiller then
                                        pcall(function()
                                            attribute = selectedKiller.Value
                                        end)
                                    end
                                end

                                if attribute and tostring(attribute) ~= "" then
                                    name2 = tostring(attribute)
                                end
                            end

                            if _G.Ox.ESPConfig.ItemIcon and not flag3 then
                                local attribute = v12:GetAttribute("EquippedItem")

                                if attribute and attribute ~= "" then
                                    v22 = getItemIcon(attribute)
                                end
                            end
                        end

                        local v23 = nil

                        if not flag3 and _G.Ox.ESPConfig.HookCount then
                            local v24 = tbl6[v12.Name]
                            local attribute = v24 or v12:GetAttribute("HookCount") or 0
                            v23 = attribute
                        end

                        local v24 = buildInfoRich
                        local distance = _G.Ox.ESPConfig.Distance
                        local v25 = distance and n2 or nil
                        local v26 = v24(v13, v14, v25, v23, flag3)

                        if not name2 and v26 == "" then
                            local v27 = v12.Character:FindFirstChild(str)

                            if v27 then
                                v27:Destroy()
                            end
                        else
                            local v27 = CreateModernESP
                            local character2 = v12.Character
                            local tbl8 = {}
                            local name3 = name2 or ""
                            tbl8.name = name3
                            tbl8.infoRich = v26
                            tbl8.color = killer2
                            tbl8.icon = v22
                            tbl8.offsetY = 4
                            v27(character2, str, tbl8)
                        end
                    else
                        local v15 = v12.Character:FindFirstChild(name)

                        if v15 then
                            v15:Destroy()
                        end

                        local v16 = v12.Character:FindFirstChild(str)

                        if v16 then
                            v16:Destroy()
                        end
                    end
                end
            end
        end
    end

    UpdateSCPESP = function()
        if not _G.Ox.ESPConfig.Master then
            return
        end

        if _G.Ox.ESPConfig.SCP then
            for i, scP in ipairs(tbl4.SCPs) do
                if scP and scP.Parent then
                    local humanoid = scP:FindFirstChildOfClass("Humanoid")
                    local humanoidRootPart = scP:FindFirstChild("HumanoidRootPart")
                    local torso = humanoidRootPart or scP:FindFirstChild("Torso") or scP.PrimaryPart

                    if torso and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - torso.Position).Magnitude then
                        local scpeh = scP:FindFirstChild("SCPEH")

                        if scpeh then
                            scpeh:Destroy()
                        end
                    elseif humanoid and torso and humanoid.Health > 0 and math.floor(humanoid.WalkSpeed) == 9 then
                        local scp = _G.Ox.ESPColors.SCP
                        local scpeh = scP:FindFirstChild("SCPEH")
                        local v5 = scpeh

                        if not scpeh then
                            local highlight2 = Instance.new("Highlight")
                            v5 = highlight2
                            highlight2.Name = "SCPEH"
                            highlight2.Parent = scP
                        end

                        v5.FillColor = scp
                        v5.OutlineColor = scp
                        local outline = _G.Ox.ESPConfig.Outline
                        local fillTransparency = outline and 1 or 0.5
                        v5.FillTransparency = fillTransparency
                        v5.OutlineTransparency = 0
                    else
                        local scpeh = scP:FindFirstChild("SCPEH")

                        if scpeh then
                            scpeh:Destroy()
                        end
                    end
                end
            end
        else
            ClearESP("SCP")
        end
    end

    UpdateStaticESP = function()
        if not _G.Ox.ESPConfig.Master then
            return
        end

        if _G.Ox.ESPConfig.Generator then
            for k, generator in pairs(tbl4.Generators) do
                local model = generator.model

                if model and model.Parent then
                    local part = generator.part
                    local basePart = part or model:FindFirstChildWhichIsA("BasePart")

                    if basePart and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - basePart.Position).Magnitude then
                        local geh = model:FindFirstChild("GEH")

                        if geh then
                            geh:Destroy()
                        end

                        local geText = model:FindFirstChild("GE_Text")

                        if geText then
                            geText:Destroy()
                        end
                    else
                        local floor = math.floor
                        local attribute = model:GetAttribute("RepairProgress")
                        local n2 = attribute or 0
                        local v5 = floor(n2)
                        local n3 = math.clamp(v5 / 100, 0, 1)
                        local v6 = _G.Ox.ESPColors.Generator:Lerp(_G.Ox.ESPColors.GeneratorDone, n3)
                        local geh = model:FindFirstChild("GEH")
                        local v7 = geh

                        if not geh then
                            local highlight2 = Instance.new("Highlight")
                            v7 = highlight2
                            highlight2.Name = "GEH"
                            highlight2.Parent = model
                        end

                        v7.FillColor = v6
                        v7.OutlineColor = v6
                        local outline = _G.Ox.ESPConfig.Outline
                        local fillTransparency = outline and 1 or 0.5
                        v7.FillTransparency = fillTransparency
                        v7.OutlineTransparency = 0

                        if _G.Ox.ESPConfig.GeneratorName then
                            local str

                            if v5 >= 100 then
                                str = "DONE"
                            else
                                str = string.format("%d%%", v5)
                            end

                            local generator2 = _G.Ox.ESPColors.Generator
                            local part2 = generator.part
                            local v8 = part2 or model
                            local n4

                            if v8:IsA("BasePart") then
                                n4 = v8.Size.Y / 2 + 1
                            else
                                n4 = model:GetExtentsSize().Y / 2 + 1
                            end

                            CreateModernESP(v8, "GE_Text", {
                                name = "GEN",
                                infoRich = string.format("<font color=\"%s\">%s</font>", "#FF8000", str),
                                color = generator2,
                                icon = nil,
                                offsetY = n4,
                                noSeparator = true,
                                noDistScale = true,
                            })
                        else
                            local geText = model:FindFirstChild("GE_Text")

                            if geText then
                                geText:Destroy()
                            end
                        end
                    end
                end
            end
        end

        if _G.Ox.ESPConfig.Pallet then
            for k, pallet in pairs(tbl4.Pallets) do
                if pallet and pallet.Parent then
                    local basePart = pallet:FindFirstChildWhichIsA("BasePart")

                    if basePart and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - basePart.Position).Magnitude then
                        local palletEH = pallet:FindFirstChild("PalletEH")

                        if palletEH then
                            palletEH:Destroy()
                        end
                    else
                        local palletEH = pallet:FindFirstChild("PalletEH")
                        local v5 = palletEH

                        if not palletEH then
                            local highlight2 = Instance.new("Highlight")
                            v5 = highlight2
                            highlight2.Name = "PalletEH"
                            highlight2.Parent = pallet
                        end

                        v5.Adornee = pallet
                        v5.FillColor = _G.Ox.ESPColors.Pallet
                        v5.OutlineColor = _G.Ox.ESPColors.Pallet
                        local outline = _G.Ox.ESPConfig.Outline
                        local fillTransparency = outline and 1 or 0.5
                        v5.FillTransparency = fillTransparency
                        v5.OutlineTransparency = 0
                    end
                end
            end
        end

        if _G.Ox.ESPConfig.Window then
            for i, window in ipairs(tbl4.Windows) do
                if window and window.Parent then
                    local bottom = window:FindFirstChild("Bottom")
                    local basePart = bottom or window:FindFirstChildWhichIsA("BasePart")

                    if basePart and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - basePart.Position).Magnitude then
                        local windowEH = window:FindFirstChild("WindowEH")

                        if windowEH then
                            windowEH:Destroy()
                        end
                    elseif basePart then
                        local windowEH = window:FindFirstChild("WindowEH")
                        local v5 = windowEH

                        if not windowEH then
                            local boxHandleAdornment = Instance.new("BoxHandleAdornment")
                            v5 = boxHandleAdornment
                            boxHandleAdornment.Name = "WindowEH"
                            boxHandleAdornment.Parent = window
                            boxHandleAdornment.AlwaysOnTop = true
                            boxHandleAdornment.ZIndex = 5
                        end

                        v5.Adornee = basePart
                        v5.Size = basePart.Size
                        v5.Color3 = _G.Ox.ESPColors.Window
                        local outline = _G.Ox.ESPConfig.Outline
                        local transparency = outline and 0.8 or 0.4
                        v5.Transparency = transparency
                    end
                end
            end
        end

        if _G.Ox.ESPConfig.Hook then
            for i, hook in ipairs(tbl4.Hooks) do
                if hook and hook.Parent then
                    local hookPoint = hook:FindFirstChild("HookPoint")
                    local basePart = hookPoint or hook:FindFirstChildWhichIsA("BasePart")

                    if basePart and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - basePart.Position).Magnitude then
                        local hookEH = hook:FindFirstChild("HookEH")

                        if hookEH then
                            hookEH:Destroy()
                        end
                    else
                        local hookEH = hook:FindFirstChild("HookEH")
                        local v5 = hookEH

                        if not hookEH then
                            local highlight2 = Instance.new("Highlight")
                            v5 = highlight2
                            highlight2.Name = "HookEH"
                            highlight2.Parent = hook
                        end

                        v5.FillColor = _G.Ox.ESPColors.Hook
                        v5.OutlineColor = _G.Ox.ESPColors.Hook
                        local outline = _G.Ox.ESPConfig.Outline
                        local fillTransparency = outline and 1 or 0.5
                        v5.FillTransparency = fillTransparency
                        v5.OutlineTransparency = 0
                    end
                end
            end
        end

        if _G.Ox.ESPConfig.Gate then
            for i, gate in ipairs(tbl4.Gates) do
                if gate and gate.Parent then
                    local basePart = gate:FindFirstChildWhichIsA("BasePart")

                    if basePart and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - basePart.Position).Magnitude then
                        local gateEH = gate:FindFirstChild("GateEH")

                        if gateEH then
                            gateEH:Destroy()
                        end
                    else
                        local gateEH = gate:FindFirstChild("GateEH")
                        local v5 = gateEH

                        if not gateEH then
                            local highlight2 = Instance.new("Highlight")
                            v5 = highlight2
                            highlight2.Name = "GateEH"
                            highlight2.Parent = gate
                        end

                        v5.Adornee = gate
                        v5.FillColor = _G.Ox.ESPColors.Gate
                        v5.OutlineColor = _G.Ox.ESPColors.Gate
                        local outline = _G.Ox.ESPConfig.Outline
                        local fillTransparency = outline and 1 or 0.5
                        v5.FillTransparency = fillTransparency
                        v5.OutlineTransparency = 0
                    end
                end
            end
        end
    end

    task.spawn(function()
        local currentCamera2, v5, v6, v7, v8, v9, v10, v11, v12, humanoidRootPart, magnitude, scale, n2, v13, v14, v15, v16, v17, v18, v19
        local v20, v21, box, distScale, v22, v23, v24, v25, v26, v27, model, basePart, magnitude2, scale2, n3, geText, box2, distScale2, n4
        n4 = 1

        while true do
            if n4 == 1 then
                if _G.Ox.ScriptAlive then
                    n4 = 2
                else
                    n4 = 26
                end
            elseif n4 == 2 then
                task.wait(0.1)
                currentCamera2 = workspace.CurrentCamera

                if currentCamera2 then
                    n4 = 3
                else
                    n4 = 1
                end
            elseif n4 == 3 then
                v5, v6, v7 = ipairs(Players:GetPlayers())
                v8 = v7
                v9 = v5
                v10 = v6
                n4 = 4
            elseif n4 == 4 then
                v11, v12 = v9(v10, v8)

                if v11 == nil then
                    n4 = 16
                else
                    n4 = 5
                end
            elseif n4 == 5 then
                v8 = v11

                if v12 ~= localPlayer and v12.Character then
                    n4 = 6
                else
                    n4 = 4
                end
            elseif n4 == 6 then
                humanoidRootPart = v12.Character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart then
                    n4 = 7
                else
                    n4 = 4
                end
            elseif n4 == 7 then
                magnitude = (currentCamera2.CFrame.Position - humanoidRootPart.Position).Magnitude
                scale = math.clamp(40 / math.max(magnitude, 5), 0.8, 1)
                n2 = 4 + math.clamp((magnitude - 40) * 0.05, 0, 6)
                v13, v14, v15 = ipairs({"PE_Text", "KE_Text"})
                v16 = v9
                v17 = v10
                v18 = v15
                n4 = 8
            elseif n4 == 8 then
                v19, v20 = v13(v14, v18)

                if v19 == nil then
                    n4 = 15
                else
                    n4 = 9
                end
            elseif n4 == 9 then
                v18 = v19
                v21 = v12.Character:FindFirstChild(v20)

                if v21 and not v21:GetAttribute("NoDistScale") then
                    n4 = 10
                else
                    n4 = 8
                end
            elseif n4 == 10 then
                box = v21:FindFirstChild("Box")
                distScale = box

                if box then
                    n4 = 11
                else
                    n4 = 12
                end
            elseif n4 == 11 then
                distScale = box:FindFirstChild("DistScale")
                n4 = 12
            elseif n4 == 12 then
                if distScale then
                    n4 = 13
                else
                    n4 = 14
                end
            elseif n4 == 13 then
                distScale.Scale = scale
                n4 = 14
            elseif n4 == 14 then
                v21.StudsOffset = Vector3.new(0, n2, 0)
                n4 = 8
            elseif n4 == 15 then
                v8 = v11
                v9 = v16
                v10 = v17
                n4 = 4
            elseif n4 == 16 then
                v22, v23, v24 = pairs(tbl4.Generators)
                v25 = v24
                n4 = 17
            elseif n4 == 17 then
                v26, v27 = v22(v23, v25)

                if v26 == nil then
                    n4 = 1
                else
                    n4 = 18
                end
            elseif n4 == 18 then
                v25 = v26
                model = v27.model

                if model and model.Parent then
                    n4 = 19
                else
                    n4 = 17
                end
            elseif n4 == 19 then
                basePart = model:FindFirstChildWhichIsA("BasePart")

                if basePart then
                    n4 = 20
                else
                    n4 = 17
                end
            elseif n4 == 20 then
                magnitude2 = (currentCamera2.CFrame.Position - basePart.Position).Magnitude
                scale2 = math.clamp(40 / math.max(magnitude2, 5), 0.8, 1)
                n3 = 4 + math.clamp((magnitude2 - 40) * 0.05, 0, 6)
                geText = model:FindFirstChild("GE_Text")

                if geText and not geText:GetAttribute("NoDistScale") then
                    n4 = 21
                else
                    n4 = 17
                end
            elseif n4 == 21 then
                box2 = geText:FindFirstChild("Box")
                distScale2 = box2

                if box2 then
                    n4 = 22
                else
                    n4 = 23
                end
            elseif n4 == 22 then
                distScale2 = box2:FindFirstChild("DistScale")
                n4 = 23
            elseif n4 == 23 then
                if distScale2 then
                    n4 = 24
                else
                    n4 = 25
                end
            elseif n4 == 24 then
                distScale2.Scale = scale2
                n4 = 25
            elseif n4 == 25 then
                geText.StudsOffset = Vector3.new(0, n3, 0)
                n4 = 17
            elseif n4 == 26 then
                return
            end
        end
    end)

    SetupHookDetection = function()
        for k, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                player:GetAttributeChangedSignal("HookCount"):Connect(function()
                    local name = player.Name
                    local attribute = player:GetAttribute("HookCount")
                    local n2 = attribute or 0
                    tbl6[name] = n2

                    if _G.Ox.ESPConfig.HookCount then
                        UpdateHookESP()
                        UpdateHookUICounter()
                    end
                end)
            end
        end
    end

    Players.PlayerAdded:Connect(function(player)
        player:GetAttributeChangedSignal("HookCount"):Connect(function()
            local name = player.Name
            local attribute = player:GetAttribute("HookCount")
            local n2 = attribute or 0
            tbl6[name] = n2

            if _G.Ox.ESPConfig.HookCount then
                UpdateHookESP()
                UpdateHookUICounter()
            end
        end)
    end)

    task.spawn(function()
        task.wait(2)
        SetupHookDetection()
    end)

    local flag3 = false

    task.spawn(function()
        while _G.Ox.ScriptAlive do
            task.wait(1)

            if _G.Ox.ESPConfig.HookCount then
                flag3 = true
                UpdateHookData()
                UpdatePlayerESP()
                UpdateHookUICounter()
            elseif flag3 then
                ClearHookESP()
                ClearHookUICounter()
                UpdatePlayerESP()
                flag3 = false
            end
        end
    end)

    local function fn44(enabled)
        _G.Ox.InfinityZoom.Enabled = enabled

        if enabled then
            localPlayer.CameraMaxZoomDistance = math.huge
            localPlayer.CameraMinZoomDistance = 0

            lib:Notify({
                Title = "Infinity Zoom",
                Description = "AKTIF - Zoom out tanpa batas",
                Duration = 2,
            })
        else
            localPlayer.CameraMaxZoomDistance = 12
            localPlayer.CameraMinZoomDistance = 0.5

            lib:Notify({
                Title = "Infinity Zoom",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    local function fn45(enabled)
        _G.Ox.CameraFOV.Enabled = enabled

        if not enabled then
            currentCamera.FieldOfView = 70
        end

        local notify = lib.Notify
        local tbl8 = {Title = "Camera FOV"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end

    local function fn46(value)
        _G.Ox.CameraFOV.Value = value

        if _G.Ox.CameraFOV.Enabled then
            currentCamera.FieldOfView = value
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)

        if _G.Ox.CameraFOV.Enabled then
            currentCamera.FieldOfView = _G.Ox.CameraFOV.Value
        end
    end)

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(0.5)

            if _G.Ox.CameraFOV.Enabled then
                currentCamera.FieldOfView = _G.Ox.CameraFOV.Value
            end
        end
    end)

    pcall(function()
        _G.Ox.InstantTPGate.GateClientModule = require(game:GetService("ReplicatedStorage").Modules.Items.GateClient)
    end)

    local function fn47(arg)
        for k, v5 in getgc(true) do
            if typeof(v5) == "table" and rawget(v5, "gateDuration") and rawget(v5, "gateRemote") then
                rawset(v5, "gateDuration", arg)
            end
        end
    end

    local function fn48()
        if not _G.Ox.InstantTPGate.GateClientModule then
            return
        end

        if not _G.Ox.InstantTPGate.oldGateNew then
            _G.Ox.InstantTPGate.oldGateNew = _G.Ox.InstantTPGate.GateClientModule.new

            _G.Ox.InstantTPGate.GateClientModule.new = function(...)
                local v5 = _G.Ox.InstantTPGate.oldGateNew(...)

                if _G.Ox.InstantTPGate.Enabled then
                    v5.gateDuration = 0
                end

                return v5
            end
        end

        if not _G.Ox.InstantTPGate.oldGateCanUse then
            _G.Ox.InstantTPGate.oldGateCanUse = _G.Ox.InstantTPGate.GateClientModule.CanUse

            _G.Ox.InstantTPGate.GateClientModule.CanUse = function(arg)
                if not _G.Ox.InstantTPGate.Enabled then
                    return _G.Ox.InstantTPGate.oldGateCanUse(arg)
                end

                if arg.isSilenced or arg.isBuffering then
                    return false
                end
                local n2 = os.clock() - arg.lastUse
                local flag4 = arg.currentCooldown <= n2
                return flag4
            end
        end
    end

    local function fn49()
        if not _G.Ox.InstantTPGate.GateClientModule then
            return
        end

        if _G.Ox.InstantTPGate.oldGateNew then
            _G.Ox.InstantTPGate.GateClientModule.new = _G.Ox.InstantTPGate.oldGateNew
            _G.Ox.InstantTPGate.oldGateNew = nil
        end

        if _G.Ox.InstantTPGate.oldGateCanUse then
            _G.Ox.InstantTPGate.GateClientModule.CanUse = _G.Ox.InstantTPGate.oldGateCanUse
            _G.Ox.InstantTPGate.oldGateCanUse = nil
        end
    end

    local function fn50(enabled)
        _G.Ox.InstantTPGate.Enabled = enabled

        if enabled then
            fn47(0)
            fn48()

            lib:Notify({
                Title = "Instant TP Gate",
                Description = "AKTIF",
                Duration = 2,
            })
        else
            fn47(1.5)
            fn49()

            lib:Notify({
                Title = "Instant TP Gate",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)

        if _G.Ox.InstantTPGate.Enabled then
            fn47(0)
            fn48()
        end
    end)

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(0.5)

            if _G.Ox.InstantTPGate.Enabled then
                fn47(0)
                fn48()
            end
        end
    end)

    ResetAllTransparency = function()
        local v5, v6, v7 = pairs(currentCamera:GetChildren())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            v8 = v11

            if v12 ~= localPlayer.Character then
                for k, descendant in pairs(v12:GetDescendants()) do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        pcall(function()
                            descendant.LocalTransparencyModifier = 0
                            descendant.Transparency = 0
                        end)
                    end
                end

                v8 = v11
            end
        end
    end

    SetWorldTransparency = function(localTransparencyModifier)
        local v5, v6, v7 = pairs(currentCamera:GetChildren())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            v8 = v11

            if v12 ~= localPlayer.Character then
                for k, descendant in pairs(v12:GetDescendants()) do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        pcall(function()
                            descendant.LocalTransparencyModifier = localTransparencyModifier
                            descendant.Transparency = localTransparencyModifier
                        end)
                    end
                end

                v8 = v11
            end
        end
    end

    SetCharacterTransparency = function(arg, localTransparencyModifier)
        if not arg then
            return
        end
        local v5, v6, v7 = pairs(arg:GetChildren())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            v8 = v11

            if v12.Name == "Hat" then
                for k, descendant in pairs(v12:GetDescendants()) do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        pcall(function()
                            descendant.LocalTransparencyModifier = localTransparencyModifier
                            descendant.Transparency = localTransparencyModifier
                        end)
                    end
                end

                v8 = v11
            end

            if v12:IsA("BasePart") and tbl3[v12.Name] then
                pcall(function()
                    v12.LocalTransparencyModifier = localTransparencyModifier
                    v12.Transparency = localTransparencyModifier
                end)
            end

            if v12:IsA("Tool") or v12:IsA("Model") then
                local isBasePart = v12:IsA("BasePart")
                local descendants = isBasePart

                if isBasePart then
                    local tbl8 = {}
                    descendants = tbl8
                    tbl8[1] = v12
                end

                if not descendants then
                    descendants = v12:GetDescendants()
                end

                for k, descendant in pairs(descendants) do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        pcall(function()
                            descendant.LocalTransparencyModifier = localTransparencyModifier
                            descendant.Transparency = localTransparencyModifier
                        end)
                    end
                end
            end
        end
    end

    ResetCharacterTransparency = function(arg)
        if not localPlayer.Character then
            return
        end

        if arg then
            local v5, v6, v7 = pairs(localPlayer.Character:GetChildren())
            local v8 = v7
            local v9 = v5
            local v10 = v6

            while true do
                local v11, v12 = v9(v10, v8)
                if v11 == nil then
                    break
                end
                v8 = v11

                if v12.Name == "Hat" then
                    for k, descendant in pairs(v12:GetDescendants()) do
                        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                            pcall(function()
                                descendant.LocalTransparencyModifier = 1
                                descendant.Transparency = 1
                            end)
                        end
                    end

                    v8 = v11
                end

                if v12:IsA("BasePart") and tbl3[v12.Name] then
                    pcall(function()
                        v12.LocalTransparencyModifier = 1
                        v12.Transparency = 1
                    end)
                end

                if v12:IsA("Tool") or v12:IsA("Model") then
                    local isBasePart = v12:IsA("BasePart")
                    local descendants = isBasePart

                    if isBasePart then
                        local tbl8 = {}
                        descendants = tbl8
                        tbl8[1] = v12
                    end

                    if not descendants then
                        descendants = v12:GetDescendants()
                    end

                    for k, descendant in pairs(descendants) do
                        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                            pcall(function()
                                descendant.LocalTransparencyModifier = 1
                                descendant.Transparency = 1
                            end)
                        end
                    end
                end
            end
        else
            SetCharacterTransparency(localPlayer.Character, 0)
        end
    end

    local function fn51()
        pcall(function()
            localPlayer.CameraMode = Enum.CameraMode.Classic

            if _G.Ox.InfinityZoom and _G.Ox.InfinityZoom.Enabled then
                localPlayer.CameraMinZoomDistance = 0
                localPlayer.CameraMaxZoomDistance = math.huge
            else
                localPlayer.CameraMinZoomDistance = 0.5
                localPlayer.CameraMaxZoomDistance = 128
            end
        end)

        ResetAllTransparency()

        if localPlayer.Character then
            ResetCharacterTransparency(false)
        end
    end

    local function fn52(enabled)
        local team = localPlayer.Team
        local flag4 = team and localPlayer.Team.Name == "Killer"

        if enabled and not flag4 then
            lib:Notify({
                Title = "Akses Ditolak",
                Description = "Fitur ini khusus Killer!",
                Duration = 3,
            })

            tbl2.Enabled = false
            fn(ThirdPersonToggle, false)
            return
        end

        tbl2.Enabled = enabled

        if not enabled then
            if _G.Ox.State.ThirdPersonConn then
                _G.Ox.State.ThirdPersonConn:Disconnect()
                _G.Ox.State.ThirdPersonConn = nil
            end

            fn51()

            lib:Notify({
                Title = "Third Person",
                Description = "NONAKTIF",
                Duration = 2,
            })

            return
        end

        localPlayer.CameraMode = Enum.CameraMode.Classic
        localPlayer.CameraMinZoomDistance = 7
        localPlayer.CameraMaxZoomDistance = 128
        SetWorldTransparency(1)

        if _G.Ox.State.ThirdPersonConn then
            _G.Ox.State.ThirdPersonConn:Disconnect()
            _G.Ox.State.ThirdPersonConn = nil
        end

        _G.Ox.State.ThirdPersonConn = RunService.RenderStepped:Connect(function()
            if not tbl2.Enabled then
                return
            end

            if localPlayer.Team and localPlayer.Team.Name == "Killer" then
                localPlayer.CameraMode = Enum.CameraMode.Classic
                localPlayer.CameraMinZoomDistance = 7
                localPlayer.CameraMaxZoomDistance = 128

                if localPlayer.Character then
                    SetCharacterTransparency(localPlayer.Character, 0)
                end

                return
            end

            tbl2.Enabled = false

            if _G.Ox.State.ThirdPersonConn then
                _G.Ox.State.ThirdPersonConn:Disconnect()
                _G.Ox.State.ThirdPersonConn = nil
            end

            fn51()
            fn(ThirdPersonToggle, false)
        end)

        lib:Notify({
            Title = "Third Person",
            Description = "AKTIF - Khusus Killer",
            Duration = 3,
        })
    end

    localPlayer:GetPropertyChangedSignal("Team"):Connect(function()
        local team = localPlayer.Team
        local name = team and localPlayer.Team.Name

        if name ~= "Killer" then
            if tbl2.Enabled then
                fn52(false)
                fn(ThirdPersonToggle, false)
            else
                fn51()
            end
        end
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.8)

        if tbl2.Enabled and localPlayer.Team and localPlayer.Team.Name == "Killer" then
            localPlayer.CameraMode = Enum.CameraMode.Classic
            localPlayer.CameraMinZoomDistance = 7
            localPlayer.CameraMaxZoomDistance = 128
        else
            fn51()
        end
    end)

    EnableUnlimitedVault = function()
        if _G.Ox.UnlimitedVaultEnabled then
            return
        end
        _G.Ox.UnlimitedVaultEnabled = true

        if _G.Ox.UnlimitedVaultConn then
            _G.Ox.UnlimitedVaultConn:Disconnect()
            _G.Ox.UnlimitedVaultConn = nil
        end

        for i, v5 in ipairs(CollectionService:GetTagged("Blocked")) do
            CollectionService:RemoveTag(v5, "Blocked")
        end

        _G.Ox.UnlimitedVaultConn = CollectionService:GetInstanceAddedSignal("Blocked"):Connect(function(arg)
            CollectionService:RemoveTag(arg, "Blocked")
        end)

        lib:Notify({
            Title = "Unlimited Vault",
            Description = "AKTIF",
            Duration = 3,
        })
    end

    DisableUnlimitedVault = function()
        _G.Ox.UnlimitedVaultEnabled = false

        if _G.Ox.UnlimitedVaultConn then
            _G.Ox.UnlimitedVaultConn:Disconnect()
            _G.Ox.UnlimitedVaultConn = nil
        end

        lib:Notify({
            Title = "Unlimited Vault",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end

    local function fn53(arg)
        if arg then
            EnableUnlimitedVault()
        else
            DisableUnlimitedVault()
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1)

        if _G.Ox.UnlimitedVaultEnabled then
            for i, v5 in ipairs(CollectionService:GetTagged("Blocked")) do
                CollectionService:RemoveTag(v5, "Blocked")
            end
        end
    end)

    task.spawn(function()
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end

        local v5 = nil
        local n2 = 0

        while not v5 and n2 < 10 do
            n2 = n2 + 1

            local ok, result = pcall(function()
                local modules = ReplicatedStorage:WaitForChild("Modules", 5)
                if not modules then
                    return nil
                end
                local survivors = modules:WaitForChild("Survivors", 5)
                if not survivors then
                    return nil
                end
                local survivorAnimationsController = survivors:WaitForChild("SurvivorAnimationsController", 5)
                if not survivorAnimationsController then
                    return nil
                end
                return require(survivorAnimationsController)
            end)

            if ok and result then
                v5 = result
            else
                task.wait(1)
            end
        end

        if not v5 then
            return
        end
        local isFacingStraightEnough = v5._isFacingStraightEnough

        v5._isFacingStraightEnough = function(arg, arg2, arg3, arg4)
            if not _G.Ox.Config.Surv_PerfectVault then
                return isFacingStraightEnough(arg, arg2, arg3, arg4)
            end
            arg.characterspeed = 20
            return true, 0
        end

        local onVaultAnimation = v5._onVaultAnimation

        v5._onVaultAnimation = function(arg, arg2, arg3)
            if not _G.Ox.Config.Surv_PerfectVault then
                return onVaultAnimation(arg, arg2, arg3)
            end
            return onVaultAnimation(arg, arg2, true)
        end
    end)

    local function fn54(arg)
        if not arg then
            return
        end
        arg:SetAttribute("Flowstate", true)

        if _G.Ox.FlowstateNoCD.Connection then
            _G.Ox.FlowstateNoCD.Connection:Disconnect()
            _G.Ox.FlowstateNoCD.Connection = nil
        end

        _G.Ox.FlowstateNoCD.Connection = arg:GetAttributeChangedSignal("Flowstate"):Connect(function()
            if not _G.Ox.FlowstateNoCD.Enabled then
                return
            end

            if arg:GetAttribute("Flowstate") == false then
                task.wait(0.05)
                arg:SetAttribute("Flowstate", true)
            end
        end)
    end

    local function fn55(enabled)
        _G.Ox.FlowstateNoCD.Enabled = enabled

        if _G.Ox.FlowstateNoCD.Connection then
            _G.Ox.FlowstateNoCD.Connection:Disconnect()
            _G.Ox.FlowstateNoCD.Connection = nil
        end

        if _G.Ox.FlowstateNoCD.CharAddedConn then
            _G.Ox.FlowstateNoCD.CharAddedConn:Disconnect()
            _G.Ox.FlowstateNoCD.CharAddedConn = nil
        end

        if not enabled then
            local character = localPlayer.Character

            if character then
                character:SetAttribute("Flowstate", false)
            end

            lib:Notify({
                Title = "Flowstate No CD",
                Description = "NONAKTIF",
                Duration = 2,
            })

            return
        end

        fn54(localPlayer.Character)

        _G.Ox.FlowstateNoCD.CharAddedConn = localPlayer.CharacterAdded:Connect(function(character)
            if not _G.Ox.FlowstateNoCD.Enabled then
                return
            end
            task.wait(1)
            fn54(character)
        end)

        lib:Notify({
            Title = "Flowstate No CD",
            Description = "AKTIF",
            Duration = 2,
        })
    end

    fn14 = function(enabled)
        _G.Ox.NoFall.Enabled = enabled
        local notify = lib.Notify
        local tbl8 = {Title = "No Fall Damage"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end

    local function fn56()
        local tbl8 = {}
        local map = workspace:FindFirstChild("Map")
        if not map then
            return tbl8
        end

        for k, descendant in pairs(map:GetDescendants()) do
            if descendant.Name == "Gate" then
                table.insert(tbl8, descendant)
            end
        end

        return tbl8
    end

    fn15 = function(enabled)
        _G.Ox.BypassGate.Enabled = enabled
        local v5 = fn56()

        for k, v6 in pairs(v5) do
            local leftGate = v6:FindFirstChild("LeftGate")
            local rightGate = v6:FindFirstChild("RightGate")
            local leftGateEnd = v6:FindFirstChild("LeftGate-end")
            local leftGateEnd2 = leftGateEnd or v6:FindFirstChild("LeftGate-end2")
            local rightGateEnd = v6:FindFirstChild("RightGate-end")
            local rightGateEnd2 = rightGateEnd or v6:FindFirstChild("RightGate-end2")
            local box = v6:FindFirstChild("Box")

            if enabled then
                if leftGate then
                    leftGate.Transparency = 1
                    leftGate.CanCollide = false
                end

                if rightGate then
                    rightGate.Transparency = 1
                    rightGate.CanCollide = false
                end

                if leftGateEnd2 then
                    leftGateEnd2.Transparency = 0
                end

                if rightGateEnd2 then
                    rightGateEnd2.Transparency = 0
                end

                if box then
                    box.CanCollide = false
                end
            else
                if leftGate then
                    leftGate.Transparency = 0
                    leftGate.CanCollide = true
                end

                if rightGate then
                    rightGate.Transparency = 0
                    rightGate.CanCollide = true
                end

                if leftGateEnd2 then
                    leftGateEnd2.Transparency = 1
                end

                if rightGateEnd2 then
                    rightGateEnd2.Transparency = 1
                end

                if box then
                    box.CanCollide = true
                end
            end
        end

        local notify = lib.Notify
        local tbl8 = {Title = "Bypass Gate"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(1)

            if _G.Ox.BypassGate.Enabled then
                fn15(true)
            end
        end
    end)

    local connection = nil

    local function fn57()
        if connection then
            return
        end
        local character = localPlayer.Character
        if not character then
            return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return
        end
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return
        end

        connection = animator.AnimationPlayed:Connect(function(arg)
            if arg.Animation and arg.Animation.AnimationId:find("95836365038528") then
                arg:Stop(0)
            end
        end)
    end

    local function fn58()
        if connection then
            pcall(function()
                connection:Disconnect()
            end)

            connection = nil
        end
    end

    task.spawn(function()
        while _G.Ox.ScriptAlive do
            task.wait(3)
            if not _G.Ox.ScriptAlive then
                break
            end

            if _G.Ox.SelfHeal.Enabled and localPlayer.Team and localPlayer.Team.Name ~= "Killer" then
                local character = localPlayer.Character

                if character then
                    local checkInterractable = character:FindFirstChild("CheckInterractable")
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    local flag4 = false

                    if checkInterractable and (checkInterractable:GetAttribute("isVaulting") or checkInterractable:GetAttribute("isRepairing") or checkInterractable:GetAttribute("isUnhooking") or checkInterractable:GetAttribute("isHealing") or checkInterractable:GetAttribute("isSliding")) then
                        flag4 = true
                    end

                    if not flag4 and humanoidRootPart and humanoid and humanoid.Health < humanoid.MaxHealth then
                        pcall(function()
                            local remotes = ReplicatedStorage:FindFirstChild("Remotes")

                            if remotes and remotes:FindFirstChild("Healing") then
                                remotes.Healing.HealEvent:FireServer(humanoidRootPart, true)
                            end
                        end)
                    end
                end
            end
        end
    end)

    localPlayer.CharacterRemoving:Connect(function()
        fn58()
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(5)

        if _G.Ox.SelfHeal.Enabled then
            fn57()
        end
    end)

    fn16 = function(enabled)
        _G.Ox.SelfHeal.Enabled = enabled

        if enabled then
            if localPlayer.Team and localPlayer.Team.Name == "Killer" then
                lib:Notify({
                    Title = "Self Heal",
                    Description = "Kamu harus Survivor!",
                    Duration = 3,
                })

                _G.Ox.SelfHeal.Enabled = false

                if SelfHealToggle then
                    fn(SelfHealToggle, false)
                end

                return
            end

            fn57()

            lib:Notify({
                Title = "Self Heal",
                Description = "AKTIF (Tanpa Animasi)",
                Duration = 2,
            })
        else
            fn58()

            lib:Notify({
                Title = "Self Heal",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    do
        local AuraPlayers = game:GetService("Players")
        local AuraLP = AuraPlayers.LocalPlayer

        local function auraHealRemote()
            local r = ReplicatedStorage:FindFirstChild("Remotes")
            local h = r and r:FindFirstChild("Healing")
            return h and h:FindFirstChild("HealEvent")
        end

        local function auraFireHeal(part)
            local remote = auraHealRemote()
            if remote and part then
                pcall(function() remote:FireServer(part, true) end)
            end
        end

        local function auraHealTick()
            local cfg = _G.Ox.AuraHeal
            local char = AuraLP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            if cfg.HealSelf then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
                    auraFireHeal(hrp)
                end
            end

            if cfg.HealOthers then
                local radius = tonumber(cfg.Radius) or 30
                for _, p in ipairs(AuraPlayers:GetPlayers()) do
                    if p ~= AuraLP and p.Character then
                        local phrp = p.Character:FindFirstChild("HumanoidRootPart")
                        local phum = p.Character:FindFirstChildOfClass("Humanoid")
                        if phrp and phum and phum.Health > 0 and phum.Health < phum.MaxHealth
                            and (phrp.Position - hrp.Position).Magnitude <= radius then
                            auraFireHeal(phrp)
                        end
                    end
                end
            end
        end

        task.spawn(function()
            while _G.Ox.ScriptAlive do
                task.wait(math.max(0.1, tonumber(_G.Ox.AuraHeal.Interval) or 0.5))
                if _G.Ox.AuraHeal.Enabled then
                    pcall(auraHealTick)
                end
            end
        end)

        _G.Ox.AuraHealSet = function(enabled)
            _G.Ox.AuraHeal.Enabled = enabled and true or false
        end
    end

    fn17 = function()
        local function fn59()
            repeat
                task.wait()
            until localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character:FindFirstChild("Right Leg")

            task.wait(0.1)
            local character = localPlayer.Character

            pcall(function()
                character.Head.Transparency = 1
                local face = character.Head:FindFirstChild("face")

                if face then
                    face:Destroy()
                end

                character["Right Leg"].Transparency = 1
                local meshPart = Instance.new("MeshPart")
                meshPart.Name = "KorlessHead"
                meshPart.Size = Vector3.new(0.85, 0.85, 0.85)
                meshPart.CanCollide = false
                meshPart.MeshId = "rbxassetid://902942096"
                meshPart.TextureID = "rbxassetid://902843398"
                meshPart.CFrame = character["Right Leg"].CFrame * CFrame.new(0, 0.7, 0)
                meshPart.Parent = character
                local weldConstraint = Instance.new("WeldConstraint")
                weldConstraint.Part0 = character["Right Leg"]
                weldConstraint.Part1 = meshPart
                weldConstraint.Parent = meshPart
            end)
        end

        fn59()

        if _G.Ox.KorlessMorph.Connection then
            _G.Ox.KorlessMorph.Connection:Disconnect()
        end

        _G.Ox.KorlessMorph.Connection = localPlayer.CharacterAdded:Connect(function()
            task.wait(1)
            fn59()
        end)
    end

    fn18 = function()
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return
        end
        local v5 = nil

        for i, descendant in ipairs(workspace:GetDescendants()) do
            if string.lower(descendant.Name) == "fininshline" and descendant:IsA("BasePart") then
                v5 = descendant
                break
            end
        end

        if not v5 then
            lib:Notify({
                Title = "Instan Escape",
                Description = "Finish line tidak ditemukan!",
                Duration = 2,
            })

            return
        end

        humanoidRootPart.CFrame = v5.CFrame + Vector3.new(0, 5, 0)

        lib:Notify({
            Title = "Instan Escape",
            Description = "Berhasil!",
            Duration = 2,
        })
    end

    SetupNextKillerIndicator = function()
        if _G.Ox.NextKiller.IndicatorGui then
            _G.Ox.NextKiller.IndicatorGui:Destroy()
        end

        _G.Ox.NextKiller.IndicatorGui = Instance.new("ScreenGui")
        _G.Ox.NextKiller.IndicatorGui.Name = "NextKillerIndicator"
        _G.Ox.NextKiller.IndicatorGui.ResetOnSpawn = false
        _G.Ox.NextKiller.IndicatorGui.Parent = localPlayer:WaitForChild("PlayerGui")
    end

    StartNextKiller = function()
        if _G.Ox.NextKiller.IndicatorGui then
            return
        end
        SetupNextKillerIndicator()

        task.spawn(function()
            while _G.Ox.NextKiller.Enabled and _G.Ox.NextKiller.IndicatorGui do
                local nextKillerDisplay = _G.Ox.NextKiller.IndicatorGui:FindFirstChild("NextKillerDisplay")
                local v5 = nextKillerDisplay

                if not nextKillerDisplay then
                    local textLabel = Instance.new("TextLabel")
                    v5 = textLabel
                    textLabel.Name = "NextKillerDisplay"
                    textLabel.Size = UDim2.new(0, 150, 0, 22)
                    textLabel.Position = UDim2.new(0.5, 0, 0, 10)
                    textLabel.AnchorPoint = Vector2.new(0.5, 0)
                    textLabel.BackgroundTransparency = 0.15
                    textLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
                    textLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
                    textLabel.Font = Enum.Font.GothamMedium
                    textLabel.TextSize = 11
                    textLabel.RichText = true
                    textLabel.Parent = _G.Ox.NextKiller.IndicatorGui
                    local uiCorner = Instance.new("UICorner")
                    uiCorner.CornerRadius = UDim.new(0, 6)
                    uiCorner.Parent = textLabel
                    local uiStroke3 = Instance.new("UIStroke")
                    uiStroke3.Thickness = 1
                    uiStroke3.Color = Color3.fromRGB(60, 60, 70)
                    uiStroke3.Transparency = 0.3
                    uiStroke3.Parent = textLabel
                end

                local players = Players:GetPlayers()

                table.sort(players, function(arg, arg2)
                    local attribute = arg:GetAttribute("AllowKiller")
                    local flag4 = attribute or false
                    local attribute2 = arg2:GetAttribute("AllowKiller")
                    local flag5 = attribute2 or false
                    if flag4 ~= flag5 then
                        return flag4
                    end
                    local attribute3 = arg:GetAttribute("KillerChance")
                    local n2 = attribute3 or 0
                    local attribute4 = arg2:GetAttribute("KillerChance")
                    local n3 = attribute4 or 0
                    local flag6 = n3 < n2
                    return flag6
                end)

                local v6 = players[1]

                if v6 then
                    local name = v6 == localPlayer and "<font color='#ff5555'>KAMU</font>" or v6.Name
                    v5.Text = "Next Killer: " .. name
                else
                    v5.Text = "Next Killer: <font color='#888888'>Waiting...</font>"
                end

                task.wait(1.5)
            end
        end)
    end

    StopNextKiller = function()
        if _G.Ox.NextKiller.IndicatorGui then
            _G.Ox.NextKiller.IndicatorGui:Destroy()
            _G.Ox.NextKiller.IndicatorGui = nil
        end
    end

    fn19 = function(enabled)
        _G.Ox.NextKiller.Enabled = enabled

        if enabled then
            StartNextKiller()

            lib:Notify({
                Title = "Next Killer Display",
                Description = "AKTIF - Menampilkan prediksi killer selanjutnya",
                Duration = 3,
            })
        else
            StopNextKiller()

            lib:Notify({
                Title = "Next Killer Display",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    local function fn59()
        local mapPredictUI = CoreGui:FindFirstChild("MapPredictUI")

        if mapPredictUI then
            mapPredictUI:Destroy()
        end
    end

    local function createScreenGui()
        local mapPredictUI = CoreGui:FindFirstChild("MapPredictUI")
        if mapPredictUI then
            return mapPredictUI
        end
        local screenGui2 = Instance.new("ScreenGui")
        screenGui2.Name = "MapPredictUI"
        screenGui2.ResetOnSpawn = false
        screenGui2.IgnoreGuiInset = true
        screenGui2.Parent = CoreGui
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "NextMapDisplay"
        textLabel.Size = UDim2.new(0, 220, 0, 22)
        textLabel.Position = UDim2.new(0.5, 0, 0, 36)
        textLabel.AnchorPoint = Vector2.new(0.5, 0)
        textLabel.BackgroundTransparency = 0.15
        textLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
        textLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
        textLabel.Font = Enum.Font.GothamMedium
        textLabel.TextSize = 11
        textLabel.RichText = true
        textLabel.Text = "Next Map: <font color='#888888'>Waiting...</font>"
        textLabel.Parent = screenGui2
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 6)
        uiCorner.Parent = textLabel
        local uiStroke3 = Instance.new("UIStroke")
        uiStroke3.Thickness = 1
        uiStroke3.Color = Color3.fromRGB(60, 60, 70)
        uiStroke3.Transparency = 0.3
        uiStroke3.Parent = textLabel
        return screenGui2
    end

    local function fn60()
        local map = workspace:FindFirstChild("Map")
        if not map then
            return nil
        end

        if map:FindFirstChild("random shakes") or map:FindFirstChild("SCP-173 Room") or map:FindFirstChild("SCP-205 Room") then
            return "Site 68"
        end

        if map:FindFirstChild("HooksMeat") then
            return "BLOODBATH! Club"
        end

        if map:FindFirstChild("Gate") and map.Gate:FindFirstChild("vfx") then
            return "Firelink Shrine"
        end

        if map:FindFirstChild("Bldg_Addon_RooftopUnit_A") or map:FindFirstChild("Rooftop") then
            return "Mercy Hospital Rooftop"
        end

        if map:FindFirstChild("White Armored Car") then
            return "Mount Massive Asylum"
        end

        if map:FindFirstChild("Dumbster") then
            return "The Bay Harbor"
        end

        if map:FindFirstChild("water pump") then
            return "Valdelobos Village"
        end

        if not map:FindFirstChild("LargeBoulder01") then
            return nil
        end
        return "Woodview Cabin"
    end

    fn20 = function(enabled)
        _G.Ox.MapPredict.Enabled = enabled

        if enabled then
            task.spawn(function()
                local v5 = nil
                local flag4 = false

                while _G.Ox.MapPredict.Enabled do
                    local v6 = createScreenGui()
                    local nextMapDisplay = v6:FindFirstChild("NextMapDisplay")
                    local enabled2 = false

                    pcall(function()
                        local team = localPlayer.Team
                        local flag5 = team and localPlayer.Team.Name == "Spectator"
                        enabled2 = flag5
                    end)

                    v6.Enabled = enabled2

                    if enabled2 and nextMapDisplay then
                        local flag5 = workspace:FindFirstChild("Map") ~= nil
                        local nextMap = fn60()

                        if flag4 and not flag5 then
                            local nextMap2 = v5 or "Unknown"
                            nextMapDisplay.Text = "Next Map: " .. nextMap2
                        elseif flag5 and nextMap then
                            v5 = nextMap
                            nextMapDisplay.Text = "Next Map: " .. nextMap
                        elseif flag5 and not nextMap then
                            nextMapDisplay.Text = "Next Map: Unknown"
                        else
                            nextMapDisplay.Text = "Next Map: <font color='#888888'>Waiting...</font>"
                        end

                        flag4 = flag5
                    end

                    task.wait(0.5)
                end

                fn59()
            end)

            lib:Notify({
                Title = "Next Map Prediction",
                Description = "AKTIF - Menampilkan prediksi map selanjutnya",
                Duration = 3,
            })
        else
            fn59()

            lib:Notify({
                Title = "Next Map Prediction",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    local function fn61(arg)
        local v5 = tostring
        local str = arg or ""
        return v5(str):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    end

    local function fn62(arg)
        local v5 = tostring
        local str = arg or ""
        local match, v6 = v5(str):match("^(.+)%s+(%d+)$")
        if not match then
            return nil
        end
        local str2 = match:gsub("^%s+", ""):gsub("%s+$", "")
        if str2 == "" then
            return nil
        end

        if not ({
            head = true,
            torso = true,
            humanoid = true,
            humanoidrootpart = true,
            ["left arm"] = true,
            ["right arm"] = true,
            ["left leg"] = true,
            ["right leg"] = true,
        })[str2:lower()] then
            return str2, v6
        end

        return nil
    end

    local function fn63()
        for i, player in ipairs(Players:GetPlayers()) do
            local team = player.Team
            local name = team and player.Team.Name
            if name and name:lower():find("killer") then
                return player
            end
        end

        return nil
    end

    local function fn64(arg)
        if not arg then
            return {}
        end
        local character = arg.Character
        local v5 = character or workspace:FindFirstChild(arg.Name) or workspace:FindFirstChild(arg.DisplayName)
        if not v5 then
            return {}
        end
        local tbl8 = {}
        local tbl9 = {}

        for i, child in ipairs(v5:GetChildren()) do
            local v6, v7 = fn62(child.Name)

            if v6 and not tbl9[v6] then
                tbl9[v6] = true
                table.insert(tbl8, {Name = v6, Level = v7})
            end
        end

        table.sort(tbl8, function(arg2, arg3)
            local flag4 = tostring(arg2.Name) < tostring(arg3.Name)
            return flag4
        end)

        return tbl8
    end

    local function fn65()
        local v5 = fn63()
        local name = v5

        if v5 then
            local displayName = v5.DisplayName
            name = displayName or v5.Name
        end

        if not name then
            name = "Unknown"
        end

        local v6 = fn64(v5)
        local v7 = v6

        if #v6 == 0 then
            for i, player in ipairs(Players:GetPlayers()) do
                local v8 = fn64(player)

                if #v8 > 0 then
                    local displayName = player.DisplayName
                    local name2 = displayName or player.Name
                    name = name2
                    v7 = v8
                    break
                end
            end
        end

        local tbl8 = {
            "Killer Perks [<font color=\"rgb(255,80,80)\">" .. fn61(name) .. "</font>]",
        }

        if #v7 == 0 then
            table.insert(tbl8, "<font color=\"rgb(200,200,200)\">- Waiting for perk data...</font>")
        else
            for i = 1, math.min(#v7, 4) do
                local v8 = v7[i]
                local level = v8.Level
                local str = level and " lvl " .. tostring(v8.Level) or ""
                table.insert(tbl8, "<font color=\"rgb(200,200,200)\">- " .. fn61(v8.Name .. str) .. "</font>")
            end
        end

        return table.concat(tbl8, "\n"), #v7
    end

    local function fn66()
        if _G.Ox.KillerPerks.Gui then
            pcall(function()
                _G.Ox.KillerPerks.Gui:Destroy()
            end)

            _G.Ox.KillerPerks.Gui = nil
        end

        if not _G.Ox.KillerPerks.Enabled then
            return
        end
        local screenGui2 = Instance.new("ScreenGui")
        screenGui2.Name = "NEX_KillerPerksGui"
        screenGui2.ResetOnSpawn = false
        screenGui2.IgnoreGuiInset = true
        screenGui2.Parent = CoreGui
        local frame2 = Instance.new("Frame")
        frame2.Name = "Holder"
        frame2.Size = UDim2.new(0, 180, 0, 85)
        frame2.Position = UDim2.new(0.08, 0, 0.22, 0)
        frame2.BackgroundTransparency = 1
        frame2.Active = true
        frame2.Parent = screenGui2
        local frame3 = Instance.new("Frame")
        frame3.Name = "Panel"
        frame3.Size = UDim2.new(1, 0, 1, 0)
        frame3.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
        frame3.BackgroundTransparency = 0.15
        frame3.BorderSizePixel = 0
        frame3.Parent = frame2
        Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 6)
        local uiStroke3 = Instance.new("UIStroke")
        uiStroke3.Color = Color3.fromRGB(60, 60, 70)
        uiStroke3.Thickness = 1
        uiStroke3.Transparency = 0.3
        uiStroke3.Parent = frame3
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(1, 0, 0, 24)
        frame4.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        frame4.BorderSizePixel = 0
        frame4.Parent = frame3
        Instance.new("UICorner", frame4).CornerRadius = UDim.new(0, 6)
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -60, 1, 0)
        textLabel.Position = UDim2.new(0, 8, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.GothamSemibold
        textLabel.Text = "Killer Perks Info"
        textLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
        textLabel.TextSize = 11
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = frame4

        local function createTextButton(text, arg, arg2)
            local textButton = Instance.new("TextButton")
            textButton.Size = UDim2.new(0, 26, 0, 16)
            textButton.Position = UDim2.new(1, arg, 0, 4)
            local color = arg2 or Color3.fromRGB(25, 25, 30)
            textButton.BackgroundColor3 = color
            textButton.BorderSizePixel = 0
            textButton.Font = Enum.Font.GothamMedium
            textButton.Text = text
            textButton.TextColor3 = Color3.fromRGB(200, 200, 210)
            textButton.TextSize = 9
            textButton.Parent = frame4
            Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 4)
            return textButton
        end

        local Minimize = createTextButton("Minimize", -54, Color3.fromRGB(30, 30, 40))
        local Close = createTextButton("Close", -28, Color3.fromRGB(40, 25, 25))
        local textLabel2 = Instance.new("TextLabel")
        textLabel2.Name = "KillerPerksText"
        textLabel2.Size = UDim2.new(1, -14, 1, -32)
        textLabel2.Position = UDim2.new(0, 8, 0, 28)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Font = Enum.Font.GothamMedium
        textLabel2.RichText = true
        textLabel2.TextXAlignment = Enum.TextXAlignment.Left
        textLabel2.TextYAlignment = Enum.TextYAlignment.Top
        textLabel2.TextColor3 = Color3.fromRGB(220, 220, 230)
        textLabel2.TextSize = 11
        textLabel2.TextWrapped = false
        textLabel2.Parent = frame3

        Minimize.MouseButton1Click:Connect(function()
            local killerPerks = _G.Ox.KillerPerks
            local minimized

            if _G.Ox.KillerPerks.Minimized then
                minimized = false
            else
                minimized = true
            end

            killerPerks.Minimized = minimized
            local visible

            if _G.Ox.KillerPerks.Minimized then
                visible = false
            else
                visible = true
            end

            textLabel2.Visible = visible
            local minimized2 = _G.Ox.KillerPerks.Minimized
            local text = minimized2 and "Show" or "Minimize"
            Minimize.Text = text
            local minimized3 = _G.Ox.KillerPerks.Minimized
            local udim2 = minimized3 and UDim2.new(0, 180, 0, 24) or UDim2.new(0, 180, 0, 85)
            frame2.Size = udim2
        end)

        Close.MouseButton1Click:Connect(function()
            _G.Ox.KillerPerks.Enabled = false

            if _G.Ox.KillerPerks.Gui then
                pcall(function()
                    _G.Ox.KillerPerks.Gui:Destroy()
                end)

                _G.Ox.KillerPerks.Gui = nil
            end

            if KillerPerksToggle then
                fn(KillerPerksToggle, false)
            end
        end)

        local flag4 = false
        local position = nil
        local position2 = nil

        frame2.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag4 = true
                position = input.Position
                position2 = frame2.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        flag4 = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if not flag4 or not position or not position2 then
                return
            end

            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            local n2 = input.Position - position
            frame2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n2.X, position2.Y.Scale, position2.Y.Offset + n2.Y)
        end)

        screenGui2.Parent = CoreGui
        _G.Ox.KillerPerks.Gui = screenGui2

        task.spawn(function()
            while _G.Ox.KillerPerks.Enabled and _G.Ox.KillerPerks.Gui do
                if not _G.Ox.KillerPerks.Minimized then
                    local v5, v6 = fn65()
                    textLabel2.Text = v5
                    local n2 = math.max(2, math.min(v6 + 1, 5))
                    frame2.Size = UDim2.new(0, 180, 0, math.max(65, 28 + n2 * 15))
                end

                task.wait(1)
            end
        end)
    end

    fn21 = function(enabled)
        _G.Ox.KillerPerks.Enabled = enabled

        if enabled then
            fn66()

            lib:Notify({
                Title = "Killer Perks Display",
                Description = "AKTIF - Menampilkan perk killer yang digunakan",
                Duration = 3,
            })
        else
            if _G.Ox.KillerPerks.Gui then
                pcall(function()
                    _G.Ox.KillerPerks.Gui:Destroy()
                end)

                _G.Ox.KillerPerks.Gui = nil
            end

            lib:Notify({
                Title = "Killer Perks Display",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    PlayHitSound = function()
        if not _G.Ox.Stun.HitSoundEnabled then
            return
        end
        local now = tick()
        if now - _G.Ox.Stun.HitSoundLastTime < _G.Ox.Stun.HitSoundCooldown then
            return
        end
        _G.Ox.Stun.HitSoundLastTime = now

        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = _G.Ox.Stun.HitSoundId
            sound.Volume = _G.Ox.Stun.HitSoundVolume
            sound.PlayOnRemove = true
            local currentCamera2 = workspace.CurrentCamera
            local v5 = currentCamera2 or workspace
            sound.Parent = v5
            sound:Play()

            task.delay(sound.TimeLength + 0.1, function()
                if sound and sound.Parent then
                    sound:Destroy()
                end
            end)
        end)
    end

    local function fn67(arg)
        local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end
        local stunRingUI = humanoidRootPart:FindFirstChild("StunRingUI")

        if stunRingUI then
            stunRingUI:Destroy()
        end

        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "StunRingUI"
        billboardGui.Adornee = humanoidRootPart
        billboardGui.AlwaysOnTop = true
        billboardGui.Size = UDim2.new(0, 48, 0, 48)
        billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 4.5, 0)
        billboardGui.ResetOnSpawn = false
        billboardGui.LightInfluence = 0
        billboardGui.Parent = humanoidRootPart
        local imageLabel = Instance.new("ImageLabel", billboardGui)
        imageLabel.Name = "Ring"
        imageLabel.Size = UDim2.new(1, 0, 1, 0)
        imageLabel.Position = UDim2.new(0, 0, 0, 0)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = "rbxassetid://129594563448607"
        imageLabel.ScaleType = Enum.ScaleType.Fit

        local textLabel = Instance.new("TextLabel", billboardGui)
        textLabel.Name = "StunText"
        textLabel.BackgroundTransparency = 1
        textLabel.Size = UDim2.new(1, 0, 0, 18)
        textLabel.Position = UDim2.new(0, 0, 1, 0)
        textLabel.Font = Enum.Font.GothamBlack
        textLabel.Text = "STUN"
        textLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
        textLabel.TextScaled = true
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        local textStroke = Instance.new("UIStroke", textLabel)
        textStroke.Thickness = 2
        textStroke.Color = Color3.fromRGB(0, 0, 0)

        billboardGui.Enabled = false

        return billboardGui, task.spawn(function()
            local n2 = 0
            local currentCamera2 = workspace.CurrentCamera

            while billboardGui and billboardGui.Parent do
                if billboardGui.Enabled then
                    local rotation = (n2 + 6) % 360
                    n2 = rotation
                    imageLabel.Rotation = rotation
                    local n3 = math.clamp(math.floor(600 / (currentCamera2.CFrame.Position - humanoidRootPart.Position).Magnitude), 22, 44)
                    billboardGui.Size = UDim2.new(0, n3, 0, n3)
                end

                task.wait(0.1)
            end
        end)
    end

    local function fn68(arg)
        if not arg or _G.Ox.Stun.Data[arg] then
            return
        end
        local v5, v6 = fn67(arg)
        if not v5 then
            return
        end

        local tbl8 = {
            stunRing = v5,
            stunSpinThread = v6,
            _stunTimer = nil,
            extraConns = {},
        }

        _G.Ox.Stun.Data[arg] = tbl8

        local function fn69(arg2)
            if not tbl8.stunRing then
                return
            end
            tbl8.stunRing.Enabled = true

            if tbl8._stunTimer then
                task.cancel(tbl8._stunTimer)
            end

            tbl8._stunTimer = task.delay(arg2, function()
                if tbl8.stunRing then
                    tbl8.stunRing.Enabled = false
                end
            end)
        end

        local connection2 = arg:GetAttributeChangedSignal("IsStunned"):Connect(function()
            if arg:GetAttribute("IsStunned") == true then
                fn69(2.2)
            end
        end)

        local connection3 = arg:GetAttributeChangedSignal("Immobile"):Connect(function()
            if arg:GetAttribute("Immobile") == true then
                fn69(2.2)
            end
        end)

        table.insert(tbl8.extraConns, connection2)
        table.insert(tbl8.extraConns, connection3)
    end

    local function fn69(arg)
        local v5 = _G.Ox.Stun.Data[arg]

        if v5 then
            if v5._stunTimer then
                task.cancel(v5._stunTimer)
            end

            if v5.stunSpinThread then
                task.cancel(v5.stunSpinThread)
            end

            if v5.stunRing then
                v5.stunRing:Destroy()
            end

            if v5.extraConns then
                for i, extraConn in ipairs(v5.extraConns) do
                    pcall(function()
                        extraConn:Disconnect()
                    end)
                end
            end

            _G.Ox.Stun.Data[arg] = nil
        end
    end

    local function fn70()
        if not _G.Ox.Stun.Enabled then
            return
        end

        for i, player in ipairs(Players:GetPlayers()) do
            if IsKiller(player) and player.Character then
                fn68(player.Character)
            end
        end
    end

    Players.PlayerAdded:Connect(function(player)
        if not _G.Ox.Stun.Enabled then
            return
        end

        player.CharacterAdded:Connect(function(character)
            task.wait(0.5)

            if _G.Ox.Stun.Enabled and IsKiller(player) then
                fn68(character)
            end
        end)

        task.wait(0.5)

        if _G.Ox.Stun.Enabled and IsKiller(player) and player.Character then
            fn68(player.Character)
        end
    end)

    Players.PlayerAdded:Connect(function(player)
        player:GetPropertyChangedSignal("Team"):Connect(function()
            if not _G.Ox.Stun.Enabled then
                return
            end
            task.wait(0.5)

            if IsKiller(player) and player.Character then
                fn69(player.Character)
                task.wait(0.1)
                fn68(player.Character)
            end
        end)
    end)

    Players.PlayerAdded:Connect(function(player)
        task.wait(0.5)

        if _G.Ox.Stun.Enabled then
            fn70()
        end
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1.5)

        if _G.Ox.Stun.Enabled then
            fn70()
        end
    end)

    task.spawn(function()
        local v5, v6, v7, v8, v9, v10, humanoidRootPart, n2
        n2 = 1

        while true do
            if n2 == 1 then
                if _G.Ox.ScriptAlive then
                    n2 = 2
                else
                    n2 = 9
                end
            elseif n2 == 2 then
                task.wait(5)

                if _G.Ox.ScriptAlive then
                    n2 = 3
                else
                    n2 = 9
                end
            elseif n2 == 3 then
                if _G.Ox.Stun.Enabled then
                    n2 = 4
                else
                    n2 = 1
                end
            elseif n2 == 4 then
                v5, v6, v7 = ipairs(Players:GetPlayers())
                v8 = v7
                n2 = 5
            elseif n2 == 5 then
                v9, v10 = v5(v6, v8)

                if v9 == nil then
                    n2 = 1
                else
                    n2 = 6
                end
            elseif n2 == 6 then
                v8 = v9

                if IsKiller(v10) and v10.Character then
                    n2 = 7
                else
                    n2 = 5
                end
            elseif n2 == 7 then
                humanoidRootPart = v10.Character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart and not humanoidRootPart:FindFirstChild("StunRingUI") then
                    n2 = 8
                else
                    n2 = 5
                end
            elseif n2 == 8 then
                fn68(v10.Character)
                n2 = 5
            elseif n2 == 9 then
                return
            end
        end
    end)

    fn22 = function(enabled)
        _G.Ox.Stun.Enabled = enabled

        if enabled then
            for k in pairs(_G.Ox.Stun.Data) do
                fn69(k)
            end

            _G.Ox.Stun.Data = {}
            task.wait(0.5)
            fn70()

            lib:Notify({
                Title = "Stun Indicator",
                Description = "AKTIF - Menampilkan stun pada killer",
                Duration = 3,
            })
        else
            for k in pairs(_G.Ox.Stun.Data) do
                fn69(k)
            end

            _G.Ox.Stun.Data = {}

            lib:Notify({
                Title = "Stun Indicator",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    local function AntiHook_FindRemote()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local game_ = remotes:FindFirstChild("Game")
            local direct = game_ and game_:FindFirstChild("UpdateCharacterLook")
            if direct then return direct end
        end

        local found
        local function scan(root)
            if found or not root then return end
            pcall(function()
                for _, d in ipairs(root:GetDescendants()) do
                    if found then break end
                    if d:IsA("RemoteEvent") then
                        local n = d.Name
                        if n == "UpdateCharacterLook" or n == "UpdateCharacter"
                            or n == "CharacterLook" or n == "UpdateLook" then
                            found = d
                            break
                        end
                    end
                end
            end)
        end
        scan(remotes)
        if not found then scan(ReplicatedStorage) end
        return found
    end

    AntiHook_GetRemote = function()
        local cached = _G.Ox.AntiHook.Remote
        if cached and cached.Parent then
            return cached
        end
        local r = AntiHook_FindRemote()
        _G.Ox.AntiHook.Remote = r
        return r
    end

    local ANTI_HOOK_HELD_ATTRS = {
        "IsCarried", "IsHooked", "Carried", "BeingCarried", "IsBeingCarried",
        "Grabbed", "IsGrabbed", "PickedUp", "InGrab", "InCarry", "Hooked",
    }
    local function AntiHook_AnyHeldAttr(inst)
        if not inst then return false end
        for _, name in ipairs(ANTI_HOOK_HELD_ATTRS) do
            if inst:GetAttribute(name) == true then return true end
        end
        return false
    end
    local antiHookHeldCache = { t = 0, v = false }

    AntiHook_IsHeld = function(force)
        local now = os.clock()
        if not force and (now - antiHookHeldCache.t) < 0.1 then
            return antiHookHeldCache.v
        end
        antiHookHeldCache.t = now

        local result = false
        local killerChars = {}
        local character = localPlayer.Character

        if character then
            if AntiHook_AnyHeldAttr(character) then result = true end

            if not result then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if AntiHook_AnyHeldAttr(hrp) then result = true end
            end

            if not result then
                local hum = character:FindFirstChildOfClass("Humanoid")
                if AntiHook_AnyHeldAttr(hum) then result = true end
            end

            if not result then
                local ci = character:FindFirstChild("CheckInterractable")
                if ci and (ci:GetAttribute("isCarrying") == true or ci:GetAttribute("IsCarrying") == true or ci:GetAttribute("isCarried") == true) then
                    result = true
                end
            end

            if not result and AntiHook_AnyHeldAttr(localPlayer) then result = true end

            if not result then
                local myRoot = character:FindFirstChild("HumanoidRootPart")
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= localPlayer and plr.Character then
                        local okK, isK = pcall(IsKiller, plr)
                        if okK and isK then
                            killerChars[plr.Character] = true
                            local kci = plr.Character:FindFirstChild("CheckInterractable")
                            if kci and (kci:GetAttribute("isCarrying") == true or kci:GetAttribute("IsCarrying") == true) then
                                local kr = plr.Character:FindFirstChild("HumanoidRootPart")
                                if myRoot and kr and (kr.Position - myRoot.Position).Magnitude < 8 then
                                    result = true
                                    break
                                end
                            end
                        end
                    end
                end
            end

            if not result then
                for _, d in ipairs(character:GetDescendants()) do
                    if d:IsA("JointInstance") or d:IsA("WeldConstraint") then
                        local p0, p1 = d.Part0, d.Part1
                        if p0 and not p0:IsDescendantOf(character) then
                            local m = p0:FindFirstAncestorOfClass("Model")
                            if m and killerChars[m] then
                                result = true
                                break
                            end
                        end
                        if p1 and not p1:IsDescendantOf(character) then
                            local m = p1:FindFirstAncestorOfClass("Model")
                            if m and killerChars[m] then
                                result = true
                                break
                            end
                        end
                    end
                end
            end
        end

        antiHookHeldCache.v = result
        return result
    end

    AntiHook_SendRemoteUpdate = function()
        if not localPlayer.Character then
            return
        end
        local v5 = AntiHook_GetRemote()
        if not v5 then
            _G.Ox.AntiHook.Remote = nil
            return
        end
        local cframe = CFrame.new(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        local cframe2 = CFrame.new(0, _G.Ox.AntiHook.OffsetY, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)

        pcall(function()
            v5:FireServer(cframe, cframe2, cframe2, cframe2, cframe2)
            local antiHook = _G.Ox.AntiHook
            antiHook.SendCounter = antiHook.SendCounter + 1
        end)
    end

    AntiHook_Update = function(arg)
        if not _G.Ox.AntiHook.Enabled then
            return
        end
        local character = localPlayer.Character
        if not character then
            _G.Ox.AntiHook.Accumulator = 0
            _G.Ox.AntiHook.WasHeld = false
            return
        end

        if not AntiHook_IsHeld() then
            _G.Ox.AntiHook.Accumulator = 0
            _G.Ox.AntiHook.WasHeld = false
            return
        end

        if not _G.Ox.AntiHook.WasHeld then
            _G.Ox.AntiHook.WasHeld = true
            AntiHook_SendRemoteUpdate()
        end

        local accumulator = _G.Ox.AntiHook.Accumulator + arg
        local interval = _G.Ox.AntiHook.Interval

        if interval <= accumulator then
            -- FIX ANTI HOOK: dulu bisa kirim sampai 3x dalam satu frame
            -- (burst). Server kebanjiran update posisi lalu narik balik
            -- karakter. Sekarang maksimal 1 kirim per interval.
            _G.Ox.AntiHook.Accumulator = accumulator - interval
            AntiHook_SendRemoteUpdate()
            return
        end

        _G.Ox.AntiHook.Accumulator = accumulator
    end

    StartAntiHook = function()
        if _G.Ox.AntiHook.Connection then
            return
        end
        _G.Ox.AntiHook.Accumulator = 0
        _G.Ox.AntiHook.WasHeld = false
        _G.Ox.AntiHook.Connection = RunService.Heartbeat:Connect(AntiHook_Update)
    end

    StopAntiHook = function()
        if _G.Ox.AntiHook.Connection then
            _G.Ox.AntiHook.Connection:Disconnect()
            _G.Ox.AntiHook.Connection = nil
        end

        _G.Ox.AntiHook.Accumulator = 0
        _G.Ox.AntiHook.WasHeld = false
    end

    task.spawn(function()
        while true do
            task.wait(1)
            local now = os.clock()
            local n2 = now - _G.Ox.AntiHook.LastCounterTime
            local sendCounter = _G.Ox.AntiHook.SendCounter

            if _G.Ox.AntiHook.Enabled and n2 > 0 and sendCounter > 0 then
                print(string.format("[AntiHook] Actual rate: %.2f Hz (%d sends in %.2fs)", sendCounter / n2, sendCounter, n2))
            end

            _G.Ox.AntiHook.SendCounter = 0
            _G.Ox.AntiHook.LastCounterTime = now
        end
    end)

    ToggleAntiHook = function(enabled)
        _G.Ox.AntiHook.Enabled = enabled

        if enabled then
            StartAntiHook()
            lib:Notify({Title = "Anti Hook", Description = "AKTIF", Duration = 2})
        else
            StopAntiHook()

            lib:Notify({
                Title = "Anti Hook",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    local Dashboard = v:CreateTab("Dashboard", false, false)
    do
        local dashTab = Dashboard._tab
        local dashPage = dashTab._page

        local dashHolder = Instance.new("Frame")
        dashHolder.Name = "A2GroupedColumns"
        dashHolder.Size = UDim2.new(1, 0, 0, 0)
        dashHolder.AutomaticSize = Enum.AutomaticSize.Y
        dashHolder.BackgroundTransparency = 1
        dashHolder.LayoutOrder = -50
        dashHolder.Parent = dashPage

        local dashColumn = Instance.new("Frame")
        dashColumn.Name = "Column1"
        dashColumn.Size = UDim2.new(1, 0, 0, 0)
        dashColumn.AutomaticSize = Enum.AutomaticSize.Y
        dashColumn.BackgroundTransparency = 1
        dashColumn.Parent = dashHolder

        local dashLayout = Instance.new("UIListLayout")
        dashLayout.Padding = UDim.new(0, 12)
        dashLayout.SortOrder = Enum.SortOrder.LayoutOrder
        dashLayout.Parent = dashColumn

        dashTab._a2Columns = { dashColumn }
        dashTab._a2SectionCount = 0

        local dashView = Dashboard:CreatePage("Community")
        local dashSection = dashView:CreateSection("Community", "user")

        local dashInner = dashSection._section._inner
        local banner = Instance.new("Frame")
        banner.Name = "A2DashboardBanner"
        banner.Size = UDim2.new(1, 0, 0, 140)
        banner.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
        banner.BorderSizePixel = 0
        banner.LayoutOrder = -999
        banner.Parent = dashInner
        local bannerCorner = Instance.new("UICorner")
        bannerCorner.CornerRadius = UDim.new(0, 10)
        bannerCorner.Parent = banner
        local bannerStroke = Instance.new("UIStroke")
        bannerStroke.Color = Color3.fromRGB(255, 255, 255)
        bannerStroke.Transparency = 0.75
        bannerStroke.Parent = banner

        local bannerImage = Instance.new("ImageLabel")
        bannerImage.Name = "Banner"
        bannerImage.Size = UDim2.new(1, -8, 1, -8)
        bannerImage.Position = UDim2.new(0, 4, 0, 4)
        bannerImage.BackgroundTransparency = 1
        bannerImage.Image = "rbxassetid://117118608066997"
        bannerImage.ScaleType = Enum.ScaleType.Crop
        bannerImage.Parent = banner
        local imageCorner = Instance.new("UICorner")
        imageCorner.CornerRadius = UDim.new(0, 8)
        imageCorner.Parent = bannerImage

        dashSection._section:Label({ Text = "Join our Discord", Bold = true, Size = 14 })
        dashSection._section:Button({
            Title = "Join Discord",
            Desc = "discord.gg/ncn9htuX2",
            Icon = "discord",
            Glow = true,
            Shine = true,
            Callback = function()
                local url = "https://discord.gg/ncn9htuX2"
                if setclipboard then pcall(setclipboard, url) end
                if OpenBrowserWindow then pcall(OpenBrowserWindow, url) end
                lib:Notify({ Title = "Discord", Description = "discord.gg/ncn9htuX2", Duration = 3 })
            end,
        })
    end

    local Main = v:CreateTab("Main", false, false)
    MainTab = Main
    local Main2 = MainTab:CreatePage("Main")
    M_Page = Main2
    local Movement = M_Page:CreateSection("Movement", "move")
    MovementCard = Movement

    v5 = MovementCard:AddToggle("Auto Vault", false, function(autoVaultEnabled)
        _G.Ox.autoVaultEnabled = autoVaultEnabled
        local notify = lib.Notify
        local tbl8 = {Title = "Auto Vault"}
        local description = autoVaultEnabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "AutoVault"})

    AutoVaultToggle = v5
    AutoVaultToggle:AddKeyPicker("None")

    v6 = MovementCard:AddToggle("Auto Pallet Slide", false, function(autoPalletSlideEnabled)
        _G.Ox.autoPalletSlideEnabled = autoPalletSlideEnabled
        local notify = lib.Notify
        local tbl8 = {Title = "Auto Pallet Slide"}
        local description = autoPalletSlideEnabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "AutoPalletSlide"})

    AutoSlideToggle = v6
    AutoSlideToggle:AddKeyPicker("None")

    v7 = MovementCard:AddToggle("Auto Run PC", false, function(pc)
        _G.Ox.AutoRun.PC = pc

        if pc then
            task.spawn(function()
                while _G.Ox.AutoRun.PC do
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, localPlayer:GetMouse())
                    task.wait(0.1)
                end
            end)
        else
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, localPlayer:GetMouse())
        end
    end, {Flag = "AutoRunPc"})

    AutoRunPCToggle = v7

    v8 = MovementCard:AddToggle("Auto Run Mobile", false, function(mobile)
        _G.Ox.AutoRun.Mobile = mobile

        if mobile then
            fn5()
        else
            fn6()
        end
    end, {Flag = "AutoRunMobile"})

    AutoRunMobileToggle = v8

    v9 = MovementCard:AddToggle("Enable Speed Boost", false, function(enabled)
        _G.Ox.Speed.Enabled = enabled
        local notify = lib.Notify
        local tbl8 = {Title = "Speed Boost"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "SpeedBoost"})

    SpeedToggle = v9

    SpeedToggle:AddKeyPicker("SpeedBoostKey", {
        Default = "None",
        Text = "Toggle Speed Boost",
        Mode = "Toggle",
        Callback = function(enabled)
            _G.Ox.Speed.Enabled = enabled

            if SpeedToggle then
                fn(SpeedToggle, enabled)
            end
        end,
    })

    MovementCard:AddSlider("SpeedAmount", 0.1, 3, 0.1, function(value)
        _G.Ox.Speed.Value = value
    end, {Increment = 0.1, Flag = "SpeedAmount"})

    _G.Ox.SkipEndscreen = false
    v10 = M_Page:CreateSection("Server Utility", "server-cog")
    ServerUtilityCard = v10

    v11 = ServerUtilityCard:AddToggle("Skip Endscreen", false, function(skipEndscreen)
        _G.Ox.SkipEndscreen = skipEndscreen
        local notify = lib.Notify
        local tbl8 = {Title = "Skip Endscreen"}
        local description = skipEndscreen and "AKTIF - Endscreen otomatis dilewati" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "SkipEndscreen"})

    SkipEndscreenToggle = v11

    SkipEndscreenToggle:AddKeyPicker("SkipEndKey", {
        Default = "None",
        Text = "Toggle Skip Endscreen",
        Mode = "Toggle",
        Callback = function(skipEndscreen)
            _G.Ox.SkipEndscreen = skipEndscreen

            if SkipEndscreenToggle then
                SkipEndscreenToggle:SetValue(skipEndscreen)
            end
        end,
    })

    task.spawn(function()
        while _G.Ox.ScriptAlive do
            if _G.Ox.SkipEndscreen then
                pcall(function()
                    local map = workspace:FindFirstChild("Map")

                    if map then
                        local endscreen = map:FindFirstChild("endscreen", true)

                        if endscreen then
                            for i, descendant in ipairs(endscreen:GetDescendants()) do
                                if descendant:IsA("LocalScript") then
                                    descendant.Disabled = true
                                end
                            end

                            endscreen:Destroy()
                        end
                    end

                    local results = playerGui:FindFirstChild("Results")

                    if results then
                        local frame2 = results:FindFirstChild("Frame")

                        if frame2 then
                            local close = frame2:FindFirstChild("Close")

                            if close and frame2.Visible and close.Visible then
                                pcall(function()
                                    firesignal(close.MouseButton1Click)
                                end)
                            end
                        end
                    end
                end)
            end

            task.wait(1)
        end
    end)

    v12 = M_Page:CreateSection("Fake Perks", "sparkles")
    FakePerksCard = v12

    v13 = FakePerksCard:AddToggle("Quick Recovery", false, function(arg)
        ToggleQuickRecovery(arg)
    end, {Flag = "FakeQR"})

    QR_Toggle = v13
    QR_Toggle:AddKeyPicker("None")

    v14 = FakePerksCard:AddToggle("Perfect Landing", false, function(arg)
        TogglePerfectLanding(arg)
    end, {Flag = "FakePL"})

    PL_Toggle = v14
    PL_Toggle:AddKeyPicker("None")

    local Flowstate = FakePerksCard:AddToggle("Flowstate", false, function(arg)
        ToggleFlowstate(arg)
    end, {Flag = "FakeFS"})

    FS_Toggle = Flowstate
    FS_Toggle:AddKeyPicker("None")

    v15 = FakePerksCard:AddToggle("Adrenaline Rush", false, function(arg)
        SetupFakeAdrenalineRush(arg)
    end, {Flag = "FakeAR"})

    AR_Toggle = v15
    AR_Toggle:AddKeyPicker("None")

    FakePerksCard:AddSlider("Perk Cooldown", 0, 180, 10, function(perkCooldown)
        _G.Ox.FakePerks.PerkCooldown = perkCooldown
    end, {Increment = 1, Flag = "FakePerkColdown"})

    v16 = M_Page:CreateSection("Camera Settings", "camera")
    CameraCard = v16

    v17 = CameraCard:AddToggle("Enable Stretch Res", false, function(arg)
        fn43(arg)
    end, {Flag = "SretchRes"})

    StretchToggle = v17
    StretchToggle:AddKeyPicker("None")

    CameraCard:AddSlider("Stretch Amount", 0.4, 1, 0.67, function(amount)
        _G.Ox.StretchRes.Amount = amount
    end, {Increment = 0.01, Flag = "StretchAmount"})

    v18 = CameraCard:AddToggle("Third Person (Killer)", false, function(arg)
        fn52(arg)
    end, {Flag = "ThirdPerson"})

    ThirdPersonToggle = v18

    v19 = CameraCard:AddToggle("Infinity Zoom Out", false, function(arg)
        fn44(arg)
    end, {Flag = "InfinityZoom"})

    InfinityToggle = v19

    v20 = CameraCard:AddToggle("Camera FOV", false, function(arg)
        fn45(arg)
    end, {Flag = "CameraFov"})

    FOVToggle = v20

    CameraCard:AddSlider("FOV Value", 60, 120, 90, function(arg)
        fn46(arg)
    end, {Increment = 0, Flag = "FOVValue"})

    v21 = M_Page:CreateSection("Camera DBD", "camera")
    DbdCard = v21

    _G.Ox.DBD = {
        Enabled = false,
        Distance = 13,
        Height = 4.2,
        RunSmooth = 0.1,
        LookSmooth = 0.28,
        Sens = 0.55,
        PitchMin = -0.55,
        PitchMax = 0.45,
        FOV = 70,
        yaw = 0,
        pitch = 0.12,
        lookInput = nil,
        lastPos = nil,
        conn = nil,
        chg = nil,
        beg = nil,
        endc = nil,
        oldFOV = nil,
    }

    DBD_isLookTouch = function(arg)
        local flag4 = currentCamera.ViewportSize.X * 0.22 < arg.X
        return flag4
    end

    DBD_initYaw = function()
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return
        end
        local n2 = humanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)

        if n2.Magnitude > 0.05 then
            _G.Ox.DBD.yaw = math.atan2(-n2.X, -n2.Z)
        end
    end

    DBD_Stop = function()
        local dbd = _G.Ox.DBD

        if dbd.conn then
            dbd.conn:Disconnect()
            dbd.conn = nil
        end

        if dbd.chg then
            dbd.chg:Disconnect()
            dbd.chg = nil
        end

        if dbd.beg then
            dbd.beg:Disconnect()
            dbd.beg = nil
        end

        if dbd.endc then
            dbd.endc:Disconnect()
            dbd.endc = nil
        end

        currentCamera.CameraType = Enum.CameraType.Custom

        if dbd.oldFOV then
            currentCamera.FieldOfView = dbd.oldFOV
        end

        dbd.lookInput = nil
        dbd.lastPos = nil
    end

    DBD_Start = function()
        DBD_Stop()
        local dbd = _G.Ox.DBD
        if not dbd.Enabled then
            return
        end
        DBD_initYaw()
        dbd.oldFOV = currentCamera.FieldOfView
        currentCamera.CameraType = Enum.CameraType.Scriptable
        currentCamera.FieldOfView = dbd.FOV
        local character = localPlayer.Character
        local humanoid = character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.AutoRotate = true
        end

        dbd.chg = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            if input ~= dbd.lookInput then
                return
            end
            local position = input.Position

            if dbd.lastPos then
                dbd.yaw = dbd.yaw - (position.X - dbd.lastPos.X) * 0.011 * dbd.Sens
                dbd.pitch = math.clamp(dbd.pitch - (position.Y - dbd.lastPos.Y) * 0.011 * dbd.Sens, dbd.PitchMin, dbd.PitchMax)
            end

            dbd.lastPos = position
        end)

        dbd.beg = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and DBD_isLookTouch(input.Position) then
                dbd.lookInput = input
                dbd.lastPos = input.Position
            end
        end)

        dbd.endc = UserInputService.InputEnded:Connect(function(input)
            if input == dbd.lookInput then
                dbd.lookInput = nil
                dbd.lastPos = nil
            end
        end)

        dbd.conn = RunService.RenderStepped:Connect(function(deltaTime)
            if not dbd.Enabled then
                return
            end
            local character2 = localPlayer.Character
            local humanoidRootPart = character2 and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
                return
            end
            local vector = Vector3.new(math.sin(dbd.yaw) * math.cos(dbd.pitch), math.sin(dbd.pitch), math.cos(dbd.yaw) * math.cos(dbd.pitch))
            local n2 = humanoidRootPart.Position + Vector3.new(0, 1.6, 0)
            local n3 = n2 - vector * dbd.Distance + Vector3.new(0, dbd.Height - 1.6, 0)
            local cframe = CFrame.lookAt(n3, n2)
            local lookInput = dbd.lookInput
            local lookSmooth = lookInput and dbd.LookSmooth or dbd.RunSmooth
            local n4 = 1 - math.pow(1 - lookSmooth, deltaTime * 60)
            currentCamera.CFrame = currentCamera.CFrame:Lerp(cframe, n4)
        end)
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.6)

        if _G.Ox.DBD.Enabled then
            DBD_Start()
        end
    end)

    DbdCard:AddToggle("DBD Camera", false, function(enabled)
        _G.Ox.DBD.Enabled = enabled

        if enabled then
            if _G.Ox.CameraFOV then
                _G.Ox.CameraFOV.Enabled = false
            end

            DBD_Start()
        else
            DBD_Stop()
        end

        local notify = lib.Notify
        local tbl8 = {Title = "DBD Camera"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "DBDCamera"})

    DbdCard:AddSlider("DBD Distance", 6, 20, 13, function(distance)
        _G.Ox.DBD.Distance = distance
    end, {Increment = 0.1, Flag = "DBDDistance"})

    DbdCard:AddSlider("DBD Height", 1, 8, 4.2, function(height)
        _G.Ox.DBD.Height = height
    end, {Increment = 0.1, Flag = "DBDHeight"})

    DbdCard:AddSlider("DBD Run Smooth", 0.03, 0.35, 0.1, function(runSmooth)
        _G.Ox.DBD.RunSmooth = runSmooth
    end, {Increment = 0.01, Flag = "DBDRunSmooth"})

    DbdCard:AddSlider("DBD Look Smooth", 0.08, 0.6, 0.28, function(lookSmooth)
        _G.Ox.DBD.LookSmooth = lookSmooth
    end, {Increment = 0.01, Flag = "DBDLookSmooth"})

    DbdCard:AddSlider("DBD Sensitivity", 0.15, 1.2, 0.55, function(sens)
        _G.Ox.DBD.Sens = sens
    end, {Increment = 0.01, Flag = "DBDSens"})

    DbdCard:AddSlider("DBD Pitch Min", -1.2, 0, -0.55, function(pitchMin)
        _G.Ox.DBD.PitchMin = pitchMin
    end, {Increment = 0.01, Flag = "DBDPitchMin"})

    DbdCard:AddSlider("DBD Pitch Max", 0, 1.2, 0.45, function(pitchMax)
        _G.Ox.DBD.PitchMax = pitchMax
    end, {Increment = 0.01, Flag = "DBDPitchMax"})

    DbdCard:AddSlider("DBD FOV", 50, 90, 70, function(fov)
        _G.Ox.DBD.FOV = fov

        if _G.Ox.DBD.Enabled then
            currentCamera.FieldOfView = fov
        end
    end, {Increment = 1, Flag = "DBDFOV"})

    v22 = M_Page:CreateSection("Streamer Mode", "eye-off")
    StreamerCard = v22

    v23 = StreamerCard:AddToggle("Streamer Mode", false, function(arg)
        fn42(arg)
    end, {Flag = "StreamerMode"})

    StreamerToggle = v23
    StreamerToggle:AddKeyPicker("None")
    v24 = M_Page:CreateSection("Players Utility", "user-cog")
    UtilityCard = v24

    v25 = UtilityCard:AddToggle("Invisibility [OP]", false, function(invisEnabled)
        _G.Ox.Utility.InvisEnabled = invisEnabled
        fn8(invisEnabled)
        if invisEnabled then
            lib:Notify({ Title = "Invisibility [OP]", Description = "AKTIF - kamu tembus pandang", Duration = 2 })
        else
            lib:Notify({ Title = "Invisibility [OP]", Description = "NONAKTIF", Duration = 2 })
        end
    end, { Flag = "InvisOP", Glow = true, GlowColor = Color3.fromRGB(178, 92, 255) })

    InvisToggle = v25

    v26 = UtilityCard:AddToggle("Fast Bandage", false, function(bandageEnabled)
        _G.Ox.Utility.BandageEnabled = bandageEnabled
        fn9(bandageEnabled)
    end)

    BandageToggle = v26

    UtilityCard:AddSlider("BandageSpeed", 10, 200, 50, function(bandageSpeed)
        _G.Ox.Utility.BandageSpeed = bandageSpeed

        if v2 and v2.Config then
            v2.Config.PreClicksCount = bandageSpeed
        end
    end, {Increment = 1, Flag = "BandageSpeed"})

    v27 = UtilityCard:AddToggle("Moonwalk GUI", false, function(arg)
        if arg then
            if not _G.Ox.Moonwalk.Gui then
                CreateMoonwalkGUI()
            end

            _G.Ox.Moonwalk.Gui.Enabled = true
            _G.Ox.Moonwalk.GuiVisible = true
            UpdateMoonwalkGUI(_G.Ox.Moonwalk.Enabled)

            lib:Notify({
                Title = "Moonwalk GUI",
                Description = "Gui Dimuat",
                Duration = 2,
            })
        else
            if _G.Ox.Moonwalk.Enabled then
                StopMoonwalk()

                if MoonwalkPCToggle then
                    fn(MoonwalkPCToggle, false)
                end
            end

            if _G.Ox.Moonwalk.Gui then
                _G.Ox.Moonwalk.Gui.Enabled = false
                _G.Ox.Moonwalk.GuiVisible = false
            end

            lib:Notify({
                Title = "Moonwalk GUI",
                Description = "Gui Disembunyikan",
                Duration = 2,
            })
        end
    end, {Flag = "MoonwalkGui"})

    MoonwalkGUIToggle = v27

    v28 = UtilityCard:AddToggle("Moonwalk PC", false, function(arg)
        if arg then
            StartMoonwalk()
        else
            StopMoonwalk()
        end

        UpdateMoonwalkGUI(_G.Ox.Moonwalk.Enabled)
        local notify = lib.Notify
        local tbl8 = {Title = "Moonwalk PC"}
        local description = arg and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "MoonwalkPC"})

    MoonwalkPCToggle = v28

    MoonwalkPCToggle:AddKeyPicker("MoonwalkPCKey", {
        Default = "None",
        Text = "Toggle Moonwalk",
        Mode = "Toggle",
        Callback = function(arg)
            if arg then
                StartMoonwalk()
            else
                StopMoonwalk()
            end

            UpdateMoonwalkGUI(_G.Ox.Moonwalk.Enabled)

            if MoonwalkPCToggle then
                fn(MoonwalkPCToggle, arg)
            end
        end,
    })

    UtilityCard:AddSlider("Kecepatan Gedek A/D", 1, 120, 56, function(gedekSpeed)
        _G.Ox.Moonwalk.SwaySpeed = gedekSpeed
    end, {Increment = 1, Flag = "MoonwalkADSpeed"})

    UtilityCard:AddSlider("Sudut Gedek A/D (Â°)", 0, 90, 23, function(gedekAngle)
        _G.Ox.Moonwalk.SwayAngle = gedekAngle
    end, {Increment = 1, Flag = "MoonwalkADAngle"})

    UtilityCard:AddToggle("Lock Moonwalk Button", false, function(lockBtn)
        _G.Ox.Moonwalk.DragLocked = lockBtn == true
        lib:Notify({
            Title = "Moonwalk",
            Description = lockBtn and "Tombol DIKUNCI (tidak bisa digeser)" or "Tombol bisa digeser",
            Duration = 2,
        })
    end, {Flag = "MoonwalkLock"})

    UtilityCard:AddButton("Fly GUI", function()
        local flag4 = false

        for k, child in pairs(game.CoreGui:GetChildren()) do
            if child.Name:lower():find("fly") then
                flag4 = true
            end
        end

        if flag4 then
            lib:Notify({
                Title = "Fly GUI",
                Description = "Fly GUI sudah terbuka",
                Duration = 2,
            })
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()

            lib:Notify({
                Title = "Fly GUI",
                Description = "Fly GUI Dimuat",
                Duration = 3,
            })
        end
    end)

    local Crosshair = M_Page:CreateSection("Crosshair", "crosshair")
    CrosshairBox = Crosshair

    v29 = CrosshairBox:AddToggle("Enable Crosshair", false, function(enabled)
        _G.Ox.Crosshair.Enabled = enabled

        if not enabled then
            ClearCrosshair()
        end

        local notify = lib.Notify
        local tbl8 = {Title = "Crosshair"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "Crosshair"})

    CrosshairToggle = v29

    CrosshairToggle:AddKeyPicker("CrosshairKey", {
        Default = "None",
        Text = "Toggle Crosshair",
        Mode = "Toggle",
        Callback = function(enabled)
            _G.Ox.Crosshair.Enabled = enabled

            if not enabled then
                ClearCrosshair()
            end
        end,
    })

    CrosshairToggle:AddColorPicker(_G.Ox.Crosshair.Color, {
        Flag = "Crosshair_Color",
        Title = "Crosshair Color",
        Callback = function(color)
            _G.Ox.Crosshair.Color = color
        end,
    })

    CrosshairBox:AddDropdown("Style", {"Plus", "Dot", "Circle"}, false, function(style)
        _G.Ox.Crosshair.Style = style
        ClearCrosshair()
        _G.Ox.CrosshairCreated = false
    end, {Flag = "CrosshairStyle"})

    CrosshairBox:AddSlider("Size", 2, 30, 8, function(size)
        _G.Ox.Crosshair.Size = size
    end, {Increment = 1, Flag = "CrosshairSize"})

    CrosshairBox:AddSlider("Thickness", 1, 5, 2, function(thickness)
        _G.Ox.Crosshair.Thickness = thickness
    end, {Increment = 1, Flag = "CrosshairThickness"})

    CrosshairBox:AddSlider("Position X", -100, 100, 0, function(offsetX)
        _G.Ox.Crosshair.OffsetX = offsetX
    end, {Increment = 1, Flag = "CrosshairX"})

    CrosshairBox:AddSlider("Position Y", -100, 100, 0, function(offsetY)
        _G.Ox.Crosshair.OffsetY = offsetY
    end, {Increment = 1, Flag = "CrosshairY"})

    v30 = M_Page:CreateSection("Copy Avatar", "shirt")
    FakeAvatarSection = v30

    local copyAvatarSection = FakeAvatarSection

    local Pandu_RANDOM_IDS = { 978663613, 5261700291, 1846241644, 4993456331, 424866237, 4312175249 }
    local Pandu_AvatarList = {
        "Self Avatar", "Random 1", "Random 2", "Random 3", "Random 4", "Random 5", "Random 6", "Random 7",
        "WoozyNate", "Nicholas", "yvlyf", "traevp", "J0LLY", "LucashDev", "CEOofIsaac", "Stealthy",
        "Wildes", "Talon", "Relukt", "Sammy", "Diesel", "S4ans03", "Aura", "iJava", "White Guy",
        "Purple King", "Mpruyyy",
    }
    local Pandu_AvatarIDs = {
        ["Self Avatar"] = localPlayer.UserId,
        ["Random 1"] = 2888298851, ["Random 2"] = 10074747755, ["Random 3"] = 5209567453,
        ["Random 4"] = 8991982843, ["Random 5"] = 5796319029, ["Random 6"] = 9744452117,
        ["Random 7"] = 8476755006,
        WoozyNate = 146089324, Nicholas = 909635, yvlyf = 181751703, traevp = 471607078,
        J0LLY = 1073847038, LucashDev = 2525651744, CEOofIsaac = 63238912, Stealthy = 56602747,
        Wildes = 40397833, Talon = 75974130, Relukt = 65042011, Sammy = 2678001507,
        Diesel = 9123921576, S4ans03 = 35439794, Aura = 2275806428, iJava = 276557820,
        ["White Guy"] = 8843268357, ["Purple King"] = 9070758608, Mpruyyy = 8340163775,
    }

    local selectedAvatarPlayer = nil
    local copyAvatarUsername = ""
    local selectedPreset = "Self Avatar"

    local copyAvatarDropdown = copyAvatarSection:AddDropdown("Select Player", {}, false, function(v)
        if type(v) == "table" then selectedAvatarPlayer = v[1] else selectedAvatarPlayer = v end
    end)

    copyAvatarSection:AddTextbox("Username / ID", "Masukkan username atau ID...", function(v)
        copyAvatarUsername = v
    end)

    copyAvatarSection:AddDropdown("Pilih Avatar", Pandu_AvatarList, false, function(v)
        selectedPreset = v
    end)

    local function UpdatePlayerDropdown()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer then table.insert(list, p.Name) end
        end
        pcall(function() copyAvatarDropdown:SetValues(list) end)
    end
    UpdatePlayerDropdown()
    Players.PlayerAdded:Connect(UpdatePlayerDropdown)
    Players.PlayerRemoving:Connect(UpdatePlayerDropdown)

    local avatarOverlay, avatarSync, avatarAddedConn, avatarLastUserId = nil, nil, nil, nil
    local avatarHidden = {}

    local function ClearAvatarOverlay()
        if avatarSync then avatarSync:Disconnect(); avatarSync = nil end
        if avatarAddedConn then avatarAddedConn:Disconnect(); avatarAddedConn = nil end
        if avatarOverlay then avatarOverlay:Destroy(); avatarOverlay = nil end
        for part, transparency in pairs(avatarHidden) do
            if part.Parent then
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = transparency
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = transparency
                end
            end
        end
        table.clear(avatarHidden)
    end

    local CopyAvatarR6
    localPlayer.CharacterAdded:Connect(function(newChar)
        ClearAvatarOverlay()
        if not avatarLastUserId then return end
        task.spawn(function()
            local r = newChar:WaitForChild("HumanoidRootPart", 15)
            local hum = newChar:WaitForChild("Humanoid", 15)
            if not r or not hum then return end

            local t0 = tick()
            while tick() - t0 < 8 and newChar.Parent and (r.Anchored or not newChar:IsDescendantOf(workspace)) do task.wait(0.2) end
            task.wait(1.2)
            pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
            if localPlayer.Character == newChar and avatarLastUserId then
                pcall(CopyAvatarR6, avatarLastUserId)
            end
        end)
    end)

    CopyAvatarR6 = function(userId)
        ClearAvatarOverlay()
        local char = localPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not char:FindFirstChildOfClass("Humanoid") then
            return false, "Character belum siap!"
        end
        local ok, result = pcall(function()
            local desc
            local okDesc, d = pcall(function() return Players:GetHumanoidDescriptionFromUserId(userId) end)
            if okDesc and d then desc = d end
            if not desc then
                desc = Players:GetHumanoidDescriptionFromUserIdAsync(userId)
            end
            local clone
            local okClone, c = pcall(function() return Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R6) end)
            if okClone and c then clone = c else clone = Players:CreateHumanoidModelFromDescriptionAsync(desc, Enum.HumanoidRigType.R6) end
            avatarOverlay = clone
            clone.Name = "VD_Clone"
            clone.Parent = workspace
            local cloneRoot = clone:WaitForChild("HumanoidRootPart", 5)
            local cloneHumanoid = clone:FindFirstChildOfClass("Humanoid")
            if not cloneRoot or not cloneHumanoid then error("Model R6 tidak lengkap") end
            cloneHumanoid.BreakJointsOnDeath = false
            cloneHumanoid.EvaluateStateMachine = false
            cloneHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            pcall(function() workspace.CurrentCamera.CameraSubject = char:FindFirstChildOfClass("Humanoid") end)
            cloneHumanoid.PlatformStand = true
            cloneHumanoid.HipHeight = 0
            for _, part in ipairs(clone:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                    part.CanCollide = false
                    part.CanQuery = false
                    part.CanTouch = false
                    part.Massless = true
                elseif part:IsA("Motor6D") then
                    part.Enabled = true
                end
            end
            cloneRoot.CFrame = root.CFrame
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = root
            weld.Part1 = cloneRoot
            weld.Parent = cloneRoot

            local originalMotors, clonedMotors = {}, {}
            for _, motor in ipairs(char:GetDescendants()) do
                if motor:IsA("Motor6D") then originalMotors[motor.Name] = motor end
            end
            for _, motor in ipairs(clone:GetDescendants()) do
                if motor:IsA("Motor6D") then clonedMotors[motor.Name] = motor end
            end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    avatarHidden[part] = part.LocalTransparencyModifier
                    part.LocalTransparencyModifier = 1
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    avatarHidden[part] = part.Transparency
                    part.Transparency = 1
                end
            end
            if avatarAddedConn then avatarAddedConn:Disconnect() end
            avatarAddedConn = char.DescendantAdded:Connect(function(part)
                if not avatarOverlay then return end
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    avatarHidden[part] = 0
                    part.LocalTransparencyModifier = 1
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    avatarHidden[part] = part.Transparency
                    part.Transparency = 1
                end
            end)
            avatarSync = RunService.PreRender:Connect(function()
                if not avatarOverlay or not avatarOverlay.Parent or localPlayer.Character ~= char then
                    ClearAvatarOverlay()
                    return
                end
                for part in pairs(avatarHidden) do
                    if part.Parent then
                        if part:IsA("BasePart") then
                            if part.LocalTransparencyModifier ~= 1 then part.LocalTransparencyModifier = 1 end
                        elseif part.Transparency ~= 1 then
                            part.Transparency = 1
                        end
                    else
                        avatarHidden[part] = nil
                    end
                end
                if not cloneRoot.Parent then
                    ClearAvatarOverlay()
                    return
                end
                if not weld.Parent or weld.Part0 ~= root then
                    weld = Instance.new("WeldConstraint")
                    weld.Part0 = root
                    weld.Part1 = cloneRoot
                    weld.Parent = cloneRoot
                end

                if (cloneRoot.Position - root.Position).Magnitude > 6 then
                    cloneRoot.CFrame = root.CFrame
                end
                for name, motor in pairs(originalMotors) do
                    if not motor.Parent then
                        local fresh = char:FindFirstChild(name, true)
                        if fresh and fresh:IsA("Motor6D") then motor = fresh; originalMotors[name] = fresh end
                    end
                    local copied = clonedMotors[name]
                    if copied and motor.Parent and copied.Parent then
                        copied.Transform = motor.Transform
                    end
                end
            end)
        end)
        if not ok then
            ClearAvatarOverlay()
            return false, tostring(result)
        end
        return true
    end

    local function CopyAvatarResolve(input)
        local str = tostring(input or ""):gsub("^%s+", ""):gsub("%s+$", ""):gsub("^@", "")
        if str == "" then return nil, nil end
        local num = tonumber(str)
        if num then
            local ok, name = pcall(function() return Players:GetNameFromUserIdAsync(num) end)
            return num, (ok and name) or tostring(num)
        end
        local ok, id = pcall(function() return Players:GetUserIdFromNameAsync(str) end)
        if ok and id then return id, str end
        return nil, nil
    end

    local function CopyAvatarApplyInput(input)
        local userId, label = CopyAvatarResolve(input)
        if not userId then
            lib:Notify({ Title = "Copy Avatar", Description = "User '" .. tostring(input) .. "' ga ketemu!", Duration = 4 })
            return
        end
        local copied, reason = CopyAvatarR6(userId)
        if copied then
            avatarLastUserId = userId
            lib:Notify({ Title = "Copy Avatar", Description = "Avatar " .. tostring(label) .. " tampil (R6 lokal)!", Duration = 3 })
        else
            lib:Notify({ Title = "Copy Avatar", Description = "Gagal copy: " .. tostring(reason), Duration = 5 })
        end
    end

    copyAvatarSection:AddButton("Apply Avatar", function()
        local input = copyAvatarUsername
        if tostring(input or "") == "" then
            if selectedAvatarPlayer and selectedAvatarPlayer ~= "" then
                input = selectedAvatarPlayer
            elseif selectedPreset and Pandu_AvatarIDs[selectedPreset] then
                input = Pandu_AvatarIDs[selectedPreset]
            end
        end
        if tostring(input or "") == "" then
            lib:Notify({ Title = "Copy Avatar", Description = "Isi username / ID atau pilih player dulu!", Duration = 3 })
            return
        end
        CopyAvatarApplyInput(input)
    end)

    copyAvatarSection:AddButton("Random Avatar", function()
        CopyAvatarApplyInput(Pandu_RANDOM_IDS[math.random(1, #Pandu_RANDOM_IDS)])
    end)

    copyAvatarSection:AddButton("Reset Avatar", function()
        avatarLastUserId = nil
        ClearAvatarOverlay()
        lib:Notify({ Title = "Copy Avatar", Description = "Avatar dikembalikan ke semula!", Duration = 3 })
    end)

    local Pandu_FAVORITES = {}
    local Pandu_SelectedFav = nil

    local function Pandu_LoadFavorites()
        Pandu_FAVORITES = {}
        pcall(function()
            if not isfolder("PanduCopyAvatar") then makefolder("PanduCopyAvatar") end
            if isfile("PanduCopyAvatar/favorites.json") then
                Pandu_FAVORITES = HttpService:JSONDecode(readfile("PanduCopyAvatar/favorites.json"))
            end
        end)
    end

    local function Pandu_SaveFavorites()
        pcall(function()
            if not isfolder("PanduCopyAvatar") then makefolder("PanduCopyAvatar") end
            writefile("PanduCopyAvatar/favorites.json", HttpService:JSONEncode(Pandu_FAVORITES))
        end)
    end

    local function Pandu_GetFavoritesList()
        local list = {}
        for _, fav in ipairs(Pandu_FAVORITES) do table.insert(list, fav.name) end
        return list
    end

    Pandu_LoadFavorites()

    local Pandu_FavDropdown
    Pandu_FavDropdown = copyAvatarSection:AddDropdown("Favorites", Pandu_GetFavoritesList(), false, function(arg)
        for _, fav in ipairs(Pandu_FAVORITES) do
            if fav.name == arg then
                Pandu_SelectedFav = fav.id
                CopyAvatarApplyInput(fav.id)
                break
            end
        end
    end)

    copyAvatarSection:AddButton("Add to Favorite", function()
        if not avatarLastUserId then
            lib:Notify({ Title = "Copy Avatar", Description = "Copy avatar dulu sebelum simpan favorite.", Duration = 3 })
            return
        end
        for _, fav in ipairs(Pandu_FAVORITES) do
            if tonumber(fav.id) == tonumber(avatarLastUserId) then
                lib:Notify({ Title = "Copy Avatar", Description = "Sudah ada di favorite.", Duration = 2 })
                return
            end
        end
        local name = tostring(avatarLastUserId)
        pcall(function()
            local n = Players:GetNameFromUserIdAsync(avatarLastUserId)
            if n then name = n end
        end)
        table.insert(Pandu_FAVORITES, { id = avatarLastUserId, name = name })
        Pandu_SaveFavorites()
        if Pandu_FavDropdown then pcall(function() Pandu_FavDropdown:SetValues(Pandu_GetFavoritesList()) end) end
        lib:Notify({ Title = "Copy Avatar", Description = "Ditambahkan ke favorite.", Duration = 2 })
    end)

    copyAvatarSection:AddButton("Delete Favorite", function()
        if not Pandu_SelectedFav then
            lib:Notify({ Title = "Copy Avatar", Description = "Pilih favorite dulu.", Duration = 3 })
            return
        end
        for i, fav in ipairs(Pandu_FAVORITES) do
            if tonumber(fav.id) == tonumber(Pandu_SelectedFav) then
                table.remove(Pandu_FAVORITES, i)
                break
            end
        end
        Pandu_SaveFavorites()
        if Pandu_FavDropdown then pcall(function() Pandu_FavDropdown:SetValues(Pandu_GetFavoritesList()) end) end
        Pandu_SelectedFav = nil
        lib:Notify({ Title = "Copy Avatar", Description = "Favorite dihapus.", Duration = 2 })
    end)

    local Survivor = v:CreateTab("Survivor", false, false)
    SurvivorTab = Survivor
    local Survivor2 = SurvivorTab:CreatePage("Survivor")
    S_Page = Survivor2
    v31 = S_Page:CreateSection("Generator Settings", "plug-zap")
    GenCard = v31

    v32 = GenCard:AddToggle("Auto Skill Check", false, function(skillCheck)
        _G.Ox.Auto.SkillCheck = skillCheck

        if skillCheck then
            fn7()
        elseif _G.Ox.Connections.SkillHeartbeat then
            _G.Ox.Connections.SkillHeartbeat:Disconnect()
            _G.Ox.Connections.SkillHeartbeat = nil
        end
    end, {Flag = "AutoSkillCheck"})

    SkillCheckToggle = v32
    SkillCheckToggle:AddKeyPicker("None")

    GenCard:AddDropdown("Skill Check Mode", {"Instant", "Random", "Perfect"}, false, function(skillCheckMode)
        _G.Ox.Auto.SkillCheckMode = skillCheckMode
        _G.Ox.State.RandomMode_IsNormal = false
    end, {Flag = "SkillCheckMode"})

    -- FIX GEN BOOST: dropdown "Gen Boost Mode" dan toggle "Gen Boost + Skill
    -- Check" DIHAPUS. Sekarang cuma ada SATU tombol Gen Boost (toggle di
    -- bawah yang memunculkan tombol GEN melayang).

    v33 = GenCard:AddToggle("Gen Boost", false, function(bypassToggleValue)
        _G.Ox.BypassToggleValue = bypassToggleValue
        _G.Ox.BypassGenEnabled = bypassToggleValue
        -- sinkron ke modul GenBypass (metode v41)
        if _G.Ox.GenBypass then
            _G.Ox.GenBypass.Enabled = bypassToggleValue
            if not bypassToggleValue then
                _G.Ox.GenBypass.Processed = {}
            end
        end
        local bypassButton = _G.Ox.BypassButton
        -- FIX GEN BOOST: tombol GEN selalu kelihatan saat toggle ON
        -- (dulu cuma muncul di device touch, jadi di PC tidak ada tombol).
        bypassButton.Visible = bypassToggleValue and true or false

        if not bypassToggleValue then
            _G.Ox.ProcessedGens = {}
            _G.Ox.AutoRepairEnabled = false
            _G.Ox.AutoCurrentGenModel = nil

            if _G.Ox.AutoRepairThread then
                task.cancel(_G.Ox.AutoRepairThread)
                _G.Ox.AutoRepairThread = nil
            end

            _G.Ox.StopAutoRepair()
        end
    end)

    GenBoostToggle = v33
    local fire
    do
        local okRS, rs = pcall(function() return ReplicatedStorage end)
        local rem = okRS and rs and rs:FindFirstChild("Remotes")
        local items = rem and rem:FindFirstChild("Items")
        local tof = items and items:FindFirstChild("Twist of Fate")
        fire = tof and tof:FindFirstChild("Fire")
    end
    local flag4 = false
    local flag5 = false
    local flag6 = true
    local flag7 = false
    local flag8 = false
    local connection2 = nil
    local part = nil
    local str = "Killer"
    UDim2.new(0.5, -120, 0, 110)
    local tbl8 = {}

    local tbl9 = {
        PredictionEfficiency = 0.85,
        LerpSmoothness = 0.4,
        EnableJitter = false,
        MaxJitterStuds = 0,
    }

    getGunObject = function()
        local character = localPlayer.Character
        if not character then
            return nil
        end
        local twistOfFate = character:FindFirstChild("Twist of Fate", true)
        if not twistOfFate then
            return nil
        end
        local rightArm = twistOfFate:FindFirstChild("Right Arm")

        if rightArm then
            local gun = rightArm:FindFirstChild("gun")
            if gun then
                return gun
            end
            local emperorGun = rightArm:FindFirstChild("EmperorGun")
            if emperorGun then
                return emperorGun
            end
        end

        return twistOfFate
    end

    isTargetVisible = function(arg, arg2, arg3)
        local n2 = arg2 - arg
        local magnitude = n2.Magnitude
        if magnitude < 0.1 then
            return true
        end
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local filterDescendantsInstances = {}
        local character = localPlayer.Character

        if character then
            table.insert(filterDescendantsInstances, character)
        end

        if arg3 and arg3 ~= character then
            table.insert(filterDescendantsInstances, arg3)
        end

        if part then
            table.insert(filterDescendantsInstances, part)
        end

        raycastParams.FilterDescendantsInstances = filterDescendantsInstances
        local flag9 = workspace:Raycast(arg, n2.Unit * magnitude, raycastParams) == nil
        return flag9
    end

    local tbl10 = {}
    local n2 = 0

    GetSCPs = function()
        if tick() - n2 < 0.5 then
            return tbl10
        end
        local tbl11 = {}
        local map = workspace:FindFirstChild("Map")

        if map then
            for k, descendant in pairs(map:GetDescendants()) do
                if descendant:IsA("Model") then
                    local attributes = descendant:GetAttributes()

                    if descendant:GetAttribute("CorpseCreated0492") or next(attributes) ~= nil then
                        local humanoidRootPart = descendant:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart then
                            table.insert(tbl11, humanoidRootPart)
                        end
                    end
                end
            end
        end

        tbl10 = tbl11
        n2 = tick()
        return tbl10
    end

    local function fn71(arg)
        local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return Vector3.zero
        end
        local position = humanoidRootPart.Position
        local v34 = tbl8[arg]

        if v34 then
            local n3 = tick() - v34.time

            if n3 > 0.001 and n3 < 0.1 then
                local v35 = v34.vel:Lerp((position - v34.pos) / n3, tbl9.LerpSmoothness)
                local tbl11 = {pos = position, vel = v35, time = tick()}
                tbl8[arg] = tbl11
                return v35
            end
        end

        local tbl11 = {pos = position, vel = humanoidRootPart.Velocity, time = tick()}
        tbl8[arg] = tbl11
        return humanoidRootPart.Velocity
    end

    local function fn72(arg, arg2, arg3, arg4)
        local n3 = arg4 or 500
        local v34 = n3
        local position = arg2.Position
        if (position - arg).Magnitude < 8 then
            return position
        end
        local v35 = fn71(arg3)
        local n4 = position - arg
        local n5 = v35:Dot(v35) - v34 * v34
        local n6 = 2 * n4:Dot(v35)
        local v36 = n4:Dot(n4)
        local n7 = nil

        if math.abs(n5) < 0.01 then
            if math.abs(n6) > 0.01 then
                n7 = -v36 / n6
            end
        else
            local n8 = n6 * n6 - 4 * n5 * v36

            if n8 >= 0 then
                local v37 = math.sqrt(n8)
                local n9 = (-n6 - v37) / (2 * n5)
                local n10 = (-n6 + v37) / (2 * n5)

                if n9 > 0.001 then
                    n7 = n9
                elseif n10 > 0.001 then
                    n7 = n10
                end
            end
        end

        local n8 = position

        if n7 then
            local n9 = position + v35 * tbl9.PredictionEfficiency * n7
            n8 = n9

            if tbl9.EnableJitter then
                n8 = n9 + Vector3.new((math.random() - 0.5) * tbl9.MaxJitterStuds, (math.random() - 0.5) * (tbl9.MaxJitterStuds / 2), (math.random() - 0.5) * tbl9.MaxJitterStuds)
            end
        end

        return n8
    end

    getTargetPosition = function()
        local currentCamera2 = workspace.CurrentCamera
        local v34 = getGunObject()
        local character = localPlayer.Character
        if not v34 or not character then
            return nil, nil, nil, nil
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil, nil, nil, nil
        end
        local position = humanoidRootPart.Position
        local n3 = nil

        if character:GetAttribute("IsCarried") then
            n3 = character.HumanoidRootPart.Position + character.HumanoidRootPart.CFrame.LookVector * 2
        else
            pcall(function()
                local isBasePart = v34:IsA("BasePart")
                local position2 = isBasePart and v34.Position

                if not position2 then
                    local basePart = v34:FindFirstChildOfClass("BasePart")
                    position2 = basePart and v34:FindFirstChildOfClass("BasePart").Position
                end

                n3 = position2
            end)

            local vector = n3 or Vector3.new(position.X, position.Y + 1.5, position.Z)
            n3 = vector
        end

        local function fn73(arg, arg2)
            local position2 = arg.Position
            if flag7 and not isTargetVisible(n3, position2, arg2) then
                return nil, nil, nil, nil
            end
            local v35 = getGunObject()
            local position3 = n3

            pcall(function()
                if v35 and v35:IsA("BasePart") then
                    position3 = v35.Position
                elseif v35 then
                    local basePart = v35:FindFirstChildOfClass("BasePart")

                    if basePart then
                        position3 = basePart.Position
                    end
                end
            end)

            if (position2 - position3).Magnitude < 8 then
                return (position2 - position3).Unit, v35, position3, position2
            end

            if not flag5 then
                return (position2 - position3).Unit, v35, position3, position2
            end
            local v36 = fn72(position3, arg, arg2, 500)
            return (v36 - position3).Unit, v35, position3, v36
        end

        if str == "Killer" then
            local v35 = nil
            local character2 = nil
            local huge = math.huge

            for i, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    local team = player.Team
                    local flag9 = team and player.Team.Name == "Killer"

                    if flag9 and player.Character then
                        local torso = player.Character:FindFirstChild("Torso")

                        if torso then
                            local magnitude = (position - torso.Position).Magnitude

                            if magnitude < huge then
                                huge = magnitude
                                v35 = torso
                                character2 = player.Character
                            end
                        end
                    end
                end
            end

            if not v35 then
                return nil, nil, nil, nil
            end
            return fn73(v35, character2)
        end

        if str == "Survivors" then
            local v35 = nil
            local character2 = nil
            local n4 = -math.huge
            local currentCamera3 = workspace.CurrentCamera
            local lookVector = currentCamera3.CFrame.LookVector

            for i, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Team and player.Team.Name == "Survivors" and player.Character then
                    local torso = player.Character:FindFirstChild("Torso")

                    if torso then
                        local v36 = lookVector:Dot((torso.Position - currentCamera3.CFrame.Position).Unit)

                        if v36 > 0.5 and n4 < v36 then
                            n4 = v36
                            v35 = torso
                            character2 = player.Character
                        end
                    end
                end
            end

            if not v35 then
                return nil, nil, nil, nil
            end
            return fn73(v35, character2)
        end

        if str ~= "Zombie" then
            return nil, nil, nil, nil
        end
        local v35 = nil
        local v36 = GetSCPs()
        local n4 = -math.huge
        local currentCamera3 = workspace.CurrentCamera
        local lookVector = currentCamera3.CFrame.LookVector

        for i, v37 in ipairs(v36) do
            if v37 and v37.Parent then
                local v38 = lookVector:Dot((v37.Position - currentCamera3.CFrame.Position).Unit)

                if v38 > 0.5 and n4 < v38 then
                    n4 = v38
                    v35 = v37
                end
            end
        end

        if not v35 then
            return nil, nil, nil, nil
        end
        return fn73(v35, v35.Parent)
    end

    updateLaser = function(arg, arg2)
        if not part then
            part = Instance.new("Part")
            part.Name = "ToFLaser"
            part.Anchored = true
            part.CanCollide = false
            part.CanTouch = false
            part.CastShadow = false
            part.Material = Enum.Material.Neon
            local color = Color3.fromRGB(255, 50, 50)
            part.Color = color
            part.Parent = workspace
        end

        local vector = Vector3.new(0.05, 0.05, (arg2 - arg).Magnitude)
        part.Size = vector
        local cframe = CFrame.new((arg + arg2) / 2, arg2)
        part.CFrame = cframe
        part.Transparency = 0
    end

    clearLaser = function()
        if part then
            part:Destroy()
            part = nil
        end
    end

    local tbl11 = {}

    local function fn73()
        local attribute = localPlayer:GetAttribute("EquippedSkin_Twist_of_Fate")
        local str2 = attribute or ""
        if str2:find("AWP") or str2:find("Awp") or str2:find("awp") then
            return "rbxassetid://119691839016468"
        end

        if not str2:find("SCP") and not str2:find("3108") then
            return "rbxassetid://124735239320776"
        end
        return "rbxassetid://116394362601423"
    end

    local function fn74()
        for i, v34 in ipairs(tbl11) do
            v34:Disconnect()
        end

        tbl11 = {}
        local character = localPlayer.Character
        if not character then
            return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return
        end

        local function fn75()
            local attribute = character:GetAttribute("IsCarried")
            local attribute2 = attribute or character:GetAttribute("Knocked")
            return attribute2
        end

        local function fn76()
            local tbl12 = {}
            tbl12[fn73()] = true
            tbl12["rbxassetid://111824163160605"] = true
            tbl12["rbxassetid://72749744367268"] = true
            return tbl12
        end

        table.insert(tbl11, animator.AnimationPlayed:Connect(function(arg)
            if not fn75() then
                return
            end

            if not arg.Animation then
                return
            end

            if fn76()[arg.Animation.AnimationId] then
                arg:Stop(0)
            end
        end))

        table.insert(tbl11, character:GetAttributeChangedSignal("IsCarried"):Connect(function()
            if not fn75() then
                return
            end
            local v34 = fn76()

            for i, v35 in ipairs(animator:GetPlayingAnimationTracks()) do
                if v35.Animation and v34[v35.Animation.AnimationId] then
                    v35:Stop(0)
                end
            end
        end))

        table.insert(tbl11, character:GetAttributeChangedSignal("Knocked"):Connect(function()
            if not fn75() then
                return
            end
            local v34 = fn76()

            for i, v35 in ipairs(animator:GetPlayingAnimationTracks()) do
                if v35.Animation and v34[v35.Animation.AnimationId] then
                    v35:Stop(0)
                end
            end
        end))
    end

    task.defer(fn74)

    localPlayer.CharacterAdded:Connect(function()
        task.defer(function()
            task.wait(0.25)
            fn74()
        end)
    end)

    doShoot = function()
        if not flag4 or not flag8 then
            return
        end
        local character = localPlayer.Character
        if character and _G.Ox.AimConfig.Pistol_BlockKnocked and IsDowned(character) then
            return
        end
        local v34, v35, v36, v37 = getTargetPosition()
        if not v34 or not v35 or not v37 or not v36 then
            return
        end
        local unit = (v37 - v36).Unit

        pcall(function()
            fire:FireServer(v35, unit)
        end)
    end

    startConnection = function()
        if connection2 then
            return
        end

        connection2 = RunService.Heartbeat:Connect(function()
            if flag8 and flag4 then
                local v34, v35, v36, v37 = getTargetPosition()

                if v34 and v35 and v37 then
                    pcall(function()
                        local character = localPlayer.Character
                        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart and not character:GetAttribute("IsCarried") then
                            humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, Vector3.new(v37.X, humanoidRootPart.Position.Y, v37.Z))
                        end
                    end)

                    if _G.Ox.AimConfig.LockAim then
                        local cframe = CFrame.lookAt(currentCamera.CFrame.Position, v37)
                        currentCamera.CFrame = currentCamera.CFrame:Lerp(cframe, 0.15)
                    end

                    if flag6 and v36 and v37 then
                        updateLaser(v36, v37)
                    end
                elseif part then
                    part.Transparency = 1
                end
            elseif part then
                part.Transparency = 1
            end
        end)
    end

    stopConnection = function()
        if connection2 then
            connection2:Disconnect()
            connection2 = nil
        end

        clearLaser()
    end

    local udim2 = UDim2.new(0.5, -82, 0, 30)
    local v34 = nil
    local connection3 = nil

    local tbl12 = {
        {
            internal = "Killer",
            display = "Killer (K)",
            activeColor = Color3.fromRGB(180, 45, 45),
            activeTxt = Color3.fromRGB(255, 180, 180),
        },
        {
            internal = "Survivors",
            display = "Survivors (J)",
            activeColor = Color3.fromRGB(25, 80, 150),
            activeTxt = Color3.fromRGB(160, 210, 255),
        },
        {
            internal = "Zombie",
            display = "Zombie (L)",
            activeColor = Color3.fromRGB(120, 80, 10),
            activeTxt = Color3.fromRGB(255, 210, 100),
        },
    }

    createTargetSelectorUI = function()
        if not CoreGui then
            return
        end

        if v34 and v34.Parent then
            return
        end
        local toFTargetSelector = CoreGui:FindFirstChild("ToFTargetSelector")

        if toFTargetSelector then
            toFTargetSelector:Destroy()
        end

        local screenGui2 = Instance.new("ScreenGui")
        screenGui2.Name = "ToFTargetSelector"
        screenGui2.ResetOnSpawn = false
        screenGui2.IgnoreGuiInset = true
        screenGui2.Parent = CoreGui
        local frame2 = Instance.new("Frame")
        frame2.Name = "Main"
        frame2.Size = UDim2.new(0, 165, 0, 32)
        frame2.Position = udim2
        frame2.BackgroundTransparency = 1
        frame2.Active = true
        frame2.Parent = screenGui2
        local visible = false
        local textButton = Instance.new("TextButton")
        textButton.Size = UDim2.new(1, 0, 1, 0)
        textButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        textButton.BackgroundTransparency = 0.25
        textButton.BorderSizePixel = 0
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 11
        textButton.TextColor3 = Color3.fromRGB(240, 240, 240)
        textButton.Parent = frame2
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 8)
        local uiStroke3 = Instance.new("UIStroke", textButton)
        uiStroke3.Color = Color3.fromRGB(100, 100, 110)
        uiStroke3.Thickness = 1.2
        uiStroke3.Transparency = 0.3
        local frame3 = Instance.new("Frame")
        frame3.Size = UDim2.new(1, 0, 0, 0)
        frame3.Position = UDim2.new(0, 0, 1, 5)
        frame3.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        frame3.BackgroundTransparency = 0.25
        frame3.BorderSizePixel = 0
        frame3.ClipsDescendants = true
        frame3.Visible = false
        frame3.AutomaticSize = Enum.AutomaticSize.Y
        frame3.Parent = frame2
        Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 8)
        local uiStroke4 = Instance.new("UIStroke", frame3)
        uiStroke4.Color = Color3.fromRGB(80, 80, 90)
        uiStroke4.Thickness = 1.2
        uiStroke4.Transparency = 0.4
        local uiListLayout = Instance.new("UIListLayout", frame3)
        uiListLayout.FillDirection = Enum.FillDirection.Vertical
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Padding = UDim.new(0, 4)
        local uiPadding = Instance.new("UIPadding", frame3)
        uiPadding.PaddingTop = UDim.new(0, 4)
        uiPadding.PaddingBottom = UDim.new(0, 4)
        uiPadding.PaddingLeft = UDim.new(0, 4)
        uiPadding.PaddingRight = UDim.new(0, 4)
        local tbl13 = {}

        local function fn75()
            local str2 = "Unknown"

            for i, v35 in ipairs(tbl12) do
                if v35.internal == str then
                    str2 = v35.internal
                    break
                end
            end

            local v35 = visible
            local str3 = v35 and "v" or ">"
            textButton.Text = string.format("Target: %s   %s", str2, str3)
            frame3.Visible = visible

            for i, v36 in ipairs(tbl12) do
                local v37 = tbl13[v36.internal]

                if v37 then
                    if v36.internal == str then
                        v37.BackgroundColor3 = v36.activeColor
                        v37.TextColor3 = v36.activeTxt
                    else
                        v37.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
                        v37.TextColor3 = Color3.fromRGB(150, 150, 150)
                    end
                end
            end
        end

        for i, v35 in ipairs(tbl12) do
            local textButton2 = Instance.new("TextButton")
            textButton2.Size = UDim2.new(1, 0, 0, 26)
            textButton2.BorderSizePixel = 0
            textButton2.Font = Enum.Font.GothamBold
            textButton2.TextSize = 10
            textButton2.Text = v35.display
            textButton2.LayoutOrder = i
            textButton2.Parent = frame3
            Instance.new("UICorner", textButton2).CornerRadius = UDim.new(0, 6)

            local function fn76()
                str = v35.internal
                visible = false
                fn75()
            end

            textButton2.MouseButton1Click:Connect(fn76)

            textButton2.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    fn76()
                end
            end)

            tbl13[v35.internal] = textButton2
        end

        fn75()
        local flag9 = false
        local flag10 = false
        local v35 = nil
        local position = nil
        local position2 = nil

        textButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag9 = true
                flag10 = false
                v35 = input
                position = input.Position
                position2 = frame2.Position
            end
        end)

        textButton.InputEnded:Connect(function(input)
            if input == v35 then
                flag9 = false

                if not flag10 then
                    local flag11

                    if visible then
                        flag11 = false
                    else
                        flag11 = true
                    end

                    visible = flag11
                    fn75()
                end

                v35 = nil
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if not flag9 then
                return
            end
            local flag11 = false

            if input.UserInputType == Enum.UserInputType.Touch and input == v35 then
                flag11 = true
            elseif input.UserInputType == Enum.UserInputType.MouseMovement and v35.UserInputType == Enum.UserInputType.MouseButton1 then
                flag11 = true
            end

            if flag11 then
                local n3 = input.Position - position

                if math.abs(n3.X) > 4 or math.abs(n3.Y) > 4 then
                    flag10 = true
                end

                if flag10 then
                    local udim22 = UDim2.new(position2.X.Scale, position2.X.Offset + n3.X, position2.Y.Scale, position2.Y.Offset + n3.Y)
                    frame2.Position = udim22
                    udim2 = udim22
                end
            end
        end)

        if connection3 then
            connection3:Disconnect()
            connection3 = nil
        end

        connection3 = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not flag4 then
                return
            end

            if gameProcessed or input.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end
            local str2 = nil

            if input.KeyCode == Enum.KeyCode.K then
                str2 = "Killer"
                lib:Notify({Title = "Target Mode", Description = "Killer", Time = 1})
            elseif input.KeyCode == Enum.KeyCode.J then
                str2 = "Survivors"
                lib:Notify({Title = "Target Mode", Description = "Survivors", Time = 1})
            elseif input.KeyCode == Enum.KeyCode.L then
                str2 = "Zombie"
                lib:Notify({Title = "Target Mode", Description = "Zombie", Time = 1})
            end

            if str2 and str2 ~= str then
                str = str2
                fn75()
            end
        end)

        v34 = screenGui2
    end

    destroyTargetSelectorUI = function()
        if connection3 then
            connection3:Disconnect()
            connection3 = nil
        end

        if v34 then
            v34:Destroy()
            v34 = nil
        end
    end

    local v35 = S_Page:CreateSection("Silent Aim (Pistol)", "crosshair")
    PistolSection = v35

    local v36 = PistolSection:AddToggle("Silent Aim Twist Of Fate", false, function(arg)
        flag4 = arg

        if arg then
            createTargetSelectorUI()
            startConnection()
        else
            destroyTargetSelectorUI()
            stopConnection()
        end
    end)

    SilentAimToggle = v36

    local v37 = PistolSection:AddToggle("Predict Aim ToF", false, function(arg)
        flag5 = arg
        local notify = lib.Notify
        local tbl13 = {Title = "Predict Aim"}
        local description = arg and "Enabled" or "Disabled"
        tbl13.Description = description
        tbl13.Duration = 2
        notify(lib, tbl13)
    end, {Flag = "Pistol_Predict"})

    PredictToggle = v37

    local v38 = PistolSection:AddCheckbox("Block aim Knocked", false, function(pistolBlockKnocked)
        _G.Ox.AimConfig.Pistol_BlockKnocked = pistolBlockKnocked
    end, {Flag = "Pistol_BlockKnocked"})

    BlockKnockedToggle = v38

    local v39 = PistolSection:AddToggle("Block Peluru (TOF)", false, function(enabled)
        _G.Ox.BulletBlockConfig.Enabled = enabled
        local notify = lib.Notify
        local tbl13 = {Title = "Block Peluru"}
        local description = enabled and "AKTIF - Peluru tidak keluar" or "NONAKTIF"
        tbl13.Description = description
        tbl13.Duration = 3
        notify(lib, tbl13)
    end, {Flag = "Pistol_BlockPeluru"})

    BulletBlockToggle = v39

    local v40 = PistolSection:AddToggle("Lock Aim (Twist Of Fate)", false, function(lockAim)
        _G.Ox.AimConfig.LockAim = lockAim
    end, {Flag = "Pistol_LockAim"})

    LockAimToggle = v40

    local Wallcheck = PistolSection:AddToggle("Wallcheck", false, function(arg)
        flag7 = arg
    end, {Flag = "Pistol_Wallcheck"})

    WallCheckToggle = Wallcheck

    local v41 = PistolSection:AddToggle("Enable Laser Effect", true, function(arg)
        flag6 = arg

        if not arg then
            clearLaser()
        end
    end, {Flag = "Pistol_Laser"})

    LaserToggle = v41

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        local flag9 = input.UserInputType == Enum.UserInputType.Touch
        if gameProcessed and not flag9 then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            flag8 = true

            if _G.Ox.AimConfig.Flash_Silent then
                flag = true
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            doShoot()
        end
    end)

    PistolSection:AddToggle("Silent Aim Flashlight", false, function(flashSilent)
        _G.Ox.AimConfig.Flash_Silent = flashSilent
        local notify = lib.Notify
        local tbl13 = {Title = "Flash Silent Aim"}
        local description = flashSilent and "AKTIF" or "NONAKTIF"
        tbl13.Description = description
        tbl13.Duration = 2
        notify(lib, tbl13)
    end)

    PistolSection:AddSlider("FlashHeadOffset", 0, 15, 1.5, function(flashYOffset)
        _G.Ox.AimConfig.Flash_YOffset = flashYOffset
    end, {Increment = 0.1, Flag = "Flash_YOffset"})

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            flag8 = false
            flag = false

            if part then
                part.Transparency = 1
            end
        end
    end)

    local connection4 = nil

    hookMobileButtons = function(arg)
        task.wait(0.5)
        local controls = arg:WaitForChild("Controls", 10)
        if not controls then
            return
        end
        local guiMob = controls:WaitForChild("Gui-mob", 5)
        if not guiMob then
            return
        end

        guiMob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                flag8 = true

                if _G.Ox.AimConfig.Flash_Silent then
                    flag = true
                end
            end
        end)

        guiMob.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                doShoot()
                flag8 = false
                flag = false

                if part then
                    part.Transparency = 1
                end
            end
        end)
    end

    setupMobileButton = function()
        local playerGui2 = localPlayer:WaitForChild("PlayerGui", 10)
        if not playerGui2 then
            return
        end
        local survivorMob = playerGui2:FindFirstChild("Survivor-mob")

        if survivorMob then
            task.spawn(hookMobileButtons, survivorMob)
        end

        if connection4 then
            connection4:Disconnect()
            connection4 = nil
        end

        connection4 = playerGui2.ChildAdded:Connect(function(child)
            if child.Name == "Survivor-mob" then
                task.spawn(hookMobileButtons, child)
            end
        end)
    end

    setupMobileButton()

    localPlayer.CharacterAdded:Connect(function(character)
        clearLaser()
        tbl8 = {}
        tbl10 = {}
        n2 = 0
        flag8 = false
        character:WaitForChild("HumanoidRootPart", 5)
        setupMobileButton()

        if flag4 then
            stopConnection()
            task.wait(0.2)
            startConnection()
            createTargetSelectorUI()
        end
    end)

    playerGui.ChildRemoved:Connect(function(child)
        if not flag4 then
            return
        end
        task.wait(0.5)
        if not flag4 then
            return
        end

        if child.Name == "ToFTargetSelector" then
            createTargetSelectorUI()
        end
    end)

    local PistolStun = {Enabled = true, Data = {}}

    local function pistolHideStun(killerChar)
        local hrp = killerChar and killerChar:FindFirstChild("HumanoidRootPart")
        local bb = hrp and hrp:FindFirstChild("ToFStunUI")
        if bb then bb:Destroy() end
    end

    local function pistolShowStun(killerChar)
        if not PistolStun.Enabled then return end
        local hrp = killerChar and killerChar:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local old = hrp:FindFirstChild("ToFStunUI")
        if old then old:Destroy() end
        local bb = Instance.new("BillboardGui")
        bb.Name = "ToFStunUI"
        bb.Adornee = hrp
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 52, 0, 52)
        bb.StudsOffsetWorldSpace = Vector3.new(0, 4.6, 0)
        bb.ResetOnSpawn = false
        bb.LightInfluence = 0
        bb.Parent = hrp
        local ring = Instance.new("ImageLabel", bb)
        ring.Name = "Ring"
        ring.Size = UDim2.new(1, 0, 1, 0)
        ring.BackgroundTransparency = 1
        ring.Image = "rbxassetid://129594563448607"
        ring.ImageColor3 = Color3.fromRGB(255, 255, 255)
        ring.ScaleType = Enum.ScaleType.Fit
        local txt = Instance.new("TextLabel", bb)
        txt.Name = "StunText"
        txt.BackgroundTransparency = 1
        txt.Size = UDim2.new(1, 0, 0, 18)
        txt.Position = UDim2.new(0, 0, 1, 0)
        txt.Font = Enum.Font.GothamBlack
        txt.Text = "STUN"
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.TextScaled = true
        txt.TextStrokeTransparency = 0
        txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        local stroke = Instance.new("UIStroke", txt)
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(0, 0, 0)
        task.spawn(function()
            local rot = 0
            while bb.Parent do
                rot = (rot + 7) % 360
                ring.Rotation = rot
                task.wait(0.03)
            end
        end)
    end

    local function pistolWatchStun(killerChar)
        if not PistolStun.Enabled then return end
        if not killerChar or PistolStun.Data[killerChar] then return end
        PistolStun.Data[killerChar] = true
        task.spawn(function()
            local t0 = tick()
            while killerChar.Parent and tick() - t0 < 1.8 do
                if killerChar:GetAttribute("IsStunned")
                    or killerChar:GetAttribute("Stunned")
                    or killerChar:GetAttribute("Immobile") then
                    pistolShowStun(killerChar)
                    task.wait(1.8)
                    pistolHideStun(killerChar)
                    break
                end
                task.wait(0.05)
            end
            PistolStun.Data[killerChar] = nil
        end)
    end

    local oxioDoShoot = doShoot
    doShoot = function(...)
        local before = tick()
        local ok = pcall(oxioDoShoot, ...)
        if not PistolStun.Enabled then return ok end

        local target = nil
        pcall(function()
            local _, _, _, aimPos = getTargetPosition()
            if not aimPos then return end
            local bestDist = math.huge
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and IsKiller(player) and player.Character then
                    local torso = player.Character:FindFirstChild("Torso")
                        or player.Character:FindFirstChild("UpperTorso")
                        or player.Character:FindFirstChild("HumanoidRootPart")
                    if torso then
                        local d = (torso.Position - aimPos).Magnitude
                        if d < bestDist then
                            bestDist = d
                            target = player.Character
                        end
                    end
                end
            end
            if bestDist > 12 then target = nil end
        end)
        if target then
            pcall(pistolWatchStun, target)
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and IsKiller(player) and player.Character then
                    pcall(pistolWatchStun, player.Character)
                end
            end
        end
        return ok
    end

    PistolSection:AddToggle("STUN Killer Status", true, function(v)
        PistolStun.Enabled = v
        if not v then
            for char in pairs(PistolStun.Data) do
                pistolHideStun(char)
            end
            PistolStun.Data = {}
        end
    end, {Flag = "Pistol_StunKiller"})

    v42 = S_Page:CreateSection("Anti Hook", "shield")
    AntiHookCard = v42

    v43 = AntiHookCard:AddToggle("Anti Hook", false, function(arg)
        ToggleAntiHook(arg)
    end)

    AntiHookToggle = v43

    -- FIX ANTI HOOK: slider offset dibatasi 1-20 (dulu 50-1000) supaya
    -- karakter tidak ditarik balik ke posisi lama.
    AntiHookCard:AddSlider("Offset", 1, 20, 6, function(arg)
        _G.Ox.AntiHook.OffsetY = -arg
    end, {Increment = 1, Flag = "AntiHookOffsetY"})

    AntiHookCard:AddSlider("Send HZ", 1, 30, 12, function(hz)
        _G.Ox.AntiHook.Hz = hz
        _G.Ox.AntiHook.Interval = 1 / hz
    end, {Increment = 1, Flag = "AntiHookHz"})

    local BH = _G.Ox.BypassHook or { Enabled = false, Running = false, SavedCFrame = nil, AutoConn = nil }
    _G.Ox.BypassHook = BH

    BH.GetRoot = function()
        local char = localPlayer.Character
        return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    end

    BH.GetAntiCamp = function()
        local names = { "anticampCharge", "AntiCampCharge", "AnticampCharge", "antiCampCharge", "AntiCampProgress", "AntiCamp", "Anticamp" }
        local char = localPlayer.Character
        local val
        for _, n in ipairs(names) do
            if char then val = char:GetAttribute(n) end
            if val == nil then val = localPlayer:GetAttribute(n) end
            if val ~= nil then break end
        end
        if val == nil and char then
            local ac = char:FindFirstChild("anticampCharge", true) or char:FindFirstChild("AntiCampCharge", true)
            if ac and ac:IsA("ValueObject") then val = ac.Value end
        end
        return tonumber(val) or 0, val ~= nil
    end

    BH.IsHooked = function()
        local char = localPlayer.Character
        if not char then return false end
        local names = { "IsHooked", "Hooked", "IsCarried", "Carried", "IsGrabbed", "Grabbed", "PickedUp", "InGrab" }
        for _, inst in ipairs({ char, char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid"), localPlayer }) do
            if inst then
                for _, n in ipairs(names) do
                    if inst:GetAttribute(n) == true then return true end
                end
            end
        end
        local ci = char:FindFirstChild("CheckInterractable")
        if ci and (ci:GetAttribute("isCarrying") == true or ci:GetAttribute("IsCarrying") == true or ci:GetAttribute("isCarried") == true) then
            return true
        end
        return false
    end

    BH.HoldCFrame = function(cf, dur)
        if not cf then return end
        local t0 = tick()
        while tick() - t0 < (dur or 1.2) do
            local r = BH.GetRoot()
            if not r or not r.Parent then break end
            r.CFrame = cf
            r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            r.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            task.wait(0.03)
        end
    end

    BH.ReturnTo = function(cf)
        if not cf then return false end
        BH.HoldCFrame(cf, 0.6)
        local r = BH.GetRoot()
        return r ~= nil and (r.Position - cf.Position).Magnitude < 6
    end

    BH.FindGenerators = function()
        local list = {}
        pcall(function()
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("Model") and (d.Name == "Generator" or d.Name:find("Generator")) then
                    table.insert(list, d)
                end
            end
        end)
        return list
    end

    BH.FindKillerRoot = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= localPlayer and plr.Character then
                local char = plr.Character
                local isK = false
                local okK, res = pcall(IsKiller, plr)
                if okK and res then isK = true end
                if not isK then
                    if plr:GetAttribute("Role") == "Killer" or plr:GetAttribute("IsKiller") == true
                        or char:GetAttribute("Role") == "Killer" or char:GetAttribute("IsKiller") == true then
                        isK = true
                    end
                end
                if not isK and plr.Team then
                    local tn = plr.Team.Name:lower()
                    if tn:find("killer") or tn:find("slasher") or tn:find("monster") then
                        isK = true
                    end
                end
                if isK then
                    local r = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                    if r then return r end
                end
            end
        end
        return nil
    end

    BH.Cancel = function()
        if not BH.Running then return end
        BH.Running = false
        if BH.SavedCFrame then BH.HoldCFrame(BH.SavedCFrame, 0.6) end
        lib:Notify({ Title = "Bypass Hook", Description = "Dibatalkan, balik ke posisi hook.", Duration = 2 })
    end

    BH.Run = function()
        if BH.Running then
            BH.Cancel()
            return
        end

        local root = BH.GetRoot()
        local char = localPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then
            lib:Notify({ Title = "Bypass Hook", Description = "Character tidak ada / mati.", Duration = 2 })
            return
        end

        BH.Running = true
        BH.SavedCFrame = root.CFrame
        lib:Notify({ Title = "Bypass Hook", Description = "Mulai self-unhook...", Duration = 2 })

        task.spawn(function()
            local okRun, errRun = pcall(function()
                local RS = ReplicatedStorage
                local remotes = RS:FindFirstChild("Remotes")
                local repairEvent
                pcall(function()
                    local genRem = remotes and remotes:FindFirstChild("Generator")
                    repairEvent = (genRem and genRem:FindFirstChild("RepairEvent")) or RS:FindFirstChild("RepairEvent", true)
                end)

                local gen
                for _, g in ipairs(BH.FindGenerators()) do
                    if g:FindFirstChild("MainPart") or g:FindFirstChild("Engine") or g:FindFirstChildWhichIsA("BasePart") then
                        gen = g
                        break
                    end
                end

                if gen then
                    local gp = gen:FindFirstChild("MainPart") or gen:FindFirstChild("Engine") or gen:FindFirstChildWhichIsA("BasePart")
                    local r = BH.GetRoot()
                    if gp and r then
                        r.CFrame = gp.CFrame + Vector3.new(0, 2, 0)
                        r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        task.wait(0.2)
                    end
                    local point
                    for _, c in ipairs(gen:GetChildren()) do
                        if c.Name:lower():find("point") then
                            point = c
                            break
                        end
                    end
                    if repairEvent and point then
                        pcall(function() repairEvent:FireServer(point, true) end)
                        task.wait(0.25)
                        pcall(function() repairEvent:FireServer(point, false) end)
                        task.wait(0.2)
                    end
                end

                local startT = tick()
                local lastPct = -1
                local hasAttr = false
                local lastPctChange = tick()
                local prevPct = -1

                while BH.Running and (tick() - startT) < 60 do
                    local pct, found = BH.GetAntiCamp()
                    if found then hasAttr = true end
                    if pct >= 100 then break end
                    if pct ~= prevPct then
                        prevPct = pct
                        lastPctChange = tick()
                    end
                    if (tick() - startT) > 6 and not hasAttr and pct <= 0 then break end
                    if hasAttr and (tick() - lastPctChange) > 12 then break end

                    local p = math.floor(pct)
                    if p % 25 == 0 and p ~= lastPct and p > 0 then
                        lastPct = p
                        lib:Notify({ Title = "Bypass Hook", Description = string.format("Anti-Camp: %d%%", p), Duration = 1.5 })
                    end

                    local kr = BH.FindKillerRoot()
                    local r = BH.GetRoot()
                    if kr and r and r.Parent then
                        r.CFrame = CFrame.new(kr.Position - Vector3.new(0, 16, 0))
                        r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                    task.wait(0.06)
                end

                if BH.SavedCFrame then
                    BH.HoldCFrame(BH.SavedCFrame, 0.6)
                end

                local unHook
                pcall(function()
                    local carry = remotes and remotes:FindFirstChild("Carry")
                    unHook = carry and carry:FindFirstChild("SelfUnHookEvent")
                    if not unHook then unHook = RS:FindFirstChild("SelfUnHookEvent", true) end
                end)

                if unHook then
                    pcall(function() unHook:FireServer() end)
                    task.wait(0.1)
                    BH.HoldCFrame(BH.SavedCFrame, 1.4)
                    pcall(function() unHook:FireServer() end)
                    BH.HoldCFrame(BH.SavedCFrame, 1.4)
                    lib:Notify({ Title = "Bypass Hook", Description = "Self-unhook berhasil! Balik ke posisi hook.", Duration = 2 })
                else
                    BH.HoldCFrame(BH.SavedCFrame, 1.0)
                    lib:Notify({ Title = "Bypass Hook", Description = "SelfUnHookEvent tidak ditemukan.", Duration = 2 })
                end
            end)

            if not okRun then
                lib:Notify({ Title = "Bypass Hook", Description = "Error: " .. tostring(errRun), Duration = 3 })
            end
            BH.Running = false
        end)
    end

    _G.doAutoUnhook = BH.Run

    BH.StartAuto = function()
        if BH.AutoConn then return end
        BH.AutoConn = RunService.Heartbeat:Connect(function()
            if not BH.Enabled or BH.Running then return end
            if BH.IsHooked() then
                BH.Run()
            end
        end)
    end

    BypassHookToggle = AntiHookCard:AddToggle("Bypass Hook", false, function(arg)
        BH.Enabled = arg
        if arg then
            BH.StartAuto()
        end
        lib:Notify({ Title = "Bypass Hook", Description = arg and "AKTIF - auto self-unhook saat ke-hook" or "NONAKTIF", Duration = 2 })
    end, { Flag = "BypassHook" })
    BypassHookToggle:AddKeyPicker("None")

    AntiHookCard:AddButton("Bypass Hook (Manual)", function()
        BH.Run()
    end)

    v44 = S_Page:CreateSection("Survivor Ability", "zap")
    AbilityCard = v44

    v45 = AbilityCard:AddToggle("Instant TP Gate", false, function(arg)
        fn50(arg)
    end, {Flag = "InstanTPGate"})

    InstantTPToggle = v45
    InstantTPToggle:AddKeyPicker("None")

    AbilityCard:AddToggle("Auto Crouch (Dodge S1)", false, function(autoCrouch)
        _G.Ox.ParryConfig.AutoCrouch = autoCrouch
    end, {Flag = "AutoCrouch"})

    v46 = AbilityCard:AddToggle("Unlimited Vault", false, function(arg)
        fn53(arg)
    end, {Flag = "UnlimitedVault"})

    UnlimitedVaultToggle = v46
    UnlimitedVaultToggle:AddKeyPicker("None")

    v47 = AbilityCard:AddToggle("Anti Slow Vault", false, function(survPerfectVault)
        _G.Ox.Config.Surv_PerfectVault = survPerfectVault
        local notify = lib.Notify
        local tbl13 = {Title = "Anti Slow Vault"}
        local description = survPerfectVault and "AKTIF" or "NONAKTIF"
        tbl13.Description = description
        tbl13.Duration = 2
        notify(lib, tbl13)
    end, {Flag = "AntiSlowVault"})

    AntiSlowVaultToggle = v47
    AntiSlowVaultToggle:AddKeyPicker("None")

    v48 = AbilityCard:AddToggle("Flowstate No CD", false, function(arg)
        fn55(arg)
    end, {Flag = "FlowstateNoCD"})

    FlowstateToggle = v48
    FlowstateToggle:AddKeyPicker("None")
end

local v3 = AbilityCard:AddToggle("No Fall Damage", false, function(arg)
    fn14(arg)
end, {Flag = "NoFallDamage"})

NoFallToggle = v3
NoFallToggle:AddKeyPicker("None")

local v4 = AbilityCard:AddToggle("Bypass Exit Gate", false, function(arg)
    fn15(arg)
end, {Flag = "BypassExiteGate"})

BypassGateToggle = v4

local v6 = AbilityCard:AddToggle("God Mode (Anti Knockdown)", false, function(godMode)
    _G.Ox.GodMode = godMode
    local notify = lib.Notify
    local tbl6 = {Title = "God Mode"}
    local description = godMode and "AKTIF - HP tidak akan berkurang" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 3
    notify(lib, tbl6)
end, {Flag = "GodMode"})

GodModeToggle = v6

GodModeToggle:AddKeyPicker("GodModeKey", {
    Default = "None",
    Text = "Toggle God Mode",
    Mode = "Toggle",
    Callback = function(godMode)
        _G.Ox.GodMode = godMode
    end,
})

AbilityCard:AddButton("Apply Korless", function()
    fn17()

    lib:Notify({
        Title = "Korless",
        Description = "Korless Morph Applied!",
        Duration = 3,
    })
end)

AbilityCard:AddButton("Instan Escape", function()
    fn18()
end)

local vHeal = S_Page:CreateSection("Heal", "heart")
HealCard = vHeal

local vSelfHeal = HealCard:AddToggle("Self Heal", false, function(arg)
    fn16(arg)
end, {Flag = "SelfHeal"})

SelfHealToggle = vSelfHeal
SelfHealToggle:AddKeyPicker("None")

local vAH1 = HealCard:AddToggle("Aura Heal", false, function(arg)
    if _G.Ox.AuraHealSet then
        _G.Ox.AuraHealSet(arg)
    end

    lib:Notify({
        Title = "Aura Heal",
        Description = arg and "AKTIF - heal diri + survivor sekitar" or "NONAKTIF",
        Duration = 2,
    })
end, {Flag = "AuraHeal"})

AuraHealToggle = vAH1
AuraHealToggle:AddKeyPicker("None")

HealCard:AddSlider("Heal Radius", 5, 120, 30, function(auraRadius)
    if _G.Ox.AuraHeal then
        _G.Ox.AuraHeal.Radius = auraRadius
    end
end, {Increment = 1, Flag = "AuraHealRadius"})

HealCard:AddSlider("Heal Interval", 0.1, 3, 0.5, function(auraInterval)
    if _G.Ox.AuraHeal then
        _G.Ox.AuraHeal.Interval = auraInterval
    end
end, {Increment = 0.1, Flag = "AuraHealInterval"})

HealCard:AddToggle("Heal Diri Sendiri", true, function(auraSelf)
    if _G.Ox.AuraHeal then
        _G.Ox.AuraHeal.HealSelf = auraSelf
    end
end, {Flag = "AuraHealSelf"})

HealCard:AddToggle("Heal Survivor Lain", true, function(auraOthers)
    if _G.Ox.AuraHeal then
        _G.Ox.AuraHeal.HealOthers = auraOthers
    end
end, {Flag = "AuraHealOthers"})

local FakeActions = S_Page:CreateSection("Fake Actions", "sparkles")
FakeActions:AddToggle("Fake Parry (Press V)", false, function(v)
    _G.Ox.Fake = _G.Ox.Fake or {}
    _G.Ox.Fake.SurvFakeParry = v
    local P = _G.Ox.Ported
    if P and P.FP and P.FP.Button then P.FP.Button.Visible = v end
    lib:Notify({ Title = "Fake Parry", Description = v and "AKTIF - tekan V / tombol" or "NONAKTIF", Duration = 2 })
end, { Flag = "SurvFakeParry" })
FakeActions:AddDropdown("Fake Parry Animation", { "Enten", "Stopwatch", "Fih", "BloodShield" }, "Enten", function(v)
    _G.Ox.Fake = _G.Ox.Fake or {}
    _G.Ox.Fake.SurvFakeParryAnim = v
end, { Flag = "SurvFakeParryAnim" })
FakeActions:AddToggle("Fake Generator (Press B)", false, function(v)
    _G.Ox.Fake = _G.Ox.Fake or {}
    _G.Ox.Fake.SurvFakeGen = v
    local P = _G.Ox.Ported
    if P and P.FG then
        if P.FG.Button then P.FG.Button.Visible = v end
        if not v and P.FG.Track then pcall(function() P.FG.Track:Stop() end); P.FG.Track = nil end
    end
    lib:Notify({ Title = "Fake Generator", Description = v and "AKTIF - tekan B / tombol" or "NONAKTIF", Duration = 2 })
end, { Flag = "SurvFakeGen" })

local v7 = S_Page:CreateSection("Survivor Aimbot", "crosshair")
AimbotCard = v7

local v8 = AimbotCard:AddToggle("Enable Aimbot", false, function(survAimbotEnabled)
    _G.Ox.Config.Surv_Aimbot_Enabled = survAimbotEnabled

    if not survAimbotEnabled then
        if _G.Ox.survivorAimbotHighlight then
            _G.Ox.survivorAimbotHighlight.Parent = nil
        end

        if _G.Ox.SurvivorFOVFrame then
            _G.Ox.SurvivorFOVFrame.Visible = false
        end
    end

    local notify = lib.Notify
    local tbl6 = {Title = "Survivor Aimbot"}
    local description = survAimbotEnabled and "AKTIF" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 2
    notify(lib, tbl6)
end, {Flag = "SurvAimbot"})

AimbotToggle = v8

AimbotToggle:AddKeyPicker("SurvivorAimbotKey", {
    Default = "None",
    Text = "Toggle Aimbot",
    Mode = "Toggle",
    Callback = function(survAimbotEnabled)
        _G.Ox.Config.Surv_Aimbot_Enabled = survAimbotEnabled

        if not survAimbotEnabled then
            if _G.Ox.survivorAimbotHighlight then
                _G.Ox.survivorAimbotHighlight.Parent = nil
            end

            if _G.Ox.SurvivorFOVFrame then
                _G.Ox.SurvivorFOVFrame.Visible = false
            end
        end
    end,
})

AimbotCard:AddToggle("Show FOV Circle", true, function(survAimbotShowFOV)
    _G.Ox.Config.Surv_Aimbot_ShowFOV = survAimbotShowFOV

    if not survAimbotShowFOV and _G.Ox.SurvivorFOVFrame then
        _G.Ox.SurvivorFOVFrame.Visible = false
    end
end, {Flag = "SurvAimbotFOV"})

AimbotCard:AddSlider("FOV Radius", 30, 500, 150, function(survAimbotRadius)
    _G.Ox.Config.Surv_Aimbot_Radius = survAimbotRadius
end, {Increment = 1, Flag = "SurvAimbotRadius"})

AimbotCard:AddSlider("Max Distance", 50, 1000, 300, function(survAimbotMaxDist)
    _G.Ox.Config.Surv_Aimbot_MaxDist = survAimbotMaxDist
end, {Increment = 10, Flag = "SurvAimbotMaxDist"})

AimbotCard:AddSlider("Smoothness", 0.1, 1, 0.5, function(survAimbotSmoothness)
    _G.Ox.Config.Surv_Aimbot_Smoothness = survAimbotSmoothness
end, {Increment = 0.05, Flag = "SurvAimbotSmoot"})

AimbotCard:AddSlider("Predict Offset", 0, 0.1, 0.01, function(survAimbotPredict)
    _G.Ox.Config.Surv_Aimbot_Predict = survAimbotPredict
end, {Increment = 0.001, Flag = "SurvAimbotPredict"})

AimbotCard:AddDropdown("Target Part", {"Torso", "Head", "Root"}, false, function(survAimbotTargetPart)
    _G.Ox.Config.Surv_Aimbot_TargetPart = survAimbotTargetPart
end, {Flag = "SurvAimbotTarget"})

local v9 = S_Page:CreateSection("Auto Parry V1", "sword")
ParryCardV1 = v9

local v10 = ParryCardV1:AddToggle("Auto Parry V1", false, function(autoParry)
    _G.Ox.ParryConfig.AutoParry = autoParry

    if not autoParry then
        _G.Ox.State.ParryCooldown = false

        if _G.Ox.State.ParryCooldownThread then
            task.cancel(_G.Ox.State.ParryCooldownThread)
            _G.Ox.State.ParryCooldownThread = nil
        end

        if ParryHUD and ParryHUD.Reset then
            ParryHUD.Reset()
        end
    end

    local notify = lib.Notify
    local tbl6 = {Title = "Auto Parry V1"}
    local description = autoParry and "AKTIF" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 2
    notify(lib, tbl6)
end, {Flag = "AutoParryV1"})

AutoParryToggle = v10
AutoParryToggle:AddKeyPicker("None")

local v11 = ParryCardV1:AddToggle("Custom GUI (V1)", false, function(arg)
    if arg then
        if not _G.Ox.AutoParryCustom.Gui then
            CreateCustomParryGUI()
        end

        _G.Ox.AutoParryCustom.Gui.Enabled = true
        _G.Ox.AutoParryCustom.GuiVisible = true
        UpdateCustomParryGUI(_G.Ox.ParryConfig.AutoParry)

        lib:Notify({
            Title = "Auto Parry GUI",
            Description = "Gui Dimuat",
            Duration = 2,
        })
    else
        if _G.Ox.ParryConfig.AutoParry then
            _G.Ox.ParryConfig.AutoParry = false
            _G.Ox.AutoParryCustom.IsActive = false
            fn(AutoParryToggle, false)
        end

        if _G.Ox.AutoParryCustom.Gui then
            _G.Ox.AutoParryCustom.Gui.Enabled = false
            _G.Ox.AutoParryCustom.GuiVisible = false
        end

        lib:Notify({
            Title = "Auto Parry GUI",
            Description = "Gui Disembunyikan",
            Duration = 2,
        })
    end
end, {Flag = "AutoParryGuiV1"})

CustomParryToggle = v11

ParryCardV1:AddCheckbox("Safety Parry", false, function(parrySafety)
    _G.Ox.ParryConfig.ParrySafety = parrySafety
end, {Flag = "ParrySafetyV1"})

ParryCardV1:AddToggle("Aggressive Mode", false, function(parryAggressive)
    _G.Ox.ParryConfig.ParryAggressive = parryAggressive
end, {Flag = "ParryAggressiveV1"})

ParryCardV1:AddToggle("Show Range Circle", true, function(parryCircle)
    _G.Ox.ParryConfig.ParryCircle = parryCircle
end, {Flag = "ParryCircleV1"})

ParryCardV1:AddSlider("Parry Radius", 5, 25, 15, function(parryRadius)
    _G.Ox.ParryConfig.ParryRadius = parryRadius
end, {Increment = 1, Flag = "ParryRadiusV1"})

ParryCardV1:AddSlider("Face Sensitivity", -10, 10, 7, function(arg)
    _G.Ox.ParryConfig.ParryFace = arg / 10
end, {Increment = 1, Flag = "ParryFaceV1"})

local v12 = S_Page:CreateSection("Auto Parry V2", "sword")
ParryCardV2 = v12

local v13 = ParryCardV2:AddToggle("Auto Parry V2", false, function(enabled)
    _G.Ox.ParryV2.Enabled = enabled

    if not enabled then
        V2_ResetCooldown()
        _G.Ox._V2ParryLastRoot = nil
        _G.Ox._V2ParryLastRadius = -1

        if _G.Ox.ParryV2.RangeAdornment then
            _G.Ox.ParryV2.RangeAdornment.Transparency = 1
        end
    end

    local notify = lib.Notify
    local tbl6 = {Title = "Auto Parry V2"}
    local description = enabled and "AKTIF" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 2
    notify(lib, tbl6)
end, {Flag = "AutoParryV2"})

ParryV2Toggle = v13
ParryV2Toggle:AddKeyPicker("None")

ParryCardV2:AddCheckbox("Safety Parry", false, function(safetyParry)
    _G.Ox.ParryV2.SafetyParry = safetyParry
end, {Flag = "ParrySafetyV2"})

ParryCardV2:AddDropdown("Mode", {"Legit", "Strict", "Aggressive"}, false, function(arg)
    local parryV2 = _G.Ox.ParryV2
    local mode = arg or "Legit"
    parryV2.Mode = mode
end, {Flag = "ParryModeV2"})

ParryCardV2:AddDropdown("Trigger", {"Remote", "Button"}, false, function(arg)
    local parryV2 = _G.Ox.ParryV2
    local trigger = arg or "Remote"
    parryV2.Trigger = trigger
end, {Flag = "ParryTriggerV2"})

ParryCardV2:AddSlider("Killer Face", -1, 1, 0.6, function(killerFace)
    _G.Ox.ParryV2.KillerFace = killerFace
end, {Increment = 0.1, Flag = "ParryKillerFaceV2"})

ParryCardV2:AddToggle("Show Range Circle", true, function(showCircle)
    _G.Ox.ParryV2.ShowCircle = showCircle

    if not showCircle and _G.Ox.ParryV2.RangeAdornment then
        _G.Ox.ParryV2.RangeAdornment.Transparency = 1
    end
end, {Flag = "ParryCircleV2"})

ParryCardV2:AddSlider("Parry Radius", 2, 20, 12, function(range)
    _G.Ox.ParryV2.Range = range
    _G.Ox._V2ParryLastRadius = -1

    if _G.Ox.ParryV2.RangeAdornment then
        _G.Ox.ParryV2.RangeAdornment.Radius = range
        _G.Ox.ParryV2.RangeAdornment.InnerRadius = math.max(0.1, range - 0.15)
    end
end, {Increment = 0.5, Flag = "ParryRadiusV2"})

local v14 = S_Page:CreateSection("Auto Drop Pallet", "fence")
PalletCard = v14

local v15 = PalletCard:AddToggle("Auto Drop Pallet", false, function(arg)
    ToggleAutoPallet(arg)
end, {Flag = "AutoDropPallet"})

AutoPalletToggle = v15

AutoPalletToggle:AddKeyPicker("AutoPalletKey", {
    Default = "None",
    Text = "Toggle Auto Drop Pallet",
    Mode = "Toggle",
    Callback = function(arg)
        ToggleAutoPallet(arg)
    end,
})

PalletCard:AddCheckbox("Safety", true, function(safety)
    _G.Ox.AutoPallet.Safety = safety
end, {Flag = "PalletSafety"})

PalletCard:AddSlider("Trigger Distance", 5, 30, 10, function(distance)
    _G.Ox.AutoPallet.Distance = distance
end, {Increment = 1, Flag = "PalletDistance"})

PalletCard:AddButton("Drop All Pallets", function()
    DropAllPallets()
end)

local Killer = v:CreateTab("Killer", false, false)
KillerTab = Killer
local Killer2 = KillerTab:CreatePage("Killer")
K_Page = Killer2
local v16 = K_Page:CreateSection("Killer Aimbot", "swords")
KillerAimbotCard = v16

local v17 = KillerAimbotCard:AddToggle("Enable Aimbot (Melee)", false, function(killerAimbotEnabled)
    _G.Ox.Config.Killer_Aimbot_Enabled = killerAimbotEnabled

    if not killerAimbotEnabled and _G.Ox.killerAimbotHighlight then
        _G.Ox.killerAimbotHighlight.Parent = nil
    end

    local notify = lib.Notify
    local tbl6 = {Title = "Killer Aimbot"}
    local description = killerAimbotEnabled and "AKTIF" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 2
    notify(lib, tbl6)
end)

KillerAimbotToggle = v17

KillerAimbotCard:AddSlider("Max Distance", 5, 30, 12, function(killerAimbotMaxDist)
    _G.Ox.Config.Killer_Aimbot_MaxDist = killerAimbotMaxDist
end, {Increment = 1, Flag = "AimbotKillerMaxDist"})

KillerAimbotCard:AddSlider("Smoothness", 0.1, 1, 0.5, function(killerAimbotSmoothness)
    _G.Ox.Config.Killer_Aimbot_Smoothness = killerAimbotSmoothness
end, {Increment = 0.05, Flag = "AimbotKillerSmoothness"})

local v18 = K_Page:CreateSection("Silent Veil", "arrow-up-right")
VeilCard = v18

local v19 = VeilCard:AddToggle("Silent Veil", false, function(aimSilentVeilV2)
    _G.Ox.AimConfig.Aim_SilentVeilV2 = aimSilentVeilV2
    local notify = lib.Notify
    local tbl6 = {Title = "Silent Veil"}
    local description = aimSilentVeilV2 and "ON" or "OFF"
    tbl6.Description = description
    tbl6.Duration = 2
    notify(lib, tbl6)
end)

VeilTog = v19

VeilCard:AddToggle("Auto Predict", false, function(spearSmartEnable)
    _G.Ox.Config.SpearSmart_enable = spearSmartEnable
end, {Flag = "SpearSmartVeil"})

VeilCard:AddToggle("Show FOV", true, function(veilShowFOV)
    _G.Ox.AimConfig.Veil_ShowFOV = veilShowFOV
end, {Flag = "VeilShowFOV"})

VeilCard:AddSlider("Lead", 0.5, 5, 1.4, function(veilLeadMultiplier)
    _G.Ox.AimConfig.Veil_LeadMultiplier = veilLeadMultiplier
end, {Increment = 0.1, Flag = "VeilLeadMulti"})

VeilCard:AddSlider("Spear Speed", 50, 200, 165, function(spearSpeed)
    _G.Ox.AimConfig.SPEAR_Speed = spearSpeed
end, {Increment = 1, Flag = "VeilSpearSpeed"})

VeilCard:AddSlider("Spear Gravity", 10, 200, 103, function(spearGravity)
    _G.Ox.AimConfig.SPEAR_Gravity = spearGravity
end, {Increment = 1, Flag = "VeilSpearGravity"})

VeilCard:AddSlider("Aura Speed", 50, 200, 165, function(spearAuraSpeed)
    _G.Ox.AimConfig.SPEAR_AuraSpeed = spearAuraSpeed
end, {Increment = 1, Flag = "VeilSpearAuraSpeed"})

VeilCard:AddSlider("Aura Gravity", 10, 200, 96.5, function(spearAuraGravity)
    _G.Ox.AimConfig.SPEAR_AuraGravity = spearAuraGravity
end, {Increment = 1, Flag = "VeilSpearAuraGravity"})

VeilCard:AddSlider("FOV", 50, 500, 150, function(veilFov)
    _G.Ox.AimConfig.Veil_FOV = veilFov
end, {Increment = 1, Flag = "VeilFOV"})

VeilCard:AddSlider("Max Dist", 50, 1000, 500, function(spearMaxDist)
    _G.Ox.AimConfig.SPEAR_MaxDist = spearMaxDist
end, {Increment = 10, Flag = "SpearMaxDist"})

local v20 = K_Page:CreateSection("Killer Ability", "zap")
AntiBlindSection = v20

local v21 = AntiBlindSection:AddToggle("Anti Blind (Flashlight)", false, function(antiBlindEnabled)
    _G.Ox.AntiBlindEnabled = antiBlindEnabled
    local notify = lib.Notify
    local tbl6 = {Title = "Anti Blind"}
    local description = antiBlindEnabled and "AKTIF - Immune dari flashlight" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 3
    notify(lib, tbl6)
end, {Flag = "AntiBlind"})

AntiBlindToggle = v21

AntiBlindToggle:AddKeyPicker("AntiBlindKey", {
    Default = "None",
    Text = "Toggle Anti Blind",
    Mode = "Toggle",
    Callback = function(antiBlindEnabled)
        _G.Ox.AntiBlindEnabled = antiBlindEnabled
    end,
})

local v22 = AntiBlindSection:AddToggle("Anti Parry", false, function(arg)
    ToggleCounterParry(arg)
end)

CounterParryToggle = v22

local v23 = AntiBlindSection:AddToggle("Infinite Lunge", false, function(arg)
    if arg then
        EnableInfiniteLunge()
    else
        DisableInfiniteLunge()
    end
end, {Flag = "InfiniteLunge"})

InfLungeToggle = v23

InfLungeToggle:AddKeyPicker("InfLungeKey", {
    Default = "None",
    Text = "Toggle Infinite Lunge",
    Mode = "Toggle",
    Callback = function(arg)
        if arg then
            EnableInfiniteLunge()
        else
            DisableInfiniteLunge()
        end
    end,
})

local v24 = AntiBlindSection:AddToggle("Auto Stalk", false, function(arg)
    ToggleAutoStalk(arg)
end, {Flag = "AutoStalk"})

AutoStalkToggle = v24

AutoStalkToggle:AddKeyPicker("AutoStalkKey", {
    Default = "None",
    Text = "Toggle Auto Stalk",
    Mode = "Toggle",
    Callback = function(arg)
        ToggleAutoStalk(arg)
    end,
})

local v25 = AntiBlindSection:AddToggle("No Slowdown Killer", false, function(noSlowdownEnabled)
    _G.Ox.NoSlowdownEnabled = noSlowdownEnabled

    if noSlowdownEnabled then
        local character = localPlayer.Character

        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end

        lib:Notify({
            Title = "No Slowdown Killer",
            Description = "AKTIF - WalkSpeed dikunci 16",
            Duration = 3,
        })
    else
        lib:Notify({
            Title = "No Slowdown Killer",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end
end, {Flag = "NoSlowdown"})

AntiSlowdownToggle = v25

AntiSlowdownToggle:AddKeyPicker("NoSlowdownKey", {
    Default = "None",
    Text = "Toggle No Slowdown",
    Mode = "Toggle",
    Callback = function(noSlowdownEnabled)
        _G.Ox.NoSlowdownEnabled = noSlowdownEnabled

        if noSlowdownEnabled then
            local character = localPlayer.Character

            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end,
})

local v27 = AntiBlindSection:AddToggle("Infinite Corrupt (Abyssal)", false, function(infAbyssalEnabled)
    _G.Ox.InfAbyssalEnabled = infAbyssalEnabled

    if not infAbyssalEnabled then
        fn13()
    end

    local notify = lib.Notify
    local tbl6 = {Title = "Infinite Corrupt"}
    local description = infAbyssalEnabled and "AKTIF - Tekan Q (PC) atau tombol skill (Mobile)" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 3
    notify(lib, tbl6)
end, {Flag = "InfinityCorrupt"})

InfAbyssalToggle = v27

InfAbyssalToggle:AddKeyPicker("InfAbyssalKey", {
    Default = "None",
    Text = "Toggle Infinite Corrupt",
    Mode = "Toggle",
    Callback = function(infAbyssalEnabled)
        _G.Ox.InfAbyssalEnabled = infAbyssalEnabled

        if not infAbyssalEnabled then
            fn13()
        end
    end,
})

local v28 = AntiBlindSection:AddToggle("Dash Lock (Hidden)", false, function(arg)
    fn10(arg)
end, {Flag = "DashLockHidden"})

DashLockToggle = v28

DashLockToggle:AddKeyPicker("DashKey", {
    Default = "V",
    Text = "Toggle Dash Lock",
    Mode = "Toggle",
    Callback = function(arg)
        fn10(arg)
    end,
})

local v29 = AntiBlindSection:AddToggle("Mask Selection GUI", false, function(arg)
    fn11(arg)
end, {Flag = "MaskSelectGui"})

MaskToggle = v29
MaskToggle:AddKeyPicker("None")

AntiBlindSection:AddButton("Aim Lock Toggle", function()
    if pcall(function()
        loadstring(game:HttpGet("https://pastefy.app/5zsm8N7G/raw"))()
    end) then
        lib:Notify({
            Title = "Aim Lock",
            Description = "Aim Lock berhasil dimuat!",
            Duration = 3,
        })
    else
        lib:Notify({
            Title = "Error",
            Description = "Gagal memuat Aim Lock!",
            Duration = 3,
        })
    end
end)

local v30 = K_Page:CreateSection("Silent Aim Flask (Cure)", "flask-conical")
FlaskCard = v30

local v31 = FlaskCard:AddToggle("Silent Aim Flask", false, function(killerSilentAimFlask)
    _G.Ox.KILLER_SilentAimFlask = killerSilentAimFlask
    local notify = lib.Notify
    local tbl6 = {Title = "Silent Aim Flask"}
    local description = killerSilentAimFlask and "AKTIF" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 2
    notify(lib, tbl6)
end)

FlaskToggle = v31

local v32 = FlaskCard:AddToggle("Flask Laser", false, function(killerFlaskLaser)
    _G.Ox.KILLER_FlaskLaser = killerFlaskLaser

    if killerFlaskLaser then
        pcall(NEX_StartCureFlaskLaser)

        lib:Notify({
            Title = "Flask Laser",
            Description = "AKTIF - Laser merah muncul",
            Duration = 2,
        })
    else
        if _G.Ox.NEX_CureFlaskLaserThread then
            _G.Ox.NEX_CureFlaskLaserThread:Disconnect()
            _G.Ox.NEX_CureFlaskLaserThread = nil
        end

        if _G.Ox.NEX_CureFlaskLaserPart then
            pcall(function()
                _G.Ox.NEX_CureFlaskLaserPart:Destroy()
            end)

            _G.Ox.NEX_CureFlaskLaserPart = nil
        end

        lib:Notify({
            Title = "Flask Laser",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end
end, {Flag = "LaserFlask"})

FlaskLaserToggle = v32

FlaskLaserToggle:AddKeyPicker("FlaskLaserKey", {
    Default = "None",
    Text = "Toggle Flask Laser",
    Mode = "Toggle",
    Callback = function(killerFlaskLaser)
        _G.Ox.KILLER_FlaskLaser = killerFlaskLaser

        if killerFlaskLaser then
            pcall(NEX_StartCureFlaskLaser)
        else
            if _G.Ox.NEX_CureFlaskLaserThread then
                _G.Ox.NEX_CureFlaskLaserThread:Disconnect()
                _G.Ox.NEX_CureFlaskLaserThread = nil
            end

            if _G.Ox.NEX_CureFlaskLaserPart then
                pcall(function()
                    _G.Ox.NEX_CureFlaskLaserPart:Destroy()
                end)

                _G.Ox.NEX_CureFlaskLaserPart = nil
            end
        end
    end,
})

local v33 = K_Page:CreateSection("Anti Looping", "repeat")
AntiLoopingSection = v33

local v34 = AntiLoopingSection:AddToggle("Block Vault & Pallets", false, function(blockPalletEnabled)
    _G.Ox.BlockPalletEnabled = blockPalletEnabled

    if not blockPalletEnabled then
        local vaultCompleteEvent = game:GetService("ReplicatedStorage").Remotes.Window.VaultCompleteEvent
        local palletSlideCompleteEvent = game:GetService("ReplicatedStorage").Remotes.Pallet.PalletSlideCompleteEvent
        local map = workspace:FindFirstChild("Map")

        if map then
            for k, descendant in pairs(map:GetDescendants()) do
                if descendant.Name == "VaultPointInUse" then
                    pcall(function()
                        vaultCompleteEvent:FireServer(descendant.Parent, false)
                    end)
                elseif descendant.Name == "PalletPointSlideInUse" then
                    pcall(function()
                        palletSlideCompleteEvent:FireServer(descendant.Parent, false)
                    end)
                end
            end
        end

        return
    end

    local vaultEvent = game:GetService("ReplicatedStorage").Remotes.Window.VaultEvent
    local palletSlideEvent = game:GetService("ReplicatedStorage").Remotes.Pallet.PalletSlideEvent
    local map = workspace:FindFirstChild("Map")

    if map then
        for k, descendant in pairs(map:GetDescendants()) do
            if descendant.Name == "VaultTrigger" then
                pcall(function()
                    vaultEvent:FireServer(descendant, true)
                end)
            end

            if descendant.Name == "PalletPointSlide" and descendant:IsA("BasePart") then
                pcall(function()
                    palletSlideEvent:FireServer(descendant, true)
                end)
            end
        end
    end

    task.spawn(function()
        local map2 = workspace:FindFirstChild("Map")
        if not map2 then
            return
        end
        local tbl6 = {}

        watchPallet = function(arg)
            if arg:IsA("BasePart") and arg.Name == "PalletPoint" then
                local connection = arg:GetPropertyChangedSignal("Name"):Connect(function()
                    if not _G.Ox.BlockPalletEnabled then
                        return
                    end

                    if arg.Name == "PalletPointSlide" then
                        task.wait(0.1)

                        pcall(function()
                            palletSlideEvent:FireServer(arg, true)
                        end)
                    end
                end)

                table.insert(tbl6, connection)
            end
        end

        for k, descendant in pairs(map2:GetDescendants()) do
            watchPallet(descendant)
        end

        local connection = map2.DescendantAdded:Connect(function(descendant)
            watchPallet(descendant)
        end)

        table.insert(tbl6, connection)

        while _G.Ox.BlockPalletEnabled do
            task.wait(0.5)
        end

        for k, v34 in pairs(tbl6) do
            v34:Disconnect()
        end

        tbl6 = {}
    end)

    lib:Notify({
        Title = "Anti Looping",
        Description = "â Aktif!",
        Duration = 2,
    })
end)

AntiLoopingToggle = v34
local Visual = v:CreateTab("Visual", false, false)
EspTab = Visual
local esp = EspTab:CreatePage("ESP")
EspPage = esp
local v35 = EspPage:CreateSection("ESP Settings", "eye")
EspMasterCard = v35

local v36 = EspMasterCard:AddToggle("Enable ESP", false, function(master)
    _G.Ox.ESPConfig.Master = master

    if master then
        ForceRefreshMap()
        lib:Notify({Title = "ESP", Description = "AKTIF", Duration = 2})
    else
        ClearAllESP()
        lib:Notify({Title = "ESP", Description = "NONAKTIF", Duration = 2})
    end
end, {Flag = "EnableEspMaster"})

EspMasterToggle = v36
EspMasterToggle:AddKeyPicker("EspKey", {Default = "None", Text = "ESP Key", Mode = "Toggle"})

EspMasterCard:AddSlider("ESP Max Distance", 100, 5000, 1000, function(maxDistance)
    _G.Ox.ESPConfig.MaxDistance = maxDistance
end, {Increment = 100, Flag = "EspMaxDistance"})

local v37 = EspMasterCard:AddCheckbox("Player ESP", false, function(player)
    _G.Ox.ESPConfig.Player = player

    if _G.Ox.ESPConfig.Master then
        if player then
            ScanMapESP()
        else
            ClearESP("Player")
        end
    end
end, {Flag = "PlayerEsp"})

PlayerToggle = v37

PlayerToggle:AddColorPicker(_G.Ox.ESPColors.Player, {
    Flag = "EspPlayer_Color",
    Title = "Warna Player ESP",
    Callback = function(player)
        _G.Ox.ESPColors.Player = player

        if _G.Ox.ESPConfig.Master then
            UpdatePlayerESP()
        end
    end,
})

local v38 = EspMasterCard:AddCheckbox("Killer ESP", false, function(killer)
    _G.Ox.ESPConfig.Killer = killer

    if _G.Ox.ESPConfig.Master then
        if killer then
            ScanMapESP()
        else
            ClearESP("Killer")
        end
    end
end, {Flag = "KillerEsp"})

KillerToggle = v38

KillerToggle:AddColorPicker(_G.Ox.ESPColors.Killer, {
    Flag = "EspKiller_Color",
    Title = "Warna Killer ESP",
    Callback = function(killer)
        _G.Ox.ESPColors.Killer = killer

        if _G.Ox.ESPConfig.Master then
            UpdatePlayerESP()
        end
    end,
})

local v39 = EspMasterCard:AddCheckbox("ESP Name", false, function(name)
    _G.Ox.ESPConfig.Name = name

    if _G.Ox.ESPConfig.Master then
        ScanMapESP()
    else
        ClearAllESP()
    end
end, {Flag = "EspName"})

NameToggle = v39

local v40 = EspMasterCard:AddCheckbox("ESP Distance", false, function(distance)
    _G.Ox.ESPConfig.Distance = distance

    if _G.Ox.ESPConfig.Master then
        UpdatePlayerESP()
    end
end, {Flag = "EspDistancw"})

DistToggle = v40

local v41 = EspMasterCard:AddCheckbox("ESP Status survivors", false, function(status)
    _G.Ox.ESPConfig.Status = status

    if _G.Ox.ESPConfig.Master then
        UpdatePlayerESP()
    end
end, {Flag = "EspStatus"})

StatusToggle = v41

local v42 = EspMasterCard:AddCheckbox("ESP Item Icon", false, function(itemIcon)
    _G.Ox.ESPConfig.ItemIcon = itemIcon

    if _G.Ox.ESPConfig.Master then
        UpdatePlayerESP()
    end
end, {Flag = "EspItemIcon"})

IconToggle = v42

local v43 = EspMasterCard:AddCheckbox("ESP Killer Warn", false, function(killerWarn)
    _G.Ox.ESPConfig.KillerWarn = killerWarn

    if not killerWarn then
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and humanoidRootPart:FindFirstChild("KillerWarn") then
            humanoidRootPart.KillerWarn:Destroy()
        end
    end
end, {Flag = "KillerWarn"})

WarnToggle = v43

local v44 = EspMasterCard:AddCheckbox("ESP Outline Mode", false, function(outline)
    _G.Ox.ESPConfig.Outline = outline
end, {Flag = "EspOutlineMode"})

OutlineToggle = v44

local v45 = EspMasterCard:AddCheckbox("ESP Hook Count", false, function(hookCount)
    _G.Ox.ESPConfig.HookCount = hookCount

    if hookCount then
        UpdateHookData()
        UpdatePlayerESP()
        UpdateHookUICounter()
        lib:Notify({Title = "Hook ESP", Description = "AKTIF", Duration = 2})
    else
        ClearHookESP()
        ClearHookUICounter()
        UpdatePlayerESP()
        lib:Notify({Title = "Hook ESP", Description = "NONAKTIF", Duration = 2})
    end
end, {Flag = "EspHookCount"})

HookCountToggle = v45
local v46 = EspPage:CreateSection("World Effects", "flashlight")
PerfCard = v46

local v47 = PerfCard:AddToggle("Full Bright", false, function(fullBright)
    _G.Ox.FullBright = fullBright
    local Lighting = game:GetService("Lighting")
    if not Lighting then
        return
    end

    if fullBright then
        StartLightingGuard()
        ReapplyPerformanceDelayed()
        lib:Notify({Title = "Full Bright", Description = "AKTIF", Duration = 2})
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1000
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        StopLightingGuard()

        lib:Notify({
            Title = "Full Bright",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end
end, {Flag = "FullBright"})

FullBrightToggle = v47

PerfCard:AddSlider("Time Of Day", 0, 24, 14, function(timeOfDayValue)
    _G.Ox.TimeOfDayValue = timeOfDayValue

    if _G.Ox.FullBright then
        local Lighting = game:GetService("Lighting")

        if Lighting then
            Lighting.ClockTime = timeOfDayValue
        end
    end
end, {Increment = 1, Flag = "TimeOfDay"})

local v48 = PerfCard:AddToggle("No Fog", false, function(noFog)
    _G.Ox.NoFog = noFog

    if noFog then
        StartLightingGuard()
        ApplyNoFog()

        lib:Notify({
            Title = "No Fog",
            Description = "AKTIF - Kabut hilang",
            Duration = 3,
        })
    else
        local Lighting = game:GetService("Lighting")

        if Lighting then
            Lighting.FogStart = 0
            Lighting.FogEnd = 1000
            local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

            if atmosphere then
                atmosphere.Density = 0.35
            end
        end

        StopLightingGuard()
        lib:Notify({Title = "No Fog", Description = "NONAKTIF", Duration = 2})
    end
end, {Flag = "NoFog"})

NoFogToggle = v48

local v49 = PerfCard:AddToggle("No Shadow", false, function(noShadow)
    _G.Ox.NoShadow = noShadow

    if noShadow then
        StartLightingGuard()
        ApplyNoShadow()

        lib:Notify({
            Title = "No Shadow",
            Description = "AKTIF - Shadow hilang",
            Duration = 2,
        })
    else
        ApplyNoShadow()
        StopLightingGuard()

        lib:Notify({
            Title = "No Shadow",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end
end, {Flag = "NoShadow"})

NoShadowToggle = v49

local v50 = PerfCard:AddToggle("Remove Texture (Low GFX)", false, function(arg)
    ToggleLowGFX(arg)
end, {Flag = "RemoveTexture"})

LowGFXToggle = v50
LowGFXToggle:AddKeyPicker("None")

PerfCard:AddToggle("Unlock FPS (Max FPS)", false, function(arg)
    _G.Ox.UnlockFPS = arg
    pcall(function()
        if type(setfpscap) == "function" then
            setfpscap(arg and 9999 or 60)
        end
    end)
end, {Flag = "UnlockFPS"}):AddKeyPicker("None")

local v51 = EspPage:CreateSection("Map ESP", "map")
MapCard = v51

local v52 = MapCard:AddCheckbox("Generator ESP", false, function(generator)
    _G.Ox.ESPConfig.Generator = generator

    if _G.Ox.ESPConfig.Master then
        if generator then
            ScanMapESP()
        else
            ClearESP("Generator")
        end
    end
end, {Flag = "GeneratorEsp"})

GenToggle = v52

GenToggle:AddColorPicker(_G.Ox.ESPColors.Generator, {
    Flag = "Generator_Color",
    Title = "Warna Generator",
    Callback = function(generator)
        _G.Ox.ESPColors.Generator = generator

        if _G.Ox.ESPConfig.Master then
            UpdateStaticESP()
        end
    end,
})

local v53 = MapCard:AddCheckbox("Generator Name & Progress", true, function(generatorName)
    _G.Ox.ESPConfig.GeneratorName = generatorName

    if _G.Ox.ESPConfig.Master then
        ScanMapESP()
    end
end, {Flag = "GeneratorName"})

GenNameToggle = v53

MapCard:AddColorPicker("Gen Done Color", _G.Ox.ESPColors.GeneratorDone, {
    Flag = "GeneratorDone_Color",
    Title = "Warna Generator Selesai",
    Callback = function(generatorDone)
        _G.Ox.ESPColors.GeneratorDone = generatorDone

        if _G.Ox.ESPConfig.Master then
            UpdateStaticESP()
        end
    end,
})

local v54 = MapCard:AddCheckbox("Pallet ESP", false, function(pallet)
    _G.Ox.ESPConfig.Pallet = pallet

    if _G.Ox.ESPConfig.Master then
        if pallet then
            ScanMapESP()
        else
            ClearESP("Pallet")
        end
    end
end, {Flag = "EspPallet"})

PalletToggle = v54

PalletToggle:AddColorPicker(_G.Ox.ESPColors.Pallet, {
    Flag = "Pallet_Color",
    Title = "Warna Pallet",
    Callback = function(pallet)
        _G.Ox.ESPColors.Pallet = pallet

        if _G.Ox.ESPConfig.Master then
            UpdateStaticESP()
        end
    end,
})

local v55 = MapCard:AddCheckbox("Window ESP", false, function(window)
    _G.Ox.ESPConfig.Window = window

    if _G.Ox.ESPConfig.Master then
        if window then
            ScanMapESP()
        else
            ClearESP("Window")
        end
    end
end, {Flag = "EspWindow"})

WindowToggle = v55

WindowToggle:AddColorPicker(_G.Ox.ESPColors.Window, {
    Flag = "Window_Color",
    Title = "Warna Window",
    Callback = function(window)
        _G.Ox.ESPColors.Window = window

        if _G.Ox.ESPConfig.Master then
            UpdateStaticESP()
        end
    end,
})

local v56 = MapCard:AddCheckbox("Hook ESP", false, function(hook)
    _G.Ox.ESPConfig.Hook = hook

    if _G.Ox.ESPConfig.Master then
        if hook then
            ScanMapESP()
        else
            ClearESP("Hook")
        end
    end
end, {Flag = "HookEsp"})

HookToggle = v56

HookToggle:AddColorPicker(_G.Ox.ESPColors.Hook, {
    Flag = "Hook_Color",
    Title = "Warna Hook",
    Callback = function(hook)
        _G.Ox.ESPColors.Hook = hook

        if _G.Ox.ESPConfig.Master then
            UpdateStaticESP()
        end
    end,
})

local v57 = MapCard:AddCheckbox("Gate ESP", false, function(gate)
    _G.Ox.ESPConfig.Gate = gate

    if _G.Ox.ESPConfig.Master then
        if gate then
            ScanMapESP()
        else
            ClearESP("Gate")
        end
    end
end, {Flag = "GateEsp"})

GateToggle = v57

GateToggle:AddColorPicker(_G.Ox.ESPColors.Gate, {
    Flag = "Gate_Color",
    Title = "Warna Gate",
    Callback = function(gate)
        _G.Ox.ESPColors.Gate = gate

        if _G.Ox.ESPConfig.Master then
            UpdateStaticESP()
        end
    end,
})

local v58 = MapCard:AddCheckbox("SCP ESP", false, function(scp)
    _G.Ox.ESPConfig.SCP = scp

    if _G.Ox.ESPConfig.Master then
        if scp then
            ScanMapESP()
        else
            ClearESP("SCP")
        end
    end
end, {Flag = "EspScp"})

SCPToggle = v58

SCPToggle:AddColorPicker(_G.Ox.ESPColors.SCP, {
    Flag = "ScpEsp_Color",
    Title = "Warna SCP",
    Callback = function(scp)
        _G.Ox.ESPColors.SCP = scp

        if _G.Ox.ESPConfig.Master then
            UpdateSCPESP()
        end
    end,
})

MapCard:AddButton("Refresh Map", function()
    ForceRefreshMap()
    lib:Notify({Title = "Map", Description = "Refreshed!", Duration = 2})
end)

local Information = EspPage:CreateSection("Information", "info")
NextKillerCard = Information

local v59 = NextKillerCard:AddToggle("Next Killer Display", false, function(arg)
    fn19(arg)
end, {Flag = "NextKillerDisplay"})

NextKillerToggle = v59

local v60 = NextKillerCard:AddToggle("Next Map Prediction", false, function(arg)
    fn20(arg)
end, {Flag = "NextMapPredict"})

MapPredictToggle = v60

local v61 = NextKillerCard:AddToggle("Killer Perks Display", false, function(arg)
    fn21(arg)
end, {Flag = "KillerPerkDisplay"})

KillerPerksToggle = v61

local v62 = NextKillerCard:AddToggle("Killer Stun Indicator", false, function(arg)
    fn22(arg)
end, {Flag = "KillerStunIndicator"})

StunToggle = v62

local v63 = NextKillerCard:AddToggle("Spectator info", false, function(arg)
    fn4(arg)
end, {Flag = "SpectatorInfo"})

SpectatorToggle = v63
local Teleport = v:CreateTab("Teleport", false, false)
TeleportTab = Teleport
local Teleport2 = TeleportTab:CreatePage("Teleport")
T_Page = Teleport2
local v64 = T_Page:CreateSection("Teleport Map", "map")
TeleportMapCard = v64

TeleportMapCard:AddButton("Refresh Map Cache", function()
    fn2()
    _G.Ox.Teleport.GenIndex = 1
    _G.Ox.Teleport.HookIndex = 1
    _G.Ox.Teleport.GateIndex = 1
    _G.Ox.Teleport.PalletIndex = 1
    _G.Ox.Teleport.WindowIndex = 1

    lib:Notify({
        Title = "Refresh",
        Description = "Cache map di-refresh!",
        Duration = 2,
    })
end)

TeleportMapCard:AddButton("Teleport ke Generator", function()
    if #tbl.Generators == 0 then
        fn2()
    end

    if #tbl.Generators < _G.Ox.Teleport.GenIndex then
        _G.Ox.Teleport.GenIndex = 1
    end

    local v65 = tbl.Generators[_G.Ox.Teleport.GenIndex]

    if v65 and v65.part then
        fn3(v65.part)

        lib:Notify({
            Title = "TP Generator",
            Description = "Generator " .. _G.Ox.Teleport.GenIndex,
            Duration = 1.2,
        })
    else
        lib:Notify({
            Title = "TP Generator",
            Description = "Generator tidak ditemukan!",
            Duration = 2,
        })
    end

    _G.Ox.Teleport.GenIndex = _G.Ox.Teleport.GenIndex + 1
end)

TeleportMapCard:AddButton("Teleport ke Hook", function()
    if #tbl.Hooks == 0 then
        fn2()
    end

    if #tbl.Hooks < _G.Ox.Teleport.HookIndex then
        _G.Ox.Teleport.HookIndex = 1
    end

    local v65 = tbl.Hooks[_G.Ox.Teleport.HookIndex]
    local basePart = v65

    if v65 then
        local hookPoint = v65:FindFirstChild("HookPoint")
        basePart = hookPoint or v65:FindFirstChildWhichIsA("BasePart")
    end

    if basePart then
        fn3(basePart)

        lib:Notify({
            Title = "TP Hook",
            Description = "Hook " .. _G.Ox.Teleport.HookIndex,
            Duration = 1.2,
        })
    end

    _G.Ox.Teleport.HookIndex = _G.Ox.Teleport.HookIndex + 1
end)

TeleportMapCard:AddButton("Teleport ke Gate", function()
    if #tbl.Gates == 0 then
        fn2()
    end

    if #tbl.Gates < _G.Ox.Teleport.GateIndex then
        _G.Ox.Teleport.GateIndex = 1
    end

    local v65 = tbl.Gates[_G.Ox.Teleport.GateIndex]
    local basePart = v65 and v65:FindFirstChildWhichIsA("BasePart")

    if basePart then
        fn3(basePart)

        lib:Notify({
            Title = "TP Gate",
            Description = "Gate " .. _G.Ox.Teleport.GateIndex,
            Duration = 1.2,
        })
    end

    _G.Ox.Teleport.GateIndex = _G.Ox.Teleport.GateIndex + 1
end)

TeleportMapCard:AddButton("Teleport ke Pallet", function()
    if #tbl.Pallets == 0 then
        fn2()
    end

    if #tbl.Pallets < _G.Ox.Teleport.PalletIndex then
        _G.Ox.Teleport.PalletIndex = 1
    end

    local v65 = tbl.Pallets[_G.Ox.Teleport.PalletIndex]
    local basePart = v65

    if v65 then
        local primaryPartPallet = v65:FindFirstChild("PrimaryPartPallet")
        basePart = primaryPartPallet or v65:FindFirstChildWhichIsA("BasePart")
    end

    if basePart then
        fn3(basePart)

        lib:Notify({
            Title = "TP Pallet",
            Description = "Pallet " .. _G.Ox.Teleport.PalletIndex,
            Duration = 1.2,
        })
    end

    _G.Ox.Teleport.PalletIndex = _G.Ox.Teleport.PalletIndex + 1
end)

TeleportMapCard:AddButton("Teleport ke Window", function()
    if #tbl.Windows == 0 then
        fn2()
    end

    if #tbl.Windows < _G.Ox.Teleport.WindowIndex then
        _G.Ox.Teleport.WindowIndex = 1
    end

    local v65 = tbl.Windows[_G.Ox.Teleport.WindowIndex]
    local basePart = v65

    if v65 then
        local bottom = v65:FindFirstChild("Bottom")
        basePart = bottom or v65:FindFirstChildWhichIsA("BasePart")
    end

    if basePart then
        fn3(basePart)

        lib:Notify({
            Title = "TP Window",
            Description = "Window " .. _G.Ox.Teleport.WindowIndex,
            Duration = 1.2,
        })
    end

    _G.Ox.Teleport.WindowIndex = _G.Ox.Teleport.WindowIndex + 1
end)

local v65 = T_Page:CreateSection("Teleport Player", "users")
PlayerCard = v65
local v66 = nil
local tbl6 = {}

local function fn23()
    tbl6 = {}

    for k, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            table.insert(tbl6, player.Name)
        end
    end

    table.sort(tbl6)
end

fn23()

local v67 = PlayerCard:AddDropdown("Pilih Player", tbl6, false, function(arg)
    v66 = arg
end)

PlayerDropdown = v67

PlayerCard:AddButton("Refresh Player List", function()
    fn23()

    pcall(function()
        if PlayerDropdown.Refresh then
            PlayerDropdown:Refresh(tbl6)
        elseif PlayerDropdown.SetValues then
            PlayerDropdown:SetValues(tbl6)
        elseif PlayerDropdown.SetOptions then
            PlayerDropdown:SetOptions(tbl6)
        elseif PlayerDropdown.Update then
            PlayerDropdown:Update(tbl6)
        end
    end)

    lib:Notify({
        Title = "Refresh",
        Description = "List player di-refresh! (" .. #tbl6 .. " player)",
        Duration = 2,
    })
end)

Players.PlayerAdded:Connect(function()
    task.wait(0.3)
    fn23()

    pcall(function()
        if PlayerDropdown.Refresh then
            PlayerDropdown:Refresh(tbl6)
        end
    end)
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    fn23()

    pcall(function()
        if PlayerDropdown.Refresh then
            PlayerDropdown:Refresh(tbl6)
        end
    end)
end)

PlayerCard:AddButton("Teleport ke Player", function()
    if v66 and v66 ~= "" then
        local v68 = Players:FindFirstChild(v66)

        if v68 and v68.Character and v68.Character:FindFirstChild("HumanoidRootPart") then
            local character = localPlayer.Character

            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = v68.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)

                lib:Notify({
                    Title = "Teleport",
                    Description = "Ke " .. v66,
                    Duration = 2,
                })
            end
        else
            lib:Notify({
                Title = "Error",
                Description = "Target tidak valid!",
                Duration = 2,
            })
        end

        return
    end

    lib:Notify({
        Title = "Error",
        Description = "Pilih pemain terlebih dulu!",
        Duration = 3,
    })
end)

local Settings = v:CreateTab("Settings", false, false)
SettingsTab = Settings
local Settings2 = SettingsTab:CreatePage("Settings")
S_Page1 = Settings2
local v68 = S_Page1:CreateSection("UI Config", "sliders-vertical")
AppearanceCard = v68

AppearanceCard:AddKeybind("Menu Keybind", "RightShift", function(arg)
    v:SetMenuKey(arg)
end, {Flag = "MenuKeybing"})

AppearanceCard:AddToggle("Transparency Toggle", false, function(arg)
    local setTransparency = v.SetTransparency
    local n = arg and 0.2 or 0
    setTransparency(v, n)
end, {Flag = "ToggleTransparancy"})

AppearanceCard:AddToggle("Lock GUI", false, function(arg)
    v:SetLocked(arg)
end, {Flag = "LockGui"})

AppearanceCard:AddToggle("Watermark", true, function(arg)
    lib:SetWatermark({Enabled = arg})
end, {Flag = "Watermark"})

local Config = S_Page1:CreateSection("Config", "sliders-vertical")
SavesCard = Config
SavesCard:AddConfigManager("OxioHub/Configs")

task.spawn(function()
    task.wait(2)
    fn2()
end)

localPlayer.CharacterAdded:Connect(function()
    _G.Ox.State.busy = false
    _G.Ox.State.RandomMode_IsNormal = false

    if _G.Ox.Auto.SkillCheck then
        task.wait(1)
        fn7()
    end
end)

localPlayer.CharacterAdded:Connect(function()
    task.wait(1.5)

    if _G.Ox.NoSlowdownEnabled then
        local character = localPlayer.Character

        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton2 and _G.Ox.Config.Surv_Aimbot_Enabled and GetRole() == "Survivor" then
        _G.Ox.isAimbotHolding = true
        _G.Ox.lockedAimbotTarget = getBestAimbotTarget()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        _G.Ox.isAimbotHolding = false
        _G.Ox.lockedAimbotTarget = nil

        if _G.Ox.survivorAimbotHighlight then
            _G.Ox.survivorAimbotHighlight.Parent = nil
        end
    end
end)

task.spawn(function()
    while _G.Ox.ScriptAlive do
        task.wait(1)
        if not _G.Ox.ScriptAlive then
            break
        end

        if _G.Ox.Config.Surv_Aimbot_Enabled and GetRole() == "Survivor" and UserInputService.TouchEnabled then
            local playerGui2 = localPlayer:FindFirstChild("PlayerGui")

            if playerGui2 then
                local survivorMob = playerGui2:FindFirstChild("Survivor-mob")

                if survivorMob then
                    local controls = survivorMob:FindFirstChild("Controls")

                    if controls then
                        local attack = controls:FindFirstChild("attack")
                        local guiMob = attack or controls:FindFirstChild("Gui-mob")

                        if guiMob and guiMob.Visible then
                            if not _G.Ox.isAimbotHolding then
                                _G.Ox.isAimbotHolding = true
                                _G.Ox.lockedAimbotTarget = getBestAimbotTarget()
                            end
                        elseif _G.Ox.isAimbotHolding then
                            _G.Ox.isAimbotHolding = false
                            _G.Ox.lockedAimbotTarget = nil

                            if _G.Ox.survivorAimbotHighlight then
                                _G.Ox.survivorAimbotHighlight.Parent = nil
                            end
                        end
                    end
                end
            end
        elseif _G.Ox.isAimbotHolding and UserInputService.TouchEnabled then
            _G.Ox.isAimbotHolding = false
            _G.Ox.lockedAimbotTarget = nil

            if _G.Ox.survivorAimbotHighlight then
                _G.Ox.survivorAimbotHighlight.Parent = nil
            end
        end
    end
end)

local v69 = nil

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    local flag2 = input.UserInputType == Enum.UserInputType.Touch
    local v70 = GetRole()

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if gameProcessed then
            return
        end

        if v70 == "Killer" and _G.Ox.Config.Killer_Aimbot_Enabled then
            _G.Ox.lockedKillerAimbotTarget = getBestKillerAimbotTarget()

            if _G.Ox.lockedKillerAimbotTarget then
                _G.Ox.isKillerAimbotHolding = true
            end
        end
    end

    if flag2 and v70 == "Killer" and _G.Ox.Config.Killer_Aimbot_Enabled then
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        local v71 = nil

        if playerGui2 then
            for k, child in pairs(playerGui2:GetChildren()) do
                if string.sub(child.Name, -4) == "-mob" and child.Name ~= "Survivor-mob" then
                    v71 = child
                    break
                end
            end
        end

        local attack = v71 and v71:FindFirstChild("Controls") and v71.Controls:FindFirstChild("attack")

        if attack and attack.Visible then
            local position = input.Position
            local absolutePosition = attack.AbsolutePosition
            local absoluteSize = attack.AbsoluteSize

            if absolutePosition.X <= position.X and position.X <= absolutePosition.X + absoluteSize.X and absolutePosition.Y <= position.Y and position.Y <= absolutePosition.Y + absoluteSize.Y then
                _G.Ox.lockedKillerAimbotTarget = getBestKillerAimbotTarget()

                if _G.Ox.lockedKillerAimbotTarget then
                    _G.Ox.isKillerAimbotHolding = true
                    v69 = input
                end
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        _G.Ox.isKillerAimbotHolding = false
        _G.Ox.lockedKillerAimbotTarget = nil

        if _G.Ox.killerAimbotHighlight then
            _G.Ox.killerAimbotHighlight.Parent = nil
        end
    end

    if input.UserInputType == Enum.UserInputType.Touch and input == v69 then
        _G.Ox.isKillerAimbotHolding = false
        _G.Ox.lockedKillerAimbotTarget = nil
        v69 = nil

        if _G.Ox.killerAimbotHighlight then
            _G.Ox.killerAimbotHighlight.Parent = nil
        end
    end
end)

localPlayer.CharacterAdded:Connect(function()
    task.wait(1.5)
    ReapplyPerformanceDelayed()
end)

workspace.ChildAdded:Connect(function(child)
    if child.Name == "Map" then
        task.wait(1)
        ReapplyPerformanceDelayed()
    end
end)

task.spawn(function()
    task.wait(2)
    ReapplyPerformanceDelayed()
end)

do
    local UIS = game:GetService("UserInputService")
    local RSvc = game:GetService("ReplicatedStorage")
    local PlayersSvc = game:GetService("Players")
    local LP = PlayersSvc.LocalPlayer

    _G.Ox.Fake = _G.Ox.Fake or {}
    local FA = _G.Ox.Fake
    FA.SurvFakeParry = FA.SurvFakeParry or false
    FA.SurvFakeParryAnim = FA.SurvFakeParryAnim or "Enten"
    FA.SurvFakeGen = FA.SurvFakeGen or false
    FA.KillerFakeAttack = FA.KillerFakeAttack or false
    FA.KillerInfFrenzy = FA.KillerInfFrenzy or false
    FA.KillerInfGrab = FA.KillerInfGrab or false

    local function notify(title, desc)
        pcall(function() lib:Notify({ Title = title, Description = desc, Duration = 3 }) end)
    end

    local FakeParryAnimations = {
        ["Enten"]       = "rbxassetid://127096285501517",
        ["Stopwatch"]   = "rbxassetid://81793464499285",
        ["Fih"]         = "rbxassetid://123307242865945",
        ["BloodShield"] = "rbxassetid://75939529748815",
    }
    local FP = { UI = nil, Button = nil, Track = nil, Dragging = false, DragStart = nil, DragStartPos = nil }

    local function playFakeParry()
        if not FA.SurvFakeParry then return end
        pcall(function()
            local char = LP.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if not animator then animator = Instance.new("Animator"); animator.Parent = humanoid end
            if FP.Track then pcall(function() FP.Track:Stop() end); FP.Track = nil end
            local animation = Instance.new("Animation")
            animation.AnimationId = FakeParryAnimations[FA.SurvFakeParryAnim] or FakeParryAnimations["Enten"]
            local track = animator:LoadAnimation(animation)
            track.Priority = Enum.AnimationPriority.Action
            track:Play()
            FP.Track = track
        end)
    end

    local function setupFakeParryBtn()
        pcall(function()
            local old = LP.PlayerGui:FindFirstChild("A2FakeParryUI")
            if old then old:Destroy() end
            local ui = Instance.new("ScreenGui")
            ui.Name = "A2FakeParryUI"
            ui.ResetOnSpawn = false
            ui.IgnoreGuiInset = true
            ui.DisplayOrder = 9999
            ui.Parent = LP:WaitForChild("PlayerGui")
            FP.UI = ui

            local btn = Instance.new("ImageButton")
            btn.Name = "FakeParryButton"
            btn.Size = UDim2.new(0, 60, 0, 60)
            btn.Position = UDim2.new(0.3, 0, 0.75, 0)
            btn.AnchorPoint = Vector2.new(0.5, 0.5)
            btn.BackgroundColor3 = Color3.fromRGB(20, 0, 30)
            btn.BackgroundTransparency = 0.15
            btn.AutoButtonColor = true
            btn.Visible = FA.SurvFakeParry
            btn.ZIndex = 10
            btn.Parent = ui
            Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
            local st = Instance.new("UIStroke", btn)
            st.Color = Color3.fromRGB(150, 70, 255); st.Thickness = 2; st.Transparency = 0.2

            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0.62, 0, 0.62, 0)
            icon.Position = UDim2.new(0.5, 0, 0.34, 0)
            icon.AnchorPoint = Vector2.new(0.5, 0.5)
            icon.BackgroundTransparency = 1
            icon.Image = "rbxassetid://124448418211665"
            icon.ImageColor3 = Color3.fromRGB(210, 170, 255)
            icon.ZIndex = 11
            icon.Parent = btn

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0.34, 0)
            lbl.Position = UDim2.new(0, 0, 0.66, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "FAKE PARRY"
            lbl.TextColor3 = Color3.fromRGB(200, 150, 255)
            lbl.TextScaled = true
            lbl.Font = Enum.Font.GothamBlack
            lbl.ZIndex = 11
            lbl.Parent = btn

            FP.Button = btn

            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    FP.Dragging = true
                    FP.DragStart = input.Position
                    FP.DragStartPos = btn.Position
                end
            end)
            btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    FP.Dragging = false
                end
            end)
            btn.MouseButton1Click:Connect(playFakeParry)
        end)
    end

    local FG = { UI = nil, Button = nil, Track = nil, Dragging = false, DragStart = nil, DragStartPos = nil }

    local function toggleFakeGen()
        if not FA.SurvFakeGen then
            if FG.Track then pcall(function() FG.Track:Stop() end); FG.Track = nil end
            if FG.Button then FG.Button.BackgroundColor3 = Color3.fromRGB(20, 30, 0) end
            return
        end
        if FG.Track then
            pcall(function() FG.Track:Stop() end); FG.Track = nil
            if FG.Button then FG.Button.BackgroundColor3 = Color3.fromRGB(20, 30, 0) end
        else
            pcall(function()
                local char = LP.Character
                if not char then return end
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if not humanoid then return end
                local animator = humanoid:FindFirstChildOfClass("Animator")
                if not animator then animator = Instance.new("Animator"); animator.Parent = humanoid end
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://83160743983246"
                local track = animator:LoadAnimation(animation)
                track.Looped = true
                track.Priority = Enum.AnimationPriority.Action
                track:Play()
                FG.Track = track
                if FG.Button then FG.Button.BackgroundColor3 = Color3.fromRGB(80, 180, 100) end
            end)
        end
    end

    local function setupFakeGenBtn()
        pcall(function()
            local old = LP.PlayerGui:FindFirstChild("A2FakeGenUI")
            if old then old:Destroy() end
            local ui = Instance.new("ScreenGui")
            ui.Name = "A2FakeGenUI"
            ui.ResetOnSpawn = false
            ui.IgnoreGuiInset = true
            ui.DisplayOrder = 9999
            ui.Parent = LP:WaitForChild("PlayerGui")
            FG.UI = ui

            local btn = Instance.new("ImageButton")
            btn.Name = "FakeGenButton"
            btn.Size = UDim2.new(0, 60, 0, 60)
            btn.Position = UDim2.new(0.4, 0, 0.75, 0)
            btn.AnchorPoint = Vector2.new(0.5, 0.5)
            btn.BackgroundColor3 = Color3.fromRGB(20, 30, 0)
            btn.BackgroundTransparency = 0.15
            btn.AutoButtonColor = true
            btn.Visible = FA.SurvFakeGen
            btn.ZIndex = 10
            btn.Parent = ui
            Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
            local st = Instance.new("UIStroke", btn)
            st.Color = Color3.fromRGB(150, 255, 70); st.Thickness = 2; st.Transparency = 0.2

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "FAKE\nGEN"
            lbl.TextColor3 = Color3.fromRGB(200, 255, 150)
            lbl.TextScaled = true
            lbl.Font = Enum.Font.GothamBlack
            lbl.ZIndex = 11
            lbl.Parent = btn

            FG.Button = btn

            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    FG.Dragging = true
                    FG.DragStart = input.Position
                    FG.DragStartPos = btn.Position
                end
            end)
            btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    FG.Dragging = false
                end
            end)
            btn.MouseButton1Click:Connect(toggleFakeGen)
        end)
    end

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if FP.Dragging and FP.Button then
                local d = input.Position - FP.DragStart
                FP.Button.Position = UDim2.new(FP.DragStartPos.X.Scale, FP.DragStartPos.X.Offset + d.X, FP.DragStartPos.Y.Scale, FP.DragStartPos.Y.Offset + d.Y)
            end
            if FG.Dragging and FG.Button then
                local d = input.Position - FG.DragStart
                FG.Button.Position = UDim2.new(FG.DragStartPos.X.Scale, FG.DragStartPos.X.Offset + d.X, FG.DragStartPos.Y.Scale, FG.DragStartPos.Y.Offset + d.Y)
            end
        end
    end)

    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.V then playFakeParry() end
        if input.KeyCode == Enum.KeyCode.B then toggleFakeGen() end
    end)

    setupFakeParryBtn()
    setupFakeGenBtn()
    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        setupFakeParryBtn()
        setupFakeGenBtn()
    end)

    local FakeAttackThread = nil
    local function toggleFakeAttack(enabled)
        if not enabled then
            if FakeAttackThread then pcall(task.cancel, FakeAttackThread); FakeAttackThread = nil end
            return
        end
        if FakeAttackThread then return end
        FakeAttackThread = task.spawn(function()
            while FA.KillerFakeAttack do
                local char = LP.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        local myRoot = char:FindFirstChild("HumanoidRootPart")
                        local near = false
                        if myRoot then
                            for _, p in ipairs(PlayersSvc:GetPlayers()) do
                                if p ~= LP and p.Team and p.Team.Name == "Survivors" then
                                    local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                                    if r and (myRoot.Position - r.Position).Magnitude <= 15 then near = true; break end
                                end
                            end
                        end
                        if near then
                            pcall(function()
                                local bait = Instance.new("Animation")
                                bait.AnimationId = "rbxassetid://117042998468241"
                                local track = animator:LoadAnimation(bait)
                                track:Play()
                                track:AdjustWeight(0)
                                task.wait(0.05)
                                track:Stop()
                            end)
                        end
                    end
                end
                task.wait(0.3)
            end
            FakeAttackThread = nil
        end)
    end

    local JeffConns = {}
    local JeffAutoAimConn = nil
    local JeffSkillActive = false
    local JeffRemotes = nil

    local function enableJeffAutoAim(state)
        if state then
            if JeffAutoAimConn then return end
            JeffAutoAimConn = RunService.Heartbeat:Connect(function()
                pcall(function()
                    local char = LP.Character
                    if not char then return end
                    local myRoot = char:FindFirstChild("HumanoidRootPart")
                    if not myRoot then return end
                    local closest, shortest = nil, 12
                    for _, other in ipairs(PlayersSvc:GetPlayers()) do
                        if other ~= LP and other.Character then
                            local er = other.Character:FindFirstChild("HumanoidRootPart")
                            local eh = other.Character:FindFirstChildOfClass("Humanoid")
                            if er and eh and eh.Health > 0 then
                                local dist = (er.Position - myRoot.Position).Magnitude
                                if dist < shortest then shortest = dist; closest = er end
                            end
                        end
                    end
                    if closest then
                        local tp = Vector3.new(closest.Position.X, myRoot.Position.Y, closest.Position.Z)
                        myRoot.CFrame = CFrame.new(myRoot.Position, tp)
                    end
                end)
            end)
        else
            if JeffAutoAimConn then JeffAutoAimConn:Disconnect(); JeffAutoAimConn = nil end
        end
    end

    local function startJeff()
        for _, c in ipairs(JeffConns) do pcall(function() c:Disconnect() end) end
        JeffConns = {}
        local killerRemotes = RSvc:FindFirstChild("Remotes") and RSvc.Remotes:FindFirstChild("Killers") and RSvc.Remotes.Killers:FindFirstChild("Killer")
        local activatePowerRemote = killerRemotes and killerRemotes:FindFirstChild("ActivatePower")
        local deactivateRemote = killerRemotes and killerRemotes:FindFirstChild("Deactivatefromclient")
        local cooldownEventRemote = killerRemotes and killerRemotes:FindFirstChild("CooldownEvent")
        JeffRemotes = { Activate = activatePowerRemote, Deactivate = deactivateRemote, Cooldown = cooldownEventRemote }

        pcall(function()
            local pg = LP:FindFirstChild("PlayerGui")
            local killerMob = pg and pg:FindFirstChild("Killer-mob")
            local controls = killerMob and killerMob:FindFirstChild("Controls")
            local move1Button = controls and controls:FindFirstChild("move1")
            if move1Button then
                table.insert(JeffConns, move1Button.MouseButton1Click:Connect(function()
                    if not FA.KillerInfFrenzy then return end
                    JeffSkillActive = not JeffSkillActive
                    local char = LP.Character
                    if JeffSkillActive then
                        if char then char:SetAttribute("Frenzy", true) end
                        if activatePowerRemote then pcall(function() activatePowerRemote:FireServer(true) end) end
                        enableJeffAutoAim(true)
                    else
                        if char then char:SetAttribute("Frenzy", false) end
                        if deactivateRemote then pcall(function() deactivateRemote:FireServer() end) end
                        enableJeffAutoAim(false)
                    end
                end))
            end
        end)

        if cooldownEventRemote then
            table.insert(JeffConns, cooldownEventRemote.OnClientEvent:Connect(function()
                if not FA.KillerInfFrenzy then return end
                pcall(function() cooldownEventRemote:FireServer(0) end)
            end))
        end
    end

    local function stopJeff()
        for _, c in ipairs(JeffConns) do pcall(function() c:Disconnect() end) end
        JeffConns = {}
        enableJeffAutoAim(false)
        pcall(function()
            local char = LP.Character
            JeffSkillActive = false
            if char and char:GetAttribute("Frenzy") == true then
                char:SetAttribute("Frenzy", false)
                if JeffRemotes and JeffRemotes.Deactivate then JeffRemotes.Deactivate:FireServer() end
            end
        end)
    end

    local RunService = game:GetService("RunService")
    local HttpService = game:GetService("HttpService")

    local GRAB_FILE = "Myers_Grab_Config.json"
    local GrabState = {
        Enabled      = false,
        Range        = 5,
        StunDuration = 11,
        LoopDelay    = 0.1,
        PlaySlash    = true,
        GrabKey      = "Q",
        ToggleKey    = "F6",
    }

    local function GrabLoad()
        local read = readfile or (syn and syn.readfile)
        local isf  = isfile   or (syn and syn.isfile)
        if read and isf then
            local ok, exists = pcall(isf, GRAB_FILE)
            if ok and exists then
                pcall(function()
                    local d = HttpService:JSONDecode(read(GRAB_FILE))
                    if type(d) == "table" then
                        for k, v in pairs(d) do GrabState[k] = v end
                    end
                end)
            end
        end
    end
    local function GrabSave()
        local write = writefile or (syn and syn.writefile)
        if write then pcall(function()
            write(GRAB_FILE, HttpService:JSONEncode(GrabState))
        end) end
    end
    GrabLoad()
    GrabState.Enabled = false

    local function GrabGetKiller()
        local a = LP:GetAttribute("SelectedKiller")
        if a then return tostring(a):lower() end
        local v = LP:FindFirstChild("SelectedKiller")
        if v and v.Value then return tostring(v.Value):lower() end
        local char = LP.Character
        if char then
            local c = char:GetAttribute("SelectedKiller")
            if c then return tostring(c):lower() end
        end
        return "none"
    end

    local function GrabIsMyers()
        local k = GrabGetKiller()
        return (k:find("stalker") or k:find("myers") or k:find("veil") or k:find("masked")) and true or false
    end

    local function GrabGetRemote()
        local r = RSvc:FindFirstChild("Remotes"); if not r then return nil end
        local k = r:FindFirstChild("Killers");  if not k then return nil end
        local s = k:FindFirstChild("Stalker");  if not s then return nil end
        return s:FindFirstChild("grab")
    end

    local GRAB_ANIM_ID = "rbxassetid://77477445889320"
    local GrabAnimator, GrabAnimTrack

    local function GrabGetAnimator()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return nil end
        return hum:FindFirstChildOfClass("Animator") or hum
    end

    local function GrabPlaySlash()
        local animator = GrabGetAnimator()
        if not animator then return nil end
        if GrabAnimator ~= animator or not GrabAnimTrack then
            GrabAnimator = animator
            local ok, track = pcall(function()
                local a = Instance.new("Animation")
                a.AnimationId = GRAB_ANIM_ID
                return animator:LoadAnimation(a)
            end)
            GrabAnimTrack = (ok and track) or nil
            if GrabAnimTrack then
                GrabAnimTrack.Priority = Enum.AnimationPriority.Action
                GrabAnimTrack.Looped = false
            end
        end
        local track = GrabAnimTrack
        if not track then return nil end
        pcall(function()

            if not track.IsPlaying then
                track:Play(0.1)
            end
        end)
        return track
    end

    local function GrabStopSlash()
        local track = GrabAnimTrack
        if track then
            pcall(function() if track.IsPlaying then track:Stop(0.15) end end)
        end
    end

    task.spawn(function()
        pcall(function()
            local a = Instance.new("Animation")
            a.AnimationId = GRAB_ANIM_ID
            game:GetService("ContentProvider"):PreloadAsync({a})
        end)
    end)

    local function GrabFindTarget()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local target, best = nil, math.huge
        for _, p in ipairs(PlayersSvc:GetPlayers()) do
            if p ~= LP and p.Character then
                local pr = p.Character:FindFirstChild("HumanoidRootPart")
                local ph = p.Character:FindFirstChildOfClass("Humanoid")
                if pr and ph and ph.Health > 0 then
                    local d = (pr.Position - hrp.Position).Magnitude
                    if d < best and d <= GrabState.Range then
                        best = d
                        target = p.Character
                    end
                end
            end
        end
        return target
    end

    local function GrabApplyStun(target)
        if not target then return end
        local stun = GrabState.StunDuration

        pcall(function() target:SetAttribute("StunDuration", stun) end)
        pcall(function() target:SetAttribute("Stun",         stun) end)
        pcall(function() target:SetAttribute("GrabStun",     stun) end)
        pcall(function() target:SetAttribute("stunTime",     stun) end)

        local hum = target:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() hum:SetAttribute("StunDuration", stun) end)
            pcall(function() hum:SetAttribute("Stun",         stun) end)
        end

        local plr = PlayersSvc:GetPlayerFromCharacter(target)
        if plr then
            pcall(function() plr:SetAttribute("StunDuration", stun) end)
            pcall(function() plr:SetAttribute("Stun",         stun) end)
        end
    end

    local GrabBusy = false
    local GrabGeneration = 0
    local function GrabFire()
        if not GrabState.Enabled or not GrabIsMyers() or GrabBusy then return false end
        local grab = GrabGetRemote()
        if not grab then return false end
        local character = LP.Character
        local generation = GrabGeneration
        GrabBusy = true
        task.spawn(function()
            local deadline = tick() + 0.6
            while GrabState.Enabled and generation == GrabGeneration and LP.Character == character and tick() < deadline do
                local target = GrabFindTarget()
                if target then
                    GrabApplyStun(target)
                    pcall(function() grab:FireServer(target) end)
                    break
                end
                task.wait(0.03)
            end
            if generation == GrabGeneration then GrabBusy = false end
        end)
        return true
    end

    local function GrabManual()
        if not GrabState.Enabled or not GrabIsMyers() or GrabBusy then return end
        if GrabState.PlaySlash then pcall(GrabPlaySlash) end
        GrabFire()
    end

    local function GrabToggle(enabled)
        GrabGeneration += 1
        GrabBusy = false
        GrabState.Enabled = enabled == true
        FA.KillerInfGrab = GrabState.Enabled
        if not GrabState.Enabled then GrabStopSlash() end
        GrabSave()
        notify("Infinite Grab", GrabState.Enabled and "ENABLED" or "DISABLED")
    end

    local function GrabKeyCode(name)
        local ok, key = pcall(function() return Enum.KeyCode[name] end)
        return ok and key or nil
    end
    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == GrabKeyCode(GrabState.GrabKey) then
            GrabManual()
        elseif input.KeyCode == GrabKeyCode(GrabState.ToggleKey) then
            GrabToggle(not GrabState.Enabled)
            local ctrl = _G.Ox.Ported and _G.Ox.Ported.GrabToggleCtrl
            if ctrl and ctrl.SetValue then pcall(function() ctrl:SetValue(GrabState.Enabled) end) end
        end
    end)

    local GrabButtons = setmetatable({}, {__mode = "k"})
    local function GrabHook(gui)
        if gui.Name ~= "Slasher-mob" and gui.Name ~= "Slasher-mo" then return end
        local function attach(button)
            if button.Name ~= "move2" or not button:IsA("GuiButton") or GrabButtons[button] then return end
            GrabButtons[button] = button.Activated:Connect(GrabManual)
        end
        for _, descendant in ipairs(gui:GetDescendants()) do attach(descendant) end
        gui.DescendantAdded:Connect(attach)
    end
    local grabPlayerGui = LP:FindFirstChild("PlayerGui")
    if grabPlayerGui then
        for _, gui in ipairs(grabPlayerGui:GetChildren()) do GrabHook(gui) end
        grabPlayerGui.ChildAdded:Connect(GrabHook)
    end
    LP.CharacterAdded:Connect(function()
        GrabGeneration += 1
        GrabBusy = false
        GrabStopSlash()
    end)

    _G.Ox.Ported = _G.Ox.Ported or {}
    _G.Ox.Ported.GrabState  = GrabState
    _G.Ox.Ported.GrabToggle = GrabToggle
    _G.Ox.Ported.GrabFire   = GrabFire
    _G.Ox.Ported.GrabSave   = GrabSave

    _G.Ox.Ported = _G.Ox.Ported or {}
    _G.Ox.Ported.FA = FA
    _G.Ox.Ported.FP = FP
    _G.Ox.Ported.FG = FG
    _G.Ox.Ported.startJeff = startJeff
    _G.Ox.Ported.stopJeff = stopJeff
    _G.Ox.Ported.toggleFakeAttack = toggleFakeAttack
    _G.Ox.Ported.GrabState = GrabState
    _G.Ox.Ported.GrabToggle = GrabToggle
    _G.Ox.Ported.GrabFire = GrabFire
end

do
    local RSvc  = game:GetService("RunService")
    local UISvc = game:GetService("UserInputService")
    local Plrs  = game:GetService("Players")
    local LP    = Plrs.LocalPlayer
    local RS    = game:GetService("ReplicatedStorage")
    local WS    = workspace

    local function notify(title, desc)
        pcall(function() lib:Notify({ Title = title, Description = desc, Duration = 2 }) end)
    end

    _G.Ox.Move = _G.Ox.Move or {
        Speed = false, SpeedValue = 16,
        Jump = false, JumpValue = 50,
        InfiniteJump = false, Noclip = false, AntiAFK = false,
        AntiKnock = false, ShiftLock = false, AntiFallDamage = false,
    }
    local MV = _G.Ox.Move

    local originalCanCollide = {}
    RSvc.Stepped:Connect(function()
        if not MV.Noclip then return end
        local char = LP.Character
        if not char then return end
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") then
                if originalCanCollide[d] == nil then originalCanCollide[d] = d.CanCollide end
                d.CanCollide = false
            end
        end
    end)
    local function disableNoclip()
        for part, cc in pairs(originalCanCollide) do
            if part and part.Parent then pcall(function() part.CanCollide = cc end) end
        end
        originalCanCollide = {}
    end
    LP.CharacterRemoving:Connect(function(c) if c == LP.Character then originalCanCollide = {} end end)

    RSvc.Heartbeat:Connect(function()
        if not MV.Speed and not MV.Jump then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if MV.Speed and hum.WalkSpeed ~= MV.SpeedValue then hum.WalkSpeed = MV.SpeedValue end
        if MV.Jump and hum.JumpPower ~= MV.JumpValue then hum.JumpPower = MV.JumpValue end
    end)

    UISvc.JumpRequest:Connect(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if MV.InfiniteJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)

    do
        local vu = game:GetService("VirtualUser")
        LP.Idled:Connect(function()
            if not MV.AntiAFK then return end
            pcall(function()
                vu:Button2Down(Vector2.new(0, 0), WS.CurrentCamera.CFrame)
                task.wait(0.2)
                vu:Button2Up(Vector2.new(0, 0), WS.CurrentCamera.CFrame)
            end)
        end)
    end

    local function isStatusActive(v) return v == true or (type(v) == "number" and v > 0) end
    local function getGameValue(obj, name)
        if typeof(obj) ~= "Instance" then return nil end
        local a = obj:GetAttribute(name)
        if a ~= nil then return a end
        local c = obj:FindFirstChild(name)
        if c and c:IsA("ValueBase") then return c.Value end
        return nil
    end
    local lastAntiKnock = 0
    RSvc.Heartbeat:Connect(function()
        if not MV.AntiKnock then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum then return end
        local isKnocked = isStatusActive(getGameValue(char, "Knocked")) or isStatusActive(getGameValue(char, "IsKnocked"))
        local isCarried = isStatusActive(getGameValue(char, "Carried")) or isStatusActive(getGameValue(char, "IsCarried")) or isStatusActive(getGameValue(char, "Grabbed"))
        if not isKnocked and not isCarried then return end
        local now = tick()
        if now - lastAntiKnock < 0.3 then return end
        lastAntiKnock = now
        for _, flag in ipairs({ "Knocked", "IsKnocked", "Carried", "IsCarried", "Grabbed", "Ragdolled", "Captured", "Disabled" }) do
            pcall(function()
                if char:GetAttribute(flag) ~= nil then char:SetAttribute(flag, false) end
                local obj = char:FindFirstChild(flag)
                if obj and obj:IsA("BoolValue") then obj.Value = false
                elseif obj and (obj:IsA("NumberValue") or obj:IsA("IntValue")) then obj.Value = 0 end
            end)
        end
        pcall(function()
            hum.PlatformStand = false
            hum.Sit = false
            hum.AutoRotate = true
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.PlatformStanding then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            if root then root.AssemblyLinearVelocity = Vector3.zero end
            task.defer(function()
                pcall(function()
                    hum.Health = hum.MaxHealth
                    hum.WalkSpeed = math.max(hum.WalkSpeed, 16)
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end)
        end)
    end)

    local shiftLockWasActive = false
    RSvc.RenderStepped:Connect(function()
        if not MV.ShiftLock and not shiftLockWasActive then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local cam = WS.CurrentCamera
        if MV.ShiftLock then
            if not char or not root or not cam then return end
            if hum then hum.AutoRotate = false end
            shiftLockWasActive = true
            local flat = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
            if flat.Magnitude > 0.001 then
                root.CFrame = CFrame.new(root.Position, root.Position + flat.Unit)
            end
        elseif shiftLockWasActive then
            if hum then hum.AutoRotate = true end
            shiftLockWasActive = false
        end
    end)

    if MovementCard then
        MovementCard:AddToggle("Speed Hack", false, function(v)
            MV.Speed = v
            if not v then
                local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.WalkSpeed = 16 end) end
            end
            notify("Speed Hack", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "MoveSpeedHack" })

        MovementCard:AddSlider("Speed Value", 16, 200, 16, function(v)
            MV.SpeedValue = v
        end, { Increment = 1, Flag = "MoveSpeedValue" })

        MovementCard:AddToggle("Jump Hack", false, function(v)
            MV.Jump = v
            if not v then
                local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.JumpPower = 0 end) end
            end
            notify("Jump Hack", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "MoveJumpHack" })

        MovementCard:AddSlider("Jump Power", 50, 300, 50, function(v)
            MV.JumpValue = v
        end, { Increment = 1, Flag = "MoveJumpValue" })

        MovementCard:AddToggle("Infinite Jump", false, function(v)
            MV.InfiniteJump = v
            notify("Infinite Jump", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "MoveInfiniteJump" })

        MovementCard:AddToggle("Noclip", false, function(v)
            MV.Noclip = v
            if not v then pcall(disableNoclip) end
            notify("Noclip", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "MoveNoclip" })

        MovementCard:AddToggle("Anti AFK", false, function(v)
            MV.AntiAFK = v
            notify("Anti AFK", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "MoveAntiAFK" })

        MovementCard:AddToggle("Anti Fall Damage", false, function(v)
            MV.AntiFallDamage = v
            notify("Anti Fall Damage", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "MoveAntiFallDamage" })

        MovementCard:AddToggle("Shift Lock (auto face camera)", false, function(v)
            MV.ShiftLock = v
            notify("Shift Lock", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "MoveShiftLock" })
    end

    _G.Ox.Util = _G.Ox.Util or {
        CustomMasked = "Richard",
        SelectedEmote = "Friday Night",
        EmoteEnabled = false,
        NoCutscene = false,
        WeatherTheme = "Default",
    }
    local UT = _G.Ox.Util

    local spoofLevel, spoofGears, spoofScrews = "0", "0", "0"

    local customMaskedMasks = { "Richard", "Tony", "Brandon", "Jake", "Richter", "Graham", "Alex" }
    local function applyCustomMasked(maskName)
        local sel = maskName or UT.CustomMasked or "Richard"
        if type(sel) == "table" then sel = sel[1] end
        if type(sel) ~= "string" or sel == "" then sel = "Richard" end
        local remotes = RS:FindFirstChild("Remotes")
        local killers = remotes and remotes:FindFirstChild("Killers")
        local masked = killers and killers:FindFirstChild("Masked")
        local ap = masked and masked:FindFirstChild("Activatepower")
        if ap and ap:IsA("RemoteEvent") then
            ap:FireServer(sel)
            return true
        end
        return false
    end

    local SelectedAnim = "rbxassetid://83229063951016"
    local SelectedSound = "rbxassetid://85355610204255"
    local currentTrack, currentSound = nil, nil
    local EmoteOptions = {
        "Friday Night", "WarCry", "24 Hour Cinderella", "Applause", "Arm Swing",
        "Backflip", "California Girls", "Christmas Spirit", "Floating Rest",
        "Ghoul", "Griddy", "Kyoufuu", "OnePlays", "Vulnerable",
    }
    local function selectEmoteData(value)
        if value == "Friday Night" then
            SelectedAnim = "rbxassetid://83229063951016"; SelectedSound = "rbxassetid://85355610204255"
        elseif value == "WarCry" then
            SelectedAnim = "rbxassetid://82600868380136"; SelectedSound = "rbxassetid://120101930689931"
        elseif value == "24 Hour Cinderella" then
            SelectedAnim = "rbxassetid://137195203725366"; SelectedSound = "rbxassetid://121099446613414"
        elseif value == "Applause" then
            SelectedAnim = "rbxassetid://96328361165090"; SelectedSound = "rbxassetid://115490787020749"
        elseif value == "Arm Swing" then
            SelectedAnim = "rbxassetid://80552139463944"; SelectedSound = "rbxassetid://74216458932348"
        elseif value == "Backflip" then
            SelectedAnim = "rbxassetid://74705617908505"; SelectedSound = nil
        elseif value == "California Girls" then
            SelectedAnim = "rbxassetid://123552803041504"; SelectedSound = "rbxassetid://87899327891544"
        elseif value == "Christmas Spirit" then
            SelectedAnim = "rbxassetid://137859761110514"; SelectedSound = nil
        elseif value == "Floating Rest" then
            SelectedAnim = "rbxassetid://114593021219597"; SelectedSound = nil
        elseif value == "Ghoul" then
            SelectedAnim = "rbxassetid://130415594909401"; SelectedSound = "rbxassetid://123004139176580"
        elseif value == "Griddy" then
            SelectedAnim = "rbxassetid://75586690784894"; SelectedSound = nil
        elseif value == "Kyoufuu" then
            SelectedAnim = "rbxassetid://137322894494527"; SelectedSound = "rbxassetid://129064643026442"
        elseif value == "OnePlays" then
            SelectedAnim = "rbxassetid://140625405103474"; SelectedSound = "rbxassetid://94749073728335"
        elseif value == "Vulnerable" then
            SelectedAnim = "rbxassetid://121773684313913"; SelectedSound = "rbxassetid://135265751184744"
        end
    end
    local function playEmote()
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if currentTrack then pcall(function() currentTrack:Stop() end); currentTrack = nil end
        if currentSound then pcall(function() currentSound:Destroy() end); currentSound = nil end
        if SelectedAnim then
            pcall(function()
                local anim = Instance.new("Animation")
                anim.AnimationId = SelectedAnim
                local animator = hum:FindFirstChildOfClass("Animator")
                if not animator then animator = hum:WaitForChild("Animator", 2) end
                if not animator then animator = Instance.new("Animator"); animator.Parent = hum end
                local track
                if animator then track = animator:LoadAnimation(anim) else track = hum:LoadAnimation(anim) end
                if track then
                    track.Priority = Enum.AnimationPriority.Action
                    track.Looped = true
                    track:Play()
                    currentTrack = track
                end
            end)
        end
        if SelectedSound then
            pcall(function()
                currentSound = Instance.new("Sound")
                currentSound.SoundId = SelectedSound
                currentSound.Looped = true
                currentSound.Volume = 2
                currentSound.Parent = hrp
                currentSound:Play()
            end)
        end
    end
    local function stopEmote()
        if currentTrack then pcall(function() currentTrack:Stop() end); currentTrack = nil end
        if currentSound then pcall(function() currentSound:Destroy() end); currentSound = nil end
    end

    local Lighting = game:GetService("Lighting")
    local originalLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        GlobalShadows = Lighting.GlobalShadows,
        OutdoorAmbient = Lighting.OutdoorAmbient,
    }
    local weatherPresets = {
        ["Default"] = {},
        ["Christmas (Snow)"] = {
            Lighting = { FogColor = Color3.fromRGB(150, 180, 220), FogEnd = 200, ClockTime = 8, OutdoorAmbient = Color3.fromRGB(100, 120, 150) },
            Atmosphere = { Density = 0.5, Color = Color3.fromRGB(180, 200, 220), Decay = Color3.fromRGB(150, 180, 220), Haze = 5, Glare = 0 },
            Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)), Size = NumberSequence.new(1.5), Rate = 150, Speed = NumberRange.new(15, 25), Lifetime = NumberRange.new(4, 6), EmissionDirection = Enum.NormalId.Bottom, RotSpeed = NumberRange.new(-45, 45) }
        },
        ["Heavy Rain (Storm)"] = {
            Lighting = { FogColor = Color3.fromRGB(50, 50, 60), FogEnd = 150, OutdoorAmbient = Color3.fromRGB(40, 40, 50), Brightness = 0.2, ClockTime = 12 },
            CC = { TintColor = Color3.fromRGB(150, 150, 180), Contrast = 0.2, Saturation = -0.5 },
            Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", AnchorSize = Vector3.new(260, 1, 260), CameraOffset = Vector3.new(0, 38, -18), Squash = NumberSequence.new(16), Color = ColorSequence.new(Color3.fromRGB(235, 245, 255)), Size = NumberSequence.new(1.25), Rate = 2600, Speed = NumberRange.new(110, 145), Lifetime = NumberRange.new(0.85, 1.25), EmissionDirection = Enum.NormalId.Bottom, Transparency = NumberSequence.new(0), Acceleration = Vector3.new(-18, -75, 0), SpreadAngle = Vector2.new(3, 3), LightEmission = 1 }
        },
        ["Autumn (Musim Gugur)"] = {
            Lighting = { FogColor = Color3.fromRGB(200, 150, 80), FogEnd = 500, OutdoorAmbient = Color3.fromRGB(180, 140, 70), ClockTime = 16.5 },
            CC = { TintColor = Color3.fromRGB(255, 220, 180), Contrast = 0.1, Saturation = 0.2 },
            Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", AnchorSize = Vector3.new(210, 1, 210), CameraOffset = Vector3.new(0, 28, -16), Squash = NumberSequence.new(3.2), Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 45)), ColorSequenceKeypoint.new(0.45, Color3.fromRGB(235, 95, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 45, 10)) }), Size = NumberSequence.new(2.05), Rate = 360, Speed = NumberRange.new(8, 15), Lifetime = NumberRange.new(6, 10), EmissionDirection = Enum.NormalId.Bottom, Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-220, 220), Transparency = NumberSequence.new(0), Acceleration = Vector3.new(18, -8, 6), SpreadAngle = Vector2.new(38, 38), LightEmission = 0.6 }
        },
        ["Cherry Blossom (Sakura)"] = {
            Lighting = { FogColor = Color3.fromRGB(255, 200, 220), FogEnd = 600, OutdoorAmbient = Color3.fromRGB(255, 180, 200), ClockTime = 9 },
            CC = { TintColor = Color3.fromRGB(255, 230, 240), Saturation = 0.3 },
            Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", AnchorSize = Vector3.new(160, 1, 160), CameraOffset = Vector3.new(0, 25, -18), Squash = NumberSequence.new(1.2), Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 235)), ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 165, 205)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 180)) }), Size = NumberSequence.new(1.25), Rate = 190, Speed = NumberRange.new(5, 10), Lifetime = NumberRange.new(7, 10), EmissionDirection = Enum.NormalId.Bottom, Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-170, 170), Transparency = NumberSequence.new(0), Acceleration = Vector3.new(14, -5, 5), SpreadAngle = Vector2.new(32, 32), LightEmission = 0.55 }
        },
        ["Sunset (Golden Hour)"] = {
            Lighting = { FogColor = Color3.fromRGB(255, 120, 50), FogEnd = 1200, OutdoorAmbient = Color3.fromRGB(200, 100, 50), ClockTime = 17.5, Brightness = 1.5 },
            CC = { TintColor = Color3.fromRGB(255, 200, 150), Contrast = 0.2, Saturation = 0.4 }
        },
        ["Blood Moon (Spooky)"] = {
            Lighting = { FogColor = Color3.fromRGB(150, 10, 10), FogEnd = 500, OutdoorAmbient = Color3.fromRGB(80, 0, 0), ClockTime = 0, Brightness = 0.3 },
            CC = { TintColor = Color3.fromRGB(255, 50, 50), Contrast = 0.4, Saturation = 0.5 },
            Atmosphere = { Density = 0.35, Color = Color3.fromRGB(255, 0, 0), Decay = Color3.fromRGB(100, 0, 0), Haze = 5, Glare = 0 }
        },
        ["Toxic Wasteland"] = {
            Lighting = { FogColor = Color3.fromRGB(80, 150, 50), FogEnd = 250, OutdoorAmbient = Color3.fromRGB(50, 120, 40), ClockTime = 12, Brightness = 1 },
            CC = { TintColor = Color3.fromRGB(150, 255, 150), Contrast = 0.1, Saturation = 0.3 },
            Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", Color = ColorSequence.new(Color3.fromRGB(100, 255, 50)), Size = NumberSequence.new(0.8), Rate = 200, Speed = NumberRange.new(50, 60), Lifetime = NumberRange.new(2, 3), EmissionDirection = Enum.NormalId.Bottom, Transparency = NumberSequence.new(0.5) }
        },
        ["Vaporwave (Synthwave)"] = {
            Lighting = { FogColor = Color3.fromRGB(200, 50, 255), FogEnd = 500, OutdoorAmbient = Color3.fromRGB(150, 0, 200), ClockTime = 20, Brightness = 1 },
            CC = { TintColor = Color3.fromRGB(255, 100, 255), Contrast = 0.3, Saturation = 0.5 }
        },
        ["Midnight (Pitch Black)"] = {
            Lighting = { FogColor = Color3.fromRGB(0, 0, 0), FogEnd = 100, OutdoorAmbient = Color3.fromRGB(0, 0, 0), Brightness = 0, ClockTime = 0 },
            CC = { TintColor = Color3.fromRGB(50, 50, 50), Contrast = 0.5, Saturation = -0.8 }
        },
    }
    local weatherAnchor = nil
    local function updateWeatherAnchor()
        local anchor = weatherAnchor
        if not anchor then return end
        if anchor.Parent ~= WS then pcall(function() anchor.Parent = WS end) end
        local camera = WS.CurrentCamera
        if camera then
            local offset = Vector3.new(
                anchor:GetAttribute("VD_CameraOffsetX") or 0,
                anchor:GetAttribute("VD_CameraOffsetY") or 30,
                anchor:GetAttribute("VD_CameraOffsetZ") or 0
            )
            local worldPos = camera.CFrame.Position
                + camera.CFrame.RightVector * offset.X
                + Vector3.new(0, offset.Y, 0)
                + camera.CFrame.LookVector * math.abs(offset.Z)
            anchor.CFrame = CFrame.new(worldPos)
            return
        end
        local char = LP.Character
        if char and char:FindFirstChild("Head") then
            anchor.CFrame = CFrame.new(char.Head.Position + Vector3.new(0, 30, 0))
        end
    end
    local function applyWeather(themeName)
        local theme = weatherPresets[themeName] or weatherPresets["Default"]
        if getgenv().VD_CurrentSky and getgenv().VD_CurrentSky.Parent then getgenv().VD_CurrentSky:Destroy() end
        getgenv().VD_CurrentSky = nil
        if getgenv().VD_WeatherCC and getgenv().VD_WeatherCC.Parent then getgenv().VD_WeatherCC:Destroy() end
        getgenv().VD_WeatherCC = nil
        if getgenv().VD_WeatherAtmosphere and getgenv().VD_WeatherAtmosphere.Parent then getgenv().VD_WeatherAtmosphere:Destroy() end
        getgenv().VD_WeatherAtmosphere = nil
        if theme.Atmosphere then
            local atm = Instance.new("Atmosphere")
            atm.Name = "VD_WeatherAtmosphere"
            for k, v in pairs(theme.Atmosphere) do pcall(function() atm[k] = v end) end
            atm.Parent = Lighting
            getgenv().VD_WeatherAtmosphere = atm
        end
        if theme.CC then
            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "VD_WeatherCC"
            for k, v in pairs(theme.CC) do pcall(function() cc[k] = v end) end
            cc.Parent = Lighting
            getgenv().VD_WeatherCC = cc
        end
        if theme.Lighting then
            for k, v in pairs(theme.Lighting) do pcall(function() Lighting[k] = v end) end
        else
            if not _G.Ox.FullBright and not _G.Ox.NoFog then
                Lighting.Brightness = originalLighting.Brightness
                Lighting.ClockTime = originalLighting.ClockTime
                Lighting.FogEnd = originalLighting.FogEnd
                Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
            end
        end
        if weatherAnchor and weatherAnchor.Parent then weatherAnchor:Destroy() end
        weatherAnchor = nil
        if theme.Particle then
            local anchor = Instance.new("Part")
            anchor.Name = "VD_WeatherAnchor"
            anchor.Transparency = 0.99
            anchor.CanCollide = false
            anchor.Anchored = true
            anchor.Size = theme.Particle.AnchorSize or Vector3.new(120, 1, 120)
            anchor:SetAttribute("VD_CameraOffsetX", theme.Particle.CameraOffset and theme.Particle.CameraOffset.X or 0)
            anchor:SetAttribute("VD_CameraOffsetY", theme.Particle.CameraOffset and theme.Particle.CameraOffset.Y or 30)
            anchor:SetAttribute("VD_CameraOffsetZ", theme.Particle.CameraOffset and theme.Particle.CameraOffset.Z or 0)
            local pe = Instance.new("ParticleEmitter")
            pe.Name = "VD_WeatherEmitter"
            pe.Enabled = true
            pe.EmissionDirection = Enum.NormalId.Bottom
            pe.LockedToPart = false
            pe.ZOffset = 2
            pe.LightEmission = 0.25
            pe.SpreadAngle = Vector2.new(10, 10)
            pcall(function() pe.Shape = Enum.ParticleEmitterShape.Box end)
            pcall(function() pe.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
            for k, v in pairs(theme.Particle) do
                if k ~= "AnchorSize" and k ~= "CameraOffset" then
                    pcall(function() pe[k] = v end)
                end
            end
            pe.Parent = anchor
            if themeName == "Heavy Rain (Storm)" then
                local nearRain = Instance.new("ParticleEmitter")
                nearRain.Name = "VD_WeatherRainNearEmitter"
                nearRain.Enabled = true
                nearRain.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                nearRain.Color = ColorSequence.new(Color3.fromRGB(230, 240, 255))
                nearRain.Transparency = NumberSequence.new(0)
                nearRain.Size = NumberSequence.new(1.65)
                nearRain.Squash = NumberSequence.new(20)
                nearRain.Rate = 1800
                nearRain.Speed = NumberRange.new(70, 95)
                nearRain.Lifetime = NumberRange.new(0.75, 1.05)
                nearRain.EmissionDirection = Enum.NormalId.Bottom
                nearRain.Acceleration = Vector3.new(-24, -90, 0)
                nearRain.SpreadAngle = Vector2.new(2, 2)
                nearRain.LockedToPart = false
                nearRain.ZOffset = 6
                nearRain.LightEmission = 1
                pcall(function() nearRain.Shape = Enum.ParticleEmitterShape.Box end)
                pcall(function() nearRain.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
                nearRain.Parent = anchor
                local rainSheet = Instance.new("ParticleEmitter")
                rainSheet.Name = "VD_WeatherRainSheetEmitter"
                rainSheet.Enabled = true
                rainSheet.Texture = "rbxasset://textures/particles/smoke_main.dds"
                rainSheet.Color = ColorSequence.new(Color3.fromRGB(170, 195, 225))
                rainSheet.Transparency = NumberSequence.new(0.45)
                rainSheet.Size = NumberSequence.new(3.2)
                rainSheet.Squash = NumberSequence.new(7)
                rainSheet.Rate = 650
                rainSheet.Speed = NumberRange.new(45, 65)
                rainSheet.Lifetime = NumberRange.new(1.0, 1.5)
                rainSheet.EmissionDirection = Enum.NormalId.Bottom
                rainSheet.Acceleration = Vector3.new(-14, -55, 0)
                rainSheet.SpreadAngle = Vector2.new(8, 8)
                rainSheet.LockedToPart = false
                rainSheet.ZOffset = 3
                rainSheet.LightEmission = 0.35
                pcall(function() rainSheet.Shape = Enum.ParticleEmitterShape.Box end)
                pcall(function() rainSheet.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
                rainSheet.Parent = anchor
            elseif themeName == "Autumn (Musim Gugur)" then
                local bigLeaves = Instance.new("ParticleEmitter")
                bigLeaves.Name = "VD_WeatherAutumnBigLeavesEmitter"
                bigLeaves.Enabled = true
                bigLeaves.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                bigLeaves.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 205, 55)),
                    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(230, 95, 25)),
                    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(165, 65, 20)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 40, 8)),
                })
                bigLeaves.Transparency = NumberSequence.new(0)
                bigLeaves.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 2.4),
                    NumberSequenceKeypoint.new(0.5, 3.1),
                    NumberSequenceKeypoint.new(1, 1.8),
                })
                bigLeaves.Squash = NumberSequence.new(4.5)
                bigLeaves.Rate = 150
                bigLeaves.Speed = NumberRange.new(5, 10)
                bigLeaves.Lifetime = NumberRange.new(8, 12)
                bigLeaves.EmissionDirection = Enum.NormalId.Bottom
                bigLeaves.Rotation = NumberRange.new(0, 360)
                bigLeaves.RotSpeed = NumberRange.new(-280, 280)
                bigLeaves.Acceleration = Vector3.new(24, -5, 10)
                bigLeaves.SpreadAngle = Vector2.new(45, 45)
                bigLeaves.LockedToPart = false
                bigLeaves.ZOffset = 5
                bigLeaves.LightEmission = 0.65
                pcall(function() bigLeaves.Shape = Enum.ParticleEmitterShape.Box end)
                pcall(function() bigLeaves.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
                bigLeaves.Parent = anchor
            end
            anchor.Parent = WS
            weatherAnchor = anchor
            if theme.Particle.Texture then
                task.spawn(function()
                    pcall(function() game:GetService("ContentProvider"):PreloadAsync({ pe }) end)
                end)
            end
            pcall(updateWeatherAnchor)
        end
    end
    RSvc.RenderStepped:Connect(function()
        if UT.WeatherTheme and UT.WeatherTheme ~= "Default" then pcall(updateWeatherAnchor) end
    end)

    do
        pcall(function()
            if not getrawmetatable or not setreadonly then return end
            local mt = getrawmetatable(game)
            if not mt then return end
            setreadonly(mt, false)
            local oldIndex = mt.__index
            local fakeBindable = Instance.new("BindableEvent")
            local fakeRemote = Instance.new("RemoteEvent")
            mt.__index = newcclosure(function(t, k)
                if (k == "OnClientEvent" or k == "Event") and not checkcaller() and typeof(t) == "Instance" then
                    if UT.NoCutscene then
                        local name = t.Name
                        local parent = t.Parent
                        if parent and parent.Name == "Game" then
                            if name == "cutscene" and k == "Event" then
                                return fakeBindable.Event
                            elseif name == "cutsceneEnd" or name == "cutsceneEnd2" or name == "cutsceneEndwithownchar" or name == "endscreencutscene" then
                                return fakeRemote.OnClientEvent
                            end
                        end
                    end
                end
                return oldIndex(t, k)
            end)
            setreadonly(mt, true)
        end)
        task.spawn(function()
            local remotes = RS:WaitForChild("Remotes", 10)
            local gameFolder = remotes and remotes:WaitForChild("Game", 10)
            if not gameFolder then return end
            local function showInstantResults()
                if not UT.NoCutscene then return end
                pcall(function()
                    local cam = WS.CurrentCamera
                    if cam then
                        cam.CameraType = Enum.CameraType.Custom
                        cam.FieldOfView = 70
                    end
                    UISvc.MouseIconEnabled = true
                    pcall(function() game:GetService("SoundService"):WaitForChild("chase").Volume = 0 end)
                    LP:SetAttribute("isspectating", true)
                    local pg = LP:FindFirstChild("PlayerGui")
                    if pg then
                        local Results = pg:FindFirstChild("Results")
                        local EndScreen = pg:FindFirstChild("EndScreen")
                        local Darkness = pg:FindFirstChild("Darkness")
                        if Results then Results.Enabled = true end
                        if EndScreen then
                            EndScreen.Enabled = true
                            local blackout = EndScreen:FindFirstChild("blackout")
                            if blackout then blackout.BackgroundTransparency = 1 end
                        end
                        if Darkness then
                            Darkness.Enabled = true
                            local frame2 = Darkness:FindFirstChild("Frame2")
                            if frame2 then frame2.BackgroundTransparency = 1 end
                        end
                    end
                end)
            end
            for _, nm in ipairs({ "endscreencutscene", "cutsceneEnd", "cutsceneEnd2", "cutsceneEndwithownchar" }) do
                local ev = gameFolder:WaitForChild(nm, 10)
                if ev then ev.OnClientEvent:Connect(showInstantResults) end
            end
        end)
    end

    local UtilCard = M_Page:CreateSection("Utility", "wrench")

    UtilCard:AddTextbox("Set Level", "0", function(v) spoofLevel = v end, { Flag = "SpoofLevel" })
    UtilCard:AddTextbox("Set Gears", "0", function(v) spoofGears = v end, { Flag = "SpoofGears" })
    UtilCard:AddTextbox("Set Screws", "0", function(v) spoofScrews = v end, { Flag = "SpoofScrews" })
    UtilCard:AddButton("Apply Spoof Data", function()
        local p = LP
        if p then
            p:SetAttribute("Level", tonumber(spoofLevel) or 0)
            p:SetAttribute("Gears", tonumber(spoofGears) or 0)
            p:SetAttribute("Screws", tonumber(spoofScrews) or 0)
            notify("Spoof Data", "Level, Gears, dan Screws diperbarui")
        end
    end, { Icon = "check" })

    UtilCard:AddDropdown("Custom Masked", customMaskedMasks, "Richard", function(v)
        if type(v) == "table" then v = v[1] end
        UT.CustomMasked = v or "Richard"
    end, { Flag = "CustomMasked" })
    UtilCard:AddButton("Apply Custom Masked", function()
        local ok = applyCustomMasked(UT.CustomMasked)
        notify("Custom Masked", ok and ("Terpasang: " .. tostring(UT.CustomMasked)) or "Gagal (bukan Killer / remote tidak ada)")
    end, { Icon = "mask" })
    UtilCard:AddButton("Random Custom Masked", function()
        local mask = customMaskedMasks[math.random(1, #customMaskedMasks)]
        UT.CustomMasked = mask
        local ok = applyCustomMasked(mask)
        notify("Custom Masked", ok and ("Random: " .. tostring(mask)) or "Gagal (bukan Killer / remote tidak ada)")
    end, { Icon = "dice-5" })

    UtilCard:AddTextbox("Custom Masked (Manual)", "", function(v)
        UT.CustomMaskedManual = v
    end, { Flag = "CustomMaskedManual" })
    UtilCard:AddButton("Apply Manual Masked", function()
        local name = tostring(UT.CustomMaskedManual or "")
        if name == "" then notify("Custom Masked", "Isi nama mask dulu (mis. Richard)"); return end
        UT.CustomMasked = name
        local ok = applyCustomMasked(name)
        notify("Custom Masked", ok and ("Terpasang: " .. name) or "Gagal (bukan Killer / remote tidak ada)")
    end, { Icon = "mask" })

    UtilCard:AddToggle("Enable Emote", false, function(v)
        UT.EmoteEnabled = v
        if v then playEmote() else stopEmote() end
        notify("Emote", v and "AKTIF" or "NONAKTIF")
    end, { Flag = "EnableEmote" })
    UtilCard:AddDropdown("Select Emote", EmoteOptions, "Friday Night", function(v)
        if type(v) == "table" then v = v[1] end
        UT.SelectedEmote = v or "Friday Night"
        selectEmoteData(UT.SelectedEmote)
        if UT.EmoteEnabled then playEmote() end
    end, { Flag = "SelectEmote" })
    UtilCard:AddButton("Jerk", function()
        pcall(function()
            loadstring(game:HttpGetAsync("https://pastefy.app/wa3v2Vgm/raw"))()
        end)
    end, { Icon = "laugh" })

    UtilCard:AddToggle("No Cutscene", false, function(v)
        UT.NoCutscene = v
        notify("No Cutscene", v and "AKTIF" or "NONAKTIF")
    end, { Flag = "NoCutscene" })

    UtilCard:AddDropdown("Weather & Sky Theme",
        { "Default", "Christmas (Snow)", "Heavy Rain (Storm)", "Autumn (Musim Gugur)", "Cherry Blossom (Sakura)", "Sunset (Golden Hour)", "Blood Moon (Spooky)", "Toxic Wasteland", "Vaporwave (Synthwave)", "Midnight (Pitch Black)" },
        "Default", function(v)
            if type(v) == "table" then v = v[1] end
            UT.WeatherTheme = v or "Default"
            pcall(applyWeather, UT.WeatherTheme)
            notify("Weather & Sky", tostring(UT.WeatherTheme))
        end, { Flag = "WeatherTheme" })
end

do
    local RSvc = game:GetService("ReplicatedStorage")
    local PlayersSvc = game:GetService("Players")
    local RunSvc = game:GetService("RunService")
    local LP = PlayersSvc.LocalPlayer

    _G.Ox.Inf = _G.Ox.Inf or {}
    local INF = _G.Ox.Inf
    INF.LakeMist = INF.LakeMist or false
    INF.Pursuit  = INF.Pursuit  or false
    INF.Lunge    = INF.Lunge    or false
    INF.Abyss    = INF.Abyss    or false
    INF.Hidden   = INF.Hidden   or false

    local function notify(title, desc)
        pcall(function() lib:Notify({ Title = title, Description = desc, Duration = 3 }) end)
    end

    pcall(function()
        local b = true
        local mt = debug.getmetatable(b)
        if not mt then mt = {}; debug.setmetatable(b, mt) end
        if setreadonly then setreadonly(mt, false) end
        mt.__div = function() return 0 end
        mt.__mul = function() return 0 end
        mt.__add = function() return 0 end
        mt.__sub = function() return 0 end
        if setreadonly then setreadonly(mt, true) end
    end)

    local SlasherThread = nil
    local function startSlasher()
        if SlasherThread then return end
        SlasherThread = task.spawn(function()
            local toggleFunc, pursuitHandler
            local function scan()
                pcall(function()
                    for _, fn in pairs(getgc(true)) do
                        if type(fn) == "function" and islclosure(fn) then
                            local consts = debug.getconstants(fn)
                            local hasOffset, hasLinear, hasAction, hasTweenInfo = false, false, false, false
                            local hasPursuit, hasWalkSpeed = false, false
                            for _, c in pairs(consts) do
                                if c == "Offset" then hasOffset = true
                                elseif c == "Linear" then hasLinear = true
                                elseif c == "action" then hasAction = true
                                elseif c == "TweenInfo" then hasTweenInfo = true
                                elseif c == "Pursuit" then hasPursuit = true
                                elseif c == "WalkSpeed" then hasWalkSpeed = true end
                            end
                            if hasOffset and hasLinear and hasAction and hasTweenInfo and not hasPursuit then toggleFunc = fn end
                            if hasPursuit and hasTweenInfo and hasAction and hasWalkSpeed then pursuitHandler = fn end
                        end
                        if toggleFunc and pursuitHandler then break end
                    end
                end)
            end
            scan()
            local lastScan = os.clock()
            while task.wait(0.1) do
                if not INF.LakeMist and not INF.Pursuit then break end
                if not (toggleFunc and pursuitHandler) then
                    if os.clock() - lastScan >= 2 then scan(); lastScan = os.clock() end
                end
                if toggleFunc and INF.LakeMist then
                    pcall(function()
                        debug.setupvalue(toggleFunc, 6, false)
                        debug.setupvalue(toggleFunc, 10, false)
                    end)
                end
                if pursuitHandler and INF.Pursuit then
                    pcall(function()
                        debug.setupvalue(pursuitHandler, 5, false)
                        debug.setupvalue(pursuitHandler, 6, false)
                    end)
                end
            end
            SlasherThread = nil
        end)
    end
    local function stopSlasher()
        pcall(function()
            local remotes = RSvc:FindFirstChild("Remotes")
            local killers = remotes and remotes:FindFirstChild("Killers")
            local jason = killers and killers:FindFirstChild("Jason")
            if jason then
                if not INF.LakeMist then
                    local lm = jason:FindFirstChild("LakeMist"); if lm then lm:FireServer(false) end
                end
                if not INF.Pursuit then
                    local ps = jason:FindFirstChild("Pursuit"); if ps then ps:FireServer(false) end
                end
            end
        end)
    end

    local LungeOrig, LungeConn = nil, nil
    local function updateLunge()
        local char = LP.Character
        if not char then return end
        if INF.Lunge then
            if char:GetAttribute("lungeboost") ~= 999999 then
                LungeOrig = char:GetAttribute("lungeboost") or 1
                char:SetAttribute("lungeboost", 999999)
            end
        elseif LungeOrig then
            char:SetAttribute("lungeboost", LungeOrig)
            LungeOrig = nil
        end
    end
    local function startLunge()
        if LungeConn then return end
        LungeConn = RunSvc.Heartbeat:Connect(function() if INF.Lunge then updateLunge() end end)
    end
    local function stopLunge()
        if LungeConn then LungeConn:Disconnect(); LungeConn = nil end
        updateLunge()
    end

    local AbyssConn, CorruptFunc = nil, nil
    local function startAbyss()
        if not CorruptFunc then
            pcall(function()
                for _, fn in pairs(getgc(true)) do
                    if type(fn) == "function" and islclosure(fn) then
                        local constants = debug.getconstants(fn)
                        if table.find(constants, "corrupt") and table.find(constants, "Immobile") then
                            CorruptFunc = fn; break
                        end
                    end
                end
            end)
        end
        if not CorruptFunc then return end
        if AbyssConn then AbyssConn:Disconnect() end
        AbyssConn = RunSvc.Heartbeat:Connect(function()
            if not INF.Abyss or not CorruptFunc then return end
            pcall(function()
                for idx, val in pairs(debug.getupvalues(CorruptFunc)) do
                    if type(val) == "boolean" and val == false then debug.setupvalue(CorruptFunc, idx, true) end
                end
            end)
        end)
    end
    local function stopAbyss()
        if AbyssConn then AbyssConn:Disconnect(); AbyssConn = nil end
    end

    local HiddenThread = nil
    local function startHidden()
        if HiddenThread then return end
        HiddenThread = task.spawn(function()
            local leapFunction, m2Function
            local function scan()
                pcall(function()
                    for _, fn in pairs(getgc(true)) do
                        if type(fn) == "function" and islclosure(fn) then
                            local info
                            pcall(function() info = debug.getinfo(fn) end)
                            if info then
                                if info.name == "tryActivate" then leapFunction = fn
                                elseif info.name == "playM2Animation" then m2Function = fn end
                            end
                        end
                        if leapFunction and m2Function then break end
                    end
                end)
            end
            scan()
            local lastScan = os.clock()
            while task.wait(0.1) do
                if not INF.Hidden then break end
                if not (leapFunction and m2Function) then
                    local now = os.clock()
                    if now - lastScan >= 2 then lastScan = now; scan() end
                end
                if leapFunction then
                    pcall(function()
                        for i, val in pairs(debug.getupvalues(leapFunction)) do
                            if type(val) == "boolean" and val == true then debug.setupvalue(leapFunction, i, false) end
                        end
                    end)
                end
                if m2Function then
                    pcall(function()
                        for i, val in pairs(debug.getupvalues(m2Function)) do
                            if type(val) == "boolean" and val == true then debug.setupvalue(m2Function, i, false) end
                        end
                    end)
                end
            end
            HiddenThread = nil
        end)
    end
    local function stopHidden() end

    pcall(function()
        local InfKiller = K_Page:CreateSection("Infinite Killer", "bolt")
        InfKiller:AddToggle("Infinite Lake Mist (Jason)", false, function(v)
            INF.LakeMist = v
            if v then pcall(startSlasher) else pcall(stopSlasher) end
            notify("Infinite Lake Mist", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "InfLakeMist" })
        InfKiller:AddToggle("Infinite Pursuit (Jason)", false, function(v)
            INF.Pursuit = v
            if v then pcall(startSlasher) else pcall(stopSlasher) end
            notify("Infinite Pursuit", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "InfPursuit" })
        InfKiller:AddToggle("Infinite Lunge (Basic Attack)", false, function(v)
            INF.Lunge = v
            if v then pcall(startLunge) else pcall(stopLunge) end
            notify("Infinite Lunge", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "InfLunge" })
        InfKiller:AddToggle("Infinite Abyssal Burst (Abyss)", false, function(v)
            INF.Abyss = v
            if v then pcall(startAbyss) else pcall(stopAbyss) end
            notify("Infinite Abyssal Burst", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "InfAbyss" })
        InfKiller:AddToggle("Infinite Skill (Hidden)", false, function(v)
            INF.Hidden = v
            if v then pcall(startHidden) else pcall(stopHidden) end
            notify("Infinite Skill (Hidden)", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "InfHidden" })
        InfKiller:AddToggle("Infinite Frenzy + Auto-Aim (Jeff)", false, function(v)
            local P = _G.Ox.Ported
            if P and P.FA then P.FA.KillerInfFrenzy = v end
            if P then if v then pcall(P.startJeff) else pcall(P.stopJeff) end end
            notify("Infinite Frenzy", v and "AKTIF - Auto-Aim ON" or "NONAKTIF")
        end, { Flag = "KillerInfFrenzy" })
        local grabToggleCtrl
        grabToggleCtrl = InfKiller:AddToggle("Infinite Grab (Myers)", false, function(v)

            local P = _G.Ox.Ported
            if P and P.GrabToggle then pcall(P.GrabToggle, v) end
        end, { Flag = "KillerInfGrab" })
        _G.Ox.Ported = _G.Ox.Ported or {}
        _G.Ox.Ported.GrabToggleCtrl = grabToggleCtrl

        InfKiller:AddSlider("Grab Range", 5, 30, 5, function(v)
            local P = _G.Ox.Ported
            if P and P.GrabState then
                P.GrabState.Range = v
                if P.GrabSave then pcall(P.GrabSave) end
            end
        end, { Flag = "GrabRange" })
        InfKiller:AddSlider("Grab Stun (detik)", 10, 20, 11, function(v)
            local P = _G.Ox.Ported
            if P and P.GrabState then
                P.GrabState.StunDuration = v
                if P.GrabSave then pcall(P.GrabSave) end
            end
        end, { Flag = "GrabStun" })
        InfKiller:AddToggle("Animasi Grab (Myers)", true, function(v)
            local P = _G.Ox.Ported
            if P and P.GrabState then
                P.GrabState.PlaySlash = v
                if P.GrabSave then pcall(P.GrabSave) end
            end
        end, { Flag = "GrabAnim" })
    end)

    pcall(function()
        local KillerUtil = K_Page:CreateSection("Killer Utility", "wrench")
        KillerUtil:AddToggle("Fake Attack (Counter Parry)", false, function(v)
            local P = _G.Ox.Ported
            if P and P.FA then P.FA.KillerFakeAttack = v end
            if P and P.toggleFakeAttack then pcall(P.toggleFakeAttack, v) end
            notify("Fake Attack", v and "AKTIF" or "NONAKTIF")
        end, { Flag = "KillerFakeAttack" })
    end)
end

lib:Notify({Title = BRAND_NAME .. " HUB", Description = "Loaded", Duration = 3})
