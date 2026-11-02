--[[
Bintang Spear — standalone Silent Veil
Requires: executor dengan getrawmetatable, setreadonly, newcclosure,
          checkcaller, getnamecallmethod, setnamecallmethod, getgenv
Target  : Violence District (Roblox)
Author  : Bintang Spear build
--]]

local ENV = getgenv and getgenv() or _G
if ENV.__BSTAR_LOADED then return ENV.__BSTAR_API end
ENV.__BSTAR_LOADED = true

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local LocalPlayer       = Players.LocalPlayer
local currentCamera     = workspace.CurrentCamera

-- =========================================================================
-- STATE
-- =========================================================================
local CFG = {
    Enabled         = false,
    ShowFOV         = true,
    ShowHighlight   = true,
    ShowTracker     = true,
    SmartPredict    = false,
    FOV             = 150,
    MaxDist         = 500,
    LeadMultiplier  = 1.4,
    SpearSpeed      = 165,
    SpearGravity    = 103,
    AuraSpeed       = 165,
    AuraGravity     = 96.5,
    TargetPart      = "Torso",
    Theme           = {
        Primary   = Color3.fromRGB(255, 215, 0),
        Secondary = Color3.fromRGB(255, 140, 0),
        Accent    = Color3.fromRGB(180, 230, 255),
        Bg        = Color3.fromRGB(14, 16, 22),
        Panel     = Color3.fromRGB(22, 26, 34),
        Row       = Color3.fromRGB(34, 40, 52),
        Hover     = Color3.fromRGB(48, 56, 72),
        Stroke    = Color3.fromRGB(80, 90, 110),
        Text      = Color3.fromRGB(230, 234, 242),
        Dim       = Color3.fromRGB(140, 148, 165),
        Good      = Color3.fromRGB(80, 220, 130),
        Bad       = Color3.fromRGB(240, 90, 90),
    },
}

local State = {
    Hooked      = false,
    OrigMeta    = nil,
    Firing      = false,
    TrackedTarget = nil,
    FOVGui      = nil,
    FOVFrame    = nil,
    FOVStroke   = nil,
    Highlight   = nil,
    TrackerPart = nil,
    UI          = {},
    Dragging    = false,
    DragStart   = nil,
    DragPos     = nil,
}

-- =========================================================================
-- HELPERS
-- =========================================================================
local function getTargetPart(char)
    if not char then return nil end
    if CFG.TargetPart == "Head" then return char:FindFirstChild("Head") end
    if CFG.TargetPart == "Root" then return char:FindFirstChild("HumanoidRootPart") end
    return char:FindFirstChild("Torso")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("HumanoidRootPart")
end

local function getClosestSurvivor()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local bestDist = CFG.FOV
    local best     = nil
    local screenC  = Vector2.new(currentCamera.ViewportSize.X * 0.5, currentCamera.ViewportSize.Y * 0.5)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
            and plr.Team and plr.Team.Name == "Survivors"
            and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local part = getTargetPart(plr.Character)
            if hum and hum.Health > 0 and part
                and (part.Position - hrp.Position).Magnitude <= CFG.MaxDist then
                local sp, onScreen = currentCamera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - screenC).Magnitude
                    if d <= bestDist then
                        bestDist = d
                        best = part
                    end
                end
            end
        end
    end
    return best
end

-- ballistic solve: given horizontal distance D, vertical dy, speed v, gravity g
-- returns pitch angle and time of flight
local function solveBallistic(v, g, D, dy)
    D = math.max(D, 0.1)
    local v2 = v * v
    local disc = v2 * v2 - g * (g * D * D + 2 * dy * v2)
    if disc < 0 then disc = 0 end
    local root = math.sqrt(disc)
    local tanTheta = (v2 - root) / (g * D)
    local theta = math.atan(tanTheta)
    return theta
end

-- =========================================================================
-- FOV CIRCLE + HIGHLIGHT + TRACKER
-- =========================================================================
local function buildVisuals()
    local gui = Instance.new("ScreenGui")
    gui.Name = "BintangSpear_FOV"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9900
    gui.Parent = CoreGui
    State.FOVGui = gui

    local frame = Instance.new("Frame")
    frame.Name = "Circle"
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size = UDim2.fromOffset(CFG.FOV * 2, CFG.FOV * 2)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke")
    stroke.Color = CFG.Theme.Primary
    stroke.Thickness = 1.5
    stroke.Transparency = 0.35
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame
    State.FOVFrame = frame
    State.FOVStroke = stroke

    local hl = Instance.new("Highlight")
    hl.Name = "BintangSpear_Target"
    hl.FillColor = CFG.Theme.Primary
    hl.OutlineColor = CFG.Theme.Accent
    hl.FillTransparency = 0.55
    hl.OutlineTransparency = 0
    State.Highlight = hl
