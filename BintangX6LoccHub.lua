-- Services.
local playersService = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local lightingService = game:GetService("Lighting")

-- Config. Change these three lines.
local HUB_NAME = "BintangX6LoccHub"
local OWNER_NAME = "BintangHub"
local DISCORD_LINK = "https://discord.gg/GANTI_LINK"

local TOGGLE_KEY = Enum.KeyCode.RightShift
local LOGO_FILE = "BintangX6LoccHub_logo.jpg"
local LOGO_BASE64 = "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"
local BG_VIDEO_FILE = "BintangX6LoccHub/bg.webm"

-- Re-execution guard.
if shared.BintangX6LoccHub then
	pcall(shared.BintangX6LoccHub.destroy)
end

-- State.
local localPlayer = playersService.LocalPlayer
local parentGui = (gethui and gethui()) or game:GetService("CoreGui")
local flags, callbacks, elements = {}, {}, {}
local connections = {}
local pages, registries, tabButtons = {}, {}, {}
local activeRegistry = {}
local currentTab = "Info"
local activeSlider = nil
local Assets = {}
local autoY = Enum.AutomaticSize.Y
local layoutOrder = Enum.SortOrder.LayoutOrder

local Hub = { flags = flags }

-- Theme (crimson).
local colors = {
	window = Color3.fromRGB(13, 9, 9),
	row = Color3.fromRGB(26, 17, 17),
	line = Color3.fromRGB(46, 30, 30),
	border = Color3.fromRGB(90, 35, 38),
	off = Color3.fromRGB(47, 34, 34),
	accent = Color3.fromRGB(193, 39, 45),
	text = Color3.fromRGB(238, 238, 238),
	bright = Color3.fromRGB(241, 222, 222),
	muted = Color3.fromRGB(167, 154, 154),
	dim = Color3.fromRGB(127, 112, 112),
}

local palette = {
	Color3.fromRGB(255, 59, 59), Color3.fromRGB(255, 154, 0), Color3.fromRGB(255, 230, 0),
	Color3.fromRGB(18, 184, 74), Color3.fromRGB(0, 200, 200), Color3.fromRGB(59, 156, 255),
	Color3.fromRGB(139, 92, 246), Color3.fromRGB(255, 120, 220), Color3.fromRGB(255, 255, 255),
	Color3.fromRGB(150, 150, 150),
}

-- Decode base64 without relying on executor functions.
local function decodeBase64(data, yieldEvery)
	local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	local lookup = {}
	for index = 1, #alphabet do
		lookup[alphabet:byte(index)] = index - 1
	end

	local output, buffer, bits = {}, 0, 0
	for index = 1, #data do
		local value = lookup[data:byte(index)]
		if value then
			buffer = buffer * 64 + value
			bits += 6
			if bits >= 8 then
				bits -= 8
				table.insert(output, string.char(math.floor(buffer / 2 ^ bits)))
				buffer = buffer % 2 ^ bits
			end
		end

		-- Give the game a breather while decoding big data.
		if yieldEvery and index % yieldEvery == 0 then
			task.wait()
		end
	end

	return table.concat(output)
end

-- Write the logo to disk and get an asset id. Falls back to a letter.
local function loadLogo()
	if not (writefile and getcustomasset) then
		return nil
	end

	local ok, asset = pcall(function()
		writefile(LOGO_FILE, decodeBase64(LOGO_BASE64))
		return getcustomasset(LOGO_FILE)
	end)

	return ok and asset or nil
end

local logoAsset = loadLogo()

-- Create an instance with properties in one call.
local function create(className, properties, parent)
	local instance = Instance.new(className)
	for key, value in pairs(properties) do
		instance[key] = value
	end
	instance.Parent = parent
	return instance
end

local function round(instance, radius)
	create("UICorner", { CornerRadius = UDim.new(0, radius) }, instance)
end

local function stroke(instance, color, thickness)
	create("UIStroke", { Color = color, Thickness = thickness or 1 }, instance)
end

-- Fire a flag change and its callback.
local function fire(key, value)
	flags[key] = value
	local callback = callbacks[key]
	if callback then
		task.spawn(callback, value)
	end
end

-- Logo image, or a letter if images are unsupported.
local function createLogo(parent, size, radius)
	local logo
	if logoAsset then
		logo = create("ImageLabel", {
			Size = UDim2.fromOffset(size, size),
			BackgroundTransparency = 1,
			Image = logoAsset,
			ScaleType = Enum.ScaleType.Crop,
		}, parent)
	else
		logo = create("TextLabel", {
			Size = UDim2.fromOffset(size, size),
			BackgroundColor3 = colors.accent,
			Font = Enum.Font.GothamBold,
			TextSize = math.floor(size * 0.55),
			TextColor3 = Color3.new(1, 1, 1),
			Text = HUB_NAME:sub(1, 1),
		}, parent)
	end
	round(logo, radius)
	return logo
end

-- Window.
local gui = create("ScreenGui", { Name = HUB_NAME, ResetOnSpawn = false, DisplayOrder = 100, IgnoreGuiInset = true }, parentGui)

-- Ignore notch and cutout insets, which push centered windows sideways.
pcall(function()
	gui.ScreenInsets = Enum.ScreenInsets.None
end)

local viewport = workspace.CurrentCamera.ViewportSize
local windowWidth = math.clamp(viewport.X - 60, 380, 580)
local windowHeight = math.clamp(viewport.Y - 40, 250, 350)

local window = create("Frame", {
	Size = UDim2.fromOffset(windowWidth, windowHeight),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	BackgroundColor3 = colors.window,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, gui)
round(window, 12)
stroke(window, colors.border, 1.5)

-- Background video layer with a dark overlay so text stays readable.
local videoEnabled, videoReady = true, false

local videoFrame = create("VideoFrame", {
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = colors.window,
	BorderSizePixel = 0,
	Looped = true,
	Volume = 0,
	Visible = false,
}, window)

local overlay = create("Frame", {
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = colors.window,
	BackgroundTransparency = 0.22,
	BorderSizePixel = 0,
}, window)

-- Play the video only while it can be seen, to keep things light.
local function applyVideo()
	videoFrame.Visible = videoEnabled and videoReady
	videoFrame.Playing = videoEnabled and videoReady and window.Visible
end

local function setWindowVisible(visible)
	window.Visible = visible
	applyVideo()
end

-- Write the embedded video to the workspace folder once, then play it.
local function loadVideo()
	if not (writefile and isfile and getcustomasset and Assets.video) then
		return
	end

	local ok = pcall(function()
		if makefolder and isfolder and not isfolder("BintangX6LoccHub") then
			makefolder("BintangX6LoccHub")
		end

		if not isfile(BG_VIDEO_FILE) then
			writefile(BG_VIDEO_FILE, decodeBase64(Assets.video, 20000))
		end

		videoFrame.Video = getcustomasset(BG_VIDEO_FILE)
	end)
	if not ok then
		return
	end

	-- Wait a few seconds for the video; if it never loads the UI stays plain.
	local startTime = os.clock()
	while gui.Parent and not videoFrame.IsLoaded and os.clock() - startTime < 6 do
		task.wait(0.2)
	end

	if gui.Parent then
		videoReady = videoFrame.IsLoaded
		applyVideo()
	end
end

-- Sidebar.
local sidebar = create("Frame", { Size = UDim2.new(0, 150, 1, 0), BackgroundTransparency = 1 }, window)
create("Frame", { Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = colors.line, BorderSizePixel = 0 }, sidebar)

local brandLogo = createLogo(sidebar, 22, 6)
brandLogo.Position = UDim2.fromOffset(8, 8)

create("TextLabel", {
	Size = UDim2.new(1, -44, 0, 22),
	Position = UDim2.fromOffset(36, 8),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	TextColor3 = colors.text,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Text = HUB_NAME,
}, sidebar)

local searchBox = create("TextBox", {
	Size = UDim2.new(1, -16, 0, 26),
	Position = UDim2.fromOffset(8, 38),
	BackgroundColor3 = colors.window,
	BackgroundTransparency = 0.4,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	TextColor3 = colors.text,
	PlaceholderText = "Search",
	PlaceholderColor3 = colors.dim,
	Text = "",
	ClearTextOnFocus = false,
	TextXAlignment = Enum.TextXAlignment.Left,
}, sidebar)
round(searchBox, 6)
stroke(searchBox, colors.line)
create("UIPadding", { PaddingLeft = UDim.new(0, 8) }, searchBox)

create("Frame", { Size = UDim2.new(1, -16, 0, 1), Position = UDim2.fromOffset(8, 70), BackgroundColor3 = colors.line, BorderSizePixel = 0 }, sidebar)

local nav = create("ScrollingFrame", {
	Size = UDim2.new(1, -12, 1, -132),
	Position = UDim2.fromOffset(6, 76),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 0,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = autoY,
}, sidebar)
create("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = layoutOrder }, nav)

-- Footer with avatar and name.
local footer = create("Frame", { Size = UDim2.new(1, 0, 0, 48), Position = UDim2.new(0, 0, 1, -48), BackgroundTransparency = 1 }, sidebar)
create("Frame", { Size = UDim2.new(1, -16, 0, 1), Position = UDim2.fromOffset(8, 0), BackgroundColor3 = colors.line, BorderSizePixel = 0 }, footer)

local avatar = create("ImageLabel", {
	Size = UDim2.fromOffset(28, 28),
	Position = UDim2.fromOffset(8, 11),
	BackgroundColor3 = colors.row,
	BorderSizePixel = 0,
}, footer)
round(avatar, 6)

task.spawn(function()
	local ok, content = pcall(playersService.GetUserThumbnailAsync, playersService, localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	if ok then
		avatar.Image = content
	end
end)

create("TextLabel", {
	Size = UDim2.new(1, -46, 0, 16),
	Position = UDim2.fromOffset(42, 10),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	TextColor3 = colors.text,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Text = localPlayer.DisplayName,
}, footer)

create("TextLabel", {
	Size = UDim2.new(1, -46, 0, 14),
	Position = UDim2.fromOffset(42, 25),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	TextSize = 10,
	TextColor3 = colors.dim,
	TextXAlignment = Enum.TextXAlignment.Left,
	Text = "Violence District",
}, footer)

-- Header with title, minimize and close.
local header = create("Frame", { Size = UDim2.new(1, -150, 0, 36), Position = UDim2.fromOffset(150, 0), BackgroundTransparency = 1 }, window)
create("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = colors.line, BorderSizePixel = 0 }, header)

local headerTitle = create("TextLabel", {
	Size = UDim2.new(1, -80, 1, 0),
	Position = UDim2.fromOffset(14, 0),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	TextColor3 = colors.text,
	TextXAlignment = Enum.TextXAlignment.Left,
	Text = "Info",
}, header)

local function createHeaderButton(text, offsetX, callback)
	local button = create("TextButton", {
		Size = UDim2.fromOffset(24, 24),
		Position = UDim2.new(1, offsetX, 0, 6),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = colors.muted,
		Text = text,
	}, header)
	button.MouseButton1Click:Connect(callback)
end

createHeaderButton("-", -56, function()
	setWindowVisible(false)
end)

createHeaderButton("x", -28, function()
	Hub.destroy()
end)

local pagesHolder = create("Frame", {
	Size = UDim2.new(1, -150, 1, -36),
	Position = UDim2.fromOffset(150, 36),
	BackgroundTransparency = 1,
	ClipsDescendants = true,
}, window)

-- Floating button to show or hide the window.
local floatButton = create("ImageButton", {
	Size = UDim2.fromOffset(38, 38),
	Position = UDim2.fromOffset(56, 56),
	BackgroundColor3 = colors.window,
	BorderSizePixel = 0,
	Image = logoAsset or "",
}, gui)
round(floatButton, 10)
stroke(floatButton, colors.border, 1.5)
floatButton.MouseButton1Click:Connect(function()
	setWindowVisible(not window.Visible)
end)

-- Window dragging and slider dragging share one input listener.
local dragging, dragStart, startPosition = false, nil, nil

local function isPointerInput(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function setScrollLocked(locked)
	for _, page in pairs(pages) do
		if page:IsA("ScrollingFrame") then
			page.ScrollingEnabled = not locked
		end
	end
end

header.InputBegan:Connect(function(input)
	if isPointerInput(input) then
		dragging, dragStart, startPosition = true, input.Position, window.Position
	end
end)

table.insert(connections, userInputService.InputChanged:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	if activeSlider then
		activeSlider(input)
	end

	if dragging then
		local delta = input.Position - dragStart
		window.Position = UDim2.new(
			startPosition.X.Scale, startPosition.X.Offset + delta.X,
			startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
		)
	end
end))

table.insert(connections, userInputService.InputEnded:Connect(function(input)
	if isPointerInput(input) then
		dragging = false
		activeSlider = nil
		setScrollLocked(false)
	end
end))

table.insert(connections, userInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == TOGGLE_KEY then
		setWindowVisible(not window.Visible)
	end
end))

-- Row builders. Each one registers a flag under its key.
local builders = {}

local function registerRow(frame, text)
	table.insert(activeRegistry, { frame = frame, text = text:lower() })
end

local function createLabel(parent, text, size, color)
	return create("TextLabel", {
		Size = size,
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = color or colors.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Text = text,
	}, parent)
end

builders.toggle = function(body, row, key)
	local frame = create("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1 }, body)
	registerRow(frame, row.text)
	createLabel(frame, row.text, UDim2.new(1, -44, 1, 0))

	local track = create("Frame", {
		Size = UDim2.fromOffset(34, 18),
		Position = UDim2.new(1, -34, 0.5, -9),
		BackgroundColor3 = colors.off,
		BorderSizePixel = 0,
	}, frame)
	round(track, 9)

	local knob = create("Frame", {
		Size = UDim2.fromOffset(12, 12),
		Position = UDim2.fromOffset(3, 3),
		BackgroundColor3 = colors.muted,
		BorderSizePixel = 0,
	}, track)
	round(knob, 6)

	local value = row.default

	local function render(animate)
		local trackColor = value and colors.accent or colors.off
		local knobColor = value and Color3.new(1, 1, 1) or colors.muted
		local knobPosition = UDim2.fromOffset(value and 19 or 3, 3)

		if animate then
			local info = TweenInfo.new(0.12)
			tweenService:Create(track, info, { BackgroundColor3 = trackColor }):Play()
			tweenService:Create(knob, info, { BackgroundColor3 = knobColor, Position = knobPosition }):Play()
		else
			track.BackgroundColor3, knob.BackgroundColor3, knob.Position = trackColor, knobColor, knobPosition
		end
	end

	local function set(newValue, silent)
		value = newValue and true or false
		render(true)
		if silent then
			flags[key] = value
		else
			fire(key, value)
		end
	end

	local click = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "" }, frame)
	click.MouseButton1Click:Connect(function()
		set(not value)
	end)

	flags[key] = value
	render(false)
	elements[key] = { set = set }
end

builders.slider = function(body, row, key)
	local frame = create("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1 }, body)
	registerRow(frame, row.text)
	createLabel(frame, row.text, UDim2.new(1, -50, 0, 20))

	local valueLabel = create("TextLabel", {
		Size = UDim2.fromOffset(46, 20),
		Position = UDim2.new(1, -46, 0, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = colors.muted,
		TextXAlignment = Enum.TextXAlignment.Right,
	}, frame)

	local track = create("Frame", {
		Size = UDim2.new(1, 0, 0, 6),
		Position = UDim2.fromOffset(0, 26),
		BackgroundColor3 = colors.off,
		BorderSizePixel = 0,
	}, frame)
	round(track, 3)

	local fill = create("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = colors.accent, BorderSizePixel = 0 }, track)
	round(fill, 3)

	local knob = create("Frame", {
		Size = UDim2.fromOffset(12, 12),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
	}, track)
	round(knob, 6)

	local value = row.default
	local range = row.max - row.min

	local function render()
		local alpha = (value - row.min) / range
		fill.Size = UDim2.fromScale(alpha, 1)
		knob.Position = UDim2.fromScale(alpha, 0.5)
		valueLabel.Text = row.step < 1 and string.format("%.2f", value) or tostring(value)
	end

	local function set(newValue, silent)
		value = math.clamp(math.floor(newValue / row.step + 0.5) * row.step, row.min, row.max)
		render()
		if silent then
			flags[key] = value
		else
			fire(key, value)
		end
	end

	local function update(input)
		local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		set(row.min + alpha * range)
	end

	frame.InputBegan:Connect(function(input)
		if isPointerInput(input) then
			activeSlider = update
			setScrollLocked(true)
			update(input)
		end
	end)

	flags[key] = value
	render()
	elements[key] = { set = set }
end

builders.dropdown = function(body, row, key)
	local frame = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = autoY, BackgroundTransparency = 1 }, body)
	create("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = layoutOrder }, frame)
	registerRow(frame, row.text)

	local label = createLabel(frame, row.text, UDim2.new(1, 0, 0, 16), colors.muted)
	label.LayoutOrder = 1

	local box = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 26),
		LayoutOrder = 2,
		BackgroundColor3 = colors.row,
		AutoButtonColor = false,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = colors.text,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, frame)
	round(box, 6)
	stroke(box, colors.line)
	create("UIPadding", { PaddingLeft = UDim.new(0, 8) }, box)

	local optionsFrame = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = autoY,
		LayoutOrder = 3,
		BackgroundTransparency = 1,
		Visible = false,
	}, frame)
	create("UIListLayout", { Padding = UDim.new(0, 2) }, optionsFrame)

	local value = row.default

	local function set(newValue, silent)
		value = newValue
		box.Text = tostring(value) .. "  v"
		if silent then
			flags[key] = value
		else
			fire(key, value)
		end
	end

	-- Replace the list of choices (for example a player list).
	local function setOptions(list)
		for _, child in ipairs(optionsFrame:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		for _, option in ipairs(list) do
			local optionButton = create("TextButton", {
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundColor3 = colors.window,
				AutoButtonColor = false,
				Font = Enum.Font.Gotham,
				TextSize = 12,
				TextColor3 = colors.muted,
				Text = tostring(option),
			}, optionsFrame)
			round(optionButton, 5)

			optionButton.MouseButton1Click:Connect(function()
				set(option)
				optionsFrame.Visible = false
			end)
		end
	end

	box.MouseButton1Click:Connect(function()
		optionsFrame.Visible = not optionsFrame.Visible
	end)

	setOptions(row.options)
	flags[key] = value
	set(value, true)
	elements[key] = { set = set, setOptions = setOptions }
end

builders.colorPick = function(body, row, key)
	local frame = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = autoY, BackgroundTransparency = 1 }, body)
	create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = layoutOrder }, frame)
	registerRow(frame, row.text)

	local top = create("Frame", { Size = UDim2.new(1, 0, 0, 26), LayoutOrder = 1, BackgroundTransparency = 1 }, frame)
	createLabel(top, row.text, UDim2.new(1, -44, 1, 0), colors.muted)

	local swatch = create("TextButton", {
		Size = UDim2.fromOffset(34, 16),
		Position = UDim2.new(1, -34, 0.5, -8),
		BackgroundColor3 = row.default,
		AutoButtonColor = false,
		Text = "",
	}, top)
	round(swatch, 4)
	stroke(swatch, colors.border)

	local palettePanel = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = autoY,
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		Visible = false,
	}, frame)
	create("UIGridLayout", { CellSize = UDim2.fromOffset(22, 22), CellPadding = UDim2.fromOffset(4, 4) }, palettePanel)

	local value = row.default

	local function set(newValue, silent)
		value = newValue
		swatch.BackgroundColor3 = value
		if silent then
			flags[key] = value
		else
			fire(key, value)
		end
	end

	for _, presetColor in ipairs(palette) do
		local presetButton = create("TextButton", { BackgroundColor3 = presetColor, AutoButtonColor = false, Text = "" }, palettePanel)
		round(presetButton, 4)
		presetButton.MouseButton1Click:Connect(function()
			set(presetColor)
			palettePanel.Visible = false
		end)
	end

	swatch.MouseButton1Click:Connect(function()
		palettePanel.Visible = not palettePanel.Visible
	end)

	flags[key] = value
	elements[key] = { set = set }
end

builders.button = function(body, row, key)
	local button = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = colors.row,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = colors.bright,
		Text = row.text:upper(),
	}, body)
	round(button, 6)
	stroke(button, colors.line)
	registerRow(button, row.text)

	button.MouseButton1Click:Connect(function()
		button.BackgroundColor3 = colors.accent
		tweenService:Create(button, TweenInfo.new(0.25), { BackgroundColor3 = colors.row }):Play()
		local callback = callbacks[key]
		if callback then
			task.spawn(callback)
		end
	end)

	elements[key] = {}
end

builders.textBox = function(body, row, key)
	local frame = create("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1 }, body)
	registerRow(frame, row.text)
	createLabel(frame, row.text, UDim2.new(1, 0, 0, 16), colors.muted)

	local box = create("TextBox", {
		Size = UDim2.new(1, 0, 0, 26),
		Position = UDim2.fromOffset(0, 20),
		BackgroundColor3 = colors.row,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = colors.text,
		PlaceholderText = row.placeholder or "",
		PlaceholderColor3 = colors.dim,
		Text = "",
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, frame)
	round(box, 6)
	stroke(box, colors.line)
	create("UIPadding", { PaddingLeft = UDim.new(0, 8) }, box)

	box.FocusLost:Connect(function()
		fire(key, box.Text)
	end)

	flags[key] = ""
	elements[key] = {
		set = function(newValue, silent)
			box.Text = newValue
			if silent then
				flags[key] = newValue
			else
				fire(key, newValue)
			end
		end,
	}
end

builders.note = function(body, row)
	local label = createLabel(body, row.text, UDim2.new(1, 0, 0, 0), colors.dim)
	label.TextSize = 11
	label.TextWrapped = true
	label.TextTruncate = Enum.TextTruncate.None
	label.AutomaticSize = autoY
end

-- Row and card constructors for the tab data below.
local function toggle(text, default) return { kind = "toggle", text = text, default = default or false } end
local function slider(text, min, max, default, step) return { kind = "slider", text = text, min = min, max = max, default = default, step = step or 1 } end
local function dropdown(text, options, default) return { kind = "dropdown", text = text, options = options, default = default or options[1] } end
local function colorPick(text, value) return { kind = "colorPick", text = text, default = value } end
local function button(text) return { kind = "button", text = text } end
local function textBox(text, placeholder) return { kind = "textBox", text = text, placeholder = placeholder } end
local function note(text) return { kind = "note", text = text } end
local function card(title, rows) return { title = title, rows = rows } end

-- Tabs. Add or remove rows here. Key = "TabName.Row text".
local tabs = {
	{ name = "Info", info = true },
	{
		name = "Exclusive",
		left = {
			card("Utility", { toggle("Self Unhook GUI"), toggle("Fast Bandage GUI") }),
			card("Crosshair", {
				toggle("Enable Crosshair"),
				colorPick("Crosshair Color", Color3.fromRGB(255, 230, 0)),
				dropdown("Style", { "Dot", "Cross", "Circle" }),
				slider("Size", 1, 20, 8),
			}),
			card("Movement", { toggle("Auto Vault") }),
		},
		right = {
			card("Camera", {
				toggle("Max Zoom"), toggle("Killer Radar"), toggle("Camera FOV"),
				slider("FOV Value", 40, 120, 90),
				toggle("Third Person (Killer)"), toggle("DBD Camera"),
				slider("DBD Camera Distance", 1, 10, 3),
				slider("Custom Scale", 1, 5, 1),
			}),
			card("Fake Perks", {
				toggle("Fake Quick Recovery"), toggle("Fake Perfect Landing"),
				toggle("Fake Flowstate"), toggle("Fake Adrenaline Rush"),
				slider("Perks Cooldown (sec)", 1, 60, 10),
			}),
		},
	},
	{
		name = "Survivor",
		left = {
			card("Skill Check Generator", {
				toggle("Auto Skill Check"),
				dropdown("Skill Check Mode", { "Normal", "Instant", "Random" }, "Instant"),
				note("Normal: tekan saat jarum masuk zona"),
				note("Instant: langsung kena zona"),
				note("Random: Instant, pindah ke Normal saat King's Scourge"),
			}),
			card("Auto Parry", {
				toggle("Auto Parry", true),
				toggle("Silent Parry", true),
				toggle("Visual Radius", true),
				toggle("Abyss Auto Crouch", true),
				slider("Parry Radius", 1, 60, 15),
				slider("Facing Dot", -1, 1, 0.5, 0.05),
				toggle("Parry Debug"),
				button("Refresh Parry"),
			}),
			card("Survivor Ability", {
				toggle("God Mode (Anti Knock)"), toggle("Dodge Slash Abyss"), toggle("Unlimited Vault"),
				toggle("Fast Vault (Anti Slow)"), toggle("No CD Flowstate"), toggle("No Fall Damage"),
				toggle("Exit Gate Ghost"), toggle("Self Heal"), toggle("Instant Escape"),
			}),
		},
		right = {
			card("Silent Aim (Pistol)", {
				toggle("Silent Aim TOF"), toggle("Predict Aim TOF"), toggle("Block Aim Knocked"),
				toggle("Wallcheck"), toggle("Enable Laser Effect", true),
			}),
			card("Flash Aim", { toggle("Silent Aim (Flash)"), slider("Flash Head Offset (Y)", 0, 20, 1.5, 0.1) }),
		},
	},
	{
		name = "Killer",
		left = {
			card("Killer Ability", {
				toggle("Enable Aimbot"),
				slider("Melee Lock Distance", 1, 30, 12),
				slider("Aimbot Smoothness", 1, 20, 5),
				toggle("Anti Blind (Flash)"), toggle("No Slowdown"), toggle("Infinity Lunge"), toggle("Aim Lock Hidden"),
			}),
		},
		right = {
			card("Veil Spear Aim Lock", {
				toggle("Aim Lock (Kamera)"),
				toggle("Aura CD Tracker", true),
				slider("FOV (derajat)", 30, 360, 120),
			}),
			card("Veil Spear Silent", {
				toggle("Silent Veil"),
				toggle("Show FOV", true),
				toggle("Show Laser", true),
				slider("Silent FOV (derajat)", 20, 170, 145),
				slider("Silent Max Range", 50, 500, 280, 10),
				slider("Prediction", 0, 2, 1.18, 0.01),
				toggle("Log Spear Payload"),
				note("Kamera tidak bergerak. Arah tombak diganti saat dilempar."),
			}),
			card("Silent Aim Flask (Cure)", { toggle("Silent Aim Flask (Cure)"), toggle("Enable Laser") }),
		},
	},
	{
		name = "ESP",
		left = {
			card("ESP Players", {
				toggle("Enable ESP", true), toggle("ESP Survivor", true),
				colorPick("Player Color", Color3.fromRGB(160, 90, 255)),
				toggle("ESP Killer", true),
				colorPick("Killer Color", Color3.fromRGB(255, 40, 40)),
				toggle("Mode Outline"), toggle("ESP Hook Count"), toggle("ESP Name", true), toggle("ESP Distance", true),
				toggle("ESP Health State"), toggle("ESP Zombie", true),
				colorPick("SCP Color", Color3.fromRGB(255, 255, 0)),
				toggle("ESP Item Icon"), toggle("Killer Warn", true),
			}),
			card("ESP Maps", {
				toggle("Generator", true), colorPick("Generator Color", Color3.fromRGB(255, 255, 255)),
				toggle("Gen Name and Progress", true),
				toggle("Pallet", true), colorPick("Pallet Color", Color3.fromRGB(0, 180, 60)),
				toggle("Window / Vault", true), colorPick("Window Color", Color3.fromRGB(255, 255, 255)),
				toggle("Hook", true), colorPick("Hook Color", Color3.fromRGB(0, 180, 60)),
				toggle("Exit Gate", true), colorPick("Gate Color", Color3.fromRGB(255, 255, 255)),
				toggle("ESP Trap"), colorPick("Bear Trap Color", Color3.fromRGB(0, 200, 255)),
				toggle("ESP Pumpkin"), colorPick("Pumpkin Color", Color3.fromRGB(255, 154, 0)),
			}),
		},
		right = {
			card("Info Player", {
				toggle("FPS + Ping"), toggle("Next Killer"), toggle("Next Map"),
				toggle("Stun Indicator"), toggle("Show Killer Perks"),
			}),
			card("World Effects", {
				toggle("Full Bright"), toggle("No Fog"), toggle("No Shadow"),
				toggle("Low Graphics"), toggle("Clean Sky"), slider("Time Of Day", 0, 24, 14),
			}),
		},
	},
	{
		name = "Teleport",
		left = {
			card("Teleport Players", {
				dropdown("Pilih Player", { "None" }),
				button("Refresh player"), button("Teleport ke player dipilih"),
			}),
		},
		right = {
			card("Teleport Maps", {
				button("TP generator"), button("TP hook (loop)"), button("TP gate (loop)"),
				button("TP pallet (loop)"), button("TP window (loop)"), button("Refresh map"),
			}),
		},
	},
	{
		name = "Config",
		left = {
			card("Config Manager", {
				textBox("Config Name", "my config"),
				dropdown("Configs", { "none" }),
				note("autoload: none"),
				button("Save config"), button("Load config"), button("Delete config"),
			}),
		},
		right = {
			card("Misc Player", {
				toggle("Copy Avatar GUI"), toggle("Fly GUI"), toggle("Noclip"),
				toggle("Enable Speed Boost"), slider("Speed Boost Value", 1, 10, 2),
			}),
			card("Appearance", {
				toggle("Video background", true),
				slider("Overlay darkness", 50, 95, 78),
			}),
		},
	},
}

-- Page builders.
local function createScrollPage()
	local page = create("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = colors.accent,
		VerticalScrollBarInset = Enum.ScrollBarInset.None,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = autoY,
		Visible = false,
	}, pagesHolder)
	return page
end

local function createColumns(page)
	local content = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = autoY, BackgroundTransparency = 1 }, page)
	create("UIPadding", {
		PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
	}, content)

	local holder = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = autoY, BackgroundTransparency = 1 }, content)
	create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, 8),
		SortOrder = layoutOrder,
	}, holder)

	local columns = {}
	for index = 1, 2 do
		local column = create("Frame", {
			Size = UDim2.new(0.5, -4, 0, 0),
			AutomaticSize = autoY,
			BackgroundTransparency = 1,
			LayoutOrder = index,
		}, holder)
		create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = layoutOrder }, column)
		columns[index] = column
	end

	return columns[1], columns[2]
end

-- A collapsible card holding rows.
local function buildCard(column, tabName, cardData)
	local cardFrame = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = autoY,
		BackgroundColor3 = colors.window,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
	}, column)
	round(cardFrame, 8)
	stroke(cardFrame, colors.line)
	create("UIListLayout", { SortOrder = layoutOrder }, cardFrame)

	local headerButton = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
	}, cardFrame)

	local titleLabel = createLabel(headerButton, cardData.title, UDim2.new(1, -30, 1, 0))
	titleLabel.Position = UDim2.fromOffset(10, 0)
	titleLabel.Font = Enum.Font.GothamBold

	local arrow = create("TextLabel", {
		Size = UDim2.fromOffset(20, 30),
		Position = UDim2.new(1, -30, 0, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = colors.muted,
		Text = "v",
	}, headerButton)

	create("Frame", { Size = UDim2.new(1, 0, 0, 1), LayoutOrder = 2, BackgroundColor3 = colors.line, BorderSizePixel = 0 }, cardFrame)

	local body = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = autoY, LayoutOrder = 3, BackgroundTransparency = 1 }, cardFrame)
	create("UIPadding", {
		PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
	}, body)
	create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = layoutOrder }, body)

	headerButton.MouseButton1Click:Connect(function()
		body.Visible = not body.Visible
		arrow.Text = body.Visible and "v" or ">"
	end)

	for _, row in ipairs(cardData.rows) do
		builders[row.kind](body, row, row.key or (tabName .. "." .. row.text))
	end