end

local function updateTracker(from, to)
    if not from or not to then
        if State.TrackerPart then State.TrackerPart.Transparency = 1 end
        return
    end
    local d = (to - from).Magnitude
    if d < 0.2 then
        if State.TrackerPart then State.TrackerPart.Transparency = 1 end
        return
    end
    if not State.TrackerPart or not State.TrackerPart.Parent then
        local part = Instance.new("Part")
        part.Name = "BintangSpear_Tracker"
        part.Anchored = true
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.CastShadow = false
        part.Material = Enum.Material.Neon
        part.Color = CFG.Theme.Primary
        part.Parent = workspace
        State.TrackerPart = part
    end
    local part = State.TrackerPart
    part.Size = Vector3.new(0.06, 0.06, d)
    part.CFrame = CFrame.new((from + to) * 0.5, to)
    part.Transparency = 0.2
end

-- =========================================================================
-- INTERCEPTOR (Silent Veil branch only)
-- =========================================================================
local function installHook()
    if State.Hooked then return true end
    if not getrawmetatable or not setreadonly or not newcclosure then
        return false
    end
    local mt = getrawmetatable(game)
    if not mt then return false end
    setreadonly(mt, false)
    State.OrigMeta = mt.__namecall
    local orig = mt.__namecall

    local spearthrow
    pcall(function()
        spearthrow = ReplicatedStorage.Remotes.Killers.Veil.Spearthrow
    end)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if CFG.Enabled
            and not State.Firing
            and not checkcaller()
            and (method == "FireServer" or method == "fireServer")
            and typeof(self) == "Instance"
            and self.Name == "Spearthrow"
        then
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local originPart = char and (char:FindFirstChild("Head") or hrp)
            local origin = originPart and originPart.Position
            local args = {...}
            local fallbackOrigin = args[3] or origin

            local target = getClosestSurvivor()
            if target and fallbackOrigin then
                local isSpecial = char and char:GetAttribute("special") == true
                local speed, grav
                if isSpecial then
                    speed, grav = CFG.AuraSpeed, CFG.AuraGravity
                else
                    speed, grav = CFG.SpearSpeed, CFG.SpearGravity
                end

                local targetRoot = target.Parent and target.Parent:FindFirstChild("HumanoidRootPart") or target
                local targetPos  = targetRoot.Position
                local humanoid   = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
                local vel        = Vector3.zero
                if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                    vel = humanoid.MoveDirection * humanoid.WalkSpeed
                elseif targetRoot:IsA("BasePart") then
                    vel = targetRoot.AssemblyLinearVelocity
                end
                local velFlat = Vector3.new(vel.X, 0, vel.Z)

                local delta = targetPos - fallbackOrigin
                local magFlat = Vector3.new(delta.X, 0, delta.Z).Magnitude
                local dy      = delta.Y
                local dir     = args[1]

                if delta.Magnitude > 0.1 and delta.Magnitude <= CFG.MaxDist then
                    if CFG.SmartPredict and velFlat.Magnitude > 0.5 then
                        local theta = solveBallistic(speed, grav, magFlat, dy)
                        local tflight = magFlat / (speed * math.cos(theta))
                        local lead = velFlat * (tflight * CFG.LeadMultiplier)
                        local cap  = math.clamp(delta.Magnitude * 0.6, 3, 45)
                        if lead.Magnitude > cap then lead = lead.Unit * cap end
                        local aimPoint = targetPos + lead
                        local d2 = aimPoint - fallbackOrigin
                        local m2 = Vector3.new(d2.X, 0, d2.Z).Magnitude
                        local theta2 = solveBallistic(speed, grav, m2, d2.Y)
                        if m2 > 0.001 then
                            dir = Vector3.new(d2.X, 0, d2.Z).Unit * math.cos(theta2)
                                + Vector3.new(0, math.sin(theta2), 0)
                        else
                            dir = d2.Unit
                        end
                    else
                        local theta = solveBallistic(speed, grav, magFlat, dy)
                        if magFlat > 0.001 then
                            dir = Vector3.new(delta.X, 0, delta.Z).Unit * math.cos(theta)
                                + Vector3.new(0, math.sin(theta), 0)
                        else
                            dir = delta.Unit
                        end
                    end
                end

                State.Firing = true
                pcall(function()
                    if spearthrow and spearthrow.Parent then
                        spearthrow:FireServer(dir, speed, fallbackOrigin)
                    else
                        self:FireServer(dir, speed, fallbackOrigin)
                    end
                end)
                State.Firing = false
                return
            end
        end
        return orig(self, ...)
    end)

    setreadonly(mt, true)
    State.Hooked = true
    return true