end

-- Info tab: welcome text, Discord button and owner.
local function buildInfoPage(page)
	local infoCard = create("Frame", {
		Size = UDim2.new(1, -16, 1, -16),
		Position = UDim2.fromOffset(8, 8),
		BackgroundTransparency = 1,
	}, page)
	round(infoCard, 8)
	stroke(infoCard, colors.line)
	create("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 8),
		SortOrder = layoutOrder,
	}, infoCard)

	local infoLogo = createLogo(infoCard, 56, 14)
	infoLogo.LayoutOrder = 1

	create("TextLabel", {
		LayoutOrder = 2,
		Size = UDim2.fromOffset(280, 26),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 20,
		TextColor3 = colors.text,
		Text = "SELAMAT BERMAIN",
	}, infoCard)

	local copyButton = create("TextButton", {
		LayoutOrder = 3,
		Size = UDim2.fromOffset(210, 32),
		BackgroundColor3 = colors.row,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = colors.bright,
		Text = "COPY LINK DC",
	}, infoCard)
	round(copyButton, 6)
	stroke(copyButton, colors.line)

	local feedback = create("TextLabel", {
		LayoutOrder = 4,
		Size = UDim2.fromOffset(210, 14),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = colors.dim,
		Text = "",
	}, infoCard)

	create("TextLabel", {
		LayoutOrder = 5,
		Size = UDim2.fromOffset(210, 18),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = colors.muted,
		RichText = true,
		Text = 'Owner  <font color="rgb(241,222,222)"><b>' .. OWNER_NAME .. "</b></font>",
	}, infoCard)

	copyButton.MouseButton1Click:Connect(function()
		local clip = setclipboard or toclipboard
		if clip then
			pcall(clip, DISCORD_LINK)
			feedback.Text = "Link DC tersalin"
		else
			warn(DISCORD_LINK)
			feedback.Text = "Executor tidak support clipboard"
		end

		task.delay(1.6, function()
			feedback.Text = ""
		end)
	end)
end

-- Search only filters the tab that is open.
local function applySearch()
	local query = searchBox.Text:lower()
	for _, entry in ipairs(registries[currentTab] or {}) do
		entry.frame.Visible = query == "" or entry.text:find(query, 1, true) ~= nil
	end
end

local function selectTab(name)
	currentTab = name
	headerTitle.Text = name

	for pageName, page in pairs(pages) do
		page.Visible = pageName == name
	end

	for tabName, entry in pairs(tabButtons) do
		local active = tabName == name
		entry.button.BackgroundTransparency = active and 0 or 1
		entry.button.TextColor3 = active and colors.text or colors.muted
		entry.bar.Visible = active
	end

	applySearch()
end

searchBox:GetPropertyChangedSignal("Text"):Connect(applySearch)

-- Build every tab, its page and its sidebar button.
for index, tab in ipairs(tabs) do
	activeRegistry = {}
	registries[tab.name] = activeRegistry

	local page
	if tab.info then
		page = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false }, pagesHolder)
		buildInfoPage(page)
	else
		page = createScrollPage()
		local left, right = createColumns(page)
		for _, cardData in ipairs(tab.left or {}) do
			buildCard(left, tab.name, cardData)
		end
		for _, cardData in ipairs(tab.right or {}) do
			buildCard(right, tab.name, cardData)
		end
	end
	pages[tab.name] = page

	local navButton = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 28),
		LayoutOrder = index,
		BackgroundColor3 = colors.row,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = colors.muted,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = tab.name,
	}, nav)
	round(navButton, 6)
	create("UIPadding", { PaddingLeft = UDim.new(0, 12) }, navButton)

	local bar = create("Frame", {
		Size = UDim2.new(0, 2, 1, -12),
		Position = UDim2.fromOffset(-10, 6),
		BackgroundColor3 = colors.accent,
		BorderSizePixel = 0,
		Visible = false,
	}, navButton)

	tabButtons[tab.name] = { button = navButton, bar = bar }
	navButton.MouseButton1Click:Connect(function()
		selectTab(tab.name)
	end)
end

selectTab("Info")

-- Public API for your own feature code.

---Run a function whenever a row changes. Buttons call it with no value.
---@param key string
---@param callback function
---@param runNow boolean
function Hub.on(key, callback, runNow)
	if not elements[key] then
		return warn("Unknown key: " .. key)
	end

	callbacks[key] = callback
	if runNow and flags[key] ~= nil then
		task.spawn(callback, flags[key])
	end
end

---Change a row from code. Pass silent = true to skip its callback.
function Hub.set(key, value, silent)
	local element = elements[key]
	if element and element.set then
		element.set(value, silent)
	end
end

---Replace the choices of a dropdown, for example a player list.
function Hub.setOptions(key, list)
	local element = elements[key]
	if element and element.setOptions then
		element.setOptions(list)
	end
end

---List every key you can hook.
function Hub.listKeys()
	local keys = {}
	for key in pairs(elements) do
		table.insert(keys, key)
	end
	table.sort(keys)
	return keys
end

function Hub.destroy()
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end

	gui:Destroy()
	shared.BintangX6LoccHub = nil
end

shared.BintangX6LoccHub = Hub

-- Appearance hooks.
Hub.on("Config.Video background", function(enabled)
	videoEnabled = enabled
	applyVideo()
end)

Hub.on("Config.Overlay darkness", function(value)
	overlay.BackgroundTransparency = 1 - value / 100
end)


-- BUILT-IN FEATURES. These are already connected to the UI rows.
local function setupFeatures()
	local runService = game:GetService("RunService")
	local httpService = game:GetService("HttpService")
	local statsService = game:GetService("Stats")

	local FLY_SPEED = 60
	local CONFIG_FOLDER = "BintangX6LoccHub/configs"

	-- Original lighting values, restored when a toggle turns off.
	local original = {
		Brightness = lightingService.Brightness,
		Ambient = lightingService.Ambient,
		OutdoorAmbient = lightingService.OutdoorAmbient,
		FogEnd = lightingService.FogEnd,
		FogStart = lightingService.FogStart,
		GlobalShadows = lightingService.GlobalShadows,
	}
	local originalMaxZoom = localPlayer.CameraMaxZoomDistance
	local timeTouched = false

	-- World effects.
	local atmosphereDensity

	Hub.on("ESP.Full Bright", function(enabled)
		if not enabled then
			lightingService.Brightness = original.Brightness
			lightingService.Ambient = original.Ambient
			lightingService.OutdoorAmbient = original.OutdoorAmbient
		end
	end)

	Hub.on("ESP.No Fog", function(enabled)
		local atmosphere = lightingService:FindFirstChildOfClass("Atmosphere")
		if enabled then
			atmosphereDensity = atmosphere and atmosphere.Density
		else
			lightingService.FogEnd = original.FogEnd
			lightingService.FogStart = original.FogStart
			if atmosphere and atmosphereDensity then
				atmosphere.Density = atmosphereDensity
			end
		end
	end)

	Hub.on("ESP.No Shadow", function(enabled)
		lightingService.GlobalShadows = enabled and false or original.GlobalShadows
	end)

	local disabledEffects = {}

	Hub.on("ESP.Low Graphics", function(enabled)
		pcall(function()
			settings().Rendering.QualityLevel = enabled and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
		end)

		if enabled then
			for _, effect in ipairs(lightingService:GetChildren()) do
				if effect:IsA("PostEffect") and effect.Enabled then
					effect.Enabled = false
					table.insert(disabledEffects, effect)
				end
			end
		else
			for _, effect in ipairs(disabledEffects) do
				effect.Enabled = true
			end
			table.clear(disabledEffects)
		end
	end)

	local savedSky = {}

	Hub.on("ESP.Clean Sky", function(enabled)
		local atmosphere = lightingService:FindFirstChildOfClass("Atmosphere")
		if atmosphere then
			if enabled then
				savedSky.haze, savedSky.glare = atmosphere.Haze, atmosphere.Glare
				atmosphere.Haze, atmosphere.Glare = 0, 0
			elseif savedSky.haze then
				atmosphere.Haze, atmosphere.Glare = savedSky.haze, savedSky.glare
			end
		end

		local clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
		if clouds then
			if enabled then
				savedSky.clouds = clouds.Enabled
				clouds.Enabled = false
			else
				clouds.Enabled = savedSky.clouds ~= false
			end
		end
	end)

	Hub.on("ESP.Time Of Day", function()
		timeTouched = true
	end)

	-- Camera.
	Hub.on("Exclusive.Max Zoom", function(enabled)
		localPlayer.CameraMaxZoomDistance = enabled and 100000 or originalMaxZoom
	end)

	-- Crosshair.
	local crosshair = create("Frame", {
		Name = "Crosshair",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1,
		Visible = false,
	}, gui)

	local function renderCrosshair()
		crosshair:ClearAllChildren()
		crosshair.Visible = flags["Exclusive.Enable Crosshair"] == true

		local size = flags["Exclusive.Size"] or 8
		local color = flags["Exclusive.Crosshair Color"] or Color3.fromRGB(255, 230, 0)
		local style = flags["Exclusive.Style"]

		local function part(width, height, isRound)
			local frame = create("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(width, height),
				BackgroundColor3 = color,
				BorderSizePixel = 0,
			}, crosshair)
			if isRound then
				round(frame, 100)
			end
			return frame
		end

		if style == "Cross" then
			part(size * 2, 2)
			part(2, size * 2)
		elseif style == "Circle" then
			local ring = part(size * 2, size * 2, true)
			ring.BackgroundTransparency = 1
			stroke(ring, color, 2)
		else
			part(size, size, true)
		end
	end

	for _, key in ipairs({ "Exclusive.Enable Crosshair", "Exclusive.Crosshair Color", "Exclusive.Style", "Exclusive.Size" }) do
		Hub.on(key, renderCrosshair)
	end
	renderCrosshair()

	-- FPS and ping counter.
	local fpsLabel = create("TextLabel", {
		Position = UDim2.fromOffset(56, 100),
		Size = UDim2.fromOffset(130, 20),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.4,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = Color3.new(1, 1, 1),
		Visible = false,
	}, gui)
	round(fpsLabel, 4)

	Hub.on("ESP.FPS + Ping", function(enabled)
		fpsLabel.Visible = enabled
	end)

	local frames, lastTick = 0, os.clock()

	table.insert(connections, runService.RenderStepped:Connect(function()
		if flags["Exclusive.Camera FOV"] then
			workspace.CurrentCamera.FieldOfView = flags["Exclusive.FOV Value"]
		end

		frames += 1
		if os.clock() - lastTick >= 1 then
			local ok, ping = pcall(function()
				return statsService.Network.ServerStatsItem["Data Ping"]:GetValue()
			end)
			fpsLabel.Text = string.format("FPS %d  |  Ping %s", frames, ok and math.floor(ping) .. "ms" or "?")
			frames, lastTick = 0, os.clock()
		end
	end))

	-- Per-frame lighting, movement, fly and speed boost.
	local wasFlying = false

	table.insert(connections, runService.Heartbeat:Connect(function(deltaTime)
		if flags["ESP.Full Bright"] then
			lightingService.Brightness = 2
			lightingService.Ambient = Color3.new(1, 1, 1)
			lightingService.OutdoorAmbient = Color3.new(1, 1, 1)
		end

		if flags["ESP.No Fog"] then
			lightingService.FogEnd = 1e9
			local atmosphere = lightingService:FindFirstChildOfClass("Atmosphere")
			if atmosphere then
				atmosphere.Density = 0
			end
		end

		if timeTouched then
			lightingService.ClockTime = flags["ESP.Time Of Day"]
		end

		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not (humanoid and root) then
			return
		end

		local flying = flags["Config.Fly GUI"]
		if flying then
			local cameraCFrame = workspace.CurrentCamera.CFrame
			local localMove = cameraCFrame:VectorToObjectSpace(humanoid.MoveDirection)
			local velocity = cameraCFrame.RightVector * localMove.X + cameraCFrame.LookVector * -localMove.Z
			humanoid.PlatformStand = true
			root.AssemblyLinearVelocity = velocity * FLY_SPEED
		elseif wasFlying then
			humanoid.PlatformStand = false
		end
		wasFlying = flying

		if flags["Config.Enable Speed Boost"] and not flying then
			local boost = flags["Config.Speed Boost Value"] - 1
			root.CFrame = root.CFrame + humanoid.MoveDirection * humanoid.WalkSpeed * boost * deltaTime
		end
	end))

	table.insert(connections, runService.Stepped:Connect(function()
		if not flags["Config.Noclip"] then
			return
		end

		local character = localPlayer.Character
		if not character then
			return
		end

		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end))

	-- Teleport to a chosen player.
	local function refreshPlayers()
		local names = {}
		for _, player in ipairs(playersService:GetPlayers()) do
			if player ~= localPlayer then
				table.insert(names, player.Name)
			end
		end

		table.sort(names)
		if #names == 0 then
			names = { "None" }
		end

		Hub.setOptions("Teleport.Pilih Player", names)
		if not table.find(names, flags["Teleport.Pilih Player"]) then
			Hub.set("Teleport.Pilih Player", names[1], true)
		end
	end

	Hub.on("Teleport.Refresh player", refreshPlayers)

	Hub.on("Teleport.Teleport ke player dipilih", function()
		local target = playersService:FindFirstChild(tostring(flags["Teleport.Pilih Player"]))
		local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
		local myCharacter = localPlayer.Character
		local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")

		if targetRoot and myRoot then
			myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
		end
	end)

	table.insert(connections, playersService.PlayerAdded:Connect(refreshPlayers))
	table.insert(connections, playersService.PlayerRemoving:Connect(function()
		task.defer(refreshPlayers)
	end))
	refreshPlayers()

	-- Config save, load and delete.
	local function ensureConfigFolder()
		if makefolder and isfolder then
			if not isfolder("BintangX6LoccHub") then
				makefolder("BintangX6LoccHub")
			end
			if not isfolder(CONFIG_FOLDER) then
				makefolder(CONFIG_FOLDER)
			end
		end
	end

	local function refreshConfigs()
		local names = {}
		pcall(function()
			ensureConfigFolder()
			for _, path in ipairs(listfiles(CONFIG_FOLDER)) do
				local name = path:match("([^/\\]+)%.json$")
				if name then
					table.insert(names, name)
				end
			end
		end)

		table.sort(names)
		if #names == 0 then
			names = { "none" }
		end

		Hub.setOptions("Config.Configs", names)
		if not table.find(names, flags["Config.Configs"]) then
			Hub.set("Config.Configs", names[1], true)
		end
	end

	-- Colors become {r, g, b} tables so they can be saved as JSON.
	local function serializeFlags()
		local data = {}
		for key, value in pairs(flags) do
			if key ~= "Config.Config Name" and key ~= "Config.Configs" and key ~= "Teleport.Pilih Player" then
				if typeof(value) == "Color3" then
					data[key] = { color = { value.R, value.G, value.B } }
				else
					data[key] = value
				end
			end
		end
		return data
	end

	Hub.on("Config.Save config", function()
		local name = tostring(flags["Config.Config Name"] or ""):gsub("[^%w _%-]", "")
		if name == "" then
			return warn("Isi Config Name dulu.")
		end

		local ok = pcall(function()
			ensureConfigFolder()
			writefile(CONFIG_FOLDER .. "/" .. name .. ".json", httpService:JSONEncode(serializeFlags()))
		end)

		if ok then
			refreshConfigs()
			Hub.set("Config.Configs", name, true)
		end
	end)

	Hub.on("Config.Load config", function()
		pcall(function()
			local data = httpService:JSONDecode(readfile(CONFIG_FOLDER .. "/" .. flags["Config.Configs"] .. ".json"))
			for key, value in pairs(data) do
				if type(value) == "table" and value.color then
					value = Color3.new(value.color[1], value.color[2], value.color[3])
				end
				Hub.set(key, value)
			end
		end)
	end)

	Hub.on("Config.Delete config", function()
		pcall(function()
			delfile(CONFIG_FOLDER .. "/" .. flags["Config.Configs"] .. ".json")
		end)
		refreshConfigs()
	end)

	refreshConfigs()

	-- Put everything back when the hub closes.
	local baseDestroy = Hub.destroy

	function Hub.destroy()
		lightingService.Brightness = original.Brightness
		lightingService.Ambient = original.Ambient
		lightingService.OutdoorAmbient = original.OutdoorAmbient
		lightingService.FogEnd = original.FogEnd
		lightingService.FogStart = original.FogStart
		lightingService.GlobalShadows = original.GlobalShadows
		localPlayer.CameraMaxZoomDistance = originalMaxZoom

		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.PlatformStand = false
		end

		baseDestroy()
	end
end

setupFeatures()

-- ESP. Your logic, connected to the ESP tab. Trap and pumpkin are new.
local function setupEsp()
	local runService = game:GetService("RunService")
	local replicatedStorage = game:GetService("ReplicatedStorage")

	-- Highlights stop rendering after about 31 at once, so only the nearest are lit.
	local MAX_EXTRA_HIGHLIGHTS = 6
	local GENERATOR_DONE_COLOR = Color3.fromRGB(0, 180, 60)

	local Cache = { Generators = {}, Pallets = {}, Hooks = {}, Gates = {}, Windows = {}, SCPs = {}, Traps = {}, Pumpkins = {} }
	local itemsFolder = nil
	local lastScanTime = 0

	local function isKiller(player)
		return player and player.Team and player.Team.Name == "Killer"
	end

	-- A label needs a part to sit on, so models use their main part.
	local function labelPart(instance)
		if instance:IsA("Model") then
			return instance.PrimaryPart or instance:FindFirstChildWhichIsA("BasePart", true)
		end
		return instance
	end

	local function getItemsFolder()
		if not itemsFolder or not itemsFolder.Parent then
			itemsFolder = replicatedStorage:FindFirstChild("Items")
		end
		return itemsFolder
	end

	local function getItemIcon(name)
		local folder = getItemsFolder()
		if not folder then
			return nil
		end

		local item = folder:FindFirstChild(name)
		if not item then
			return nil
		end

		local texture
		pcall(function()
			texture = item.Texture or item.Image
		end)

		if texture and texture ~= "" then
			local id = tostring(texture):match("%d+")
			if id then
				return ("rbxthumb://type=Asset&id=%s&w=420&h=420"):format(id)
			end
		end

		return nil
	end

	-- Floating label with an optional icon, distance, subtext and health.
	local function createModernESP(parent, idName, config)
		local billboard = parent:FindFirstChild(idName)

		if not billboard then
			billboard = Instance.new("BillboardGui")
			billboard.Name = idName
			billboard.Parent = parent
			billboard.AlwaysOnTop = true
			billboard.Size = UDim2.new(0, 200, 0, 25)
			billboard.StudsOffset = Vector3.new(0, config.offsetY or 3.5, 0)

			local box = Instance.new("Frame")
			box.Name = "Box"
			box.AutomaticSize = Enum.AutomaticSize.X
			box.Size = UDim2.new(0, 0, 0, 15)
			box.Position = UDim2.new(0.5, 0, 0, 0)
			box.AnchorPoint = Vector2.new(0.5, 0)
			box.BackgroundTransparency = 1
			box.BorderSizePixel = 0
			box.ZIndex = 2
			box.Parent = billboard

			local layout = Instance.new("UIListLayout", box)
			layout.FillDirection = Enum.FillDirection.Horizontal
			layout.VerticalAlignment = Enum.VerticalAlignment.Center
			layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			layout.Padding = UDim.new(0, 3)
			layout.SortOrder = Enum.SortOrder.LayoutOrder

			local icon = Instance.new("ImageLabel", box)
			icon.Name = "Icon"
			icon.Size = UDim2.new(0, 12, 0, 12)
			icon.BackgroundTransparency = 1
			icon.ZIndex = 3
			icon.LayoutOrder = 1
			icon.Visible = false

			local text = Instance.new("TextLabel", box)
			text.Name = "Text"
			text.AutomaticSize = Enum.AutomaticSize.X
			text.Size = UDim2.new(0, 0, 1, 0)
			text.BackgroundTransparency = 1
			text.Font = Enum.Font.GothamBlack
			text.TextSize = 11
			text.ZIndex = 3
			text.LayoutOrder = 2
			text.RichText = true
			text.TextXAlignment = Enum.TextXAlignment.Center
			text.TextYAlignment = Enum.TextYAlignment.Center
			text.TextStrokeTransparency = 0
			text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		end

		local iconLabel = billboard.Box:FindFirstChild("Icon")
		if iconLabel then
			if config.icon and config.icon ~= "" then
				iconLabel.Image = config.icon
				iconLabel.Visible = true
			else
				iconLabel.Visible = false
			end
		end

		local color = config.color or Color3.fromRGB(255, 255, 255)
		local hex = string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
		local text

		if config.distance then
			text = string.format("<font color='%s'><b>%s</b></font> <font color='#FFFFFF'>[%dm]</font>", hex, config.name, config.distance)
		elseif config.subtext then
			text = string.format("<font color='%s'><b>%s</b></font> <font color='#FFFFFF'>%s</font>", hex, config.name, config.subtext)
		else
			text = string.format("<font color='%s'><b>%s</b></font>", hex, config.name)
		end

		if config.health then
			text ..= string.format(" <font color='#FFD84D'>%s</font>", config.health)
		end

		billboard.Box.Text.Text = text
	end

	local function destroyChild(parent, name)
		local child = parent and parent:FindFirstChild(name)
		if child then
			child:Destroy()
		end
	end

	local function clearEsp(kind)
		if kind == "Player" or kind == "Killer" then
			local highlightName = kind == "Player" and "PEH" or "KEH"
			local textName = kind == "Player" and "PE_Text" or "KE_Text"
			for _, player in ipairs(playersService:GetPlayers()) do
				destroyChild(player.Character, highlightName)
				destroyChild(player.Character, textName)
			end
		elseif kind == "Generator" then
			for _, entry in pairs(Cache.Generators) do
				if entry.model and entry.model.Parent then
					destroyChild(entry.model, "GEH")
					destroyChild(entry.model, "GE_Text")
				end
			end
		elseif kind == "Pallet" then
			for _, model in pairs(Cache.Pallets) do
				destroyChild(model, "PalletEH")
			end
		elseif kind == "Hook" then
			for _, model in pairs(Cache.Hooks) do
				destroyChild(model, "HookEH")
			end
		elseif kind == "Window" then
			for _, model in pairs(Cache.Windows) do
				destroyChild(model, "WindowEH")
			end
		elseif kind == "Gate" then
			for _, model in pairs(Cache.Gates) do
				destroyChild(model, "GateEH")
			end
		elseif kind == "SCP" then
			for _, model in pairs(Cache.SCPs) do
				destroyChild(model, "SCPEH")
			end
		elseif kind == "Trap" then
			for instance in pairs(Cache.Traps) do
				destroyChild(instance, "TrapEH")
				destroyChild(labelPart(instance), "TrapText")
			end
		elseif kind == "Pumpkin" then
			for instance in pairs(Cache.Pumpkins) do
				destroyChild(instance, "PumpkinEH")
			end
		end
	end

	local function removeKillerWarn()
		local character = localPlayer.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		destroyChild(root, "KillerWarn")
	end

	local function clearAllEsp()
		for _, kind in ipairs({ "Player", "Killer", "Generator", "Pallet", "Hook", "Gate", "SCP", "Window", "Trap", "Pumpkin" }) do
			clearEsp(kind)
		end
		removeKillerWarn()
	end

	-- Find everything inside workspace.Map.
	local function scanMap()
		if tick() - lastScanTime < 2 then
			return
		end
		lastScanTime = tick()

		table.clear(Cache.Generators)
		table.clear(Cache.Windows)
		table.clear(Cache.Pallets)
		table.clear(Cache.Hooks)
		table.clear(Cache.Gates)
		table.clear(Cache.SCPs)

		local mapFolder = workspace:FindFirstChild("Map")
		if not mapFolder then
			return
		end

		local descendants = mapFolder:GetDescendants()
		for index = 1, #descendants do
			if index % 300 == 0 then
				task.wait()
			end

			local instance = descendants[index]
			if instance:IsA("Model") then
				local lowered = string.lower(instance.Name)

				if lowered == "generator" then
					local part = instance.PrimaryPart or instance:FindFirstChildWhichIsA("BasePart")
					if part then
						table.insert(Cache.Generators, { model = instance, part = part })
					end
				elseif lowered == "hook" then
					if instance:FindFirstChild("HookPoint") then
						table.insert(Cache.Hooks, instance)
					end
				elseif lowered == "gate" then
					if instance:FindFirstChild("ExitLever") then
						table.insert(Cache.Gates, instance)
					end
				elseif lowered == "window" then
					table.insert(Cache.Windows, instance)
				elseif string.match(lowered, "^scp") then
					table.insert(Cache.SCPs, instance)
				elseif string.find(lowered, "pallet", 1, true) and not instance:FindFirstChildWhichIsA("Model") and not table.find(Cache.Pallets, instance) then
					table.insert(Cache.Pallets, instance)
				end
			elseif instance:IsA("BasePart") and instance.Name == "PrimaryPartPallet" then
				local model = instance.Parent
				if model and not table.find(Cache.Pallets, model) then
					table.insert(Cache.Pallets, model)
				end
			end
		end
	end

	-- Traps and pumpkins can appear anywhere, so they are tracked across the whole workspace.
	local extras = {
		{
			cache = Cache.Traps, highlight = "TrapEH", flag = "ESP.ESP Trap", color = "ESP.Bear Trap Color",
			label = "TRAP", labelName = "TrapText",
			match = function(lowered)
				return lowered:find("trap", 1, true) and not lowered:find("trapdoor", 1, true)
			end,
		},
		{
			cache = Cache.Pumpkins, highlight = "PumpkinEH", flag = "ESP.ESP Pumpkin", color = "ESP.Pumpkin Color",
			match = function(lowered)
				return lowered:find("pumpkin", 1, true)
			end,
		},
	}

	local function addExtra(instance)
		if not (instance:IsA("Model") or instance:IsA("BasePart")) then
			return
		end

		local lowered = instance.Name:lower()
		for _, extra in ipairs(extras) do
			if extra.match(lowered) and not extra.cache[instance] then
				if playersService:GetPlayerFromCharacter(instance) then
					return
				end

				-- Skip children of something already tracked, and player characters.
				local parentModel = instance:FindFirstAncestorOfClass("Model")
				if parentModel and (extra.cache[parentModel] or playersService:GetPlayerFromCharacter(parentModel)) then
					return
				end

				extra.cache[instance] = true
			end
		end
	end

	local function removeExtra(instance)
		for _, extra in ipairs(extras) do
			extra.cache[instance] = nil
		end
	end

	local function scanExtras()
		local count = 0
		for _, instance in ipairs(workspace:GetDescendants()) do
			addExtra(instance)
			count += 1
			if count % 400 == 0 then
				task.wait()
			end
		end
	end

	-- Highlight only the nearest traps or pumpkins.
	local function updateExtraEsp(extra, myRoot)
		local entries = {}

		for instance in pairs(extra.cache) do
			if instance.Parent then
				local position = instance:IsA("Model") and instance:GetPivot().Position or instance.Position
				local distance = myRoot and (position - myRoot.Position).Magnitude or 0
				table.insert(entries, { instance = instance, distance = distance })
			else
				extra.cache[instance] = nil
			end
		end

		table.sort(entries, function(a, b)
			return a.distance < b.distance
		end)

		for index, entry in ipairs(entries) do
			local instance = entry.instance
			local highlight = instance:FindFirstChild(extra.highlight)

			if index <= MAX_EXTRA_HIGHLIGHTS then
				if not highlight then
					highlight = Instance.new("Highlight")
					highlight.Name = extra.highlight
					highlight.Adornee = instance
					highlight.Parent = instance
				end

				local color = flags[extra.color]
				highlight.FillColor = color
				highlight.OutlineColor = color
				highlight.FillTransparency = flags["ESP.Mode Outline"] and 1 or 0.15
				highlight.OutlineTransparency = 0

				if extra.label then
					local part = labelPart(instance)
					if part then
						createModernESP(part, extra.labelName, {
							name = extra.label,
							distance = math.floor(entry.distance),
							color = color,
							offsetY = 2,
						})
					end
				end
			else
				if highlight then
					highlight:Destroy()
				end
				if extra.label then
					destroyChild(labelPart(instance), extra.labelName)
				end
			end
		end
	end

	local function updatePlayerEsp()
		local myCharacter = localPlayer.Character
		local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")

		-- Warn survivors when the killer is close.
		if flags["ESP.Killer Warn"] and myRoot and localPlayer.Team and localPlayer.Team.Name == "Survivors" then
			local warnGui = myRoot:FindFirstChild("KillerWarn")
			local closest = math.huge

			for _, player in ipairs(playersService:GetPlayers()) do
				if player ~= localPlayer and isKiller(player) and player.Character then
					local killerRoot = player.Character:FindFirstChild("HumanoidRootPart")
					if killerRoot then
						local distance = (killerRoot.Position - myRoot.Position).Magnitude
						if distance < closest then
							closest = distance
						end
					end
				end
			end

			if closest <= 80 then
				if not warnGui then
					warnGui = Instance.new("BillboardGui")
					warnGui.Name = "KillerWarn"
					warnGui.Size = UDim2.new(0, 30, 0, 30)
					warnGui.AlwaysOnTop = true
					warnGui.StudsOffset = Vector3.new(0, 4, 0)
					warnGui.Parent = myRoot

					local label = Instance.new("TextLabel")
					label.Name = "WarnText"
					label.Size = UDim2.new(1, 0, 1, 0)
					label.BackgroundTransparency = 1
					label.TextScaled = true
					label.TextStrokeTransparency = 0
					label.Font = Enum.Font.GothamBlack
					label.Parent = warnGui
				end

				local label = warnGui:FindFirstChild("WarnText")
				if label then
					if closest <= 40 then
						label.Text = "!!"
						label.TextColor3 = Color3.fromRGB(255, 0, 0)
					else
						label.Text = "!"
						label.TextColor3 = Color3.fromRGB(255, 255, 0)
					end
				end
			elseif warnGui then
				warnGui:Destroy()
			end
		else
			removeKillerWarn()
		end

		if flags["ESP.ESP Survivor"] or flags["ESP.ESP Killer"] then
			for _, player in ipairs(playersService:GetPlayers()) do
				local character = player.Character
				if player ~= localPlayer and character then
					local killer = isKiller(player)
					local head = character:FindFirstChild("Head")

					if head and ((not killer and flags["ESP.ESP Survivor"]) or (killer and flags["ESP.ESP Killer"])) then
						local distance = myRoot and math.floor((head.Position - myRoot.Position).Magnitude) or 0
						local color = killer and flags["ESP.Killer Color"] or flags["ESP.Player Color"]
						local highlightName = killer and "KEH" or "PEH"
						local textName = killer and "KE_Text" or "PE_Text"

						local highlight = character:FindFirstChild(highlightName)
						if not highlight then
							highlight = Instance.new("Highlight")
							highlight.Name = highlightName
							highlight.Parent = character
						end

						highlight.FillColor = color
						highlight.OutlineColor = color
						highlight.FillTransparency = flags["ESP.Mode Outline"] and 1 or 0.5
						highlight.OutlineTransparency = 0

						if flags["ESP.ESP Name"] then
							local icon
							if flags["ESP.ESP Item Icon"] and not killer then
								local itemName = player:GetAttribute("EquippedItem")
								if itemName and itemName ~= "" then
									icon = getItemIcon(itemName)
								end
							end

							local health
							if flags["ESP.ESP Health State"] then
								local humanoid = character:FindFirstChildOfClass("Humanoid")
								if humanoid and humanoid.MaxHealth > 0 then
									health = math.floor(humanoid.Health / humanoid.MaxHealth * 100) .. "%"
								end
							end

							createModernESP(character, textName, {
								name = player.Name,
								distance = flags["ESP.ESP Distance"] and distance or nil,
								color = color,
								icon = icon,
								health = health,
							})
						else
							destroyChild(character, textName)
						end
					end
				end
			end
		end
	end

	-- SCP: only the ones that are alive and walking at speed 9.
	local function updateScpEsp()
		if not flags["ESP.ESP Zombie"] then
			return
		end

		for _, model in ipairs(Cache.SCPs) do
			if model and model.Parent then
				local humanoid = model:FindFirstChildOfClass("Humanoid")
				local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model.PrimaryPart

				if humanoid and root and humanoid.Health > 0 and math.floor(humanoid.WalkSpeed) == 9 then
					local color = flags["ESP.SCP Color"]
					local highlight = model:FindFirstChild("SCPEH")
					if not highlight then
						highlight = Instance.new("Highlight")
						highlight.Name = "SCPEH"
						highlight.Parent = model
					end

					highlight.FillColor = color
					highlight.OutlineColor = color
					highlight.FillTransparency = flags["ESP.Mode Outline"] and 1 or 0.5
					highlight.OutlineTransparency = 0
				else
					destroyChild(model, "SCPEH")
				end
			end
		end
	end

	-- Pallet: one box around the whole model. Boxes have no 31 limit like highlights.
	local function applyPalletBox(model, outline)
		local anchor = model:FindFirstChild("PrimaryPartPallet") or (model:IsA("Model") and model.PrimaryPart) or model:FindFirstChildWhichIsA("BasePart", true)
		if not anchor or not anchor:IsA("BasePart") then
			return
		end

		local box = model:FindFirstChild("PalletEH")
		if box and not box:IsA("BoxHandleAdornment") then
			box:Destroy()
			box = nil
		end

		if not box then
			box = Instance.new("BoxHandleAdornment")
			box.Name = "PalletEH"
			box.AlwaysOnTop = true
			box.ZIndex = 5
			box.Parent = model
		end

		local boxCFrame, boxSize = anchor.CFrame, anchor.Size
		if model:IsA("Model") then
			boxCFrame, boxSize = model:GetBoundingBox()
		end

		box.Adornee = anchor
		box.CFrame = anchor.CFrame:ToObjectSpace(boxCFrame)
		box.Size = boxSize
		box.Color3 = flags["ESP.Pallet Color"]
		box.Transparency = outline and 0.7 or 0.3
	end

	-- Generators, pallets, windows, hooks and gates.
	local function updateStaticEsp()
		local outline = flags["ESP.Mode Outline"]

		local function applyHighlight(model, name, color, adornee)
			local highlight = model:FindFirstChild(name)
			if not highlight then
				highlight = Instance.new("Highlight")
				highlight.Name = name
				highlight.Parent = model
			end

			if adornee then
				highlight.Adornee = model
			end

			highlight.FillColor = color
			highlight.OutlineColor = color
			highlight.FillTransparency = outline and 1 or 0.5
			highlight.OutlineTransparency = 0
		end

		if flags["ESP.Generator"] then
			for _, entry in pairs(Cache.Generators) do
				local model = entry.model
				if model and model.Parent then
					local progress = math.floor(model:GetAttribute("RepairProgress") or 0)
					local color = progress >= 100 and GENERATOR_DONE_COLOR or flags["ESP.Generator Color"]
					applyHighlight(model, "GEH", color)

					if flags["ESP.Gen Name and Progress"] then
						local subtext = progress >= 100 and "100%" or string.format("%d%%", progress)
						createModernESP(model, "GE_Text", { name = "GEN", subtext = subtext, color = color })
					else
						destroyChild(model, "GE_Text")
					end
				end
			end
		end

		if flags["ESP.Pallet"] then
			for _, model in pairs(Cache.Pallets) do
				if model and model.Parent then
					applyPalletBox(model, outline)
				end
			end
		end

		if flags["ESP.Window / Vault"] then
			for _, model in ipairs(Cache.Windows) do
				if model and model.Parent then
					local part = model:FindFirstChild("Bottom") or model:FindFirstChildWhichIsA("BasePart")
					if part then
						local box = model:FindFirstChild("WindowEH")
						if not box then
							box = Instance.new("BoxHandleAdornment")
							box.Name = "WindowEH"
							box.Parent = model
							box.AlwaysOnTop = true
							box.ZIndex = 5
						end

						box.Adornee = part
						box.Size = part.Size
						box.Color3 = flags["ESP.Window Color"]
						box.Transparency = outline and 0.7 or 0.15
					end
				end
			end
		end

		if flags["ESP.Hook"] then
			for _, model in ipairs(Cache.Hooks) do
				if model and model.Parent then
					applyHighlight(model, "HookEH", flags["ESP.Hook Color"])
				end
			end
		end

		if flags["ESP.Exit Gate"] then
			for _, model in ipairs(Cache.Gates) do
				if model and model.Parent then
					applyHighlight(model, "GateEH", flags["ESP.Gate Color"], true)
				end
			end
		end
	end

	local function updateExtras()
		local character = localPlayer.Character
		local myRoot = character and character:FindFirstChild("HumanoidRootPart")

		for _, extra in ipairs(extras) do
			if flags[extra.flag] then
				updateExtraEsp(extra, myRoot)
			end
		end
	end

	-- Update a few times per second, only the parts that are switched on.
	local frameCounter = 0

	table.insert(connections, runService.Heartbeat:Connect(function()
		frameCounter += 1
		if not flags["ESP.Enable ESP"] or frameCounter % 5 ~= 0 then
			return
		end

		if flags["ESP.ESP Survivor"] or flags["ESP.ESP Killer"] or flags["ESP.ESP Name"] or flags["ESP.ESP Item Icon"] or flags["ESP.Killer Warn"] then
			updatePlayerEsp()
		end

		if flags["ESP.ESP Zombie"] then
			updateScpEsp()
		end

		if flags["ESP.Generator"] or flags["ESP.Pallet"] or flags["ESP.Hook"] or flags["ESP.Exit Gate"] or flags["ESP.Window / Vault"] then
			updateStaticEsp()
		end

		updateExtras()
	end))

	-- Clean up whatever a toggle was showing when it is switched off.
	local clearWhenOff = {
		["ESP.ESP Survivor"] = "Player",
		["ESP.ESP Killer"] = "Killer",
		["ESP.ESP Zombie"] = "SCP",
		["ESP.Generator"] = "Generator",
		["ESP.Pallet"] = "Pallet",
		["ESP.Hook"] = "Hook",
		["ESP.Exit Gate"] = "Gate",
		["ESP.Window / Vault"] = "Window",
		["ESP.ESP Trap"] = "Trap",
		["ESP.ESP Pumpkin"] = "Pumpkin",
	}

	for key, kind in pairs(clearWhenOff) do
		Hub.on(key, function(enabled)
			if not enabled then
				clearEsp(kind)
			end
		end)
	end

	Hub.on("ESP.Enable ESP", function(enabled)
		if not enabled then
			clearAllEsp()
		end
	end)

	Hub.on("ESP.Killer Warn", function(enabled)
		if not enabled then
			removeKillerWarn()
		end
	end)

	-- Rescan the map now, after a respawn, every minute and when a new Map appears.
	task.spawn(function()
		task.wait(2)
		scanMap()
	end)

	task.spawn(scanExtras)

	task.spawn(function()
		while gui.Parent do
			task.wait(60)
			if flags["ESP.Enable ESP"] then
				scanMap()
				updateStaticEsp()
				updatePlayerEsp()
				updateScpEsp()
			end
		end
	end)

	table.insert(connections, localPlayer.CharacterAdded:Connect(function()
		task.wait(1.5)
		scanMap()

		if flags["ESP.Enable ESP"] then
			task.wait(0.5)
			clearAllEsp()
			task.wait(0.2)
			updatePlayerEsp()
			updateScpEsp()
			updateStaticEsp()
		end
	end))

	table.insert(connections, workspace.ChildAdded:Connect(function(child)
		if child.Name == "Map" then
			task.wait(1)
			scanMap()
		end
	end))

	table.insert(connections, workspace.DescendantAdded:Connect(addExtra))
	table.insert(connections, workspace.DescendantRemoving:Connect(removeExtra))

	-- Remove every highlight and label when the hub closes.
	local baseDestroy = Hub.destroy

	function Hub.destroy()
		clearAllEsp()
		baseDestroy()
	end