end

local function uninstallHook()
    if not State.Hooked then return end
    local mt = getrawmetatable(game)
    if mt and State.OrigMeta then
        setreadonly(mt, false)
        mt.__namecall = State.OrigMeta
        setreadonly(mt, true)
    end
    State.OrigMeta = nil
    State.Hooked = false
end

-- =========================================================================
-- UI BUILD
-- =========================================================================
local function mk(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then o[k] = v end
    end
    if props and props.Parent then o.Parent = props.Parent end
    return o
end

local function corner(parent, r)
    mk("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = parent })
end

local function stroke(parent, color, thick, trans)
    local s = mk("UIStroke", {
        Color = color or CFG.Theme.Stroke,
        Thickness = thick or 1,
        Transparency = trans or 0.4,
        Parent = parent,
    })
    return s
end

local function pad(parent, t, r, b, l)
    mk("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingRight = UDim.new(0, r or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0),
        Parent = parent,
    })
end

local function makeUI()
    local parent = (gethui and gethui()) or CoreGui
    local old = parent:FindFirstChild("BintangSpearUI")
    if old then old:Destroy() end

    local gui = mk("ScreenGui", {
        Name = "BintangSpearUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 9998,
        Parent = parent,
    })
    State.UI.Gui = gui

    local main = mk("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(320, 470),
        BackgroundColor3 = CFG.Theme.Bg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = gui,
    })
    corner(main, 14)
    local mainStroke = stroke(main, CFG.Theme.Primary, 1.5, 0.25)
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mk("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, CFG.Theme.Primary),
            ColorSequenceKeypoint.new(0.5, CFG.Theme.Secondary),
            ColorSequenceKeypoint.new(1, CFG.Theme.Primary),
        }),
        Rotation = 45,
        Parent = mainStroke,
    })
    mk("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 60, 1, 60),
        BackgroundTransparency = 1,
        Image = "rbxassetid://8992230677",
        ImageColor3 = CFG.Theme.Primary,
        ImageTransparency = 0.85,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(99, 99, 99, 99),
        Parent = main,
    })
    State.UI.Main = main

    local top = mk("Frame", {
        Name = "Top",
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = CFG.Theme.Panel,
        BorderSizePixel = 0,
        Parent = main,
    })
    corner(top, 14)
    mk("Frame", {
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 1, -16),
        BackgroundColor3 = CFG.Theme.Panel,
        BorderSizePixel = 0,
        Parent = top,
    })

    local logo = mk("Frame", {
        Size = UDim2.fromOffset(34, 34),
        Position = UDim2.fromOffset(12, 9),
        BackgroundColor3 = CFG.Theme.Row,
        BorderSizePixel = 0,
        Parent = top,
    })
    corner(logo, 10)
    stroke(logo, CFG.Theme.Primary, 1.5, 0.2)
    mk("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "★",
        Font = Enum.Font.GothamBlack,
        TextSize = 22,
        TextColor3 = CFG.Theme.Primary,
        Parent = logo,
    })

    mk("TextLabel", {
        Size = UDim2.new(1, -90, 0, 18),
        Position = UDim2.fromOffset(54, 10),
        BackgroundTransparency = 1,
        Text = "BINTANG SPEAR",
        Font = Enum.Font.GothamBlack,
        TextSize = 15,
        TextColor3 = CFG.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = top,
    })
    mk("TextLabel", {
        Size = UDim2.new(1, -90, 0, 14),
        Position = UDim2.fromOffset(54, 28),
        BackgroundTransparency = 1,
        Text = "silent veil · solo",
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = CFG.Theme.Dim,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = top,
    })

    local closeBtn = mk("TextButton", {
        Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(1, -34, 0, 13),
        BackgroundColor3 = CFG.Theme.Row,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = top,
    })
    corner(closeBtn, 8)
    mk("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = CFG.Theme.Dim,
        Parent = closeBtn,
    })
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.12), { BackgroundColor3 = CFG.Theme.Bad }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.12), { BackgroundColor3 = CFG.Theme.Row }):Play()
    end)
    closeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
    end)

    State.Dragging = false
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            State.Dragging  = true
            State.DragStart = input.Position
            State.DragPos   = main.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            State.Dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not State.Dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - State.DragStart
        main.Position = UDim2.new(
            State.DragPos.X.Scale,
            State.DragPos.X.Offset + delta.X,
            State.DragPos.Y.Scale,
            State.DragPos.Y.Offset + delta.Y
        )
    end)

    local body = mk("ScrollingFrame", {
        Name = "Body",
        Size = UDim2.new(1, -20, 1, -68),
        Position = UDim2.fromOffset(10, 60),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = CFG.Theme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = main,
    })
    local bodyList = mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = body,
    })
    pad(body, 2, 6, 10, 2)

    State.UI.Body = body
    State.UI.BodyList = bodyList

    local orderCounter = 0
    local function nextOrder()
        orderCounter = orderCounter + 1
        return orderCounter
    end

    -- == Master toggle ==
    local function buildMaster()
        local card = mk("Frame", {
            Size = UDim2.new(1, 0, 0, 64),
            BackgroundColor3 = CFG.Theme.Panel,
            BorderSizePixel = 0,
            LayoutOrder = nextOrder(),
            Parent = body,
        })
        corner(card, 10)
        local cs = stroke(card, CFG.Theme.Primary, 1.4, 0.35)
        mk("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, CFG.Theme.Primary),
                ColorSequenceKeypoint.new(1, CFG.Theme.Secondary),
            }),
            Rotation = 90,
            Parent = cs,
        })

        mk("TextLabel", {
            Size = UDim2.new(1, -100, 0, 20),
            Position = UDim2.fromOffset(14, 10),
            BackgroundTransparency = 1,
            Text = "SILENT VEIL",
            Font = Enum.Font.GothamBlack,
            TextSize = 14,
            TextColor3 = CFG.Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = card,
        })
        mk("TextLabel", {
            Size = UDim2.new(1, -100, 0, 16),
            Position = UDim2.fromOffset(14, 30),
            BackgroundTransparency = 1,
            Text = "aim assist aktif saat spearmode",
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextColor3 = CFG.Theme.Dim,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = card,
        })

        local btn = mk("TextButton", {
            Size = UDim2.fromOffset(72, 30),
            Position = UDim2.new(1, -86, 0, 17),
            BackgroundColor3 = CFG.Theme.Row,
            BorderSizePixel = 0,
            Text = "OFF",
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = CFG.Theme.Dim,
            AutoButtonColor = false,
            Parent = card,
        })
        corner(btn, 8)
        local btnStroke = stroke(btn, CFG.Theme.Stroke, 1, 0.4)

        local function render()
            if CFG.Enabled then
                TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = CFG.Theme.Good }):Play()
                btn.Text = "ON"
                btn.TextColor3 = CFG.Theme.Bg
                btnStroke.Transparency = 1
                cs.Transparency = 0
            else
                TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = CFG.Theme.Row }):Play()
                btn.Text = "OFF"
                btn.TextColor3 = CFG.Theme.Dim
                btnStroke.Transparency = 0.4
            end
        end

        btn.MouseButton1Click:Connect(function()
            CFG.Enabled = not CFG.Enabled
            if CFG.Enabled and not State.Hooked then installHook() end
            render()
        end)
        render()
        State.UI.MasterBtn = btn
    end

    -- == Generic toggle row ==
    local function buildToggle(title, desc, get, set, flagName)
        local card = mk("Frame", {
            Size = UDim2.new(1, 0, 0, desc and 52 or 40),
            BackgroundColor3 = CFG.Theme.Panel,
            BorderSizePixel = 0,
            LayoutOrder = nextOrder(),
            Parent = body,
        })
        corner(card, 8)
        stroke(card, CFG.Theme.Stroke, 1, 0.5)

        mk("TextLabel", {
            Size = UDim2.new(1, -70, 0, desc and 18 or 40),
            Position = UDim2.fromOffset(12, desc and 8 or 0),
            BackgroundTransparency = 1,
            Text = title,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = CFG.Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = desc and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
            Parent = card,
        })
        if desc then
            mk("TextLabel", {
                Size = UDim2.new(1, -70, 0, 16),
                Position = UDim2.fromOffset(12, 28),
                BackgroundTransparency = 1,
                Text = desc,
                Font = Enum.Font.Gotham,
                TextSize = 9,
                TextColor3 = CFG.Theme.Dim,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = card,
            })
        end

        local sw = mk("Frame", {
            Size = UDim2.fromOffset(40, 20),
            Position = UDim2.new(1, -52, 0.5, -10),
            BackgroundColor3 = CFG.Theme.Row,
            BorderSizePixel = 0,
            Parent = card,
        })
        corner(sw, 10)
        local swStroke = stroke(sw, CFG.Theme.Stroke, 1, 0.5)
        local knob = mk("Frame", {
            Size = UDim2.fromOffset(14, 14),
            Position = UDim2.new(0, 3, 0.5, -7),
            BackgroundColor3 = CFG.Theme.Dim,
            BorderSizePixel = 0,
            Parent = sw,
        })
        corner(knob, 7)

        local hit = mk("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = "",
            Parent = card,
        })

        local function render()
            local v = get()
            if v then
                TweenService:Create(knob, TweenInfo.new(0.15), {
                    Position = UDim2.new(1, -17, 0.5, -7),
                    BackgroundColor3 = CFG.Theme.Bg,
                }):Play()
                TweenService:Create(sw, TweenInfo.new(0.15), {
                    BackgroundColor3 = CFG.Theme.Primary,
                }):Play()
                swStroke.Transparency = 1
            else
                TweenService:Create(knob, TweenInfo.new(0.15), {
                    Position = UDim2.new(0, 3, 0.5, -7),
                    BackgroundColor3 = CFG.Theme.Dim,
                }):Play()
                TweenService:Create(sw, TweenInfo.new(0.15), {
                    BackgroundColor3 = CFG.Theme.Row,
                }):Play()
                swStroke.Transparency = 0.5
            end
        end

        hit.MouseButton1Click:Connect(function()
            set(not get())
            render()
        end)
        render()
        State.UI[flagName or title] = { Render = render, Set = set, Get = get }
    end

    -- == Slider row ==
    local function buildSlider(title, min, max, default, get, set, flagName)
        local card = mk("Frame", {
            Size = UDim2.new(1, 0, 0, 56),
            BackgroundColor3 = CFG.Theme.Panel,
            BorderSizePixel = 0,
            LayoutOrder = nextOrder(),
            Parent = body,
        })
        corner(card, 8)
        stroke(card, CFG.Theme.Stroke, 1, 0.5)

        mk("TextLabel", {
            Size = UDim2.new(1, -90, 0, 18),
            Position = UDim2.fromOffset(12, 8),
            BackgroundTransparency = 1,
            Text = title,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = CFG.Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = card,
        })
        local valLabel = mk("TextLabel", {
            Size = UDim2.fromOffset(70, 18),
            Position = UDim2.new(1, -82, 0, 8),
            BackgroundTransparency = 1,
            Text = tostring(default),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextColor3 = CFG.Theme.Primary,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = card,
        })

        local track = mk("Frame", {
            Size = UDim2.new(1, -24, 0, 6),
            Position = UDim2.fromOffset(12, 38),
            BackgroundColor3 = CFG.Theme.Row,
            BorderSizePixel = 0,
            Parent = card,
        })
        corner(track, 3)
        local range = max - min
        local alpha = range > 0 and (default - min) / range or 0
        local fill = mk("Frame", {
            Size = UDim2.new(alpha, 0, 1, 0),
            BackgroundColor3 = CFG.Theme.Primary,
            BorderSizePixel = 0,
            Parent = track,
        })
        corner(fill, 3)
        mk("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, CFG.Theme.Primary),
                ColorSequenceKeypoint.new(1, CFG.Theme.Secondary),
            }),
            Parent = fill,
        })
        local knob = mk("Frame", {
            Size = UDim2.fromOffset(14, 14),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(alpha, 0, 0.5, 0),
            BackgroundColor3 = CFG.Theme.Text,
            BorderSizePixel = 0,
            Parent = track,
        })
        corner(knob, 7)
        stroke(knob, CFG.Theme.Primary, 2, 0)

        local function fmt(v)
            if v == math.floor(v) then return tostring(v) end
            return string.format("%.2f", v)
        end

        local function apply(v, fire)
            v = math.clamp(v, min, max)
            local a = range > 0 and (v - min) / range or 0
            fill.Size = UDim2.new(a, 0, 1, 0)
            knob.Position = UDim2.new(a, 0, 0.5, 0)
            valLabel.Text = fmt(v)
            set(v)
        end

        local dragging = false
        local function fromX(x)
            local a = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            apply(min + a * range, true)
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                fromX(input.Position.X)
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

        apply(get(), false)
        State.UI[flagName or title] = { Set = apply }
    end

    -- == Dropdown row (Torso/Head/Root) ==
    local function buildTargetPart()
        local card = mk("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = CFG.Theme.Panel,
            BorderSizePixel = 0,
            LayoutOrder = nextOrder(),
            Parent = body,
        })
        corner(card, 8)
        stroke(card, CFG.Theme.Stroke, 1, 0.5)

        mk("TextLabel", {
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.fromOffset(12, 0),
            BackgroundTransparency = 1,
            Text = "Target Part",
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = CFG.Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = card,
        })

        local parts = { "Torso", "Head", "Root" }
        local idx = 1
        for i, v in ipairs(parts) do
            if v == CFG.TargetPart then idx = i; break end
        end

        local btn = mk("TextButton", {
            Size = UDim2.new(0, 140, 0, 26),
            Position = UDim2.new(1, -152, 0.5, -13),
            BackgroundColor3 = CFG.Theme.Row,
            BorderSizePixel = 0,
            Text = "  " .. parts[idx] .. "  ▾",
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextColor3 = CFG.Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            Parent = card,
        })
        corner(btn, 6)
        stroke(btn, CFG.Theme.Stroke, 1, 0.5)

        btn.MouseButton1Click:Connect(function()
            idx = (idx % #parts) + 1
            CFG.TargetPart = parts[idx]
            btn.Text = "  " .. parts[idx] .. "  ▾"
        end)
    end

    -- Build sections
    buildMaster()

    mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = "VISUAL",
        Font = Enum.Font.GothamBlack,
        TextSize = 10,
        TextColor3 = CFG.Theme.Dim,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = nextOrder(),
        Parent = body,
    })
    buildToggle("FOV Circle", "border lingkaran di layar",
        function() return CFG.ShowFOV end,
        function(v) CFG.ShowFOV = v; if State.FOVFrame then State.FOVFrame.Visible = v and CFG.Enabled end end,
        "ShowFOV")
    buildToggle("Target Highlight", "outline merah di target",
        function() return CFG.ShowHighlight end,
        function(v) CFG.ShowHighlight = v; if not v and State.Highlight then State.Highlight.Parent = nil end end,
        "ShowHighlight")
    buildToggle("Tracker Line", "garis neon dari kepala ke target",
        function() return CFG.ShowTracker end,
        function(v) CFG.ShowTracker = v; if not v and State.TrackerPart then State.TrackerPart.Transparency = 1 end end,
        "ShowTracker")

    mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = "AIM",
        Font = Enum.Font.GothamBlack,
        TextSize = 10,
        TextColor3 = CFG.Theme.Dim,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = nextOrder(),
        Parent = body,
    })
    buildToggle("Auto Predict", "lead velocity survivor",
        function() return CFG.SmartPredict end,
        function(v) CFG.SmartPredict = v end,
        "SmartPredict")
    buildSlider("FOV Radius", 30, 500, CFG.FOV,
        function() return CFG.FOV end,
        function(v) CFG.FOV = v; if State.FOVFrame then State.FOVFrame.Size = UDim2.fromOffset(v * 2, v * 2) end end,
        "FOVSlider")
    buildSlider("Max Distance", 50, 1000, CFG.MaxDist,
        function() return CFG.MaxDist end,
        function(v) CFG.MaxDist = v end,
        "MaxDistSlider")
    buildSlider("Lead", 0.5, 5, CFG.LeadMultiplier,
        function() return CFG.LeadMultiplier end,
        function(v) CFG.LeadMultiplier = v end,
        "LeadSlider")
    buildTargetPart()

    mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = "BALLISTIC",
        Font = Enum.Font.GothamBlack,
        TextSize = 10,
        TextColor3 = CFG.Theme.Dim,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = nextOrder(),
        Parent = body,
    })
    buildSlider("Spear Speed", 50, 200, CFG.SpearSpeed,
        function() return CFG.SpearSpeed end,
        function(v) CFG.SpearSpeed = v end,
        "SpearSpeedSlider")
    buildSlider("Spear Gravity", 10, 200, CFG.SpearGravity,
        function() return CFG.SpearGravity end,
        function(v) CFG.SpearGravity = v end,
        "SpearGravitySlider")
    buildSlider("Aura Speed", 50, 200, CFG.AuraSpeed,
        function() return CFG.AuraSpeed end,
        function(v) CFG.AuraSpeed = v end,
        "AuraSpeedSlider")
    buildSlider("Aura Gravity", 10, 200, CFG.AuraGravity,
        function() return CFG.AuraGravity end,
        function(v) CFG.AuraGravity = v end,
        "AuraGravitySlider")

    local footer = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = nextOrder(),
        Parent = body,
    })
    mk("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "★ Bintang Spear · build standalone",
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextColor3 = CFG.Theme.Dim,
        Parent = footer,
    })

    -- Minimize bubble (reopen panel)
    local bubble = mk("TextButton", {
        Name = "Bubble",
        Size = UDim2.fromOffset(46, 46),
        Position = UDim2.new(0, 20, 0.5, -23),
        BackgroundColor3 = CFG.Theme.Panel,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Visible = false,
        Parent = gui,
    })
    corner(bubble, 10)
    stroke(bubble, CFG.Theme.Primary, 1.5, 0.2)
    mk("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "★",
        Font = Enum.Font.GothamBlack,
        TextSize = 24,
        TextColor3 = CFG.Theme.Primary,
        Parent = bubble,
    })
    State.UI.Bubble = bubble

    bubble.MouseButton1Click:Connect(function()
        main.Visible = true
        bubble.Visible = false
    end)
    closeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        bubble.Visible = true
    end)

    -- Keybind to toggle panel (RightAlt)
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.RightAlt then
            main.Visible = not main.Visible
            bubble.Visible = not main.Visible
        end
    end)