end

setupEsp()

-- SKILL CHECK GENERATOR. Your logic, connected to the Survivor tab.
local function setupSkillCheck()
	local runService = game:GetService("RunService")
	local virtualInputManager = game:GetService("VirtualInputManager")
	local guiService = game:GetService("GuiService")
	local replicatedStorage = game:GetService("ReplicatedStorage")

	local busy = false
	local randomIsNormal = false

	-- King's Scourge switches Random mode to Normal until the check ends.
	task.spawn(function()
		local remotes = replicatedStorage:WaitForChild("Remotes", 10)
		local perks = remotes and remotes:WaitForChild("KillerPerks", 5)
		local scourge = perks and perks:WaitForChild("kingscourge", 5)
		local startEvent = scourge and scourge:WaitForChild("KingScourgeStart", 5)

		if startEvent then
			table.insert(connections, startEvent.OnClientEvent:Connect(function()
				if flags["Survivor.Skill Check Mode"] == "Random" then
					randomIsNormal = true
				end
			end))
		end
	end)

	-- The mobile action button that confirms a skill check.
	local function getActionTarget()
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		local mobile = playerGui and playerGui:FindFirstChild("Survivor-mob")
		local controls = mobile and mobile:FindFirstChild("Controls")
		return controls and (controls:FindFirstChild("action") or controls:FindFirstChild("check"))
	end

	-- Press the button with firesignal, then touch input, then the Space key.
	local function triggerSkillCheck()
		local button = getActionTarget()
		local usable = button and button:IsA("GuiObject") and button.Visible

		if usable and type(firesignal) == "function" then
			pcall(function()
				firesignal(button.MouseButton1Down)
				task.wait(0.005)
				firesignal(button.MouseButton1Up)
			end)
			return
		end

		if usable then
			pcall(function()
				local position, size = button.AbsolutePosition, button.AbsoluteSize
				local inset = guiService:GetGuiInset()
				local touchId = 8822 + math.random(1, 9999)
				local x = position.X + size.X / 2 + inset.X
				local y = position.Y + size.Y / 2 + inset.Y

				virtualInputManager:SendTouchEvent(touchId, 0, x, y)
				task.wait(0.005)
				virtualInputManager:SendTouchEvent(touchId, 2, x, y)
			end)
			return
		end

		pcall(function()
			virtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
			task.wait(0.005)
			virtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
		end)
	end

	local function pressButton()
		busy = true
		task.spawn(function()
			triggerSkillCheck()
			task.wait(0.05)
			busy = false
		end)
	end

	table.insert(connections, runService.Heartbeat:Connect(function()
		if not flags["Survivor.Auto Skill Check"] or busy then
			return
		end

		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		local prompt = playerGui and playerGui:FindFirstChild("SkillCheckPromptGui")
		if not prompt then
			return
		end

		local check = prompt:FindFirstChild("Check")
		if not check or not check.Visible then
			randomIsNormal = false
			return
		end

		local line, goal = check:FindFirstChild("Line"), check:FindFirstChild("Goal")
		if not line or not goal then
			return
		end

		local mode = flags["Survivor.Skill Check Mode"]
		local isInstant = mode == "Instant" or (mode == "Random" and not randomIsNormal)

		-- Instant: put the needle on the goal and confirm.
		if isInstant then
			line.Rotation = goal.Rotation + 109
			pressButton()
			return
		end

		-- Normal: wait until the needle is inside the zone.
		local isNormal = mode == "Normal" or (mode == "Random" and randomIsNormal)
		local lineRotation, goalRotation = line.Rotation % 360, goal.Rotation % 360
		local startRotation, endRotation

		if isNormal then
			startRotation = (goalRotation + 116) % 360
			endRotation = (goalRotation + 140) % 360
		else
			startRotation = (goalRotation + 102) % 360
			endRotation = (goalRotation + 116) % 360
		end

		local inZone
		if startRotation > endRotation then
			inZone = lineRotation >= startRotation or lineRotation <= endRotation
		else
			inZone = lineRotation >= startRotation and lineRotation <= endRotation
		end

		if inZone then
			pressButton()
		end
	end))
end

setupSkillCheck()

-- AUTO PARRY. Your logic, connected to the Survivor tab.
local function setupAutoParry()
	local runService = game:GetService("RunService")
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local collectionService = game:GetService("CollectionService")

	-- Abysswalker Slash is not parried, it triggers the crouch instead.
	local ABYSS_SLASH_ID = "100014992013740"
	local MAX_VISUAL_RADIUS = 1024
	local RING_NAME = "BintangParryRing"

	-- Lunge animations that must be parried.
	local LUNGE_IDS = {
		["127417297154354"] = true, ["129626174716003"] = true, ["135002183282873"] = true,
		["105374834496520"] = true, ["117042998468241"] = true, ["93902163029544"] = true,
		["104540716539347"] = true, ["113255068724446"] = true, ["98163597193511"] = true,
		["125430111937587"] = true, ["84926129581106"] = true,
		["138720291317243"] = true, ["115244153053858"] = true,
	}

	-- Animations and parts that never count as a wall.
	local NON_WALL_NAMES = {
		hitbox = true, hitboxes = true, weapon = true, weaponhitbox = true, stunshove = true,
		rushvfx = true, vfxdebris = true, vfx = true, effect = true, effects = true, fx = true,
	}

	local serverCooldownEnd = 0
	local isCrouchSequenceActive = false
	local lastTriggerAt = 0
	local cachedButton = nil
	local currentKiller, killerHookConnection, hookedAnimator = nil, nil, nil
	local activeTrackerToken = 0
	local ringPart, ringGui
	local debugInfo = { attempts = 0, error = "-", reason = "-", result = "-", anim = "-", animAt = 0, distance = -1, facing = 0 }

	local oldRing = workspace:FindFirstChild(RING_NAME)
	if oldRing then
		pcall(function()
			oldRing:Destroy()
		end)
	end

	-- Listen for the cooldown the server sends after a parry.
	task.spawn(function()
		pcall(function()
			local remotes = replicatedStorage:WaitForChild("Remotes", 5)
			local items = remotes and remotes:WaitForChild("Items", 5)
			local dagger = items and items:WaitForChild("Parrying Dagger", 5)
			local result = dagger and dagger:WaitForChild("parryResult", 5)

			if result then
				table.insert(connections, result.OnClientEvent:Connect(function(success, cooldown)
					debugInfo.result = string.format("succ=%s cd=%s", tostring(success), tostring(cooldown))
					if typeof(cooldown) == "number" and cooldown > 0 then
						serverCooldownEnd = tick() + cooldown
					end
				end))
			end
		end)
	end)

	-- Silent Parry: clear the states that would block a parry.
	local function bypassAllStates()
		local character = localPlayer.Character
		if not flags["Survivor.Silent Parry"] or not character then
			return
		end

		local root = character:FindFirstChild("HumanoidRootPart")
		local check = character:FindFirstChild("CheckInterractable")

		if root then
			pcall(function()
				collectionService:RemoveTag(root, "doing action")
			end)
		end

		if check then
			for _, attribute in ipairs({ "isVaulting", "isRepairing", "isHealing", "isUnhooking" }) do
				pcall(function()
					check:SetAttribute(attribute, false)
				end)
			end
		end

		pcall(function() character:SetAttribute("Trapped", false) end)
		pcall(function() character:SetAttribute("IsCarried", false) end)
		pcall(function() character:SetAttribute("IsHooked", false) end)
		pcall(function() localPlayer:SetAttribute("IsDead", false) end)
	end

	-- The parry button, found in whichever Survivor GUI folder exists.
	local function findParryButtonLive()
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		if not playerGui then
			return nil
		end

		for _, folderName in ipairs({ "Survivor-mob", "Survivor-con", "Survivor" }) do
			local folder = playerGui:FindFirstChild(folderName)
			local controls = folder and folder:FindFirstChild("Controls")
			local button = controls and controls:FindFirstChild("Gui-mob")
			if button then
				return button
			end
		end

		return nil
	end

	local function getParryButton()
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		if cachedButton and cachedButton.Parent and playerGui and cachedButton:IsDescendantOf(playerGui) then
			return cachedButton
		end

		cachedButton = findParryButtonLive()
		return cachedButton
	end

	task.spawn(function()
		while gui.Parent do
			task.wait(1)
			local liveButton = findParryButtonLive()
			if liveButton then
				cachedButton = liveButton
			end
		end
	end)

	-- Get the controller behind a button's handler and call a method on it.
	local function findControllerInHandler(signal, matches)
		local okConnections, connectionList = pcall(getconnections, signal)
		if not okConnections or not connectionList then
			return nil
		end

		for _, connection in ipairs(connectionList) do
			if connection.Enabled ~= false then
				local ok, upvalues = pcall(getupvalues, connection.Function)
				if ok and upvalues then
					for _, upvalue in ipairs(upvalues) do
						if type(upvalue) == "table" and matches(upvalue) then
							return upvalue
						end
					end
				end
			end
		end

		return nil
	end

	local function triggerParry(reason)
		if tick() < serverCooldownEnd then
			debugInfo.error = string.format("cooldown %.1fs", serverCooldownEnd - tick())
			return false
		end

		debugInfo.attempts += 1
		debugInfo.reason = tostring(reason or "-")

		if tick() - lastTriggerAt < 0.08 then
			debugInfo.error = "debounce"
			return false
		end
		lastTriggerAt = tick()

		local button = getParryButton()
		if not button then
			debugInfo.error = "tombol parry tidak ketemu"
			return false
		end

		bypassAllStates()

		if not getconnections or not getupvalues then
			debugInfo.error = "executor tanpa getconnections/getupvalues"
			return false
		end

		local instance = findControllerInHandler(button.MouseButton1Down, function(candidate)
			local metatable = getmetatable(candidate)
			return metatable and metatable.__index and type(candidate.Parry) == "function"
		end)
		if not instance then
			debugInfo.error = "controller parry tidak ketemu"
			return false
		end

		-- CanUse covers equip, cooldown, busy and health checks.
		local okCan, canUse = pcall(instance.CanUse, instance)
		if not okCan or not canUse then
			debugInfo.error = "CanUse = false"
			return false
		end

		local ok, err = pcall(function()
			instance.Parry(instance)
		end)

		debugInfo.error = ok and "-" or ("error: " .. tostring(err))
		return ok
	end

	-- Press the crouch button the same way the game does.
	local function triggerCrouch()
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		local folder = playerGui and playerGui:FindFirstChild("Survivor-mob")
		local controls = folder and folder:FindFirstChild("Controls")
		local button = controls and controls:FindFirstChild("crouch")

		if not button or not getconnections or not getupvalues then
			return
		end

		local instance = findControllerInHandler(button.MouseButton1Click, function(candidate)
			return type(candidate._setCrouching) == "function"
		end)
		if not instance then
			return
		end

		pcall(function()
			if instance.isCtrlHeld or (instance.humanoid.Health <= 59 or (not instance:_isGrounded() or (instance:_getActiveAction() or instance.character:GetAttribute("Rooted")))) then
				-- Stand up.
				instance.isCtrlHeld = false
				instance.character:SetAttribute("Crouching", false)
				instance.changeatt:FireServer("Crouchingserver", false)
				if instance._checkConditions then instance:_checkConditions() end
				instance.humanoid:ChangeState(Enum.HumanoidStateType.Landed)
				if instance._refreshMobileButtons then instance:_refreshMobileButtons() end
			else
				-- Crouch.
				instance.isCtrlHeld = true
				instance.isShiftHeld = false
				if instance._syncSprint then instance:_syncSprint() end
				instance.character:SetAttribute("Crouching", true)
				instance.changeatt:FireServer("Crouchingserver", true)
				instance.runevent:FireServer(instance.character, false)
				if instance._checkConditions then instance:_checkConditions() end
				instance.humanoid:ChangeState(Enum.HumanoidStateType.Landed)
				if instance._refreshMobileButtons then instance:_refreshMobileButtons() end
			end
		end)
	end

	-- Killer tracking.
	local function unhookKiller()
		if killerHookConnection then
			pcall(function()
				killerHookConnection:Disconnect()
			end)
		end

		killerHookConnection, currentKiller, hookedAnimator = nil, nil, nil
		activeTrackerToken += 1
	end

	local function findLiveKiller()
		for _, player in ipairs(playersService:GetPlayers()) do
			if player ~= localPlayer then
				local character = player.Character
				if character and character.Parent and character:FindFirstChild("Lookscriptkiller", true) then
					return character
				end
			end
		end

		return nil
	end

	-- Line of sight filters.
	local function nameIsNonWall(name)
		return name ~= nil and NON_WALL_NAMES[string.lower(name)] == true
	end

	local function hasHumanoidAncestor(instance)
		local model = instance:FindFirstAncestorOfClass("Model")
		while model do
			if model:FindFirstChildOfClass("Humanoid") then
				return true
			end

			model = model:FindFirstAncestorOfClass("Model")
			if model and model.Parent == workspace then
				break
			end
		end

		return false
	end

	local function isNonWallHit(instance, killerCharacter)
		if not instance then
			return true
		end

		if killerCharacter and instance:IsDescendantOf(killerCharacter) then
			return true
		end

		for _, player in ipairs(playersService:GetPlayers()) do
			local character = player.Character
			if character and instance:IsDescendantOf(character) then
				return true
			end
		end

		if hasHumanoidAncestor(instance) or nameIsNonWall(instance.Name) then
			return true
		end

		local ancestor = instance.Parent
		while ancestor and ancestor ~= workspace do
			if nameIsNonWall(ancestor.Name) then
				return true
			end
			ancestor = ancestor.Parent
		end

		return false
	end

	local function buildRayFilter(myCharacter, killerCharacter)
		local list = {}

		for _, player in ipairs(playersService:GetPlayers()) do
			if player.Character then
				table.insert(list, player.Character)
			end
		end

		if myCharacter then
			table.insert(list, myCharacter)
		end
		if killerCharacter then
			table.insert(list, killerCharacter)
		end

		for _, name in ipairs({ "Hitboxes", "Hitbox", "VFX", "Vfx", "Effects", "FX" }) do
			local folder = workspace:FindFirstChild(name)
			if folder then
				table.insert(list, folder)
			end
		end

		return list
	end

	-- Watch the killer for 0.55 seconds and parry once the lunge can reach you.
	local function trackLungeWindow(killerCharacter, token)
		local startTime = tick()

		while tick() - startTime < 0.55 do
			if activeTrackerToken ~= token or not killerCharacter or not killerCharacter.Parent then
				return
			end

			local myCharacter = localPlayer.Character
			if not myCharacter then
				return
			end

			local killerRoot = killerCharacter:FindFirstChild("HumanoidRootPart")
			local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
			local myHumanoid = myCharacter:FindFirstChildOfClass("Humanoid")
			if not killerRoot or not myRoot or not myHumanoid then
				return
			end

			local delta = myRoot.Position - killerRoot.Position
			debugInfo.distance = delta.Magnitude

			if delta.Magnitude <= flags["Survivor.Parry Radius"] then
				local facing = killerRoot.CFrame.LookVector:Dot(delta.Unit)
				debugInfo.facing = facing

				if facing >= flags["Survivor.Facing Dot"] then
					local params = RaycastParams.new()
					params.FilterType = Enum.RaycastFilterType.Exclude
					params.FilterDescendantsInstances = buildRayFilter(myCharacter, killerCharacter)

					local wallHit = workspace:Raycast(myRoot.Position, killerRoot.Position - myRoot.Position, params)
					local isWall = wallHit and wallHit.Instance and not isNonWallHit(wallHit.Instance, killerCharacter)

					if not isWall then
						triggerParry("tracker")
						return
					end
				end
			end

			task.wait(0.02)
		end
	end

	local function handleAnim(track)
		if not flags["Survivor.Auto Parry"] then
			return
		end

		local animation = track.Animation
		if not animation then
			return
		end

		local id = string.match(animation.AnimationId or "", "%d+")
		if not id then
			return
		end

		debugInfo.anim = id
		debugInfo.animAt = tick()

		local killerCharacter = currentKiller
		if not killerCharacter or not killerCharacter.Parent then
			return
		end

		local myCharacter = localPlayer.Character
		if not myCharacter then
			return
		end

		local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
		local killerRoot = killerCharacter:FindFirstChild("HumanoidRootPart")
		if not myRoot or not killerRoot then
			return
		end

		local distance = (myRoot.Position - killerRoot.Position).Magnitude
		debugInfo.distance = distance

		-- Abysswalker Slash: crouch, then stand up after 3.05 seconds. Never parried.
		if id == ABYSS_SLASH_ID then
			if flags["Survivor.Abyss Auto Crouch"] and distance <= 30 and not isCrouchSequenceActive then
				isCrouchSequenceActive = true
				triggerCrouch()

				task.delay(3.05, function()
					triggerCrouch()
					isCrouchSequenceActive = false
				end)
			end
			return
		end

		if not LUNGE_IDS[id] then
			return
		end

		-- Already in range and facing you: parry right away.
		if distance <= flags["Survivor.Parry Radius"] then
			local delta = myRoot.Position - killerRoot.Position
			local facing = killerRoot.CFrame.LookVector:Dot(delta.Unit)
			debugInfo.facing = facing

			if facing >= flags["Survivor.Facing Dot"] then
				triggerParry("direct")
				return
			end
		end

		activeTrackerToken += 1
		local token = activeTrackerToken

		task.spawn(function()
			trackLungeWindow(killerCharacter, token)
		end)
	end

	local function tryHook(killerCharacter)
		if not killerCharacter or not killerCharacter.Parent then
			return
		end

		local humanoid = killerCharacter:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end

		local animator = humanoid:FindFirstChildOfClass("Animator")
			or killerCharacter:FindFirstChildOfClass("Animator")
			or killerCharacter:FindFirstChild("Animator", true)
		if not animator then
			return
		end

		if hookedAnimator == animator and killerHookConnection then
			return
		end

		if killerHookConnection then
			pcall(function()
				killerHookConnection:Disconnect()
			end)
		end

		hookedAnimator = animator
		killerHookConnection = animator.AnimationPlayed:Connect(function(track)
			pcall(handleAnim, track)
		end)

		for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
			task.spawn(function()
				pcall(handleAnim, track)
			end)
		end
	end

	-- Find the killer and hook its animator. Idle while Auto Parry is off.
	task.spawn(function()
		while gui.Parent do
			if not flags["Survivor.Auto Parry"] then
				if currentKiller then
					unhookKiller()
				end
				task.wait(0.2)
			else
				task.wait(0.016)

				local killerCharacter = findLiveKiller()
				if killerCharacter then
					if currentKiller ~= killerCharacter then
						unhookKiller()
						currentKiller = killerCharacter
					end

					if not killerHookConnection then
						tryHook(killerCharacter)
					end
				elseif currentKiller then
					unhookKiller()
				end
			end
		end
	end)

	-- Reset on every respawn, then re-equip the dagger so its button reconnects.
	local function resetMatchState()
		cachedButton = nil
		lastTriggerAt = 0

		if killerHookConnection then
			pcall(function()
				killerHookConnection:Disconnect()
			end)
		end

		killerHookConnection, hookedAnimator, currentKiller = nil, nil, nil
		activeTrackerToken += 1
		serverCooldownEnd = 0
		isCrouchSequenceActive = false
	end

	local function refreshGameState()
		task.spawn(function()
			task.wait(1.5)
			if not findParryButtonLive() then
				return
			end

			local character = localPlayer.Character
			if not character then
				return
			end

			local backpack = localPlayer:FindFirstChild("Backpack")
			local dagger = character:FindFirstChild("Parrying Dagger") or (backpack and backpack:FindFirstChild("Parrying Dagger"))
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not dagger or not humanoid then
				return
			end

			if dagger.Parent == character then
				humanoid:UnequipTools()
				task.wait(0.3)
			end

			humanoid:EquipTool(dagger)
			task.wait(0.3)

			local oldSpeed = humanoid.WalkSpeed
			humanoid.WalkSpeed = oldSpeed + 0.01
			task.wait(0.1)
			humanoid.WalkSpeed = oldSpeed
		end)
	end

	table.insert(connections, localPlayer.CharacterAdded:Connect(function()
		resetMatchState()
		refreshGameState()
	end))

	table.insert(connections, localPlayer.CharacterRemoving:Connect(function()
		cachedButton = nil
	end))

	-- Visual ring on the floor showing the parry radius.
	local function ensureRing()
		if ringPart and ringPart.Parent then
			return
		end

		ringPart = create("Part", {
			Name = RING_NAME,
			Anchored = true,
			CanCollide = false,
			CanQuery = false,
			CanTouch = false,
			CastShadow = false,
			Material = Enum.Material.SmoothPlastic,
			Transparency = 1,
			Size = Vector3.new(2, 0.05, 2),
		}, workspace)

		ringGui = create("SurfaceGui", {
			Name = "RingUI",
			Face = Enum.NormalId.Top,
			AlwaysOnTop = true,
			LightInfluence = 0,
			SizingMode = Enum.SurfaceGuiSizingMode.FixedSize,
			CanvasSize = Vector2.new(1024, 1024),
		}, ringPart)

		local ringFrame = create("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, ringGui)
		round(ringFrame, 1024)

		create("UIStroke", {
			Color = Color3.new(1, 1, 1),
			Thickness = 3,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}, ringFrame)
	end

	table.insert(connections, runService.RenderStepped:Connect(function()
		if not flags["Survivor.Visual Radius"] then
			if ringGui then
				ringGui.Enabled = false
			end
			return
		end

		ensureRing()

		local character = localPlayer.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not root then
			ringGui.Enabled = false
			return
		end

		ringGui.Enabled = true

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { character, ringPart }

		local position = root.Position
		local hit = workspace:Raycast(position, Vector3.new(0, -50, 0), params)
		local groundY = (hit and hit.Position.Y or (position.Y - 3)) - 0.1
		local radius = math.max(math.min(flags["Survivor.Parry Radius"], MAX_VISUAL_RADIUS), 0.5)

		ringPart.Size = Vector3.new(radius * 2, 0.05, radius * 2)
		ringPart.CFrame = CFrame.new(position.X, groundY, position.Z)
	end))

	-- Live status, switched on by the Parry Debug toggle.
	local debugLabel = create("TextLabel", {
		Position = UDim2.fromOffset(56, 124),
		Size = UDim2.fromOffset(240, 124),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.35,
		Font = Enum.Font.Code,
		TextSize = 11,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Visible = false,
	}, gui)
	round(debugLabel, 4)
	create("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingTop = UDim.new(0, 4) }, debugLabel)

	Hub.on("Survivor.Parry Debug", function(enabled)
		debugLabel.Visible = enabled
	end)

	-- Run the respawn refresh by hand, useful when the hub is loaded mid-match.
	Hub.on("Survivor.Refresh Parry", function()
		resetMatchState()
		refreshGameState()
	end)

	task.spawn(function()
		while gui.Parent do
			task.wait(0.2)

			if debugLabel.Visible then
				local age = debugInfo.animAt > 0 and string.format("%.1fs", tick() - debugInfo.animAt) or "-"

				debugLabel.Text = table.concat({
					"killer: " .. (currentKiller and currentKiller.Name or "tidak ada"),
					"hook animator: " .. tostring(killerHookConnection ~= nil),
					"anim: " .. debugInfo.anim .. " (" .. age .. ")",
					string.format("jarak: %.1f  dot: %.2f", debugInfo.distance, debugInfo.facing),
					"tombol parry: " .. tostring(cachedButton ~= nil),
					"percobaan: " .. debugInfo.attempts .. " (" .. debugInfo.reason .. ")",
					"hasil server: " .. debugInfo.result,
					"error: " .. debugInfo.error,
				}, "\n")
			end
		end
	end)

	-- Clean up the ring and killer hook when the hub closes.
	local baseDestroy = Hub.destroy

	function Hub.destroy()
		unhookKiller()
		if ringPart then
			pcall(function()
				ringPart:Destroy()
			end)
		end

		baseDestroy()
	end
end

setupAutoParry()

-- SILENT AIM (FLASH). Your logic, connected to the Flash Aim card.
local function setupFlashAim()
	local runService = game:GetService("RunService")

	local isAimingFlash = false
	local currentTouchInput = nil

	local function isKiller(player)
		return player and player.Team and player.Team.Name == "Killer"
	end

	local function isDowned(character)
		if not character then
			return false
		end

		return character:GetAttribute("Knocked") == true or character:GetAttribute("IsHooked") == true
	end

	-- The closest killer that is alive and not downed.
	local function getKillerTarget()
		local myCharacter = localPlayer.Character
		local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
		if not myRoot then
			return nil
		end

		local best, closest = nil, math.huge

		for _, player in ipairs(playersService:GetPlayers()) do
			if player ~= localPlayer and isKiller(player) and player.Character then
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
				local root = player.Character:FindFirstChild("HumanoidRootPart")

				if humanoid and humanoid.Health > 0 and root and not isDowned(player.Character) then
					local distance = (root.Position - myRoot.Position).Magnitude
					if distance < closest then
						closest, best = distance, root
					end
				end
			end
		end

		return best
	end

	-- Hold right click (PC) or hold the item button (mobile) to aim.
	table.insert(connections, userInputService.InputBegan:Connect(function(input, gameProcessed)
		local isTouch = input.UserInputType == Enum.UserInputType.Touch
		if gameProcessed and not isTouch then
			return
		end

		if not flags["Survivor.Silent Aim (Flash)"] then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			isAimingFlash = true
		elseif isTouch then
			local playerGui = localPlayer:FindFirstChild("PlayerGui")
			local mobile = playerGui and playerGui:FindFirstChild("Survivor-mob")
			local controls = mobile and mobile:FindFirstChild("Controls")
			local button = controls and controls:FindFirstChild("Gui-mob")

			if button and button.Visible then
				local position = input.Position
				local buttonPosition, buttonSize = button.AbsolutePosition, button.AbsoluteSize

				local insideX = position.X >= buttonPosition.X and position.X <= buttonPosition.X + buttonSize.X
				local insideY = position.Y >= buttonPosition.Y and position.Y <= buttonPosition.Y + buttonSize.Y

				if insideX and insideY then
					isAimingFlash = true
					currentTouchInput = input
				end
			end
		end
	end))

	table.insert(connections, userInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			isAimingFlash = false
		end

		if input.UserInputType == Enum.UserInputType.Touch and input == currentTouchInput then
			isAimingFlash = false
			currentTouchInput = nil
		end
	end))

	-- While aiming, turn the camera and your body toward the killer.
	table.insert(connections, runService.RenderStepped:Connect(function()
		if not isAimingFlash or not flags["Survivor.Silent Aim (Flash)"] then
			return
		end

		local target = getKillerTarget()
		if not target then
			return
		end

		local camera = workspace.CurrentCamera
		local myCharacter = localPlayer.Character
		local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
		local targetPosition = target.Position + Vector3.new(0, flags["Survivor.Flash Head Offset (Y)"], 0)

		camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, targetPosition), 0.5)

		if myRoot then
			local facing = CFrame.lookAt(myRoot.Position, Vector3.new(targetPosition.X, myRoot.Position.Y, targetPosition.Z))
			myRoot.CFrame = myRoot.CFrame:Lerp(facing, 0.5)
		end
	end))