end

-- =========================================================================
-- RENDER LOOP
-- =========================================================================
local function startRenderLoop()
    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        local spearmode = char and char:GetAttribute("spearmode") == true

        if State.FOVFrame then
            local show = CFG.Enabled and CFG.ShowFOV and spearmode
            State.FOVFrame.Visible = show
            if show then
                State.FOVFrame.Size = UDim2.fromOffset(CFG.FOV * 2, CFG.FOV * 2)
                local target = getClosestSurvivor()
                if target then
                    State.FOVStroke.Color = CFG.Theme.Primary
                    State.FOVStroke.Transparency = 0.15
                else
                    State.FOVStroke.Color = CFG.Theme.Accent
                    State.FOVStroke.Transparency = 0.5
                end
            end
        end

        if State.Highlight then
            local target = (CFG.Enabled and CFG.ShowHighlight and spearmode) and getClosestSurvivor() or nil
            if target and target.Parent then
                State.Highlight.Parent = target.Parent
            else
                State.Highlight.Parent = nil
            end
        end

        if State.TrackerPart then
            local target = (CFG.Enabled and CFG.ShowTracker and spearmode) and getClosestSurvivor() or nil
            if target and char then
                local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                if head then
                    updateTracker(head.Position, target.Position)
                else
                    State.TrackerPart.Transparency = 1
                end
            else
                State.TrackerPart.Transparency = 1
            end
        end
    end)
end

-- =========================================================================
-- BOOT
-- =========================================================================
buildVisuals()
makeUI()
if not State.Hooked then installHook() end
startRenderLoop()

ENV.__BSTAR_API = {
    Config = CFG,
    State = State,
    Enable = function() CFG.Enabled = true; if not State.Hooked then installHook() end end,
    Disable = function() CFG.Enabled = false end,
    Toggle = function() CFG.Enabled = not CFG.Enabled; if CFG.Enabled and not State.Hooked then installHook() end; return CFG.Enabled end,
    ShowPanel = function() if State.UI.Main then State.UI.Main.Visible = true; State.UI.Bubble.Visible = false end end,
    HidePanel = function() if State.UI.Main then State.UI.Main.Visible = false; State.UI.Bubble.Visible = true end end,
    Uninstall = function() CFG.Enabled = false; uninstallHook(); if State.UI.Gui then State.UI.Gui:Destroy() end; if State.FOVGui then State.FOVGui:Destroy() end; if State.TrackerPart then State.TrackerPart:Destroy() end end,
}

return ENV.__BSTAR_API