end

setupFlashAim()

-- SILENT VEIL (spear auto-aim). Your logic, always active while the toggle is on.
local veilLockState = { target = nil }

local function setupVeilAim()
	local runService = game:GetService("RunService")
	local replicatedStorage = game:GetService("ReplicatedStorage")

	local CONFIG = {
		GRAVITY = 98.1,
		SPEAR_SPEED = 165,
		SPAWN_OFFSET = 3,
		MAX_LIFE = 4,
		AIM_POINT = "HumanoidRootPart",
		AIM_Y_OFFSET = 0,
		MAX_TARGET_DIST_BROAD = 2000,
		PASSIVE_CD = 45,
		COLOR_LOCK = Color3.fromRGB(0, 255, 80),
		COLOR_NO_TARGET = Color3.fromRGB(255, 255, 255),
	}
	local BIND_NAME = "BintangVeilAimSnap"

	local lockedTarget = nil
	local cdEndTime = 0
	local scanAccum = 0
	local hookedMetatable, originalNamecall

	-- Aiming only runs for the killer side, since it never needs a button.
	local function aimActive()
		local team = localPlayer.Team
		return flags["Killer.Aim Lock (Kamera)"] and team ~= nil and team.Name == "Killer"
	end

	-- Ballistic core: position = p0 + v0 * t + g * 0.5 * t^2.
	local function ballisticCheck(actualOrigin, targetPos, speed)
		local g = CONFIG.GRAVITY
		local delta = targetPos - actualOrigin
		local horizontal = Vector3.new(delta.X, 0, delta.Z)
		local d = horizontal.Magnitude
		local y = delta.Y

		-- Almost straight above or below: only the vertical time matters.
		if d < 0.1 then
			local t = math.abs(y) / speed
			return t <= CONFIG.MAX_LIFE, t, 0
		end

		local v2 = speed * speed
		local v4 = v2 * v2
		local disc = v4 - g * (g * d * d + 2 * y * v2)

		-- No parabola reaches the target: out of range.
		if disc < 0 then
			return false, nil, nil
		end

		-- Low arc, the flatter shot.
		local tanTheta = (v2 - math.sqrt(disc)) / (g * d)
		local theta = math.atan(tanTheta)
		local cosTheta = math.cos(theta)
		if cosTheta <= 0.001 then
			return false, nil, nil
		end

		local t = d / (speed * cosTheta)
		if t < 0 or t > CONFIG.MAX_LIFE then
			return false, nil, nil
		end

		return true, t, theta
	end

	local function computeAimDirection(origin, targetPos, speed)
		local g = CONFIG.GRAVITY
		local dir = (targetPos - origin).Unit

		for _ = 1, 3 do
			local actualOrigin = origin + dir * CONFIG.SPAWN_OFFSET
			local delta = targetPos - actualOrigin
			local horizontal = Vector3.new(delta.X, 0, delta.Z)
			local d = horizontal.Magnitude
			local y = delta.Y

			if d < 0.1 then
				return (targetPos - origin).Unit, true, 0.1
			end

			local v2 = speed * speed
			local v4 = v2 * v2
			local disc = v4 - g * (g * d * d + 2 * y * v2)

			if disc < 0 then
				return (targetPos - origin).Unit, false, nil
			end

			local tanTheta = (v2 - math.sqrt(disc)) / (g * d)
			local theta = math.atan(tanTheta)
			dir = (horizontal.Unit * math.cos(theta)) + Vector3.new(0, math.sin(theta), 0)
		end

		local finalOrigin = origin + dir * CONFIG.SPAWN_OFFSET
		local reachable, t = ballisticCheck(finalOrigin, targetPos, speed)
		return dir, reachable, t
	end

	local function isReachable(origin, targetPos)
		local finalDir = (targetPos - origin).Unit
		local actualOrigin = origin + finalDir * CONFIG.SPAWN_OFFSET
		local ok, t = ballisticCheck(actualOrigin, targetPos, CONFIG.SPEAR_SPEED)

		if not ok then
			local _, reachable, flightTime = computeAimDirection(origin, targetPos, CONFIG.SPEAR_SPEED)
			return reachable, flightTime
		end

		return ok, t
	end

	-- FOV circle, lock label and cooldown label.
	local fovCircle = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(300, 300),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = false,
	}, gui)
	round(fovCircle, 1000)
	create("UIStroke", { Color = CONFIG.COLOR_NO_TARGET, Thickness = 1, Transparency = 0.5 }, fovCircle)

	local lockLabel = create("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		TextColor3 = CONFIG.COLOR_LOCK,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextStrokeColor3 = Color3.new(0, 0, 0),
		TextStrokeTransparency = 0.5,
		Visible = false,
	}, gui)

	local laserLine = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = CONFIG.COLOR_LOCK,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(0, 2),
		Visible = false,
		ZIndex = 5,
	}, gui)

	local cdLabel = create("TextLabel", {
		Size = UDim2.fromOffset(250, 34),
		Position = UDim2.new(0.5, -125, 0, 20),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		TextColor3 = Color3.fromRGB(255, 200, 60),
		Font = Enum.Font.GothamBold,
		TextSize = 15,
		Visible = false,
	}, gui)
	round(cdLabel, 8)

	local function getFovRadius()
		local camera = workspace.CurrentCamera
		local viewport = camera.ViewportSize
		local cameraFov = math.rad(camera.FieldOfView)
		local cappedFov = math.min(flags["Killer.FOV (derajat)"], 359)
		local half = math.rad(cappedFov * 0.5)
		local radius = (viewport.Y / 2) * (math.tan(half) / math.tan(cameraFov / 2))
		return math.min(radius, viewport.Y * 0.95)
	end

	-- The drawn circle follows Silent's FOV (the card it now lives under), not Aim Lock's.
	local function getVisualFovRadius()
		local camera = workspace.CurrentCamera
		local viewport = camera.ViewportSize
		local cameraFov = math.rad(camera.FieldOfView)
		local cappedFov = math.clamp(flags["Killer.Silent FOV (derajat)"] or 145, 20, 170)
		local half = math.rad(cappedFov * 0.5)
		local radius = (viewport.Y / 2) * (math.tan(half) / math.tan(cameraFov / 2))
		return math.min(radius, viewport.Y * 0.95)
	end

	local function isKillerTeam()
		local team = localPlayer.Team
		return team ~= nil and team.Name == "Killer"
	end

	local function updateFovCircle()
		fovCircle.Visible = isKillerTeam() and flags["Killer.Show FOV"] == true
		if fovCircle.Visible then
			local radius = getVisualFovRadius()
			fovCircle.Size = UDim2.fromOffset(radius * 2, radius * 2)
		end
	end

	-- Targets are players on the other team who are alive and not downed.
	local function isEnemy(player)
		if player == localPlayer then
			return false
		end

		local mine, theirs = localPlayer.Team, player.Team
		if not mine or not theirs then
			return false
		end

		return mine ~= theirs
	end

	local function isValidTarget(character, humanoid)
		if not humanoid or humanoid.Health <= 20 then
			return false
		end

		if character:GetAttribute("Knocked") == true or character:GetAttribute("IsKnocked") == true then
			return false
		end

		if character:GetAttribute("IsHooked") == true then
			return false
		end

		local hookPhase = character:GetAttribute("HookPhase") or character:GetAttribute("HookedPhase")
		if hookPhase and hookPhase > 0 then
			return false
		end

		return true
	end

	local function updateTarget(deltaTime)
		if not aimActive() then
			lockedTarget = nil
			lockLabel.Visible = false
			return
		end

		local camera = workspace.CurrentCamera

		-- Sticky lock: keep the same target while it stays valid and reachable.
		if lockedTarget then
			local character = lockedTarget.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local root = character and character:FindFirstChild(CONFIG.AIM_POINT)

			if not (character and character.Parent and humanoid and root and isValidTarget(character, humanoid)) then
				lockedTarget = nil
			else
				local myPosition = camera.CFrame.Position
				local livePosition = root.Position + Vector3.new(0, CONFIG.AIM_Y_OFFSET, 0)

				if not isReachable(myPosition, livePosition) then
					lockedTarget = nil
				elseif (root.Position - myPosition).Magnitude > CONFIG.MAX_TARGET_DIST_BROAD then
					lockedTarget = nil
				else
					return
				end
			end
		end

		scanAccum += deltaTime
		if scanAccum < 0.05 then
			return
		end
		scanAccum = 0

		local viewport = camera.ViewportSize
		local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
		local radius = getFovRadius()
		local cameraPosition = camera.CFrame.Position
		local best, bestDistance = nil, math.huge

		for _, player in ipairs(playersService:GetPlayers()) do
			if isEnemy(player) then
				local character = player.Character
				local root = character and character:FindFirstChild(CONFIG.AIM_POINT)
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")

				if root and humanoid and isValidTarget(character, humanoid) then
					local livePosition = root.Position + Vector3.new(0, CONFIG.AIM_Y_OFFSET, 0)

					if isReachable(cameraPosition, livePosition) and (root.Position - cameraPosition).Magnitude <= CONFIG.MAX_TARGET_DIST_BROAD then
						local screenPoint, onScreen = camera:WorldToViewportPoint(root.Position)
						if onScreen then
							local screenDistance = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude
							if screenDistance <= radius and screenDistance < bestDistance then
								best, bestDistance = player, screenDistance
							end
						end
					end
				end
			end
		end

		lockedTarget = best
		if flags["Killer.Aim Lock (Kamera)"] then
			veilLockState.target = best
		end
	end

	-- Camera snap using the live target position and the ballistic arc.
	local function onRenderStep()
		if not (aimActive() and lockedTarget) then
			return
		end

		local character = lockedTarget.Character
		if not character or not character.Parent then
			return
		end

		local targetPart = character:FindFirstChild(CONFIG.AIM_POINT)
		if not targetPart then
			return
		end

		local camera = workspace.CurrentCamera
		local liveTargetPosition = targetPart.Position + Vector3.new(0, CONFIG.AIM_Y_OFFSET, 0)
		local origin = camera.CFrame.Position
		local aimDirection, reachable, flightTime = computeAimDirection(origin, liveTargetPosition, CONFIG.SPEAR_SPEED)

		-- Out of range: skip, do not snap, and look for another target.
		if not reachable then
			lockLabel.Visible = false
			lockedTarget = nil
			return
		end

		camera.CFrame = CFrame.lookAt(origin, origin + aimDirection)

		local screenPoint, onScreen = camera:WorldToViewportPoint(liveTargetPosition)
		if onScreen then
			lockLabel.Visible = true
			lockLabel.Position = UDim2.fromOffset(screenPoint.X, screenPoint.Y - 20)
			lockLabel.Text = string.format("LOCK\n%.0f studs | t=%.2fs", (liveTargetPosition - origin).Magnitude, flightTime or 0)
			lockLabel.TextColor3 = CONFIG.COLOR_LOCK
		else
			lockLabel.Visible = false
		end
	end

	-- Laser from the screen center to whichever target is currently locked.
	local function updateLaser()
		local target = flags["Killer.Show Laser"] and veilLockState.target

		local character = target and target.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if not root or not root.Parent then
			laserLine.Visible = false
			return
		end

		local camera = workspace.CurrentCamera
		local screenPoint, onScreen = camera:WorldToViewportPoint(root.Position)
		if not onScreen then
			laserLine.Visible = false
			return
		end

		local viewport = camera.ViewportSize
		local from = Vector2.new(viewport.X / 2, viewport.Y)
		local to = Vector2.new(screenPoint.X, screenPoint.Y)
		local delta = to - from

		laserLine.Position = UDim2.fromOffset(from.X, from.Y)
		laserLine.Size = UDim2.fromOffset(delta.Magnitude, 2)
		laserLine.Rotation = math.deg(math.atan2(delta.Y, delta.X))
		laserLine.Visible = true
	end

	-- Aura cooldown label.
	local function updateCdLabel()
		local remaining = cdEndTime - tick()

		if flags["Killer.Aura CD Tracker"] and remaining > 0.05 then
			cdLabel.Visible = true
			cdLabel.Text = string.format("Aura CD: %.1fs", remaining)
		else
			cdLabel.Visible = false
		end
	end

	-- Payload logger: shows what the game sends when the spear is thrown.
	local function describe(value, depth)
		depth = depth or 0
		local kind = typeof(value)

		if kind == "table" then
			if depth >= 3 then
				return "{...}"
			end

			local parts = {}
			for key, inner in pairs(value) do
				table.insert(parts, tostring(key) .. "=" .. describe(inner, depth + 1))
			end
			table.sort(parts)
			return "{" .. table.concat(parts, ", ") .. "}"
		elseif kind == "string" then
			return '"' .. value .. '"'
		elseif kind == "Instance" then
			return "<" .. value.ClassName .. ":" .. value.Name .. ">"
		elseif kind == "number" or kind == "boolean" or kind == "nil" then
			return tostring(value)
		end

		return kind .. "(" .. tostring(value) .. ")"
	end

	local logLabel = create("TextLabel", {
		Position = UDim2.new(1, -316, 0, 60),
		Size = UDim2.fromOffset(300, 170),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.35,
		Font = Enum.Font.Code,
		TextSize = 11,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Text = "Lempar tombak untuk melihat isi data.",
		Visible = false,
	}, gui)
	round(logLabel, 4)
	create("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingTop = UDim.new(0, 4), PaddingRight = UDim.new(0, 6) }, logLabel)

	Hub.on("Killer.Log Spear Payload", function(enabled)
		logLabel.Visible = enabled
	end)

	local logSections = { Spearthrow = "-", SpearState = "-" }

	local function logPayload(source, packed)
		local lines = {}
		for index = 1, packed.n do
			table.insert(lines, index .. ": " .. describe(packed[index]))
		end

		logSections[source] = table.concat(lines, "\n")

		local text = "Spearthrow\n" .. logSections.Spearthrow .. "\n\nSpearState\n" .. logSections.SpearState
		logLabel.Text = text:sub(1, 900)
		warn("[Veil] " .. text)

		local clip = setclipboard or toclipboard
		if clip then
			pcall(clip, text)
		end
	end

	-- Cooldown tracking from the spear remotes.
	task.spawn(function()
		local remotes = replicatedStorage:WaitForChild("Remotes", 10)
		local killers = remotes and remotes:WaitForChild("Killers", 5)
		local veil = killers and killers:WaitForChild("Veil", 5)
		local stateRemote = veil and veil:WaitForChild("SpearState", 5)
		local throwRemote = veil and veil:WaitForChild("Spearthrow", 5)

		if stateRemote then
			table.insert(connections, stateRemote.OnClientEvent:Connect(function(kind, data)
				if flags["Killer.Log Spear Payload"] then
					logPayload("SpearState", table.pack(kind, data))
				end

				if (kind == "launch" or kind == "cooldown") and type(data) == "table" then
					local ready = data.SpecialReadyAt
					if type(ready) == "number" and ready > 0 then
						local remaining = ready - workspace:GetServerTimeNow()
						if remaining > 0 then
							cdEndTime = tick() + remaining
						end
					end
				end
			end))
		end

		-- A long charge (2 seconds or more) starts the passive cooldown.
		if throwRemote and type(hookmetamethod) == "function" then
			pcall(function()
				local metatable = getrawmetatable(game)
				local original = metatable.__namecall
				hookedMetatable, originalNamecall = metatable, original

				setreadonly(metatable, false)
				metatable.__namecall = newcclosure(function(self, ...)
					if getnamecallmethod() == "FireServer" and self == throwRemote then
						local packed = table.pack(...)
						local payload = packed[1]

						if flags["Killer.Log Spear Payload"] then
							task.defer(logPayload, "Spearthrow", packed)
						end

						if type(payload) == "table" then
							local throwTime, releasedAt = payload.Time, payload.ReleasedAt
							if type(throwTime) == "number" and type(releasedAt) == "number" and (throwTime - releasedAt) >= 2.0 then
								cdEndTime = tick() + CONFIG.PASSIVE_CD
							end
						end
					end

					return original(self, ...)
				end)
				setreadonly(metatable, true)
			end)
		end
	end)

	runService:BindToRenderStep(BIND_NAME, Enum.RenderPriority.Camera.Value + 10, onRenderStep)

	table.insert(connections, runService.RenderStepped:Connect(function(deltaTime)
		updateFovCircle()
		updateTarget(deltaTime)
		updateCdLabel()
		updateLaser()
	end))

	-- Remove the render step and the hook when the hub closes.
	local baseDestroy = Hub.destroy

	function Hub.destroy()
		pcall(function()
			runService:UnbindFromRenderStep(BIND_NAME)
		end)

		if hookedMetatable and originalNamecall then
			pcall(function()
				setreadonly(hookedMetatable, false)
				hookedMetatable.__namecall = originalNamecall
				setreadonly(hookedMetatable, true)
			end)
		end

		baseDestroy()
	end
end

setupVeilAim()

-- SILENT VEIL. Your logic: the direction sent to the server is replaced, the camera is never touched.
local function setupSilentVeil()
	local runService = game:GetService("RunService")
	local replicatedStorage = game:GetService("ReplicatedStorage")

	local SPEAR_SPEED = 165
	local SPAWN_OFFSET = 3
	local MAX_LIFE = 4
	local AIM_Y_OFFSET = 0.6

	local silentLockedTarget = nil
	local lastAimDir, lastOrigin = nil, nil
	local lastVelocity = Vector3.zero
	local silentAccum = 0
	local silentHookedMetatable, silentOriginalNamecall, spearRemote

	local function ballisticCheck(origin, targetPos, speed)
		local g = CONFIG_GRAVITY
		local delta = targetPos - origin
		local horizontal = Vector3.new(delta.X, 0, delta.Z)
		local d = horizontal.Magnitude
		local y = delta.Y

		if d < 0.1 then
			local t = math.abs(y) / speed
			return t <= MAX_LIFE, t
		end

		local v2 = speed * speed
		local disc = v2 * v2 - g * (g * d * d + 2 * y * v2)
		if disc < 0 then
			return false, nil
		end

		local tanTheta = (v2 - math.sqrt(disc)) / (g * d)
		local theta = math.atan(tanTheta)
		local cosTheta = math.cos(theta)
		if cosTheta <= 0.001 then
			return false, nil
		end

		local t = d / (speed * cosTheta)
		if t < 0 or t > MAX_LIFE then
			return false, nil
		end

		return true, t
	end

	local function computeAim(origin, targetPos)
		local dir = (targetPos - origin).Unit

		for _ = 1, 3 do
			local actual = origin + dir * SPAWN_OFFSET
			local delta = targetPos - actual
			local horizontal = Vector3.new(delta.X, 0, delta.Z)
			local d = horizontal.Magnitude
			local y = delta.Y

			if d < 0.1 then
				return (targetPos - origin).Unit, true, 0.1
			end

			local v2 = SPEAR_SPEED * SPEAR_SPEED
			local disc = v2 * v2 - CONFIG_GRAVITY * (CONFIG_GRAVITY * d * d + 2 * y * v2)
			if disc < 0 then
				return (targetPos - origin).Unit, false, nil
			end

			local tanTheta = (v2 - math.sqrt(disc)) / (CONFIG_GRAVITY * d)
			local theta = math.atan(tanTheta)
			dir = (horizontal.Unit * math.cos(theta)) + Vector3.new(0, math.sin(theta), 0)
		end

		local ok, t = ballisticCheck(origin + dir * SPAWN_OFFSET, targetPos, SPEAR_SPEED)
		return dir, ok, t
	end

	-- Lead the target using its current velocity.
	local function predict(part, flightTime)
		if not part then
			return nil
		end

		local velocity = part.AssemblyLinearVelocity or Vector3.zero
		lastVelocity = lastVelocity:Lerp(velocity, 0.4)

		local lead = Vector3.new(lastVelocity.X, lastVelocity.Y * 0.25, lastVelocity.Z) * (flightTime or 0.55) * flags["Killer.Prediction"]
		return part.Position + lead + Vector3.new(0, AIM_Y_OFFSET, 0)
	end

	local function getSilentFovRadius()
		local camera = workspace.CurrentCamera
		local viewport = camera.ViewportSize
		local cameraFov = math.rad(camera.FieldOfView)
		local aimFov = math.rad(math.clamp(flags["Killer.Silent FOV (derajat)"], 20, 170))
		local radius = (viewport.Y * 0.5) * (math.tan(aimFov * 0.5) / math.tan(cameraFov * 0.5))
		return math.clamp(radius, 20, viewport.Y * 0.95)
	end

	local function isEnemy(player)
		if player == localPlayer then
			return false
		end

		local mine, theirs = localPlayer.Team, player.Team
		if mine and theirs then
			return mine ~= theirs
		end
		return true
	end

	local function isValidTarget(character, humanoid)
		if not humanoid or humanoid.Health <= 20 then
			return false
		end
		if character:GetAttribute("Knocked") or character:GetAttribute("IsKnocked") then
			return false
		end
		if character:GetAttribute("IsHooked") then
			return false
		end

		local hookPhase = character:GetAttribute("HookPhase") or character:GetAttribute("HookedPhase")
		return not (hookPhase and hookPhase > 0)
	end

	local function updateSilentTarget(deltaTime)
		if not flags["Killer.Silent Veil"] then
			silentLockedTarget, lastAimDir, lastVelocity = nil, nil, Vector3.zero
			veilLockState.target = nil
			VeilShared.silentTarget = nil
			return
		end

		local camera = workspace.CurrentCamera
		local radius = getSilentFovRadius()
		local center = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y * 0.5)
		local origin = camera.CFrame.Position
		local maxRange = flags["Killer.Silent Max Range"]

		-- Sticky lock: keep the target while it stays in range and on screen.
		if silentLockedTarget then
			local character = silentLockedTarget.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local root = character and character:FindFirstChild("HumanoidRootPart")

			if not (character and character.Parent and humanoid and root and isValidTarget(character, humanoid)) then
				silentLockedTarget, lastAimDir, lastVelocity = nil, nil, Vector3.zero
				veilLockState.target = nil
				VeilShared.silentTarget = nil
			else
				local distance = (root.Position - origin).Magnitude
				if distance > maxRange then
					silentLockedTarget, lastAimDir, lastVelocity = nil, nil, Vector3.zero
					veilLockState.target = nil
					VeilShared.silentTarget = nil
				else
					local screenPoint, onScreen = camera:WorldToViewportPoint(root.Position)
					local inside = onScreen and (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude <= radius

					if inside then
						local predicted = predict(root, distance / SPEAR_SPEED)
						local dir, ok, t = computeAim(origin, predicted)
						if ok then
							lastAimDir, lastOrigin = dir, origin
							return
						end
					end

					silentLockedTarget, lastAimDir = nil, nil
					VeilShared.silentTarget = nil
				end
			end
		end

		silentAccum += deltaTime
		if silentAccum < 0.03 then
			return
		end
		silentAccum = 0

		local best, bestScreenDistance = nil, math.huge

		for _, player in ipairs(playersService:GetPlayers()) do
			if isEnemy(player) then
				local character = player.Character
				local root = character and character:FindFirstChild("HumanoidRootPart")
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")

				if root and humanoid and isValidTarget(character, humanoid) then
					local distance = (root.Position - origin).Magnitude

					if distance <= maxRange then
						local screenPoint, onScreen = camera:WorldToViewportPoint(root.Position)
						if onScreen then
							local screenDistance = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude
							if screenDistance <= radius and screenDistance < bestScreenDistance then
								local predicted = predict(root, distance / SPEAR_SPEED)
								local _, ok = computeAim(origin, predicted)
								if ok then
									best, bestScreenDistance = player, screenDistance
								end
							end
						end
					end
				end
			end
		end

		silentLockedTarget = best
		if flags["Killer.Silent Veil"] then
			veilLockState.target = best
		end
		if best then
			local root = best.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local distance = (root.Position - origin).Magnitude
				local predicted = predict(root, distance / SPEAR_SPEED)
				local dir, ok, t = computeAim(origin, predicted)
				if ok then
					lastAimDir, lastOrigin = dir, origin
				end
			end
		else
			lastAimDir, lastVelocity = nil, Vector3.zero
		end
	end

	-- Replace the throw direction with the computed one. The camera is never touched.
	local function setupSilentHook()
		pcall(function()
			spearRemote = replicatedStorage.Remotes.Killers.Veil.Spearthrow
		end)

		if not spearRemote then
			for _, candidate in ipairs(replicatedStorage:GetDescendants()) do
				if candidate:IsA("RemoteEvent") then
					local lowered = candidate.Name:lower()
					if lowered:find("spear", 1, true) or lowered:find("throw", 1, true) then
						spearRemote = candidate
						break
					end
				end
			end
		end

		if not spearRemote or type(hookmetamethod) ~= "function" then
			warn("[BintangX6LoccHub] Silent Veil: remote atau hookmetamethod tidak ada")
			return
		end

		local metatable = getrawmetatable(game)
		local original = metatable.__namecall
		silentHookedMetatable, silentOriginalNamecall = metatable, original

		setreadonly(metatable, false)
		metatable.__namecall = newcclosure(function(self, ...)
			if getnamecallmethod() == "FireServer" and self == spearRemote and flags["Killer.Silent Veil"] and lastAimDir and silentLockedTarget then
				local args = table.pack(...)
				local payload = args[1]
				local newPayload = {}

				if type(payload) == "table" then
					for key, value in pairs(payload) do
						newPayload[key] = value
					end
				end

				newPayload.Direction = lastAimDir
				newPayload.LookVector = lastAimDir
				newPayload.Velocity = lastAimDir * SPEAR_SPEED
				newPayload.Origin = lastOrigin or workspace.CurrentCamera.CFrame.Position
				newPayload.Position = lastOrigin or workspace.CurrentCamera.CFrame.Position

				if newPayload.Pierce ~= nil then
					newPayload.Pierce = true
				end
				if newPayload.ThroughVeil ~= nil then
					newPayload.ThroughVeil = true
				end
				if newPayload.IgnoreCollision ~= nil then
					newPayload.IgnoreCollision = true
				end

				args[1] = newPayload
				return original(self, table.unpack(args, 1, args.n))
			end

			return original(self, ...)
		end)
		setreadonly(metatable, true)
	end

	CONFIG_GRAVITY = 98.1
	task.spawn(setupSilentHook)

	table.insert(connections, runService.RenderStepped:Connect(function(deltaTime)
		pcall(updateSilentTarget, deltaTime)
	end))

	local baseDestroy = Hub.destroy

	function Hub.destroy()
		if silentHookedMetatable and silentOriginalNamecall then
			pcall(function()
				setreadonly(silentHookedMetatable, false)
				silentHookedMetatable.__namecall = silentOriginalNamecall
				setreadonly(silentHookedMetatable, true)
			end)
		end

		baseDestroy()
	end
end

setupSilentVeil()

-- YOUR OWN FEATURES: add Hub.on("Tab.Row text", function(value) ... end) calls here.

-- WRITE YOUR FEATURES ABOVE THIS LINE. Do not edit anything below.
-- VIDEO DATA (background video, base64).
Assets.video = "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"
task.spawn(loadVideo)
